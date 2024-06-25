<?php

namespace MauticPlugin\MauticTransactionBundle\Security\Permissions;

use Mautic\CoreBundle\Security\Permissions\AbstractPermissions;
use Symfony\Component\Form\FormBuilderInterface;

/**
 * Class TagManagerPermissions.
 */
class TransactionPermissions extends AbstractPermissions
{
    /**
     * {@inheritdoc}
     */
    public function __construct($params)
    {
        parent::__construct($params);

        $this->addStandardPermissions('transaction', false);
    }

    /**
     * {@inheritdoc}
     */
    public function getName()
    {
        return 'transaction';
    }

    /**
     * {@inheritdoc}
     */
    public function buildForm(FormBuilderInterface &$builder, array $options, array $data)
    {
        $this->addStandardFormFields('transaction', 'transaction', $builder, $data);
    }
}
