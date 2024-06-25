
<?php
	
	/*
	 * @copyright   2016 Mautic, Inc. All rights reserved
	 * @author      Mautic, Inc
	 *
	 * @link        https://mautic.org
	 *
	 * @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
	 */
	$view->extend('MauticCoreBundle:Default:content.html.php');
	$view['slots']->set('mauticContent', 'focus');
	$view['slots']->set('headerTitle', $view['translator']->trans('mautic.focus'));
//
//	$view['slots']->set(
//		'actions',
//		$view->render(
//			'MauticCoreBundle:Helper:page_actions.html.php',
//			[
//				'templateButtons' => [
//					'new' => $permissions['focus:items:create'],
//				],
//				'routeBase' => 'focus',
//			]
//		)
//	);

?>

<div class="panel panel-default bdr-t-wdh-0 mb-0">
<!--	--><?php //echo $view->render(
//		'MauticCoreBundle:Helper:list_toolbar.html.php',
//		[
//			'searchValue' => $searchValue,
//			'searchHelp'  => 'mautic.core.help.searchcommands',
//			'action'      => $currentRoute,
//		]
//	); ?>
    <div class="page-list">
		<?php $view['slots']->output('_content'); ?>

        <h1>List of Transactions</h1>
        <ul>
		    <?php foreach ($transactions as $transaction): ?>
                <li><?php echo $transaction->getId(); ?> - <?php echo $transaction->getName(); ?></li>
		    <?php endforeach; ?>
        </ul>
    </div>
</div>
