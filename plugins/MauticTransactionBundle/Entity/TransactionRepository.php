<?php

namespace MauticPlugin\MauticTransactionBundle\Entity;

use Doctrine\DBAL\Query\Expression\CompositeExpression;
use Doctrine\ORM\QueryBuilder;
use Mautic\CoreBundle\Entity\CommonRepository;
use Mautic\LeadBundle\Entity\CustomFieldRepositoryInterface;
use Mautic\LeadBundle\Entity\CustomFieldRepositoryTrait;
use Mautic\LeadBundle\Event\CompanyBuildSearchEvent;
use Mautic\LeadBundle\LeadEvents;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;

/**
 * Class TagRepository.
 */
class TransactionRepository extends CommonRepository implements CustomFieldRepositoryInterface
{
    use CustomFieldRepositoryTrait;
    /**
     * @return array
     */
    protected function getDefaultOrder()
    {
        return [
            ['t.id', 'DESC'],
        ];
    }

    /**
     * @return string
     */
    public function getTableAlias()
    {
        return 't';
    }

    public function countOccurrences($code)
    {
        $q = $this->getEntityManager()->getConnection()->createQueryBuilder();
        $as = $this->getTableAlias();

        $q->select($as.'.trancode')
            ->from(MAUTIC_TABLE_PREFIX.Transaction::TABLE, $as)
            ->where($as.'.trancode = :code')
            ->setParameter('code', $code);

        $result = $q->execute()->fetchAll();

        return count($result);
    }

    /**
     * Used by search functions to search using aliases as commands.
     */
    public function setAvailableSearchFields(array $fields)
    {
        $this->availableSearchFields = $fields;
    }

    public function setDispatcher(EventDispatcherInterface $dispatcher)
    {
        $this->dispatcher = $dispatcher;
    }
 

    /**
     * {@inheritdoc}
     *
     * @param int $id
     *
     * @return mixed|null
     */
    public function getEntity($id = 0)
    {
        try {
            $q = $this->createQueryBuilder($this->getTableAlias());
            if (is_array($id)) {
                $this->buildSelectClause($q, $id);
                $transactionId = (int) $id['id'];
            } else {
                $transactionId = $id;
            }
            $q->andWhere($this->getTableAlias().'.id = '.(int) $transactionId);
            $entity = $q->getQuery()->getSingleResult();
        } catch (\Exception $e) {
            $entity = null;
        }

        if (null === $entity) {
            return $entity;
        }

        if ($entity->getFields()) {
            // Pulled from Doctrine memory so don't make unnecessary queries as this has already happened
            return $entity;
        }

        $fieldValues = $this->getFieldValues($id, true, 'transaction');
        $entity->setFields($fieldValues);

        return $entity;
    }

    /**
     * Get a list of leads.
     *
     * @return array
     */
    public function getEntities(array $args = [])
    {
        return $this->getEntitiesWithCustomFields('transaction', $args);
    }

    /**
     * @return \Doctrine\DBAL\Query\QueryBuilder
     */
    public function getEntitiesDbalQueryBuilder()
    {
        return $this->getEntityManager()->getConnection()->createQueryBuilder()
            ->from(MAUTIC_TABLE_PREFIX.'transactions', $this->getTableAlias());
    }

    /**
     * @param $order
     *
     * @return \Doctrine\ORM\QueryBuilder
     */
    public function getEntitiesOrmQueryBuilder($order)
    {
        $q = $this->getEntityManager()->createQueryBuilder();
        $q->select($this->getTableAlias().','.$order)
            ->from('MauticTransactionBundle:Transaction', $this->getTableAlias(), $this->getTableAlias().'.id');

        return $q;
    }

    /**
     * Get the groups available for fields.
     *
     * @return array
     */
    public function getFieldGroups()
    {
        return ['core', 'professional', 'other'];
    }
	
	
	
	
	/**
	 * Haihs
	 * @param array $filters
	 *
	 * @return int
	 */
	public function getTransactionsCount($meeyId, array $filters = null)
	{
		$query = $this->_em->getConnection()->createQueryBuilder()
			->from(MAUTIC_TABLE_PREFIX . 'transactions', 't')
			->select('count(*)')
			->where('t.tranmeeyid = :meeyid')
			->setParameter('meeyid', $meeyId);
		
		if (is_array($filters) && !empty($filters['search'])) {
			$query->andWhere('t.trancode like \'%' . $filters['search'] . '%\'');
		}
		
		return $query->execute()->fetchColumn();
	}
	
	/**
	 * Haihs
	 * @param int   $meeyId
	 * @param array $filters
	 * @param array $orderBy
	 * @param int   $page
	 * @param int   $limit
	 *
	 * @return array
	 */
	public function getTransactionsPaging($meeyId, array $filters = null, array $orderBy = null, $page = 1, $limit = 25)
	{
		$conn = $this->getEntityManager()->getConnection();
		$q = $conn->createQueryBuilder();
		
		$q->select('t.trancode', 't.tranmeeyid', 't.tranprice', 't.date_added', 't.created_by')
			->from('transactions', 't')
			->where('t.tranmeeyid = :meeyid')
			->setParameter('meeyid', $meeyId);
		
		if (is_array($filters) && !empty($filters['search'])) {
			$q->andWhere('t.trancode LIKE :search')
				->setParameter('search', '%' . $filters['search'] . '%');
		}
		
		if (0 === $page) {
			$page = 1;
		}
		$offset = ($page - 1) * $limit;
		$q->setFirstResult($offset)
			->setMaxResults($limit);
		
		if (is_array($orderBy) && count($orderBy) >= 1) {
			$order = isset($orderBy[0]) ? $orderBy[0] : 'id';
			$orderdir = isset($orderBy[1]) ? $orderBy[1] : 'ASC';
			$q->orderBy('t.' . $order, $orderdir);
		} else {
			$q->orderBy('t.id', 'ASC');
		}
		
		
		$stmt = $q->execute();
		return $stmt->fetchAllAssociative();
	}
	
	
	
	
}
