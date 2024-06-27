<?php

namespace MauticPlugin\MauticEventBundle\Form\Type;

use Mautic\CoreBundle\Form\Type\FormButtonsType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\NotBlank;

class EventMergeType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder->add(
            'event_to_merge',
            EventListType::class,
            [
                'multiple'    => false,
                'label'       => 'mautic.event.to.merge.into',
                'required'    => true,
                'modal_route' => false,
                'main_entity' => $options['main_entity'],
                'constraints' => [
                    new NotBlank(
                        ['message' => 'mautic.event.chooseevent.notblank']
                    ),
                ],
            ]
        );
        $builder->add(
            'buttons',
            FormButtonsType::class,
            [
                'apply_text' => false,
                'save_text'  => 'mautic.lead.merge',
                'save_icon'  => 'fa fa-building',
            ]
        );

        if (!empty($options['action'])) {
            $builder->setAction($options['action']);
        }
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefined(
            ['main_entity']
        );
    }

    /**
     * @return string
     */
    public function getBlockPrefix()
    {
        return 'event_merge';
    }
}
