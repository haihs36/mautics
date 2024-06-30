<?php

if ('index' == $tmpl) {
    $view->extend('MauticEventBundle:Event:index.html.php');
}
?>

<?php if (count($items)):  ?>
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
                        'text'       => 'mautic.event.name',
                        'class'      => 'col-event-name',
                        'orderBy'    => 'e.eventname',
                    ]
                );
                echo $view->render(
                    'MauticCoreBundle:Helper:tableheader.html.php',
                    [
                        'sessionVar' => 'event',
                        'text'       => 'mautic.event.meeyid',
                        'class'      => 'visible-md visible-lg col-event-category',
                        'orderBy'    => 'e.eventmeeyid',
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
            <?php foreach ($items as $item):  ?>
                <?php $fields = $item->getFields(); ?>
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
                                    <?php if (($item->eventname)) : ?>
                                        <?php echo $view->escape($item->eventname) ?>
                                    <?php endif; ?>
                                </a>
                            <?php else: ?>
	                            <?php if ($item->eventname) : ?>
		                            <?php echo $view->escape($item->eventname) ?>
                                <?php endif; ?>
                            <?php endif; ?>
                        </div>
                    </td>
                    <td>
	                    <?php if ($item->eventmeeyid) : ?>
                        <div class="text-muted mt-4">
                            <small>
	                            <?php echo $view->escape($item->eventmeeyid) ?>
                            </small>
                        </div>
                        <?php endif; ?>
                    </td>

                    <td class="visible-md visible-lg">
                        <?php if (isset($fields['core']['eventplatform'])) :?>
                        <?php echo $fields['core']['eventplatform']['value']; ?>
                        <?php endif; ?>
                    </td>
                    <td class="visible-md visible-lg">
                        <?php echo $item->getScore(); ?>
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
