<?php

namespace MauticPlugin\MauticEventBundle\Event;

use Mautic\CoreBundle\Event\CommonEvent;
use MauticPlugin\MauticEventBundle\Entity\Event;

/**
 * Class EventPluginEvent.
 */
class EventPluginEvent extends CommonEvent
{
    /**
     * @var int
     */
    protected $score;

    /**
     * @param bool $isNew
     * @param int  $score
     */
    public function __construct(Event $event, $isNew = false, $score = 0)
    {
        $this->entity = $event;
        $this->isNew  = $isNew;
        $this->score  = $score;
    }

    /**
     * Returns the event entity.
     *
     * @return Event
     */
    public function getEvent()
    {
        return $this->entity;
    }

    /**
     * Sets the event entity.
     */
    public function setEvent(Event $event)
    {
        $this->entity = $event;
    }

    public function changeScore($score)
    {
        $this->score = $score;
    }

    public function getScore()
    {
        return $this->score;
    }
}
