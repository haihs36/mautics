<?php

/*
 * @copyright   2016 Mautic Contributors. All rights reserved
 * @author      Mautic
 *
 * @link        http://mautic.org
 *
 * @license     GNU/GPLv3 http://www.gnu.org/licenses/gpl-3.0.html
 */
$halfSize = (empty($embedded)) ? 4 : 6;
$fullSize = (empty($embedded)) ? 8 : 12;
?>

    <!-- pane -->
<?php
foreach ($groups as $key => $group):
    if (isset($fields[$group])):
        $groupFields = $fields[$group];
        if (!empty($groupFields)): ?>
            <div class="tab-pane fade<?php if (0 === $key) {
            echo ' in active';
        } ?> bdr-rds-0 bdr-w-0" id="transaction-<?php echo $group; ?>">
                <?php if (empty($embedded)): ?>
                    <div class="pa-md bg-auto bg-light-xs bdr-b">
                        <h4 class="fw-sb">
                            <?php echo $view['translator']->trans('mautic.lead.field.group.'.$group); ?>
                        </h4>
                    </div>
                <?php endif; ?>
                <div class="pa-md">
                    <div class="form-group mb-0">
                        <div class="row">
                            <?php foreach ($groupFields as $alias => $field): ?>
                                <?php
                                if ($form[$alias]->isRendered()) {
                                    continue;
                                } ?>
                                <div class="col-sm-<?php echo $fullSize; ?>">
                                    <?php echo $view['form']->row($form[$alias]); ?>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                    <?php if (!empty($embedded)): ?>
                        <hr class="mnr-md mnl-md">
                        <div>
                            <?php echo $view['form']->row($form['owner']); ?>
                        </div>
                    <?php endif; ?>
                </div>

            </div>

            <?php
        endif;
    endif;
endforeach;
