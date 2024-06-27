<?php

namespace MauticPlugin\MauticEventBundle\Entity;

use Doctrine\DBAL\Query\Expression\CompositeExpression;
use Doctrine\ORM\QueryBuilder;
use Mautic\CoreBundle\Entity\CommonRepository;
use Mautic\LeadBundle\Entity\CustomFieldRepositoryInterface;
use Mautic\LeadBundle\Entity\CustomFieldRepositoryTrait;
use Mautic\LeadBundle\LeadEvents;
use MauticPlugin\MauticEventBundle\Event\EventBuildSearchEvent;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;

/**
 * Class EventRepository.
 */
class EventRepository extends CommonRepository implements CustomFieldRepositoryInterface
{
    use CustomFieldRepositoryTrait;

    /**
     * @var array
     */
    private $availableSearchFields = [];

    /**
     * @var EventDispatcherInterface|null
     */
    private $dispatcher;

    /**
     * Used by search functions to search using aliases as commands.
     */
    public function setAvailableSearchFields(array $fields)
    {
        $this->availableSearchFields = $fields;
    }

    public function setDispatcher(EventDispatcherInterface $dispatcher)
    {
        $this->dispatcher = $dispatcher;
    }

    /**
     * {@inheritdoc}
     *
     * @param int $id
     *
     * @return mixed|null
     */
    public function getEntity($id = 0)
    {
        try {
            $q = $this->createQueryBuilder($this->getTableAlias());
            if (is_array($id)) {
                $this->buildSelectClause($q, $id);
                $eventId = (int) $id['id'];
            } else {
                $eventId = $id;
            }
            $q->andWhere($this->getTableAlias().'.id = '.(int) $eventId);
            $entity = $q->getQuery()->getSingleResult();
        } catch (\Exception $e) {
            $entity = null;
        }

        if (null === $entity) {
            return $entity;
        }

        if ($entity->getFields()) {
            // Pulled from Doctrine memory so don't make unnecessary queries as this has already happened
            return $entity;
        }

        $fieldValues = $this->getFieldValues($id, true, 'event');
        $entity->setFields($fieldValues);

        return $entity;
    }

    /**
     * Get a list of leads.
     *
     * @return array
     */
    public function getEntities(array $args = [])
    {

        $events =  $this->getEntitiesWithCustomFields('event', $args);
        return $events;
    }

    /**
     * @return \Doctrine\DBAL\Query\QueryBuilder
     */
    public function getEntitiesDbalQueryBuilder()
    {
        return $this->getEntityManager()->getConnection()->createQueryBuilder()
            ->from(MAUTIC_TABLE_PREFIX.'events', $this->getTableAlias());
    }

    /**
     * @param $order
     *
     * @return \Doctrine\ORM\QueryBuilder
     */
    public function getEntitiesOrmQueryBuilder($order)
    {
        $q = $this->getEntityManager()->createQueryBuilder();
        $q->select($this->getTableAlias().','.$order)
            ->from('MauticEventBundle:Event', $this->getTableAlias(), $this->getTableAlias().'.id');

        return $q;
    }

    /**
     * Get the groups available for fields.
     *
     * @return array
     */
    public function getFieldGroups()
    {
        return ['core', 'professional', 'other'];
    }

    /**
     * Get events by lead.
     *
     * @param $leadId
     *
     * @return array
     */
    public function getEventsByLeadId($leadId, $eventId = null)
    {
        $q = $this->getEntityManager()->getConnection()->createQueryBuilder();

        $q->select('e.id, e.eventname, e.eventcity, e.eventcountry, cl.is_primary')
            ->from(MAUTIC_TABLE_PREFIX.'events', 'e')
            ->leftJoin('e', MAUTIC_TABLE_PREFIX.'events_leads', 'cl', 'cl.event_id = e.id')
            ->where('cl.lead_id = :leadId')
            ->setParameter('leadId', $leadId)
            ->orderBy('cl.is_primary', 'DESC');

        if ($eventId) {
            $q->andWhere('e.id = :eventId')->setParameter('eventId', $eventId);
        }

        return $q->execute()->fetchAll();
    }

    /**
     * {@inheritdoc}
     */
    public function getTableAlias()
    {
        return 'e';
    }

    /**
     * {@inheritdoc}
     */
    protected function addCatchAllWhereClause($q, $filter)
    {
        return $this->addStandardCatchAllWhereClause(
            $q,
            $filter,
            [
                'e.eventmeeyid',
                'e.eventname',
            ]
        );
    }

    /**
     * {@inheritdoc}
     */
    protected function addSearchCommandWhereClause($q, $filter)
    {
        list($expr, $parameters) = $this->addStandardSearchCommandWhereClause($q, $filter);
        $unique                  = $this->generateRandomParameterName();
        $returnParameter         = true;
        $command                 = $filter->command;

        if (in_array($command, $this->availableSearchFields)) {
            $expr = $q->expr()->like($this->getTableAlias().".$command", ":$unique");
        }

        if ($this->dispatcher) {
            $event = new EventBuildSearchEvent($filter->string, $filter->command, $unique, $filter->not, $q);
            $this->dispatcher->dispatch(LeadEvents::EVENT_BUILD_SEARCH_COMMANDS, $event);
            if ($event->isSearchDone()) {
                $returnParameter = $event->getReturnParameters();
                $filter->strict  = $event->getStrict();
                $expr            = $event->getSubQuery();
                $parameters      = array_merge($parameters, $event->getParameters());
            }
        }

        if ($returnParameter) {
            $string              = ($filter->strict) ? $filter->string : "%{$filter->string}%";
            $parameters[$unique] = $string;
        }

        return [
            $expr,
            $parameters,
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function getSearchCommands()
    {
        $commands = $this->getStandardSearchCommands();
        if (!empty($this->availableSearchFields)) {
            $commands = array_merge($commands, $this->availableSearchFields);
        }

        return $commands;
    }

    /**
     * @param bool   $user
     * @param string $id
     *
     * @return array|mixed
     */
    public function getEvents($user = false, $id = '')
    {
        $q                = $this->_em->getConnection()->createQueryBuilder();
        static $events = [];

        if ($user) {
            $user = $this->currentUser;
        }

        $key = (int) $id;
        if (isset($events[$key])) {
            return $events[$key];
        }

        $q->select('e.*')
            ->from(MAUTIC_TABLE_PREFIX.'events', 'e');

        if (!empty($id)) {
            $q->where(
                $q->expr()->eq('e.id', $id)
            );
        }

        if ($user) {
            $q->andWhere('e.created_by = :user');
            $q->setParameter('user', $user->getId());
        }

        $q->orderBy('e.eventname', 'ASC');

        $results = $q->execute()->fetchAll();

        $events[$key] = $results;

        return $results;
    }

    /**
     * Get a count of leads that belong to the event.
     *
     * @param $eventIds
     *
     * @return array
     */
    public function getLeadCount($eventIds)
    {
        $q = $this->_em->getConnection()->createQueryBuilder();

        $q->select('count(cl.lead_id) as thecount, cl.event_id')
            ->from(MAUTIC_TABLE_PREFIX.'events_leads', 'cl');

        $returnArray = (is_array($eventIds));

        if (!$returnArray) {
            $eventIds = [$eventIds];
        }

        $q->where(
            $q->expr()->in('cl.event_id', $eventIds)
        )
            ->groupBy('cl.event_id');

        $result = $q->execute()->fetchAll();

        $return = [];
        foreach ($result as $r) {
            $return[$r['event_id']] = $r['thecount'];
        }

        // Ensure lists without leads have a value
        foreach ($eventIds as $l) {
            if (!isset($return[$l])) {
                $return[$l] = 0;
            }
        }

        return ($returnArray) ? $return : $return[$eventIds[0]];
    }

    /**
     * Get a list of lists.
     *
     * @param      $eventName
     * @param      $city
     * @param      $country
     * @param null $state
     *
     * @return array
     */
    public function identifyEvent($eventName, $city = null, $country = null, $state = null)
    {
        $q = $this->_em->getConnection()->createQueryBuilder();
        if (empty($eventName)) {
            return [];
        }
        $q->select('e.id, e.eventname, e.eventcity, e.eventcountry, e.eventstate')
            ->from(MAUTIC_TABLE_PREFIX.'events', 'e');

        $q->where(
            $q->expr()->eq('e.eventname', ':eventName')
        )->setParameter('eventName', $eventName);

        if ($city) {
            $q->andWhere(
                $q->expr()->eq('e.eventcity', ':city')
            )->setParameter('city', $city);
        }
        if ($country) {
            $q->andWhere(
                $q->expr()->eq('e.eventcountry', ':country')
            )->setParameter('country', $country);
        }
        if ($state) {
            $q->andWhere(
                $q->expr()->eq('e.eventstate', ':state')
            )->setParameter('state', $state);
        }

        $results = $q->execute()->fetchAll();

        return ($results) ? $results[0] : null;
    }

    /**
     * @return array
     */
    public function getEventsForContacts(array $contacts)
    {
        if (!$contacts) {
            return [];
        }

        $qb = $this->getEntityManager()->getConnection()->createQueryBuilder();
        $qb->select('c.*, l.lead_id, l.is_primary')
            ->from(MAUTIC_TABLE_PREFIX.'events', 'c')
            ->join('c', MAUTIC_TABLE_PREFIX.'events_leads', 'l', 'l.event_id = c.id')
            ->where(
                $qb->expr()->andX(
                    $qb->expr()->in('l.lead_id', $contacts)
                )
            )
            ->orderBy('l.date_added, l.event_id', 'DESC'); // primary should be [0]
        $events = $qb->execute()->fetchAll();

        // Group events per contact
        $contactevents = [];
        foreach ($events as $event) {
            if (!isset($contactevents[$event['lead_id']])) {
                $contactevents[$event['lead_id']] = [];
            }

            $contactevents[$event['lead_id']][] = $event;
        }

        return $contactevents;
    }

    /**
     * Get events grouped by column.
     *
     * @param QueryBuilder $query
     *
     * @return array
     *
     * @throws \Doctrine\ORM\NoResultException
     * @throws \Doctrine\ORM\NonUniqueResultException
     */
    public function getEventsByGroup($query, $column)
    {
        $query->select('count(e.id) as events, '.$column)
            ->addGroupBy($column)
            ->andWhere(
                $query->expr()->andX(
                    $query->expr()->isNotNull($column),
                    $query->expr()->neq($column, $query->expr()->literal(''))
                )
            );

        return $query->execute()->fetchAll();
    }

    /**
     * @param     $query
     * @param int $limit
     * @param int $offset
     *
     * @return mixed
     */
    public function getMostevents($query, $limit = 10, $offset = 0)
    {
        $query->setMaxResults($limit)
            ->setFirstResult($offset);

        return $query->execute()->fetchAll();
    }

    /**
     * @param null   $labelColumn
     * @param string $valueColumn
     *
     * @return array
     */
    public function getAjaxSimpleList(CompositeExpression $expr = null, array $parameters = [], $labelColumn = null, $valueColumn = 'id')
    {
        $q = $this->_em->getConnection()->createQueryBuilder();

        $alias = $prefix = $this->getTableAlias();
        if (!empty($prefix)) {
            $prefix .= '.';
        }

        $tableName = $this->_em->getClassMetadata($this->getEntityName())->getTableName();

        $class      = '\\'.$this->getClassName();
        $reflection = new \ReflectionClass(new $class());

        // Get the label column if necessary
        if (null == $labelColumn) {
            if ($reflection->hasMethod('getTitle')) {
                $labelColumn = 'title';
            } else {
                $labelColumn = 'name';
            }
        }

        $q->select($prefix.$valueColumn.' as value,
        case
        when (e.eventcountry is not null and e.eventcity is not null) then concat(e.eventname, \' <small>\', eventcity,\', \', eventcountry, \'</small>\')
        when (e.eventcountry is not null) then concat(e.eventname, \' <small>\', e.eventcountry, \'</small>\')
        when (e.eventcity is not null) then concat(e.eventname, \' <small>\', e.eventcity, \'</small>\')
        else e.eventname
        end
        as label')
            ->from($tableName, $alias)
            ->orderBy($prefix.$labelColumn);

        if (null !== $expr && $expr->count()) {
            $q->where($expr);
        }

        if (!empty($parameters)) {
            $q->setParameters($parameters);
        }

        // Published only
        if ($reflection->hasMethod('getIsPublished')) {
            $q->andWhere(
                $q->expr()->eq($prefix.'is_published', ':true')
            )
                ->setParameter('true', true, 'boolean');
        }

        return $q->execute()->fetchAll();
    }

    public function getEventsByUniqueFields(array $uniqueFieldsWithData, int $eventId = null, int $limit = null)
    {
        $q = $this->getEntityManager()->getConnection()->createQueryBuilder()
            ->select('c.*')
            ->from(MAUTIC_TABLE_PREFIX.'events', 'c');

        // loop through the fields and
        foreach ($uniqueFieldsWithData as $col => $val) {
            $q->{$this->getUniqueIdentifiersWherePart()}("c.$col = :".$col)
                ->setParameter($col, $val);
        }

        // if we have a lead ID lets use it
        if (!empty($eventId)) {
            // make sure that its not the id we already have
            $q->andWhere('c.id != :eventId')
                ->setParameter('eventId', $eventId);
        }

        if ($limit) {
            $q->setMaxResults($limit);
        }

        $results = $q->execute()->fetchAll();

        // Collect the IDs
        $events = [];
        foreach ($results as $r) {
            $events[$r['id']] = $r;
        }

        // Get entities
        $q = $this->getEntityManager()->createQueryBuilder()
            ->select('c')
            ->from(event::class, 'c');

        $q->where(
            $q->expr()->in('c.id', ':ids')
        )
            ->setParameter('ids', array_keys($events))
            ->orderBy('c.dateAdded', 'DESC')
            ->addOrderBy('c.id', 'DESC');

        $entities = $q->getQuery()
            ->getResult();

        /** @var event $event */
        foreach ($entities as $event) {
            $event->setFields(
                $this->formatFieldValues($events[$event->getId()], true, 'event')
            );
        }

        return $entities;
    }
}
