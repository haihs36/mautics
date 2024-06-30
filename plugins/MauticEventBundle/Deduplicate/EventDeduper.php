<?php

namespace MauticPlugin\MauticEventBundle\Deduplicate;

use MauticPlugin\MauticEventBundle\Entity\EventRepository;
use Mautic\LeadBundle\Exception\UniqueFieldNotFoundException;
use Mautic\LeadBundle\Model\FieldModel;
use MauticPlugin\MauticEventBundle\Entity\Event;

class EventDeduper
{
    use DeduperTrait;

    /**
     * @var EventRepository
     */
    private $eventRepository;

    /**
     * DedupModel constructor.
     */
    public function __construct(FieldModel $fieldModel, EventRepository $eventRepository)
    {
        $this->fieldModel        = $fieldModel;
        $this->eventRepository = $eventRepository;
        $this->object            = 'event';
    }

    /**
     * @return Event[]
     *
     * @throws UniqueFieldNotFoundException
     */
    public function checkForDuplicateEvents(array $queryFields): array
    {
        $uniqueData = $this->getUniqueData($queryFields);
        if (empty($uniqueData)) {
            throw new UniqueFieldNotFoundException();
        }

        return $this->eventRepository->getEventsByUniqueFields($uniqueData);
    }
}
