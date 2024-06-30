<?php
	
	namespace MauticPlugin\MauticTransactionBundle\EventListener;
	
	use Symfony\Component\EventDispatcher\EventSubscriberInterface;
	use Mautic\LeadBundle\Model\LeadModel;
	
	class TransactionSubscriber implements EventSubscriberInterface
	{
		private $leadModel;
		
		public function __construct(LeadModel $leadModel)
		{
			$this->leadModel = $leadModel;
		}
		
		public static function getSubscribedEvents()
		{
			return [
				// Add your event subscriptions here
			];
		}
	}
