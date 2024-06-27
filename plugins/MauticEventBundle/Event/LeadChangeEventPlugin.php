<?php

namespace MauticPlugin\MauticEventBundle\Event;

use Symfony\Component\EventDispatcher\Event as EventDispatcher;
use MauticPlugin\MauticEventBundle\Entity\Event ;
use Mautic\LeadBundle\Entity\Lead;

/**
 * Class LeadChangeEventPlugin.
 */
class LeadChangeEventPlugin extends EventDispatcher
{
    private $lead;
    private $leads;
    private $event;
    private $added;

    public function __construct($leads, Event $event, $added = true)
    {
        if (is_array($leads)) {
            $this->leads = $leads;
        } else {
            $this->lead = $leads;
        }
        $this->event = $event;
        $this->added   = $added;
    }

    /**
     * Returns the Lead entity.
     *
     * @return Lead
     */
    public function getLead()
    {
        return $this->lead;
    }

    /**
     * Returns batch array of leads.
     *
     * @return array
     */
    public function getLeads()
    {
        return $this->leads;
    }

    /**
     * @return Event/Event
     */
    public function getEvent()
    {
        return $this->event;
    }

    /**
     * @return bool
     */
    public function wasAdded()
    {
        return $this->added;
    }

    /**
     * @return bool
     */
    public function wasRemoved()
    {
        return !$this->added;
    }
}
