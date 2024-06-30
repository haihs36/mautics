<?php

namespace MauticPlugin\MauticTransactionBundle\Event;

use Mautic\CoreBundle\Event\CommonEvent;
use MauticPlugin\MauticTransactionBundle\Entity\Transaction;

/**
 * Class CompanyEvent.
 */
class TransactionEvent extends CommonEvent
{

    /**
     * @param bool $isNew
     * @param int  $score
     */
    public function __construct(Transaction $transaction, $isNew = false)
    {
        $this->entity = $transaction;
        $this->isNew  = $isNew;
    }

    /**
     * Returns the Company entity.
     *
     * @return Transaction
     */
    public function getTransaction()
    {
        return $this->entity;
    }

    /**
     * Sets the Company entity.
     */
    public function setTransaction(Transaction $transaction)
    {
        $this->entity = $transaction;
    }
}
