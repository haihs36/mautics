/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mautic_master

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2024-07-01 00:10:11
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `transactions`
-- ----------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_id` int(10) unsigned DEFAULT NULL,
  `is_published` tinyint(1) NOT NULL,
  `date_added` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_by_user` varchar(191) DEFAULT NULL,
  `date_modified` datetime DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `modified_by_user` varchar(191) DEFAULT NULL,
  `checked_out` datetime DEFAULT NULL,
  `checked_out_by` int(11) DEFAULT NULL,
  `checked_out_by_user` varchar(191) DEFAULT NULL,
  `social_cache` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `score` int(11) DEFAULT NULL,
  `tranmeeyid` varchar(191) DEFAULT NULL,
  `trancode` varchar(191) DEFAULT NULL,
  `tranidid` varchar(191) DEFAULT NULL,
  `tranprice` double DEFAULT NULL,
  `transtatus` double DEFAULT NULL,
  `tranproductid` varchar(191) DEFAULT NULL,
  `tranplatform_d` varchar(191) DEFAULT NULL,
  `tranplatform` varchar(191) DEFAULT NULL,
  `transaleemail` varchar(191) DEFAULT NULL,
  `trancreateddate` varchar(191) DEFAULT NULL,
  `tranupdateddate` varchar(191) DEFAULT NULL,
  `tranid` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_8244AA3A7E3C61F9` (`owner_id`),
  KEY `tranmeeyid_search` (`tranmeeyid`),
  KEY `trancode_search` (`trancode`),
  KEY `tranidid_search` (`tranidid`),
  KEY `tranproductid_search` (`tranproductid`),
  KEY `tranplatform_d_search` (`tranplatform_d`),
  KEY `tranplatform_search` (`tranplatform`),
  KEY `transaleemail_search` (`transaleemail`),
  KEY `trancreateddate_search` (`trancreateddate`),
  KEY `tranupdateddate_search` (`tranupdateddate`),
  KEY `tranid_search` (`tranid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of transactions
-- ----------------------------
