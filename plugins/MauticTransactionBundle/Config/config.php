<?php

return [
    'name' => 'Mautic transaction bundle',
    'description' => 'Provides an interface for management.',
    'version' => '1.0',
    'author' => 'Admin',
    'routes' => [
        'main' => [
            'mautic_transaction_index' => [
                'path' => '/transactions/{page}',
                'controller' => 'MauticTransactionBundle:Transaction:index',
            ],
            'mautic_transaction_action' => [
                'path' => '/transactions/{objectAction}/{objectId}',
                'controller' => 'MauticTransactionBundle:Transaction:execute',
            ],
            'mautic_transaction_import_action' => [
                'path'       => 'import/{object}/{objectAction}/{objectId}',
                'controller' => 'MauticTransactionBundle:Import:execute',
            ],
            'mautic_transaction_import_index' => [
                'path'       => 'import/{object}/{page}',
                'controller' => 'MauticTransactionBundle:Import:index',
            ],
        ],
        'api' => [
            'mautic_api_transactionstandard' => [
                'standard_entity' => true,
                'name'            => 'transactions',
                'path'            => '/transactions',
                'controller'      => 'MauticTransactionBundle:Api\Transaction:index',
                'method'          => 'GET',
            ],
            'mautic_api_add_transaction' => [
                'name' => 'add-transaction',
                'path' => '/transactions/add-transaction',
                'controller' => 'MauticTransactionBundle:Api\Transaction:addTransaction',
                'method' => 'POST',
            ],
        ]
    ],
    'services' => [
        'integrations' => [
            'mautic.integration.transaction' => [
                'class' => \MauticPlugin\MauticTransactionBundle\Integration\TransactionIntegration::class,
                'arguments' => [
                    'event_dispatcher',
                    'mautic.helper.cache_storage',
                    'doctrine.orm.entity_manager',
                    'session',
                    'request_stack',
                    'router',
                    'translator',
                    'logger',
                    'mautic.helper.encryption',
                    'mautic.lead.model.lead',
                    'mautic.lead.model.company',
                    'mautic.helper.paths',
                    'mautic.core.model.notification',
                    'mautic.lead.model.field',
                    'mautic.plugin.model.integration_entity',
                    'mautic.lead.model.dnc',
                ],
            ],
            'mautic.transaction.import.subscriber' => [
                'class'     => \MauticPlugin\MauticTransactionBundle\EventListener\ImportSubscriber::class,
                'arguments' => [
                    'mautic.lead.field.field_list',
                    'mautic.security',
                    'mautic.transaction.model.transaction',
                    'translator',
                ],
                'tag'      => 'kernel.event_subscriber',
            ],
        ],
        'repositories' => [
            'mautic.transaction.repository.transaction' => [
                'class' => Doctrine\ORM\EntityRepository::class,
                'factory' => ['@doctrine.orm.entity_manager', 'getRepository'],
                'arguments' => [
                    \MauticPlugin\MauticTransactionBundle\Entity\Transaction::class,
                ],
            ],
        ],
        'models' => [
            'mautic.transaction.model.transaction' => [
                'class' => \MauticPlugin\MauticTransactionBundle\Model\TransactionModel::class,
                'arguments' => [
                    'mautic.lead.model.field',
                    'session',
                    'mautic.validator.email',
                    'mautic.company.deduper',
                ],
            ],
        ],
        'forms' => [
            'mautic.transaction.type.form' => [
                'class'     => \MauticPlugin\MauticTransactionBundle\Form\Type\TransactionType::class,
                'arguments' => ['doctrine.orm.entity_manager', 'router', 'translator'],
            ],
        ],
    ],
    'menu' => [
        'main' => [
            'transaction.menu.index' => [
                'id' => 'mautic_transaction_index',
                'route' => 'mautic_transaction_index',
                'iconClass' => 'fa-exchange',
                //                'access' => 'transaction:transaction:view',
                'priority' => 1,
            ],
        ],

    ],
];