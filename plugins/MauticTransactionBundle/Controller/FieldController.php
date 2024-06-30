<?php
	
	namespace MauticPlugin\MauticTransactionBundle\Controller;
	
	use Mautic\CoreBundle\Controller\FormController;
	use MauticPlugin\MauticTransactionBundle\Entity\TransactionField;
	use Symfony\Component\HttpFoundation\Request;
	use MauticPlugin\MauticTransactionBundle\Form\Type\FieldType;
	
	class FieldController extends FormController
	{
		public function indexAction(Request $request)
		{
			$form = $this->createForm(FieldType::class);
			
			if ($request->isMethod('POST')) {
				$form->handleRequest($request);
				
				if ($form->isSubmitted() && $form->isValid()) {
					$data = $form->getData();
					
					// Create a new TransactionField entity
					$transactionField = new TransactionField();
					$transactionField->setName($data['name']);
					$transactionField->setLabel($data['label']);
					$transactionField->setType($data['type']);
					$transactionField->setIsRequired($data['is_required']);
					
					// Save the transaction field
					$em = $this->getDoctrine()->getManager();
					$em->persist($transactionField);
					$em->flush();
					
					// Add flash message and redirect
					$this->addFlash('success', 'Custom field added successfully.');
					return $this->redirectToRoute('custom_transaction_fields');
				}
			}
			
			return $this->delegateView([
				'viewParameters' => [
					'form' => $form->createView()
				],
				'contentTemplate' => 'MauticTransactionBundle:Field:form.html.php',
				'passthroughVars' => [
					'activeLink'    => '#plugin_transaction_fields',
					'mauticContent' => 'transaction_fields'
				]
			]);
		}
	}
