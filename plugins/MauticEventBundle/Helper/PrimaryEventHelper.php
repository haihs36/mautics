<?php

namespace MauticPlugin\MauticEventBundle\Helper;

use MauticPlugin\MauticEventBundle\Entity\EventLeadRepository;
use Mautic\LeadBundle\Entity\Lead;
use Mautic\LeadBundle\Entity\LeadRepository;

class PrimaryEventHelper
{
    private $eventLeadRepository;

    /**
     * PrimaryEventHelper constructor.
     *
     * @param LeadRepository $eventLeadRepository
     */
    public function __construct(EventLeadRepository $eventLeadRepository)
    {
        $this->eventLeadRepository = $eventLeadRepository;
    }

    /**
     * @return array
     */
    public function getProfileFieldsWithPrimaryEvent(Lead $lead)
    {
        return $this->mergeInPrimaryEvent(
            $this->eventLeadRepository->getEventsByLeadId($lead->getId()),
            $lead->getProfileFields()
        );
    }

    /**
     * @param $contactId
     *
     * @return array
     */
    public function mergePrimaryEventWithProfileFields($contactId, array $profileFields)
    {
        return $this->mergeInPrimaryEvent(
            $this->eventLeadRepository->getEventsByLeadId($contactId),
            $profileFields
        );
    }

    /**
     * @return array
     */
    private function mergeInPrimaryEvent(array $events, array $profileFields)
    {
        foreach ($events as $event) {
            if (empty($event['is_primary'])) {
                continue;
            }

            unset($event['id'], $event['score'], $event['date_added'], $event['date_associated'], $event['is_primary']);

            return array_merge($profileFields, $event);
        }

        return $profileFields;
    }
}
