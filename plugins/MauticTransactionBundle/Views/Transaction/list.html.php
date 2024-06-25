<?php

if ('index' == $tmpl):
    $view->extend('MauticTransactionBundle:Transaction:index.html.php');
endif;

if (!isset($nameGetter)) {
    $nameGetter = 'getTransaction';
}

$listCommand = $view['translator']->trans('mautic.transaction.searchcommand.list');
?>

<?php if (count($items)): ?>
    <div class="table-responsive">
        <table class="table table-hover table-striped table-bordered" id="tagsTable">
            <thead>
            <tr>
                <?php
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'checkall'        => 'true',
                        'target'          => '#transactionsTable',
                        'langVar'         => 'transaction',
                        'routeBase'       => 'transaction',
                        'templateButtons' => [
                            'delete' => $permissions['transaction:transaction:delete'],
                        ],
                    ]
                );

                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'transactions',
                        'orderBy'    => 't.name',
                        'text'       => 'mautic.core.name',
                        'class'      => 'col-tag-name',
                    ]
                );

                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'transactions',
                        'text'       => 'mautic.lead.list.thead.leadcount',
                        'class'      => 'visible-md visible-lg col-tag-leadcount',
                    ]
                );

                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'transaction',
                        'orderBy'    => 't.id',
                        'text'       => 'mautic.core.id',
                        'class'      => 'visible-md visible-lg col-tag-id',
                    ]
                );
                ?>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($items as $item): ?>
                <?php $mauticTemplateVars['item'] = $item; ?>
                <tr>
                    <td>
                        <?php
                        echo $view->render(
                            'MauticCoreBundle:Helper:list_actions.html.php',
                            [
                                'item'            => $item,
//                                'templateButtons' => [
//                                    'edit'   => $permissions['transaction:transaction:edit'],
//                                    'delete' => $permissions['transaction:transaction:delete'],
//                                ],
                                'routeBase'  => 'transaction',
                                'langVar'    => 'transaction',
                                'nameGetter' => $nameGetter,
                                'custom'     => [
                                    [
                                        'attr' => [
                                            'data-toggle' => 'ajax',
                                            'href'        => $view['router']->path(
                                                'mautic_contact_index',
                                                [
                                                    'search' => "$listCommand:{$item->getTag()}",
                                                ]
                                            ),
                                        ],
                                        'icon'  => 'fa-users',
                                        'label' => 'mautic.lead.list.view_contacts',
                                    ],
                                ],
                            ]
                        );
                        ?>
                    </td>
                    <td>
                        <div>
                            <?php if ($permissions['transaction:transaction:edit']) : ?>
                                <a href="<?php echo $view['router']->path(
                                    'mautic_transaction_action',
                                    ['objectAction' => 'view', 'objectId' => $item->getId()]
                                ); ?>" data-toggle="ajax">
                                    <?php echo $item->getTag(); ?>
                                </a>
                            <?php else : ?>
                                <?php echo $item->getTag(); ?>
                            <?php endif; ?>
                        </div>
                        <?php if ($description = $item->getDescription()): ?>
                            <div class="text-muted mt-4">
                                <small><?php echo $description; ?></small>
                            </div>
                        <?php endif; ?>
                    </td>

                    <td class="visible-md visible-lg">
                        <a class="label label-primary" href="<?php echo $view['router']->path(
                            'mautic_contact_index',
                            ['search' => $view['translator']->trans('mautic.transaction.lead.searchcommand.list').':"'.$item->getTag().'"']
                        ); ?>" data-toggle="ajax"<?php echo (0 == $transactionCount[$item->getId()]) ? 'disabled=disabled' : ''; ?>>
                            <?php echo $view['translator']->trans(
                                'mautic.lead.list.viewleads_count',
                                ['%count%' => $transactionCount[$item->getId()]]
                            ); ?>
                        </a>
                    </td>

                    <td class="visible-md visible-lg"><?php echo $item->getId(); ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
        <div class="panel-footer">
            <?php echo $view->render(
                'MauticCoreBundle:Helper:pagination.html.php',
                [
                    'totalItems' => count($items),
                    'page'       => $page,
                    'limit'      => $limit,
                    'baseUrl'    => $view['router']->path('mautic_transaction_index'),
                    'sessionVar' => 'transaction',
                ]
            ); ?>
        </div>
    </div>
<?php else: ?>
    <?php echo $view->render('MauticCoreBundle:Helper:noresults.html.php'); ?>
<?php endif; ?>
