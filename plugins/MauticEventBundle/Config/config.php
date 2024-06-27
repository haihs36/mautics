<?php

return [
    'routes' => [
        'main' => [
            'mautic_event_index' => [
                'path'       => '/events/{page}',
                'controller' => 'MauticEventBundle:Event:index',
            ],
            'mautic_event_contacts_list' => [
                'path'         => '/event/{objectId}/contacts/{page}',
                'controller'   => 'MauticEventBundle:Event:contactsList',
                'requirements' => [
                    'objectId' => '\d+',
                ],
            ],
            'mautic_event_action' => [
                'path'       => '/events/{objectAction}/{objectId}',
                'controller' => 'MauticEventBundle:Event:execute',
            ],
            'mautic_event_export_action' => [
                'path'         => '/events/event/export/{eventId}',
                'controller'   => 'MauticEventBundle:Event:EventExport',
                'requirements' => [
                    'eventId' => '\d+',
                ],
            ],
        ],
        'api' => [
            'mautic_api_eventsstandard' => [
                'standard_entity' => true,
                'name'            => 'events',
                'path'            => '/events',
                'controller'      => 'MauticEventBundle:Api\EventApi',
            ],
            'mautic_api_eventaddcontact' => [
                'path'       => '/events/{eventId}/contact/{contactId}/add',
                'controller' => 'MauticEventBundle:Api\EventApi:addContact',
                'method'     => 'POST',
            ],
            'mautic_api_eventremovecontact' => [
                'path'       => '/events/{eventId}/contact/{contactId}/remove',
                'controller' => 'MauticEventBundle:Api\EventApi:removeContact',
                'method'     => 'POST',
            ],
        ],
    ],
    'menu' => [
        'main' => [
            'items' => [
                'mautic.event.menu.index' => [
                    'route'     => 'mautic_event_index',
                    'iconClass' => 'fa fa-calendar',
                    'access'    => ['lead:leads:viewother'],
                    'priority'  => 1,
                ],
            ],
        ],
//        'admin' => [
//            'priority' => 50,
//            'items'    => [
//                'mautic.lead.field.menu.index' => [
//                    'id'        => 'mautic_lead_field',
//                    'iconClass' => 'fa-list',
//                    'route'     => 'mautic_contactfield_index',
//                    'access'    => 'lead:fields:full',
//                ],
//            ],
//        ],
    ],
//    'categories' => [
//        'segment' => null,
//    ],
    'services' => [
        'events' => [
            'mautic.lead.import.event.subscriber' => [
                'class'     => MauticPlugin\MauticEventBundle\EventListener\ImportEventSubscriber::class,
                'arguments' => [
                    'mautic.lead.field.field_list',
                    'mautic.security',
                    'mautic.lead.model.event',
                    'translator',
                ],
            ],
        ],
        'forms' => [
            'mautic.form.type.updateevent_action' => [
                'class'     => MauticPlugin\MauticEventBundle\Form\Type\UpdateEventActionType::class,
                'arguments' => ['mautic.lead.model.field'],
            ],
            'mautic.event.type.form' => [
                'class'     => \MauticPlugin\MauticEventBundle\Form\Type\EventType::class,
                'arguments' => ['doctrine.orm.entity_manager', 'router', 'translator'],
            ],
            'mautic.event.campaign.action.type.form' => [
                'class'     => \MauticPlugin\MauticEventBundle\Form\Type\AddToEventActionType::class,
                'arguments' => ['router'],
            ],
            'mautic.event.list.type.form' => [
                'class'     => \MauticPlugin\MauticEventBundle\Form\Type\EventListType::class,
                'arguments' => [
                    'mautic.lead.model.event',
                    'mautic.helper.user',
                    'translator',
                    'router',
                    'database_connection',
                ],
            ],
            'mautic.event.merge.type.form' => [
                'class' => \MauticPlugin\MauticEventBundle\Form\Type\EventMergeType::class,
            ],
            'mautic.form.type.event_change_score' => [
                'class' => \MauticPlugin\MauticEventBundle\Form\Type\EventChangeScoreActionType::class,
            ],
        ],
        'other' => [
            'mautic.event.deduper' => [
                'class'     => \MauticPlugin\MauticEventBundle\Deduplicate\EventDeduper::class,
                'arguments' => [
                    'mautic.lead.model.field',
                    'mautic.lead.repository.event',
                ],
            ],
            'mautic.lead.helper.primary_event' => [
                'class'     => \MauticPlugin\MauticEventBundle\Helper\PrimaryEventHelper::class,
                'arguments' => [
                    'mautic.lead.repository.event_lead',
                ],
            ],
            
        ],
        'repositories' => [
            'mautic.lead.repository.event' => [
                'class'     => Doctrine\ORM\EntityRepository::class,
                'factory'   => ['@doctrine.orm.entity_manager', 'getRepository'],
                'arguments' => [
                    \MauticPlugin\MauticEventBundle\Entity\Event::class,
                ],
                'methodCalls' => [
                    'setUniqueIdentifiersOperator' => [
                        '%mautic.event_unique_identifiers_operator%',
                    ],
                ],
            ],
            'mautic.lead.repository.event_lead' => [
                'class'     => Doctrine\ORM\EntityRepository::class,
                'factory'   => ['@doctrine.orm.entity_manager', 'getRepository'],
                'arguments' => [
                    \MauticPlugin\MauticEventBundle\Entity\EventLead::class,
                ],
            ],
        ],
        'models' => [
            'mautic.lead.model.event' => [
                'class'     => 'MauticPlugin\MauticEventBundle\Model\EventModel',
                'arguments' => [
                    'mautic.lead.model.field',
                    'session',
                    'mautic.validator.email',
                    'mautic.event.deduper',
                ],
            ],
            'mautic.lead.model.event_report_data' => [
                'class'     => \MauticPlugin\MauticEventBundle\Model\EventReportData::class,
                'arguments' => [
                    'mautic.lead.model.field',
                    'translator',
                ],
            ],
        ],
    ],
    'parameters' => [
        'parallel_import_limit'               => 1,
        'background_import_if_more_rows_than' => 0,
        'contact_columns'                     => [
            '0' => 'name',
            '1' => 'email',
            '2' => 'location',
            '3' => 'stage',
            '4' => 'points',
            '5' => 'last_active',
            '6' => 'id',
        ],
        'event_unique_identifiers_operator'                                                   => \Doctrine\DBAL\Query\Expression\CompositeExpression::TYPE_OR,
        'contact_unique_identifiers_operator'                                                   => \Doctrine\DBAL\Query\Expression\CompositeExpression::TYPE_OR,
        'segment_rebuild_time_warning'                                                          => 30,
    ],
];
