<?php

declare(strict_types=1);

namespace MauticPlugin\MauticTransactionBundle\EventListener;

use Mautic\CoreBundle\Helper\ArrayHelper;
use Mautic\CoreBundle\Security\Permissions\CorePermissions;
use Mautic\LeadBundle\Entity\Tag;
use Mautic\LeadBundle\Event\ImportInitEvent;
use Mautic\LeadBundle\Event\ImportMappingEvent;
use Mautic\LeadBundle\Event\ImportProcessEvent;
use Mautic\LeadBundle\Event\ImportValidateEvent;
use Mautic\LeadBundle\Field\FieldList;
use Mautic\LeadBundle\LeadEvents;
use MauticPlugin\MauticTransactionBundle\Model\TransactionModel;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Form\FormError;
use Symfony\Component\Security\Core\Exception\AccessDeniedException;
use Symfony\Component\Translation\TranslatorInterface;

final class ImportSubscriber implements EventSubscriberInterface
{
    private FieldList $fieldList;
    private CorePermissions $corePermissions;
    private TransactionModel $transactionModel;
    private TranslatorInterface $translator;

    public function __construct(FieldList $fieldList,
        CorePermissions $corePermissions,
        TransactionModel $transactionModel,
        TranslatorInterface $translator
    ) {
        $this->fieldList       = $fieldList;
        $this->corePermissions = $corePermissions;
        $this->transactionModel    = $transactionModel;
        $this->translator      = $translator;
    }

    public static function getSubscribedEvents(): array
    {
        return [
            LeadEvents::IMPORT_ON_INITIALIZE    => ['onImportInit'],
            LeadEvents::IMPORT_ON_FIELD_MAPPING => ['onFieldMapping'],
            LeadEvents::IMPORT_ON_PROCESS       => ['onImportProcess'],
            LeadEvents::IMPORT_ON_VALIDATE      => ['onValidateImport'],
        ];
    }

    /**
     * @throws AccessDeniedException
     */
    public function onImportInit(ImportInitEvent $event): void
    {
        if ($event->importIsForRouteObject('transactions')) {
            if (!$this->corePermissions->isGranted('lead:imports:create')) {
                throw new AccessDeniedException('You do not have permission to import transactions');
            }

            $event->objectSingular = 'transaction';
            $event->objectName     = 'mautic.lead.lead.transactions';
            $event->activeLink     = '#mautic_transaction_index';
            $event->setIndexRoute('mautic_transaction_index');
            $event->stopPropagation();
        }
    }

    public function onFieldMapping(ImportMappingEvent $event): void
    {
        if ($event->importIsForRouteObject('transactions')) {
            $specialFields = [
                'dateAdded'      => 'mautic.lead.import.label.dateAdded',
                'createdByUser'  => 'mautic.lead.import.label.createdByUser',
                'dateModified'   => 'mautic.lead.import.label.dateModified',
                'modifiedByUser' => 'mautic.lead.import.label.modifiedByUser',
            ];

            $event->fields = [
                'mautic.lead.transaction'        => $this->fieldList->getFieldList(false, false, ['isPublished' => true, 'object' => 'transaction']),
                'mautic.lead.special_fields' => $specialFields,
            ];
        }
    }

    public function onImportProcess(ImportProcessEvent $event): void
    {
        if ($event->importIsForObject('transaction')) {
            $merged = $this->transactionModel->import(
                $event->import->getMatchedFields(),
                $event->rowData,
                $event->import->getDefault('owner'),
                $event->import->getDefault('skip_if_exists')
            );
            $event->setWasMerged((bool) $merged);
            $event->stopPropagation();
        }
    }

    public function onValidateImport(ImportValidateEvent $event): void
    {
        if (false === $event->importIsForRouteObject('transactions')) {
            return;
        }

        $matchedFields = $event->getForm()->getData();

        $event->setOwnerId($this->handleValidateOwner($matchedFields));
        $event->setList($this->handleValidateList($matchedFields));
        $event->setTags($this->handleValidateTags($matchedFields));

        $matchedFields = array_map(
            fn ($value) => is_string($value) ? trim($value) : $value,
            array_filter($matchedFields)
        );

        if (empty($matchedFields)) {
            $event->getForm()->addError(
                new FormError(
                    $this->translator->trans('mautic.lead.import.matchfields', [], 'validators')
                )
            );
        }

        $this->handleValidateRequired($event, $matchedFields);

        $event->setMatchedFields($matchedFields);
    }

    /**
     * @param mixed[] $matchedFields
     */
    private function handleValidateOwner(array &$matchedFields): ?int
    {
        $owner = ArrayHelper::pickValue('owner', $matchedFields);

        return $owner ? $owner->getId() : null;
    }

    /**
     * @param mixed[] $matchedFields
     */
    private function handleValidateList(array &$matchedFields): ?int
    {
        return ArrayHelper::pickValue('list', $matchedFields);
    }

    /**
     * @param mixed[] $matchedFields
     *
     * @return mixed[]
     */
    private function handleValidateTags(array &$matchedFields): array
    {
        // In case $matchedFields['tags'] === null ...
        $tags = ArrayHelper::pickValue('tags', $matchedFields, []);
        // ...we must ensure we pass an [] to array_map
        $tags = is_array($tags) ? $tags : [];

        return array_map(fn (Tag $tag) => $tag->getTag(), $tags);
    }

    /**
     * Validate required fields.
     *
     * Required fields come through as ['alias' => 'label'], and
     * $matchedFields is a zero indexed array, so to calculate the
     * diff, we must array_flip($matchedFields) and compare on key.
     *
     * @param mixed[] $matchedFields
     */
    private function handleValidateRequired(ImportValidateEvent $event, array &$matchedFields): void
    {
        $requiredFields = $this->fieldList->getFieldList(false, false, [
            'isPublished' => true,
            'object'      => 'transaction',
            'isRequired'  => true,
        ]);

        $missingRequiredFields = array_diff_key($requiredFields, array_flip($matchedFields));

        if (count($missingRequiredFields)) {
            $event->getForm()->addError(
                new FormError(
                    $this->translator->trans(
                        'mautic.import.missing.required.fields',
                        [
                            '%requiredFields%' => implode(', ', $missingRequiredFields),
                            '%fieldOrFields%'  => 1 === count($missingRequiredFields) ? 'field' : 'fields',
                        ],
                        'validators'
                    )
                )
            );
        }
    }
}
