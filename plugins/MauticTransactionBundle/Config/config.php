<?php

return [
    'name'        => 'Mautic transaction bundle',
    'description' => 'Provides an interface for management.',
    'version'     => '1.0',
    'author'      => 'Admin',
    'routes'      => [
        'main' => [
            'mautic_transaction_index' => [
                'path'       => '/transactions/{page}',
                'controller' => 'MauticTransactionBundle:Transaction:index',
            ],
            'mautic_transaction_action' => [
                'path'       => '/transactions/{objectAction}/{objectId}',
                'controller' => 'MauticTransactionBundle:Transaction:execute',
            ],
        ],
    ],
    'services'    => [
        'integrations' => [
            'mautic.integration.transaction' => [
                'class'     => \MauticPlugin\MauticTransactionBundle\Integration\TransactionIntegration::class,
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
        ],
        'repositories' => [
            'mautic.transaction.repository.transaction' => [
                'class'     => Doctrine\ORM\EntityRepository::class,
                'factory'   => ['@doctrine.orm.entity_manager', 'getRepository'],
                'arguments' => [
                    \MauticPlugin\MauticTransactionBundle\Entity\Transaction::class,
                ],
            ],
        ],
        'models' => [
            'mautic.transaction.model.transaction' => [
                'class'     => \MauticPlugin\MauticTransactionBundle\Model\TransactionModel::class,
                'arguments' => [
                    'service_container',
                ],
            ],
        ],
    ],
    'menu' => [
        'main' => [
            'transaction.menu.index' => [
                'id'        => 'mautic_transaction_index',
                'route'     => 'mautic_transaction_index',
                'iconClass' => 'fa-exchange',
                'access'    => 'transaction:transaction:view',
                'priority'  => 1,
            ],
        ],
    ],
  ];
