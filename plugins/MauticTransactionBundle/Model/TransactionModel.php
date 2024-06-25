<?php

namespace MauticPlugin\MauticTransactionBundle\Model;

use Mautic\CoreBundle\Model\FormModel;
use MauticPlugin\MauticTransactionBundle\Entity\Transaction;
use MauticPlugin\MauticTransactionBundle\Form\Type\TransactionEntityType;

/**
 * Class TagModel
 * {@inheritdoc}
 */
class TransactionModel extends FormModel
{
    /**
     * {@inheritdoc}
     *
     * @return object
     */
    public function getRepository()
    {
        return $this->em->getRepository(Transaction::class);
    }

    /**
     * {@inheritdoc}
     *
     * @param Transaction   $entity
     * @param       $formFactory
     * @param null  $action
     * @param array $options
     *
     * @return mixed
     *
     * @throws \Symfony\Component\HttpKernel\Exception\NotFoundHttpException
     */
    public function createForm($entity, $formFactory, $action = null, $options = [])
    {

        if (!empty($action)) {
            $options['action'] = $action;
        }

        return $formFactory->create(TransactionEntityType::class, $entity, $options);
    }
}
