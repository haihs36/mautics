<?php

namespace MauticPlugin\MauticEventBundle\Form\Type;

use Mautic\LeadBundle\Form\Type\EntityFieldsBuildFormTrait;
use Mautic\LeadBundle\Model\FieldModel;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;

class UpdateEventActionType extends AbstractType
{
    use EntityFieldsBuildFormTrait;

    /**
     * @var FieldModel
     */
    protected $fieldModel;

    public function __construct(FieldModel $fieldModel)
    {
        $this->fieldModel = $fieldModel;
    }

    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $leadFields = $this->fieldModel->getEntities(
            [
                'force' => [
                    [
                        'column' => 'f.isPublished',
                        'expr'   => 'eq',
                        'value'  => true,
                    ],
                ],
                'hydration_mode' => 'HYDRATE_ARRAY',
            ]
        );

        $options['fields']                      = $leadFields;
        $options['ignore_required_constraints'] = true;

        $this->getFormFields($builder, $options, 'event');
    }

    /**
     * @return string
     */
    public function getBlockPrefix()
    {
        return 'updateevent_action';
    }
}
