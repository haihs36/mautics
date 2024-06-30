/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mautic4

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2024-06-30 22:14:47
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `events`
-- ----------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
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
  `event_device_web` varchar(191) DEFAULT NULL,
  `geo_city` varchar(191) DEFAULT NULL,
  `geo_country` varchar(191) DEFAULT NULL,
  `geo_continent` varchar(191) DEFAULT NULL,
  `geo_region` varchar(191) DEFAULT NULL,
  `param_page_location` varchar(191) DEFAULT NULL,
  `param_page_title` varchar(191) DEFAULT NULL,
  `param_ga_session_id` varchar(191) DEFAULT NULL,
  `eventname` varchar(191) DEFAULT NULL,
  `eventmeeyid` varchar(191) DEFAULT NULL,
  `eventplatform` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_8244AA3A7E3C61F9` (`owner_id`),
  KEY `event_device_web_search` (`event_device_web`),
  KEY `geo_city_search` (`geo_city`),
  KEY `geo_country_search` (`geo_country`),
  KEY `geo_continent_search` (`geo_continent`),
  KEY `geo_region_search` (`geo_region`),
  KEY `param_page_location_search` (`param_page_location`),
  KEY `param_page_title_search` (`param_page_title`),
  KEY `param_ga_session_id_search` (`param_ga_session_id`),
  KEY `eventname_search` (`eventname`),
  KEY `eventmeeyid_search` (`eventmeeyid`),
  KEY `eventplatform_search` (`eventplatform`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of events
-- ----------------------------
