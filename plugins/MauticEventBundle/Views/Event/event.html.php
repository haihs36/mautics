<?php

/*
 * @copyright   2020 Mautic Contributors. All rights reserved
 * @author      Mautic
 *
 * @link        http://mautic.org
 *
 * @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */

/** @var \MauticPlugin\MauticEventBundle\Entity\Event $event */
/** @var array $fields */
$view->extend('MauticCoreBundle:Default:content.html.php');

$view['slots']->set(
    'headerTitle',
    $view->escape($event->getName())
);

$groups = array_keys($fields);
$edit   = $view['security']->hasEntityAccess(
    $permissions['lead:leads:editown'],
    $permissions['lead:leads:editother'],
    $event->getPermissionUser()
);

$buttons = [];

//Merge button
$merge = $view['security']->hasEntityAccess(
    $permissions['lead:leads:deleteown'],
    $permissions['lead:leads:deleteother'],
    $event->getPermissionUser()
);
if ($merge && $edit) {
    $buttons[] = [
        'attr' => [
            'data-toggle' => 'ajaxmodal',
            'data-target' => '#MauticSharedModal',
            'data-header' => $view['translator']->trans(
                'mautic.lead.event.header.merge',
                ['%name%' => $view->escape($event->getPrimaryIdentifier())]
            ),
            'href' => $view['router']->path(
                'mautic_event_action',
                ['objectId' => $event->getId(), 'objectAction' => 'merge']
            ),
        ],
        'btnText'   => $view['translator']->trans('mautic.lead.merge'),
        'iconClass' => 'fa fa-user',
    ];
}

//Download button
if ($view['security']->hasEntityAccess(
    $permissions['lead:leads:viewown'],
    $permissions['lead:leads:viewother'],
    $event->getPermissionUser()
)
) {
    $buttons[] = [
        'attr' => [
            'data-toggle'=> 'download',
            'href'       => $view['router']->path(
                'mautic_event_export_action',
                ['eventId' => $event->getId()]
            ),
        ],
        'btnText'   => $view['translator']->trans('mautic.core.export'),
        'iconClass' => 'fa fa-download',
    ];
}

$view['slots']->set(
    'actions',
    $view->render(
        'MauticCoreBundle:Helper:page_actions.html.php',
        [
            'item'            => $event,
            'routeBase'       => 'event',
            'langVar'         => 'event',
            'customButtons'   => $buttons,
            'templateButtons' => [
                'edit'   => $edit,
                'delete' => $view['security']->hasEntityAccess(
                    $permissions['lead:leads:deleteown'],
                    $permissions['lead:leads:deleteother'],
                    $event->getPermissionUser()
                ),
                'close' => $view['security']->hasEntityAccess(
                    $permissions['lead:leads:viewown'],
                    $permissions['lead:leads:viewother'],
                    $event->getPermissionUser()
                ),
            ],
        ]
    )
);

?>

<!-- start: box layout -->
<div class="box-layout">
    <!-- left section -->
    <div class="col-md-9 bg-white height-auto">
        <div class="bg-auto">
            <!--/ lead detail header -->
            <!-- lead detail collapseable -->
            <div class="collapse" id="lead-details">
                <ul class="pt-md nav nav-tabs pr-md pl-md" role="tablist">
                    <?php $step = 0; ?>
                    <?php foreach ($groups as $g) : ?>
                        <?php if (!empty($fields[$g])) : ?>
                            <li class="<?php echo (0 === $step) ? 'active' : ''; ?>">
                                <a href="#<?php echo $g; ?>" class="group" data-toggle="tab">
                                    <?php echo $view['translator']->trans('mautic.lead.field.group.'.$g); ?>
                                </a>
                            </li>
                            <?php ++$step; ?>
                        <?php endif; ?>
                    <?php endforeach; ?>
                </ul>

                <!-- start: tab-content -->
                <div class="tab-content pa-md bg-white">
                    <?php $i = 0; ?>
                    <?php foreach ($groups as $group): ?>
                        <div class="tab-pane fade <?php echo 0 == $i ? 'in active' : ''; ?> bdr-w-0" id="<?php echo $group; ?>">
                            <div class="pr-md pl-md pb-md">
                                <div class="panel shd-none mb-0">
                                    <table class="table table-bordered table-striped mb-0">
                                        <tbody>
                                        <?php foreach ($fields[$group] as $field) : ?>
                                            <?php if (isset($field['value'])): ?>
                                                <tr>
                                                    <td width="20%"><span class="fw-b"><?php echo $view->escape($field['label']); ?></span>
                                                    </td>
                                                    <td>
                                                        <?php if ('core' == $group && 'country' == $field['alias'] && !empty($flag)) : ?>
                                                        <img class="mr-sm" src="<?php echo $flag; ?>" alt="" style="max-height: 24px;"/>
                                                        <span class="mt-1"><?php echo $view->escape($field['value']); ?>
                                                            <?php else : ?>
                                                                <?php if (is_array($field['value']) && 'multiselect' === $field['type']) : ?>
                                                                    <?php echo implode(', ', $field['value']); ?>
                                                                <?php elseif (is_string($field['value']) && 'url' === $field['type']) : ?>
                                                                    <a href="<?php echo $view->escape($field['value']); ?>" target="_blank">
                                                                <?php echo $field['value']; ?>
                                                            </a>
                                                                <?php else : ?>
                                                                    <?php echo $view->escape($field['normalizedValue']); ?>
                                                                <?php endif; ?>
                                                            <?php endif; ?>
                                                    </td>
                                                </tr>
                                            <?php endif; ?>
                                        <?php endforeach; ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <?php ++$i; ?>
                    <?php endforeach; ?>
                </div>
            </div>
            <!--/ lead detail collapseable -->
        </div>

        <div class="bg-auto bg-dark-xs">
            <!-- lead detail collapseable toggler -->
            <div class="hr-expand nm">
                <span data-toggle="tooltip" title="<?php echo $view['translator']->trans('mautic.core.details'); ?>">
                    <a href="javascript:void(0)" class="arrow text-muted collapsed" data-toggle="collapse" data-target="#lead-details">
                       <span class="caret"></span>
                       <?php echo $view['translator']->trans('mautic.core.details'); ?>
                    </a>
                </span>
            </div>
            <!--/ lead detail collapseable toggler -->
        </div>

        <div class="pa-md enage">
            <div class="row">
                <div class="col-sm-12">
                    <div class="panel">
                        <div class="panel-body box-layout">
                            <div class="col-xs-8 va-m">
                                <h5 class="text-white dark-md fw-sb mb-xs">
                                    <?php echo $view['translator']->trans('mautic.event.field.header.engagements'); ?>
                                </h5>
                            </div>
                            <div class="col-xs-4 va-t text-right">
                                <h3 class="text-white dark-sm"><span class="fa fa-eye"></span></h3>
                            </div>
                        </div>
                        <?php echo $view->render(
                            'MauticCoreBundle:Helper:chart.html.php',
                            ['chartData' => $engagementData, 'chartType' => 'line', 'chartHeight' => 250]
                        ); ?>
                    </div>
                </div>
            </div>
        </div>

<!--         contacts section-->
        <div class="pa-md enage">
            <div class="row">
                <div class="col-sm-12">
                    <div id="contacts-table">
                        <?php echo $view->render(
                            'MauticEventBundle:Event:list_rows_contacts.html.php',
                            [
                                'contacts'    => $items,
                                'event'     => $event,
                                'tmpl'        => 'index',
                                'permissions' => $permissions,
                                'security'    => $security,
                                'page'        => $page,
                                'limit'       => $limit,
                                'totalItems'  => $totalItems,
                            ]
                        ); ?>
                    </div>
                </div>
            </div>
        </div>
        <!--/ contacts section -->

        <!--/ end: tab-content -->
    </div>

    <!--/ left section -->

    <!-- right section -->
    <div class="col-md-3 bg-white bdr-l height-auto">
        <!-- form HTML -->
        <div class="panel bg-transparent shd-none bdr-rds-0 bdr-w-0 mb-0">
            <div class="mt-sm points-panel text-center">
                <h1>
                    <?php echo $view['translator']->trans(
                        'mautic.event.score',
                        ['%count%' => $event->getScore()]
                    ); ?>
                </h1>
                <hr/>
            </div>
            <div class="panel-heading">
                <div class="panel-title">
                    <?php echo $view['translator']->trans('mautic.event.event'); ?>
                </div>
            </div>
            <div class="panel-body pt-sm">
            <?php if ($event->getOwner()) : ?>
                <h6 class="fw-sb"><?php echo $view['translator']->trans('mautic.lead.event.field.owner'); ?></h6>
                <p class="text-muted"><?php echo $view->escape($event->getOwner()->getName()); ?></p>
            <?php endif; ?>

                <h6 class="fw-sb">
                    <?php echo $view['translator']->trans('mautic.lead.field.address'); ?>
                </h6>
            </div>
        </div>
        <!--/ form HTML -->
    </div>
    <!--/ right section -->
</div>
<!--/ end: box layout -->
