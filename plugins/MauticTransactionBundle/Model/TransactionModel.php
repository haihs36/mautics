<?php

namespace MauticPlugin\MauticTransactionBundle\Model;

use Doctrine\DBAL\Query\Expression\ExpressionBuilder;
use Mautic\CoreBundle\Form\RequestTrait;
use Mautic\CoreBundle\Helper\DateTimeHelper;
use Mautic\CoreBundle\Helper\InputHelper;
use Mautic\CoreBundle\Model\AjaxLookupModelInterface;
use Mautic\CoreBundle\Model\FormModel as CommonFormModel;
use Mautic\EmailBundle\Helper\EmailValidator;
use Mautic\LeadBundle\Deduplicate\CompanyDeduper;
use Mautic\LeadBundle\Entity\Company;
use Mautic\LeadBundle\Entity\LeadField;
use Mautic\LeadBundle\Exception\UniqueFieldNotFoundException;
use Mautic\LeadBundle\Model\DefaultValueTrait;
use Mautic\LeadBundle\Model\FieldModel;
use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
use MauticPlugin\MauticTransactionBundle\Entity\TransactionRepository;
use MauticPlugin\MauticTransactionBundle\Event\TransactionEvent;
use MauticPlugin\MauticTransactionBundle\Form\Type\TransactionType;
use Symfony\Component\EventDispatcher\Event;
use Symfony\Component\HttpFoundation\Session\Session;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;

/**
 * Class CompanyModel.
 */
class TransactionModel extends CommonFormModel implements AjaxLookupModelInterface
{
    use DefaultValueTrait;
    use RequestTrait;

    /**
     * @var Session
     */
    protected $session;

    /**
     * @var FieldModel
     */
    protected $leadFieldModel;

    /**
     * @var array
     */
    protected $companyFields;

    /**
     * @var EmailValidator
     */
    protected $emailValidator;

    /**
     * @var array
     */
    private $fields = [];

    /**
     * @var bool
     */
    private $repoSetup = false;

    /**
     * @var CompanyDeduper
     */
    private $companyDeduper;

    /**
     * CompanyModel constructor.
     */
    public function __construct(FieldModel $leadFieldModel, Session $session, EmailValidator $validator, CompanyDeduper $companyDeduper)
    {
        $this->leadFieldModel = $leadFieldModel;
        $this->session        = $session;
        $this->emailValidator = $validator;
        $this->companyDeduper = $companyDeduper;
    }

    /**
     * @param Company $entity
     * @param bool    $unlock
     */
    public function saveEntity($entity, $unlock = true)
    {
        // Update leads primary company name
        $this->setEntityDefaultValues($entity, 'transaction');

        parent::saveEntity($entity, $unlock);
    }

    /**
     * Save an array of entities.
     *
     * @param array $entities
     * @param bool  $unlock
     *
     * @return array
     */
    public function saveEntities($entities, $unlock = true)
    {
        // Update leads primary company name
        foreach ($entities as $entity) {
            $this->setEntityDefaultValues($entity, 'transaction');
        }
        parent::saveEntities($entities, $unlock);
    }

    /**
     * {@inheritdoc}
     *
     * @return TransactionRepository
     */
    public function getRepository()
    {
        $repo =  $this->em->getRepository('MauticTransactionBundle:Transaction');
        if (!$this->repoSetup) {
            $this->repoSetup = true;
            $repo->setDispatcher($this->dispatcher);
            //set the point trigger model in order to get the color code for the lead
            $fields = $this->leadFieldModel->getFieldList(true, true, ['isPublished' => true, 'object' => 'transaction']);

            $searchFields = [];
            foreach ($fields as $groupFields) {
                $searchFields = array_merge($searchFields, array_keys($groupFields));
            }
            $repo->setAvailableSearchFields($searchFields);
        }

        return $repo;
    }


    /**
     * {@inheritdoc}
     *
     * @throws MethodNotAllowedHttpException
     */
    public function createForm($entity, $formFactory, $action = null, $options = [])
    {
        if (!$entity instanceof Transaction) {
            throw new MethodNotAllowedHttpException(['Transaction']);
        }
        if (!empty($action)) {
            $options['action'] = $action;
        }

        return $formFactory->create(TransactionType::class, $entity, $options);
    }

    /**
     * {@inheritdoc}
     *
     * @return Transaction|null
     */
    public function getEntity($id = null)
    {
        if (null === $id) {
            return new Transaction();
        }

        return parent::getEntity($id);
    }

    /**
     * Get list of entities for autopopulate fields.
     *
     * @param string         $type
     * @param mixed[]|string $filter
     * @param int            $limit
     * @param int            $start
     *
     * @return array
     */
    public function getLookupResults($type, $filter = '', $limit = 10, $start = 0)
    {
        $results = [];
        switch ($type) {
            case 'transactionfield':
            case 'mautic.transaction.model.transaction':
                if ('mautic.transaction.model.transaction' === $type) {
                    $column    = 'trancode';
                    $filterVal = $filter;
                } else {
                    if (is_array($filter)) {
                        $column    = $filter[0];
                        $filterVal = $filter[1];
                    } else {
                        $column = $filter;
                    }
                }

                $expr      = new ExpressionBuilder($this->em->getConnection());
                $composite = $expr->andX();
                $composite->add(
                    $expr->like("comp.$column", ':filterVar')
                );

                // Validate owner permissions
                if (!$this->security->isGranted('lead:leads:viewother')) {
                    $composite->add(
                        $expr->orX(
                            $expr->andX(
                                $expr->isNull('comp.owner_id'),
                                $expr->eq('comp.created_by', (int) $this->userHelper->getUser()->getId())
                            ),
                            $expr->eq('comp.owner_id', (int) $this->userHelper->getUser()->getId())
                        )
                    );
                }

                $results = $this->getRepository()->getAjaxSimpleList($composite, ['filterVar' => $filterVal.'%'], $column);

                break;
        }

        return $results;
    }

    /**
     * {@inheritdoc}
     *
     * @param $action
     * @param $event
     * @param $entity
     * @param $isNew
     *
     * @throws \Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException
     */
    protected function dispatchEvent($action, &$entity, $isNew = false, Event $event = null)
    {
        if (!$entity instanceof Transaction) {
            throw new MethodNotAllowedHttpException(['Email']);
        }

        switch ($action) {
            case 'pre_save':
                $name = 'mautic.transaction_pre_save';
                break;
            case 'post_save':
                $name = 'mautic.transaction_post_save';
                break;
            case 'pre_delete':
                $name = 'mautic.transaction_pre_delete';
                break;
            case 'post_delete':
                $name = 'mautic.transaction_post_delete';
                break;
            default:
                return null;
        }

        if ($this->dispatcher->hasListeners($name)) {
            if (empty($event)) {
                $event = new TransactionEvent($entity, $isNew);
                $event->setEntityManager($this->em);
            }

            $this->dispatcher->dispatch($name, $event);

            return $event;
        } else {
            return null;
        }
    }

    /**
     * @return array
     */
    public function fetchTransactionFields()
    {
        if (empty($this->companyFields)) {
            $this->companyFields = $this->leadFieldModel->getEntities(
                [
                    'filter' => [
                        'force' => [
                            [
                                'column' => 'f.isPublished',
                                'expr'   => 'eq',
                                'value'  => true,
                            ],
                            [
                                'column' => 'f.object',
                                'expr'   => 'eq',
                                'value'  => 'transaction',
                            ],
                        ],
                    ],
                    'hydration_mode' => 'HYDRATE_ARRAY',
                ]
            );
        }

        return $this->companyFields;
    }

    /**
     * @param mixed[] $fields
     * @param mixed[] $data
     * @param null    $owner
     * @param bool    $skipIfExists
     *
     * @return bool|null
     *
     * @throws \Exception
     */
    public function import($fields, $data, $owner = null, $skipIfExists = false)
    {
        $transaction = $this->importTransaction($fields, $data, $owner, false, $skipIfExists);
        if (null === $transaction) {
            throw new \Exception($this->translator->trans('mautic.lead.import.unique_field_not_exist', [], 'flashes'));
        }

        $merged = !$transaction->isNew();
        $this->saveEntity($transaction);

        return $merged;
    }

    /**
     * @param array $fields
     * @param array $data
     * @param null  $owner
     *
     * @return Company|null
     *
     * @throws \Exception
     */
    public function importTransaction($fields, $data, $owner = null, $persist = true, $skipIfExists = false)
    {
        try {
            $duplicateCompanies = $this->companyDeduper->checkForDuplicateCompanies($this->getFieldData($fields, $data));
        } catch (UniqueFieldNotFoundException $uniqueFieldNotFoundException) {
            return null;
        }

        $transaction = new Transaction();

        if (!empty($fields['dateAdded']) && !empty($data[$fields['dateAdded']])) {
            $dateAdded = new DateTimeHelper($data[$fields['dateAdded']]);
            $transaction->setDateAdded($dateAdded->getUtcDateTime());
        }
        unset($fields['dateAdded']);

        if (!empty($fields['dateModified']) && !empty($data[$fields['dateModified']])) {
            $dateModified = new DateTimeHelper($data[$fields['dateModified']]);
            $transaction->setDateModified($dateModified->getUtcDateTime());
        }
        unset($fields['dateModified']);

        if (!empty($fields['createdByUser']) && !empty($data[$fields['createdByUser']])) {
            $userRepo      = $this->em->getRepository('MauticUserBundle:User');
            $createdByUser = $userRepo->findByIdentifier($data[$fields['createdByUser']]);
            if (null !== $createdByUser) {
                $transaction->setCreatedBy($createdByUser);
            }
        }
        unset($fields['createdByUser']);

        if (!empty($fields['modifiedByUser']) && !empty($data[$fields['modifiedByUser']])) {
            $userRepo       = $this->em->getRepository('MauticUserBundle:User');
            $modifiedByUser = $userRepo->findByIdentifier($data[$fields['modifiedByUser']]);
            if (null !== $modifiedByUser) {
                $transaction->setModifiedBy($modifiedByUser);
            }
        }
        unset($fields['modifiedByUser']);

        if (null !== $owner) {
            $transaction->setOwner($this->em->getReference('MauticUserBundle:User', $owner));
        }

        $fieldData = $this->getFieldData($fields, $data);

        $fieldErrors = [];
        foreach ($this->fetchTransactionFields() as $entityField) {
            // Skip If value already exists
            if ($skipIfExists && !$transaction->isNew() && !empty($transaction->getProfileFields()[$entityField['alias']])) {
                unset($fieldData[$entityField['alias']]);
                continue;
            }

            if (isset($fieldData[$entityField['alias']])) {
                $fieldData[$entityField['alias']] = InputHelper::_($fieldData[$entityField['alias']], 'string');

                if ('NULL' === $fieldData[$entityField['alias']]) {
                    $fieldData[$entityField['alias']] = null;

                    continue;
                }

                try {
                    $this->cleanFields($fieldData, $entityField);
                } catch (\Exception $exception) {
                    $fieldErrors[] = $entityField['alias'].': '.$exception->getMessage();
                }

                // Skip if the value is in the CSV row
                continue;
            } elseif ($transaction->isNew() && $entityField['defaultValue']) {
                // Fill in the default value if any
                $fieldData[$entityField['alias']] = ('multiselect' === $entityField['type']) ? [$entityField['defaultValue']] : $entityField['defaultValue'];
            }
        }

        if ($fieldErrors) {
            $fieldErrors = implode("\n", $fieldErrors);

            throw new \Exception($fieldErrors);
        }
        // All clear
        foreach ($fieldData as $field => $value) {
            $transaction->addUpdatedField($field, $value);
        }

        if ($persist) {
            $this->saveEntity($transaction);
        }

        return $transaction;
    }

    public function checkForDuplicateCompanies(array $queryFields)
    {
        return $this->companyDeduper->checkForDuplicateCompanies($queryFields);
    }

    /**
     * @param array $fields
     * @param array $data
     */
    protected function getFieldData($fields, $data): array
    {
        // Set profile data using the form so that values are validated
        $fieldData = [];
        foreach ($fields as $importField => $entityField) {
            // Prevent overwriting existing data with empty data
            if (array_key_exists($importField, $data) && !is_null($data[$importField]) && '' != $data[$importField]) {
                $fieldData[$entityField] = $data[$importField];
            }
        }

        return $fieldData;
    }

    /**
     * Reorganizes a field list to be keyed by field's group then alias.
     *
     * @param $fields
     *
     * @return array
     */
    public function organizeFieldsByGroup($fields)
    {
        $array = [];

        foreach ($fields as $field) {
            if ($field instanceof LeadField) {
                $alias = $field->getAlias();
                if ('transaction' === $field->getObject()) {
                    $group                          = $field->getGroup();
                    $array[$group][$alias]['id']    = $field->getId();
                    $array[$group][$alias]['group'] = $group;
                    $array[$group][$alias]['label'] = $field->getLabel();
                    $array[$group][$alias]['alias'] = $alias;
                    $array[$group][$alias]['type']  = $field->getType();
                }
            } else {
                $alias   = $field['alias'];
                $field[] = $alias;
                if ('transaction' === $field['object']) {
                    $group                          = $field['group'];
                    $array[$group][$alias]['id']    = $field['id'];
                    $array[$group][$alias]['group'] = $group;
                    $array[$group][$alias]['label'] = $field['label'];
                    $array[$group][$alias]['alias'] = $alias;
                    $array[$group][$alias]['type']  = $field['type'];
                }
            }
        }

        //make sure each group key is present
        $groups = ['core', 'social', 'personal', 'professional'];
        foreach ($groups as $g) {
            if (!isset($array[$g])) {
                $array[$g] = [];
            }
        }

        return $array;
    }

    /**
     * Populates custom field values for updating the company.
     *
     * @param bool|false $overwriteWithBlank
     */
    public function setFieldValues(Transaction $transaction, array $data, $overwriteWithBlank = false)
    {
        $fieldValues = $transaction->getFields();

        if (empty($fieldValues)) {
            if (empty($this->fields)) {
                $this->fields = $this->leadFieldModel->getEntities(
                    [
                        'filter'         => ['object' => 'transaction'],
                        'hydration_mode' => 'HYDRATE_ARRAY',
                    ]
                );
                $this->fields = $this->organizeFieldsByGroup($this->fields);
            }
            $fieldValues = $this->fields;
        }

        foreach ($fieldValues as &$groupFields) {
            foreach ($groupFields as $alias => &$field) {
                if (!isset($field['value'])) {
                    $field['value'] = null;
                }
                if (array_key_exists($alias, $data)) {
                    $curValue = $field['value'];
                    $newValue = $data[$alias];

                    if (is_array($newValue)) {
                        $newValue = implode('|', $newValue);
                    }

                    if ($curValue !== $newValue && (strlen($newValue) > 0 || (0 === strlen($newValue) && $overwriteWithBlank))) {
                        $field['value'] = $newValue;
                        $transaction->addUpdatedField($alias, $newValue, $curValue);
                    }
                }
            }
        }
        $transaction->setFields($fieldValues);
    }
	
}
