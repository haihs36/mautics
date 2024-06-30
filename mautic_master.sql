/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : mautic_master

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2024-07-01 00:10:52
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `assets`
-- ----------------------------
DROP TABLE IF EXISTS `assets`;
CREATE TABLE `assets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `title` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `alias` varchar(191) NOT NULL,
  `storage_location` varchar(191) DEFAULT NULL,
  `path` varchar(191) DEFAULT NULL,
  `remote_path` longtext DEFAULT NULL,
  `original_file_name` longtext DEFAULT NULL,
  `lang` varchar(191) NOT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `download_count` int(11) NOT NULL,
  `unique_download_count` int(11) NOT NULL,
  `revision` int(11) NOT NULL,
  `extension` varchar(191) DEFAULT NULL,
  `mime` varchar(191) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `disallow` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_79D17D8E12469DE2` (`category_id`),
  KEY `asset_alias_search` (`alias`),
  CONSTRAINT `FK_79D17D8E12469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of assets
-- ----------------------------

-- ----------------------------
-- Table structure for `asset_downloads`
-- ----------------------------
DROP TABLE IF EXISTS `asset_downloads`;
CREATE TABLE `asset_downloads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` int(10) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `email_id` int(10) unsigned DEFAULT NULL,
  `date_download` datetime NOT NULL,
  `code` int(11) NOT NULL,
  `referer` longtext DEFAULT NULL,
  `tracking_id` varchar(191) NOT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_A6494C8F5DA1941` (`asset_id`),
  KEY `IDX_A6494C8FA03F5E9F` (`ip_id`),
  KEY `IDX_A6494C8F55458D` (`lead_id`),
  KEY `IDX_A6494C8FA832C1C9` (`email_id`),
  KEY `download_tracking_search` (`tracking_id`),
  KEY `download_source_search` (`source`,`source_id`),
  KEY `asset_date_download` (`date_download`),
  CONSTRAINT `FK_A6494C8F55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_A6494C8F5DA1941` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_A6494C8FA03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_A6494C8FA832C1C9` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of asset_downloads
-- ----------------------------

-- ----------------------------
-- Table structure for `audit_log`
-- ----------------------------
DROP TABLE IF EXISTS `audit_log`;
CREATE TABLE `audit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_name` varchar(191) NOT NULL,
  `bundle` varchar(50) NOT NULL,
  `object` varchar(50) NOT NULL,
  `object_id` bigint(20) unsigned NOT NULL,
  `action` varchar(50) NOT NULL,
  `details` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `date_added` datetime NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_search` (`object`,`object_id`),
  KEY `timeline_search` (`bundle`,`object`,`action`,`object_id`),
  KEY `date_added_index` (`date_added`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of audit_log
-- ----------------------------
INSERT INTO audit_log VALUES ('1', '1', 'Hai Ha', 'user', 'security', '1', 'login', 'a:1:{s:8:\"username\";s:5:\"admin\";}', '2024-06-30 12:30:31', '127.0.0.1');
INSERT INTO audit_log VALUES ('2', '1', 'Hai Ha', 'user', 'security', '1', 'login', 'a:1:{s:8:\"username\";s:5:\"admin\";}', '2024-06-30 14:45:40', '127.0.0.1');
INSERT INTO audit_log VALUES ('3', '1', 'Hai Ha', 'lead', 'field', '60', 'delete', 'a:2:{i:0;s:4:\"name\";i:1;s:16:\"Transaction Name\";}', '2024-06-30 15:17:06', '127.0.0.1');
INSERT INTO audit_log VALUES ('4', '1', 'Hai Ha', 'lead', 'import', '1', 'create', 'a:6:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:8:{s:4:\"city\";s:4:\"city\";s:13:\"contactmeeyid\";s:13:\"contactmeeyid\";s:5:\"email\";s:5:\"email\";s:9:\"firstname\";s:9:\"firstname\";s:8:\"lastname\";s:8:\"lastname\";s:6:\"mobile\";s:6:\"mobile\";s:5:\"phone\";s:5:\"phone\";s:5:\"state\";s:5:\"state\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:8:{i:0;s:13:\"contactmeeyid\";i:1;s:9:\"firstname\";i:2;s:8:\"lastname\";i:3;s:5:\"email\";i:4;s:5:\"phone\";i:5;s:6:\"mobile\";i:6;s:4:\"city\";i:7;s:5:\"state\";}}i:1;a:4:{s:6:\"fields\";a:8:{s:4:\"city\";s:4:\"city\";s:13:\"contactmeeyid\";s:13:\"contactmeeyid\";s:5:\"email\";s:5:\"email\";s:9:\"firstname\";s:9:\"firstname\";s:8:\"lastname\";s:8:\"lastname\";s:6:\"mobile\";s:6:\"mobile\";s:5:\"phone\";s:5:\"phone\";s:5:\"state\";s:5:\"state\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:8:{i:0;s:13:\"contactmeeyid\";i:1;s:9:\"firstname\";i:2;s:8:\"lastname\";i:3;s:5:\"email\";i:4;s:5:\"phone\";i:5;s:6:\"mobile\";i:6;s:4:\"city\";i:7;s:5:\"state\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:21;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630151748.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:12:\"contac t.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 15:18:07', '127.0.0.1');
INSERT INTO audit_log VALUES ('5', '1', 'Hai Ha', 'lead', 'import', '1', 'update', 'a:5:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:18:10+00:00\";}s:12:\"ignoredCount\";a:2:{i:0;i:20;i:1;i:21;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:18:11+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:18:11+00:00\";}}', '2024-06-30 15:18:11', '127.0.0.1');
INSERT INTO audit_log VALUES ('6', '1', 'Hai Ha', 'lead', 'field', '61', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:19:18+00:00\";}}', '2024-06-30 15:19:18', '127.0.0.1');
INSERT INTO audit_log VALUES ('7', '1', 'Hai Ha', 'lead', 'lead', '20', 'delete', 'a:1:{s:4:\"name\";s:16:\"Marvin Patterson\";}', '2024-06-30 15:19:48', '127.0.0.1');
INSERT INTO audit_log VALUES ('8', '1', 'Hai Ha', 'lead', 'lead', '19', 'delete', 'a:1:{s:4:\"name\";s:12:\"Willie Perez\";}', '2024-06-30 15:19:48', '127.0.0.1');
INSERT INTO audit_log VALUES ('9', '1', 'Hai Ha', 'lead', 'lead', '18', 'delete', 'a:1:{s:4:\"name\";s:14:\"Kyung Brittain\";}', '2024-06-30 15:19:48', '127.0.0.1');
INSERT INTO audit_log VALUES ('10', '1', 'Hai Ha', 'lead', 'lead', '17', 'delete', 'a:1:{s:4:\"name\";s:17:\"Mildred Rodriguez\";}', '2024-06-30 15:19:48', '127.0.0.1');
INSERT INTO audit_log VALUES ('11', '1', 'Hai Ha', 'config', 'config', '0', 'update', 'a:13:{s:17:\"do_not_track_bots\";a:389:{i:0;s:6:\"MSNBOT\";i:1;s:12:\"msnbot-media\";i:2;s:7:\"bingbot\";i:3;s:9:\"Googlebot\";i:4;s:18:\"Google Web Preview\";i:5;s:20:\"Mediapartners-Google\";i:6;s:11:\"Baiduspider\";i:7;s:6:\"Ezooms\";i:8;s:11:\"YahooSeeker\";i:9;s:5:\"Slurp\";i:10;s:9:\"AltaVista\";i:11;s:8:\"AVSearch\";i:12;s:8:\"Mercator\";i:13;s:7:\"Scooter\";i:14;s:8:\"InfoSeek\";i:15;s:9:\"Ultraseek\";i:16;s:5:\"Lycos\";i:17;s:4:\"Wget\";i:18;s:9:\"YandexBot\";i:19;s:13:\"Java/1.4.1_04\";i:20;s:7:\"SiteBot\";i:21;s:6:\"Exabot\";i:22;s:9:\"AhrefsBot\";i:23;s:7:\"MJ12bot\";i:24;s:15:\"NetSeer crawler\";i:25;s:11:\"TurnitinBot\";i:26;s:14:\"magpie-crawler\";i:27;s:13:\"Nutch Crawler\";i:28;s:11:\"CMS Crawler\";i:29;s:8:\"rogerbot\";i:30;s:8:\"Domnutch\";i:31;s:11:\"ssearch_bot\";i:32;s:7:\"XoviBot\";i:33;s:9:\"digincore\";i:34;s:10:\"fr-crawler\";i:35;s:9:\"SeznamBot\";i:36;s:27:\"Seznam screenshot-generator\";i:37;s:7:\"Facebot\";i:38;s:19:\"facebookexternalhit\";i:39;s:9:\"SimplePie\";i:40;s:7:\"Riddler\";i:41;s:14:\"007ac9 Crawler\";i:42;s:9:\"360Spider\";i:43;s:10:\"A6-Indexer\";i:44;s:7:\"ADmantX\";i:45;s:3:\"AHC\";i:46;s:11:\"AISearchBot\";i:47;s:11:\"APIs-Google\";i:48;s:8:\"Aboundex\";i:49;s:7:\"AddThis\";i:50;s:8:\"Adidxbot\";i:51;s:13:\"AdsBot-Google\";i:52;s:13:\"AdsTxtCrawler\";i:53;s:6:\"AdvBot\";i:54;s:6:\"Ahrefs\";i:55;s:8:\"AlphaBot\";i:56;s:17:\"Amazon CloudFront\";i:57;s:13:\"AndersPinkBot\";i:58;s:17:\"Apache-HttpClient\";i:59;s:8:\"Apercite\";i:60;s:16:\"AppEngine-Google\";i:61;s:8:\"Applebot\";i:62;s:10:\"ArchiveBot\";i:63;s:6:\"BDCbot\";i:64;s:9:\"BIGLOTRON\";i:65;s:7:\"BLEXBot\";i:66;s:8:\"BLP_bbot\";i:67;s:11:\"BTWebClient\";i:68;s:6:\"BUbiNG\";i:69;s:15:\"Baidu-YunGuanCe\";i:70;s:10:\"Barkrowler\";i:71;s:10:\"BehloolBot\";i:72;s:11:\"BingPreview\";i:73;s:10:\"BomboraBot\";i:74;s:16:\"Bot.AraTurka.com\";i:75;s:9:\"BoxcarBot\";i:76;s:11:\"BrandVerity\";i:77;s:4:\"Buck\";i:78;s:18:\"CC Metadata Scaper\";i:79;s:5:\"CCBot\";i:80;s:14:\"CapsuleChecker\";i:81;s:8:\"Cliqzbot\";i:82;s:23:\"CloudFlare-AlwaysOnline\";i:83;s:19:\"Companybook-Crawler\";i:84;s:13:\"ContextAd Bot\";i:85;s:9:\"CrunchBot\";i:86;s:19:\"CrystalSemanticsBot\";i:87;s:11:\"CyberPatrol\";i:88;s:9:\"DareBoost\";i:89;s:13:\"Datafeedwatch\";i:90;s:4:\"Daum\";i:91;s:5:\"DeuSu\";i:92;s:21:\"developers.google.com\";i:93;s:7:\"Diffbot\";i:94;s:11:\"Digg Deeper\";i:95;s:13:\"Digincore bot\";i:96;s:10:\"Discordbot\";i:97;s:6:\"Disqus\";i:98;s:7:\"DnyzBot\";i:99;s:22:\"Domain Re-Animator Bot\";i:100;s:14:\"DomainStatsBot\";i:101;s:11:\"DuckDuckBot\";i:102;s:23:\"DuckDuckGo-Favicons-Bot\";i:103;s:4:\"EZID\";i:104;s:7:\"Embedly\";i:105;s:17:\"EveryoneSocialBot\";i:106;s:11:\"ExtLinksBot\";i:107;s:23:\"FAST Enterprise Crawler\";i:108;s:15:\"FAST-WebCrawler\";i:109;s:18:\"Feedfetcher-Google\";i:110;s:6:\"Feedly\";i:111;s:11:\"Feedspotbot\";i:112;s:14:\"FemtosearchBot\";i:113;s:5:\"Fetch\";i:114;s:5:\"Fever\";i:115;s:21:\"Flamingo_SearchEngine\";i:116;s:14:\"FlipboardProxy\";i:117;s:7:\"Fyrebot\";i:118;s:13:\"GarlikCrawler\";i:119;s:6:\"Genieo\";i:120;s:9:\"Gigablast\";i:121;s:7:\"Gigabot\";i:122;s:13:\"GingerCrawler\";i:123;s:19:\"Gluten Free Crawler\";i:124;s:13:\"GnowitNewsbot\";i:125;s:14:\"Go-http-client\";i:126;s:22:\"Google-Adwords-Instant\";i:127;s:9:\"Gowikibot\";i:128;s:16:\"GrapeshotCrawler\";i:129;s:7:\"Grobbot\";i:130;s:7:\"HTTrack\";i:131;s:6:\"Hatena\";i:132;s:11:\"IAS crawler\";i:133;s:11:\"ICC-Crawler\";i:134;s:9:\"IndeedBot\";i:135;s:15:\"InterfaxScanBot\";i:136;s:10:\"IstellaBot\";i:137;s:9:\"James BOT\";i:138;s:14:\"Jamie\'s Spider\";i:139;s:8:\"Jetslide\";i:140;s:5:\"Jetty\";i:141;s:28:\"Jugendschutzprogramm-Crawler\";i:142;s:9:\"K7MLWCBot\";i:143;s:8:\"Kemvibot\";i:144;s:9:\"KosmioBot\";i:145;s:19:\"Landau-Media-Spider\";i:146;s:12:\"Laserlikebot\";i:147;s:8:\"Leikibot\";i:148;s:11:\"Linguee Bot\";i:149;s:12:\"LinkArchiver\";i:150;s:11:\"LinkedInBot\";i:151;s:10:\"LivelapBot\";i:152;s:16:\"Luminator-robots\";i:153;s:11:\"Mail.RU_Bot\";i:154;s:8:\"Mastodon\";i:155;s:7:\"MauiBot\";i:156;s:15:\"Mediatoolkitbot\";i:157;s:9:\"MegaIndex\";i:158;s:13:\"MeltwaterNews\";i:159;s:10:\"MetaJobBot\";i:160;s:7:\"MetaURI\";i:161;s:8:\"Miniflux\";i:162;s:9:\"MojeekBot\";i:163;s:8:\"Moreover\";i:164;s:8:\"MuckRack\";i:165;s:12:\"Multiviewbot\";i:166;s:4:\"NING\";i:167;s:16:\"NerdByNature.Bot\";i:168;s:19:\"NetcraftSurveyAgent\";i:169;s:8:\"Netvibes\";i:170;s:16:\"Nimbostratus-Bot\";i:171;s:6:\"Nuzzel\";i:172;s:10:\"Ocarinabot\";i:173;s:11:\"OpenHoseBot\";i:174;s:9:\"OrangeBot\";i:175;s:12:\"OutclicksBot\";i:176;s:8:\"PR-CY.RU\";i:177;s:10:\"PaperLiBot\";i:178;s:10:\"Pcore-HTTP\";i:179;s:9:\"PhantomJS\";i:180;s:7:\"PiplBot\";i:181;s:12:\"PocketParser\";i:182;s:9:\"Primalbot\";i:183;s:15:\"PrivacyAwareBot\";i:184;s:10:\"Pulsepoint\";i:185;s:13:\"Python-urllib\";i:186;s:8:\"Qwantify\";i:187;s:17:\"RankActiveLinkBot\";i:188;s:19:\"RetrevoPageAnalyzer\";i:189;s:7:\"SBL-BOT\";i:190;s:10:\"SEMrushBot\";i:191;s:8:\"SEOkicks\";i:192;s:8:\"SWIMGBot\";i:193;s:10:\"SafeDNSBot\";i:194;s:28:\"SafeSearch microdata crawler\";i:195;s:8:\"ScoutJet\";i:196;s:6:\"Scrapy\";i:197;s:25:\"Screaming Frog SEO Spider\";i:198;s:18:\"SemanticScholarBot\";i:199;s:13:\"SimpleCrawler\";i:200;s:15:\"Siteimprove.com\";i:201;s:15:\"SkypeUriPreview\";i:202;s:14:\"Slack-ImgProxy\";i:203;s:8:\"Slackbot\";i:204;s:9:\"Snacktory\";i:205;s:15:\"SocialRankIOBot\";i:206;s:5:\"Sogou\";i:207;s:5:\"Sonic\";i:208;s:12:\"StorygizeBot\";i:209;s:9:\"SurveyBot\";i:210;s:7:\"Sysomos\";i:211;s:12:\"TangibleeBot\";i:212;s:11:\"TelegramBot\";i:213;s:5:\"Teoma\";i:214;s:8:\"Thinklab\";i:215;s:6:\"TinEye\";i:216;s:13:\"ToutiaoSpider\";i:217;s:11:\"Traackr.com\";i:218;s:5:\"Trove\";i:219;s:12:\"TweetmemeBot\";i:220;s:10:\"Twitterbot\";i:221;s:6:\"Twurly\";i:222;s:6:\"Upflow\";i:223;s:11:\"UptimeRobot\";i:224;s:20:\"UsineNouvelleCrawler\";i:225;s:8:\"Veoozbot\";i:226;s:12:\"WeSEE:Search\";i:227;s:8:\"WhatsApp\";i:228;s:16:\"Xenu Link Sleuth\";i:229;s:3:\"Y!J\";i:230;s:3:\"YaK\";i:231;s:18:\"Yahoo Link Preview\";i:232;s:4:\"Yeti\";i:233;s:11:\"YisouSpider\";i:234;s:6:\"Zabbix\";i:235;s:11:\"ZoominfoBot\";i:236;s:6:\"ZumBot\";i:237;s:12:\"ZuperlistBot\";i:238;s:4:\"^LCC\";i:239;s:7:\"acapbot\";i:240;s:8:\"acoonbot\";i:241;s:10:\"adbeat_bot\";i:242;s:9:\"adscanner\";i:243;s:8:\"aiHitBot\";i:244;s:7:\"antibot\";i:245;s:6:\"arabot\";i:246;s:15:\"archive.org_bot\";i:247;s:5:\"axios\";i:248;s:15:\"backlinkcrawler\";i:249;s:7:\"betaBot\";i:250;s:10:\"bibnum.bnf\";i:251;s:6:\"binlar\";i:252;s:8:\"bitlybot\";i:253;s:9:\"blekkobot\";i:254;s:11:\"blogmuraBot\";i:255;s:10:\"bnf.fr_bot\";i:256;s:18:\"bot-pge.chlooe.com\";i:257;s:6:\"botify\";i:258;s:9:\"brainobot\";i:259;s:7:\"buzzbot\";i:260;s:9:\"cXensebot\";i:261;s:9:\"careerbot\";i:262;s:11:\"centurybot9\";i:263;s:15:\"changedetection\";i:264;s:10:\"check_http\";i:265;s:12:\"citeseerxbot\";i:266;s:6:\"coccoc\";i:267;s:21:\"collection@infegy.com\";i:268;s:22:\"content crawler spider\";i:269;s:8:\"contxbot\";i:270;s:7:\"convera\";i:271;s:9:\"crawler4j\";i:272;s:4:\"curl\";i:273;s:12:\"datagnionbot\";i:274;s:6:\"dcrawl\";i:275;s:15:\"deadlinkchecker\";i:276;s:8:\"discobot\";i:277;s:13:\"domaincrawler\";i:278;s:6:\"dotbot\";i:279;s:7:\"drupact\";i:280;s:13:\"ec2linkfinder\";i:281;s:10:\"edisterbot\";i:282;s:12:\"electricmonk\";i:283;s:8:\"elisabot\";i:284;s:7:\"epicbot\";i:285;s:6:\"eright\";i:286;s:16:\"europarchive.org\";i:287;s:6:\"exabot\";i:288;s:6:\"ezooms\";i:289;s:16:\"filterdb.iss.net\";i:290;s:8:\"findlink\";i:291;s:12:\"findthatfile\";i:292;s:8:\"findxbot\";i:293;s:6:\"fluffy\";i:294;s:7:\"fuelbot\";i:295;s:10:\"g00g1e.net\";i:296;s:12:\"g2reader-bot\";i:297;s:16:\"gnam gnam spider\";i:298;s:14:\"google-xrawler\";i:299;s:8:\"grub.org\";i:300;s:7:\"gslfbot\";i:301;s:8:\"heritrix\";i:302;s:8:\"http_get\";i:303;s:8:\"httpunit\";i:304;s:11:\"ia_archiver\";i:305;s:6:\"ichiro\";i:306;s:6:\"imrbot\";i:307;s:11:\"integromedb\";i:308;s:12:\"intelium_bot\";i:309;s:18:\"ip-web-crawler.com\";i:310;s:9:\"ips-agent\";i:311;s:7:\"iskanie\";i:312;s:23:\"it2media-domain-crawler\";i:313;s:7:\"jyxobot\";i:314;s:9:\"lb-spider\";i:315;s:6:\"libwww\";i:316;s:13:\"linkapediabot\";i:317;s:7:\"linkdex\";i:318;s:9:\"lipperhey\";i:319;s:6:\"lssbot\";i:320;s:16:\"lssrocketcrawler\";i:321;s:5:\"ltx71\";i:322;s:9:\"mappydata\";i:323;s:9:\"memorybot\";i:324;s:9:\"mindUpBot\";i:325;s:5:\"mlbot\";i:326;s:7:\"moatbot\";i:327;s:6:\"msnbot\";i:328;s:6:\"msrbot\";i:329;s:8:\"nerdybot\";i:330;s:20:\"netEstate NE Crawler\";i:331;s:17:\"netresearchserver\";i:332;s:14:\"newsharecounts\";i:333;s:9:\"newspaper\";i:334;s:8:\"niki-bot\";i:335;s:5:\"nutch\";i:336;s:6:\"okhttp\";i:337;s:6:\"omgili\";i:338;s:15:\"openindexspider\";i:339;s:8:\"page2rss\";i:340;s:9:\"panscient\";i:341;s:8:\"phpcrawl\";i:342;s:7:\"pingdom\";i:343;s:9:\"pinterest\";i:344;s:8:\"postrank\";i:345;s:8:\"proximic\";i:346;s:5:\"psbot\";i:347;s:7:\"purebot\";i:348;s:15:\"python-requests\";i:349;s:9:\"redditbot\";i:350;s:9:\"scribdbot\";i:351;s:7:\"seekbot\";i:352;s:11:\"semanticbot\";i:353;s:6:\"sentry\";i:354;s:11:\"seoscanners\";i:355;s:9:\"seznambot\";i:356;s:15:\"sistrix crawler\";i:357;s:7:\"sitebot\";i:358;s:17:\"siteexplorer.info\";i:359;s:6:\"smtbot\";i:360;s:5:\"spbot\";i:361;s:6:\"speedy\";i:362;s:7:\"summify\";i:363;s:8:\"tagoobot\";i:364;s:10:\"toplistbot\";i:365;s:11:\"tracemyfile\";i:366;s:14:\"trendictionbot\";i:367;s:11:\"turnitinbot\";i:368;s:9:\"twengabot\";i:369;s:5:\"um-LN\";i:370;s:12:\"urlappendbot\";i:371;s:10:\"vebidoobot\";i:372;s:7:\"vkShare\";i:373;s:8:\"voilabot\";i:374;s:11:\"wbsearchbot\";i:375;s:23:\"web-archive-net.com.bot\";i:376;s:17:\"webcompanycrawler\";i:377;s:6:\"webmon\";i:378;s:4:\"wget\";i:379;s:6:\"wocbot\";i:380;s:6:\"woobot\";i:381;s:8:\"woriobot\";i:382;s:6:\"wotbox\";i:383;s:7:\"xovibot\";i:384;s:7:\"yacybot\";i:385;s:10:\"yandex.com\";i:386;s:5:\"yanga\";i:387;s:7:\"yoozBot\";i:388;s:5:\"zgrab\";}s:32:\"api_oauth2_access_token_lifetime\";d:60;s:33:\"api_oauth2_refresh_token_lifetime\";d:14;s:16:\"unsubscribe_text\";s:68:\"<a href=\"|URL|\">Unsubscribe</a> to no longer receive emails from us.\";s:12:\"webview_text\";s:66:\"<a href=\"|URL|\">Having trouble reading this email? Click here.</a>\";s:19:\"unsubscribe_message\";s:146:\"We are sorry to see you go! |EMAIL| will no longer receive emails from us. If this was by mistake, <a href=\"|URL|\">click here to re-subscribe</a>.\";s:19:\"resubscribe_message\";s:102:\"|EMAIL| has been re-subscribed. If this was by mistake, <a href=\"|URL|\">click here to unsubscribe</a>.\";s:22:\"default_signature_text\";s:25:\"Best regards, |FROM_NAME|\";s:15:\"contact_columns\";a:8:{i:0;s:13:\"contactmeeyid\";i:1;s:4:\"name\";i:2;s:5:\"email\";i:3;s:8:\"location\";i:4;s:5:\"stage\";i:5;s:6:\"points\";i:6;s:11:\"last_active\";i:7;s:2:\"id\";}s:13:\"sms_transport\";N;s:24:\"saml_idp_email_attribute\";s:12:\"EmailAddress\";s:28:\"saml_idp_firstname_attribute\";s:9:\"FirstName\";s:27:\"saml_idp_lastname_attribute\";s:8:\"LastName\";}', '2024-06-30 15:20:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('12', '1', 'Hai Ha', 'lead', 'lead', '16', 'delete', 'a:1:{s:4:\"name\";s:13:\"Jimmy Sanchez\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('13', '1', 'Hai Ha', 'lead', 'lead', '15', 'delete', 'a:1:{s:4:\"name\";s:10:\"Paula Hill\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('14', '1', 'Hai Ha', 'lead', 'lead', '14', 'delete', 'a:1:{s:4:\"name\";s:12:\"Regina Dolph\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('15', '1', 'Hai Ha', 'lead', 'lead', '13', 'delete', 'a:1:{s:4:\"name\";s:16:\"Margaret Maguire\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('16', '1', 'Hai Ha', 'lead', 'lead', '12', 'delete', 'a:1:{s:4:\"name\";s:11:\"Pamela Wise\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('17', '1', 'Hai Ha', 'lead', 'lead', '11', 'delete', 'a:1:{s:4:\"name\";s:17:\"Guadalupe Strauss\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('18', '1', 'Hai Ha', 'lead', 'lead', '10', 'delete', 'a:1:{s:4:\"name\";s:14:\"Bruce Campbell\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('19', '1', 'Hai Ha', 'lead', 'lead', '9', 'delete', 'a:1:{s:4:\"name\";s:16:\"Leonard Sinclair\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('20', '1', 'Hai Ha', 'lead', 'lead', '8', 'delete', 'a:1:{s:4:\"name\";s:13:\"Kevin Kennedy\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('21', '1', 'Hai Ha', 'lead', 'lead', '7', 'delete', 'a:1:{s:4:\"name\";s:10:\"Jean Cross\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('22', '1', 'Hai Ha', 'lead', 'lead', '6', 'delete', 'a:1:{s:4:\"name\";s:11:\"Jose Patton\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('23', '1', 'Hai Ha', 'lead', 'lead', '5', 'delete', 'a:1:{s:4:\"name\";s:13:\"Daniel Wright\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('24', '1', 'Hai Ha', 'lead', 'lead', '4', 'delete', 'a:1:{s:4:\"name\";s:15:\"Andrew Flanagan\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('25', '1', 'Hai Ha', 'lead', 'lead', '3', 'delete', 'a:1:{s:4:\"name\";s:14:\"Stephanie Cone\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('26', '1', 'Hai Ha', 'lead', 'lead', '2', 'delete', 'a:1:{s:4:\"name\";s:14:\"Henry Catalano\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('27', '1', 'Hai Ha', 'lead', 'lead', '1', 'delete', 'a:1:{s:4:\"name\";s:11:\"Penny Moore\";}', '2024-06-30 15:27:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('28', '1', 'Hai Ha', 'lead', 'import', '2', 'create', 'a:6:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:8:{s:4:\"city\";s:4:\"city\";s:13:\"contactmeeyid\";s:13:\"contactmeeyid\";s:5:\"email\";s:5:\"email\";s:9:\"firstname\";s:9:\"firstname\";s:8:\"lastname\";s:8:\"lastname\";s:6:\"mobile\";s:6:\"mobile\";s:5:\"phone\";s:5:\"phone\";s:5:\"state\";s:5:\"state\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:8:{i:0;s:13:\"contactmeeyid\";i:1;s:9:\"firstname\";i:2;s:8:\"lastname\";i:3;s:5:\"email\";i:4;s:5:\"phone\";i:5;s:6:\"mobile\";i:6;s:4:\"city\";i:7;s:5:\"state\";}}i:1;a:4:{s:6:\"fields\";a:8:{s:4:\"city\";s:4:\"city\";s:13:\"contactmeeyid\";s:13:\"contactmeeyid\";s:5:\"email\";s:5:\"email\";s:9:\"firstname\";s:9:\"firstname\";s:8:\"lastname\";s:8:\"lastname\";s:6:\"mobile\";s:6:\"mobile\";s:5:\"phone\";s:5:\"phone\";s:5:\"state\";s:5:\"state\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:8:{i:0;s:13:\"contactmeeyid\";i:1;s:9:\"firstname\";i:2;s:8:\"lastname\";i:3;s:5:\"email\";i:4;s:5:\"phone\";i:5;s:6:\"mobile\";i:6;s:4:\"city\";i:7;s:5:\"state\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:21;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630152608.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:12:\"contac t.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 15:28:21', '127.0.0.1');
INSERT INTO audit_log VALUES ('29', '1', 'Hai Ha', 'lead', 'lead', '21', 'create', 'a:7:{s:6:\"fields\";a:6:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"64280ee582f486001dc95a1b\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Penny\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Moore\";}s:5:\"email\";a:2:{i:0;N;i:1;s:22:\"PennyKMoore@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"070 7086 0753\";}s:4:\"city\";a:2:{i:0;N;i:1;s:18:\"HEWELSFIELD COMMON\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Penny\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Moore\";}s:5:\"email\";a:2:{i:0;N;i:1;s:22:\"PennyKMoore@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"070 7086 0753\";}s:4:\"city\";a:2:{i:0;N;i:1;s:18:\"HEWELSFIELD COMMON\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.097644\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('30', '1', 'Hai Ha', 'lead', 'lead', '21', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('31', '1', 'Hai Ha', 'lead', 'lead', '22', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"664338d8b33bffda58e9f502\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Henry\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Catalano\";}s:5:\"email\";a:2:{i:0;N;i:1;s:25:\"HenryLCatalano@einrot.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"082 118 9037\";}s:4:\"city\";a:2:{i:0;N;i:1;s:10:\"Rustenburg\";}s:5:\"state\";a:2:{i:0;N;i:1;s:10:\"North West\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Henry\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Catalano\";}s:5:\"email\";a:2:{i:0;N;i:1;s:25:\"HenryLCatalano@einrot.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"082 118 9037\";}s:4:\"city\";a:2:{i:0;N;i:1;s:10:\"Rustenburg\";}s:5:\"state\";a:2:{i:0;N;i:1;s:10:\"North West\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.367938\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('32', '1', 'Hai Ha', 'lead', 'lead', '22', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('33', '1', 'Hai Ha', 'lead', 'lead', '23', 'create', 'a:7:{s:6:\"fields\";a:6:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"625a2d155216600019362c1e\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:9:\"Stephanie\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:4:\"Cone\";}s:5:\"email\";a:2:{i:0;N;i:1;s:26:\"StephanieMCone@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"078 4515 7520\";}s:4:\"city\";a:2:{i:0;N;i:1;s:4:\"PANT\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:9:\"Stephanie\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:4:\"Cone\";}s:5:\"email\";a:2:{i:0;N;i:1;s:26:\"StephanieMCone@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"078 4515 7520\";}s:4:\"city\";a:2:{i:0;N;i:1;s:4:\"PANT\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.419667\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('34', '1', 'Hai Ha', 'lead', 'lead', '23', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('35', '1', 'Hai Ha', 'lead', 'lead', '24', 'create', 'a:7:{s:6:\"fields\";a:6:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"664040de004ed6869bc07c5b\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Andrew\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Flanagan\";}s:5:\"email\";a:2:{i:0;N;i:1;s:26:\"AndrewVFlanagan@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"077 6574 7295\";}s:4:\"city\";a:2:{i:0;N;i:1;s:11:\"WEATHERCOTE\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Andrew\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Flanagan\";}s:5:\"email\";a:2:{i:0;N;i:1;s:26:\"AndrewVFlanagan@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"077 6574 7295\";}s:4:\"city\";a:2:{i:0;N;i:1;s:11:\"WEATHERCOTE\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.462253\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('36', '1', 'Hai Ha', 'lead', 'lead', '24', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('37', '1', 'Hai Ha', 'lead', 'lead', '25', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6632f93d2b4698893b0a2656\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Daniel\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:6:\"Wright\";}s:5:\"email\";a:2:{i:0;N;i:1;s:24:\"DanielAWright@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"082 673 3168\";}s:4:\"city\";a:2:{i:0;N;i:1;s:5:\"Qumbu\";}s:5:\"state\";a:2:{i:0;N;i:1;s:12:\"Eastern Cape\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Daniel\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:6:\"Wright\";}s:5:\"email\";a:2:{i:0;N;i:1;s:24:\"DanielAWright@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"082 673 3168\";}s:4:\"city\";a:2:{i:0;N;i:1;s:5:\"Qumbu\";}s:5:\"state\";a:2:{i:0;N;i:1;s:12:\"Eastern Cape\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.507140\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('38', '1', 'Hai Ha', 'lead', 'lead', '25', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('39', '1', 'Hai Ha', 'lead', 'lead', '26', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6642d26409302011f3dfc73b\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:4:\"Jose\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:6:\"Patton\";}s:5:\"email\";a:2:{i:0;N;i:1;s:26:\"JoseMPatton@jourrapide.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"250-453-4211\";}s:4:\"city\";a:2:{i:0;N;i:1;s:8:\"Ashcroft\";}s:5:\"state\";a:2:{i:0;N;i:1;s:2:\"BC\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:4:\"Jose\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:6:\"Patton\";}s:5:\"email\";a:2:{i:0;N;i:1;s:26:\"JoseMPatton@jourrapide.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"250-453-4211\";}s:4:\"city\";a:2:{i:0;N;i:1;s:8:\"Ashcroft\";}s:5:\"state\";a:2:{i:0;N;i:1;s:2:\"BC\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.586513\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('40', '1', 'Hai Ha', 'lead', 'lead', '26', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('41', '1', 'Hai Ha', 'lead', 'lead', '27', 'create', 'a:7:{s:6:\"fields\";a:6:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"66439079434a7d8497d64f12\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:4:\"Jean\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Cross\";}s:5:\"email\";a:2:{i:0;N;i:1;s:22:\"JeanGCross@armyspy.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"077 8114 7167\";}s:4:\"city\";a:2:{i:0;N;i:1;s:13:\"WEST CHINNOCK\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:4:\"Jean\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Cross\";}s:5:\"email\";a:2:{i:0;N;i:1;s:22:\"JeanGCross@armyspy.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"077 8114 7167\";}s:4:\"city\";a:2:{i:0;N;i:1;s:13:\"WEST CHINNOCK\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.630931\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('42', '1', 'Hai Ha', 'lead', 'lead', '27', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('43', '1', 'Hai Ha', 'lead', 'lead', '28', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6144830b2792fd26d7b89331\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Kevin\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Kennedy\";}s:5:\"email\";a:2:{i:0;N;i:1;s:23:\"KevinBKennedy@gustr.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(03) 5330 2874\";}s:4:\"city\";a:2:{i:0;N;i:1;s:8:\"COLBROOK\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"VIC\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Kevin\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Kennedy\";}s:5:\"email\";a:2:{i:0;N;i:1;s:23:\"KevinBKennedy@gustr.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(03) 5330 2874\";}s:4:\"city\";a:2:{i:0;N;i:1;s:8:\"COLBROOK\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"VIC\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.675364\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('44', '1', 'Hai Ha', 'lead', 'lead', '28', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('45', '1', 'Hai Ha', 'lead', 'lead', '29', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"625a2d155216600019362c1e\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:7:\"Leonard\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Sinclair\";}s:5:\"email\";a:2:{i:0;N;i:1;s:28:\"LeonardMSinclair@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"084 524 8203\";}s:4:\"city\";a:2:{i:0;N;i:1;s:9:\"Cape Town\";}s:5:\"state\";a:2:{i:0;N;i:1;s:12:\"Western Cape\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:7:\"Leonard\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Sinclair\";}s:5:\"email\";a:2:{i:0;N;i:1;s:28:\"LeonardMSinclair@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"084 524 8203\";}s:4:\"city\";a:2:{i:0;N;i:1;s:9:\"Cape Town\";}s:5:\"state\";a:2:{i:0;N;i:1;s:12:\"Western Cape\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.721486\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('46', '1', 'Hai Ha', 'lead', 'lead', '29', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('47', '1', 'Hai Ha', 'lead', 'lead', '30', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"61473c75a59b960018fed63b\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Bruce\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Campbell\";}s:5:\"email\";a:2:{i:0;N;i:1;s:25:\"BruceMCampbell@einrot.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(07) 3187 6375\";}s:4:\"city\";a:2:{i:0;N;i:1;s:12:\"MOOLBOOLAMAN\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"QLD\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Bruce\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Campbell\";}s:5:\"email\";a:2:{i:0;N;i:1;s:25:\"BruceMCampbell@einrot.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(07) 3187 6375\";}s:4:\"city\";a:2:{i:0;N;i:1;s:12:\"MOOLBOOLAMAN\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"QLD\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.765128\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('48', '1', 'Hai Ha', 'lead', 'lead', '30', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('49', '1', 'Hai Ha', 'lead', 'lead', '31', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6641c0cc09302011f3de442e\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:9:\"Guadalupe\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Strauss\";}s:5:\"email\";a:2:{i:0;N;i:1;s:29:\"GuadalupeHStrauss@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(08) 9029 4631\";}s:4:\"city\";a:2:{i:0;N;i:1;s:8:\"TOOLIBIN\";}s:5:\"state\";a:2:{i:0;N;i:1;s:2:\"WA\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:9:\"Guadalupe\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Strauss\";}s:5:\"email\";a:2:{i:0;N;i:1;s:29:\"GuadalupeHStrauss@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(08) 9029 4631\";}s:4:\"city\";a:2:{i:0;N;i:1;s:8:\"TOOLIBIN\";}s:5:\"state\";a:2:{i:0;N;i:1;s:2:\"WA\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.813288\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('50', '1', 'Hai Ha', 'lead', 'lead', '31', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('51', '1', 'Hai Ha', 'lead', 'lead', '32', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"662e683abcaff9d0288fb6d8\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Pamela\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:4:\"Wise\";}s:5:\"email\";a:2:{i:0;N;i:1;s:21:\"PamelaSWise@gustr.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(03) 5389 0975\";}s:4:\"city\";a:2:{i:0;N;i:1;s:7:\"WARROCK\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"VIC\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Pamela\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:4:\"Wise\";}s:5:\"email\";a:2:{i:0;N;i:1;s:21:\"PamelaSWise@gustr.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(03) 5389 0975\";}s:4:\"city\";a:2:{i:0;N;i:1;s:7:\"WARROCK\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"VIC\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.859130\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('52', '1', 'Hai Ha', 'lead', 'lead', '32', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('53', '1', 'Hai Ha', 'lead', 'lead', '33', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"66430bcd09302011f3e04cf5\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:8:\"Margaret\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Maguire\";}s:5:\"email\";a:2:{i:0;N;i:1;s:25:\"MargaretDMaguire@cuvox.de\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"450-439-2306\";}s:4:\"city\";a:2:{i:0;N;i:1;s:11:\"Laurentides\";}s:5:\"state\";a:2:{i:0;N;i:1;s:2:\"QC\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:8:\"Margaret\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Maguire\";}s:5:\"email\";a:2:{i:0;N;i:1;s:25:\"MargaretDMaguire@cuvox.de\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"450-439-2306\";}s:4:\"city\";a:2:{i:0;N;i:1;s:11:\"Laurentides\";}s:5:\"state\";a:2:{i:0;N;i:1;s:2:\"QC\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.902929\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('54', '1', 'Hai Ha', 'lead', 'lead', '33', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('55', '1', 'Hai Ha', 'lead', 'lead', '34', 'create', 'a:7:{s:6:\"fields\";a:6:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6642f18abd0df3b8db7455f5\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Regina\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Dolph\";}s:5:\"email\";a:2:{i:0;N;i:1;s:24:\"ReginaBDolph@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"077 0685 3094\";}s:4:\"city\";a:2:{i:0;N;i:1;s:5:\"SOLAS\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Regina\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Dolph\";}s:5:\"email\";a:2:{i:0;N;i:1;s:24:\"ReginaBDolph@teleworm.us\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:13:\"077 0685 3094\";}s:4:\"city\";a:2:{i:0;N;i:1;s:5:\"SOLAS\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:23.950469\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('56', '1', 'Hai Ha', 'lead', 'lead', '34', 'identified', 'a:0:{}', '2024-06-30 15:28:23', '127.0.0.1');
INSERT INTO audit_log VALUES ('57', '1', 'Hai Ha', 'lead', 'lead', '35', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"5e7671085071cd1c9e8f4a88\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Paula\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:4:\"Hill\";}s:5:\"email\";a:2:{i:0;N;i:1;s:21:\"PaulaWHill@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"085 488 7773\";}s:4:\"city\";a:2:{i:0;N;i:1;s:5:\"Brits\";}s:5:\"state\";a:2:{i:0;N;i:1;s:10:\"North West\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Paula\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:4:\"Hill\";}s:5:\"email\";a:2:{i:0;N;i:1;s:21:\"PaulaWHill@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:12:\"085 488 7773\";}s:4:\"city\";a:2:{i:0;N;i:1;s:5:\"Brits\";}s:5:\"state\";a:2:{i:0;N;i:1;s:10:\"North West\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:24.054004\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('58', '1', 'Hai Ha', 'lead', 'lead', '35', 'identified', 'a:0:{}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('59', '1', 'Hai Ha', 'lead', 'lead', '36', 'create', 'a:8:{s:6:\"fields\";a:7:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"64c37bee643774001dce6b0f\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Jimmy\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Sanchez\";}s:5:\"email\";a:2:{i:0;N;i:1;s:24:\"JimmyCSanchez@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(07) 4042 9552\";}s:4:\"city\";a:2:{i:0;N;i:1;s:14:\"COQUETTE POINT\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"QLD\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Jimmy\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:7:\"Sanchez\";}s:5:\"email\";a:2:{i:0;N;i:1;s:24:\"JimmyCSanchez@dayrep.com\";}s:5:\"phone\";a:2:{i:0;N;i:1;s:14:\"(07) 4042 9552\";}s:4:\"city\";a:2:{i:0;N;i:1;s:14:\"COQUETTE POINT\";}s:5:\"state\";a:2:{i:0;N;i:1;s:3:\"QLD\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:24.119670\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('60', '1', 'Hai Ha', 'lead', 'lead', '36', 'identified', 'a:0:{}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('61', '1', 'Hai Ha', 'lead', 'lead', '37', 'create', 'a:4:{s:6:\"fields\";a:3:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6642fa70004ed6869bc48dee\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:7:\"Mildred\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:9:\"Rodriguez\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:7:\"Mildred\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:9:\"Rodriguez\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:24.162049\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('62', '1', 'Hai Ha', 'lead', 'lead', '37', 'identified', 'a:0:{}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('63', '1', 'Hai Ha', 'lead', 'lead', '38', 'create', 'a:4:{s:6:\"fields\";a:3:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"6642f629004ed6869bc48654\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Kyung\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Brittain\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:5:\"Kyung\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:8:\"Brittain\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:24.206857\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('64', '1', 'Hai Ha', 'lead', 'lead', '38', 'identified', 'a:0:{}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('65', '1', 'Hai Ha', 'lead', 'lead', '39', 'create', 'a:4:{s:6:\"fields\";a:3:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"643e68fb03e8bf001da908f9\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Willie\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Perez\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Willie\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:5:\"Perez\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:24.247498\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('66', '1', 'Hai Ha', 'lead', 'lead', '39', 'identified', 'a:0:{}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('67', '1', 'Hai Ha', 'lead', 'lead', '40', 'create', 'a:4:{s:6:\"fields\";a:3:{s:13:\"contactmeeyid\";a:2:{i:0;N;i:1;s:24:\"643e68fb03e8bf001da908f9\";}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Marvin\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:9:\"Patterson\";}}s:9:\"firstname\";a:2:{i:0;N;i:1;s:6:\"Marvin\";}s:8:\"lastname\";a:2:{i:0;N;i:1;s:9:\"Patterson\";}s:14:\"dateIdentified\";a:2:{i:0;s:0:\"\";i:1;O:8:\"DateTime\":3:{s:4:\"date\";s:26:\"2024-06-30 15:28:24.288359\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";}}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('68', '1', 'Hai Ha', 'lead', 'lead', '40', 'identified', 'a:0:{}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('69', '1', 'Hai Ha', 'lead', 'import', '2', 'update', 'a:6:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:28:22+00:00\";}s:13:\"insertedCount\";a:2:{i:0;i:19;i:1;i:20;}s:12:\"ignoredCount\";a:2:{i:0;i:0;i:1;i:1;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:28:24+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:28:24+00:00\";}}', '2024-06-30 15:28:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('70', '1', 'Hai Ha', 'lead', 'lead', '40', 'delete', 'a:1:{s:4:\"name\";s:16:\"Marvin Patterson\";}', '2024-06-30 15:29:08', '127.0.0.1');
INSERT INTO audit_log VALUES ('71', '1', 'Hai Ha', 'lead', 'lead', '39', 'delete', 'a:1:{s:4:\"name\";s:12:\"Willie Perez\";}', '2024-06-30 15:29:08', '127.0.0.1');
INSERT INTO audit_log VALUES ('72', '1', 'Hai Ha', 'lead', 'lead', '38', 'delete', 'a:1:{s:4:\"name\";s:14:\"Kyung Brittain\";}', '2024-06-30 15:29:08', '127.0.0.1');
INSERT INTO audit_log VALUES ('73', '1', 'Hai Ha', 'lead', 'lead', '37', 'delete', 'a:1:{s:4:\"name\";s:17:\"Mildred Rodriguez\";}', '2024-06-30 15:29:08', '127.0.0.1');
INSERT INTO audit_log VALUES ('74', '1', 'Hai Ha', 'lead', 'import', '3', 'create', 'a:7:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:10:{s:11:\"eventmeeyid\";s:11:\"eventmeeyid\";s:8:\"geo_city\";s:8:\"geo_city\";s:13:\"geo_continent\";s:13:\"geo_continent\";s:11:\"geo_country\";s:11:\"geo_country\";s:10:\"geo_region\";s:10:\"geo_region\";s:19:\"param_ga_session_id\";s:19:\"param_ga_session_id\";s:19:\"param_page_location\";s:19:\"param_page_location\";s:16:\"param_page_title\";s:16:\"param_page_title\";s:8:\"platform\";s:13:\"eventplatform\";s:9:\"eventname\";s:9:\"eventname\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:11:{i:0;s:12:\"﻿eventname\";i:1;s:11:\"eventmeeyid\";i:2;s:14:\"is_active_user\";i:3;s:8:\"platform\";i:4;s:8:\"geo_city\";i:5;s:11:\"geo_country\";i:6;s:13:\"geo_continent\";i:7;s:10:\"geo_region\";i:8;s:19:\"param_page_location\";i:9;s:16:\"param_page_title\";i:10;s:19:\"param_ga_session_id\";}}i:1;a:4:{s:6:\"fields\";a:10:{s:11:\"eventmeeyid\";s:11:\"eventmeeyid\";s:8:\"geo_city\";s:8:\"geo_city\";s:13:\"geo_continent\";s:13:\"geo_continent\";s:11:\"geo_country\";s:11:\"geo_country\";s:10:\"geo_region\";s:10:\"geo_region\";s:19:\"param_ga_session_id\";s:19:\"param_ga_session_id\";s:19:\"param_page_location\";s:19:\"param_page_location\";s:16:\"param_page_title\";s:16:\"param_page_title\";s:8:\"platform\";s:13:\"eventplatform\";s:9:\"eventname\";s:9:\"eventname\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:11:{i:0;s:12:\"﻿eventname\";i:1;s:11:\"eventmeeyid\";i:2;s:14:\"is_active_user\";i:3;s:8:\"platform\";i:4;s:8:\"geo_city\";i:5;s:11:\"geo_country\";i:6;s:13:\"geo_continent\";i:7;s:10:\"geo_region\";i:8;s:19:\"param_page_location\";i:9;s:16:\"param_page_title\";i:10;s:19:\"param_ga_session_id\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:5:\"event\";}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:21;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630153046.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:14:\"event_data.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 15:36:54', '127.0.0.1');
INSERT INTO audit_log VALUES ('75', '1', 'Hai Ha', 'lead', 'import', '3', 'update', 'a:7:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:36:55+00:00\";}s:13:\"insertedCount\";a:2:{i:0;i:17;i:1;i:18;}s:12:\"updatedCount\";a:2:{i:0;i:1;i:1;i:2;}s:12:\"ignoredCount\";a:2:{i:0;i:0;i:1;i:1;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:36:56+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T15:36:56+00:00\";}}', '2024-06-30 15:36:56', '127.0.0.1');
INSERT INTO audit_log VALUES ('76', '1', 'Hai Ha', 'lead', 'field', '58', 'delete', 'a:2:{i:0;s:4:\"name\";i:1;s:18:\"Transaction MeeyID\";}', '2024-06-30 16:30:01', '127.0.0.1');
INSERT INTO audit_log VALUES ('77', '1', 'Hai Ha', 'lead', 'field', '62', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:18:\"Transaction MeeyID\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:10:\"tranmeeyid\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:30:40', '127.0.0.1');
INSERT INTO audit_log VALUES ('78', '1', 'Hai Ha', 'lead', 'field', '62', 'delete', 'a:2:{i:0;s:4:\"name\";i:1;s:18:\"Transaction MeeyID\";}', '2024-06-30 16:32:12', '127.0.0.1');
INSERT INTO audit_log VALUES ('79', '1', 'Hai Ha', 'lead', 'field', '63', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:18:\"Transaction MeeyID\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:10:\"tranmeeyid\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:34:03', '127.0.0.1');
INSERT INTO audit_log VALUES ('80', '1', 'Hai Ha', 'lead', 'field', '63', 'delete', 'a:2:{i:0;s:4:\"name\";i:1;s:18:\"Transaction MeeyID\";}', '2024-06-30 16:41:39', '127.0.0.1');
INSERT INTO audit_log VALUES ('81', '1', 'Hai Ha', 'lead', 'field', '64', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:18:\"Transaction MeeyID\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:10:\"tranmeeyid\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:42:08', '127.0.0.1');
INSERT INTO audit_log VALUES ('82', '1', 'Hai Ha', 'lead', 'field', '65', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:16:\"Transaction Code\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:8:\"trancode\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:42:41', '127.0.0.1');
INSERT INTO audit_log VALUES ('83', '1', 'Hai Ha', 'lead', 'field', '64', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:1;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:43:05+00:00\";}}', '2024-06-30 16:43:05', '127.0.0.1');
INSERT INTO audit_log VALUES ('84', '1', 'Hai Ha', 'lead', 'field', '66', 'create', 'a:7:{s:5:\"label\";a:2:{i:0;N;i:1;s:14:\"Transaction ID\";}s:5:\"alias\";a:2:{i:0;N;i:1;s:8:\"tranidid\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:45:21', '127.0.0.1');
INSERT INTO audit_log VALUES ('85', '1', 'Hai Ha', 'lead', 'field', '67', 'create', 'a:9:{s:5:\"label\";a:2:{i:0;N;i:1;s:17:\"Transaction Price\";}s:4:\"type\";a:2:{i:0;s:4:\"text\";i:1;s:6:\"number\";}s:10:\"properties\";a:2:{i:0;a:2:{s:9:\"roundmode\";s:1:\"3\";s:5:\"scale\";N;}i:1;a:2:{s:9:\"roundmode\";s:1:\"3\";s:5:\"scale\";s:0:\"\";}}s:5:\"alias\";a:2:{i:0;N;i:1;s:9:\"tranprice\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:46:07', '127.0.0.1');
INSERT INTO audit_log VALUES ('86', '1', 'Hai Ha', 'lead', 'field', '68', 'create', 'a:9:{s:5:\"label\";a:2:{i:0;N;i:1;s:18:\"Transaction Status\";}s:4:\"type\";a:2:{i:0;s:4:\"text\";i:1;s:6:\"number\";}s:10:\"properties\";a:2:{i:0;a:2:{s:9:\"roundmode\";s:1:\"3\";s:5:\"scale\";N;}i:1;a:2:{s:9:\"roundmode\";s:1:\"3\";s:5:\"scale\";s:0:\"\";}}s:5:\"alias\";a:2:{i:0;N;i:1;s:10:\"transtatus\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:47:07', '127.0.0.1');
INSERT INTO audit_log VALUES ('87', '1', 'Hai Ha', 'lead', 'field', '69', 'create', 'a:7:{s:5:\"label\";a:2:{i:0;N;i:1;s:21:\"Transaction ProductId\";}s:5:\"alias\";a:2:{i:0;N;i:1;s:13:\"tranproductid\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:47:52', '127.0.0.1');
INSERT INTO audit_log VALUES ('88', '1', 'Hai Ha', 'lead', 'field', '70', 'create', 'a:7:{s:5:\"label\";a:2:{i:0;N;i:1;s:23:\"Transaction Platform_id\";}s:5:\"alias\";a:2:{i:0;N;i:1;s:14:\"tranplatform_d\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:48:37', '127.0.0.1');
INSERT INTO audit_log VALUES ('89', '1', 'Hai Ha', 'lead', 'field', '66', 'delete', 'a:2:{i:0;s:4:\"name\";i:1;s:14:\"Transaction ID\";}', '2024-06-30 16:48:58', '127.0.0.1');
INSERT INTO audit_log VALUES ('90', '1', 'Hai Ha', 'lead', 'field', '70', 'delete', 'a:2:{i:0;s:4:\"name\";i:1;s:23:\"Transaction Platform_id\";}', '2024-06-30 16:49:18', '127.0.0.1');
INSERT INTO audit_log VALUES ('91', '1', 'Hai Ha', 'lead', 'field', '71', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:23:\"Transaction Platform_id\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:12:\"tranplatform\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:50:07', '127.0.0.1');
INSERT INTO audit_log VALUES ('92', '1', 'Hai Ha', 'lead', 'field', '72', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:22:\"Transaction sale email\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:13:\"transaleemail\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:51:35', '127.0.0.1');
INSERT INTO audit_log VALUES ('93', '1', 'Hai Ha', 'lead', 'field', '73', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:24:\"Transaction Created Date\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:15:\"trancreateddate\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:52:21', '127.0.0.1');
INSERT INTO audit_log VALUES ('94', '1', 'Hai Ha', 'lead', 'field', '74', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:24:\"Transaction Updated Date\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:15:\"tranupdateddate\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:52:58', '127.0.0.1');
INSERT INTO audit_log VALUES ('95', '1', 'Hai Ha', 'lead', 'field', '75', 'create', 'a:8:{s:5:\"label\";a:2:{i:0;N;i:1;s:14:\"Transaction ID\";}s:5:\"order\";a:2:{i:0;i:1;i:1;i:0;}s:5:\"alias\";a:2:{i:0;N;i:1;s:6:\"tranid\";}s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:0;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}}', '2024-06-30 16:56:07', '127.0.0.1');
INSERT INTO audit_log VALUES ('96', '1', 'Hai Ha', 'lead', 'import', '4', 'create', 'a:7:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}}i:1;a:4:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:20;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630165619.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:23:\"fact_order_official.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 16:56:31', '127.0.0.1');
INSERT INTO audit_log VALUES ('97', '1', 'Hai Ha', 'lead', 'import', '4', 'update', 'a:5:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:56:32+00:00\";}s:12:\"ignoredCount\";a:2:{i:0;i:19;i:1;i:20;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:56:33+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:56:33+00:00\";}}', '2024-06-30 16:56:33', '127.0.0.1');
INSERT INTO audit_log VALUES ('98', '1', 'Hai Ha', 'lead', 'field', '75', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:0;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:57:26+00:00\";}}', '2024-06-30 16:57:26', '127.0.0.1');
INSERT INTO audit_log VALUES ('99', '1', 'Hai Ha', 'lead', 'field', '64', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:1;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;s:25:\"2024-06-30T16:43:05+00:00\";i:1;s:25:\"2024-06-30T16:57:41+00:00\";}}', '2024-06-30 16:57:41', '127.0.0.1');
INSERT INTO audit_log VALUES ('100', '1', 'Hai Ha', 'lead', 'import', '5', 'create', 'a:7:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}}i:1;a:4:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:20;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630165749.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:23:\"fact_order_official.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 16:58:01', '127.0.0.1');
INSERT INTO audit_log VALUES ('101', '1', 'Hai Ha', 'lead', 'import', '5', 'update', 'a:5:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:58:02+00:00\";}s:12:\"ignoredCount\";a:2:{i:0;i:19;i:1;i:20;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:58:03+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:58:03+00:00\";}}', '2024-06-30 16:58:03', '127.0.0.1');
INSERT INTO audit_log VALUES ('102', '1', 'Hai Ha', 'lead', 'field', '65', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:1;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T16:59:34+00:00\";}}', '2024-06-30 16:59:34', '127.0.0.1');
INSERT INTO audit_log VALUES ('103', '1', 'Hai Ha', 'lead', 'import', '6', 'create', 'a:7:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}}i:1;a:4:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:20;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630170213.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:23:\"fact_order_official.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 17:03:38', '127.0.0.1');
INSERT INTO audit_log VALUES ('104', '1', 'Hai Ha', 'lead', 'import', '6', 'update', 'a:5:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:03:40+00:00\";}s:12:\"ignoredCount\";a:2:{i:0;i:19;i:1;i:20;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:03:40+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:03:40+00:00\";}}', '2024-06-30 17:03:40', '127.0.0.1');
INSERT INTO audit_log VALUES ('105', '1', 'Hai Ha', 'lead', 'field', '64', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:1;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;s:25:\"2024-06-30T16:57:41+00:00\";i:1;s:25:\"2024-06-30T17:05:59+00:00\";}}', '2024-06-30 17:05:59', '127.0.0.1');
INSERT INTO audit_log VALUES ('106', '1', 'Hai Ha', 'lead', 'import', '7', 'create', 'a:7:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}}i:1;a:4:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:20;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630170540.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:23:\"fact_order_official.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 17:06:32', '127.0.0.1');
INSERT INTO audit_log VALUES ('107', '1', 'Hai Ha', 'lead', 'import', '7', 'update', 'a:5:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:06:33+00:00\";}s:12:\"ignoredCount\";a:2:{i:0;i:19;i:1;i:20;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:06:33+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:06:33+00:00\";}}', '2024-06-30 17:06:33', '127.0.0.1');
INSERT INTO audit_log VALUES ('108', '1', 'Hai Ha', 'lead', 'field', '65', 'update', 'a:5:{s:10:\"isRequired\";a:2:{i:0;b:1;i:1;i:1;}s:9:\"isVisible\";a:2:{i:0;b:1;i:1;i:1;}s:14:\"isShortVisible\";a:2:{i:0;b:1;i:1;i:1;}s:10:\"isListable\";a:2:{i:0;b:1;i:1;i:1;}s:12:\"dateModified\";a:2:{i:0;s:25:\"2024-06-30T16:59:34+00:00\";i:1;s:25:\"2024-06-30T17:07:24+00:00\";}}', '2024-06-30 17:07:24', '127.0.0.1');
INSERT INTO audit_log VALUES ('109', '1', 'Hai Ha', 'lead', 'import', '8', 'create', 'a:7:{s:10:\"properties\";a:2:{i:0;a:3:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}}i:1;a:4:{s:6:\"fields\";a:10:{s:8:\"trancode\";s:8:\"trancode\";s:15:\"trancreateddate\";s:15:\"trancreateddate\";s:6:\"tranid\";s:6:\"tranid\";s:10:\"tranmeeyid\";s:10:\"tranmeeyid\";s:12:\"tranplatform\";s:12:\"tranplatform\";s:9:\"tranprice\";s:9:\"tranprice\";s:13:\"tranproductid\";s:13:\"tranproductid\";s:13:\"transaleemail\";s:13:\"transaleemail\";s:10:\"transtatus\";s:10:\"transtatus\";s:15:\"tranupdateddate\";s:15:\"tranupdateddate\";}s:8:\"defaults\";a:4:{s:5:\"owner\";N;s:4:\"list\";N;s:4:\"tags\";a:0:{}s:14:\"skip_if_exists\";b:0;}s:7:\"headers\";a:10:{i:0;s:6:\"tranid\";i:1;s:8:\"trancode\";i:2;s:10:\"tranmeeyid\";i:3;s:9:\"tranprice\";i:4;s:10:\"transtatus\";i:5;s:13:\"tranproductid\";i:6;s:12:\"tranplatform\";i:7;s:13:\"transaleemail\";i:8;s:15:\"trancreateddate\";i:9;s:15:\"tranupdateddate\";}s:6:\"parser\";a:4:{s:9:\"delimiter\";s:1:\",\";s:9:\"enclosure\";s:1:\"\"\";s:6:\"escape\";s:1:\"\\\";s:10:\"batchlimit\";i:100;}}}s:6:\"object\";a:2:{i:0;s:4:\"lead\";i:1;s:11:\"transaction\";}s:3:\"dir\";a:2:{i:0;N;i:1;s:52:\"D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports\";}s:9:\"lineCount\";a:2:{i:0;i:0;i:1;i:20;}s:4:\"file\";a:2:{i:0;s:10:\"import.csv\";i:1;s:18:\"20240630170733.csv\";}s:12:\"originalFile\";a:2:{i:0;N;i:1;s:23:\"fact_order_official.csv\";}s:6:\"status\";a:2:{i:0;i:1;i:1;i:6;}}', '2024-06-30 17:07:42', '127.0.0.1');
INSERT INTO audit_log VALUES ('110', '1', 'Hai Ha', 'lead', 'import', '8', 'update', 'a:5:{s:11:\"dateStarted\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:07:43+00:00\";}s:12:\"ignoredCount\";a:2:{i:0;i:19;i:1;i:20;}s:6:\"status\";a:2:{i:0;i:6;i:1;i:3;}s:9:\"dateEnded\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:07:43+00:00\";}s:12:\"dateModified\";a:2:{i:0;N;i:1;s:25:\"2024-06-30T17:07:43+00:00\";}}', '2024-06-30 17:07:44', '127.0.0.1');

-- ----------------------------
-- Table structure for `bundle_grapesjsbuilder`
-- ----------------------------
DROP TABLE IF EXISTS `bundle_grapesjsbuilder`;
CREATE TABLE `bundle_grapesjsbuilder` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(10) unsigned DEFAULT NULL,
  `custom_mjml` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_56A1EB07A832C1C9` (`email_id`),
  CONSTRAINT `FK_56A1EB07A832C1C9` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of bundle_grapesjsbuilder
-- ----------------------------

-- ----------------------------
-- Table structure for `cache_items`
-- ----------------------------
DROP TABLE IF EXISTS `cache_items`;
CREATE TABLE `cache_items` (
  `item_id` varbinary(255) NOT NULL,
  `item_data` longblob NOT NULL,
  `item_lifetime` int(10) unsigned DEFAULT NULL,
  `item_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of cache_items
-- ----------------------------

-- ----------------------------
-- Table structure for `campaigns`
-- ----------------------------
DROP TABLE IF EXISTS `campaigns`;
CREATE TABLE `campaigns` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `canvas_settings` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `allow_restart` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E373747012469DE2` (`category_id`),
  CONSTRAINT `FK_E373747012469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaigns
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_events`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_events`;
CREATE TABLE `campaign_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` int(10) unsigned NOT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `event_order` int(11) NOT NULL,
  `properties` longtext NOT NULL COMMENT '(DC2Type:array)',
  `trigger_date` datetime DEFAULT NULL,
  `trigger_interval` int(11) DEFAULT NULL,
  `trigger_interval_unit` varchar(1) DEFAULT NULL,
  `trigger_hour` time DEFAULT NULL,
  `trigger_restricted_start_hour` time DEFAULT NULL,
  `trigger_restricted_stop_hour` time DEFAULT NULL,
  `trigger_restricted_dow` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `trigger_mode` varchar(10) DEFAULT NULL,
  `decision_path` varchar(191) DEFAULT NULL,
  `temp_id` varchar(191) DEFAULT NULL,
  `channel` varchar(191) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_8EC42EE7F639F774` (`campaign_id`),
  KEY `IDX_8EC42EE7727ACA70` (`parent_id`),
  KEY `campaign_event_search` (`type`,`event_type`),
  KEY `campaign_event_type` (`event_type`),
  KEY `campaign_event_channel` (`channel`,`channel_id`),
  CONSTRAINT `FK_8EC42EE7727ACA70` FOREIGN KEY (`parent_id`) REFERENCES `campaign_events` (`id`),
  CONSTRAINT `FK_8EC42EE7F639F774` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_events
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_form_xref`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_form_xref`;
CREATE TABLE `campaign_form_xref` (
  `campaign_id` int(10) unsigned NOT NULL,
  `form_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`campaign_id`,`form_id`),
  KEY `IDX_3048A8B25FF69B7D` (`form_id`),
  CONSTRAINT `FK_3048A8B25FF69B7D` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_3048A8B2F639F774` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_form_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_leadlist_xref`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_leadlist_xref`;
CREATE TABLE `campaign_leadlist_xref` (
  `campaign_id` int(10) unsigned NOT NULL,
  `leadlist_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`campaign_id`,`leadlist_id`),
  KEY `IDX_6480052EB9FC8874` (`leadlist_id`),
  CONSTRAINT `FK_6480052EB9FC8874` FOREIGN KEY (`leadlist_id`) REFERENCES `lead_lists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_6480052EF639F774` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_leadlist_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_leads`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_leads`;
CREATE TABLE `campaign_leads` (
  `campaign_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `manually_removed` tinyint(1) NOT NULL,
  `manually_added` tinyint(1) NOT NULL,
  `date_last_exited` datetime DEFAULT NULL,
  `rotation` int(11) NOT NULL,
  PRIMARY KEY (`campaign_id`,`lead_id`),
  KEY `IDX_5995213D55458D` (`lead_id`),
  KEY `campaign_leads_date_added` (`date_added`),
  KEY `campaign_leads_date_exited` (`date_last_exited`),
  KEY `campaign_leads` (`campaign_id`,`manually_removed`,`lead_id`,`rotation`),
  CONSTRAINT `FK_5995213D55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_5995213DF639F774` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_leads
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_lead_event_failed_log`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_lead_event_failed_log`;
CREATE TABLE `campaign_lead_event_failed_log` (
  `log_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `reason` longtext DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `campaign_event_failed_date` (`date_added`),
  CONSTRAINT `FK_E50614D2EA675D86` FOREIGN KEY (`log_id`) REFERENCES `campaign_lead_event_log` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_lead_event_failed_log
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_lead_event_log`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_lead_event_log`;
CREATE TABLE `campaign_lead_event_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `campaign_id` int(10) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `rotation` int(11) NOT NULL,
  `date_triggered` datetime DEFAULT NULL,
  `is_scheduled` tinyint(1) NOT NULL,
  `trigger_date` datetime DEFAULT NULL,
  `system_triggered` tinyint(1) NOT NULL,
  `metadata` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `channel` varchar(191) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `non_action_path_taken` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_rotation` (`event_id`,`lead_id`,`rotation`),
  KEY `IDX_B7420BA171F7E88B` (`event_id`),
  KEY `IDX_B7420BA155458D` (`lead_id`),
  KEY `IDX_B7420BA1F639F774` (`campaign_id`),
  KEY `IDX_B7420BA1A03F5E9F` (`ip_id`),
  KEY `campaign_event_upcoming_search` (`is_scheduled`,`lead_id`),
  KEY `campaign_event_schedule_counts` (`campaign_id`,`is_scheduled`,`trigger_date`),
  KEY `campaign_date_triggered` (`date_triggered`),
  KEY `campaign_leads` (`lead_id`,`campaign_id`,`rotation`),
  KEY `campaign_log_channel` (`channel`,`channel_id`,`lead_id`),
  KEY `campaign_actions` (`campaign_id`,`event_id`,`date_triggered`),
  KEY `campaign_stats` (`campaign_id`,`date_triggered`,`event_id`,`non_action_path_taken`),
  KEY `campaign_trigger_date_order` (`trigger_date`),
  CONSTRAINT `FK_B7420BA155458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B7420BA171F7E88B` FOREIGN KEY (`event_id`) REFERENCES `campaign_events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B7420BA1A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_B7420BA1F639F774` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_lead_event_log
-- ----------------------------

-- ----------------------------
-- Table structure for `campaign_summary`
-- ----------------------------
DROP TABLE IF EXISTS `campaign_summary`;
CREATE TABLE `campaign_summary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` int(10) unsigned DEFAULT NULL,
  `event_id` int(10) unsigned NOT NULL,
  `date_triggered` datetime DEFAULT NULL COMMENT '(DC2Type:datetime_immutable)',
  `scheduled_count` int(11) NOT NULL,
  `triggered_count` int(11) NOT NULL,
  `non_action_path_taken_count` int(11) NOT NULL,
  `failed_count` int(11) NOT NULL,
  `log_counts_processed` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_event_date_triggered` (`campaign_id`,`event_id`,`date_triggered`),
  KEY `IDX_6692FA4FF639F774` (`campaign_id`),
  KEY `IDX_6692FA4F71F7E88B` (`event_id`),
  CONSTRAINT `FK_6692FA4F71F7E88B` FOREIGN KEY (`event_id`) REFERENCES `campaign_events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_6692FA4FF639F774` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of campaign_summary
-- ----------------------------

-- ----------------------------
-- Table structure for `categories`
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
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
  `title` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `alias` varchar(191) NOT NULL,
  `color` varchar(7) DEFAULT NULL,
  `bundle` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_alias_search` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of categories
-- ----------------------------

-- ----------------------------
-- Table structure for `channel_url_trackables`
-- ----------------------------
DROP TABLE IF EXISTS `channel_url_trackables`;
CREATE TABLE `channel_url_trackables` (
  `channel_id` int(11) NOT NULL,
  `redirect_id` bigint(20) unsigned NOT NULL,
  `channel` varchar(191) NOT NULL,
  `hits` int(11) NOT NULL,
  `unique_hits` int(11) NOT NULL,
  PRIMARY KEY (`redirect_id`,`channel_id`),
  KEY `channel_url_trackable_search` (`channel`,`channel_id`),
  CONSTRAINT `FK_2F81A41DB42D874D` FOREIGN KEY (`redirect_id`) REFERENCES `page_redirects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of channel_url_trackables
-- ----------------------------

-- ----------------------------
-- Table structure for `companies`
-- ----------------------------
DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
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
  `companyemail` varchar(191) DEFAULT NULL,
  `companyaddress1` varchar(191) DEFAULT NULL,
  `companyaddress2` varchar(191) DEFAULT NULL,
  `companyphone` varchar(191) DEFAULT NULL,
  `companycity` varchar(191) DEFAULT NULL,
  `companystate` varchar(191) DEFAULT NULL,
  `companyzipcode` varchar(191) DEFAULT NULL,
  `companycountry` varchar(191) DEFAULT NULL,
  `companyname` varchar(191) DEFAULT NULL,
  `companywebsite` varchar(191) DEFAULT NULL,
  `companyindustry` varchar(191) DEFAULT NULL,
  `companydescription` longtext DEFAULT NULL,
  `companynumber_of_employees` double DEFAULT NULL,
  `companyfax` varchar(191) DEFAULT NULL,
  `companyannual_revenue` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_8244AA3A7E3C61F9` (`owner_id`),
  KEY `companynumber_of_employees_search` (`companynumber_of_employees`),
  KEY `companyfax_search` (`companyfax`),
  KEY `companyannual_revenue_search` (`companyannual_revenue`),
  KEY `company_filter` (`companyname`,`companyemail`),
  KEY `company_match` (`companyname`,`companycity`,`companycountry`,`companystate`),
  CONSTRAINT `FK_8244AA3A7E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of companies
-- ----------------------------

-- ----------------------------
-- Table structure for `companies_leads`
-- ----------------------------
DROP TABLE IF EXISTS `companies_leads`;
CREATE TABLE `companies_leads` (
  `company_id` int(11) NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `is_primary` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`company_id`,`lead_id`),
  KEY `IDX_F4190AB655458D` (`lead_id`),
  CONSTRAINT `FK_F4190AB655458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_F4190AB6979B1AD6` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of companies_leads
-- ----------------------------

-- ----------------------------
-- Table structure for `contact_merge_records`
-- ----------------------------
DROP TABLE IF EXISTS `contact_merge_records`;
CREATE TABLE `contact_merge_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `merged_id` int(11) NOT NULL,
  `name` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_D9B4F2BFE7A1254A` (`contact_id`),
  KEY `contact_merge_date_added` (`date_added`),
  KEY `contact_merge_ids` (`merged_id`),
  CONSTRAINT `FK_D9B4F2BFE7A1254A` FOREIGN KEY (`contact_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of contact_merge_records
-- ----------------------------

-- ----------------------------
-- Table structure for `dynamic_content`
-- ----------------------------
DROP TABLE IF EXISTS `dynamic_content`;
CREATE TABLE `dynamic_content` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
  `translation_parent_id` int(10) unsigned DEFAULT NULL,
  `variant_parent_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `sent_count` int(11) NOT NULL,
  `content` longtext DEFAULT NULL,
  `utm_tags` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `lang` varchar(191) NOT NULL,
  `variant_settings` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `variant_start_date` datetime DEFAULT NULL,
  `filters` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `is_campaign_based` tinyint(1) NOT NULL DEFAULT 1,
  `slot_name` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_20B9DEB212469DE2` (`category_id`),
  KEY `IDX_20B9DEB29091A2FB` (`translation_parent_id`),
  KEY `IDX_20B9DEB291861123` (`variant_parent_id`),
  KEY `is_campaign_based_index` (`is_campaign_based`),
  KEY `slot_name_index` (`slot_name`),
  CONSTRAINT `FK_20B9DEB212469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_20B9DEB29091A2FB` FOREIGN KEY (`translation_parent_id`) REFERENCES `dynamic_content` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_20B9DEB291861123` FOREIGN KEY (`variant_parent_id`) REFERENCES `dynamic_content` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of dynamic_content
-- ----------------------------

-- ----------------------------
-- Table structure for `dynamic_content_lead_data`
-- ----------------------------
DROP TABLE IF EXISTS `dynamic_content_lead_data`;
CREATE TABLE `dynamic_content_lead_data` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `dynamic_content_id` int(10) unsigned DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `slot` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_515B221B55458D` (`lead_id`),
  KEY `IDX_515B221BD9D0CD7` (`dynamic_content_id`),
  CONSTRAINT `FK_515B221B55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_515B221BD9D0CD7` FOREIGN KEY (`dynamic_content_id`) REFERENCES `dynamic_content` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of dynamic_content_lead_data
-- ----------------------------

-- ----------------------------
-- Table structure for `dynamic_content_stats`
-- ----------------------------
DROP TABLE IF EXISTS `dynamic_content_stats`;
CREATE TABLE `dynamic_content_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dynamic_content_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `date_sent` datetime NOT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `tokens` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `sent_count` int(11) DEFAULT NULL,
  `last_sent` datetime DEFAULT NULL,
  `sent_details` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_E48FBF80D9D0CD7` (`dynamic_content_id`),
  KEY `IDX_E48FBF8055458D` (`lead_id`),
  KEY `stat_dynamic_content_search` (`dynamic_content_id`,`lead_id`),
  KEY `stat_dynamic_content_source_search` (`source`,`source_id`),
  CONSTRAINT `FK_E48FBF8055458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_E48FBF80D9D0CD7` FOREIGN KEY (`dynamic_content_id`) REFERENCES `dynamic_content` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of dynamic_content_stats
-- ----------------------------

-- ----------------------------
-- Table structure for `emails`
-- ----------------------------
DROP TABLE IF EXISTS `emails`;
CREATE TABLE `emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
  `translation_parent_id` int(10) unsigned DEFAULT NULL,
  `variant_parent_id` int(10) unsigned DEFAULT NULL,
  `unsubscribeform_id` int(10) unsigned DEFAULT NULL,
  `preference_center_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `subject` longtext DEFAULT NULL,
  `from_address` varchar(191) DEFAULT NULL,
  `from_name` varchar(191) DEFAULT NULL,
  `reply_to_address` varchar(191) DEFAULT NULL,
  `bcc_address` varchar(191) DEFAULT NULL,
  `use_owner_as_mailer` tinyint(1) DEFAULT NULL,
  `template` varchar(191) DEFAULT NULL,
  `content` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `utm_tags` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `plain_text` longtext DEFAULT NULL,
  `custom_html` longtext DEFAULT NULL,
  `email_type` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `read_count` int(11) NOT NULL,
  `sent_count` int(11) NOT NULL,
  `variant_sent_count` int(11) NOT NULL,
  `variant_read_count` int(11) NOT NULL,
  `revision` int(11) NOT NULL,
  `lang` varchar(191) NOT NULL,
  `variant_settings` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `variant_start_date` datetime DEFAULT NULL,
  `dynamic_content` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `headers` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  `public_preview` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_4C81E85212469DE2` (`category_id`),
  KEY `IDX_4C81E8529091A2FB` (`translation_parent_id`),
  KEY `IDX_4C81E85291861123` (`variant_parent_id`),
  KEY `IDX_4C81E8522DC494F6` (`unsubscribeform_id`),
  KEY `IDX_4C81E852834F9C5B` (`preference_center_id`),
  CONSTRAINT `FK_4C81E85212469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_4C81E8522DC494F6` FOREIGN KEY (`unsubscribeform_id`) REFERENCES `forms` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_4C81E852834F9C5B` FOREIGN KEY (`preference_center_id`) REFERENCES `pages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_4C81E8529091A2FB` FOREIGN KEY (`translation_parent_id`) REFERENCES `emails` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_4C81E85291861123` FOREIGN KEY (`variant_parent_id`) REFERENCES `emails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of emails
-- ----------------------------

-- ----------------------------
-- Table structure for `email_assets_xref`
-- ----------------------------
DROP TABLE IF EXISTS `email_assets_xref`;
CREATE TABLE `email_assets_xref` (
  `email_id` int(10) unsigned NOT NULL,
  `asset_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`email_id`,`asset_id`),
  KEY `IDX_CA3157785DA1941` (`asset_id`),
  CONSTRAINT `FK_CA3157785DA1941` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_CA315778A832C1C9` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of email_assets_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `email_copies`
-- ----------------------------
DROP TABLE IF EXISTS `email_copies`;
CREATE TABLE `email_copies` (
  `id` varchar(32) NOT NULL,
  `date_created` datetime NOT NULL,
  `body` longtext DEFAULT NULL,
  `subject` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of email_copies
-- ----------------------------

-- ----------------------------
-- Table structure for `email_list_xref`
-- ----------------------------
DROP TABLE IF EXISTS `email_list_xref`;
CREATE TABLE `email_list_xref` (
  `email_id` int(10) unsigned NOT NULL,
  `leadlist_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`email_id`,`leadlist_id`),
  KEY `IDX_2E24F01CB9FC8874` (`leadlist_id`),
  CONSTRAINT `FK_2E24F01CA832C1C9` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_2E24F01CB9FC8874` FOREIGN KEY (`leadlist_id`) REFERENCES `lead_lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of email_list_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `email_stats`
-- ----------------------------
DROP TABLE IF EXISTS `email_stats`;
CREATE TABLE `email_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `list_id` int(10) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `copy_id` varchar(32) DEFAULT NULL,
  `email_address` varchar(191) NOT NULL,
  `date_sent` datetime NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `is_failed` tinyint(1) NOT NULL,
  `viewed_in_browser` tinyint(1) NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `tracking_hash` varchar(191) DEFAULT NULL,
  `retry_count` int(11) DEFAULT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `tokens` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `open_count` int(11) DEFAULT NULL,
  `last_opened` datetime DEFAULT NULL,
  `open_details` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `generated_sent_date` date GENERATED ALWAYS AS (concat(year(`date_sent`),'-',lpad(month(`date_sent`),2,'0'),'-',lpad(dayofmonth(`date_sent`),2,'0'))) VIRTUAL COMMENT '(DC2Type:generated)',
  PRIMARY KEY (`id`),
  KEY `IDX_CA0A2625A832C1C9` (`email_id`),
  KEY `IDX_CA0A262555458D` (`lead_id`),
  KEY `IDX_CA0A26253DAE168B` (`list_id`),
  KEY `IDX_CA0A2625A03F5E9F` (`ip_id`),
  KEY `IDX_CA0A2625A8752772` (`copy_id`),
  KEY `stat_email_search` (`email_id`,`lead_id`),
  KEY `stat_email_search2` (`lead_id`,`email_id`),
  KEY `stat_email_failed_search` (`is_failed`),
  KEY `is_read_date_sent` (`is_read`,`date_sent`),
  KEY `stat_email_hash_search` (`tracking_hash`),
  KEY `stat_email_source_search` (`source`,`source_id`),
  KEY `email_date_sent` (`date_sent`),
  KEY `email_date_read_lead` (`date_read`,`lead_id`),
  KEY `generated_sent_date_email_id` (`generated_sent_date`,`email_id`),
  CONSTRAINT `FK_CA0A26253DAE168B` FOREIGN KEY (`list_id`) REFERENCES `lead_lists` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_CA0A262555458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_CA0A2625A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_CA0A2625A832C1C9` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_CA0A2625A8752772` FOREIGN KEY (`copy_id`) REFERENCES `email_copies` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of email_stats
-- ----------------------------

-- ----------------------------
-- Table structure for `email_stats_devices`
-- ----------------------------
DROP TABLE IF EXISTS `email_stats_devices`;
CREATE TABLE `email_stats_devices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` bigint(20) unsigned DEFAULT NULL,
  `stat_id` bigint(20) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `date_opened` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_7A8A1C6F94A4C7D4` (`device_id`),
  KEY `IDX_7A8A1C6F9502F0B` (`stat_id`),
  KEY `IDX_7A8A1C6FA03F5E9F` (`ip_id`),
  KEY `date_opened_search` (`date_opened`),
  CONSTRAINT `FK_7A8A1C6F94A4C7D4` FOREIGN KEY (`device_id`) REFERENCES `lead_devices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_7A8A1C6F9502F0B` FOREIGN KEY (`stat_id`) REFERENCES `email_stats` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_7A8A1C6FA03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of email_stats_devices
-- ----------------------------

-- ----------------------------
-- Table structure for `email_stat_replies`
-- ----------------------------
DROP TABLE IF EXISTS `email_stat_replies`;
CREATE TABLE `email_stat_replies` (
  `id` char(36) NOT NULL COMMENT '(DC2Type:guid)',
  `stat_id` bigint(20) unsigned NOT NULL,
  `date_replied` datetime NOT NULL,
  `message_id` varchar(191) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_11E9F6E09502F0B` (`stat_id`),
  KEY `email_replies` (`stat_id`,`message_id`),
  KEY `date_email_replied` (`date_replied`),
  CONSTRAINT `FK_11E9F6E09502F0B` FOREIGN KEY (`stat_id`) REFERENCES `email_stats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of email_stat_replies
-- ----------------------------

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

-- ----------------------------
-- Table structure for `events_leads`
-- ----------------------------
DROP TABLE IF EXISTS `events_leads`;
CREATE TABLE `events_leads` (
  `event_id` int(11) NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `is_primary` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`event_id`,`lead_id`),
  KEY `IDX_A72C8D7455458D` (`lead_id`),
  CONSTRAINT `FK_A72C8D7455458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_A72C8D7471F7E88B` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of events_leads
-- ----------------------------

-- ----------------------------
-- Table structure for `focus`
-- ----------------------------
DROP TABLE IF EXISTS `focus`;
CREATE TABLE `focus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `focus_type` varchar(191) NOT NULL,
  `style` varchar(191) NOT NULL,
  `website` varchar(191) DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `properties` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `utm_tags` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `form_id` int(11) DEFAULT NULL,
  `cache` longtext DEFAULT NULL,
  `html_mode` varchar(191) DEFAULT NULL,
  `editor` longtext DEFAULT NULL,
  `html` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_62C04AE912469DE2` (`category_id`),
  KEY `focus_type` (`focus_type`),
  KEY `focus_style` (`style`),
  KEY `focus_form` (`form_id`),
  CONSTRAINT `FK_62C04AE912469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of focus
-- ----------------------------

-- ----------------------------
-- Table structure for `focus_stats`
-- ----------------------------
DROP TABLE IF EXISTS `focus_stats`;
CREATE TABLE `focus_stats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `focus_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `type` varchar(191) NOT NULL,
  `type_id` int(11) DEFAULT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_C36970DC51804B42` (`focus_id`),
  KEY `IDX_C36970DC55458D` (`lead_id`),
  KEY `focus_type` (`type`),
  KEY `focus_type_id` (`type`,`type_id`),
  KEY `focus_date_added` (`date_added`),
  CONSTRAINT `FK_C36970DC51804B42` FOREIGN KEY (`focus_id`) REFERENCES `focus` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_C36970DC55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of focus_stats
-- ----------------------------

-- ----------------------------
-- Table structure for `forms`
-- ----------------------------
DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `alias` varchar(191) NOT NULL,
  `form_attr` varchar(191) DEFAULT NULL,
  `cached_html` longtext DEFAULT NULL,
  `post_action` varchar(191) NOT NULL,
  `post_action_property` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `template` varchar(191) DEFAULT NULL,
  `in_kiosk_mode` tinyint(1) DEFAULT NULL,
  `render_style` tinyint(1) DEFAULT NULL,
  `form_type` varchar(191) DEFAULT NULL,
  `no_index` tinyint(1) DEFAULT NULL,
  `progressive_profiling_limit` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_FD3F1BF712469DE2` (`category_id`),
  CONSTRAINT `FK_FD3F1BF712469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of forms
-- ----------------------------

-- ----------------------------
-- Table structure for `form_actions`
-- ----------------------------
DROP TABLE IF EXISTS `form_actions`;
CREATE TABLE `form_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `action_order` int(11) NOT NULL,
  `properties` longtext NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_342491D45FF69B7D` (`form_id`),
  KEY `form_action_type_search` (`type`),
  CONSTRAINT `FK_342491D45FF69B7D` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of form_actions
-- ----------------------------

-- ----------------------------
-- Table structure for `form_fields`
-- ----------------------------
DROP TABLE IF EXISTS `form_fields`;
CREATE TABLE `form_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `label` longtext NOT NULL,
  `show_label` tinyint(1) DEFAULT NULL,
  `alias` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `is_custom` tinyint(1) NOT NULL,
  `custom_parameters` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `default_value` longtext DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL,
  `validation_message` longtext DEFAULT NULL,
  `help_message` longtext DEFAULT NULL,
  `field_order` int(11) DEFAULT NULL,
  `properties` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `validation` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `parent_id` varchar(191) DEFAULT NULL,
  `conditions` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `label_attr` varchar(191) DEFAULT NULL,
  `input_attr` varchar(191) DEFAULT NULL,
  `container_attr` varchar(191) DEFAULT NULL,
  `lead_field` varchar(191) DEFAULT NULL,
  `save_result` tinyint(1) DEFAULT NULL,
  `is_auto_fill` tinyint(1) DEFAULT NULL,
  `show_when_value_exists` tinyint(1) DEFAULT NULL,
  `show_after_x_submissions` int(11) DEFAULT NULL,
  `always_display` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_7C0B37265FF69B7D` (`form_id`),
  KEY `form_field_type_search` (`type`),
  CONSTRAINT `FK_7C0B37265FF69B7D` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of form_fields
-- ----------------------------

-- ----------------------------
-- Table structure for `form_submissions`
-- ----------------------------
DROP TABLE IF EXISTS `form_submissions`;
CREATE TABLE `form_submissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `ip_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `page_id` int(10) unsigned DEFAULT NULL,
  `tracking_id` varchar(191) DEFAULT NULL,
  `date_submitted` datetime NOT NULL,
  `referer` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_C80AF9E65FF69B7D` (`form_id`),
  KEY `IDX_C80AF9E6A03F5E9F` (`ip_id`),
  KEY `IDX_C80AF9E655458D` (`lead_id`),
  KEY `IDX_C80AF9E6C4663E4` (`page_id`),
  KEY `form_submission_tracking_search` (`tracking_id`),
  KEY `form_date_submitted` (`date_submitted`),
  CONSTRAINT `FK_C80AF9E655458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_C80AF9E65FF69B7D` FOREIGN KEY (`form_id`) REFERENCES `forms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_C80AF9E6A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_C80AF9E6C4663E4` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of form_submissions
-- ----------------------------

-- ----------------------------
-- Table structure for `imports`
-- ----------------------------
DROP TABLE IF EXISTS `imports`;
CREATE TABLE `imports` (
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
  `dir` varchar(191) NOT NULL,
  `file` varchar(191) NOT NULL,
  `original_file` varchar(191) DEFAULT NULL,
  `line_count` int(11) NOT NULL,
  `inserted_count` int(11) NOT NULL,
  `updated_count` int(11) NOT NULL,
  `ignored_count` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `date_started` datetime DEFAULT NULL,
  `date_ended` datetime DEFAULT NULL,
  `object` varchar(191) NOT NULL,
  `properties` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  PRIMARY KEY (`id`),
  KEY `import_object` (`object`),
  KEY `import_status` (`status`),
  KEY `import_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of imports
-- ----------------------------
INSERT INTO imports VALUES ('1', '1', '2024-06-30 15:18:07', '1', 'Hai Ha', '2024-06-30 15:18:11', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630151748.csv', 'contac t.csv', '21', '0', '0', '21', '512', '3', '2024-06-30 15:18:10', '2024-06-30 15:18:11', 'lead', '{\"fields\":{\"city\":\"city\",\"contactmeeyid\":\"contactmeeyid\",\"email\":\"email\",\"firstname\":\"firstname\",\"lastname\":\"lastname\",\"mobile\":\"mobile\",\"phone\":\"phone\",\"state\":\"state\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"contactmeeyid\",\"firstname\",\"lastname\",\"email\",\"phone\",\"mobile\",\"city\",\"state\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":22}');
INSERT INTO imports VALUES ('2', '1', '2024-06-30 15:28:21', '1', 'Hai Ha', '2024-06-30 15:28:24', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630152608.csv', 'contac t.csv', '21', '20', '0', '1', '512', '3', '2024-06-30 15:28:22', '2024-06-30 15:28:24', 'lead', '{\"fields\":{\"city\":\"city\",\"contactmeeyid\":\"contactmeeyid\",\"email\":\"email\",\"firstname\":\"firstname\",\"lastname\":\"lastname\",\"mobile\":\"mobile\",\"phone\":\"phone\",\"state\":\"state\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"contactmeeyid\",\"firstname\",\"lastname\",\"email\",\"phone\",\"mobile\",\"city\",\"state\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":22}');
INSERT INTO imports VALUES ('3', '1', '2024-06-30 15:36:54', '1', 'Hai Ha', '2024-06-30 15:36:56', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630153046.csv', 'event_data.csv', '21', '18', '2', '1', '512', '3', '2024-06-30 15:36:55', '2024-06-30 15:36:56', 'event', '{\"fields\":{\"eventmeeyid\":\"eventmeeyid\",\"geo_city\":\"geo_city\",\"geo_continent\":\"geo_continent\",\"geo_country\":\"geo_country\",\"geo_region\":\"geo_region\",\"param_ga_session_id\":\"param_ga_session_id\",\"param_page_location\":\"param_page_location\",\"param_page_title\":\"param_page_title\",\"platform\":\"eventplatform\",\"eventname\":\"eventname\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"\\ufeffeventname\",\"eventmeeyid\",\"is_active_user\",\"platform\",\"geo_city\",\"geo_country\",\"geo_continent\",\"geo_region\",\"param_page_location\",\"param_page_title\",\"param_ga_session_id\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":22}');
INSERT INTO imports VALUES ('4', '1', '2024-06-30 16:56:31', '1', 'Hai Ha', '2024-06-30 16:56:33', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630165619.csv', 'fact_order_official.csv', '20', '0', '0', '20', '512', '3', '2024-06-30 16:56:32', '2024-06-30 16:56:33', 'transaction', '{\"fields\":{\"trancode\":\"trancode\",\"trancreateddate\":\"trancreateddate\",\"tranid\":\"tranid\",\"tranmeeyid\":\"tranmeeyid\",\"tranplatform\":\"tranplatform\",\"tranprice\":\"tranprice\",\"tranproductid\":\"tranproductid\",\"transaleemail\":\"transaleemail\",\"transtatus\":\"transtatus\",\"tranupdateddate\":\"tranupdateddate\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"tranid\",\"trancode\",\"tranmeeyid\",\"tranprice\",\"transtatus\",\"tranproductid\",\"tranplatform\",\"transaleemail\",\"trancreateddate\",\"tranupdateddate\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":21}');
INSERT INTO imports VALUES ('5', '1', '2024-06-30 16:58:01', '1', 'Hai Ha', '2024-06-30 16:58:03', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630165749.csv', 'fact_order_official.csv', '20', '0', '0', '20', '512', '3', '2024-06-30 16:58:02', '2024-06-30 16:58:03', 'transaction', '{\"fields\":{\"trancode\":\"trancode\",\"trancreateddate\":\"trancreateddate\",\"tranid\":\"tranid\",\"tranmeeyid\":\"tranmeeyid\",\"tranplatform\":\"tranplatform\",\"tranprice\":\"tranprice\",\"tranproductid\":\"tranproductid\",\"transaleemail\":\"transaleemail\",\"transtatus\":\"transtatus\",\"tranupdateddate\":\"tranupdateddate\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"tranid\",\"trancode\",\"tranmeeyid\",\"tranprice\",\"transtatus\",\"tranproductid\",\"tranplatform\",\"transaleemail\",\"trancreateddate\",\"tranupdateddate\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":21}');
INSERT INTO imports VALUES ('6', '1', '2024-06-30 17:03:38', '1', 'Hai Ha', '2024-06-30 17:03:40', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630170213.csv', 'fact_order_official.csv', '20', '0', '0', '20', '512', '3', '2024-06-30 17:03:40', '2024-06-30 17:03:40', 'transaction', '{\"fields\":{\"trancode\":\"trancode\",\"trancreateddate\":\"trancreateddate\",\"tranid\":\"tranid\",\"tranmeeyid\":\"tranmeeyid\",\"tranplatform\":\"tranplatform\",\"tranprice\":\"tranprice\",\"tranproductid\":\"tranproductid\",\"transaleemail\":\"transaleemail\",\"transtatus\":\"transtatus\",\"tranupdateddate\":\"tranupdateddate\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"tranid\",\"trancode\",\"tranmeeyid\",\"tranprice\",\"transtatus\",\"tranproductid\",\"tranplatform\",\"transaleemail\",\"trancreateddate\",\"tranupdateddate\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":21}');
INSERT INTO imports VALUES ('7', '1', '2024-06-30 17:06:32', '1', 'Hai Ha', '2024-06-30 17:06:33', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630170540.csv', 'fact_order_official.csv', '20', '0', '0', '20', '512', '3', '2024-06-30 17:06:33', '2024-06-30 17:06:33', 'transaction', '{\"fields\":{\"trancode\":\"trancode\",\"trancreateddate\":\"trancreateddate\",\"tranid\":\"tranid\",\"tranmeeyid\":\"tranmeeyid\",\"tranplatform\":\"tranplatform\",\"tranprice\":\"tranprice\",\"tranproductid\":\"tranproductid\",\"transaleemail\":\"transaleemail\",\"transtatus\":\"transtatus\",\"tranupdateddate\":\"tranupdateddate\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"tranid\",\"trancode\",\"tranmeeyid\",\"tranprice\",\"transtatus\",\"tranproductid\",\"tranplatform\",\"transaleemail\",\"trancreateddate\",\"tranupdateddate\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":21}');
INSERT INTO imports VALUES ('8', '1', '2024-06-30 17:07:42', '1', 'Hai Ha', '2024-06-30 17:07:43', '1', 'Hai Ha', null, null, null, 'D:\\project\\mautics\\mautic-4.4\\app/../var/tmp/imports', '20240630170733.csv', 'fact_order_official.csv', '20', '0', '0', '20', '512', '3', '2024-06-30 17:07:43', '2024-06-30 17:07:43', 'transaction', '{\"fields\":{\"trancode\":\"trancode\",\"trancreateddate\":\"trancreateddate\",\"tranid\":\"tranid\",\"tranmeeyid\":\"tranmeeyid\",\"tranplatform\":\"tranplatform\",\"tranprice\":\"tranprice\",\"tranproductid\":\"tranproductid\",\"transaleemail\":\"transaleemail\",\"transtatus\":\"transtatus\",\"tranupdateddate\":\"tranupdateddate\"},\"defaults\":{\"owner\":null,\"list\":null,\"tags\":[],\"skip_if_exists\":false},\"headers\":[\"tranid\",\"trancode\",\"tranmeeyid\",\"tranprice\",\"transtatus\",\"tranproductid\",\"tranplatform\",\"transaleemail\",\"trancreateddate\",\"tranupdateddate\"],\"parser\":{\"delimiter\":\",\",\"enclosure\":\"\\\"\",\"escape\":\"\\\\\",\"batchlimit\":100},\"line\":21}');

-- ----------------------------
-- Table structure for `integration_entity`
-- ----------------------------
DROP TABLE IF EXISTS `integration_entity`;
CREATE TABLE `integration_entity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_added` datetime NOT NULL,
  `integration` varchar(191) DEFAULT NULL,
  `integration_entity` varchar(191) DEFAULT NULL,
  `integration_entity_id` varchar(191) DEFAULT NULL,
  `internal_entity` varchar(191) DEFAULT NULL,
  `internal_entity_id` int(11) DEFAULT NULL,
  `last_sync_date` datetime DEFAULT NULL,
  `internal` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `integration_external_entity` (`integration`,`integration_entity`,`integration_entity_id`),
  KEY `integration_internal_entity` (`integration`,`internal_entity`,`internal_entity_id`),
  KEY `integration_entity_match` (`integration`,`internal_entity`,`integration_entity`),
  KEY `integration_last_sync_date` (`integration`,`last_sync_date`),
  KEY `internal_integration_entity` (`internal_entity_id`,`integration_entity_id`,`internal_entity`,`integration_entity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of integration_entity
-- ----------------------------

-- ----------------------------
-- Table structure for `ip_addresses`
-- ----------------------------
DROP TABLE IF EXISTS `ip_addresses`;
CREATE TABLE `ip_addresses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(45) NOT NULL,
  `ip_details` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `ip_search` (`ip_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of ip_addresses
-- ----------------------------

-- ----------------------------
-- Table structure for `leads`
-- ----------------------------
DROP TABLE IF EXISTS `leads`;
CREATE TABLE `leads` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int(10) unsigned DEFAULT NULL,
  `stage_id` int(10) unsigned DEFAULT NULL,
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
  `points` int(11) NOT NULL,
  `last_active` datetime DEFAULT NULL,
  `internal` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `social_cache` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `date_identified` datetime DEFAULT NULL,
  `preferred_profile_image` varchar(191) DEFAULT NULL,
  `title` varchar(191) DEFAULT NULL,
  `firstname` varchar(191) DEFAULT NULL,
  `lastname` varchar(191) DEFAULT NULL,
  `company` varchar(191) DEFAULT NULL,
  `position` varchar(191) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `phone` varchar(191) DEFAULT NULL,
  `mobile` varchar(191) DEFAULT NULL,
  `address1` varchar(191) DEFAULT NULL,
  `address2` varchar(191) DEFAULT NULL,
  `city` varchar(191) DEFAULT NULL,
  `state` varchar(191) DEFAULT NULL,
  `zipcode` varchar(191) DEFAULT NULL,
  `timezone` varchar(191) DEFAULT NULL,
  `country` varchar(191) DEFAULT NULL,
  `event` varchar(191) DEFAULT NULL,
  `fax` varchar(191) DEFAULT NULL,
  `preferred_locale` varchar(191) DEFAULT NULL,
  `attribution_date` datetime DEFAULT NULL,
  `attribution` double DEFAULT NULL,
  `website` varchar(191) DEFAULT NULL,
  `facebook` varchar(191) DEFAULT NULL,
  `foursquare` varchar(191) DEFAULT NULL,
  `instagram` varchar(191) DEFAULT NULL,
  `linkedin` varchar(191) DEFAULT NULL,
  `skype` varchar(191) DEFAULT NULL,
  `twitter` varchar(191) DEFAULT NULL,
  `generated_email_domain` varchar(255) GENERATED ALWAYS AS (substr(`email`,locate('@',`email`) + 1)) VIRTUAL COMMENT '(DC2Type:generated)',
  `contactmeeyid` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_179045527E3C61F9` (`owner_id`),
  KEY `IDX_179045522298D193` (`stage_id`),
  KEY `lead_date_added` (`date_added`),
  KEY `date_identified` (`date_identified`),
  KEY `event_search` (`event`),
  KEY `fax_search` (`fax`),
  KEY `preferred_locale_search` (`preferred_locale`),
  KEY `attribution_date_search` (`attribution_date`),
  KEY `attribution_search` (`attribution`),
  KEY `website_search` (`website`),
  KEY `facebook_search` (`facebook`),
  KEY `foursquare_search` (`foursquare`),
  KEY `instagram_search` (`instagram`),
  KEY `linkedin_search` (`linkedin`),
  KEY `skype_search` (`skype`),
  KEY `twitter_search` (`twitter`),
  KEY `contact_attribution` (`attribution`,`attribution_date`),
  KEY `date_added_country_index` (`date_added`,`country`),
  KEY `generated_email_domain` (`generated_email_domain`),
  KEY `contactmeeyid_search` (`contactmeeyid`),
  CONSTRAINT `FK_179045522298D193` FOREIGN KEY (`stage_id`) REFERENCES `stages` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_179045527E3C61F9` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of leads
-- ----------------------------
INSERT INTO leads VALUES ('21', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Penny', 'Moore', null, null, 'PennyKMoore@dayrep.com', '070 7086 0753', null, null, null, 'HEWELSFIELD COMMON', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'dayrep.com', '64280ee582f486001dc95a1b');
INSERT INTO leads VALUES ('22', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Henry', 'Catalano', null, null, 'HenryLCatalano@einrot.com', '082 118 9037', null, null, null, 'Rustenburg', 'North West', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'einrot.com', '664338d8b33bffda58e9f502');
INSERT INTO leads VALUES ('23', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Stephanie', 'Cone', null, null, 'StephanieMCone@teleworm.us', '078 4515 7520', null, null, null, 'PANT', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'teleworm.us', '625a2d155216600019362c1e');
INSERT INTO leads VALUES ('24', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Andrew', 'Flanagan', null, null, 'AndrewVFlanagan@dayrep.com', '077 6574 7295', null, null, null, 'WEATHERCOTE', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'dayrep.com', '664040de004ed6869bc07c5b');
INSERT INTO leads VALUES ('25', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Daniel', 'Wright', null, null, 'DanielAWright@dayrep.com', '082 673 3168', null, null, null, 'Qumbu', 'Eastern Cape', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'dayrep.com', '6632f93d2b4698893b0a2656');
INSERT INTO leads VALUES ('26', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Jose', 'Patton', null, null, 'JoseMPatton@jourrapide.com', '250-453-4211', null, null, null, 'Ashcroft', 'BC', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'jourrapide.com', '6642d26409302011f3dfc73b');
INSERT INTO leads VALUES ('27', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Jean', 'Cross', null, null, 'JeanGCross@armyspy.com', '077 8114 7167', null, null, null, 'WEST CHINNOCK', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'armyspy.com', '66439079434a7d8497d64f12');
INSERT INTO leads VALUES ('28', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Kevin', 'Kennedy', null, null, 'KevinBKennedy@gustr.com', '(03) 5330 2874', null, null, null, 'COLBROOK', 'VIC', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'gustr.com', '6144830b2792fd26d7b89331');
INSERT INTO leads VALUES ('29', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Leonard', 'Sinclair', null, null, 'LeonardMSinclair@teleworm.us', '084 524 8203', null, null, null, 'Cape Town', 'Western Cape', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'teleworm.us', '625a2d155216600019362c1e');
INSERT INTO leads VALUES ('30', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Bruce', 'Campbell', null, null, 'BruceMCampbell@einrot.com', '(07) 3187 6375', null, null, null, 'MOOLBOOLAMAN', 'QLD', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'einrot.com', '61473c75a59b960018fed63b');
INSERT INTO leads VALUES ('31', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Guadalupe', 'Strauss', null, null, 'GuadalupeHStrauss@teleworm.us', '(08) 9029 4631', null, null, null, 'TOOLIBIN', 'WA', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'teleworm.us', '6641c0cc09302011f3de442e');
INSERT INTO leads VALUES ('32', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Pamela', 'Wise', null, null, 'PamelaSWise@gustr.com', '(03) 5389 0975', null, null, null, 'WARROCK', 'VIC', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'gustr.com', '662e683abcaff9d0288fb6d8');
INSERT INTO leads VALUES ('33', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Margaret', 'Maguire', null, null, 'MargaretDMaguire@cuvox.de', '450-439-2306', null, null, null, 'Laurentides', 'QC', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'cuvox.de', '66430bcd09302011f3e04cf5');
INSERT INTO leads VALUES ('34', null, null, '1', '2024-06-30 15:28:23', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:23', 'gravatar', null, 'Regina', 'Dolph', null, null, 'ReginaBDolph@teleworm.us', '077 0685 3094', null, null, null, 'SOLAS', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'teleworm.us', '6642f18abd0df3b8db7455f5');
INSERT INTO leads VALUES ('35', null, null, '1', '2024-06-30 15:28:24', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:24', 'gravatar', null, 'Paula', 'Hill', null, null, 'PaulaWHill@dayrep.com', '085 488 7773', null, null, null, 'Brits', 'North West', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'dayrep.com', '5e7671085071cd1c9e8f4a88');
INSERT INTO leads VALUES ('36', null, null, '1', '2024-06-30 15:28:24', '1', 'Hai Ha', null, null, null, null, null, null, '0', null, 'a:0:{}', 'a:0:{}', '2024-06-30 15:28:24', 'gravatar', null, 'Jimmy', 'Sanchez', null, null, 'JimmyCSanchez@dayrep.com', '(07) 4042 9552', null, null, null, 'COQUETTE POINT', 'QLD', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'dayrep.com', '64c37bee643774001dce6b0f');

-- ----------------------------
-- Table structure for `lead_categories`
-- ----------------------------
DROP TABLE IF EXISTS `lead_categories`;
CREATE TABLE `lead_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `manually_removed` tinyint(1) NOT NULL,
  `manually_added` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_12685DF412469DE2` (`category_id`),
  KEY `IDX_12685DF455458D` (`lead_id`),
  CONSTRAINT `FK_12685DF412469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_12685DF455458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_categories
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_companies_change_log`
-- ----------------------------
DROP TABLE IF EXISTS `lead_companies_change_log`;
CREATE TABLE `lead_companies_change_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `type` tinytext NOT NULL,
  `event_name` varchar(191) NOT NULL,
  `action_name` varchar(191) NOT NULL,
  `company_id` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_A034C81B55458D` (`lead_id`),
  KEY `company_date_added` (`date_added`),
  CONSTRAINT `FK_A034C81B55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_companies_change_log
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_devices`
-- ----------------------------
DROP TABLE IF EXISTS `lead_devices`;
CREATE TABLE `lead_devices` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `client_info` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `device` varchar(191) DEFAULT NULL,
  `device_os_name` varchar(191) DEFAULT NULL,
  `device_os_shortname` varchar(191) DEFAULT NULL,
  `device_os_version` varchar(191) DEFAULT NULL,
  `device_os_platform` varchar(191) DEFAULT NULL,
  `device_brand` varchar(191) DEFAULT NULL,
  `device_model` varchar(191) DEFAULT NULL,
  `tracking_id` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_48C912F47D05ABBE` (`tracking_id`),
  KEY `IDX_48C912F455458D` (`lead_id`),
  KEY `date_added_search` (`date_added`),
  KEY `device_search` (`device`),
  KEY `device_os_name_search` (`device_os_name`),
  KEY `device_os_shortname_search` (`device_os_shortname`),
  KEY `device_os_version_search` (`device_os_version`),
  KEY `device_os_platform_search` (`device_os_platform`),
  KEY `device_brand_search` (`device_brand`),
  KEY `device_model_search` (`device_model`),
  CONSTRAINT `FK_48C912F455458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_devices
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_donotcontact`
-- ----------------------------
DROP TABLE IF EXISTS `lead_donotcontact`;
CREATE TABLE `lead_donotcontact` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `date_added` datetime NOT NULL,
  `reason` smallint(6) NOT NULL,
  `channel` varchar(191) NOT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_71DC0B1D55458D` (`lead_id`),
  KEY `dnc_reason_search` (`reason`),
  CONSTRAINT `FK_71DC0B1D55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_donotcontact
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_events_change_log`
-- ----------------------------
DROP TABLE IF EXISTS `lead_events_change_log`;
CREATE TABLE `lead_events_change_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `type` tinytext NOT NULL,
  `event_name` varchar(191) NOT NULL,
  `action_name` varchar(191) NOT NULL,
  `event_id` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_9CAC09955458D` (`lead_id`),
  KEY `event_date_added` (`date_added`),
  CONSTRAINT `FK_9CAC09955458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_events_change_log
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_event_log`
-- ----------------------------
DROP TABLE IF EXISTS `lead_event_log`;
CREATE TABLE `lead_event_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(191) DEFAULT NULL,
  `bundle` varchar(191) DEFAULT NULL,
  `object` varchar(191) DEFAULT NULL,
  `action` varchar(191) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `date_added` datetime NOT NULL,
  `properties` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  PRIMARY KEY (`id`),
  KEY `lead_id_index` (`lead_id`),
  KEY `lead_object_index` (`object`,`object_id`),
  KEY `lead_timeline_index` (`bundle`,`object`,`action`,`object_id`),
  KEY `IDX_SEARCH` (`bundle`,`object`,`action`,`object_id`,`date_added`),
  KEY `lead_timeline_action_index` (`action`),
  KEY `lead_date_added_index` (`date_added`),
  CONSTRAINT `FK_753AF2E55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_event_log
-- ----------------------------
INSERT INTO lead_event_log VALUES ('2', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":3,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"64280ee582f486001dc95a1b\\\", \\\"1\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('4', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":4,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"664338d8b33bffda58e9f502\\\", \\\"2\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('6', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":5,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"625a2d155216600019362c1e\\\", \\\"3\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('8', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":6,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"664040de004ed6869bc07c5b\\\", \\\"4\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('10', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":7,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6632f93d2b4698893b0a2656\\\", \\\"5\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('12', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":8,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6642d26409302011f3dfc73b\\\", \\\"6\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('14', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":9,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"66439079434a7d8497d64f12\\\", \\\"7\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('16', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":10,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6144830b2792fd26d7b89331\\\", \\\"8\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('18', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":11,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"625a2d155216600019362c1e\\\", \\\"9\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('20', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":12,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"61473c75a59b960018fed63b\\\", \\\"10\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('22', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":13,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6641c0cc09302011f3de442e\\\", \\\"11\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('24', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":14,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"662e683abcaff9d0288fb6d8\\\", \\\"12\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('26', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":15,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"66430bcd09302011f3e04cf5\\\", \\\"13\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('28', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":16,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6642f18abd0df3b8db7455f5\\\", \\\"14\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('30', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":17,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"5e7671085071cd1c9e8f4a88\\\", \\\"15\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('32', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":18,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"64c37bee643774001dce6b0f\\\", \\\"16\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('34', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:10', '{\"line\":19,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6642fa70004ed6869bc48dee\\\", \\\"17\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('36', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:11', '{\"line\":20,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"6642f629004ed6869bc48654\\\", \\\"18\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('38', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:11', '{\"line\":21,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"643e68fb03e8bf001da908f9\\\", \\\"19\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('40', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:11', '{\"line\":22,\"file\":\"contac t.csv\",\"error\":\"An exception occurred while executing \'UPDATE leads SET contactmeeyid = ? WHERE id = ?\' with params [\\\"643e68fb03e8bf001da908f9\\\", \\\"20\\\"]:\\n\\nSQLSTATE[42S22]: Column not found: 1054 Unknown column \'contactmeeyid\' in \'field list\'\"}');
INSERT INTO lead_event_log VALUES ('41', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '1', '2024-06-30 15:18:11', '{\"line\":23,\"file\":\"contac t.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('42', '21', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('43', '21', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:22', '{\"line\":3,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('44', '22', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('45', '22', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":4,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('46', '23', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('47', '23', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":5,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('48', '24', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('49', '24', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":6,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('50', '25', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('51', '25', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":7,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('52', '26', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('53', '26', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":8,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('54', '27', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('55', '27', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":9,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('56', '28', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('57', '28', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":10,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('58', '29', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('59', '29', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":11,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('60', '30', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('61', '30', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":12,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('62', '31', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('63', '31', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":13,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('64', '32', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('65', '32', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":14,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('66', '33', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('67', '33', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":15,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('68', '34', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:23', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('69', '34', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":16,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('70', '35', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:24', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('71', '35', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:23', '{\"line\":17,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('72', '36', null, null, 'lead', 'import', 'identified_contact', '2', '2024-06-30 15:28:24', '{\"object_description\":\"Hai Ha\"}');
INSERT INTO lead_event_log VALUES ('73', '36', '1', 'Hai Ha', 'lead', 'import', 'inserted', '2', '2024-06-30 15:28:24', '{\"line\":18,\"file\":\"contac t.csv\"}');
INSERT INTO lead_event_log VALUES ('82', null, '1', 'Hai Ha', 'lead', 'import', 'failed', '2', '2024-06-30 15:28:24', '{\"line\":23,\"file\":\"contac t.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('83', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:55', '{\"line\":3,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('84', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":4,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('85', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":5,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('86', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":6,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('87', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":7,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('88', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":8,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('89', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":9,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('90', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":10,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('91', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":11,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('92', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":12,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('93', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":13,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('94', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":14,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('95', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":15,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('96', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":16,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('97', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":17,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('98', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":18,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('99', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":19,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('100', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":20,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('101', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":21,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('102', null, '1', 'Hai Ha', 'event', 'import', null, '3', '2024-06-30 15:36:56', '{\"line\":22,\"file\":\"event_data.csv\"}');
INSERT INTO lead_event_log VALUES ('103', null, '1', 'Hai Ha', 'event', 'import', 'failed', '3', '2024-06-30 15:36:56', '{\"line\":23,\"file\":\"event_data.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('104', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:32', '{\"line\":3,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('105', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":4,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('106', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":5,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('107', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":6,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('108', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":7,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('109', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":8,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('110', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":9,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('111', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":10,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('112', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":11,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('113', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":12,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('114', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":13,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('115', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":14,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('116', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":15,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('117', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":16,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('118', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":17,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('119', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":18,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('120', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":19,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('121', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":20,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('122', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":21,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('123', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '4', '2024-06-30 16:56:33', '{\"line\":22,\"file\":\"fact_order_official.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('124', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:02', '{\"line\":3,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('125', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":4,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('126', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":5,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('127', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":6,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('128', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":7,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('129', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":8,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('130', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":9,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('131', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":10,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('132', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":11,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('133', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":12,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('134', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":13,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('135', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":14,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('136', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":15,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('137', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":16,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('138', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":17,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('139', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":18,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('140', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":19,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('141', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":20,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('142', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":21,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('143', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '5', '2024-06-30 16:58:03', '{\"line\":22,\"file\":\"fact_order_official.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('144', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":3,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('145', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":4,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('146', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":5,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('147', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":6,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('148', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":7,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('149', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":8,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('150', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":9,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('151', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":10,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('152', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":11,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('153', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":12,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('154', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":13,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('155', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":14,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('156', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":15,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('157', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":16,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('158', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":17,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('159', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":18,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('160', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":19,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('161', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":20,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('162', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":21,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('163', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '6', '2024-06-30 17:03:40', '{\"line\":22,\"file\":\"fact_order_official.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('164', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":3,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('165', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":4,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('166', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":5,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('167', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":6,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('168', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":7,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('169', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":8,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('170', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":9,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('171', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":10,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('172', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":11,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('173', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":12,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('174', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":13,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('175', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":14,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('176', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":15,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('177', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":16,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('178', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":17,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('179', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":18,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('180', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":19,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('181', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":20,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('182', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":21,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('183', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '7', '2024-06-30 17:06:33', '{\"line\":22,\"file\":\"fact_order_official.csv\",\"error\":\"No data found\"}');
INSERT INTO lead_event_log VALUES ('184', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":3,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('185', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":4,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('186', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":5,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('187', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":6,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('188', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":7,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('189', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":8,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('190', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":9,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('191', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":10,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('192', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":11,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('193', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":12,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('194', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":13,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('195', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":14,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('196', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":15,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('197', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":16,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('198', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":17,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('199', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":18,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('200', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":19,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('201', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":20,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('202', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":21,\"file\":\"fact_order_official.csv\",\"error\":\"None of unique fields is in import\"}');
INSERT INTO lead_event_log VALUES ('203', null, '1', 'Hai Ha', 'transaction', 'import', 'failed', '8', '2024-06-30 17:07:43', '{\"line\":22,\"file\":\"fact_order_official.csv\",\"error\":\"No data found\"}');

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

-- ----------------------------
-- Table structure for `lead_frequencyrules`
-- ----------------------------
DROP TABLE IF EXISTS `lead_frequencyrules`;
CREATE TABLE `lead_frequencyrules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `frequency_number` smallint(6) DEFAULT NULL,
  `frequency_time` varchar(25) DEFAULT NULL,
  `channel` varchar(191) NOT NULL,
  `preferred_channel` tinyint(1) NOT NULL,
  `pause_from_date` datetime DEFAULT NULL,
  `pause_to_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_AA8A57F455458D` (`lead_id`),
  KEY `channel_frequency` (`channel`),
  CONSTRAINT `FK_AA8A57F455458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_frequencyrules
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_ips_xref`
-- ----------------------------
DROP TABLE IF EXISTS `lead_ips_xref`;
CREATE TABLE `lead_ips_xref` (
  `lead_id` bigint(20) unsigned NOT NULL,
  `ip_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`lead_id`,`ip_id`),
  KEY `IDX_9EED7E66A03F5E9F` (`ip_id`),
  CONSTRAINT `FK_9EED7E6655458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_9EED7E66A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_ips_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_lists`
-- ----------------------------
DROP TABLE IF EXISTS `lead_lists`;
CREATE TABLE `lead_lists` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `alias` varchar(191) NOT NULL,
  `public_name` varchar(191) NOT NULL,
  `filters` longtext NOT NULL COMMENT '(DC2Type:array)',
  `is_global` tinyint(1) NOT NULL,
  `is_preference_center` tinyint(1) NOT NULL,
  `last_built_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_6EC1522A12469DE2` (`category_id`),
  CONSTRAINT `FK_6EC1522A12469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_lists
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_lists_leads`
-- ----------------------------
DROP TABLE IF EXISTS `lead_lists_leads`;
CREATE TABLE `lead_lists_leads` (
  `leadlist_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `manually_removed` tinyint(1) NOT NULL,
  `manually_added` tinyint(1) NOT NULL,
  PRIMARY KEY (`leadlist_id`,`lead_id`),
  KEY `IDX_F5F47C7C55458D` (`lead_id`),
  KEY `manually_removed` (`manually_removed`),
  CONSTRAINT `FK_F5F47C7C55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_F5F47C7CB9FC8874` FOREIGN KEY (`leadlist_id`) REFERENCES `lead_lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_lists_leads
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_notes`
-- ----------------------------
DROP TABLE IF EXISTS `lead_notes`;
CREATE TABLE `lead_notes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
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
  `text` longtext NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `date_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_67FC6B0355458D` (`lead_id`),
  CONSTRAINT `FK_67FC6B0355458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_notes
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_points_change_log`
-- ----------------------------
DROP TABLE IF EXISTS `lead_points_change_log`;
CREATE TABLE `lead_points_change_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `ip_id` int(10) unsigned NOT NULL,
  `type` tinytext NOT NULL,
  `event_name` varchar(191) NOT NULL,
  `action_name` varchar(191) NOT NULL,
  `delta` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_949C2CCC55458D` (`lead_id`),
  KEY `IDX_949C2CCCA03F5E9F` (`ip_id`),
  KEY `point_date_added` (`date_added`),
  CONSTRAINT `FK_949C2CCC55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_949C2CCCA03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_points_change_log
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_stages_change_log`
-- ----------------------------
DROP TABLE IF EXISTS `lead_stages_change_log`;
CREATE TABLE `lead_stages_change_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `stage_id` int(10) unsigned DEFAULT NULL,
  `event_name` varchar(191) NOT NULL,
  `action_name` varchar(191) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_73B42EF355458D` (`lead_id`),
  KEY `IDX_73B42EF32298D193` (`stage_id`),
  CONSTRAINT `FK_73B42EF32298D193` FOREIGN KEY (`stage_id`) REFERENCES `stages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_73B42EF355458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_stages_change_log
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_tags`
-- ----------------------------
DROP TABLE IF EXISTS `lead_tags`;
CREATE TABLE `lead_tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lead_tag_search` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_tags
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_tags_xref`
-- ----------------------------
DROP TABLE IF EXISTS `lead_tags_xref`;
CREATE TABLE `lead_tags_xref` (
  `lead_id` bigint(20) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`lead_id`,`tag_id`),
  KEY `IDX_F2E51EB6BAD26311` (`tag_id`),
  CONSTRAINT `FK_F2E51EB655458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_F2E51EB6BAD26311` FOREIGN KEY (`tag_id`) REFERENCES `lead_tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_tags_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `lead_utmtags`
-- ----------------------------
DROP TABLE IF EXISTS `lead_utmtags`;
CREATE TABLE `lead_utmtags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  `query` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `referer` longtext DEFAULT NULL,
  `remote_host` varchar(191) DEFAULT NULL,
  `url` longtext DEFAULT NULL,
  `user_agent` longtext DEFAULT NULL,
  `utm_campaign` varchar(191) DEFAULT NULL,
  `utm_content` varchar(191) DEFAULT NULL,
  `utm_medium` varchar(191) DEFAULT NULL,
  `utm_source` varchar(191) DEFAULT NULL,
  `utm_term` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_C51BCB8D55458D` (`lead_id`),
  CONSTRAINT `FK_C51BCB8D55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of lead_utmtags
-- ----------------------------

-- ----------------------------
-- Table structure for `messages`
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_DB021E9612469DE2` (`category_id`),
  KEY `date_message_added` (`date_added`),
  CONSTRAINT `FK_DB021E9612469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of messages
-- ----------------------------

-- ----------------------------
-- Table structure for `message_channels`
-- ----------------------------
DROP TABLE IF EXISTS `message_channels`;
CREATE TABLE `message_channels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `message_id` int(10) unsigned NOT NULL,
  `channel` varchar(191) NOT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `properties` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  `is_enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `channel_index` (`message_id`,`channel`),
  KEY `IDX_FA3226A7537A1329` (`message_id`),
  KEY `channel_entity_index` (`channel`,`channel_id`),
  KEY `channel_enabled_index` (`channel`,`is_enabled`),
  CONSTRAINT `FK_FA3226A7537A1329` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of message_channels
-- ----------------------------

-- ----------------------------
-- Table structure for `message_queue`
-- ----------------------------
DROP TABLE IF EXISTS `message_queue`;
CREATE TABLE `message_queue` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `channel` varchar(191) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `priority` smallint(6) NOT NULL,
  `max_attempts` smallint(6) NOT NULL,
  `attempts` smallint(6) NOT NULL,
  `success` tinyint(1) NOT NULL,
  `status` varchar(191) NOT NULL,
  `date_published` datetime DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `last_attempt` datetime DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  `options` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_805B808871F7E88B` (`event_id`),
  KEY `IDX_805B808855458D` (`lead_id`),
  KEY `message_status_search` (`status`),
  KEY `message_date_sent` (`date_sent`),
  KEY `message_scheduled_date` (`scheduled_date`),
  KEY `message_priority` (`priority`),
  KEY `message_success` (`success`),
  KEY `message_channel_search` (`channel`,`channel_id`),
  CONSTRAINT `FK_805B808855458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_805B808871F7E88B` FOREIGN KEY (`event_id`) REFERENCES `campaign_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of message_queue
-- ----------------------------

-- ----------------------------
-- Table structure for `monitoring`
-- ----------------------------
DROP TABLE IF EXISTS `monitoring`;
CREATE TABLE `monitoring` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `title` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `lists` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `network_type` varchar(191) DEFAULT NULL,
  `revision` int(11) NOT NULL,
  `stats` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `properties` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_BA4F975D12469DE2` (`category_id`),
  CONSTRAINT `FK_BA4F975D12469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of monitoring
-- ----------------------------

-- ----------------------------
-- Table structure for `monitoring_leads`
-- ----------------------------
DROP TABLE IF EXISTS `monitoring_leads`;
CREATE TABLE `monitoring_leads` (
  `monitor_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`monitor_id`,`lead_id`),
  KEY `IDX_45207A4A55458D` (`lead_id`),
  CONSTRAINT `FK_45207A4A4CE1C902` FOREIGN KEY (`monitor_id`) REFERENCES `monitoring` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_45207A4A55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of monitoring_leads
-- ----------------------------

-- ----------------------------
-- Table structure for `monitor_post_count`
-- ----------------------------
DROP TABLE IF EXISTS `monitor_post_count`;
CREATE TABLE `monitor_post_count` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `monitor_id` int(10) unsigned DEFAULT NULL,
  `post_date` date NOT NULL,
  `post_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_E3AC20CA4CE1C902` (`monitor_id`),
  CONSTRAINT `FK_E3AC20CA4CE1C902` FOREIGN KEY (`monitor_id`) REFERENCES `monitoring` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of monitor_post_count
-- ----------------------------

-- ----------------------------
-- Table structure for `notifications`
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `type` varchar(25) DEFAULT NULL,
  `header` varchar(512) DEFAULT NULL,
  `message` longtext NOT NULL,
  `date_added` datetime NOT NULL,
  `icon_class` varchar(191) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_6000B0D3A76ED395` (`user_id`),
  KEY `notification_read_status` (`is_read`),
  KEY `notification_type` (`type`),
  KEY `notification_user_read_status` (`is_read`,`user_id`),
  CONSTRAINT `FK_6000B0D3A76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of notifications
-- ----------------------------

-- ----------------------------
-- Table structure for `oauth2_accesstokens`
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_accesstokens`;
CREATE TABLE `oauth2_accesstokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `token` varchar(191) NOT NULL,
  `expires_at` bigint(20) DEFAULT NULL,
  `scope` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_3A18CA5A5F37A13B` (`token`),
  KEY `IDX_3A18CA5A19EB6921` (`client_id`),
  KEY `IDX_3A18CA5AA76ED395` (`user_id`),
  KEY `oauth2_access_token_search` (`token`),
  CONSTRAINT `FK_3A18CA5A19EB6921` FOREIGN KEY (`client_id`) REFERENCES `oauth2_clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_3A18CA5AA76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oauth2_accesstokens
-- ----------------------------

-- ----------------------------
-- Table structure for `oauth2_authcodes`
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_authcodes`;
CREATE TABLE `oauth2_authcodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `token` varchar(191) NOT NULL,
  `expires_at` bigint(20) DEFAULT NULL,
  `scope` varchar(191) DEFAULT NULL,
  `redirect_uri` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_D2B4847B5F37A13B` (`token`),
  KEY `IDX_D2B4847B19EB6921` (`client_id`),
  KEY `IDX_D2B4847BA76ED395` (`user_id`),
  CONSTRAINT `FK_D2B4847B19EB6921` FOREIGN KEY (`client_id`) REFERENCES `oauth2_clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_D2B4847BA76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oauth2_authcodes
-- ----------------------------

-- ----------------------------
-- Table structure for `oauth2_clients`
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_clients`;
CREATE TABLE `oauth2_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `random_id` varchar(191) NOT NULL,
  `secret` varchar(191) NOT NULL,
  `redirect_uris` longtext NOT NULL COMMENT '(DC2Type:array)',
  `allowed_grant_types` longtext NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_F9D02AE6D60322AC` (`role_id`),
  KEY `client_id_search` (`random_id`),
  CONSTRAINT `FK_F9D02AE6D60322AC` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oauth2_clients
-- ----------------------------

-- ----------------------------
-- Table structure for `oauth2_refreshtokens`
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_refreshtokens`;
CREATE TABLE `oauth2_refreshtokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `token` varchar(191) NOT NULL,
  `expires_at` bigint(20) DEFAULT NULL,
  `scope` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_328C5B1B5F37A13B` (`token`),
  KEY `IDX_328C5B1B19EB6921` (`client_id`),
  KEY `IDX_328C5B1BA76ED395` (`user_id`),
  KEY `oauth2_refresh_token_search` (`token`),
  CONSTRAINT `FK_328C5B1B19EB6921` FOREIGN KEY (`client_id`) REFERENCES `oauth2_clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_328C5B1BA76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oauth2_refreshtokens
-- ----------------------------

-- ----------------------------
-- Table structure for `oauth2_user_client_xref`
-- ----------------------------
DROP TABLE IF EXISTS `oauth2_user_client_xref`;
CREATE TABLE `oauth2_user_client_xref` (
  `client_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`client_id`,`user_id`),
  KEY `IDX_1AE34413A76ED395` (`user_id`),
  CONSTRAINT `FK_1AE3441319EB6921` FOREIGN KEY (`client_id`) REFERENCES `oauth2_clients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_1AE34413A76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of oauth2_user_client_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `pages`
-- ----------------------------
DROP TABLE IF EXISTS `pages`;
CREATE TABLE `pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
  `translation_parent_id` int(10) unsigned DEFAULT NULL,
  `variant_parent_id` int(10) unsigned DEFAULT NULL,
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
  `title` varchar(191) NOT NULL,
  `alias` varchar(191) NOT NULL,
  `template` varchar(191) DEFAULT NULL,
  `custom_html` longtext DEFAULT NULL,
  `content` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `hits` int(11) NOT NULL,
  `unique_hits` int(11) NOT NULL,
  `variant_hits` int(11) NOT NULL,
  `revision` int(11) NOT NULL,
  `meta_description` varchar(191) DEFAULT NULL,
  `head_script` longtext DEFAULT NULL,
  `footer_script` longtext DEFAULT NULL,
  `redirect_type` varchar(100) DEFAULT NULL,
  `redirect_url` varchar(2048) DEFAULT NULL,
  `is_preference_center` tinyint(1) DEFAULT NULL,
  `no_index` tinyint(1) DEFAULT NULL,
  `lang` varchar(191) NOT NULL,
  `variant_settings` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `variant_start_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_2074E57512469DE2` (`category_id`),
  KEY `IDX_2074E5759091A2FB` (`translation_parent_id`),
  KEY `IDX_2074E57591861123` (`variant_parent_id`),
  KEY `page_alias_search` (`alias`),
  CONSTRAINT `FK_2074E57512469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_2074E5759091A2FB` FOREIGN KEY (`translation_parent_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_2074E57591861123` FOREIGN KEY (`variant_parent_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of pages
-- ----------------------------

-- ----------------------------
-- Table structure for `page_hits`
-- ----------------------------
DROP TABLE IF EXISTS `page_hits`;
CREATE TABLE `page_hits` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `page_id` int(10) unsigned DEFAULT NULL,
  `redirect_id` bigint(20) unsigned DEFAULT NULL,
  `email_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned NOT NULL,
  `device_id` bigint(20) unsigned DEFAULT NULL,
  `date_hit` datetime NOT NULL,
  `date_left` datetime DEFAULT NULL,
  `country` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL,
  `city` varchar(191) DEFAULT NULL,
  `isp` varchar(191) DEFAULT NULL,
  `organization` varchar(191) DEFAULT NULL,
  `code` int(11) NOT NULL,
  `referer` longtext DEFAULT NULL,
  `url` longtext DEFAULT NULL,
  `url_title` varchar(191) DEFAULT NULL,
  `user_agent` longtext DEFAULT NULL,
  `remote_host` varchar(191) DEFAULT NULL,
  `page_language` varchar(191) DEFAULT NULL,
  `browser_languages` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `tracking_id` varchar(191) NOT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `query` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_9D4B70F1C4663E4` (`page_id`),
  KEY `IDX_9D4B70F1B42D874D` (`redirect_id`),
  KEY `IDX_9D4B70F1A832C1C9` (`email_id`),
  KEY `IDX_9D4B70F155458D` (`lead_id`),
  KEY `IDX_9D4B70F1A03F5E9F` (`ip_id`),
  KEY `IDX_9D4B70F194A4C7D4` (`device_id`),
  KEY `page_hit_tracking_search` (`tracking_id`),
  KEY `page_hit_code_search` (`code`),
  KEY `page_hit_source_search` (`source`,`source_id`),
  KEY `date_hit_left_index` (`date_hit`,`date_left`),
  KEY `page_hit_url` (`url`(128)),
  CONSTRAINT `FK_9D4B70F155458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_9D4B70F194A4C7D4` FOREIGN KEY (`device_id`) REFERENCES `lead_devices` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_9D4B70F1A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_9D4B70F1A832C1C9` FOREIGN KEY (`email_id`) REFERENCES `emails` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_9D4B70F1B42D874D` FOREIGN KEY (`redirect_id`) REFERENCES `page_redirects` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_9D4B70F1C4663E4` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of page_hits
-- ----------------------------

-- ----------------------------
-- Table structure for `page_redirects`
-- ----------------------------
DROP TABLE IF EXISTS `page_redirects`;
CREATE TABLE `page_redirects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
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
  `redirect_id` varchar(25) NOT NULL,
  `url` longtext NOT NULL,
  `hits` int(11) NOT NULL,
  `unique_hits` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of page_redirects
-- ----------------------------

-- ----------------------------
-- Table structure for `permissions`
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
  `bundle` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `bitwise` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_perm` (`bundle`,`name`,`role_id`),
  KEY `IDX_2DEDCC6FD60322AC` (`role_id`),
  CONSTRAINT `FK_2DEDCC6FD60322AC` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of permissions
-- ----------------------------

-- ----------------------------
-- Table structure for `plugins`
-- ----------------------------
DROP TABLE IF EXISTS `plugins`;
CREATE TABLE `plugins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `is_missing` tinyint(1) NOT NULL,
  `bundle` varchar(50) NOT NULL,
  `version` varchar(191) DEFAULT NULL,
  `author` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_bundle` (`bundle`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of plugins
-- ----------------------------
INSERT INTO plugins VALUES ('1', 'GrapesJS Builder', 'GrapesJS Builder with MJML support for Mautic', '0', 'GrapesJsBuilderBundle', '1.0.0', 'Mautic Community');

-- ----------------------------
-- Table structure for `plugin_citrix_events`
-- ----------------------------
DROP TABLE IF EXISTS `plugin_citrix_events`;
CREATE TABLE `plugin_citrix_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned NOT NULL,
  `product` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `event_name` varchar(191) NOT NULL,
  `event_desc` varchar(191) DEFAULT NULL,
  `event_type` varchar(50) NOT NULL,
  `event_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_D77731055458D` (`lead_id`),
  KEY `citrix_event_email` (`product`,`email`),
  KEY `citrix_event_name` (`product`,`event_name`,`event_type`),
  KEY `citrix_event_type` (`product`,`event_type`,`event_date`),
  KEY `citrix_event_product` (`product`,`email`,`event_type`),
  KEY `citrix_event_product_name` (`product`,`email`,`event_type`,`event_name`),
  KEY `citrix_event_product_name_lead` (`product`,`event_type`,`event_name`,`lead_id`),
  KEY `citrix_event_product_type_lead` (`product`,`event_type`,`lead_id`),
  KEY `citrix_event_date` (`event_date`),
  CONSTRAINT `FK_D77731055458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of plugin_citrix_events
-- ----------------------------

-- ----------------------------
-- Table structure for `plugin_crm_pipedrive_owners`
-- ----------------------------
DROP TABLE IF EXISTS `plugin_crm_pipedrive_owners`;
CREATE TABLE `plugin_crm_pipedrive_owners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(191) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `owner_id` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of plugin_crm_pipedrive_owners
-- ----------------------------

-- ----------------------------
-- Table structure for `plugin_integration_settings`
-- ----------------------------
DROP TABLE IF EXISTS `plugin_integration_settings`;
CREATE TABLE `plugin_integration_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plugin_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `is_published` tinyint(1) NOT NULL,
  `supported_features` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `api_keys` longtext NOT NULL COMMENT '(DC2Type:array)',
  `feature_settings` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_941A2CE0EC942BCF` (`plugin_id`),
  CONSTRAINT `FK_941A2CE0EC942BCF` FOREIGN KEY (`plugin_id`) REFERENCES `plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of plugin_integration_settings
-- ----------------------------
INSERT INTO plugin_integration_settings VALUES ('1', '1', 'GrapesJsBuilder', '1', 'a:0:{}', 'a:0:{}', 'a:0:{}');
INSERT INTO plugin_integration_settings VALUES ('2', null, 'OneSignal', '0', 'a:4:{i:0;s:6:\"mobile\";i:1;s:20:\"landing_page_enabled\";i:2;s:28:\"welcome_notification_enabled\";i:3;s:21:\"tracking_page_enabled\";}', 'a:0:{}', 'a:0:{}');
INSERT INTO plugin_integration_settings VALUES ('3', null, 'Twilio', '0', 'a:0:{}', 'a:0:{}', 'a:0:{}');

-- ----------------------------
-- Table structure for `points`
-- ----------------------------
DROP TABLE IF EXISTS `points`;
CREATE TABLE `points` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `repeatable` tinyint(1) NOT NULL,
  `delta` int(11) NOT NULL,
  `properties` longtext NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_27BA8E2912469DE2` (`category_id`),
  KEY `point_type_search` (`type`),
  CONSTRAINT `FK_27BA8E2912469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of points
-- ----------------------------

-- ----------------------------
-- Table structure for `point_lead_action_log`
-- ----------------------------
DROP TABLE IF EXISTS `point_lead_action_log`;
CREATE TABLE `point_lead_action_log` (
  `point_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `date_fired` datetime NOT NULL,
  PRIMARY KEY (`point_id`,`lead_id`),
  KEY `IDX_6DF94A5655458D` (`lead_id`),
  KEY `IDX_6DF94A56A03F5E9F` (`ip_id`),
  CONSTRAINT `FK_6DF94A5655458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_6DF94A56A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_6DF94A56C028CEA2` FOREIGN KEY (`point_id`) REFERENCES `points` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of point_lead_action_log
-- ----------------------------

-- ----------------------------
-- Table structure for `point_lead_event_log`
-- ----------------------------
DROP TABLE IF EXISTS `point_lead_event_log`;
CREATE TABLE `point_lead_event_log` (
  `event_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `date_fired` datetime NOT NULL,
  PRIMARY KEY (`event_id`,`lead_id`),
  KEY `IDX_C2A3BDBA55458D` (`lead_id`),
  KEY `IDX_C2A3BDBAA03F5E9F` (`ip_id`),
  CONSTRAINT `FK_C2A3BDBA55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_C2A3BDBA71F7E88B` FOREIGN KEY (`event_id`) REFERENCES `point_trigger_events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_C2A3BDBAA03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of point_lead_event_log
-- ----------------------------

-- ----------------------------
-- Table structure for `point_triggers`
-- ----------------------------
DROP TABLE IF EXISTS `point_triggers`;
CREATE TABLE `point_triggers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `points` int(11) NOT NULL,
  `color` varchar(7) NOT NULL,
  `trigger_existing_leads` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_9CABD32F12469DE2` (`category_id`),
  CONSTRAINT `FK_9CABD32F12469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of point_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for `point_trigger_events`
-- ----------------------------
DROP TABLE IF EXISTS `point_trigger_events`;
CREATE TABLE `point_trigger_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `trigger_id` int(10) unsigned NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `action_order` int(11) NOT NULL,
  `properties` longtext NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_D5669585FDDDCD6` (`trigger_id`),
  KEY `trigger_type_search` (`type`),
  CONSTRAINT `FK_D5669585FDDDCD6` FOREIGN KEY (`trigger_id`) REFERENCES `point_triggers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of point_trigger_events
-- ----------------------------

-- ----------------------------
-- Table structure for `push_ids`
-- ----------------------------
DROP TABLE IF EXISTS `push_ids`;
CREATE TABLE `push_ids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `push_id` varchar(191) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `mobile` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_4F2393E855458D` (`lead_id`),
  CONSTRAINT `FK_4F2393E855458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of push_ids
-- ----------------------------

-- ----------------------------
-- Table structure for `push_notifications`
-- ----------------------------
DROP TABLE IF EXISTS `push_notifications`;
CREATE TABLE `push_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `lang` varchar(191) NOT NULL,
  `url` longtext DEFAULT NULL,
  `heading` longtext NOT NULL,
  `message` longtext NOT NULL,
  `button` longtext DEFAULT NULL,
  `utm_tags` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `notification_type` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `read_count` int(11) NOT NULL,
  `sent_count` int(11) NOT NULL,
  `mobile` tinyint(1) NOT NULL,
  `mobileSettings` longtext NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_5B9B7E4F12469DE2` (`category_id`),
  CONSTRAINT `FK_5B9B7E4F12469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of push_notifications
-- ----------------------------

-- ----------------------------
-- Table structure for `push_notification_list_xref`
-- ----------------------------
DROP TABLE IF EXISTS `push_notification_list_xref`;
CREATE TABLE `push_notification_list_xref` (
  `notification_id` int(10) unsigned NOT NULL,
  `leadlist_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`notification_id`,`leadlist_id`),
  KEY `IDX_473919EFB9FC8874` (`leadlist_id`),
  CONSTRAINT `FK_473919EFB9FC8874` FOREIGN KEY (`leadlist_id`) REFERENCES `lead_lists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_473919EFEF1A9D84` FOREIGN KEY (`notification_id`) REFERENCES `push_notifications` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of push_notification_list_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `push_notification_stats`
-- ----------------------------
DROP TABLE IF EXISTS `push_notification_stats`;
CREATE TABLE `push_notification_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `notification_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `list_id` int(10) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `date_sent` datetime NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `is_clicked` tinyint(1) NOT NULL,
  `date_clicked` datetime DEFAULT NULL,
  `tracking_hash` varchar(191) DEFAULT NULL,
  `retry_count` int(11) DEFAULT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `tokens` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `click_count` int(11) DEFAULT NULL,
  `last_clicked` datetime DEFAULT NULL,
  `click_details` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_DE63695EEF1A9D84` (`notification_id`),
  KEY `IDX_DE63695E55458D` (`lead_id`),
  KEY `IDX_DE63695E3DAE168B` (`list_id`),
  KEY `IDX_DE63695EA03F5E9F` (`ip_id`),
  KEY `stat_notification_search` (`notification_id`,`lead_id`),
  KEY `stat_notification_clicked_search` (`is_clicked`),
  KEY `stat_notification_hash_search` (`tracking_hash`),
  KEY `stat_notification_source_search` (`source`,`source_id`),
  CONSTRAINT `FK_DE63695E3DAE168B` FOREIGN KEY (`list_id`) REFERENCES `lead_lists` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_DE63695E55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_DE63695EA03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_DE63695EEF1A9D84` FOREIGN KEY (`notification_id`) REFERENCES `push_notifications` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of push_notification_stats
-- ----------------------------

-- ----------------------------
-- Table structure for `reports`
-- ----------------------------
DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `system` tinyint(1) NOT NULL,
  `source` varchar(191) NOT NULL,
  `columns` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `filters` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `table_order` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `graphs` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `group_by` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `aggregators` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `settings` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  `is_scheduled` tinyint(1) NOT NULL,
  `schedule_unit` varchar(191) DEFAULT NULL,
  `to_address` varchar(191) DEFAULT NULL,
  `schedule_day` varchar(191) DEFAULT NULL,
  `schedule_month_frequency` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of reports
-- ----------------------------
INSERT INTO reports VALUES ('1', '1', null, null, null, null, null, null, null, null, null, 'Visits published Pages', null, '1', 'page.hits', 'a:7:{i:0;s:11:\"ph.date_hit\";i:1;s:6:\"ph.url\";i:2;s:12:\"ph.url_title\";i:3;s:10:\"ph.referer\";i:4;s:12:\"i.ip_address\";i:5;s:7:\"ph.city\";i:6;s:10:\"ph.country\";}', 'a:2:{i:0;a:3:{s:6:\"column\";s:7:\"ph.code\";s:9:\"condition\";s:2:\"eq\";s:5:\"value\";s:3:\"200\";}i:1;a:3:{s:6:\"column\";s:14:\"p.is_published\";s:9:\"condition\";s:2:\"eq\";s:5:\"value\";s:1:\"1\";}}', 'a:1:{i:0;a:2:{s:6:\"column\";s:11:\"ph.date_hit\";s:9:\"direction\";s:3:\"ASC\";}}', 'a:8:{i:0;s:35:\"mautic.page.graph.line.time.on.site\";i:1;s:27:\"mautic.page.graph.line.hits\";i:2;s:38:\"mautic.page.graph.pie.new.vs.returning\";i:3;s:31:\"mautic.page.graph.pie.languages\";i:4;s:34:\"mautic.page.graph.pie.time.on.site\";i:5;s:27:\"mautic.page.table.referrers\";i:6;s:30:\"mautic.page.table.most.visited\";i:7;s:37:\"mautic.page.table.most.visited.unique\";}', 'a:0:{}', 'a:0:{}', '[]', '0', null, null, null, null);
INSERT INTO reports VALUES ('2', '1', null, null, null, null, null, null, null, null, null, 'Downloads of all Assets', null, '1', 'asset.downloads', 'a:7:{i:0;s:16:\"ad.date_download\";i:1;s:7:\"a.title\";i:2;s:12:\"i.ip_address\";i:3;s:11:\"l.firstname\";i:4;s:10:\"l.lastname\";i:5;s:7:\"l.email\";i:6;s:4:\"a.id\";}', 'a:1:{i:0;a:3:{s:6:\"column\";s:14:\"a.is_published\";s:9:\"condition\";s:2:\"eq\";s:5:\"value\";s:1:\"1\";}}', 'a:1:{i:0;a:2:{s:6:\"column\";s:16:\"ad.date_download\";s:9:\"direction\";s:3:\"ASC\";}}', 'a:4:{i:0;s:33:\"mautic.asset.graph.line.downloads\";i:1;s:31:\"mautic.asset.graph.pie.statuses\";i:2;s:34:\"mautic.asset.table.most.downloaded\";i:3;s:32:\"mautic.asset.table.top.referrers\";}', 'a:0:{}', 'a:0:{}', '[]', '0', null, null, null, null);
INSERT INTO reports VALUES ('3', '1', null, null, null, null, null, null, null, null, null, 'Submissions of published Forms', null, '1', 'form.submissions', 'a:0:{}', 'a:1:{i:1;a:3:{s:6:\"column\";s:14:\"f.is_published\";s:9:\"condition\";s:2:\"eq\";s:5:\"value\";s:1:\"1\";}}', 'a:0:{}', 'a:3:{i:0;s:34:\"mautic.form.graph.line.submissions\";i:1;s:32:\"mautic.form.table.most.submitted\";i:2;s:31:\"mautic.form.table.top.referrers\";}', 'a:0:{}', 'a:0:{}', '[]', '0', null, null, null, null);
INSERT INTO reports VALUES ('4', '1', null, null, null, null, null, null, null, null, null, 'All Emails', null, '1', 'email.stats', 'a:5:{i:0;s:12:\"es.date_sent\";i:1;s:12:\"es.date_read\";i:2;s:9:\"e.subject\";i:3;s:16:\"es.email_address\";i:4;s:4:\"e.id\";}', 'a:1:{i:0;a:3:{s:6:\"column\";s:14:\"e.is_published\";s:9:\"condition\";s:2:\"eq\";s:5:\"value\";s:1:\"1\";}}', 'a:1:{i:0;a:2:{s:6:\"column\";s:12:\"es.date_sent\";s:9:\"direction\";s:3:\"ASC\";}}', 'a:6:{i:0;s:29:\"mautic.email.graph.line.stats\";i:1;s:42:\"mautic.email.graph.pie.ignored.read.failed\";i:2;s:35:\"mautic.email.table.most.emails.read\";i:3;s:35:\"mautic.email.table.most.emails.sent\";i:4;s:43:\"mautic.email.table.most.emails.read.percent\";i:5;s:37:\"mautic.email.table.most.emails.failed\";}', 'a:0:{}', 'a:0:{}', '[]', '0', null, null, null, null);
INSERT INTO reports VALUES ('5', '1', null, null, null, null, null, null, null, null, null, 'Leads and Points', null, '1', 'lead.pointlog', 'a:7:{i:0;s:13:\"lp.date_added\";i:1;s:7:\"lp.type\";i:2;s:13:\"lp.event_name\";i:3;s:11:\"l.firstname\";i:4;s:10:\"l.lastname\";i:5;s:7:\"l.email\";i:6;s:8:\"lp.delta\";}', 'a:0:{}', 'a:1:{i:0;a:2:{s:6:\"column\";s:13:\"lp.date_added\";s:9:\"direction\";s:3:\"ASC\";}}', 'a:6:{i:0;s:29:\"mautic.lead.graph.line.points\";i:1;s:29:\"mautic.lead.table.most.points\";i:2;s:29:\"mautic.lead.table.top.actions\";i:3;s:28:\"mautic.lead.table.top.cities\";i:4;s:31:\"mautic.lead.table.top.countries\";i:5;s:28:\"mautic.lead.table.top.events\";}', 'a:0:{}', 'a:0:{}', '[]', '0', null, null, null, null);

-- ----------------------------
-- Table structure for `reports_schedulers`
-- ----------------------------
DROP TABLE IF EXISTS `reports_schedulers`;
CREATE TABLE `reports_schedulers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` int(10) unsigned NOT NULL,
  `schedule_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_C74CA6B84BD2A4C0` (`report_id`),
  CONSTRAINT `FK_C74CA6B84BD2A4C0` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of reports_schedulers
-- ----------------------------

-- ----------------------------
-- Table structure for `roles`
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL,
  `readable_permissions` longtext NOT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO roles VALUES ('1', '1', null, null, null, null, null, null, null, null, null, 'Administrator', 'Full system access', '1', 'N;');

-- ----------------------------
-- Table structure for `saml_id_entry`
-- ----------------------------
DROP TABLE IF EXISTS `saml_id_entry`;
CREATE TABLE `saml_id_entry` (
  `id` varchar(191) NOT NULL,
  `entity_id` varchar(191) NOT NULL,
  `expiryTimestamp` int(11) NOT NULL,
  PRIMARY KEY (`id`,`entity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of saml_id_entry
-- ----------------------------

-- ----------------------------
-- Table structure for `sms_messages`
-- ----------------------------
DROP TABLE IF EXISTS `sms_messages`;
CREATE TABLE `sms_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `lang` varchar(191) NOT NULL,
  `message` longtext NOT NULL,
  `sms_type` longtext DEFAULT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  `sent_count` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_BDF43F9712469DE2` (`category_id`),
  CONSTRAINT `FK_BDF43F9712469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sms_messages
-- ----------------------------

-- ----------------------------
-- Table structure for `sms_message_list_xref`
-- ----------------------------
DROP TABLE IF EXISTS `sms_message_list_xref`;
CREATE TABLE `sms_message_list_xref` (
  `sms_id` int(10) unsigned NOT NULL,
  `leadlist_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`sms_id`,`leadlist_id`),
  KEY `IDX_B032FC2EB9FC8874` (`leadlist_id`),
  CONSTRAINT `FK_B032FC2EB9FC8874` FOREIGN KEY (`leadlist_id`) REFERENCES `lead_lists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_B032FC2EBD5C7E60` FOREIGN KEY (`sms_id`) REFERENCES `sms_messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sms_message_list_xref
-- ----------------------------

-- ----------------------------
-- Table structure for `sms_message_stats`
-- ----------------------------
DROP TABLE IF EXISTS `sms_message_stats`;
CREATE TABLE `sms_message_stats` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sms_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `list_id` int(10) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `date_sent` datetime NOT NULL,
  `is_failed` tinyint(1) DEFAULT NULL,
  `tracking_hash` varchar(191) DEFAULT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `tokens` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `details` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  PRIMARY KEY (`id`),
  KEY `IDX_FE1BAE9BD5C7E60` (`sms_id`),
  KEY `IDX_FE1BAE955458D` (`lead_id`),
  KEY `IDX_FE1BAE93DAE168B` (`list_id`),
  KEY `IDX_FE1BAE9A03F5E9F` (`ip_id`),
  KEY `stat_sms_search` (`sms_id`,`lead_id`),
  KEY `stat_sms_hash_search` (`tracking_hash`),
  KEY `stat_sms_source_search` (`source`,`source_id`),
  KEY `stat_sms_failed_search` (`is_failed`),
  CONSTRAINT `FK_FE1BAE93DAE168B` FOREIGN KEY (`list_id`) REFERENCES `lead_lists` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_FE1BAE955458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_FE1BAE9A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`),
  CONSTRAINT `FK_FE1BAE9BD5C7E60` FOREIGN KEY (`sms_id`) REFERENCES `sms_messages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sms_message_stats
-- ----------------------------

-- ----------------------------
-- Table structure for `stages`
-- ----------------------------
DROP TABLE IF EXISTS `stages`;
CREATE TABLE `stages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `weight` int(11) NOT NULL,
  `publish_up` datetime DEFAULT NULL,
  `publish_down` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_2FA26A6412469DE2` (`category_id`),
  CONSTRAINT `FK_2FA26A6412469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of stages
-- ----------------------------

-- ----------------------------
-- Table structure for `stage_lead_action_log`
-- ----------------------------
DROP TABLE IF EXISTS `stage_lead_action_log`;
CREATE TABLE `stage_lead_action_log` (
  `stage_id` int(10) unsigned NOT NULL,
  `lead_id` bigint(20) unsigned NOT NULL,
  `ip_id` int(10) unsigned DEFAULT NULL,
  `date_fired` datetime NOT NULL,
  PRIMARY KEY (`stage_id`,`lead_id`),
  KEY `IDX_A506AFBE55458D` (`lead_id`),
  KEY `IDX_A506AFBEA03F5E9F` (`ip_id`),
  CONSTRAINT `FK_A506AFBE2298D193` FOREIGN KEY (`stage_id`) REFERENCES `stages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_A506AFBE55458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_A506AFBEA03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of stage_lead_action_log
-- ----------------------------

-- ----------------------------
-- Table structure for `sync_object_field_change_report`
-- ----------------------------
DROP TABLE IF EXISTS `sync_object_field_change_report`;
CREATE TABLE `sync_object_field_change_report` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `integration` varchar(191) NOT NULL,
  `object_id` bigint(20) unsigned NOT NULL,
  `object_type` varchar(191) NOT NULL,
  `modified_at` datetime NOT NULL,
  `column_name` varchar(191) NOT NULL,
  `column_type` varchar(191) NOT NULL,
  `column_value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_composite_key` (`object_type`,`object_id`,`column_name`),
  KEY `integration_object_composite_key` (`integration`,`object_type`,`object_id`,`column_name`),
  KEY `integration_object_type_modification_composite_key` (`integration`,`object_type`,`modified_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sync_object_field_change_report
-- ----------------------------

-- ----------------------------
-- Table structure for `sync_object_mapping`
-- ----------------------------
DROP TABLE IF EXISTS `sync_object_mapping`;
CREATE TABLE `sync_object_mapping` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_created` datetime NOT NULL,
  `integration` varchar(191) NOT NULL,
  `internal_object_name` varchar(191) NOT NULL,
  `internal_object_id` bigint(20) unsigned NOT NULL,
  `integration_object_name` varchar(191) NOT NULL,
  `integration_object_id` varchar(191) NOT NULL,
  `last_sync_date` datetime NOT NULL,
  `internal_storage` longtext NOT NULL COMMENT '(DC2Type:json_array)',
  `is_deleted` tinyint(1) NOT NULL,
  `integration_reference_id` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `integration_object` (`integration`,`integration_object_name`,`integration_object_id`,`integration_reference_id`),
  KEY `integration_reference` (`integration`,`integration_object_name`,`integration_reference_id`,`integration_object_id`),
  KEY `integration_last_sync_date` (`integration`,`last_sync_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sync_object_mapping
-- ----------------------------

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

-- ----------------------------
-- Table structure for `tweets`
-- ----------------------------
DROP TABLE IF EXISTS `tweets`;
CREATE TABLE `tweets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
  `page_id` int(10) unsigned DEFAULT NULL,
  `asset_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `media_id` varchar(191) DEFAULT NULL,
  `media_path` varchar(191) DEFAULT NULL,
  `text` varchar(191) NOT NULL,
  `sent_count` int(11) DEFAULT NULL,
  `favorite_count` int(11) DEFAULT NULL,
  `retweet_count` int(11) DEFAULT NULL,
  `lang` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_AA38402512469DE2` (`category_id`),
  KEY `IDX_AA384025C4663E4` (`page_id`),
  KEY `IDX_AA3840255DA1941` (`asset_id`),
  KEY `sent_count_index` (`sent_count`),
  KEY `favorite_count_index` (`favorite_count`),
  KEY `retweet_count_index` (`retweet_count`),
  CONSTRAINT `FK_AA38402512469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_AA3840255DA1941` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_AA384025C4663E4` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tweets
-- ----------------------------

-- ----------------------------
-- Table structure for `tweet_stats`
-- ----------------------------
DROP TABLE IF EXISTS `tweet_stats`;
CREATE TABLE `tweet_stats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tweet_id` int(10) unsigned DEFAULT NULL,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `twitter_tweet_id` varchar(191) DEFAULT NULL,
  `handle` varchar(191) NOT NULL,
  `date_sent` datetime DEFAULT NULL,
  `is_failed` tinyint(1) DEFAULT NULL,
  `retry_count` int(11) DEFAULT NULL,
  `source` varchar(191) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `favorite_count` int(11) DEFAULT NULL,
  `retweet_count` int(11) DEFAULT NULL,
  `response_details` longtext DEFAULT NULL COMMENT '(DC2Type:json_array)',
  PRIMARY KEY (`id`),
  KEY `IDX_CB8CBAE51041E39B` (`tweet_id`),
  KEY `IDX_CB8CBAE555458D` (`lead_id`),
  KEY `stat_tweet_search` (`tweet_id`,`lead_id`),
  KEY `stat_tweet_search2` (`lead_id`,`tweet_id`),
  KEY `stat_tweet_failed_search` (`is_failed`),
  KEY `stat_tweet_source_search` (`source`,`source_id`),
  KEY `favorite_count_index` (`favorite_count`),
  KEY `retweet_count_index` (`retweet_count`),
  KEY `tweet_date_sent` (`date_sent`),
  KEY `twitter_tweet_id_index` (`twitter_tweet_id`),
  CONSTRAINT `FK_CB8CBAE51041E39B` FOREIGN KEY (`tweet_id`) REFERENCES `tweets` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_CB8CBAE555458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tweet_stats
-- ----------------------------

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(10) unsigned NOT NULL,
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
  `username` varchar(191) NOT NULL,
  `password` varchar(64) NOT NULL,
  `first_name` varchar(191) NOT NULL,
  `last_name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `position` varchar(191) DEFAULT NULL,
  `timezone` varchar(191) DEFAULT NULL,
  `locale` varchar(191) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `last_active` datetime DEFAULT NULL,
  `preferences` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `signature` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_1483A5E9F85E0677` (`username`),
  UNIQUE KEY `UNIQ_1483A5E9E7927C74` (`email`),
  KEY `IDX_1483A5E9D60322AC` (`role_id`),
  CONSTRAINT `FK_1483A5E9D60322AC` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO users VALUES ('1', '1', '1', null, null, null, null, null, null, null, null, null, 'admin', '$2y$13$bAm5A.AJmUDxEd3Wk5uwRuo0PSolzEQ.qFykZ/.LkO/e.9TN1LRPe', 'Hai', 'Ha', 'haihs@meeyland.com', null, '', '', '2024-06-30 14:45:40', '2024-06-30 14:45:40', 'a:0:{}', null);

-- ----------------------------
-- Table structure for `user_tokens`
-- ----------------------------
DROP TABLE IF EXISTS `user_tokens`;
CREATE TABLE `user_tokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `authorizator` varchar(32) NOT NULL,
  `secret` varchar(120) NOT NULL,
  `expiration` datetime DEFAULT NULL,
  `one_time_only` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_CF080AB35CA2E8E5` (`secret`),
  KEY `IDX_CF080AB3A76ED395` (`user_id`),
  CONSTRAINT `FK_CF080AB3A76ED395` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of user_tokens
-- ----------------------------

-- ----------------------------
-- Table structure for `video_hits`
-- ----------------------------
DROP TABLE IF EXISTS `video_hits`;
CREATE TABLE `video_hits` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` bigint(20) unsigned DEFAULT NULL,
  `ip_id` int(10) unsigned NOT NULL,
  `date_hit` datetime NOT NULL,
  `date_left` datetime DEFAULT NULL,
  `country` varchar(191) DEFAULT NULL,
  `region` varchar(191) DEFAULT NULL,
  `city` varchar(191) DEFAULT NULL,
  `isp` varchar(191) DEFAULT NULL,
  `organization` varchar(191) DEFAULT NULL,
  `code` int(11) NOT NULL,
  `referer` longtext DEFAULT NULL,
  `url` longtext DEFAULT NULL,
  `user_agent` longtext DEFAULT NULL,
  `remote_host` varchar(191) DEFAULT NULL,
  `guid` varchar(191) NOT NULL,
  `page_language` varchar(191) DEFAULT NULL,
  `browser_languages` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  `channel` varchar(191) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `time_watched` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `query` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`),
  KEY `IDX_1D1831F755458D` (`lead_id`),
  KEY `IDX_1D1831F7A03F5E9F` (`ip_id`),
  KEY `video_date_hit` (`date_hit`),
  KEY `video_channel_search` (`channel`,`channel_id`),
  KEY `video_guid_lead_search` (`guid`,`lead_id`),
  CONSTRAINT `FK_1D1831F755458D` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE SET NULL,
  CONSTRAINT `FK_1D1831F7A03F5E9F` FOREIGN KEY (`ip_id`) REFERENCES `ip_addresses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of video_hits
-- ----------------------------

-- ----------------------------
-- Table structure for `webhooks`
-- ----------------------------
DROP TABLE IF EXISTS `webhooks`;
CREATE TABLE `webhooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(10) unsigned DEFAULT NULL,
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
  `name` varchar(191) NOT NULL,
  `description` longtext DEFAULT NULL,
  `webhook_url` longtext NOT NULL,
  `secret` varchar(191) NOT NULL,
  `events_orderby_dir` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_998C4FDD12469DE2` (`category_id`),
  CONSTRAINT `FK_998C4FDD12469DE2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of webhooks
-- ----------------------------

-- ----------------------------
-- Table structure for `webhook_events`
-- ----------------------------
DROP TABLE IF EXISTS `webhook_events`;
CREATE TABLE `webhook_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `webhook_id` int(10) unsigned NOT NULL,
  `event_type` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_7AD44E375C9BA60B` (`webhook_id`),
  CONSTRAINT `FK_7AD44E375C9BA60B` FOREIGN KEY (`webhook_id`) REFERENCES `webhooks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of webhook_events
-- ----------------------------

-- ----------------------------
-- Table structure for `webhook_logs`
-- ----------------------------
DROP TABLE IF EXISTS `webhook_logs`;
CREATE TABLE `webhook_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `webhook_id` int(10) unsigned NOT NULL,
  `status_code` varchar(50) NOT NULL,
  `date_added` datetime DEFAULT NULL,
  `note` varchar(191) DEFAULT NULL,
  `runtime` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_45A353475C9BA60B` (`webhook_id`),
  CONSTRAINT `FK_45A353475C9BA60B` FOREIGN KEY (`webhook_id`) REFERENCES `webhooks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of webhook_logs
-- ----------------------------

-- ----------------------------
-- Table structure for `webhook_queue`
-- ----------------------------
DROP TABLE IF EXISTS `webhook_queue`;
CREATE TABLE `webhook_queue` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `webhook_id` int(10) unsigned NOT NULL,
  `event_id` int(10) unsigned NOT NULL,
  `date_added` datetime DEFAULT NULL,
  `payload` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `IDX_F52D9A1A5C9BA60B` (`webhook_id`),
  KEY `IDX_F52D9A1A71F7E88B` (`event_id`),
  CONSTRAINT `FK_F52D9A1A5C9BA60B` FOREIGN KEY (`webhook_id`) REFERENCES `webhooks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_F52D9A1A71F7E88B` FOREIGN KEY (`event_id`) REFERENCES `webhook_events` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of webhook_queue
-- ----------------------------

-- ----------------------------
-- Table structure for `widgets`
-- ----------------------------
DROP TABLE IF EXISTS `widgets`;
CREATE TABLE `widgets` (
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
  `name` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `cache_timeout` int(11) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `params` longtext DEFAULT NULL COMMENT '(DC2Type:array)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of widgets
-- ----------------------------
INSERT INTO widgets VALUES ('1', '1', '2024-06-30 12:30:31', '1', 'Hai Ha', '2024-06-30 12:30:31', null, null, null, null, null, 'Contacts Created', 'created.leads.in.time', '100', '330', null, '0', 'a:1:{s:5:\"lists\";s:21:\"identifiedVsAnonymous\";}');
INSERT INTO widgets VALUES ('2', '1', '2024-06-30 12:30:31', '1', 'Hai Ha', '2024-06-30 12:30:31', null, null, null, null, null, 'Page Visits', 'page.hits.in.time', '50', '330', null, '1', 'a:1:{s:4:\"flag\";s:6:\"unique\";}');
INSERT INTO widgets VALUES ('3', '1', '2024-06-30 12:30:31', '1', 'Hai Ha', '2024-06-30 12:30:31', null, null, null, null, null, 'Form Submissions', 'submissions.in.time', '50', '330', null, '2', 'a:0:{}');
INSERT INTO widgets VALUES ('4', '1', '2024-06-30 12:30:31', '1', 'Hai Ha', '2024-06-30 12:30:31', null, null, null, null, null, 'Recent Activity', 'recent.activity', '50', '330', null, '3', 'a:0:{}');
INSERT INTO widgets VALUES ('5', '1', '2024-06-30 12:30:31', '1', 'Hai Ha', '2024-06-30 12:30:31', null, null, null, null, null, 'Upcoming Emails', 'upcoming.emails', '50', '330', null, '4', 'a:0:{}');
