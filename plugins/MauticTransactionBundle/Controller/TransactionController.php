<?php
	
	
	namespace MauticPlugin\MauticTransactionBundle\Controller;
	
	use Mautic\CampaignBundle\Entity\Summary;
	use Mautic\CoreBundle\Controller\CommonController;
	use Mautic\CoreBundle\Factory\PageHelperFactoryInterface;
	use Mautic\FormBundle\Controller\FormController;
	use Mautic\LeadBundle\Entity\Company;
	use Symfony\Component\HttpFoundation\Request;
	use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
	use MauticPlugin\MauticTransactionBundle\Form\Type\TransactionType;
	
	class TransactionController extends CommonController
	{
		public function indexAction($page = 1)
		{

			$transactions = $this->getDoctrine()->getRepository(Transaction::class)->findAll();
			
			/** @var PageHelperFactoryInterface $pageHelperFacotry */
			$pageHelperFacotry = $this->get('mautic.page.helper.factory');
			$pageHelper        = $pageHelperFacotry->make('mautic.company', $page);
			
			$limit      = $pageHelper->getLimit();
			$start      = $pageHelper->getStart();
			$search     = $this->request->get('search', $this->get('session')->get('mautic.company.filter', ''));
			
	
//
//			return $this->delegateView(
//				[
//					'viewParameters' => [
//						'searchValue' => $search,
////						'leadCounts'  => $leadCounts,
//						'items'       => $transactions,
//						'page'        => $page,
//						'limit'       => $limit,
//					],
//					'contentTemplate' => 'MauticTransactionBundle:Transaction:list.html.php',
//					'passthroughVars' => [
//						'activeLink'    => '#mautic_company_index',
//						'mauticContent' => 'company',
//						'route'         => $this->generateUrl('mautic_company_index', ['page' => $page]),
//					],
//				]
//			);
			
			return $this->render('MauticTransactionBundle:Transaction:index.html.php', [
				'transactions' => $transactions
			]);
		}
		//			$companies = $this->getDoctrine()->getRepository(Company::class)->getCompaniesForContacts([1]);
//			dump($companies);die;
		
		public function newAction(Request $request)
		{
			$transaction = new Transaction();
			
			$form = $this->createForm(TransactionType::class, $transaction);
			
			$form->handleRequest($request);
			
			if ($form->isSubmitted() && $form->isValid()) {
				$entityManager = $this->getDoctrine()->getManager();
				$entityManager->persist($transaction);
				$entityManager->flush();
				
				$this->addFlash('notice', 'Transaction created successfully.');
				
				return $this->redirectToRoute('mautic_transaction_index');
			}
			
			return $this->render('MauticTransactionBundle:Transaction:new.html.twig', [
				'form' => $form->createView(),
			]);
		}
	}

