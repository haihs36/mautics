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
    $view->extend('MauticEventBundle:Event:index.html.php');
}
?>

<?php if (count($items)): ?>
    <div class="table-responsive page-list">
        <table class="table table-hover table-striped table-bordered event-list" id="eventTable">
            <thead>
            <tr>
                <?php
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'checkall'        => 'true',
                        'target'          => '#eventTable',
                        'routeBase'       => 'event',
                        'templateButtons' => [
                            'delete' => $permissions['lead:leads:deleteother'],
                        ],
                    ]
                );

                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'text'       => 'mautic.event.meeyid',
                        'class'      => 'col-event-meeyid',
                        'orderBy'    => 'e.eventmeeyid',
                    ]
                );
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'text'       => 'mautic.event.name',
                        'class'      => 'visible-md visible-lg col-event-category',
                        'orderBy'    => 'e.eventname',
                    ]
                );
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'text'       => 'mautic.event.platform',
                        'class'      => 'visible-md visible-lg col-event-website',
                        'orderBy'    => 'e.platform',
                    ]
                );
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'text'       => 'mautic.event.score',
                        'class'      => 'visible-md visible-lg col-event-score',
                        'orderBy'    => 'e.score',
                    ]
                );
                echo $view->render('MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'text'       => 'mautic.lead.list.thead.leadcount',
                        'class'      => 'visible-md visible-lg col-leadlist-leadcount',
                    ]
                );
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'orderBy'    => 'e.id',
                        'text'       => 'mautic.core.id',
                        'class'      => 'visible-md visible-lg col-event-id',
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
                                'routeBase' => 'event',
                            ]
                        );
                        ?>
                    </td>
                    <td>
                        <div>
                            <?php if ($view['security']->hasEntityAccess(
                                       $permissions['lead:leads:editown'],
                                       $permissions['lead:leads:editother'],
                                       $item->getCreatedBy()
                                       )
                                   ): ?>

                            <a href="<?php echo $view['router']->url(
                                'mautic_event_action',
                                ['objectAction' => 'view', 'objectId' => $item->getId()]
                            ); ?>" data-toggle="ajax">
                                <?php if (isset($fields['social']['eventmeeyid'])) : ?>
                                    <?php echo $view->escape($fields['social']['eventmeeyid']['value']); ?>
                                <?php endif; ?>
                            </a>
                        <?php else: ?>
                            <?php if (isset($fields['social']['eventname'])) : ?>
                                <?php echo $view->escape($fields['social']['eventname']['value']); ?>
                            <?php endif; ?>
                        <?php endif; ?>
                        </div>
                    </td>
                    <td>
                        <?php if (isset($fields['social']['eventemail'])): ?>
                        <div class="text-muted mt-4">
                            <small>
                                <?php echo $view->escape($fields['social']['eventemail']['value']); ?>
                            </small>
                        </div>
                        <?php endif; ?>
                    </td>

<!--                    <td class="visible-md visible-lg">-->
<!--                        --><?php //if (isset($fields['core']['eventwebsite'])) :?>
<!--                        --><?php //echo \Mautic\CoreBundle\Helper\InputHelper::url($fields['core']['eventwebsite']['value']); ?>
<!--                        --><?php //endif; ?>
<!--                    </td>-->
                    <td class="visible-md visible-lg">
                        <?php echo $item->getScore(); ?>
                    </td>
                    <td class="visible-md visible-lg">
                        <a class="label label-primary" href="<?php
                        echo $view['router']->path(
                            'mautic_contact_index',
                            [
                                'search' => $view['translator']->trans('mautic.lead.lead.searchcommand.event_id').':'.$item->getId(),
                            ]
                        ); ?>" data-toggle="ajax"<?php echo (0 == $leadCounts[$item->getId()]) ? 'disabled=disabled' : ''; ?>>
                            <?php echo $view['translator']->trans(
                                'mautic.lead.event.viewleads_count',
                                ['%count%' => $leadCounts[$item->getId()]]
                            ); ?>
                        </a>
                    </td>
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
                'menuLinkId' => 'mautic_event_index',
                'baseUrl'    => $view['router']->url('mautic_event_index'),
                'sessionVar' => 'event',
            ]
        ); ?>
    </div>
<?php else: ?>
    <?php echo $view->render(
        'MauticCoreBundle:Helper:noresults.html.php',
        ['tip' => 'mautic.event.action.noresults.tip']
    ); ?>
<?php endif; ?>
