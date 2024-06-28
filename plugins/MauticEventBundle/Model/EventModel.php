<?php

namespace MauticPlugin\MauticEventBundle\Model;

use Doctrine\DBAL\Query\Expression\ExpressionBuilder;
use Mautic\CoreBundle\Form\RequestTrait;
use Mautic\CoreBundle\Helper\DateTimeHelper;
use Mautic\CoreBundle\Helper\InputHelper;
use Mautic\CoreBundle\Model\AjaxLookupModelInterface;
use Mautic\CoreBundle\Model\FormModel as CommonFormModel;
use Mautic\EmailBundle\Helper\EmailValidator;
use Mautic\LeadBundle\Model\FieldModel;
use MauticPlugin\MauticEventBundle\Deduplicate\EventDeduper;
use MauticPlugin\MauticEventBundle\Entity\Event;
use MauticPlugin\MauticEventBundle\Entity\EventLeadRepository;
use MauticPlugin\MauticEventBundle\Entity\EventRepository;
use MauticPlugin\MauticEventBundle\Event\LeadChangeEventPlugin;
use MauticPlugin\MauticEventBundle\Form\Type\EventType;
use Mautic\LeadBundle\Model\DefaultValueTrait;
use MauticPlugin\MauticEventBundle\Entity\EventLead;
use Mautic\LeadBundle\Entity\Lead;
use Mautic\LeadBundle\Entity\LeadField;
use Mautic\LeadBundle\Entity\LeadRepository;
use MauticPlugin\MauticEventBundle\Event\EventPluginEvent;
use Mautic\LeadBundle\Exception\UniqueFieldNotFoundException;
use MauticPlugin\MauticEventBundle\LeadEventPlugins;
use Symfony\Component\EventDispatcher\Event as EventDispatcher;
use Symfony\Component\HttpFoundation\Session\Session;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;

/**
 * Class EventModel.
 */
class EventModel extends CommonFormModel implements AjaxLookupModelInterface
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
    protected $eventFields;

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
     * @var EventDeduper
     */
    private $eventDeduper;

    /**
     * EventModel constructor.
     */
    public function __construct(FieldModel $leadFieldModel, Session $session, EmailValidator $validator, EventDeduper $eventDeduper)
    {
        $this->leadFieldModel = $leadFieldModel;
        $this->session        = $session;
        $this->emailValidator = $validator;
        $this->eventDeduper = $eventDeduper;
    }

    /**
     * @param Event $entity
     * @param bool    $unlock
     */
    public function saveEntity($entity, $unlock = true)
    {
        // Update leads primary event name
        $this->setEntityDefaultValues($entity, 'event');
        $this->getEventLeadRepository()->updateLeadsPrimaryEventName($entity);

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
        // Update leads primary event name
        foreach ($entities as $entity) {
            $this->setEntityDefaultValues($entity, 'event');
            $this->getEventLeadRepository()->updateLeadsPrimaryEventName($entity);
        }
        parent::saveEntities($entities, $unlock);
    }

    /**
     * {@inheritdoc}
     *
     * @return EventRepository
     */
    public function getRepository()
    {
        $repo =  $this->em->getRepository('MauticEventBundle:Event');
        if (!$this->repoSetup) {
            $this->repoSetup = true;
            $repo->setDispatcher($this->dispatcher);
            //set the point trigger model in order to get the color code for the lead
            $fields = $this->leadFieldModel->getFieldList(true, true, ['isPublished' => true, 'object' => 'event']);

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
     * @return EventLeadRepository
     */
    public function getEventLeadRepository()
    {
        return $this->em->getRepository('MauticEventBundle:EventLead');
    }

    /**
     * {@inheritdoc}
     */
    public function getPermissionBase()
    {
        // We are using lead:leads in the EventController so this should match to prevent a BC break
        return 'lead:leads';
    }

    /**
     * {@inheritdoc}
     *
     * @return string
     */
    public function getNameGetter()
    {
        return 'getPrimaryIdentifier';
    }

    /**
     * {@inheritdoc}
     *
     * @throws MethodNotAllowedHttpException
     */
    public function createForm($entity, $formFactory, $action = null, $options = [])
    {
        if (!$entity instanceof Event) {
            throw new MethodNotAllowedHttpException(['Event']);
        }
        if (!empty($action)) {
            $options['action'] = $action;
        }

        return $formFactory->create(EventType::class, $entity, $options);
    }

    /**
     * {@inheritdoc}
     *
     * @return Event|null
     */
    public function getEntity($id = null)
    {
        if (null === $id) {
            return new Event();
        }

        return parent::getEntity($id);
    }

    /**
     * @return mixed
     */
    public function getUserEvents()
    {
        $user = (!$this->security->isGranted('lead:leads:viewother')) ?
            $this->userHelper->getUser() : false;

        return $this->em->getRepository('MauticEventBundle:Event')->getEvents($user);
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
                if ('event' === $field->getObject()) {
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
                if ('event' === $field['object']) {
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
     * Populates custom field values for updating the event.
     *
     * @param bool|false $overwriteWithBlank
     */
    public function setFieldValues(Event $event, array $data, $overwriteWithBlank = false)
    {
        //save the field values
        $fieldValues = $event->getFields();

        if (empty($fieldValues)) {
            // Lead is new or they haven't been populated so let's build the fields now
            if (empty($this->fields)) {
                $this->fields = $this->leadFieldModel->getEntities(
                    [
                        'filter'         => ['object' => 'event'],
                        'hydration_mode' => 'HYDRATE_ARRAY',
                    ]
                );
                $this->fields = $this->organizeFieldsByGroup($this->fields);
            }
            $fieldValues = $this->fields;
        }

        //update existing values
        foreach ($fieldValues as &$groupFields) {
            foreach ($groupFields as $alias => &$field) {
                if (!isset($field['value'])) {
                    $field['value'] = null;
                }
                // Only update fields that are part of the passed $data array
                if (array_key_exists($alias, $data)) {
                    $curValue = $field['value'];
                    $newValue = $data[$alias];

                    if (is_array($newValue)) {
                        $newValue = implode('|', $newValue);
                    }

                    if ($curValue !== $newValue && (strlen($newValue) > 0 || (0 === strlen($newValue) && $overwriteWithBlank))) {
                        $field['value'] = $newValue;
                        $event->addUpdatedField($alias, $newValue, $curValue);
                    }
                }
            }
        }
        $event->setFields($fieldValues);
    }

    /**
     * Add lead to event.
     *
     * @param array|Event $events
     * @param array|Lead    $lead
     *
     * @return bool
     *
     * @throws \Doctrine\ORM\ORMException
     */
    public function addLeadToEvent($events, $lead)
    {
        // Primary event name to be persisted to the lead's contact event field
        $eventName        = '';
        $eventLeadAdd     = [];
        $searchForEvents = [];

        $dateManipulated = new \DateTime();

        if (!$lead instanceof Lead) {
            $leadId = (is_array($lead) && isset($lead['id'])) ? $lead['id'] : $lead;
            $lead   = $this->em->getReference('MauticLeadBundle:Lead', $leadId);
        }

        if ($events instanceof Event) {
            $eventLeadAdd[$events->getId()] = $events;
            $events                           = [$events->getId()];
        } elseif (!is_array($events)) {
            $events = [$events];
        }

        //make sure they are ints
        foreach ($events as &$l) {
            $l = (int) $l;

            if (!isset($eventLeadAdd[$l])) {
                $searchForEvents[] = $l;
            }
        }

        if (!empty($searchForEvents)) {
            $eventEntities = $this->getEntities([
                'filter' => [
                    'force' => [
                        [
                            'column' => 'e.id',
                            'expr'   => 'in',
                            'value'  => $searchForEvents,
                        ],
                    ],
                ],
            ]);

            foreach ($eventEntities as $event) {
                $eventLeadAdd[$event->getId()] = $event;
            }
        }

        unset($eventEntities, $searchForEvents);

        $persistEvent= [];
        $dispatchEvents = [];
        $contactAdded   = false;
        foreach ($events as $eventId) {
            if (!isset($eventLeadAdd[$eventId])) {
                // List no longer exists in the DB so continue to the next
                continue;
            }

            $eventLead = $this->getEventLeadRepository()->findOneBy(
                [
                    'lead'    => $lead,
                    'event' => $eventLeadAdd[$eventId],
                ]
            );

            if (null != $eventLead) {
                // Detach from Doctrine
                $this->em->detach($eventLead);

                continue;
            } else {
                $eventLead = new EventLead();
                $eventLead->setEvent($eventLeadAdd[$eventId]);
                $eventLead->setLead($lead);
                $eventLead->setDateAdded($dateManipulated);
                $contactAdded     = true;
                $persistEvent[] = $eventLead;
                $dispatchEvents[] = $eventId;

                if (!$eventName) {
                    // EventLeadRepository::saveEntities will set the first event of the batch as primary so
                    // use the first event name to ensure they match
                    $eventName = $eventLeadAdd[$eventId]->getName();
                }
            }
        }

        if (!empty($persistEvent)) {
            $this->getEventLeadRepository()->saveEntities($persistEvent);
        }

        if (!empty($eventName)) {
            // Set the contact's primary event to the first event added in the batch
            // This must happen before LeadEvents::LEAD_EVENT_CHANGE to ensure the Lead::getEvent has the correct value
            $currentEventName = $lead->getEvent();
            if ($currentEventName !== $eventName) {
                $lead->addUpdatedField('event', $eventName)
                    ->setDateModified(new \DateTime());

                /** @var LeadRepository */
                $leadRepository = $this->em->getRepository(Lead::class);
                $leadRepository->saveEntity($lead);
            }
        }

        if (!empty($dispatchEvents) && ($this->dispatcher->hasListeners(LeadEventPlugins::LEAD_EVENT_PLUGIN_CHANGE))) {
            foreach ($dispatchEvents as $eventId) {
                $event = new LeadChangeEventPlugin($lead, $eventLeadAdd[$eventId]);
                $this->dispatcher->dispatch(LeadEventPlugins::LEAD_EVENT_PLUGIN_CHANGE, $event);

                unset($event);
            }
        }

        // Clear EventLead entities from Doctrine memory
        $this->em->clear(EventLead::class);

        return $contactAdded;
    }

    /**
     * Remove a lead from event.
     *
     * @param $events
     * @param $lead
     *
     * @throws \Doctrine\ORM\ORMException
     */
    public function removeLeadFromEvent($events, $lead)
    {
        if (!$lead instanceof Lead) {
            $leadId = (is_array($lead) && isset($lead['id'])) ? $lead['id'] : $lead;
            $lead   = $this->em->getReference('MauticLeadBundle:Lead', $leadId);
        }

        $eventLeadRemove = [];
        if (!$events instanceof Event) {
            //make sure they are ints
            $searchForEvents = [];
            foreach ($events as &$l) {
                $l = (int) $l;
                if (!isset($eventLeadRemove[$l])) {
                    $searchForEvents[] = $l;
                }
            }
            if (!empty($searchForEvents)) {
                $eventEntities = $this->getEntities(
                    [
                        'filter' => [
                            'force' => [
                                [
                                    'column' => 'e.id',
                                    'expr'   => 'in',
                                    'value'  => $searchForEvents,
                                ],
                            ],
                        ],
                    ]
                );

                foreach ($eventEntities as $event) {
                    $eventLeadRemove[$event->getId()] = $event;
                }
            }

            unset($eventEntities, $searchForEvents);
        } else {
            $eventLeadRemove[$events->getId()] = $events;

            $events = [$events->getId()];
        }

        if (!is_array($events)) {
            $events = [$events];
        }

        $deleteEvent  = [];
        $dispatchEvents = [];

        $primaryRemoved = false;
        foreach ($events as $eventId) {
            if (!isset($eventLeadRemove[$eventId])) {
                continue;
            }

            /** @var EventLead $eventLead */
            $eventLead = $this->getEventLeadRepository()->findOneBy(
                [
                    'lead'    => $lead,
                    'event' => $eventLeadRemove[$eventId],
                ]
            );

            if (null == $eventLead) {
                // Lead is not part of this list
                continue;
            }

            // Lead was manually added and now manually removed or was not manually added and now being removed
            $deleteEventLead[] = $eventLead;
            $dispatchEvents[]    = $eventId;

            // Update the Lead's primary event name if removed from the primary event
            if (!$primaryRemoved) {
                $primaryRemoved = $eventLead->getPrimary();
            }

            unset($eventLead);
        }

        if (!empty($deleteEventLead)) {
            $this->getEventLeadRepository()->deleteEntities($deleteEventLead);
        }

        if ($primaryRemoved) {
            // Set the contact's primary event to a remaining event or empty it out if none are left
            // This must happen before LeadEventPlugins::LEAD_event_CHANGE to ensure the Lead::getevent has the correct value
            $this->updateContactAfterPrimaryEventWasRemoved($lead);
        }

        // Clear eventLead entities from Doctrine memory
        $this->em->clear(EventLead::class);

        if (!empty($dispatchEvents) && ($this->dispatcher->hasListeners(LeadEventPlugins::LEAD_EVENT_PLUGIN_CHANGE))) {
            foreach ($dispatchEvents as $eventId) {
                $event = new LeadChangeEventPlugin($lead, $eventLeadRemove[$eventId], false);
                $this->dispatcher->dispatch(LeadEventPlugins::LEAD_EVENT_PLUGIN_CHANGE, $event);

                unset($event);
            }
        }

        unset($lead, $deleteEvent, $events);
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
            case 'eventfield':
            case 'lead.event':
                if ('lead.event' === $type) {
                    $column    = 'eventName';
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
                    $expr->like("e.$column", ':filterVar')
                );

                // Validate owner permissions
                if (!$this->security->isGranted('lead:leads:viewother')) {
                    $composite->add(
                        $expr->orX(
                            $expr->andX(
                                $expr->isNull('e.owner_id'),
                                $expr->eq('e.created_by', (int) $this->userHelper->getUser()->getId())
                            ),
                            $expr->eq('e.owner_id', (int) $this->userHelper->getUser()->getId())
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
    protected function dispatchEvent($action, &$entity, $isNew = false, EventDispatcher $event = null)
    {
        if (!$entity instanceof Event) {
            throw new MethodNotAllowedHttpException(['Email']);
        }

        switch ($action) {
            case 'pre_save':
                $name = LeadEventPlugins::EVENT_PLUGIN_PRE_SAVE;
                break;
            case 'post_save':
                $name = LeadEventPlugins::EVENT_PLUGIN_POST_SAVE;
                break;
            case 'pre_delete':
                $name = LeadEventPlugins::EVENT_PLUGIN_PRE_DELETE;
                break;
            case 'post_delete':
                $name = LeadEventPlugins::EVENT_PLUGIN_POST_DELETE;
                break;
            default:
                return null;
        }

        if ($this->dispatcher->hasListeners($name)) {
            if (empty($event)) {
                $event = new EventPluginEvent($entity, $isNew);
                $event->setEntityManager($this->em);
            }

            $this->dispatcher->dispatch($name, $event);

            return $event;
        } else {
            return null;
        }
    }

    /**
     * Event Merge function, will merge $mainEvent with $secEvent -  empty records from main event will be
     * filled with secondary then secondary will be deleted.
     *
     * @param $mainEvent
     * @param $secEvent
     *
     * @return mixed
     */
    public function eventMerge($mainEvent, $secEvent)
    {
        $this->logger->debug('EVENT: Merging events');

        $mainEventId = $mainEvent->getId();
        $secEventId  = $secEvent->getId();

        //if they are the same lead, then just return one
        if ($mainEventId === $secEventId) {
            return $mainEvent;
        }
        //merge fields
        $mergeSecFields    = $secEvent->getFields();
        $mainEventFields = $mainEvent->getFields();
        foreach ($mergeSecFields as $group => $groupFields) {
            foreach ($groupFields as $alias => $details) {
                //fill in empty main event fields with secondary event fields
                if (empty($mainEventFields[$group][$alias]['value']) && !empty($details['value'])) {
                    $mainEvent->addUpdatedField($alias, $details['value']);
                    $this->logger->debug('event: Updated '.$alias.' = '.$details['value']);
                }
            }
        }

        //merge owner
        $mainEventOwner = $mainEvent->getOwner();
        $secEventOwner  = $secEvent->getOwner();

        if (null === $mainEventOwner && null !== $secEventOwner) {
            $mainEvent->setOwner($secEventOwner);
        }

        //move all leads from secondary event to main event
        $eventLeadRepo = $this->getEventLeadRepository();
        $secEventLeads = $eventLeadRepo->getEventLeads($secEventId);

        foreach ($secEventLeads as $lead) {
            $this->addLeadToEvent($mainEvent->getId(), $lead['lead_id']);
        }
        //save the updated event
        $this->saveEntity($mainEvent, false);

        //delete the old event
        $this->deleteEntity($secEvent);

        //return the merged event
        return $mainEvent;
    }

    /**
     * @return array
     */
    public function fetchEventFields()
    {
        if (empty($this->eventFields)) {
            $this->eventFields = $this->leadFieldModel->getEntities(
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
                                'value'  => 'event',
                            ],
                        ],
                    ],
                    'hydration_mode' => 'HYDRATE_ARRAY',
                ]
            );
        }

        return $this->eventFields;
    }

    /**
     * @param $mappedFields
     * @param $data
     *
     * @return array
     */
    public function extractEventDataFromImport(array &$mappedFields, array &$data)
    {
        $eventData    = [];
        $eventFields  = [];
        $internalFields = $this->fetchEventFields();

        if (!isset($mappedFields['eventName']) && isset($mappedFields['event'])) {
            $mappedFields['eventName'] = $mappedFields['event'];

            unset($mappedFields['event']);
        }

        foreach ($mappedFields as $mauticField => $importField) {
            foreach ($internalFields as $entityField) {
                if ($entityField['alias'] === $mauticField) {
                    $eventData[$importField]   = $data[$importField];
                    $eventFields[$mauticField] = $importField;
                    unset($data[$importField]);
                    unset($mappedFields[$mauticField]);
                    break;
                }
            }
        }

        return [$eventFields, $eventData];
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
        $event = $this->importEvent($fields, $data, $owner, false, $skipIfExists);

        if (null === $event) {
            throw new \Exception($this->translator->trans('mautic.lead.import.unique_field_not_exist', [], 'flashes'));
        }

        $merged = !$event->isNew();

        $this->saveEntity($event);

        return $merged;
    }

    /**
     * @param array $fields
     * @param array $data
     * @param null  $owner
     *
     * @return Event|null
     *
     * @throws \Exception
     */
    public function importEvent($fields, $data, $owner = null, $persist = true, $skipIfExists = false)
    {
        try {
            $duplicateEvents = $this->eventDeduper->checkForDuplicateEvents($this->getFieldData($fields, $data));
        } catch (UniqueFieldNotFoundException $uniqueFieldNotFoundException) {
            return null;
        }


        $event = !empty($duplicateEvents) ? $duplicateEvents[0] : new Event();

        if (!empty($fields['dateAdded']) && !empty($data[$fields['dateAdded']])) {
            $dateAdded = new DateTimeHelper($data[$fields['dateAdded']]);
            $event->setDateAdded($dateAdded->getUtcDateTime());
        }
        unset($fields['dateAdded']);

        if (!empty($fields['dateModified']) && !empty($data[$fields['dateModified']])) {
            $dateModified = new DateTimeHelper($data[$fields['dateModified']]);
            $event->setDateModified($dateModified->getUtcDateTime());
        }
        unset($fields['dateModified']);

        if (!empty($fields['createdByUser']) && !empty($data[$fields['createdByUser']])) {
            $userRepo      = $this->em->getRepository('MauticUserBundle:User');
            $createdByUser = $userRepo->findByIdentifier($data[$fields['createdByUser']]);
            if (null !== $createdByUser) {
                $event->setCreatedBy($createdByUser);
            }
        }

        unset($fields['createdByUser']);

        if (!empty($fields['modifiedByUser']) && !empty($data[$fields['modifiedByUser']])) {
            $userRepo       = $this->em->getRepository('MauticUserBundle:User');
            $modifiedByUser = $userRepo->findByIdentifier($data[$fields['modifiedByUser']]);
            if (null !== $modifiedByUser) {
                $event->setModifiedBy($modifiedByUser);
            }
        }
        unset($fields['modifiedByUser']);

        if (null !== $owner) {
            $event->setOwner($this->em->getReference('MauticUserBundle:User', $owner));
        }

        $fieldData = $this->getFieldData($fields, $data);

        $fieldErrors = [];

        foreach ($this->fetchEventFields() as $entityField) {
            // Skip If value already exists
            if ($skipIfExists && !$event->isNew() && !empty($event->getProfileFields()[$entityField['alias']])) {
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
            } elseif ($event->isNew() && $entityField['defaultValue']) {
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
            $event->addUpdatedField($field, $value);
        }

        if ($persist) {
            $this->saveEntity($event);
        }

        return $event;
    }

    public function checkForDuplicateEvents(array $queryFields)
    {
        return $this->eventDeduper->checkForDuplicateEvents($queryFields);
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

    private function updateContactAfterPrimaryEventWasRemoved(Lead $lead): void
    {
        $primaryEventName = '';

        // Find another event to make primary if applicable
        $leadEvents = $this->getEventLeadRepository()->getEventsByLeadId($lead->getId());
        if (count($leadEvents)) {
            $newPrimaryArray   = reset($leadEvents);
            $newPrimaryEvent = $this->em->getReference(Event::class, $newPrimaryArray['event_id']);

            /** @var EventLead $eventLead */
            $eventLead = $this->getEventLeadRepository()->findOneBy(
                [
                    'lead'    => $lead,
                    'event' => $newPrimaryEvent,
                ]
            );

            $eventLead->setPrimary(true);
            $this->getEventLeadRepository()->saveEntity($eventLead);

            $primaryEventName = $newPrimaryArray['eventname'];
        }

        $lead->addUpdatedField('event', $primaryEventName)
            ->setDateModified(new \DateTime());
        $this->em->getRepository('MauticLeadBundle:Lead')->saveEntity($lead);
    }
}
