<?php


$view->extend('MauticCoreBundle:Default:content.html.php');
$view['slots']->set('mauticContent', 'transactions');
$view['slots']->set('headerTitle', $view['translator']->trans('mautic.transaction.header.index'));

$view['slots']->set(
    'actions',
    $view->render(
        'MauticCoreBundle:Helper:page_actions.html.php',
        [
            'templateButtons' => [
                'new' => $view['security']->isGranted('tagManager:tagManager:create'),
            ],
            'routeBase' => 'tagmanager',
            'langVar'   => 'transactions.list',
        ]
    )
);
?>

<div class="panel panel-default bdr-t-wdh-0">
    <?php echo $view->render(
        'MauticCoreBundle:Helper:list_toolbar.html.php',
        [
            'searchValue' => $searchValue,
            'searchHelp'  => 'mautic.lead.list.help.searchcommands',
            'action'      => $currentRoute,
        ]
    ); ?>
    <div class="page-list">
        <?php $view['slots']->output('_content'); ?>
    </div>
</div>
