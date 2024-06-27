<?php

namespace MauticPlugin\MauticEventBundle\Helper;

use MauticPlugin\MauticEventBundle\Entity\Event;
use Mautic\LeadBundle\Exception\UniqueFieldNotFoundException;
use MauticPlugin\MauticEventBundle\Model\EventModel;

/**
 * Class IdentifyEventHelper.
 */
class IdentifyEventHelper
{
    /**
     * @param array $data
     * @param mixed $lead
     *
     * @return array
     */
    public static function identifyLeadsEvent($data, $lead, EventModel $eventModel)
    {
        $addContactToEvent = true;

        $parameters = self::normalizeParameters($data);

        if (!self::hasEventParameters($parameters, $eventModel)) {
            return [null, false, null];
        }

        try {
            $events = $eventModel->checkForDuplicateEvents($parameters);
        } catch (UniqueFieldNotFoundException $uniqueFieldNotFoundException) {
            return [null, false, null];
        }

        if (!empty($events)) {
            $eventEntity = end($events);
            $eventData   = $eventEntity->getProfileFields();

            if ($lead) {
                $eventLeadRepo = $eventModel->getEventLeadRepository();
                $eventLead     = $eventLeadRepo->getEventsByLeadId($lead->getId(), $eventEntity->getId());
                if (!empty($eventLead)) {
                    $addContactToEvent = false;
                }
            }
        } else {
            $eventData = $parameters;

            //create new event
            $eventEntity = new Event();
            $eventModel->setFieldValues($eventEntity, $eventData, true);
            $eventModel->saveEntity($eventEntity);
            $eventData['id'] = $eventEntity->getId();
        }

        return [$eventData, $addContactToEvent, $eventEntity];
    }

    /**
     * @return array
     */
    public static function findEvent(array $data, EventModel $eventModel)
    {
        $parameters = self::normalizeParameters($data);

        if (!self::hasEventParameters($parameters, $eventModel)) {
            return [[], []];
        }

        try {
            $eventEntities = $eventModel->checkForDuplicateEvents($parameters);
        } catch (UniqueFieldNotFoundException $uniqueFieldNotFoundException) {
            return [[], []];
        }

        $eventData     = $parameters;
        if (!empty($eventEntities)) {
            end($eventEntities);
            $key               = key($eventEntities);
            $eventData['id'] = $eventEntities[$key]->getId();
        }

        return [$eventData, $eventEntities];
    }

    private static function hasEventParameters(array $parameters, EventModel $eventModel)
    {
        $eventFields = $eventModel->fetchEventFields();
        foreach ($parameters as $alias => $value) {
            foreach ($eventFields as $eventField) {
                if ($eventField['alias'] === $alias) {
                    return true;
                }
            }
        }

        return false;
    }

    private static function normalizeParameters(array $parameters)
    {
        $eventName   = null;
        $eventDomain = null;

        if (isset($parameters['event'])) {
            $parameters['eventname'] = filter_var($parameters['event']);
            unset($parameters['event']);
        }

        $fields= ['country', 'city', 'state'];
        foreach ($fields as $field) {
            if (isset($parameters[$field]) && !isset($parameters['event'.$field])) {
                $parameters['event'.$field] = $parameters[$field];
                unset($parameters[$field]);
            }
        }

        return $parameters;
    }

    /**
     * Checks if email address' domain has a DNS MX record. Returns the domain if found.
     *
     * @param string $email
     *
     * @return string|false
     */
    protected static function domainExists($email)
    {
        if (!strstr($email, '@')) { //not a valid email adress
            return false;
        }

        [$user, $domain]     = explode('@', $email);
        $arr                 = dns_get_record($domain, DNS_MX);

        if (empty($arr)) {
            return false;
        }

        if ($arr[0]['host'] === $domain) {
            return $domain;
        }

        return false;
    }
}
