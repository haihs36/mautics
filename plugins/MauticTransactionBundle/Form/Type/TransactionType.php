<?php
	
	// plugins/MauticTransactionBundle/Form/TransactionType.php
	
	namespace MauticPlugin\MauticTransactionBundle\Form\Type;
	
	use Doctrine\ORM\EntityManager;
    use Mautic\CoreBundle\Form\DataTransformer\IdToEntityModelTransformer;
    use Mautic\CoreBundle\Form\EventListener\CleanFormSubscriber;
    use Mautic\CoreBundle\Form\Type\FormButtonsType;
    use Mautic\LeadBundle\Form\Type\EntityFieldsBuildFormTrait;
    use Mautic\UserBundle\Entity\User;
    use Mautic\UserBundle\Form\Type\UserListType;
    use Symfony\Component\Form\AbstractType;
    use Symfony\Component\Form\Extension\Core\Type\HiddenType;
    use Symfony\Component\Form\Extension\Core\Type\NumberType;
    use Symfony\Component\Form\FormBuilderInterface;
	use Symfony\Component\OptionsResolver\OptionsResolver;
	use Symfony\Component\Form\Extension\Core\Type\TextType;
	use Symfony\Component\Form\Extension\Core\Type\DateTimeType;
	use Symfony\Component\Form\Extension\Core\Type\SubmitType;
	use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
    use Symfony\Component\Routing\RouterInterface;
    use Symfony\Component\Translation\TranslatorInterface;

    class TransactionType extends AbstractType
	{
        use EntityFieldsBuildFormTrait;

        /**
         * @var EntityManager
         */
        private $em;

        /**
         * @var RouterInterface
         */
        protected $router;

        /**
         * @var TranslatorInterface
         */
        protected $translator;

        public function __construct(EntityManager $entityManager, RouterInterface $router, TranslatorInterface $translator)
        {
            $this->em         = $entityManager;
            $this->router     = $router;
            $this->translator = $translator;
        }

        /**
         * {@inheritdoc}
         */
        public function buildForm(FormBuilderInterface $builder, array $options)
        {
            $cleaningRules                 = $this->getFormFields($builder, $options, 'transaction');

//            $transformer = new IdToEntityModelTransformer($this->em, User::class);

//            $builder->add(
//                $builder->create(
//                    'owner',
//                    UserListType::class,
//                    [
//                        'label'      => 'mautic.lead.transaction.field.owner',
//                        'label_attr' => ['class' => 'control-label'],
//                        'attr'       => [
//                            'class' => 'form-control',
//                        ],
//                        'required' => false,
//                        'multiple' => false,
//                    ]
//                )
//                    ->addModelTransformer($transformer)
//            );

            if (!empty($options['update_select'])) {
                $builder->add(
                    'buttons',
                    FormButtonsType::class,
                    [
                        'apply_text' => false,
                    ]
                );

                $builder->add(
                    'updateSelect',
                    HiddenType::class,
                    [
                        'data'   => $options['update_select'],
                        'mapped' => false,
                    ]
                );
            } else {
                $builder->add(
                    'buttons',
                    FormButtonsType::class
                );
            }
            $builder->add(
                'buttons',
                FormButtonsType::class,
                [
                    'post_extra_buttons' => [
                        [
                            'name'  => 'merge',
                            'label' => 'mautic.lead.merge',
                            'attr'  => [
                                'class'       => 'btn btn-default btn-dnd',
                                'icon'        => 'fa fa-building',
                                'data-toggle' => 'ajaxmodal',
                                'data-target' => '#MauticSharedModal',
                                'data-header' => $this->translator->trans('mautic.lead.transaction.header.merge'),
                                'href'        => $this->router->generate(
                                    'mautic_transaction_action',
                                    [
                                        'objectId'     => $options['data']->getId(),
                                        'objectAction' => 'merge',
                                    ]
                                ),
                            ],
                        ],
                    ],
                ]
            );

            $builder->addEventSubscriber(new CleanFormSubscriber($cleaningRules));
        }

        /**
         * {@inheritdoc}
         */
        public function configureOptions(OptionsResolver $resolver)
        {
            $resolver->setDefaults(
                [
                    'data_class'    => Transaction::class,
                    'isShortForm'   => false,
                    'update_select' => false,
                ]
            );

            $resolver->setRequired(['fields']);
        }

        /**
         * {@inheritdoc}
         */
        public function getBlockPrefix()
        {
            return 'transaction';
        }
	}
