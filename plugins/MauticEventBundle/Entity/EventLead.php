<?php

namespace MauticPlugin\MauticEventBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Mautic\CoreBundle\Doctrine\Mapping\ClassMetadataBuilder;
use MauticPlugin\MauticSocialBundle\Entity\Lead;

class EventLead
{
    /**
     * @var Event
     **/
    private $event;

    /**
     * @var Lead
     */
    private $lead;

    /**
     * @var \DateTime
     */
    private $dateAdded;

    /**
     * @var bool
     */
    private $primary = false;

    public static function loadMetadata(ORM\ClassMetadata $metadata)
    {
        $builder = new ClassMetadataBuilder($metadata);

        $builder->setTable('events_leads')
            ->setCustomRepositoryClass(EventLeadRepository::class);

        $builder->createManyToOne('event', 'Event')
            ->isPrimaryKey()
            ->addJoinColumn('event_id', 'id', false, false, 'CASCADE')
            ->build();

        $builder->addLead(false, 'CASCADE', true);

        $builder->addDateAdded();

        $builder->createField('primary', 'boolean')
            ->columnName('is_primary')
            ->nullable()
            ->build();
    }

    /**
     * @return \DateTime
     */
    public function getDateAdded()
    {
        return $this->dateAdded;
    }

    /**
     * @param \DateTime $date
     */
    public function setDateAdded($date)
    {
        $this->dateAdded = $date;
    }

    /**
     * @return mixed
     */
    public function getLead()
    {
        return $this->lead;
    }

    /**
     * @param mixed $lead
     */
    public function setLead($lead)
    {
        $this->lead = $lead;
    }

    /**
     * @return Event
     */
    public function getEvent()
    {
        return $this->event;
    }

    /**
     * @return Event
     */
    public function getEvents()
    {
        return $this->event;
    }

    /**
     * @param Event $event
     */
    public function setEvent($event)
    {
        $this->event = $event;
    }

    /**
     * @param bool $primary
     */
    public function setPrimary($primary)
    {
        $this->primary = $primary;
    }

    /**
     * @return bool
     */
    public function getPrimary()
    {
        return $this->primary;
    }
}
