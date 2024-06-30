<?php
	
	namespace MauticPlugin\MauticTransactionBundle\Entity;
	
	use Doctrine\ORM\Mapping as ORM;
	
	/**
	 * @ORM\Entity
	 * @ORM\Table(name="transaction_fields")
	 */
	class TransactionField
	{
		/**
		 * @ORM\Id
		 * @ORM\GeneratedValue(strategy="AUTO")
		 * @ORM\Column(type="integer")
		 */
		private $id;
		
	 
		/**
		 * @ORM\Column(type="string")
		 */
		private $label;
		
		/**
		 * @ORM\Column(type="string")
		 */
		private $type;
	
		// Getters and setters for all properties...
		
		/**
		 * @return int
		 */
		public function getId()
		{
			return $this->id;
		}
		
		/**
		 * @return string
		 */
		public function getLabel()
		{
			return $this->label;
		}
		
		/**
		 * @param string $label
		 *
		 * @return TransactionField
		 */
		public function setLabel($label)
		{
			$this->label = $label;
			
			return $this;
		}
	 
		
		/**
		 * Set type.
		 *
		 * @param string $type
		 *
		 * @return TransactionField
		 */
		public function setType($type)
		{
			$this->type = $type;
			
			return $this;
		}
		
		/**
		 * Get type.
		 *
		 * @return string
		 */
		public function getType()
		{
			return $this->type;
		}
	}
