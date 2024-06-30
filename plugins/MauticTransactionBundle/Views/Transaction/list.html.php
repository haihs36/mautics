<?php

/*
 * @copyright   2014 Mautic Contributors. All rights reserved
 * @author      Mautic
 *
 * @link        http://mautic.org
 *
 * @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */

if ('index' == $tmpl) {
    $view->extend('MauticTransactionBundle:Transaction:index.html.php');
}
?>

<?php if (count($items)): ?>
    <div class="table-responsive page-list">
        <table class="table table-hover table-striped table-bordered transaction-list" id="transactionTable">
            <thead>
            <tr>
                <?php
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'checkall'        => 'true',
                        'target'          => '#transactionTable',
                        'routeBase'       => 'transaction',
                        'templateButtons' => [
                            'delete' => $permissions['lead:leads:deleteother'],
                        ],
                    ]
                );

                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'transaction',
                        'text'       => 'mautic.transaction.code',
                        'class'      => 'col-transaction-code',
                        'orderBy'    => 't.trancode',
                    ]
                );

                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'transaction',
                        'text'       => 'mautic.transaction.meeyid',
                        'class'      => 'col-transaction-name',
                        'orderBy'    => 't.tranmeeyid',
                    ]
                );
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'transaction',
                        'orderBy'    => 't.id',
                        'text'       => 'mautic.core.id',
                        'class'      => 'visible-md visible-lg col-transaction-id',
                    ]
                );
                ?>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($items as $item): ?>
                <?php $fields = $item->getFields();  ?>
                <tr>
                    <td>
                        <?php
                        echo $view->render(
                            'MauticCoreBundle:Helper:list_actions.html.php',
                            [
                                'item'            => $item,
                                'templateButtons' => [
                                    'edit'   => $permissions['lead:leads:editother'],
                                    'clone'  => $permissions['lead:leads:create'],
                                    'delete' => $permissions['lead:leads:deleteother'],
                                ],
                                'routeBase' => 'transaction',
                            ]
                        );
                        ?>
                    </td>
                    <td class="visible-md visible-lg"><?php echo $item->trancode; ?></td>
                    <td class="visible-md visible-lg"><?php echo $item->trannmeeyid; ?></td>
                    <td class="visible-md visible-lg"><?php echo $item->getId(); ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </div>
    <div class="panel-footer">
        <?php echo $view->render(
            'MauticCoreBundle:Helper:pagination.html.php',
            [
                'totalItems' => $totalItems,
                'page'       => $page,
                'limit'      => $limit,
                'menuLinkId' => 'mautic_transaction_index',
                'baseUrl'    => $view['router']->url('mautic_transaction_index'),
                'sessionVar' => 'transaction',
            ]
        ); ?>
    </div>
<?php else: ?>
    <?php echo $view->render(
        'MauticCoreBundle:Helper:noresults.html.php',
        ['tip' => 'mautic.transaction.action.noresults.tip']
    ); ?>
<?php endif; ?>
