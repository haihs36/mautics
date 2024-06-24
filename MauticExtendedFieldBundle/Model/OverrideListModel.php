<?php

namespace MauticPlugin\MauticExtendedFieldBundle\Model;

use Mautic\LeadBundle\Model\ListModel;

/**
 * Class OverrideListModel.
 */
class OverrideListModel extends ListModel
{
    /**
     * Get a list of field choices for filters.
     *
     * @param string $search
     * @return array
     */
    public function getChoiceFields(string $search = '')
    {
        // Call parent method with the correct signature
        $choices = parent::getChoiceFields($search);

        // Shift all extended fields into the "lead" object.
        $resort = false;
        foreach (['extendedField', 'extendedFieldSecure'] as $key) {
            if (isset($choices[$key])) {
                foreach ($choices[$key] as $fieldAlias => $field) {
                    $choices['lead'][$fieldAlias] = $field;
                    unset($choices[$key][$fieldAlias]);
                }
                unset($choices[$key]);
                $resort = true;
            }
        }

        // Sort after we included extended fields (same as core).
        if ($resort) {
            foreach ($choices as $key => $choice) {
                uasort($choice, function ($a, $b) {
                    return strcmp($a['label'], $b['label']);
                });
                $choices[$key] = $choice;
            }
        }

        return $choices;
    }
}
