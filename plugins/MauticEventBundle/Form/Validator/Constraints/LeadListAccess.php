<?php

namespace MauticPlugin\MauticEventBundle\Form\Validator\Constraints;

use Symfony\Component\Validator\Constraint;

/**
 * @Annotation
 */
class LeadListAccess extends Constraint
{
    public $message = 'mautic.lead.lists.failed';

    public function validatedBy()
    {
        return 'leadlist_access';
    }
}
