<?php

namespace MauticPlugin\MauticEventBundle\Entity;

use Mautic\CoreBundle\Entity\CommonRepository;

class EventLeadRepository extends CommonRepository
{
    /**
     * @param EventLead[] $entities
     */
    public function saveEntities($entities, $new = true)
    {
        // Get a list of contacts and set primary to 0
        if ($new) {
            $contacts  = [];
            $contactId = null;
            foreach ($entities as $entity) {
                $contactId = $entity->getLead()->getId();
                if (!isset($contacts[$contactId])) {
                    // Set one event from the batch as as primary
                    $entity->setPrimary(true);
                }

                $contacts[$contactId] = $contactId;
            }

            if ($contactId) {
                // Only one event should be set as primary so reset all in order to let the entity update the one
                $qb = $this->getEntityManager()->getConnection()->createQueryBuilder()
                    ->update(MAUTIC_TABLE_PREFIX.'events_leads')
                    ->set('is_primary', 0);

                $qb->where(
                    $qb->expr()->in('lead_id', $contacts)
                )->execute();
            }
        }

        return parent::saveEntities($entities);
    }

    /**
     * Get events by leadId.
     *
     * @param $leadId
     * @param $eventId
     *
     * @return array
     */
    public function getEventsByLeadId($leadId, $eventId = null)
    {
        $q = $this->_em->getConnection()->createQueryBuilder();

        $q->select('cl.event_id, cl.date_added as date_associated, cl.is_primary, comp.*')
            ->from(MAUTIC_TABLE_PREFIX.'events_leads', 'cl')
            ->join('cl', MAUTIC_TABLE_PREFIX.'events', 'comp', 'comp.id = cl.event_id')
        ->where('cl.lead_id = :leadId')
        ->setParameter('leadId', $leadId);

        if ($eventId) {
            $q->andWhere(
                $q->expr()->eq('cl.event_id', ':eventId')
            )->setParameter('eventId', $eventId);
        }

        return $q->execute()->fetchAll();
    }

    /**
     * @param $eventId
     *
     * @return array
     */
    public function getEventLeads($eventId)
    {
        $q = $this->_em->getConnection()->createQueryBuilder();
        $q->select('cl.lead_id')
            ->from(MAUTIC_TABLE_PREFIX.'events_leads', 'cl');

        $q->where($q->expr()->eq('cl.event_id', ':event'))
            ->setParameter(':event', $eventId);

        return $q->execute()->fetchAll();
    }

    /**
     * @param $leadId
     *
     * @return array
     */
    public function getLatestEventForLead($leadId)
    {
        $q = $this->_em->getConnection()->createQueryBuilder();

        $q->select('cl.event_id, comp.eventname, comp.eventcity, comp.eventcountry')
            ->from(MAUTIC_TABLE_PREFIX.'events_leads', 'cl')
            ->join('cl', MAUTIC_TABLE_PREFIX.'events', 'comp', 'comp.id = cl.event_id')
            ->where('cl.lead_id = :leadId')
            ->setParameter('leadId', $leadId);
        $q->orderBy('cl.date_added', 'DESC');
        $result = $q->execute()->fetchAll();

        return !empty($result) ? $result[0] : [];
    }

    /**
     * @param $leadId
     * @param $eventId
     */
    public function getEventLeadEntity($leadId, $eventId)
    {
        $qb = $this->getEntityManager()->getConnection()->createQueryBuilder();
        $qb->select('cl.is_primary, cl.lead_id, cl.event_id')
            ->from(MAUTIC_TABLE_PREFIX.'events_leads', 'cl')
            ->where(
                    $qb->expr()->eq('cl.lead_id', ':leadId'),
                    $qb->expr()->eq('cl.event_id', ':eventId')
            )->setParameter('leadId', $leadId)
            ->setParameter('eventId', $eventId);

        return $qb->execute()->fetchAll();
    }

    /**
     * @return mixed
     */
    public function getEntitiesByLead(Lead $lead)
    {
        $qb = $this->getEntityManager()->createQueryBuilder();
        $qb->select('cl')
            ->from(EventLead::class, 'cl')
            ->where(
                $qb->expr()->eq('cl.lead', ':lead')
            )->setParameter('lead', $lead);

        return $qb->getQuery()->execute();
    }

    /**
     * Updates leads event name If event name changed and event is primary.
     */
    public function updateLeadsPrimaryEventName(event $event)
    {
        if ($event->isNew() || empty($event->getChanges()['fields']['eventname'])) {
            return;
        }
        $q = $this->getEntityManager()->getConnection()->createQueryBuilder();
        $q->select('cl.lead_id')
            ->from(MAUTIC_TABLE_PREFIX.'events_leads', 'cl');
        $q->where($q->expr()->eq('cl.event_id', ':eventId'))
            ->setParameter(':eventId', $event->getId())
            ->andWhere('cl.is_primary = 1');
        $leadIds = $q->execute()->fetchColumn();
        if (!empty($leadIds)) {
            $this->getEntityManager()->getConnection()->createQueryBuilder()
            ->update(MAUTIC_TABLE_PREFIX.'leads')
            ->set('event', ':event')
            ->setParameter(':event', $event->getName())
            ->where(
                $q->expr()->in('id', $leadIds)
            )->execute();
        }
    }
}
