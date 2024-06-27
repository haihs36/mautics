<?php

namespace MauticPlugin\MauticEventBundle\EventListener;

use Mautic\CoreBundle\Helper\IpLookupHelper;
use Mautic\CoreBundle\Model\AuditLogModel;
use MauticPlugin\MauticEventBundle\Event as Events;

use MauticPlugin\MauticEventBundle\LeadEventPlugins;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class EventSubscriber implements EventSubscriberInterface
{
    /**
     * @var AuditLogModel
     */
    private $auditLogModel;

    /**
     * @var IpLookupHelper
     */
    private $ipLookupHelper;

    public function __construct(IpLookupHelper $ipLookupHelper, AuditLogModel $auditLogModel)
    {
        $this->ipLookupHelper = $ipLookupHelper;
        $this->auditLogModel  = $auditLogModel;
    }

    /**
     * @return array
     */
    public static function getSubscribedEvents()
    {
        return [
            LeadEventPlugins::EVENT_PLUGIN_POST_SAVE   => ['onEventPostSave', 0],
            LeadEventPlugins::EVENT_PLUGIN_POST_DELETE => ['onEventDelete', 0],
        ];
    }

    /**
     * Add a event entry to the audit log.
     */
    public function onEventPostSave(Events\EventPluginEvent $event)
    {
        $event = $event->getEvent();
        if ($details = $event->getChanges()) {
            $log = [
                'bundle'    => 'lead',
                'object'    => 'event',
                'objectId'  => $event->getId(),
                'action'    => ($event->isNew()) ? 'create' : 'update',
                'details'   => $details,
                'ipAddress' => $this->ipLookupHelper->getIpAddressFromRequest(),
            ];
            $this->auditLogModel->writeToLog($log);
        }
    }

    /**
     * Add a event delete entry to the audit log.
     */
    public function onEventDelete(Events\EventPluginEvent $event)
    {
        $event = $event->getEvent();
        $log     = [
            'bundle'    => 'lead',
            'object'    => 'event',
            'objectId'  => $event->deletedId,
            'action'    => 'delete',
            'details'   => ['name', $event->getPrimaryIdentifier()],
            'ipAddress' => $this->ipLookupHelper->getIpAddressFromRequest(),
        ];
        $this->auditLogModel->writeToLog($log);
    }

}
