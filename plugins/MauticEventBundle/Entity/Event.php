<?php

namespace MauticPlugin\MauticEventBundle\Entity;

use Doctrine\ORM\Mapping as ORM;
use Mautic\ApiBundle\Serializer\Driver\ApiMetadataDriver;
use Mautic\CoreBundle\Doctrine\Mapping\ClassMetadataBuilder;
use Mautic\CoreBundle\Entity\FormEntity;
use Mautic\LeadBundle\Entity\CustomFieldEntityInterface;
use Mautic\LeadBundle\Entity\CustomFieldEntityTrait;
use Mautic\LeadBundle\Entity\IdentifierFieldEntityInterface;
use Mautic\UserBundle\Entity\User;

class Event extends FormEntity implements CustomFieldEntityInterface, IdentifierFieldEntityInterface
{
    use CustomFieldEntityTrait;

    const FIELD_ALIAS = 'event';

    /**
     * @var int
     */
    private $id;

    /**
     * @var int
     */
    private $score = 0;

    /**
     * @var User
     */
    private $owner;

    /**
     * @var mixed[]
     */
    private $socialCache = [];

    private $email;

    private $phone;

    private $city;

    private $state;

    private $zipcode;

    private $country;

    private $name;

    private $website;

    private $industry;

    private $description;

    public function __clone()
    {
        $this->id = null;

        parent::__clone();
    }

    /**
     * @return mixed[]
     */
    public function getSocialCache()
    {
        return $this->socialCache;
    }

    /**
     * @param mixed[] $cache
     */
    public function setSocialCache($cache)
    {
        $this->socialCache = $cache;
    }

    public static function loadMetadata(ORM\ClassMetadata $metadata)
    {
        $builder = new ClassMetadataBuilder($metadata);
        $builder->setTable('events')
            ->setCustomRepositoryClass(EventRepository::class);

        $builder->createField('id', 'integer')
            ->isPrimaryKey()
            ->generatedValue()
            ->build();

        $builder->createField('socialCache', 'array')
            ->columnName('social_cache')
            ->nullable()
            ->build();

        $builder->createManyToOne('owner', 'Mautic\UserBundle\Entity\User')
            ->cascadeMerge()
            ->addJoinColumn('owner_id', 'id', true, false, 'SET NULL')
            ->build();

        $builder->createField('score', 'integer')
            ->nullable()
            ->build();
    }

    /**
     * Prepares the metadata for API usage.
     *
     * @param $metadata
     */
    public static function loadApiMetadata(ApiMetadataDriver $metadata)
    {
        $metadata->setGroupPrefix('eventBasic')
            ->addListProperties(
                [
                    'id',
                    'meeyid',
                    'name',
                    'platform',
                    'score',
                ]
            )
            ->setGroupPrefix('event')
            ->addListProperties(
                [
                    'id',
                    'eventmeeyid',
                    'eventname',
                    'platform',
                    'fields',
                    'score',
                ]
            )
            ->build();
    }

    public static function getDefaultIdentifierFields(): array
    {
        return [
            'meeyid',
            'eventname',
            'platform',
        ];
    }

    /**
     * @param string $prop
     * @param mixed $val
     */
    protected function isChanged($prop, $val)
    {
        $getter = 'get' . ucfirst($prop);
        $current = $this->$getter();
        if ('owner' == $prop) {
            if ($current && !$val) {
                $this->changes['owner'] = [$current->getName() . ' (' . $current->getId() . ')', $val];
            } elseif (!$current && $val) {
                $this->changes['owner'] = [$current, $val->getName() . ' (' . $val->getId() . ')'];
            } elseif ($current && $val && $current->getId() != $val->getId()) {
                $this->changes['owner'] = [
                    $current->getName() . '(' . $current->getId() . ')',
                    $val->getName() . '(' . $val->getId() . ')',
                ];
            }
        } else {
            parent::isChanged($prop, $val);
        }
    }

    /**
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * Get the primary identifier for the event.
     *
     * @return string
     */
    public function getPrimaryIdentifier()
    {
        if ($name = $this->getName()) {
            return $name;
        } elseif (!empty($this->fields['core']['eventemail']['value'])) {
            return $this->fields['core']['eventemail']['value'];
        }
    }

    /**
     * @param User $owner
     *
     * @return Event
     */
    public function setOwner(User $owner = null)
    {
        $this->isChanged('owner', $owner);
        $this->owner = $owner;

        return $this;
    }

    /**
     * @return User
     */
    public function getOwner()
    {
        return $this->owner;
    }

    /**
     * Returns the user to be used for permissions.
     *
     * @return User|int
     */
    public function getPermissionUser()
    {
        return (null === $this->getOwner()) ? $this->getCreatedBy() : $this->getOwner();
    }

    /**
     * @param User $score
     *
     * @return Event
     */
    public function setScore($score)
    {
        $score = (int)$score;

        $this->isChanged('score', $score);
        $this->score = $score;

        return $this;
    }

    /**
     * @return int
     */
    public function getScore()
    {
        return $this->score;
    }

    /**
     * @return mixed
     */
    public function getName()
    {
        return $this->name;
    }

    /**
     * @param mixed $name
     *
     * @return Event
     */
    public function setName($name)
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getEmail()
    {
        return $this->email;
    }

    /**
     * @param mixed $email
     *
     * @return Event
     */
    public function setEmail($email)
    {
        $this->email = $email;

        return $this;
    }



    /**
     * @return mixed
     */
    public function getPhone()
    {
        return $this->phone;
    }

    /**
     * @param mixed $phone
     *
     * @return Event
     */
    public function setPhone($phone)
    {
        $this->phone = $phone;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getCity()
    {
        return $this->city;
    }

    /**
     * @param mixed $city
     *
     * @return Event
     */
    public function setCity($city)
    {
        $this->city = $city;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getState()
    {
        return $this->state;
    }

    /**
     * @param mixed $state
     *
     * @return Event
     */
    public function setState($state)
    {
        $this->state = $state;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getZipcode()
    {
        return $this->zipcode;
    }

    /**
     * @param mixed $zipcode
     *
     * @return Event
     */
    public function setZipcode($zipcode)
    {
        $this->zipcode = $zipcode;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getCountry()
    {
        return $this->country;
    }

    /**
     * @param mixed $country
     *
     * @return Event
     */
    public function setCountry($country)
    {
        $this->country = $country;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getWebsite()
    {
        return $this->website;
    }

    /**
     * @param mixed $website
     *
     * @return Event
     */
    public function setWebsite($website)
    {
        $this->website = $website;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getIndustry()
    {
        return $this->industry;
    }

    /**
     * @param mixed $industry
     *
     * @return Event
     */
    public function setIndustry($industry)
    {
        $this->industry = $industry;

        return $this;
    }

    /**
     * @return mixed
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * @param mixed $description
     *
     * @return Event
     */
    public function setDescription($description)
    {
        $this->description = $description;

        return $this;
    }
}
