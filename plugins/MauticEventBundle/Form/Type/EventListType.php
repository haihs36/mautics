<?php

namespace MauticPlugin\MauticEventBundle\Form\Type;

use Mautic\CoreBundle\Form\Type\EntityLookupType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\OptionsResolver\OptionsResolver;

class EventListType extends AbstractType
{
    /**
     * {@inheritdoc}
     */
    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults(
            [
                'label'               => 'mautic.lead.lead.events',
                'entity_label_column' => 'eventname',
                'modal_route'         => 'mautic_event_action',
                'modal_header'        => 'mautic.event.new.event',
                'model'               => 'lead.event',
                'ajax_lookup_action'  => 'lead:getLookupChoiceList',
                'multiple'            => true,
                'main_entity'         => null,
            ]
        );
    }

    /**
     * @return string
     */
    public function getParent()
    {
        return EntityLookupType::class;
    }

    /**
     * @return string
     */
    public function getBlockPrefix()
    {
        return 'event_list';
    }
}
