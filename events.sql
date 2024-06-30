/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mautic_master

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2024-07-01 00:10:26
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of events
-- ----------------------------
INSERT INTO events VALUES ('21', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, null, 'Vietnam', 'Asia', 'Binh Djinh', 'https://meeymap.com/tin-tuc/ban-do-chau-au', 'Bản đồ Châu Âu | Bản đồ Các Nước Châu Âu Phóng To | Meey Map', null, 'page_view', '64280ee582f486001dc95a1b', 'WEB');
INSERT INTO events VALUES ('22', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Mong Cai', 'Vietnam', 'Asia', 'Quang Ninh', 'https://meeymap.com/tin-tuc/ban-do-quy-hoach-xa-nam-hong-dong-anh-ha-noi', 'Bản đồ Quy Hoạch Xã Nam Hồng, Đông Anh, Hà Nội| Kế Hoạch Sử Dụng đất', null, 'user_engagement', '664338d8b33bffda58e9f502', 'WEB');
INSERT INTO events VALUES ('23', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, 'a:0:{}', '0', null, 'Phuc Yen', 'Vietnam', 'Asia', 'Vinh Phuc', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoyMS4yNTA0Njk2Mzc0MTYyODQsImxuZyI6MTA1LjQ2NTM5NTIwNDc4MDExfSwiem9uaW5nVHlwZSI6MSwic2VhcmNoVHlwZSI6MywiaXNTb3RvU290aHVhIjpmYWxzZSwiZnJ', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'click_location', '625a2d155216600019362c1e', 'WEB');
INSERT INTO events VALUES ('24', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Ben Tre', 'Vietnam', 'Asia', 'Ben Tre', 'https://meeymap.com/tin-tuc/xa-tan-thanh-binh-huyen-mo-cay-bac-quy-hoach-ban-do-tong-quan', 'Xã Tân Thành Bình, Huyện Mỏ Cày Bắc – Quy Hoạch – Bản đồ – Tổng Quan | Meey Map', null, 'user_engagement', '664040de004ed6869bc07c5b', 'WEB');
INSERT INTO events VALUES ('25', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoyMS4xNTc5NTY4MzY3NjYzODUsImxuZyI6MTA1LjgxNTY2NDIzMTc3NzJ9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'user_engagement', '6632f93d2b4698893b0a2656', 'WEB');
INSERT INTO events VALUES ('26', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoxOC42ODI0ODY1MDEyODIxMTQsImxuZyI6MTA1LjczODY4NTgyMjk0OTV9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'page_view', '6642d26409302011f3dfc73b', 'WEB');
INSERT INTO events VALUES ('27', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoyMS4xMzkxNjc2NDE2NTA3NTgsImxuZyI6MTA1LjQ1NTkyNjM1ODY5OTgzfSwiem9uaW5nVHlwZSI6MSwic2VhcmNoVHlwZSI6MywiaXNTb3RvU290aHVhIjpmYWxzZSwiZnJ', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'button_base_map', '66439079434a7d8497d64f12', 'WEB');
INSERT INTO events VALUES ('28', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'user_engagement', '6144830b2792fd26d7b89331', 'WEB');
INSERT INTO events VALUES ('29', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoxOC42ODI0ODY1MDEyODIxMTQsImxuZyI6MTA1LjczODY4NTgyMjk0OTV9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'scroll', '61473c75a59b960018fed63b', 'WEB');
INSERT INTO events VALUES ('30', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoyMS41Nzg1MDY4MDcxODA1MywibG5nIjoxMDQuOTk2MjI5NzIyOTg2ODR9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'user_engagement', '6641c0cc09302011f3de442e', 'WEB');
INSERT INTO events VALUES ('31', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/tin-tuc/ban-do-quy-hoach-huyen-ha-hoa-phu-tho', 'Bản đồ Quy Hoạch Huyện Hạ Hòa, Phú Thọ| Kế Hoạch Sử Dụng đất | Meey Map', null, 'user_engagement', '662e683abcaff9d0288fb6d8', 'WEB');
INSERT INTO events VALUES ('32', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoxOC42ODI0ODY1MDEyODIxMTQsImxuZyI6MTA1LjczODY4NTgyMjk0OTV9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'page_view', '66430bcd09302011f3e04cf5', 'WEB');
INSERT INTO events VALUES ('33', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoxOC42ODI0ODY1MDEyODIxMTQsImxuZyI6MTA1LjczODY4NTgyMjk0OTV9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'page_view', '6642f18abd0df3b8db7455f5', 'WEB');
INSERT INTO events VALUES ('34', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoxOC42ODI0ODY1MDEyODIxMTQsImxuZyI6MTA1LjczODY4NTgyMjk0OTV9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'page_view', '5e7671085071cd1c9e8f4a88', 'WEB');
INSERT INTO events VALUES ('35', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoxOC42ODI0ODY1MDEyODIxMTQsImxuZyI6MTA1LjczODY4NTgyMjk0OTV9LCJ6b25pbmdUeXBlIjoyLCJzZWFyY2hUeXBlIjozLCJpc1NvdG9Tb3RodWEiOmZhbHNlLCJmcm9', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'view_search_results', '64c37bee643774001dce6b0f', 'WEB');
INSERT INTO events VALUES ('36', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Phuc Yen', 'Vietnam', 'Asia', 'Vinh Phuc', 'https://meeymap.com/?search=eyJzZWFyY2hTdHJpbmciOnsibGF0IjoyMS4yNTA0Njk2Mzc0MTYyODQsImxuZyI6MTA1LjQ2NTM5NTIwNDc4MDExfSwiem9uaW5nVHlwZSI6MSwic2VhcmNoVHlwZSI6MywiaXNTb3RvU290aHVhIjpmYWxzZSwiZnJ', 'Meey Map | web tra cứu thông tin bản đồ quy hoạch bất động sản #1', null, 'page_view', '6642fa70004ed6869bc48dee', 'WEB');
INSERT INTO events VALUES ('37', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, null, null, null, 'a:0:{}', '0', null, 'Hanoi', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/tin-tuc/ban-do-thanh-pho-vinh-nghe-an', 'Bản đồ Thành Phố Vinh, Nghệ An| Quy Hoạch Sử Dụng đất', null, 'session_start', '6642f629004ed6869bc48654', 'WEB');
INSERT INTO events VALUES ('38', null, '1', '2024-06-30 15:36:56', '1', 'Hai Ha', '2024-06-30 15:43:37', '1', 'Hai Ha', null, null, 'Hai Ha', 'a:0:{}', '10', 'web', 'Son Tay', 'Vietnam', 'Asia', 'Hanoi', 'https://meeymap.com/tin-tuc/xa-phong-nam-tp-phan-thiet-quy-hoach-ban-do-tong-quan', 'Xã Phong Nẫm, TP Phan Thiết – Quy Hoạch – Bản đồ – Tổng Quan | Meey Map', null, 'user_engagement', '643e68fb03e8bf001da908f9', 'WEB');
