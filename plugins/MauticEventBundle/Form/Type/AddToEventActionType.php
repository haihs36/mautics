<?php

namespace MauticPlugin\MauticEventBundle\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ButtonType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Routing\RouterInterface;
use Symfony\Component\Validator\Constraints\NotBlank;

class AddToEventActionType extends AbstractType
{
    /**
     * @var RouterInterface
     */
    protected $router;

    public function __construct(RouterInterface $router)
    {
        $this->router = $router;
    }

    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder->add(
            'event',
            EventListType::class,
            [
                'multiple'    => false,
                'required'    => true,
                'modal_route' => false,
                'constraints' => [
                    new NotBlank(
                        ['message' => 'mautic.event.chooseevent.notblank']
                    ),
                ],
            ]
        );

        $windowUrl = $this->router->generate(
            'mautic_event_action',
            [
                'objectAction' => 'new',
                'contentOnly'  => 1,
                'updateSelect' => 'campaignevent_properties_event',
            ]
        );

        $builder->add(
            'newEventButton',
            ButtonType::class,
            [
                'attr' => [
                    'class'   => 'btn btn-primary btn-nospin',
                    'onclick' => 'Mautic.loadNewWindow({"windowUrl": "'.$windowUrl.'"})',
                    'icon'    => 'fa fa-plus',
                ],
                'label' => 'mautic.event.new.event',
            ]
        );
    }

    /**
     * @return string
     */
    public function getBlockPrefix()
    {
        return 'addtoevent_action';
    }
}
