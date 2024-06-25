<?php
	
	return [
        'name' => 'TransactionBundle',
        'description' => 'Plugin for managing transactions.',
        'version' => '1.0.0',
        'author' => 'Haihs',
		'routes' => [
			'main' => [
				'mautic_transaction_index' => [
					'path' => '/transactions',
					'controller' => 'MauticTransactionBundle:Transaction:index',
					'methods' => ['GET'],
				],
				'mautic_transaction_new' => [
					'path' => '/transactions/new',
					'controller' => 'MauticTransactionBundle:Transaction:new',
					'methods' => ['GET', 'POST'],
				],
			],
		],
		'menu' => [
			'main' => [
				'priority' => 1,
				'items'    => [
					'mautic.transaction.menu.index' => [
                        'priority'  => 89,
                        'bundle'    => 'MauticTransactionBundle',
						'route'     => 'mautic_transaction_index',
						'iconClass' => 'fa-exchange',
						'label'     => 'mautic.transaction.menu',
					],
				],
			],
		],
        'routes_public' => [],
        'menu_parameters' => [],
        'services_parameters' => [],
        'models' => [
            'mautic.transaction.entity.transaction' => [
                'class' => 'MauticPlugin\MauticTransactionBundle\Entity\Transaction',
                'table' => 'transactions',
            ],
            'mautic.transaction.model.transaction' => [
                'class' => 'MauticPlugin\MauticTransactionBundle\Model\TransactionModel',
            ],
        ],
		
	];
