<?php


namespace MauticPlugin\MauticTransactionBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="transactions")
 */
class Transaction
{
    /**
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="AUTO")
     * @ORM\Column(type="integer")
     */
    protected $id;

    /**
     * @ORM\Column(type="string", length=255)
     */
    protected $meeyid;

    /**
     * @ORM\Column(type="string", length=255)
     */
    protected $orderid;

    /**
     * @ORM\Column(type="string", length=255)
     */
    protected $name;

    /**
     * @ORM\Column(type="datetime")
     */
    protected $date;

    // Getters and setters
    public function getId()
    {
        return $this->id;
    }

    public function getMeeyid()
    {
        return $this->meeyid;
    }

    public function setMeeyid($meeyid)
    {
        $this->meeyid = $meeyid;
        return $this;
    }

    public function getOrderid()
    {
        return $this->orderid;
    }

    public function setOrderid($orderid)
    {
        $this->orderid = $orderid;
        return $this;
    }

    public function getName()
    {
        return $this->name;
    }

    public function setName($name)
    {
        $this->name = $name;
        return $this;
    }

    public function getDate()
    {
        return $this->date;
    }

    public function setDate($date)
    {
        $this->date = $date;
        return $this;
    }
}
