/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mautic_master

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2024-07-01 00:10:41
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `lead_fields`
-- ----------------------------
DROP TABLE IF EXISTS `lead_fields`;
CREATE TABLE `lead_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
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
  `label` varchar(191) NOT NULL,
  `alias` varchar(191) NOT NULL,
  `type` varchar(50) NOT NULL,
  `field_group` varchar(191) DEFAULT NULL,
  `default_value` varchar(191) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL,
  `is_fixed` tinyint(1) NOT NULL,
  `is_visible` tinyint(1) NOT NULL,
  `is_short_visible` tinyint(1) NOT NULL,
  `is_listable` tinyint(1) NOT NULL,
  `is_publicly_updatable` tinyint(1) NOT NULL,
  `is_unique_identifer` tinyint(1) DEFAULT NULL,
  `field_order` int(11) DEFAULT NULL,
  `object` varchar(191) DEFAULT NULL,
  `properties` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `column_is_not_created` tinyint(1) NOT NULL DEFAULT 0,
  `original_is_published_value` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `search_by_object` (`object`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_fields
-- ----------------------------
INSERT INTO lead_fields VALUES ('1', '1', null, null, null, null, null, null, null, null, null, 'Title', 'title', 'lookup', 'core', null, '0', '1', '1', '0', '1', '0', '0', '23', 'lead', 'a:1:{s:4:\"list\";a:3:{i:0;s:2:\"Mr\";i:1;s:3:\"Mrs\";i:2;s:4:\"Miss\";}}', '0', '0');
INSERT INTO lead_fields VALUES ('2', '1', null, null, null, null, null, null, null, null, null, 'First Name', 'firstname', 'text', 'core', null, '0', '1', '1', '1', '1', '0', '0', '25', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('3', '1', null, null, null, null, null, null, null, null, null, 'Last Name', 'lastname', 'text', 'core', null, '0', '1', '1', '1', '1', '0', '0', '27', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('4', '1', null, null, null, null, null, null, null, null, null, 'Primary company', 'company', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '29', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('5', '1', null, null, null, null, null, null, null, null, null, 'mautic.lead.field.event', 'event', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '31', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('6', '1', null, null, null, null, null, null, null, null, null, 'Position', 'position', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '33', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('7', '1', null, null, null, null, null, null, null, null, null, 'Email', 'email', 'email', 'core', null, '0', '1', '1', '1', '1', '0', '1', '35', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('8', '1', null, null, null, null, null, null, null, null, null, 'Mobile', 'mobile', 'tel', 'core', null, '0', '1', '1', '0', '1', '0', '0', '37', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('9', '1', null, null, null, null, null, null, null, null, null, 'Phone', 'phone', 'tel', 'core', null, '0', '1', '1', '0', '1', '0', '0', '39', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('10', '1', null, null, null, null, null, null, null, null, null, 'Points', 'points', 'number', 'core', '0', '0', '1', '1', '0', '1', '0', '0', '41', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('11', '1', null, null, null, null, null, null, null, null, null, 'Fax', 'fax', 'tel', 'core', null, '0', '0', '1', '0', '1', '0', '0', '43', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('12', '1', null, null, null, null, null, null, null, null, null, 'Address Line 1', 'address1', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '45', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('13', '1', null, null, null, null, null, null, null, null, null, 'Address Line 2', 'address2', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '47', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('14', '1', null, null, null, null, null, null, null, null, null, 'City', 'city', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '49', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('15', '1', null, null, null, null, null, null, null, null, null, 'State', 'state', 'region', 'core', null, '0', '1', '1', '0', '1', '0', '0', '51', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('16', '1', null, null, null, null, null, null, null, null, null, 'Zip Code', 'zipcode', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '53', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('17', '1', null, null, null, null, null, null, null, null, null, 'Country', 'country', 'country', 'core', null, '0', '1', '1', '0', '1', '0', '0', '54', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('18', '1', null, null, null, null, null, null, null, null, null, 'Preferred Locale', 'preferred_locale', 'locale', 'core', null, '0', '1', '1', '0', '1', '0', '0', '55', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('19', '1', null, null, null, null, null, null, null, null, null, 'Preferred Timezone', 'timezone', 'timezone', 'core', null, '0', '1', '1', '0', '1', '0', '0', '56', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('20', '1', null, null, null, null, null, null, null, null, null, 'Date Last Active', 'last_active', 'datetime', 'core', null, '0', '1', '1', '0', '1', '0', '0', '57', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('21', '1', null, null, null, null, null, null, null, null, null, 'Attribution Date', 'attribution_date', 'datetime', 'core', null, '0', '1', '1', '0', '1', '0', '0', '58', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('22', '1', null, null, null, null, null, null, null, null, null, 'Attribution', 'attribution', 'number', 'core', null, '0', '1', '1', '0', '1', '0', '0', '59', 'lead', 'a:2:{s:9:\"roundmode\";i:4;s:5:\"scale\";i:2;}', '0', '0');
INSERT INTO lead_fields VALUES ('23', '1', null, null, null, null, null, null, null, null, null, 'Website', 'website', 'url', 'core', null, '0', '0', '1', '0', '1', '0', '0', '60', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('24', '1', null, null, null, null, null, null, null, null, null, 'Facebook', 'facebook', 'text', 'social', null, '0', '0', '1', '0', '1', '0', '0', '61', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('25', '1', null, null, null, null, null, null, null, null, null, 'Foursquare', 'foursquare', 'text', 'social', null, '0', '0', '1', '0', '1', '0', '0', '62', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('26', '1', null, null, null, null, null, null, null, null, null, 'Instagram', 'instagram', 'text', 'social', null, '0', '0', '1', '0', '1', '0', '0', '63', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('27', '1', null, null, null, null, null, null, null, null, null, 'LinkedIn', 'linkedin', 'text', 'social', null, '0', '0', '1', '0', '1', '0', '0', '64', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('28', '1', null, null, null, null, null, null, null, null, null, 'Skype', 'skype', 'text', 'social', null, '0', '0', '1', '0', '1', '0', '0', '65', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('29', '1', null, null, null, null, null, null, null, null, null, 'Twitter', 'twitter', 'text', 'social', null, '0', '0', '1', '0', '1', '0', '0', '66', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('30', '1', null, null, null, null, null, null, null, null, null, 'Address 1', 'companyaddress1', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '24', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('31', '1', null, null, null, null, null, null, null, null, null, 'Address 2', 'companyaddress2', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '26', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('32', '1', null, null, null, null, null, null, null, null, null, 'Company Email', 'companyemail', 'email', 'core', null, '0', '1', '1', '0', '1', '0', '0', '28', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('33', '1', null, null, null, null, null, null, null, null, null, 'Phone', 'companyphone', 'tel', 'core', null, '0', '1', '1', '0', '1', '0', '0', '30', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('34', '1', null, null, null, null, null, null, null, null, null, 'City', 'companycity', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '32', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('35', '1', null, null, null, null, null, null, null, null, null, 'State', 'companystate', 'region', 'core', null, '0', '1', '1', '0', '1', '0', '0', '34', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('36', '1', null, null, null, null, null, null, null, null, null, 'Zip Code', 'companyzipcode', 'text', 'core', null, '0', '1', '1', '0', '1', '0', '0', '36', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('37', '1', null, null, null, null, null, null, null, null, null, 'Country', 'companycountry', 'country', 'core', null, '0', '1', '1', '0', '1', '0', '0', '38', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('38', '1', null, null, null, null, null, null, null, null, null, 'Company Name', 'companyname', 'text', 'core', null, '1', '1', '1', '0', '1', '0', '1', '40', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('39', '1', null, null, null, null, null, null, null, null, null, 'Website', 'companywebsite', 'url', 'core', null, '0', '1', '1', '0', '1', '0', '0', '42', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('40', '1', null, null, null, null, null, null, null, null, null, 'Number of Employees', 'companynumber_of_employees', 'number', 'professional', null, '0', '0', '1', '0', '1', '0', '0', '44', 'company', 'a:2:{s:9:\"roundmode\";i:4;s:5:\"scale\";i:0;}', '0', '0');
INSERT INTO lead_fields VALUES ('41', '1', null, null, null, null, null, null, null, null, null, 'Fax', 'companyfax', 'tel', 'professional', null, '0', '0', '1', '0', '1', '0', '0', '46', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('42', '1', null, null, null, null, null, null, null, null, null, 'Annual Revenue', 'companyannual_revenue', 'number', 'professional', null, '0', '0', '1', '0', '1', '0', '0', '48', 'company', 'a:2:{s:9:\"roundmode\";i:4;s:5:\"scale\";i:2;}', '0', '0');
INSERT INTO lead_fields VALUES ('43', '1', null, null, null, null, null, null, null, null, null, 'Industry', 'companyindustry', 'select', 'professional', null, '0', '1', '1', '0', '1', '0', '0', '50', 'company', 'a:1:{s:4:\"list\";a:31:{i:0;a:2:{s:5:\"label\";s:11:\"Agriculture\";s:5:\"value\";s:11:\"Agriculture\";}i:1;a:2:{s:5:\"label\";s:7:\"Apparel\";s:5:\"value\";s:7:\"Apparel\";}i:2;a:2:{s:5:\"label\";s:7:\"Banking\";s:5:\"value\";s:7:\"Banking\";}i:3;a:2:{s:5:\"label\";s:13:\"Biotechnology\";s:5:\"value\";s:13:\"Biotechnology\";}i:4;a:2:{s:5:\"label\";s:9:\"Chemicals\";s:5:\"value\";s:9:\"Chemicals\";}i:5;a:2:{s:5:\"label\";s:14:\"Communications\";s:5:\"value\";s:14:\"Communications\";}i:6;a:2:{s:5:\"label\";s:12:\"Construction\";s:5:\"value\";s:12:\"Construction\";}i:7;a:2:{s:5:\"label\";s:9:\"Education\";s:5:\"value\";s:9:\"Education\";}i:8;a:2:{s:5:\"label\";s:11:\"Electronics\";s:5:\"value\";s:11:\"Electronics\";}i:9;a:2:{s:5:\"label\";s:6:\"Energy\";s:5:\"value\";s:6:\"Energy\";}i:10;a:2:{s:5:\"label\";s:11:\"Engineering\";s:5:\"value\";s:11:\"Engineering\";}i:11;a:2:{s:5:\"label\";s:13:\"Entertainment\";s:5:\"value\";s:13:\"Entertainment\";}i:12;a:2:{s:5:\"label\";s:13:\"Environmental\";s:5:\"value\";s:13:\"Environmental\";}i:13;a:2:{s:5:\"label\";s:7:\"Finance\";s:5:\"value\";s:7:\"Finance\";}i:14;a:2:{s:5:\"label\";s:15:\"Food & Beverage\";s:5:\"value\";s:15:\"Food & Beverage\";}i:15;a:2:{s:5:\"label\";s:10:\"Government\";s:5:\"value\";s:10:\"Government\";}i:16;a:2:{s:5:\"label\";s:10:\"Healthcare\";s:5:\"value\";s:10:\"Healthcare\";}i:17;a:2:{s:5:\"label\";s:11:\"Hospitality\";s:5:\"value\";s:11:\"Hospitality\";}i:18;a:2:{s:5:\"label\";s:9:\"Insurance\";s:5:\"value\";s:9:\"Insurance\";}i:19;a:2:{s:5:\"label\";s:9:\"Machinery\";s:5:\"value\";s:9:\"Machinery\";}i:20;a:2:{s:5:\"label\";s:13:\"Manufacturing\";s:5:\"value\";s:13:\"Manufacturing\";}i:21;a:2:{s:5:\"label\";s:5:\"Media\";s:5:\"value\";s:5:\"Media\";}i:22;a:2:{s:5:\"label\";s:14:\"Not for Profit\";s:5:\"value\";s:14:\"Not for Profit\";}i:23;a:2:{s:5:\"label\";s:10:\"Recreation\";s:5:\"value\";s:10:\"Recreation\";}i:24;a:2:{s:5:\"label\";s:6:\"Retail\";s:5:\"value\";s:6:\"Retail\";}i:25;a:2:{s:5:\"label\";s:8:\"Shipping\";s:5:\"value\";s:8:\"Shipping\";}i:26;a:2:{s:5:\"label\";s:10:\"Technology\";s:5:\"value\";s:10:\"Technology\";}i:27;a:2:{s:5:\"label\";s:18:\"Telecommunications\";s:5:\"value\";s:18:\"Telecommunications\";}i:28;a:2:{s:5:\"label\";s:14:\"Transportation\";s:5:\"value\";s:14:\"Transportation\";}i:29;a:2:{s:5:\"label\";s:9:\"Utilities\";s:5:\"value\";s:9:\"Utilities\";}i:30;a:2:{s:5:\"label\";s:5:\"Other\";s:5:\"value\";s:5:\"Other\";}}}', '0', '0');
INSERT INTO lead_fields VALUES ('44', '1', null, null, null, null, null, null, null, null, null, 'Description', 'companydescription', 'text', 'professional', null, '0', '1', '1', '0', '1', '0', '0', '52', 'company', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('47', '1', '2024-06-29 16:17:34', '1', 'Hai Ha', null, null, null, null, null, 'Hai Ha', 'Event device web info', 'event_device_web', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '22', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('48', '1', '2024-06-29 16:19:21', '1', 'Hai Ha', null, null, null, null, null, null, 'geo_city', 'geo_city', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '21', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('49', '1', '2024-06-29 16:22:23', '1', 'Hai Ha', null, null, null, null, null, null, 'geo_country', 'geo_country', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '20', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('50', '1', '2024-06-29 16:23:38', '1', 'Hai Ha', null, null, null, null, null, null, 'geo_continent', 'geo_continent', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '19', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('51', '1', '2024-06-29 16:23:57', '1', 'Hai Ha', null, null, null, null, null, null, 'geo_region', 'geo_region', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '18', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('52', '1', '2024-06-29 16:24:58', '1', 'Hai Ha', null, null, null, null, null, null, 'param_page_location', 'param_page_location', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '17', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('53', '1', '2024-06-29 16:25:54', '1', 'Hai Ha', null, null, null, null, null, null, 'param_page_title', 'param_page_title', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '16', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('54', '1', '2024-06-29 16:26:18', '1', 'Hai Ha', null, null, null, null, null, null, 'param_ga_session_id', 'param_ga_session_id', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '15', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('55', '1', '2024-06-29 16:44:19', '1', 'Hai Ha', '2024-06-29 16:49:13', '1', 'Hai Ha', null, null, 'Hai Ha', 'Event Name', 'eventname', 'text', 'core', null, '1', '0', '1', '1', '1', '0', '0', '14', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('56', '1', '2024-06-29 16:44:46', '1', 'Hai Ha', '2024-06-30 02:04:52', '1', 'Hai Ha', null, null, 'Hai Ha', 'Event MeeyID', 'eventmeeyid', 'text', 'core', null, '1', '0', '1', '1', '1', '0', '1', '13', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('57', '1', '2024-06-29 16:51:28', '1', 'Hai Ha', null, null, null, null, null, null, 'Event Platform', 'eventplatform', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '12', 'event', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('61', '1', '2024-06-30 04:03:49', '1', 'Hai Ha', '2024-06-30 15:19:18', '1', 'Hai Ha', null, null, 'Hai Ha', 'Contact MeeyID', 'contactmeeyid', 'text', 'core', null, '1', '0', '1', '1', '1', '0', '0', '11', 'lead', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('64', '1', '2024-06-30 16:42:08', '1', 'Hai Ha', '2024-06-30 17:05:59', '1', 'Hai Ha', null, null, 'Hai Ha', 'Transaction MeeyID', 'tranmeeyid', 'text', 'core', null, '1', '0', '1', '1', '1', '0', '0', '10', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('65', '1', '2024-06-30 16:42:41', '1', 'Hai Ha', '2024-06-30 17:07:24', '1', 'Hai Ha', null, null, 'Hai Ha', 'Transaction Code', 'trancode', 'text', 'core', null, '1', '0', '1', '1', '1', '0', '0', '9', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('67', '1', '2024-06-30 16:46:07', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction Price', 'tranprice', 'number', 'core', null, '0', '0', '1', '1', '1', '0', '0', '8', 'transaction', 'a:2:{s:9:\"roundmode\";s:1:\"3\";s:5:\"scale\";s:0:\"\";}', '0', '0');
INSERT INTO lead_fields VALUES ('68', '1', '2024-06-30 16:47:07', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction Status', 'transtatus', 'number', 'core', null, '0', '0', '1', '1', '1', '0', '0', '7', 'transaction', 'a:2:{s:9:\"roundmode\";s:1:\"3\";s:5:\"scale\";s:0:\"\";}', '0', '0');
INSERT INTO lead_fields VALUES ('69', '1', '2024-06-30 16:47:52', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction ProductId', 'tranproductid', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '6', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('71', '1', '2024-06-30 16:50:07', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction Platform_id', 'tranplatform', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '5', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('72', '1', '2024-06-30 16:51:35', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction sale email', 'transaleemail', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '4', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('73', '1', '2024-06-30 16:52:21', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction Created Date', 'trancreateddate', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '3', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('74', '1', '2024-06-30 16:52:58', '1', 'Hai Ha', null, null, null, null, null, null, 'Transaction Updated Date', 'tranupdateddate', 'text', 'core', null, '0', '0', '1', '1', '1', '0', '0', '2', 'transaction', 'a:0:{}', '0', '0');
INSERT INTO lead_fields VALUES ('75', '1', '2024-06-30 16:56:07', '1', 'Hai Ha', '2024-06-30 16:57:26', '1', 'Hai Ha', null, null, 'Hai Ha', 'Transaction ID', 'tranid', 'text', 'core', null, '1', '0', '1', '1', '1', '0', '1', '1', 'transaction', 'a:0:{}', '0', '0');
