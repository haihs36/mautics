<?php
	
	namespace MauticPlugin\MauticTransactionBundle\Form\Type;
	
	use Symfony\Component\Form\AbstractType;
	use Symfony\Component\Form\FormBuilderInterface;
	use Symfony\Component\Form\Extension\Core\Type\TextType;
	use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
	use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
	
	class FieldType extends AbstractType
	{
		public function buildForm(FormBuilderInterface $builder, array $options)
		{
			$builder
				->add('name', TextType::class, [
					'label' => 'Field Name'
				])
				->add('label', TextType::class, [
					'label' => 'Field Label'
				])
				->add('type', ChoiceType::class, [
					'label' => 'Field Type',
					'choices' => [
						'Text' => 'text',
						'Number' => 'number',
						'Date' => 'date',
						'Choice' => 'choice'
					]
				])
				->add('is_required', CheckboxType::class, [
					'label' => 'Is Required',
					'required' => false
				]);
		}
		
		public function getBlockPrefix()
		{
			return 'transactionfield';
		}
	}
