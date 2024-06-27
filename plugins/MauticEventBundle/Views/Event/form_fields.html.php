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
        } ?> bdr-rds-0 bdr-w-0" id="event-<?php echo $group; ?>">
                <?php if (empty($embedded)): ?>
                    <div class="pa-md bg-auto bg-light-xs bdr-b">
                        <h4 class="fw-sb">
                            <?php echo $view['translator']->trans('mautic.lead.field.group.'.$group); ?>
                        </h4>
                    </div>
                <?php endif; ?>
                <div class="pa-md">
                    <?php if ('core' == $group): ?>
                        <div class="form-group mb-0">
                            <div class="row">
                                <?php if (isset($form['eventname'])): ?>
                                    <div class="col-sm-<?php echo $halfSize; ?>">
                                        <?php echo $view['form']->row($view->escape($form['eventname'])); ?>
                                    </div>
                                <?php endif; ?>
                                <?php if (isset($form['eventemail'])): ?>
                                    <div class="col-sm-<?php echo $halfSize; ?>">
                                        <?php echo $view['form']->row($form['eventemail']); ?>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                        <hr class="mnr-md mnl-md">
                        <?php if (isset($form['eventaddress1']) || isset($form['eventaddress2']) || isset($form['eventcity'])
                            || isset($form['eventstate'])
                            || isset($form['eventzipcode'])
                            || isset($form['eventcountry'])
                        ): ?>
                            <div class="form-group mb-0">
                                <label
                                    class="control-label mb-xs"><?php echo $view['translator']->trans('mautic.event.field.address'); ?></label>
                                <?php if (isset($form['eventaddress1'])): ?>
                                    <div class="row mb-xs">
                                        <div class="col-sm-<?php echo $fullSize; ?>">
                                            <?php echo $view['form']->widget(
                                                $form['eventaddress1'],
                                                ['attr' => ['placeholder' => $form['eventaddress1']->vars['label']]]
                                            ); ?>
                                        </div>
                                    </div>
                                <?php endif; ?>
                                <?php if (isset($form['eventaddress2'])): ?>
                                    <div class="row mb-xs">
                                        <div class="col-sm-<?php echo $fullSize; ?>">
                                            <?php echo $view['form']->widget(
                                                $form['eventaddress2'],
                                                ['attr' => ['placeholder' => $form['eventaddress2']->vars['label']]]
                                            ); ?>
                                        </div>
                                    </div>
                                <?php endif; ?>
                                <div class="row mb-xs">
                                    <?php if (isset($form['eventcity'])): ?>
                                        <div class="col-sm-<?php echo $halfSize; ?>">
                                            <?php echo $view['form']->widget(
                                                $form['eventcity'],
                                                ['attr' => ['placeholder' => $form['eventcity']->vars['label']]]
                                            ); ?>
                                        </div>
                                    <?php endif; ?>
                                    <?php if (isset($form['eventstate'])): ?>
                                        <div class="col-sm-<?php echo $halfSize; ?>">
                                            <?php echo $view['form']->widget(
                                                $form['eventstate'],
                                                ['attr' => ['placeholder' => $form['eventstate']->vars['label']]]
                                            ); ?>
                                        </div>
                                    <?php endif; ?>
                                </div>
                                <div class="row">
                                    <?php if (isset($form['eventzipcode'])): ?>
                                        <div class="col-sm-<?php echo $halfSize; ?>">
                                            <?php echo $view['form']->widget(
                                                $form['eventzipcode'],
                                                ['attr' => ['placeholder' => $form['eventzipcode']->vars['label']]]
                                            ); ?>
                                        </div>
                                    <?php endif; ?>
                                    <?php if (isset($form['eventcountry'])): ?>
                                        <div class="col-sm-<?php echo $halfSize; ?>">
                                            <?php echo $view['form']->widget(
                                                $form['eventcountry'],
                                                ['attr' => ['placeholder' => $form['eventcountry']->vars['label']]]
                                            ); ?>
                                        </div>
                                    <?php endif; ?>
                                </div>
                            </div>

                        <?php endif; ?>
                        <hr class="mnr-md mnl-md">
                    <?php endif; ?>
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
