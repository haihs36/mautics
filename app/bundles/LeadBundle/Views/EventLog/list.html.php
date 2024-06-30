<?php

/*
 * @copyright   2014 Mautic Contributors. All rights reserved
 * @author      Mautic
 *
 * @link        http://mautic.org
 *
 * @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */
if (isset($tmpl) && 'index' == $tmpl) {
//    $view->extend('MauticLeadBundle:EventLog:index.html.php');
}

$baseUrl = $view['router']->path(
    'mautic_contact_eventlog_action',
    [
        'leadId' => $lead->getId(),
    ]
);
?>

<!-- eventlog -->
<div class="table-responsive">
    <table class="table table-hover table-bordered" id="contact-eventlog">
        <thead>
        <tr>
            <th class="timeline-icon">
                <a class="btn btn-sm btn-nospin btn-default" data-activate-details="all" data-toggle="tooltip" title="<?php echo $view['translator']->trans(
                    'mautic.lead.timeline.toggle_all_details'
                ); ?>">
                    <span class="fa fa-fw fa-level-down"></span>
                </a>
            </th>
            <?php
            echo $view->render('MauticCoreBundle:Helper:tableheader.html.php', [
	            'orderBy'    => 'e.eventname',
	            'text'       => 'mautic.event.name',
                'class'      => 'timeline-name',
                'sessionVar' => 'lead.'.$lead->getId().'.eventlog',
                'baseUrl'    => $baseUrl,
                'target'     => '#eventlog-table',
            ]);

            echo $view->render('MauticCoreBundle:Helper:tableheader.html.php', [
                'orderBy'    => 'action',
	            'text'       => 'mautic.event.platform',
                'class'      => 'visible-md visible-lg timeline-type',
                'sessionVar' => 'lead.'.$lead->getId().'.eventlog',
                'baseUrl'    => $baseUrl,
                'target'     => '#eventlog-table',
            ]);

            echo $view->render('MauticCoreBundle:Helper:tableheader.html.php', [
                'orderBy'    => 'dateAdded',
                'text'       => 'mautic.lead.timeline.event_timestamp',
                'class'      => 'visible-md visible-lg timeline-timestamp',
                'sessionVar' => 'lead.'.$lead->getId().'.eventlog',
                'baseUrl'    => $baseUrl,
                'target'     => '#eventlog-table',
            ]);
            ?>
        </tr>
        <tbody>
        <?php if(!empty($events['events'])): foreach ($events['events'] as $counter => $event): ?>
            <?php
            ++$counter; // prevent 0
            $icon       = (isset($event['icon'])) ? $event['icon'] : 'fa-history';

            $details = '';

            $rowStripe = (0 === $counter % 2) ? ' timeline-row-highlighted' : '';
            ?>
            <tr class="timeline-row<?php echo $rowStripe; ?><?php if (!empty($event['featured'])) {
                echo ' timeline-featured';
            } ?>">
                <td class="timeline-icon">
                    <a href="javascript:void(0);" data-activate-details="<?php echo $counter; ?>" class="btn btn-sm btn-nospin btn-default<?php if (empty($details)) {
                echo ' disabled';
            } ?>" data-toggle="tooltip" title="<?php echo $view['translator']->trans('mautic.lead.timeline.toggle_details'); ?>">
                     <?= $counter ?>
                    </a>
                </td>
                <td class="timeline-name"><?php echo $event['eventname']; ?></td>
                <td class="timeline-type"><?php echo $event['eventplatform']; ?>
           </td>
                <td class="timeline-timestamp"><?php echo $view['date']->toText($event['date_added'], 'local', 'Y-m-d H:i:s', true); ?></td>
            </tr>
            <?php if (!empty($details)): ?>
                <tr class="timeline-row<?php echo $rowStripe; ?> timeline-details hide" id="eventlog-details-<?php echo $counter; ?>">
                    <td colspan="4">
                        <?php echo $details; ?>
                    </td>
                </tr>
            <?php endif; ?>
        <?php endforeach; ?>
        <?php endif; ?>
        </tbody>
    </table>
</div>
<?php /*echo $view->render(
    'MauticCoreBundle:Helper:pagination.html.php',
    [
        'page'       => $events['page'],
        'fixedPages' => $events['maxPages'],
        'fixedLimit' => true,
        'baseUrl'    => $baseUrl,
        'target'     => '#eventlog-table',
        'totalItems' => $events['total'],
    ]
); */?>

<!--/ eventlog -->