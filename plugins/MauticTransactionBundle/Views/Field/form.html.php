<?php echo $view['form']->start($form); ?>
<div class="panel panel-default">
	<div class="panel-heading">
		<h3 class="panel-title">Add Custom Field</h3>
	</div>
	<div class="panel-body">
		<?php echo $view['form']->row($form['name']); ?>
		<?php echo $view['form']->row($form['label']); ?>
		<?php echo $view['form']->row($form['type']); ?>
		<?php echo $view['form']->row($form['is_required']); ?>
	</div>
	<div class="panel-footer">
		<button type="submit" class="btn btn-primary">Save</button>
	</div>
</div>
<?php echo $view['form']->end($form); ?>
