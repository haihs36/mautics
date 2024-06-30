<?php

namespace MauticPlugin\MauticTransactionBundle\Entity;

use Doctrine\DBAL\Types\Type;
use Doctrine\ORM\Mapping\ClassMetadata;
use Mautic\ApiBundle\Serializer\Driver\ApiMetadataDriver;
use Mautic\CoreBundle\Doctrine\Mapping\ClassMetadataBuilder;
use Mautic\CoreBundle\Entity\FormEntity;
use Mautic\CoreBundle\Helper\InputHelper;
use Mautic\LeadBundle\Entity\CustomFieldEntityInterface;
use Mautic\LeadBundle\Entity\CustomFieldEntityTrait;
use Mautic\LeadBundle\Entity\IdentifierFieldEntityInterface;
use Mautic\UserBundle\Entity\User;


class Transaction extends FormEntity implements CustomFieldEntityInterface, IdentifierFieldEntityInterface
{
    use CustomFieldEntityTrait;
    const TABLE = 'transactions';

    /**
     * @var int
     */
    private $id;
 
    /**
     * @var User
     */
    private $owner;


    public static function loadMetadata(ClassMetadata $metadata)
    {
	
	    $builder = new ClassMetadataBuilder($metadata);
        $builder->setTable(self::TABLE)
            ->setEmbeddable()
            ->setCustomRepositoryClass(TransactionRepository::class)->addIndex(['id'], 'lead_name_search');

        $builder->addId();
    }


    public static function loadApiMetadata(ApiMetadataDriver $metadata)
    {
        $metadata->setGroupPrefix('transaction')
            ->addListProperties(
                [
                    'id',
                    'trancode',
                ]
            )
            ->build();
    }

    /**
     * @return mixed
     */
    public function getId()
    {
        return $this->id;
    }
 

    /**
     * @return User
     */
    public function getOwner()
    {
        return $this->owner;
    }


 
    public static function getDefaultIdentifierFields(): array
    {
        return [];
    }
}
