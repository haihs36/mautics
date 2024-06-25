<?php
	
	// plugins/MauticTransactionBundle/Form/TransactionType.php
	
	namespace MauticPlugin\MauticTransactionBundle\Form\Type;
	
	use Symfony\Component\Form\AbstractType;
	use Symfony\Component\Form\FormBuilderInterface;
	use Symfony\Component\OptionsResolver\OptionsResolver;
	use Symfony\Component\Form\Extension\Core\Type\TextType;
	use Symfony\Component\Form\Extension\Core\Type\DateTimeType;
	use Symfony\Component\Form\Extension\Core\Type\SubmitType;
	use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
	
	class TransactionType extends AbstractType
	{
		public function buildForm(FormBuilderInterface $builder, array $options)
		{
			$builder
				->add('meeyid', TextType::class, [
					'label' => 'MeeYID'
				])
				->add('orderid', TextType::class, [
					'label' => 'OrderID'
				])
				->add('name', TextType::class, [
					'label' => 'Name'
				])
				->add('date', DateTimeType::class, [
					'label' => 'Date',
					'widget' => 'single_text',
					'html5' => false,
					'format' => 'yyyy-MM-dd HH:mm:ss',
				])
				->add('save', SubmitType::class, [
					'label' => 'Save',
					'attr' => ['class' => 'btn btn-primary']
				]);
		}
		
		public function configureOptions(OptionsResolver $resolver)
		{
			$resolver->setDefaults([
				'data_class' => Transaction::class,
			]);
		}
	}
