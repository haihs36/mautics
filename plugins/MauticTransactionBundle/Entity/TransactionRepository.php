<?php

namespace MauticPlugin\MauticTransactionBundle\Entity;

use Mautic\CoreBundle\Entity\CommonRepository;

/**
 * Class TagRepository.
 */
class TransactionRepository extends CommonRepository
{
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

    public function countOccurrences($name)
    {
        $q = $this->getEntityManager()->getConnection()->createQueryBuilder();
        $as = $this->getTableAlias();

        $q->select($as.'.name')
            ->from(MAUTIC_TABLE_PREFIX.Transaction::TABLE, $as)
            ->where($as.'.name = :name')
            ->setParameter('name', $name);

        $result = $q->execute()->fetchAll();

        return count($result);
    }

//    /**
//     * Get a count of leads that belong to the tag.
//     *
//     * @param $tagIds
//     *
//     * @return array
//     */
//    public function countByLeads($tagIds)
//    {
//        $q = $this->getEntityManager()->getConnection()->createQueryBuilder();
//
//        $q->select('count(ltx.lead_id) as thecount, ltx.tag_id')
//            ->from(MAUTIC_TABLE_PREFIX.'lead_tags_xref', 'ltx');
//
//        $returnArray = (is_array($tagIds));
//
//        if (!$returnArray) {
//            $tagIds = [$tagIds];
//        }
//
//        $q->where(
//            $q->expr()->in('ltx.tag_id', $tagIds)
//        )
//            ->groupBy('ltx.tag_id');
//
//        $result = $q->execute()->fetchAll();
//
//        $return = [];
//        foreach ($result as $r) {
//            $return[$r['tag_id']] = $r['thecount'];
//        }
//
//        // Ensure lists without leads have a value
//        foreach ($tagIds as $l) {
//            if (!isset($return[$l])) {
//                $return[$l] = 0;
//            }
//        }
//
//        return ($returnArray) ? $return : $return[$tagIds[0]];
//    }
}
