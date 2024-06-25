<?php

namespace MauticPlugin\MauticTransactionBundle\Entity;

use Doctrine\DBAL\Types\Type;
use Doctrine\ORM\Mapping\ClassMetadata;
use Mautic\ApiBundle\Serializer\Driver\ApiMetadataDriver;
use Mautic\CoreBundle\Doctrine\Mapping\ClassMetadataBuilder;
use Mautic\CoreBundle\Helper\InputHelper;


class Transaction
{

    const TABLE = 'transactions';

    /**
     * @var int
     */
    private $id;

    /**
     * @var string
     */
    private $name;

    /**
     * @param string $name
     * @param bool $clean
     */
    public function __construct($name = null, $clean = true)
    {
        $this->name = $clean ? $this->validateName($name) : $name;
    }

    public static function loadMetadata(ClassMetadata $metadata)
    {
        $builder = new ClassMetadataBuilder($metadata);
        $builder->setTable(self::TABLE)
            ->setEmbeddable()
            ->setCustomRepositoryClass(TransactionRepository::class)->addIndex(['name'], 'lead_name_search');

        $builder->addId();
        $builder->addField('name', Type::STRING);
    }


    public static function loadApiMetadata(ApiMetadataDriver $metadata)
    {
        $metadata->setGroupPrefix('transaction')
            ->addListProperties(
                [
                    'id',
                    'name',
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
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param string $name
     *
     * @return Transaction
     */
    public function setName($name)
    {
        $this->name = $this->validateName($name);

        return $this;
    }


    /**
     * @param string $name
     *
     * @return Transaction
     */
    protected function validateName($name)
    {
        return InputHelper::string(trim($name));
    }
}
