-- dragonfly dev DB sync dump
-- generated: 2026-06-04 21:12:42 JST
-- database: dragonfly
-- export: bin/db-export.sh (overwrite www/database/sync/dragonfly.sql)

/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.2.6-MariaDB, for debian-linux-gnu (aarch64)
--
-- Host: localhost    Database: dragonfly
-- ------------------------------------------------------
-- Server version	11.2.6-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bo_assignment_audit_logs`
--

DROP TABLE IF EXISTS `bo_assignment_audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bo_assignment_audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `actor_user_id` bigint(20) unsigned DEFAULT NULL,
  `actor_owner_member_id` bigint(20) unsigned DEFAULT NULL,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `source` varchar(40) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `occurred_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bo_assignment_audit_logs_actor_user_id_foreign` (`actor_user_id`),
  KEY `bo_assignment_audit_logs_actor_owner_member_id_occurred_at_index` (`actor_owner_member_id`,`occurred_at`),
  KEY `bo_assignment_audit_logs_meeting_id_index` (`meeting_id`),
  CONSTRAINT `bo_assignment_audit_logs_actor_owner_member_id_foreign` FOREIGN KEY (`actor_owner_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bo_assignment_audit_logs_actor_user_id_foreign` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `bo_assignment_audit_logs_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bo_assignment_audit_logs`
--

LOCK TABLES `bo_assignment_audit_logs` WRITE;
/*!40000 ALTER TABLE `bo_assignment_audit_logs` DISABLE KEYS */;
INSERT INTO `bo_assignment_audit_logs` VALUES
(1,4,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[52,26,2,14,19],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[52,26,2,14,19,55],\"notes\":null}]}','2026-03-24 00:52:49','2026-03-24 00:52:49','2026-03-24 00:52:49'),
(2,4,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[52,26,2,14,19],\"notes\":\"\\u98ef\\u7530\\u3055\\u3093\\u306e\\u8a08\\u3089\\u3044\\u3067\\u79c1\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\u3092\\u3055\\u305b\\u3066\\u3082\\u3089\\u3063\\u305f\"},{\"room_label\":\"BO2\",\"member_ids\":[52,26,2,14,19,55],\"notes\":null}]}','2026-03-24 01:11:16','2026-03-24 01:11:16','2026-03-24 01:11:16'),
(3,4,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[52,26,2,14,19],\"notes\":\"\\u98ef\\u7530\\u3055\\u3093\\u306e\\u8a08\\u3089\\u3044\\u3067\\u79c1\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\u3092\\u3055\\u305b\\u3066\\u3082\\u3089\\u3063\\u305f\"},{\"room_label\":\"BO2\",\"member_ids\":[52,26,2,14,19,55],\"notes\":\"\\u5c0f\\u91ce\\u5bfa\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\u795e\\u5948\\u5ddd\\u770c\\u306e\\u4e0d\\u52d5\\u7523\\u696d\\uff08\\u58f2\\u8cb7\\u30fb\\u8cc3\\u8cb8\\uff09\\n\\u98f2\\u98df\\u4ee5\\u5916\\u306e\\u5e97\\u8217\\n\\u4e00\\u90fd\\u4e09\\u770c\\u3001\\u95a2\\u897f\\n\\u30fb\\u672a\\u516c\\u958b\\u7269\\u4ef6\\n\\u30fb\\u5e97\\u8217\\u304cNG\\u7269\\u4ef6\\u306b\\u3082\\u5bfe\\u5fdc\\u53ef\\u80fd\\n\\u30fb\\u30d5\\u30e9\\u30f3\\u30c1\\u30e3\\u30a4\\u30ba\\u672c\\u90e8\\u3067\\u306e\\u62c5\\u5f53\\u5bfe\\u5fdc\\u304c\\u3067\\u304d\\u308b\"}]}','2026-03-24 01:19:05','2026-03-24 01:19:05','2026-03-24 01:19:05'),
(4,6,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[32,42,30],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[32,42,30,66],\"notes\":null}]}','2026-03-31 00:12:15','2026-03-31 00:12:15','2026-03-31 00:12:15'),
(5,6,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[32,42,30],\"notes\":\"\\u4f50\\u4e45\\u9593\\u3055\\u3093\\u306e\\u8a08\\u3089\\u3044\\u3067\\u81ea\\u5df1\\u7d39\\u4ecb\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\u3001\\u8cea\\u7591\\u5fdc\\u7b54\\n\\u4f50\\u4e45\\u9593\\u3055\\u3093\\u304b\\u3089\\u306f\\u5de5\\u7a0b\\u7ba1\\u7406\\u3060\\u3063\\u305f\\u308a\\u305d\\u3046\\u3044\\u3046\\u3053\\u3068\\u306b\\u3082\\u5bfe\\u5fdc\\u3067\\u304d\\u308b\\u306e\\u304b\\u3068\\u554f\\u3044\\u5408\\u308f\\u305b\\u304c\\u3042\\u3063\\u305f\"},{\"room_label\":\"BO2\",\"member_ids\":[32,42,30,66],\"notes\":null}]}','2026-03-31 01:11:56','2026-03-31 01:11:56','2026-03-31 01:11:56'),
(6,6,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[32,42,30],\"notes\":\"\\u4f50\\u4e45\\u9593\\u3055\\u3093\\u306e\\u8a08\\u3089\\u3044\\u3067\\u81ea\\u5df1\\u7d39\\u4ecb\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\u3001\\u8cea\\u7591\\u5fdc\\u7b54\\n\\u4f50\\u4e45\\u9593\\u3055\\u3093\\u304b\\u3089\\u306f\\u5de5\\u7a0b\\u7ba1\\u7406\\u3060\\u3063\\u305f\\u308a\\u305d\\u3046\\u3044\\u3046\\u3053\\u3068\\u306b\\u3082\\u5bfe\\u5fdc\\u3067\\u304d\\u308b\\u306e\\u304b\\u3068\\u554f\\u3044\\u5408\\u308f\\u305b\\u304c\\u3042\\u3063\\u305f\"},{\"room_label\":\"BO2\",\"member_ids\":[32,42,30,66],\"notes\":\"\\u30d3\\u30b8\\u30bf\\u30fc\\u7c73\\u6fa4\\u3055\\u3093\\n\\nWeb\\u30c7\\u30b6\\u30a4\\u30f3\\u306e\\u8b1b\\u5e2b\\u7d4c\\u9a13\\u3042\\u308a\\u2028\\u30b5\\u30fc\\u30d3\\u30b9\\u696d\\u7cfb\\u306eLP\\u306a\\u3069\\u5f37\\u3044\\n\\n\\u30b3\\u30ed\\u30ca\\u3092\\u304d\\u3063\\u304b\\u3051\\u306b\\u30d1\\u30c6\\u30a3\\u30b7\\u30a83\\u5e74\\u3092\\u52d9\\u3081\\u3066Web\\u30c7\\u30b6\\u30a4\\u30ca\\u3068\\u3057\\u3066\\n\\u884c\\u52d5\\u5fc3\\u7406\\u304b\\u3089\\u30c7\\u30b6\\u30a4\\u30f3\\u3092\\u8ffd\\u6c42\"}]}','2026-03-31 01:18:35','2026-03-31 01:18:35','2026-03-31 01:18:35'),
(7,7,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[12,71],\"notes\":\"\\u6fa4\\u91ce\\u3055\\u3093PR\\n\\n\\u30d5\\u30ea\\u30fc\\u30e9\\u30f3\\u30b9\\u3067\\u6d3b\\u52d5\\n\\u770c\\u5185\\u5916\\u3000\\u6771\\u4eac\\u3068\\u9759\\u5ca1\\u306e\\u5e83\\u544a\\u4ee3\\u7406\\u5e97\\u304b\\u3089\\u306e\\u4f9d\\u983c\\nWeb\\u4ee5\\u5916\\u5bfe\\u5fdc\\u53ef\\u80fd\\n\\u30b0\\u30e9\\u30d5\\u30a3\\u30c3\\u30af\\u30c7\\u30b6\\u30a4\\u30f3\\u5168\\u822c\\n\\u7d19\\u5a92\\u4f53\\u5c02\\u9580\\n\\u30d0\\u30ca\\u30fc\\u306a\\u3069\\u30d1\\u30fc\\u30c4\\u306f\\u5bfe\\u5fdc\\u53ef\\u80fd\"},{\"room_label\":\"BO2\",\"member_ids\":[12,55],\"notes\":\"\\u30a8\\u30b9\\u30c6\\u30c6\\u30a3\\u30b7\\u30e3\\u30f3\\u3068\\u3057\\u3066\\u3082\\u6d3b\\u52d5\\n\\u4eca\\u5f8c\\u306f\\u30a8\\u30b9\\u30c6\\u3067\\u958b\\u696d\\u3057\\u305f\\u3044\\n\\n\\u795e\\u5948\\u5ddd\\u5728\\u4f4f\\n\\u95a2\\u6771\\u570f\\u3067\\u958b\\u696d\\u4e88\\u5b9a\\n\\n\\u7e4b\\u304c\\u308a\\u305f\\u3044\\u696d\\u7a2e\\n\\u30ec\\u30f3\\u30bf\\u30eb\\u30b9\\u30da\\u30fc\\u30b9\\u4e8b\\u696d\\n\\u5b9f\\u5e97\\u8217\\u3092\\u6301\\u3063\\u305f\\u30aa\\u30fc\\u30ca\\u30fc\\u306e\\u30c1\\u30e9\\u30b7\\u3001\\u30d1\\u30f3\\u30d5\\u30ec\\u30c3\\u30c8\\u4f5c\\u6210\\u5bfe\\u5fdc\\u53ef\\u80fd\"}]}','2026-04-07 01:16:39','2026-04-07 01:16:39','2026-04-07 01:16:39'),
(8,8,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[41,12,56],\"notes\":\"\\u6e21\\u4e95\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\n\\u9759\\u5ca1\\u770c\\u5bcc\\u58eb\\u5bae\\u5e02\\n\\u81ea\\u5b85\\u30b5\\u30ed\\u30f3\\u3067\\u8033\\u30c4\\u30dc\\n\\u8033\\u306b\\u306f\\uff11\\uff11\\uff10\\u500b\\u30c4\\u30dc\\u304c\\u3042\\u308b\\n\\n\\u907a\\u4f1d\\u5b50\\u691c\\u67fb\\u30ad\\u30c3\\u30c8\\u306e\\u7d39\\u4ecb\\n\\u553e\\u6db2\\u9001\\u4ed8\\u2192\\u30b9\\u30de\\u30db\\u30a2\\u30d7\\u30ea\\u3067\\u75c5\\u6c17\\u306b\\u304b\\u304b\\u308a\\u3084\\u3059\\u3044\\u60c5\\u5831\\u306a\\u3069\\u78ba\\u8a8d\\u3067\\u304d\\u308b\\n\\u4e88\\u9632\\u7b56\\u306a\\u3069\\u3092\\u63d0\\u6848\\u3057\\u3066\\u304f\\u308c\\u308b\\n\\u3000\\u91d1\\u984d\\u219229,800\\u5186\"},{\"room_label\":\"BO2\",\"member_ids\":[41,12],\"notes\":null}]}','2026-04-14 10:11:02','2026-04-14 10:11:02','2026-04-14 10:11:02'),
(9,8,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[41,12,56],\"notes\":\"\\u6e21\\u4e95\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\n\\u9759\\u5ca1\\u770c\\u5bcc\\u58eb\\u5bae\\u5e02\\n\\u81ea\\u5b85\\u30b5\\u30ed\\u30f3\\u3067\\u8033\\u30c4\\u30dc\\n\\u8033\\u306b\\u306f\\uff11\\uff11\\uff10\\u500b\\u30c4\\u30dc\\u304c\\u3042\\u308b\\n\\n\\u907a\\u4f1d\\u5b50\\u691c\\u67fb\\u30ad\\u30c3\\u30c8\\u306e\\u7d39\\u4ecb\\n\\u553e\\u6db2\\u9001\\u4ed8\\u2192\\u30b9\\u30de\\u30db\\u30a2\\u30d7\\u30ea\\u3067\\u75c5\\u6c17\\u306b\\u304b\\u304b\\u308a\\u3084\\u3059\\u3044\\u60c5\\u5831\\u306a\\u3069\\u78ba\\u8a8d\\u3067\\u304d\\u308b\\n\\u4e88\\u9632\\u7b56\\u306a\\u3069\\u3092\\u63d0\\u6848\\u3057\\u3066\\u304f\\u308c\\u308b\\n\\u3000\\u91d1\\u984d\\u219229,800\\u5186\"},{\"room_label\":\"BO2\",\"member_ids\":[41,12],\"notes\":\"\\u96c5\\u3055\\u3093\\u306e\\u65b0\\u898f\\u4e8b\\u696d\\u306b\\u95a2\\u3057\\u3066\\n\\u7537\\u6027\\u306eAGA\\u5bfe\\u7b56\\u306e\\u30b5\\u30ed\\u30f3\\u3092\\u958b\\u696d\\u4e88\\u5b9a\"}]}','2026-04-14 10:15:29','2026-04-14 10:15:29','2026-04-14 10:15:29'),
(10,9,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[],\"notes\":null}]}','2026-04-21 10:04:28','2026-04-21 10:04:28','2026-04-21 10:04:28'),
(11,9,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[11,39,27],\"notes\":\"\\u5c71\\u672c\\u3055\\u3093\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\n\\n\\u51fa\\u5149\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u30ab\\u30fc\\u30c9\\uff08\\u30b3\\u30b9\\u30d1\\u6700\\u5f37\\uff09\\n\\u30dd\\u30a4\\u30f3\\u30c8\\u9084\\u5143\\u7387(0.8%\\uff09\\u30fb\\u5e74\\u4f1a\\u8cbb\\uff082\\u4e072\\u5343\\u5186\\uff09\\u30fb\\u30b5\\u30fc\\u30d3\\u30b9\\n\\u5e74\\u4f1a\\u8cbb\\u512a\\u9047\\u30b5\\u30fc\\u30d3\\u30b9\\uff08300\\u4e07\\u4f7f\\u7528\\u3067\\u7fcc\\u5e74\\u5e74\\u4f1a\\u8cbb\\u7121\\u6599\\uff09\\n\\u30ac\\u30bd\\u30ea\\u30f3\\u5024\\u5f15\\u304d\"},{\"room_label\":\"BO2\",\"member_ids\":[11,39,27],\"notes\":null}]}','2026-04-21 10:08:29','2026-04-21 10:08:29','2026-04-21 10:08:29'),
(12,9,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[11,39,27],\"notes\":\"\\u5c71\\u672c\\u3055\\u3093\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\n\\n\\u51fa\\u5149\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u30ab\\u30fc\\u30c9\\uff08\\u30b3\\u30b9\\u30d1\\u6700\\u5f37\\uff09\\n\\u30dd\\u30a4\\u30f3\\u30c8\\u9084\\u5143\\u7387(0.8%\\uff09\\u30fb\\u5e74\\u4f1a\\u8cbb\\uff082\\u4e072\\u5343\\u5186\\uff09\\u30fb\\u30b5\\u30fc\\u30d3\\u30b9\\n\\u5e74\\u4f1a\\u8cbb\\u512a\\u9047\\u30b5\\u30fc\\u30d3\\u30b9\\uff08300\\u4e07\\u4f7f\\u7528\\u3067\\u7fcc\\u5e74\\u5e74\\u4f1a\\u8cbb\\u7121\\u6599\\uff09\\n\\u30ac\\u30bd\\u30ea\\u30f3\\u5024\\u5f15\\u304d\"},{\"room_label\":\"BO2\",\"member_ids\":[11,39,27,83],\"notes\":null}]}','2026-04-21 10:09:54','2026-04-21 10:09:54','2026-04-21 10:09:54'),
(13,9,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[11,39,27],\"notes\":\"\\u5c71\\u672c\\u3055\\u3093\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\n\\n\\u51fa\\u5149\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u30ab\\u30fc\\u30c9\\uff08\\u30b3\\u30b9\\u30d1\\u6700\\u5f37\\uff09\\n\\u30dd\\u30a4\\u30f3\\u30c8\\u9084\\u5143\\u7387(0.8%\\uff09\\u30fb\\u5e74\\u4f1a\\u8cbb\\uff082\\u4e072\\u5343\\u5186\\uff09\\u30fb\\u30b5\\u30fc\\u30d3\\u30b9\\n\\u5e74\\u4f1a\\u8cbb\\u512a\\u9047\\u30b5\\u30fc\\u30d3\\u30b9\\uff08300\\u4e07\\u4f7f\\u7528\\u3067\\u7fcc\\u5e74\\u5e74\\u4f1a\\u8cbb\\u7121\\u6599\\uff09\\n\\u30ac\\u30bd\\u30ea\\u30f3\\u5024\\u5f15\\u304d\"},{\"room_label\":\"BO2\",\"member_ids\":[11,39,27,83],\"notes\":\"\\u5c0f\\u68ee\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\u30d3\\u30b8\\u30c8\\u30ea\\u3001\\u51fa\\u5f35\\u65c5\\u8cbb\\u898f\\u5b9a\\u3092\\u4f7f\\u3063\\u305f\\u30b5\\u30fc\\u30d3\\u30b9\\n\\u4f1a\\u793e\\u304b\\u3089\\u4e00\\u6b69\\u3067\\u3082\\u51fa\\u305f\\u3089\\u51fa\\u5f35\\u6271\\u3044\\n\\u51fa\\u5f35\\u65c5\\u8cbb\\u898f\\u5b9a\\u306b\\n\\u7d4c\\u55b6\\u8005\\u3055\\u3093\\u306e\\u624b\\u5143\\u306b\\u304a\\u91d1\\u3092\\u6b8b\\u3059\\n\\n\\u793e\\u4f1a\\u4fdd\\u967a\\u3092\\u5727\\u7e2e\\u3057\\u3066\\u304a\\u91d1\\u3092\\u6b8b\\u3059\\n\\u57fa\\u672c\\u6599\\u91d12\\u4e07\\/\\u6708\\uff08\\u7a0e\\u7406\\u58eb\\u4ed8\\u304d\\u30d7\\u30e9\\u30f3\\u306f\\u30d7\\u30e9\\u30b9\\uff11\\u4e07\\uff09\"}]}','2026-04-21 10:16:22','2026-04-21 10:16:22','2026-04-21 10:16:22'),
(14,10,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,41,12,53,94],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[2,41,12,53,94],\"notes\":null}]}','2026-05-12 09:29:16','2026-05-12 09:29:16','2026-05-12 09:29:16'),
(15,10,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,41,12,53,94],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[2,41,12,53,89],\"notes\":null}]}','2026-05-12 10:00:33','2026-05-12 10:00:33','2026-05-12 10:00:33'),
(16,10,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,41,12,53,94],\"notes\":\"\\u7530\\u8fba\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\t\\u6cd5\\u4eba\\u643a\\u5e2f\"},{\"room_label\":\"BO2\",\"member_ids\":[2,41,12,53,89],\"notes\":null}]}','2026-05-12 10:09:10','2026-05-12 10:09:10','2026-05-12 10:09:10'),
(17,10,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,41,12,53,94],\"notes\":\"\\u7530\\u8fba\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\t\\u6cd5\\u4eba\\u643a\\u5e2f\"},{\"room_label\":\"BO2\",\"member_ids\":[2,41,12,53,89],\"notes\":\"\\u9db4\\u5ca1\\u3055\\u3093\\n\\u30b3\\u30fc\\u30c0\\u30fc\\u3055\\u3093\\n\\u30c7\\u30b6\\u30a4\\u30ca\\u30fc\\u3055\\u3093\\u3068\\u7e4b\\u304c\\u308a\\u305f\\u3044\"}]}','2026-05-12 10:14:28','2026-05-12 10:14:28','2026-05-12 10:14:28'),
(18,10,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,41,12,53,94,37],\"notes\":\"\\u7530\\u8fba\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\t\\u6cd5\\u4eba\\u643a\\u5e2f\"},{\"room_label\":\"BO2\",\"member_ids\":[2,41,12,53,89,37],\"notes\":\"\\u9db4\\u5ca1\\u3055\\u3093\\n\\u30b3\\u30fc\\u30c0\\u30fc\\u3055\\u3093\\n\\u30c7\\u30b6\\u30a4\\u30ca\\u30fc\\u3055\\u3093\\u3068\\u7e4b\\u304c\\u308a\\u305f\\u3044\"}]}','2026-05-18 09:01:06','2026-05-18 09:01:06','2026-05-18 09:01:06'),
(19,9,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[11,39,27,37],\"notes\":\"\\u5c71\\u672c\\u3055\\u3093\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\n\\n\\u51fa\\u5149\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u30ab\\u30fc\\u30c9\\uff08\\u30b3\\u30b9\\u30d1\\u6700\\u5f37\\uff09\\n\\u30dd\\u30a4\\u30f3\\u30c8\\u9084\\u5143\\u7387(0.8%\\uff09\\u30fb\\u5e74\\u4f1a\\u8cbb\\uff082\\u4e072\\u5343\\u5186\\uff09\\u30fb\\u30b5\\u30fc\\u30d3\\u30b9\\n\\u5e74\\u4f1a\\u8cbb\\u512a\\u9047\\u30b5\\u30fc\\u30d3\\u30b9\\uff08300\\u4e07\\u4f7f\\u7528\\u3067\\u7fcc\\u5e74\\u5e74\\u4f1a\\u8cbb\\u7121\\u6599\\uff09\\n\\u30ac\\u30bd\\u30ea\\u30f3\\u5024\\u5f15\\u304d\"},{\"room_label\":\"BO2\",\"member_ids\":[11,39,27,83,37],\"notes\":\"\\u5c0f\\u68ee\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\u30d3\\u30b8\\u30c8\\u30ea\\u3001\\u51fa\\u5f35\\u65c5\\u8cbb\\u898f\\u5b9a\\u3092\\u4f7f\\u3063\\u305f\\u30b5\\u30fc\\u30d3\\u30b9\\n\\u4f1a\\u793e\\u304b\\u3089\\u4e00\\u6b69\\u3067\\u3082\\u51fa\\u305f\\u3089\\u51fa\\u5f35\\u6271\\u3044\\n\\u51fa\\u5f35\\u65c5\\u8cbb\\u898f\\u5b9a\\u306b\\n\\u7d4c\\u55b6\\u8005\\u3055\\u3093\\u306e\\u624b\\u5143\\u306b\\u304a\\u91d1\\u3092\\u6b8b\\u3059\\n\\n\\u793e\\u4f1a\\u4fdd\\u967a\\u3092\\u5727\\u7e2e\\u3057\\u3066\\u304a\\u91d1\\u3092\\u6b8b\\u3059\\n\\u57fa\\u672c\\u6599\\u91d12\\u4e07\\/\\u6708\\uff08\\u7a0e\\u7406\\u58eb\\u4ed8\\u304d\\u30d7\\u30e9\\u30f3\\u306f\\u30d7\\u30e9\\u30b9\\uff11\\u4e07\\uff09\"}]}','2026-05-18 09:01:27','2026-05-18 09:01:27','2026-05-18 09:01:27'),
(20,8,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[41,12,56,37],\"notes\":\"\\u6e21\\u4e95\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\n\\u9759\\u5ca1\\u770c\\u5bcc\\u58eb\\u5bae\\u5e02\\n\\u81ea\\u5b85\\u30b5\\u30ed\\u30f3\\u3067\\u8033\\u30c4\\u30dc\\n\\u8033\\u306b\\u306f\\uff11\\uff11\\uff10\\u500b\\u30c4\\u30dc\\u304c\\u3042\\u308b\\n\\n\\u907a\\u4f1d\\u5b50\\u691c\\u67fb\\u30ad\\u30c3\\u30c8\\u306e\\u7d39\\u4ecb\\n\\u553e\\u6db2\\u9001\\u4ed8\\u2192\\u30b9\\u30de\\u30db\\u30a2\\u30d7\\u30ea\\u3067\\u75c5\\u6c17\\u306b\\u304b\\u304b\\u308a\\u3084\\u3059\\u3044\\u60c5\\u5831\\u306a\\u3069\\u78ba\\u8a8d\\u3067\\u304d\\u308b\\n\\u4e88\\u9632\\u7b56\\u306a\\u3069\\u3092\\u63d0\\u6848\\u3057\\u3066\\u304f\\u308c\\u308b\\n\\u3000\\u91d1\\u984d\\u219229,800\\u5186\"},{\"room_label\":\"BO2\",\"member_ids\":[41,12,37],\"notes\":\"\\u96c5\\u3055\\u3093\\u306e\\u65b0\\u898f\\u4e8b\\u696d\\u306b\\u95a2\\u3057\\u3066\\n\\u7537\\u6027\\u306eAGA\\u5bfe\\u7b56\\u306e\\u30b5\\u30ed\\u30f3\\u3092\\u958b\\u696d\\u4e88\\u5b9a\"}]}','2026-05-18 09:01:58','2026-05-18 09:01:58','2026-05-18 09:01:58'),
(21,7,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[12,71,37],\"notes\":\"\\u6fa4\\u91ce\\u3055\\u3093PR\\n\\n\\u30d5\\u30ea\\u30fc\\u30e9\\u30f3\\u30b9\\u3067\\u6d3b\\u52d5\\n\\u770c\\u5185\\u5916\\u3000\\u6771\\u4eac\\u3068\\u9759\\u5ca1\\u306e\\u5e83\\u544a\\u4ee3\\u7406\\u5e97\\u304b\\u3089\\u306e\\u4f9d\\u983c\\nWeb\\u4ee5\\u5916\\u5bfe\\u5fdc\\u53ef\\u80fd\\n\\u30b0\\u30e9\\u30d5\\u30a3\\u30c3\\u30af\\u30c7\\u30b6\\u30a4\\u30f3\\u5168\\u822c\\n\\u7d19\\u5a92\\u4f53\\u5c02\\u9580\\n\\u30d0\\u30ca\\u30fc\\u306a\\u3069\\u30d1\\u30fc\\u30c4\\u306f\\u5bfe\\u5fdc\\u53ef\\u80fd\"},{\"room_label\":\"BO2\",\"member_ids\":[12,55,37],\"notes\":\"\\u30a8\\u30b9\\u30c6\\u30c6\\u30a3\\u30b7\\u30e3\\u30f3\\u3068\\u3057\\u3066\\u3082\\u6d3b\\u52d5\\n\\u4eca\\u5f8c\\u306f\\u30a8\\u30b9\\u30c6\\u3067\\u958b\\u696d\\u3057\\u305f\\u3044\\n\\n\\u795e\\u5948\\u5ddd\\u5728\\u4f4f\\n\\u95a2\\u6771\\u570f\\u3067\\u958b\\u696d\\u4e88\\u5b9a\\n\\n\\u7e4b\\u304c\\u308a\\u305f\\u3044\\u696d\\u7a2e\\n\\u30ec\\u30f3\\u30bf\\u30eb\\u30b9\\u30da\\u30fc\\u30b9\\u4e8b\\u696d\\n\\u5b9f\\u5e97\\u8217\\u3092\\u6301\\u3063\\u305f\\u30aa\\u30fc\\u30ca\\u30fc\\u306e\\u30c1\\u30e9\\u30b7\\u3001\\u30d1\\u30f3\\u30d5\\u30ec\\u30c3\\u30c8\\u4f5c\\u6210\\u5bfe\\u5fdc\\u53ef\\u80fd\"}]}','2026-05-18 09:02:15','2026-05-18 09:02:15','2026-05-18 09:02:15'),
(22,6,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[32,42,30,37],\"notes\":\"\\u4f50\\u4e45\\u9593\\u3055\\u3093\\u306e\\u8a08\\u3089\\u3044\\u3067\\u81ea\\u5df1\\u7d39\\u4ecb\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\u3001\\u8cea\\u7591\\u5fdc\\u7b54\\n\\u4f50\\u4e45\\u9593\\u3055\\u3093\\u304b\\u3089\\u306f\\u5de5\\u7a0b\\u7ba1\\u7406\\u3060\\u3063\\u305f\\u308a\\u305d\\u3046\\u3044\\u3046\\u3053\\u3068\\u306b\\u3082\\u5bfe\\u5fdc\\u3067\\u304d\\u308b\\u306e\\u304b\\u3068\\u554f\\u3044\\u5408\\u308f\\u305b\\u304c\\u3042\\u3063\\u305f\"},{\"room_label\":\"BO2\",\"member_ids\":[32,42,30,66,37],\"notes\":\"\\u30d3\\u30b8\\u30bf\\u30fc\\u7c73\\u6fa4\\u3055\\u3093\\n\\nWeb\\u30c7\\u30b6\\u30a4\\u30f3\\u306e\\u8b1b\\u5e2b\\u7d4c\\u9a13\\u3042\\u308a\\u2028\\u30b5\\u30fc\\u30d3\\u30b9\\u696d\\u7cfb\\u306eLP\\u306a\\u3069\\u5f37\\u3044\\n\\n\\u30b3\\u30ed\\u30ca\\u3092\\u304d\\u3063\\u304b\\u3051\\u306b\\u30d1\\u30c6\\u30a3\\u30b7\\u30a83\\u5e74\\u3092\\u52d9\\u3081\\u3066Web\\u30c7\\u30b6\\u30a4\\u30ca\\u3068\\u3057\\u3066\\n\\u884c\\u52d5\\u5fc3\\u7406\\u304b\\u3089\\u30c7\\u30b6\\u30a4\\u30f3\\u3092\\u8ffd\\u6c42\"}]}','2026-05-18 09:02:45','2026-05-18 09:02:45','2026-05-18 09:02:45'),
(23,4,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[52,26,2,14,19,37],\"notes\":\"\\u98ef\\u7530\\u3055\\u3093\\u306e\\u8a08\\u3089\\u3044\\u3067\\u79c1\\u306e\\u30d3\\u30b8\\u30cd\\u30b9\\u7d39\\u4ecb\\u3092\\u3055\\u305b\\u3066\\u3082\\u3089\\u3063\\u305f\"},{\"room_label\":\"BO2\",\"member_ids\":[52,26,2,14,19,55,37],\"notes\":\"\\u5c0f\\u91ce\\u5bfa\\u3055\\u3093\\u306e\\u7d39\\u4ecb\\n\\u795e\\u5948\\u5ddd\\u770c\\u306e\\u4e0d\\u52d5\\u7523\\u696d\\uff08\\u58f2\\u8cb7\\u30fb\\u8cc3\\u8cb8\\uff09\\n\\u98f2\\u98df\\u4ee5\\u5916\\u306e\\u5e97\\u8217\\n\\u4e00\\u90fd\\u4e09\\u770c\\u3001\\u95a2\\u897f\\n\\u30fb\\u672a\\u516c\\u958b\\u7269\\u4ef6\\n\\u30fb\\u5e97\\u8217\\u304cNG\\u7269\\u4ef6\\u306b\\u3082\\u5bfe\\u5fdc\\u53ef\\u80fd\\n\\u30fb\\u30d5\\u30e9\\u30f3\\u30c1\\u30e3\\u30a4\\u30ba\\u672c\\u90e8\\u3067\\u306e\\u62c5\\u5f53\\u5bfe\\u5fdc\\u304c\\u3067\\u304d\\u308b\"}]}','2026-05-18 09:03:07','2026-05-18 09:03:07','2026-05-18 09:03:07'),
(24,3,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[41,49,74,37],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[41,49,73,37],\"notes\":null}]}','2026-05-18 09:03:26','2026-05-18 09:03:26','2026-05-18 09:03:26'),
(25,2,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[5,8,37],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[5,8,37],\"notes\":null}]}','2026-05-18 09:03:41','2026-05-18 09:03:41','2026-05-18 09:03:41'),
(26,1,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[12,31,10,17,37],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[37,29,9],\"notes\":null}]}','2026-05-18 09:03:53','2026-05-18 09:03:53','2026-05-18 09:03:53'),
(27,11,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,37,117],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[2,37,108],\"notes\":null}]}','2026-05-19 09:00:22','2026-05-19 09:00:22','2026-05-19 09:00:22'),
(28,11,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[2,37,117],\"notes\":\"\\u5c71\\u672c\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u696d\\u52d9\\u52b9\\u7387\\u5316\\uff1a\\n\\u3000GoogleWorkspace\\u3092\\u5229\\u7528\\u3057\\u3066\\u696d\\u52d9\\u52b9\\u7387\\u5316\\u3092\\u30b5\\u30dd\\u30fc\\u30c8\\u3059\\u308b\\n\\u3000GAS\\u3092\\u5229\\u7528\\u3057\\u3066\\u4e00\\u9023\\u306e\\u6d41\\u308c\\u3092\\u3064\\u304f\\u308b\"},{\"room_label\":\"BO2\",\"member_ids\":[2,37,108],\"notes\":\"\\u798f\\u7530\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30aa\\u30f3\\u30e9\\u30a4\\u30f3\\u5bb6\\u5ead\\u6559\\u5e2b\\n\\u3000\\u6559\\u6750\\u4f5c\\u6210\\u306b\\u529b\\u3092\\u5165\\u308c\\u3066\\u3044\\u308b\\n\\u3000\\u696d\\u8005\\u304c\\u4f5c\\u308b\\u6559\\u6750\\u3067\\u306f\\u306a\\u304f\\u3066\\u81ea\\u5206\\u306e\\u6559\\u3048\\u65b9\\u306b\\u30de\\u30c3\\u30c1\\u3057\\u305f\\u6559\\u6750\\u3092\\u4f5c\\u6210\\u3059\\u308b\\u3053\\u3068\\u304c\\u53ef\\u80fd\\n\\u3000\\u5370\\u5237\\u4f1a\\u793e\\u3055\\u3093\\u3068\\u306e\\u5354\\u696d\\u3092\\u6c42\\u3081\\u3066\\u53c2\\u52a0\\u3057\\u305f\"}]}','2026-05-19 10:22:35','2026-05-19 10:22:35','2026-05-19 10:22:35'),
(29,12,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[18,28,37,5,14,128],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[],\"notes\":null}]}','2026-05-26 10:42:31','2026-05-26 10:42:31','2026-05-26 10:42:31'),
(30,12,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[18,28,37,5,14,128],\"notes\":\"\\u77f3\\u539f\\u6c0f\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\"},{\"room_label\":\"BO2\",\"member_ids\":[18,28,37,5,14,133],\"notes\":\"\\u4f50\\u85e4\\u6c0f\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\"}]}','2026-05-26 10:43:19','2026-05-26 10:43:19','2026-05-26 10:43:19'),
(31,13,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[24,29,37,22,159],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[24,29,37,22,153],\"notes\":null}]}','2026-06-02 09:09:43','2026-06-02 09:09:43','2026-06-02 09:09:43'),
(32,13,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[24,29,37,22,159],\"notes\":\"\\u6e9d\\u6e15\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30d5\\u30a3\\u30b8\\u30fc\\u30af\\u3082\\u3084\\u3089\\u308c\\u3066\\u3044\\u308b\"},{\"room_label\":\"BO2\",\"member_ids\":[24,29,37,22,153],\"notes\":null}]}','2026-06-02 10:10:10','2026-06-02 10:10:10','2026-06-02 10:10:10'),
(33,13,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[24,29,37,22,159],\"notes\":\"\\u6e9d\\u6e15\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30d5\\u30a3\\u30b8\\u30fc\\u30af\\u3082\\u3084\\u3089\\u308c\\u3066\\u3044\\u308b\"},{\"room_label\":\"BO2\",\"member_ids\":[24,29,37,22,153],\"notes\":\"\\u6797\\u7530\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30af\\u30fc\\u30dd\\u30f3\\u7cfb\\u306e\\u798f\\u5229\\u539a\\u751f\\n\\u65e5\\u5e38\\u4f7f\\u3044\\u306e\\u30af\\u30fc\\u30dd\\u30f3\\u63b2\\u8f09(10%\\u30aa\\u30d5\\uff09\"}]}','2026-06-02 10:11:02','2026-06-02 10:11:02','2026-06-02 10:11:02'),
(34,13,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[24,29,37,22,159],\"notes\":\"\\u6e9d\\u6e15\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30d5\\u30a3\\u30b8\\u30fc\\u30af\\u3082\\u3084\\u3089\\u308c\\u3066\\u3044\\u308b\"},{\"room_label\":\"BO2\",\"member_ids\":[24,29,37,22,153],\"notes\":\"\\u6797\\u7530\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30af\\u30fc\\u30dd\\u30f3\\u7cfb\\u306e\\u798f\\u5229\\u539a\\u751f\\n\\u65e5\\u5e38\\u4f7f\\u3044\\u306e\\u30af\\u30fc\\u30dd\\u30f3\\u63b2\\u8f09(10%\\u30aa\\u30d5\\uff09\\n\\u6c34\\u9053\\u4ee3\\u306e\\uff11\\uff15\\u5e74\\u306e\\u524a\\u6e1b\\u304c\\u53ef\\u80fd\\uff08\\u4e95\\u6238\\u3092\\u6398\\u308b\\uff09\"}]}','2026-06-02 10:15:08','2026-06-02 10:15:08','2026-06-02 10:15:08');
/*!40000 ALTER TABLE `bo_assignment_audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `breakout_memos`
--

DROP TABLE IF EXISTS `breakout_memos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breakout_memos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `participant_id` bigint(20) unsigned NOT NULL,
  `target_participant_id` bigint(20) unsigned NOT NULL,
  `breakout_room_id` bigint(20) unsigned DEFAULT NULL,
  `body` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breakout_memos_meeting_author_target_unique` (`meeting_id`,`participant_id`,`target_participant_id`),
  KEY `breakout_memos_participant_id_foreign` (`participant_id`),
  KEY `breakout_memos_meeting_id_participant_id_index` (`meeting_id`,`participant_id`),
  KEY `breakout_memos_target_participant_id_index` (`target_participant_id`),
  KEY `breakout_memos_breakout_room_id_index` (`breakout_room_id`),
  CONSTRAINT `breakout_memos_breakout_room_id_foreign` FOREIGN KEY (`breakout_room_id`) REFERENCES `breakout_rooms` (`id`) ON DELETE SET NULL,
  CONSTRAINT `breakout_memos_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `breakout_memos_participant_id_foreign` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE,
  CONSTRAINT `breakout_memos_target_participant_id_foreign` FOREIGN KEY (`target_participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `breakout_memos`
--

LOCK TABLES `breakout_memos` WRITE;
/*!40000 ALTER TABLE `breakout_memos` DISABLE KEYS */;
INSERT INTO `breakout_memos` VALUES
(1,1,1,2,NULL,'名刺交換済み。次回1to1提案。','2026-03-03 00:34:37','2026-03-03 00:34:37');
/*!40000 ALTER TABLE `breakout_memos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `breakout_rooms`
--

DROP TABLE IF EXISTS `breakout_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `breakout_rooms` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `room_label` varchar(50) NOT NULL,
  `sort_order` tinyint(3) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `breakout_rooms_meeting_id_room_label_unique` (`meeting_id`,`room_label`),
  KEY `breakout_rooms_meeting_id_index` (`meeting_id`),
  KEY `breakout_rooms_sort_order_index` (`sort_order`),
  CONSTRAINT `breakout_rooms_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `breakout_rooms`
--

LOCK TABLES `breakout_rooms` WRITE;
/*!40000 ALTER TABLE `breakout_rooms` DISABLE KEYS */;
INSERT INTO `breakout_rooms` VALUES
(6,1,'BO1',1,NULL,'2026-03-05 14:01:27','2026-03-05 14:01:27'),
(7,1,'BO2',2,NULL,'2026-03-05 14:01:27','2026-03-05 14:01:27'),
(18,2,'BO1',1,NULL,'2026-03-10 22:41:28','2026-03-10 22:41:28'),
(19,2,'BO2',1,NULL,'2026-03-10 22:41:28','2026-03-10 22:41:28'),
(20,3,'BO1',1,NULL,'2026-03-17 00:29:27','2026-03-17 00:29:27'),
(21,3,'BO2',1,NULL,'2026-03-17 00:29:27','2026-03-17 00:29:27'),
(22,4,'BO1',1,'飯田さんの計らいで私のビジネス紹介をさせてもらった','2026-03-24 00:52:49','2026-03-24 01:11:16'),
(23,4,'BO2',1,'小野寺さんの紹介\n神奈川県の不動産業（売買・賃貸）\n飲食以外の店舗\n一都三県、関西\n・未公開物件\n・店舗がNG物件にも対応可能\n・フランチャイズ本部での担当対応ができる','2026-03-24 00:52:49','2026-03-24 01:19:05'),
(24,6,'BO1',1,'佐久間さんの計らいで自己紹介ビジネス紹介、質疑応答\n佐久間さんからは工程管理だったりそういうことにも対応できるのかと問い合わせがあった','2026-03-31 00:12:15','2026-03-31 01:11:56'),
(25,6,'BO2',1,'ビジター米澤さん\n\nWebデザインの講師経験あり サービス業系のLPなど強い\n\nコロナをきっかけにパティシエ3年を務めてWebデザイナとして\n行動心理からデザインを追求','2026-03-31 00:12:15','2026-03-31 01:18:35'),
(26,7,'BO1',1,'澤野さんPR\n\nフリーランスで活動\n県内外　東京と静岡の広告代理店からの依頼\nWeb以外対応可能\nグラフィックデザイン全般\n紙媒体専門\nバナーなどパーツは対応可能','2026-04-07 01:16:39','2026-04-07 01:16:39'),
(27,7,'BO2',1,'エステティシャンとしても活動\n今後はエステで開業したい\n\n神奈川在住\n関東圏で開業予定\n\n繋がりたい業種\nレンタルスペース事業\n実店舗を持ったオーナーのチラシ、パンフレット作成対応可能','2026-04-07 01:16:39','2026-04-07 01:16:39'),
(28,8,'BO1',1,'渡井さんの紹介\n\n静岡県富士宮市\n自宅サロンで耳ツボ\n耳には１１０個ツボがある\n\n遺伝子検査キットの紹介\n唾液送付→スマホアプリで病気にかかりやすい情報など確認できる\n予防策などを提案してくれる\n　金額→29,800円','2026-04-14 10:11:02','2026-04-14 10:11:02'),
(29,8,'BO2',1,'雅さんの新規事業に関して\n男性のAGA対策のサロンを開業予定','2026-04-14 10:11:02','2026-04-14 10:15:29'),
(30,9,'BO1',1,'山本さんのビジネス紹介\n\n出光のビジネスカード（コスパ最強）\nポイント還元率(0.8%）・年会費（2万2千円）・サービス\n年会費優遇サービス（300万使用で翌年年会費無料）\nガソリン値引き','2026-04-21 10:04:28','2026-04-21 10:08:29'),
(31,9,'BO2',1,'小森さんの紹介\nビジトリ、出張旅費規定を使ったサービス\n会社から一歩でも出たら出張扱い\n出張旅費規定に\n経営者さんの手元にお金を残す\n\n社会保険を圧縮してお金を残す\n基本料金2万/月（税理士付きプランはプラス１万）','2026-04-21 10:04:28','2026-04-21 10:16:22'),
(32,10,'BO1',1,'田辺さんの事業紹介\n	法人携帯','2026-05-12 09:29:16','2026-05-12 10:09:10'),
(33,10,'BO2',1,'鶴岡さん\nコーダーさん\nデザイナーさんと繋がりたい','2026-05-12 09:29:16','2026-05-12 10:14:28'),
(34,11,'BO1',1,'山本さんの事業紹介\n業務効率化：\n　GoogleWorkspaceを利用して業務効率化をサポートする\n　GASを利用して一連の流れをつくる','2026-05-19 09:00:22','2026-05-19 10:22:35'),
(35,11,'BO2',1,'福田さんの事業紹介\nオンライン家庭教師\n　教材作成に力を入れている\n　業者が作る教材ではなくて自分の教え方にマッチした教材を作成することが可能\n　印刷会社さんとの協業を求めて参加した','2026-05-19 09:00:22','2026-05-19 10:22:35'),
(36,12,'BO1',1,'石原氏の事業紹介','2026-05-26 10:42:31','2026-05-26 10:43:19'),
(37,12,'BO2',1,'佐藤氏の事業紹介','2026-05-26 10:42:31','2026-05-26 10:43:19'),
(38,13,'BO1',1,'溝渕さんの事業紹介\nフィジークもやられている','2026-06-02 09:09:43','2026-06-02 10:10:10'),
(39,13,'BO2',1,'林田さんの事業紹介\nクーポン系の福利厚生\n日常使いのクーポン掲載(10%オフ）\n水道代の１５年の削減が可能（井戸を掘る）','2026-06-02 09:09:43','2026-06-02 10:15:07');
/*!40000 ALTER TABLE `breakout_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) NOT NULL COMMENT '大カテゴリー',
  `name` varchar(255) NOT NULL COMMENT '実カテゴリー',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES
(1,'建設・不動産','建設・不動産','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(2,'中小企業サポート','中小企業サポート','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(3,'ライフサポート','ライフサポート','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(4,'金融・保険・資金サポート','金融・保険・資金サポート','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(5,'士業・コンサル','士業・コンサル','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(6,'ＩＴ','ＩＴ','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(7,'食品・製造','食品・製造','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(8,'ファッション・デザイン','ファッション・デザイン','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(9,'美容・健康・生活','美容・健康・生活','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(10,'（リージョン）','（リージョン）','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(11,'塗装・防水','塗装・防水','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(12,'SNS×地域イベント事業','SNS×地域イベント事業','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(13,'システムエンジニア','システムエンジニア','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(14,'BPO(事務代行)','BPO(事務代行)','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(15,'リゾート会員権販売','リゾート会員権販売','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(16,'美容・健康専門マーケティング','美容・健康専門マーケティング','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(17,'ライブ配信','ライブ配信','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(18,'鉄コンドクター','鉄コンドクター','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(19,'ビジュアルブランディング撮影','ビジュアルブランディング撮影','2026-03-05 01:47:04','2026-03-05 01:47:04'),
(20,'SmokeTest','Phase16C-edited','2026-03-05 08:13:50','2026-03-05 08:14:06'),
(21,'建設・不動産','大型物件対応解体工事','2026-03-10 00:40:13','2026-03-10 00:40:13'),
(22,'建設・不動産','害虫ブロック','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(23,'建設・不動産','空き家不動産','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(24,'建設・不動産','断熱フィルム','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(25,'建設・不動産','小屋販売','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(26,'建設・不動産','ファインバブル','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(27,'建設・不動産','足場部材','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(28,'中小企業サポート','海外物流','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(29,'中小企業サポート','出張手配旅行','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(30,'中小企業サポート','中国物販','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(31,'中小企業サポート','プレゼン資料','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(32,'中小企業サポート','SNS集客','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(33,'中小企業サポート','地域情報サイト','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(34,'中小企業サポート','技能実習生','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(35,'中小企業サポート','オンライン講座','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(36,'中小企業サポート','ブランディング映像','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(37,'中小企業サポート','建設採用コンサル','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(38,'ライフサポート','シングルマザー事業','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(39,'ライフサポート','不用品回収','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(40,'ライフサポート','結婚相談所','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(41,'ライフサポート','着物買取','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(42,'ライフサポート','福利厚生','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(43,'ライフサポート','中古スマホ','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(44,'金融・保険・資金サポート','企業型DC','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(45,'金融・保険・資金サポート','建設損保','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(46,'金融・保険・資金サポート','生命保険','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(47,'士業・コンサル','脱炭素経営','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(48,'士業・コンサル','税理士','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(49,'士業・コンサル','マーケティング','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(50,'士業・コンサル','行政書士','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(51,'士業・コンサル','社労士','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(52,'IT','Webマーケ','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(53,'IT','AIツール','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(54,'IT','WEB制作','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(55,'IT','LINE運用','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(56,'食品・製造','漆食器','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(57,'食品・製造','パッケージ','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(58,'食品・製造','和スイーツOEM','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(59,'食品・製造','集客アプリ','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(60,'食品・製造','金属製品','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(61,'食品・製造','石材','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(62,'ファッション・デザイン','Tシャツ','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(63,'ファッション・デザイン','革靴','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(64,'ファッション・デザイン','ネクタイ','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(65,'ファッション・デザイン','播州織日傘','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(66,'美容・健康・生活','ダイエット','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(67,'美容・健康・生活','まつ毛美容液','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(68,'美容・健康・生活','眼の整体','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(69,'美容・健康・生活','開運占い','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(70,'美容・健康・生活','スタイルアドバイザー','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(71,'BNI','ディレクター','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(72,'BNI','エリアディレクター','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(73,'BNI','エグゼクティブディレクター','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(74,'IT・Web','IT・Web','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(75,'NETIS申請','NETIS申請','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(76,'生命保険','生命保険','2026-03-10 00:40:14','2026-03-10 00:40:14'),
(77,'建設・不動産','虫が建物に近寄らない害虫ブロック','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(78,'建設・不動産','空き家問題を解決する不動産屋','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(79,'建設・不動産','エアロゲル透明断熱フィルム','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(80,'建設・不動産','自宅で開業にちょうどいい小屋','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(81,'建設・不動産','ファインバブル（住宅設備機器）販売','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(82,'建設・不動産','足場部材販売','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(83,'中小企業サポート','日本企業からの海外専門安心物流','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(84,'中小企業サポート','出張手配専門旅行会社','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(85,'中小企業サポート','中国向け物販支援','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(86,'中小企業サポート','勝てるプレゼン資料作成','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(87,'中小企業サポート','外構工事特化型SNS集客','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(88,'中小企業サポート','地域情報サイト運営','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(89,'中小企業サポート','外国人技能実習生支援団体','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(90,'中小企業サポート','事業のオンライン展開サポート','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(91,'中小企業サポート','ブランディング映像クリエイター','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(92,'中小企業サポート','建設業向け高校生新卒採用コンサル','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(93,'ライフサポート','シングルマザー専門事業コンシェルジュ','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(94,'ライフサポート','ごみ屋敷の片づけ＆不用品回収','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(95,'ライフサポート','着物に強い出張買取','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(96,'ライフサポート','家族も使える福利厚生','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(97,'ライフサポート','中古スマホ買取販売','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(98,'金融・保険・資金サポート','企業型確定拠出年金導入サポート','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(99,'金融・保険・資金サポート','建設業特化型損害保険','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(100,'金融・保険・資金サポート','アスリート専門生命保険','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(101,'士業・コンサル','ゲームで学べる脱炭素経営','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(102,'士業・コンサル','建設業専門税理士事務所','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(103,'士業・コンサル','ブランド戦略プランナー','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(104,'士業・コンサル','相続・遺言特化型行政書士','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(105,'士業・コンサル','社労士（スタートアップ企業）','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(106,'士業・コンサル','建設業専門行政書士','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(107,'ＩＴ','売上を伸ばすWebマーケティング','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(108,'ＩＴ','使って学ぶAIツールの情報発信','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(109,'ＩＴ','デザインに強いWEB制作','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(110,'ＩＴ','LINE公式アカウント運用代行','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(111,'食品・製造','抗菌効果の強い漆塗りの食器販売','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(112,'食品・製造','顧客ニーズを超えるパッケージ制作','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(113,'食品・製造','和スイーツのＯＥＭ製造','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(114,'食品・製造','飲食店向け集客アプリ','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(115,'食品・製造','砂で造る高機能金属製品','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(116,'食品・製造','高級石材の採掘・供給','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(117,'ファッション・デザイン','Tシャツプリント','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(118,'ファッション・デザイン','オーダーメイド革靴の製造販売','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(119,'ファッション・デザイン','町工場の職人が作るネクタイ','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(120,'ファッション・デザイン','播州織の日傘製造','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(121,'美容・健康・生活','身体と心を整えるダイエットコーチング','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(122,'美容・健康・生活','月1回で伸びるまつ毛美容液','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(123,'美容・健康・生活','眼の整体院','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(124,'美容・健康・生活','経営者向け開運占い師','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(125,'美容・健康・生活','30代からのスタイルアドバイザー','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(126,'BNI東京N.E.リージョン','ディレクターコンサルタント','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(127,'BNI東京N.E.リージョン','グロースエリアディレクター','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(128,'BNI東京N.E.リージョン','エグゼクティブディレクター','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(129,'toB向けビジネススクール','toB向けビジネススクール','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(130,'健康支援サービス','健康支援サービス','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(131,'ゲーム・ホビー・メディア専門買取','ゲーム・ホビー・メディア専門買取','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(132,'ニッチナンバーワンプロデューサー','ニッチナンバーワンプロデューサー','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(133,'高齢者向けアプリ','高齢者向けアプリ','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(134,'不動産管理　民泊','不動産管理　民泊','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(135,'古物商','古物商','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(136,'金融・クルーズ事業','金融・クルーズ事業','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(137,'ビューティービズサロン（コワーキングスペース＆レンタルサロン複合型施設FC本部）','ビューティービズサロン（コワーキングスペース＆レンタルサロン複合型施設FC本部）','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(138,'ビジネスカード','ビジネスカード','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(139,'屋根工事業','屋根工事業','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(140,'サステナビリティ×パーパス経営　研修','サステナビリティ×パーパス経営　研修','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(141,'伐採・草刈り','伐採・草刈り','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(142,'フェムケア','フェムケア','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(143,'珈琲豆の「食べる資源化」クラウドファンディング','珈琲豆の「食べる資源化」クラウドファンディング','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(144,'シングルマザー専門事業コンシェルジュ','シングルマザー専門事業コンシェルジュ','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(145,'エアロゲル透明断熱フィルム','エアロゲル透明断熱フィルム','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(146,'ファインバブル（住宅設備機器）販売','ファインバブル（住宅設備機器）販売','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(147,'応用脳科学を使った企業研修講師','応用脳科学を使った企業研修講師','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(148,'着物監修家/再生・オーダーディレクター','着物監修家/再生・オーダーディレクター','2026-03-16 23:42:37','2026-03-16 23:42:37'),
(149,'ＩＴ','AI業務改善システム構築','2026-03-23 12:34:34','2026-03-23 12:34:34'),
(150,'不動産','不動産','2026-03-23 12:34:34','2026-03-23 12:34:34'),
(151,'企業の販管費削減コンサルタント','企業の販管費削減コンサルタント','2026-03-23 12:34:34','2026-03-23 12:34:34'),
(152,'町工場の職人が作るネクタイ','町工場の職人が作るネクタイ','2026-03-23 12:34:34','2026-03-23 12:34:34'),
(153,'空家・行方不明専門司法書士','空家・行方不明専門司法書士','2026-03-23 12:34:34','2026-03-23 12:34:34'),
(154,'美容・健康・生活','若返り育毛ヘッドスパ','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(155,'生命保険会社が絶対にマネできない医療保険','生命保険会社が絶対にマネできない医療保険','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(156,'心と美容の専門家','心と美容の専門家','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(157,'建設業特化営業代行','建設業特化営業代行','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(158,'革靴・靴磨き','革靴・靴磨き','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(159,'業務用厨房機器メーカー','業務用厨房機器メーカー','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(160,'Webデザイナー','Webデザイナー','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(161,'建設業向け高校生新卒採用コンサル','建設業向け高校生新卒採用コンサル','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(162,'ゲームで学べる脱炭素経営','ゲームで学べる脱炭素経営','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(163,'温活サロンコンサル、カウンセラー','温活サロンコンサル、カウンセラー','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(164,'デジタルサイネージ販売代理店募集','デジタルサイネージ販売代理店募集','2026-03-31 00:09:20','2026-03-31 00:09:20'),
(165,'中小企業サポート','日本製ものづくり再興事業プロデューサー','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(166,'中小企業サポート','店舗・施設集客を高めるデジタルサイネージ','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(167,'チラシ作成・プレゼンスライド作成','チラシ作成・プレゼンスライド作成','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(168,'フォトグラファー','フォトグラファー','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(169,'一枚一枚削り出す福島のまな板職人','一枚一枚削り出す福島のまな板職人','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(170,'ブランディング×デザイン','ブランディング×デザイン','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(171,'地域創りプロデューサー','地域創りプロデューサー','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(172,'法人営業代行','法人営業代行','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(173,'税理士','税理士','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(174,'WEBデザイン・グラフィックデザイン','WEBデザイン・グラフィックデザイン','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(175,'事務代行','事務代行','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(176,'グラフィックデザイナー','グラフィックデザイナー','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(177,'飲食業','飲食業','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(178,'インテリア雑貨の製造、販売','インテリア雑貨の製造、販売','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(179,'チーズ製造機械メーカー　チーズ製造販売','チーズ製造機械メーカー　チーズ製造販売','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(180,'伝統工芸プロデューサー（営業代行、マーケティング）','伝統工芸プロデューサー（営業代行、マーケティング）','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(181,'建築全般、アート','建築全般、アート','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(182,'オリジナル時計制作','オリジナル時計制作','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(183,'美容化粧品販売・卸し','美容化粧品販売・卸し','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(184,'楽天市場特化コンサルティング','楽天市場特化コンサルティング','2026-04-07 00:04:59','2026-04-07 00:04:59'),
(185,'金融・保険・資金サポート','ビジネス特化型クレジットカード','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(186,'美容・健康・生活','温活機器導入サポート','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(187,'公認会計士・税理士','公認会計士・税理士','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(188,'リラクゼーションサロン（耳ツボ）','リラクゼーションサロン（耳ツボ）','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(189,'子どもの主体性を育てる出張型のパーソナル体育教室','子どもの主体性を育てる出張型のパーソナル体育教室','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(190,'占い師（カラットセラピー）','占い師（カラットセラピー）','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(191,'電話営業代行','電話営業代行','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(192,'カーボンクレジット（投資商品）','カーボンクレジット（投資商品）','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(193,'ママさん向け講師業','ママさん向け講師業','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(194,'EC事業の運営、商品企画','EC事業の運営、商品企画','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(195,'不動産、M&A、インフラ整備支援','不動産、M&A、インフラ整備支援','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(196,'人生ストーリー動画制作','人生ストーリー動画制作','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(197,'独立系ファイナンシャルプランナー','独立系ファイナンシャルプランナー','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(198,'動画制作全般','動画制作全般','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(199,'可能性開発支援事業','可能性開発支援事業','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(200,'30代からのスタイルアドバイザー','30代からのスタイルアドバイザー','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(201,'システム販売','システム販売','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(202,'MEOツール販売','MEOツール販売','2026-04-13 12:13:25','2026-04-13 12:13:25'),
(203,'SNS運用/動画編集スクール','SNS運用/動画編集スクール','2026-04-20 21:05:14','2026-04-20 21:05:14'),
(204,'コスト削減','コスト削減','2026-04-20 21:05:14','2026-04-20 21:05:14'),
(205,'株式投資コンサル','株式投資コンサル','2026-04-20 21:05:14','2026-04-20 21:05:14'),
(206,'自宅で開業にちょうどいい小屋','自宅で開業にちょうどいい小屋','2026-04-20 21:05:14','2026-04-20 21:05:14'),
(207,'LINE公式アカウント運用代行','LINE公式アカウント運用代行','2026-04-20 21:05:14','2026-04-20 21:05:14'),
(208,'士業・コンサル','Construction industry tax accountant office','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(209,'業務改善コンサルタント','業務改善コンサルタント','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(210,'WEB制作','WEB制作','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(211,'保険業','保険業','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(212,'体の再生業(断食・ファスティング )','体の再生業(断食・ファスティング )','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(213,'若者キャリアコンサル','若者キャリアコンサル','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(214,'中国向け物販支援','中国向け物販支援','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(215,'通信関係（法人携帯、インターネット、新電力）、SNS運用代行','通信関係（法人携帯、インターネット、新電力）、SNS運用代行','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(216,'ポスティング特化　広告代理店','ポスティング特化　広告代理店','2026-05-12 08:00:44','2026-05-12 08:00:44'),
(217,'食品・製造','ステーキハウス','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(218,'美容・健康・生活','サロン向け育毛機器・商材販売','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(219,'イタリアンジェラート製造 卸','イタリアンジェラート製造 卸','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(220,'インテリア、リフォーム、家具デザイン製作','インテリア、リフォーム、家具デザイン製作','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(221,'産業機器メンテナンス','産業機器メンテナンス','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(222,'中小企業診断士','中小企業診断士','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(223,'組織改革コーチング、社外CHRO','組織改革コーチング、社外CHRO','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(224,'マルシェ運営','マルシェ運営','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(225,'オンライン家庭教師','オンライン家庭教師','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(226,'電気代削減プラン提案','電気代削減プラン提案','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(227,'中古介護ベッド売買','中古介護ベッド売買','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(228,'コンサル','コンサル','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(229,'通信サービス・不動産','通信サービス・不動産','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(230,'化粧品','化粧品','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(231,'非破壊検査AIロボット','非破壊検査AIロボット','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(232,'総合防災設備業','総合防災設備業','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(233,'事務の効率化パートナー','事務の効率化パートナー','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(234,'損害保険','損害保険','2026-05-18 22:56:51','2026-05-18 22:56:51'),
(235,'女性客に強いWEB制作','女性客に強いWEB制作','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(236,'婚活サロン','婚活サロン','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(237,'キャッサバスイーツ','キャッサバスイーツ','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(238,'保険代理店','保険代理店','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(239,'石州瓦のやきもの制作','石州瓦のやきもの制作','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(240,'コンサルティング','コンサルティング','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(241,'肌着・婦人服・スポーツ衣料の縫製工場','肌着・婦人服・スポーツ衣料の縫製工場','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(242,'通信費削減','通信費削減','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(243,'耳かきリラクゼーション専門店FC','耳かきリラクゼーション専門店FC','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(244,'骨盤底筋体操','骨盤底筋体操','2026-05-25 17:33:03','2026-05-25 17:33:03'),
(245,'建設・不動産','コンクリート内部防水テクノロジー','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(246,'中小企業サポート','AI×事務代行','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(247,'中小企業サポート','建設業の業務改善パートナー','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(248,'ＩＴ','反応率にこだわるWEBデザイン','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(249,'snsマーケティング','snsマーケティング','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(250,'医療専門FP','医療専門FP','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(251,'経営者コンディショニングサロン','経営者コンディショニングサロン','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(252,'技能継承技術の開発（製造業・建設業・物流業・訪問介護・就労支援・ビルメンテ）','技能継承技術の開発（製造業・建設業・物流業・訪問介護・就労支援・ビルメンテ）','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(253,'経営者マッチング','経営者マッチング','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(254,'YouTubeマーケティングコンサル','YouTubeマーケティングコンサル','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(255,'アパレルデザイナー','アパレルデザイナー','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(256,'芸能','芸能','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(257,'香川県中小企業診断士','香川県中小企業診断士','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(258,'統計学×量子力学コーチング','統計学×量子力学コーチング','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(259,'住宅設備','住宅設備','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(260,'Webマーケティング','Webマーケティング','2026-06-02 08:49:44','2026-06-02 08:49:44');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_memos`
--

DROP TABLE IF EXISTS `contact_memos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contact_memos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `target_member_id` bigint(20) unsigned NOT NULL,
  `meeting_id` bigint(20) unsigned DEFAULT NULL,
  `memo_type` varchar(32) NOT NULL DEFAULT 'other',
  `one_to_one_id` bigint(20) unsigned DEFAULT NULL,
  `body` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contact_memos_target_member_id_foreign` (`target_member_id`),
  KEY `contact_memos_owner_target_created_index` (`owner_member_id`,`target_member_id`,`created_at`),
  KEY `contact_memos_meeting_id_index` (`meeting_id`),
  KEY `contact_memos_one_to_one_id_index` (`one_to_one_id`),
  KEY `contact_memos_workspace_id_index` (`workspace_id`),
  CONSTRAINT `contact_memos_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `contact_memos_one_to_one_id_foreign` FOREIGN KEY (`one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE SET NULL,
  CONSTRAINT `contact_memos_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `contact_memos_target_member_id_foreign` FOREIGN KEY (`target_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `contact_memos_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_memos`
--

LOCK TABLES `contact_memos` WRITE;
/*!40000 ALTER TABLE `contact_memos` DISABLE KEYS */;
INSERT INTO `contact_memos` VALUES
(1,NULL,1,1,NULL,'other',NULL,'Phase16C smoke test memo','2026-03-05 08:15:13','2026-03-05 08:15:13'),
(2,NULL,1,14,4,'meeting',NULL,'外国人のスタッフ管理システムを構築したいと考えている\n1to1を希望','2026-03-24 01:20:18','2026-03-24 01:20:18'),
(3,NULL,1,17,4,'meeting',NULL,'高校生新卒採用\n求人がうまくいかない社長','2026-03-24 01:37:13','2026-03-24 01:37:13'),
(4,NULL,1,1,NULL,'other',NULL,'小学校のプール解体をしている。\n木を切ってお庭を広くしたい人がいたら','2026-03-31 01:31:59','2026-03-31 01:31:59'),
(5,NULL,1,10,NULL,'other',NULL,'業務拡大している施工店募集\nリフォーム業','2026-03-31 01:32:26','2026-03-31 01:32:26'),
(6,1,37,17,NULL,'one_to_one',11,'- **共通点・シナジー:**\n  - **地元:** 両者とも静岡県藤枝市出身・在住。佐藤氏は藤枝市古利（西焼津小学校区）、次廣氏は青葉町（青島中学校区）。\n  - **教育への関心:** 次廣氏は娘の受験を控え、佐藤氏のキャリア教育理念（五教科と社会の結びつけ）に強く共感。\n  - **システム×採用:** 次廣氏は静岡県の大卒求人サイト **「三並び」** のアプリ開発を受注中。**大学生がメールを見ない** ため通知機能が必要、という課題を共有。\n- **アクションアイテム（当時の整理）:**\n  - 次廣氏: 求人媒体からのリスト自動作成システムの **技術調査・提案準備**。\n  - 佐藤氏: **5月中旬の静岡帰省日程確定後**、次廣氏に連絡。\n  - 両者: **名古屋出世クラブ（5月末）** への参加可能性を検討（今西氏が佐藤氏を誘致中）。\n- **次回ミーティング:** **5月16–17日頃**、佐藤氏静岡帰省時に **対面** で実施予定。\n- **プライベート文脈（会話に出た事実の記録・紹介判断とは分離）:** 婚活、飯田氏からの占い（**32歳で結婚** 等）、保険担当の高校同級生からの紹介の動きなどが要約に含まれる。**取り扱い注意。本人確認のうえ参照。**\n\n#### 抽出された課題（事実：会話で言及）\n\n- テレアポ用リスト作成の **手作業負荷**（約1時間100件ペース）。\n- 求人媒体からの自動取得は **技術** に加え **利用規約・法的リスク（二次利用）** の確認が必要、との合意。\n- Google マイビジネス／公開情報は **二次利用禁止** の話題があり、個人事業主リストは **取得経路の設計** が課題。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** リスト作成が **コンサル本業とリソース競合** している。**根拠:** 手作業1時間100件の共有。**構造（仮説）:** リード前処理が属人・手作業 → 営業・提案に振る時間が圧迫 → スケールしにくい。\n- **課題②:** データ取得は **「作れるか」より「取ってよいか」** が先に決まる。**根拠:** スクレイピング・API の **法的リスク確認** が合意事項。**構造（仮説）:** 技術要件とコンプライアンスが分離できないと、開発が進んでも運用不能になりうる。\n- **シナジー:** 「採用」周辺に **通知・進捗・フォロー** のデジタル化が横展開しうる。**根拠:** 三並び案件で **メールを見ない大学生** と通知ニーズの共有。**仮説**としての展開可能性。\n\n#### 次アクション\n\n- 次廣: 技術調査・法務・規約リスク整理・提案準備。\n- 佐藤: 帰省日程確定後に連絡 → 5/16–17頃 対面設定。\n- 双方: 名古屋出世クラブ（5月末）参加の検討。','2026-04-07 03:39:09','2026-04-13 14:11:46');
/*!40000 ALTER TABLE `contact_memos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `countries_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dragonfly_contact_events`
--

DROP TABLE IF EXISTS `dragonfly_contact_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dragonfly_contact_events` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `target_member_id` bigint(20) unsigned NOT NULL,
  `meeting_id` bigint(20) unsigned DEFAULT NULL,
  `event_type` varchar(32) NOT NULL,
  `reason` varchar(280) DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dragonfly_contact_events_target_member_id_foreign` (`target_member_id`),
  KEY `dragonfly_contact_events_owner_target_created_index` (`owner_member_id`,`target_member_id`,`created_at`),
  KEY `dragonfly_contact_events_meeting_id_index` (`meeting_id`),
  CONSTRAINT `dragonfly_contact_events_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `dragonfly_contact_events_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `dragonfly_contact_events_target_member_id_foreign` FOREIGN KEY (`target_member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dragonfly_contact_events`
--

LOCK TABLES `dragonfly_contact_events` WRITE;
/*!40000 ALTER TABLE `dragonfly_contact_events` DISABLE KEYS */;
INSERT INTO `dragonfly_contact_events` VALUES
(5,1,2,1,'interested_on','test',NULL,'2026-03-03 08:33:35'),
(6,1,2,1,'interested_off','off',NULL,'2026-03-03 08:33:35'),
(7,1,2,1,'interested_on','both',NULL,'2026-03-03 08:33:35'),
(8,1,2,NULL,'interested_off',NULL,NULL,'2026-03-03 08:33:43'),
(9,1,2,NULL,'want_1on1_on',NULL,NULL,'2026-03-03 08:33:43'),
(10,1,12,NULL,'interested_on',NULL,NULL,'2026-03-05 14:04:01'),
(11,1,12,NULL,'want_1on1_off',NULL,NULL,'2026-03-05 14:04:01'),
(12,1,12,NULL,'want_1on1_on',NULL,NULL,'2026-03-05 14:04:02'),
(13,1,12,NULL,'interested_off',NULL,NULL,'2026-03-10 04:54:39'),
(14,1,12,NULL,'want_1on1_off',NULL,NULL,'2026-03-10 04:54:39');
/*!40000 ALTER TABLE `dragonfly_contact_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dragonfly_contact_flags`
--

DROP TABLE IF EXISTS `dragonfly_contact_flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dragonfly_contact_flags` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `target_member_id` bigint(20) unsigned NOT NULL,
  `interested` tinyint(1) NOT NULL DEFAULT 0,
  `want_1on1` tinyint(1) NOT NULL DEFAULT 0,
  `extra_status` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_status`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dragonfly_contact_flags_owner_member_id_target_member_id_unique` (`owner_member_id`,`target_member_id`),
  KEY `dragonfly_contact_flags_target_member_id_foreign` (`target_member_id`),
  KEY `dragonfly_contact_flags_owner_member_id_index` (`owner_member_id`),
  KEY `dragonfly_contact_flags_interested_index` (`interested`),
  KEY `dragonfly_contact_flags_want_1on1_index` (`want_1on1`),
  KEY `dragonfly_contact_flags_workspace_id_index` (`workspace_id`),
  CONSTRAINT `dragonfly_contact_flags_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `dragonfly_contact_flags_target_member_id_foreign` FOREIGN KEY (`target_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `dragonfly_contact_flags_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dragonfly_contact_flags`
--

LOCK TABLES `dragonfly_contact_flags` WRITE;
/*!40000 ALTER TABLE `dragonfly_contact_flags` DISABLE KEYS */;
INSERT INTO `dragonfly_contact_flags` VALUES
(3,NULL,1,2,0,1,'{\"only_extra\":true}','2026-03-03 08:33:35','2026-03-03 08:33:43'),
(4,NULL,1,12,0,0,NULL,'2026-03-05 14:04:01','2026-03-10 04:54:39');
/*!40000 ALTER TABLE `dragonfly_contact_flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `internal_referrals`
--

DROP TABLE IF EXISTS `internal_referrals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `internal_referrals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `buyer_member_id` bigint(20) unsigned NOT NULL,
  `seller_member_id` bigint(20) unsigned NOT NULL,
  `summary` varchar(255) NOT NULL,
  `closed_on` date DEFAULT NULL,
  `amount_yen` bigint(20) unsigned DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `internal_referrals_owner_member_id_created_at_index` (`owner_member_id`,`created_at`),
  KEY `internal_referrals_workspace_id_index` (`workspace_id`),
  KEY `internal_referrals_buyer_member_id_index` (`buyer_member_id`),
  KEY `internal_referrals_seller_member_id_index` (`seller_member_id`),
  CONSTRAINT `internal_referrals_buyer_member_id_foreign` FOREIGN KEY (`buyer_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `internal_referrals_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `internal_referrals_seller_member_id_foreign` FOREIGN KEY (`seller_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `internal_referrals_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `internal_referrals`
--

LOCK TABLES `internal_referrals` WRITE;
/*!40000 ALTER TABLE `internal_referrals` DISABLE KEYS */;
/*!40000 ALTER TABLE `internal_referrals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `introductions`
--

DROP TABLE IF EXISTS `introductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `introductions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `from_member_id` bigint(20) unsigned NOT NULL,
  `to_member_id` bigint(20) unsigned NOT NULL,
  `referral_kind` varchar(32) NOT NULL DEFAULT 'external',
  `meeting_id` bigint(20) unsigned DEFAULT NULL,
  `introduced_at` date DEFAULT NULL,
  `note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `introductions_from_member_id_foreign` (`from_member_id`),
  KEY `introductions_to_member_id_foreign` (`to_member_id`),
  KEY `introductions_owner_from_to_index` (`owner_member_id`,`from_member_id`,`to_member_id`),
  KEY `introductions_meeting_id_index` (`meeting_id`),
  KEY `introductions_workspace_id_index` (`workspace_id`),
  KEY `introductions_referral_kind_index` (`referral_kind`),
  CONSTRAINT `introductions_from_member_id_foreign` FOREIGN KEY (`from_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `introductions_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `introductions_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `introductions_to_member_id_foreign` FOREIGN KEY (`to_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `introductions_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `introductions`
--

LOCK TABLES `introductions` WRITE;
/*!40000 ALTER TABLE `introductions` DISABLE KEYS */;
/*!40000 ALTER TABLE `introductions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_csv_apply_logs`
--

DROP TABLE IF EXISTS `meeting_csv_apply_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_csv_apply_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `meeting_csv_import_id` bigint(20) unsigned NOT NULL,
  `apply_type` varchar(32) NOT NULL,
  `applied_on` date NOT NULL,
  `executed_at` datetime NOT NULL,
  `applied_count` int(10) unsigned NOT NULL DEFAULT 0,
  `added_count` int(10) unsigned DEFAULT NULL,
  `updated_count` int(10) unsigned DEFAULT NULL,
  `deleted_count` int(10) unsigned DEFAULT NULL,
  `protected_count` int(10) unsigned DEFAULT NULL,
  `skipped_count` int(10) unsigned DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `executed_by_member_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meeting_csv_apply_logs_meeting_csv_import_id_foreign` (`meeting_csv_import_id`),
  KEY `meeting_csv_apply_logs_meeting_id_executed_at_index` (`meeting_id`,`executed_at`),
  CONSTRAINT `meeting_csv_apply_logs_meeting_csv_import_id_foreign` FOREIGN KEY (`meeting_csv_import_id`) REFERENCES `meeting_csv_imports` (`id`) ON DELETE CASCADE,
  CONSTRAINT `meeting_csv_apply_logs_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_csv_apply_logs`
--

LOCK TABLES `meeting_csv_apply_logs` WRITE;
/*!40000 ALTER TABLE `meeting_csv_apply_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `meeting_csv_apply_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_csv_import_resolutions`
--

DROP TABLE IF EXISTS `meeting_csv_import_resolutions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_csv_import_resolutions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_csv_import_id` bigint(20) unsigned NOT NULL,
  `resolution_type` varchar(16) NOT NULL,
  `source_value` varchar(512) NOT NULL,
  `resolved_id` bigint(20) unsigned NOT NULL,
  `resolved_label` varchar(512) DEFAULT NULL,
  `action_type` varchar(16) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `csv_import_resolutions_unique` (`meeting_csv_import_id`,`resolution_type`,`source_value`),
  CONSTRAINT `meeting_csv_import_resolutions_meeting_csv_import_id_foreign` FOREIGN KEY (`meeting_csv_import_id`) REFERENCES `meeting_csv_imports` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_csv_import_resolutions`
--

LOCK TABLES `meeting_csv_import_resolutions` WRITE;
/*!40000 ALTER TABLE `meeting_csv_import_resolutions` DISABLE KEYS */;
/*!40000 ALTER TABLE `meeting_csv_import_resolutions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_csv_imports`
--

DROP TABLE IF EXISTS `meeting_csv_imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_csv_imports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `file_path` varchar(512) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT NULL,
  `imported_at` timestamp NULL DEFAULT NULL,
  `applied_count` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meeting_csv_imports_meeting_id_index` (`meeting_id`),
  CONSTRAINT `meeting_csv_imports_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_csv_imports`
--

LOCK TABLES `meeting_csv_imports` WRITE;
/*!40000 ALTER TABLE `meeting_csv_imports` DISABLE KEYS */;
INSERT INTO `meeting_csv_imports` VALUES
(1,3,'meeting_csv_imports/3/20260319020516_dragonfly_201_20260317_all_csv.txt','dragonfly_201_20260317_all_csv.txt','2026-03-19 02:05:16',NULL,NULL,'2026-03-19 02:05:16','2026-03-19 02:05:16'),
(2,3,'meeting_csv_imports/3/20260319020916_dragonfly_201_20260317_all_csv.txt','dragonfly_201_20260317_all_csv.txt','2026-03-19 02:09:16',NULL,NULL,'2026-03-19 02:09:16','2026-03-19 02:09:16'),
(3,3,'meeting_csv_imports/3/20260319133855_dragonfly_201_20260317_all_csv.txt','dragonfly_201_20260317_all_csv.txt','2026-03-19 13:38:55',NULL,NULL,'2026-03-19 13:38:55','2026-03-19 13:38:55'),
(4,6,'meeting_csv_imports/6/20260331000001_dragonfly_203_20260331_all.csv','dragonfly_203_20260331_all.csv','2026-03-31 00:00:01',NULL,NULL,'2026-03-31 00:00:01','2026-03-31 00:00:01'),
(5,6,'meeting_csv_imports/6/20260331000417_dragonfly_203_20260331_all_fixed.csv','dragonfly_203_20260331_all_fixed.csv','2026-03-31 00:04:17',NULL,NULL,'2026-03-31 00:04:17','2026-03-31 00:04:17'),
(6,6,'meeting_csv_imports/6/20260331000507_dragonfly_203_20260331_all_fixed.csv','dragonfly_203_20260331_all_fixed.csv','2026-03-31 00:05:07',NULL,NULL,'2026-03-31 00:05:07','2026-03-31 00:05:07'),
(7,9,'meeting_csv_imports/9/20260420221902_dragonfly_206_20260421_all_full.csv','dragonfly_206_20260421_all_full.csv','2026-04-20 22:19:02',NULL,NULL,'2026-04-20 22:19:02','2026-04-20 22:19:02'),
(8,13,'meeting_csv_imports/13/20260602164646_dragonfly_210_20260602_all_full.csv','dragonfly_210_20260602_all_full.csv','2026-06-02 16:46:47',NULL,NULL,'2026-06-02 16:46:47','2026-06-02 16:46:47');
/*!40000 ALTER TABLE `meeting_csv_imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_minutes`
--

DROP TABLE IF EXISTS `meeting_minutes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_minutes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `body_markdown` longtext NOT NULL,
  `source_path` varchar(512) NOT NULL,
  `doc_type` varchar(64) DEFAULT NULL,
  `session_date` date DEFAULT NULL,
  `session_time_jst` varchar(32) DEFAULT NULL,
  `session_time_note` text DEFAULT NULL,
  `format` varchar(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `front_matter` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`front_matter`)),
  `imported_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meeting_minutes_meeting_id_unique` (`meeting_id`),
  CONSTRAINT `meeting_minutes_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_minutes`
--

LOCK TABLES `meeting_minutes` WRITE;
/*!40000 ALTER TABLE `meeting_minutes` DISABLE KEYS */;
INSERT INTO `meeting_minutes` VALUES
(1,10,'# DragonFly 定例会 — 第207回（2026-05-12）\n\n**日時:** 2026-05-12（火）JST **10:00–11:45頃**（参加者PDF記載・Zoom録画メタ要確認）  \n**形式:** Zoom  \n**参加者:** 文字起こし要約ではメンバー 46・ビジター 6・代理出席 2・ゲスト 2 — **計 56 名**。参加者PDF/CSV上で確認できる代理出席者は 1 名のため、代理出席人数は要確認。  \n**関連:** [定例会参加者リスト PDF](../../pdf/260512/定例会参加者リスト2026-05-12.pdf) · [参加者 CSV](../../pdf/260512/dragonfly_207_20260512_all_full.csv)\n\n---\n\n## サマリー\n\n3週間ぶりの開催となった第207回定例会。メンバー更新、カテゴリー変更、一時退会の報告に加え、教育コーナーでは竹内駿太さんが「エレベーターピッチ」を扱った。\n\nメインプレゼンは **大竹絵理香さん**（家族も使える福利厚生）と **清原佳彩美さん**（サロン向け育毛機器・商材販売）。ビジター6名・ゲスト2名を迎え、ビジターの事業紹介、リファーラル事例、推薦の言葉、今後のイベント案内まで実施された。\n\n---\n\n## 校正メモ\n\n| 項目 | 校正後の扱い |\n|------|--------------|\n| 開催年 | 提供要約は「2025年5月12日」だが、参加者PDF/CSVと前後の議事録から **2026年5月12日** に補正 |\n| 用語 | 「産給金額」「請求金額」ではなく、BNI用語として **サンキュー金額** に統一 |\n| 藤井氏表記 | 既存名簿に合わせ **藤井恵理子** と表記 |\n| 岡元氏表記 | 既存名簿に合わせ **岡元智美** と表記 |\n| 舩杉氏表記 | 既存名簿に合わせ **舩杉牧子** と表記 |\n| 浜名氏表記 | 参加者PDF/CSVに合わせ **浜名靖博** と表記 |\n| 4月度サンキュー金額 | 提供要約は `19,507,000円` だが、後続の第209回議事録と整合する **19,057,000円** として記録 |\n| 今週リファーラル内訳 | 提供要約は「内部34・外部300・合計244」と算術不整合があるため、本文では **合計244件（内訳要確認）** として扱う |\n| 代理出席人数 | 提供要約は2名、参加者PDF/CSVでは1名確認。本文では差異を要確認として残す |\n\n---\n\n## 決定事項・重要事項\n\n### メンバーシップ関連\n\n| 区分 | 氏名 | カテゴリー / 内容 | 補足 |\n|------|------|-------------------|------|\n| **更新承認** | **藤井恵理子** | 播州織の日傘製造 | メンバーシップ委員会の審査を経て更新承認 |\n| **一時退会** | **吉田俊之** | 抗菌効果の強い漆塗りの食器販売 | 配偶者の出産に伴い 2026-05-12 付で一時退会。8月頃復帰予定 |\n| **カテゴリー変更** | **清原佳彩美** | サロン向け育毛機器・商材販売 | DragonFlyでの出会いから、薄毛に悩む経営者・美容業界向けの新領域へ変更 |\n\n藤井さんは、BNIを通じて「自分のできること・やりたいこと」をブラッシュアップできたこと、次の1年で得た学びを目標達成に活かしたいことを更新理由として共有した。\n\n---\n\n## 今週の実績\n\n### 参加\n\n| 区分 | 人数 |\n|------|------|\n| メンバー | 46名（文字起こし要約ベース） |\n| ビジター | 6名 |\n| ゲスト | 2名 |\n| 代理出席 | 2名（PDF/CSV上は1名確認のため要確認） |\n| 合計 | 56名（文字起こし要約ベース） |\n\n### チャプター実績（4月度・累計）\n\n| 指標 | 4月度 | 発足以来累計 |\n|------|------|--------------|\n| リファーラル | 338件（内部57・外部281） | 26,771件 |\n| サンキュー金額 | **19,057,000円** | **1,080,388,000円** |\n\n### 4月度 ネットワーキングリーダー\n\n| 部門 | 受賞者 | 実績 |\n|------|--------|------|\n| リファーラル部門 | 平岡国彦 | 22件 |\n| ビジター招待部門 | 西浦雅 | 6件 |\n| ワントゥーワン部門 | 増本重孝 | 33件 |\n| サンキュー金額部門 | 原田里織 | 6,000,000円 |\n| エデュケーション部門 | 西岡優希 | 170ポイント |\n\n### 今週のリファーラル\n\n提供要約では合計 **244件**。内訳は「内部34・外部300」とされているが、合計と一致しないため要確認。\n\n| 順位 | メンバー | カテゴリー | 件数 |\n|------|----------|------------|------|\n| 1 | 平岡国彦 | 大型物件対応解体工事 | 25件 |\n| 2 | 増本重孝 | 虫が建物に近寄らない害虫ブロック | 15件 |\n| 3 | 舩杉牧子 | 結婚相談所 | 12件 |\n\n### 主要リファーラル事例\n\n| 紹介元 | 紹介先 | 内容 |\n|--------|--------|------|\n| 平岡国彦 | 岡元智美 | 中小企業診断士の方を、勝てるプレゼン資料作成の岡元さんへ紹介 |\n| 増本重孝 | 里見允二 | 新商品の箱を探していた経営者を、パッケージ制作の里見さんへ紹介 |\n| 西浦雅 | 次廣淳 | AI業務改善システム構築の次廣へ、協業可能性のあるWeb制作会社社長を紹介 |\n| 舩杉牧子 | 岡元智美 | 強みを引き出すコーチングをされている小松さんを、岡元さんへ紹介 |\n\n---\n\n## 教育コーナー：エレベーターピッチ\n\n**担当:** 竹内駿太（エデュケーションコーディネーター）  \n**テーマ:** エレベーターピッチ\n\n商品スペックではなく、**顧客の問題と解決後の未来**を短く伝えることが重要だと共有された。\n\n### 要点\n\n| 観点 | 内容 |\n|------|------|\n| 主役 | 自社商品ではなく、顧客が抱えている問題 |\n| 悪い例 | 「私は最新のAIツールを販売しています」では、聞き手は紹介先を思い浮かべにくい |\n| 良い例 | 「残業に悩む経営者の時間を1日2時間作り出す仕事をしています」なら、相手が前のめりになりやすい |\n| 信頼の裏付け | 「成約率30%改善」「500世帯の家計改善」など、具体的な数字で実績を伝える |\n| 行動依頼 | 「誰かいい人」ではなく、地域・規模・立場・悩みまで絞って依頼する |\n\n### 今週のワーク\n\nワントゥーワンや名刺交換の場で、自分のビジネスを **「誰の悩みを解決し、どんな実績があるのか」** という形で30秒以内に話す練習をする。\n\n### 次廣への落とし込み\n\n「AI業務改善システム構築」ではなく、以下のように話す方が紹介されやすい。\n\n> 人を増やしたくないけれど、日報・見積・問い合わせ対応・毎月の集計に時間を取られている中小企業の社長に、LINE・Web・AIを使って、確認だけで回る仕組みを作っています。\n\n---\n\n## メインプレゼンテーション\n\n### 大竹絵理香 — 家族も使える福利厚生\n\n#### 背景\n\n日本企業の99.7%を占める中小企業では、大企業のような福利厚生を提供しづらい。大竹さん自身も、以前勤務していたネイルサロンで福利厚生が整っておらず、それを理由にスタッフが辞めていく場面を見てきた。\n\n#### サービス内容\n\n| 項目 | 内容 |\n|------|------|\n| 提携先 | 全国600社、10,000種類以上のサービス |\n| お祝い金 | 出産・結婚・入学など人生の節目に最大30,000円 |\n| 保険 | 個人賠償責任保険 500,000,000円まで付帯、示談交渉サービス付き |\n| 対象領域 | 電気・ガス、日用品、レジャー、慶弔など |\n\n#### ビジネスモデル\n\n- 会員数が増えるほどサービス内容が良くなる仕組み。\n- 利用するだけでなく、会社の事業として収益化・雇用創出につなげられる。\n\n#### 紹介希望先\n\n- 保険代理店\n- 財務コンサル\n- コミュニティ運営者\n- 新しい収入の柱を探している方\n\n---\n\n### 清原佳彩美 — サロン向け育毛機器・商材販売\n\n#### プロフィール\n\n仙台で美容サロンを経営しながら、シングルマザーとして2人の子どもと2匹のダックスを育てている。20代でまつげパーマに出会い、美容が人の人生を変える力を持つと実感。副作用や肌トラブルが少なく結果の出る商材「ノベルラッシュ」を開発し、1年半で全国600店舗以上へ導入した。\n\n#### N2プラスの特徴\n\n| 観点 | 内容 |\n|------|------|\n| 施術 | 針を刺さない、触れない、ダウンタイムなし |\n| 技術 | 高圧高速で美容成分を頭皮の奥へ届ける |\n| 時間 | 月1回、10分程度の施術 |\n| 用途 | 育毛、フェイシャルリフトアップ、スカルプ、ボディまで対応 |\n\n#### 実績・症例\n\n- 1回の施術で変化が見られた症例。\n- 4回・4ヶ月後に大幅な改善が見られた症例。\n- 若い女性の円形脱毛症が3回の施術後、半年で回復した症例。\n- 病院で改善困難だった抜け毛が、1回・1ヶ月で産毛が生えた症例。\n\n#### ビジネスメリット\n\n- 技術不要で導入しやすい。\n- 10分以内の施術で高単価メニュー化しやすい。\n- 美容業界の長時間労働・低単価問題を解決し、利益が残る美容を目指せる。\n\n#### 今後の予定・紹介希望先\n\n2026-05-18 からクラウドファンディング開始予定。\n\n- 美容室オーナー\n- 美容系サロンコンサル\n- 新しい高単価メニューを探しているサロン経営者\n\n---\n\n## コアバリューシェア・シェアストーリー\n\n### コアバリューシェア：佐藤拓斗\n\n**テーマ:** 関係構築\n\n採用も営業も、最終的には信頼関係が重要。BNI入会当初は「仕事につなげなければ」と自分語りが多かったが、最近は相手の事業・人・考えを知ろうとする姿勢に変わり、自然と紹介や良いご縁が増えたと共有した。\n\n### シェアストーリー：望月雅幸\n\n社労士の仕事は地元で広げるものだと考えていたが、BNIで全国のメンバーとつながる中で、オンライン商品を全国へ届けられる発想に変わった。\n\n#### 新サービス\n\n| 項目 | 内容 |\n|------|------|\n| サービス | セミオーダー就業規則オンライン |\n| 初期費用 | 50,000円 |\n| 月額メンテナンス | 9,800円 |\n| 対象 | 初めて就業規則を作る中小企業・小規模事業主 |\n| 提供方法 | オンライン相談・ヒアリングで全国対応 |\n\n望月さんは、BNIの5つのベネフィットに加え、特に **生涯学習** が大きな学びだったと共有した。\n\n---\n\n## リファーラル真正度確認\n\n**対象:** 越賀淑恵さん → 舩杉牧子さん  \n**内容:** 以前の会社の先輩で、婚活がうまくいっておらず、年齢面から結婚相談所に対応してもらえるか不安を持っていた方を紹介。\n\n舩杉さんからは、その後交流会へ参加してもらい、話を重ねる中でサポートすることになり、順調に進んでいるとの報告があった。\n\n---\n\n## 推薦の言葉：松倉健治 → 飯田千帆\n\n松倉健治さんが、経営者向け開運占い師の飯田千帆さんへの推薦の言葉を述べた。\n\n最初は「見える・聞こえる」リーディングに半信半疑だったが、仙台で鑑定を受けた際、本当に見えていると感じた。数日後に父の七回忌で帰省予定だったことを言っていないにもかかわらず、お墓参りに関する具体的な助言を受け、心を開いたというエピソードを共有した。\n\n仕事面でも相談に乗ってもらい、当時より売上が伸びていること、相手の立場に立って方向性を導いてくれる方だと推薦した。\n\n飯田さんは「迷いが確信に変わった」という言葉が占い師として嬉しかったと述べ、今後もご縁をいただいた方が安心して前に進めるよう丁寧に向き合いたいと話した。\n\n---\n\n## ビジター・代理・ゲスト\n\n### ビジター（6名）\n\n| 氏名 | 事業・カテゴリー | 要点 |\n|------|------------------|------|\n| 花崎勇佑 | SNS運用 / 動画編集スクール | Instagram・TikTokなどショート動画を活用した集客・問い合わせ導線づくり |\n| 丹羽さくら | 業務改善コンサルタント | 一人社長・中小企業向けに業務整備、IT/AI活用、バックオフィス自動化を支援 |\n| 鶴岡江里子 | Web制作 | LPコーディング、WordPress制作、写真撮影まで対応 |\n| 石原悠雅 | 保険業 | 生命保険を通じたライフプランニング・資産形成支援 |\n| 津澤正人 | 体の再生業（断食・ファスティング） | 断食指導を通じて体を整え、不調改善と健康寿命を支援 |\n| 小原裕美 | 若者キャリアコンサル | 延べ10,000人の若年者支援実績。岡山拠点・オンライン全国対応 |\n\n### ビジター感想\n\n- **丹羽さくら:** 初めてのBNI参加で緊張していたが、雰囲気が良く落ち着いて参加できた。多業種の参加者の多さに圧倒された。\n- **津澤正人:** 初参加で、様々な方が力を合わせて前に進む素晴らしいチームだと感じた。\n\n### ゲスト（2名）\n\n| 氏名 | 事業・カテゴリー | 補足 |\n|------|------------------|------|\n| 田辺光 | 通信関係（法人携帯、インターネット、新電力）、SNS運用代行 | 船津麻理子さん紹介 |\n| 髙橋豊 | ポスティング特化 広告代理店 | 75名規模のチャプターは初めて。テンポが良く、ビジネス拡大の可能性があるチャプターと感想 |\n\n### 代理出席\n\n| 氏名 | 代理元 | 事業 |\n|------|--------|------|\n| 浜名靖博 | 倉持賢一 | 中国向け物販支援 |\n\n提供要約には片山あつしさん（スマホ・PC修理）も代理出席として記載があるが、参加者PDF/CSV上では確認できなかったため要確認。\n\n---\n\n## BNI・チャプター情報（例会内共有）\n\n### 基本用語\n\nリファーラル、チャプター、サンキュー金額、1to1 について説明あり。リファーラルマーケティングは費用対効果の高い手法であり、BNIでは1専門カテゴリー1名に限定することで、メンバー同士が互いの営業部隊として機能する。\n\n### BNI規模\n\n| 項目 | 内容 |\n|------|------|\n| 世界 | 77カ国、11,642チャプター、約350,000人 |\n| 日本 | 383チャプター、12,566名 |\n| 日本の年間リファーラル | 1,700,000回超 |\n| 日本の年間サンキュー金額 | 124,400,000,000円以上 |\n| 東京NEリージョン | 24チャプター、1,158名 |\n\n### DragonFly\n\n| 項目 | 内容 |\n|------|------|\n| ビジョン | Flying Sky — 繋がりを世界の果てまで |\n| コアバリュー | Quality（上質を目指し） / Pride（誇りを持ち） / Challenge（挑戦し続ける） |\n| 第10期スローガン | 百華繚凛 |\n| 重点募集カテゴリー | 広告代理業、経営コンサル、税理士、Webマーケティング、美容商材販売 |\n\n### 役員・サポート\n\n- **プレジデント:** 平山真由美\n- **バイスプレジデント:** 芳賀崇利\n- **書記兼会計:** 岡元智美\n- **サポート:** 舩杉（メンター）、竹内（エデュケーション）、西浦（ビジターホスト）、山本（トレーニング）、渡辺（フォーラム）、中村（対面）、太田（1to1）、倉持（Webマスター）、飯田香（BCP）、飯田千帆（オンラインコミュニケーション）、藤井（グローバルビジネス）、福上（BOD）\n- **チャプターサポート:** 藤田磨紀（ディレクターコンサルタント）、山崎勇一（グロースエリアディレクター）、木下馨（東京NEリージョン エグゼクティブディレクター）\n\n---\n\n## 今後の予定・イベント\n\n### ワントゥーミニー\n\n太田一誠さんより、2026-05-12、2026-05-19、2026-05-26 の3週連続でワントゥーミニーを開催する案内があった。特に 2026-05-19 13:00 は山本葉子さんが開催予定。DragonFlyが大きくなるためには個々のつながりが重要であり、ワントゥーミニー活用が呼びかけられた。\n\n### リージョンフォーラム\n\nNキャス登録時、対面参加・オンライン参加のどちらかをコメント欄へ入力するよう案内があった。\n\n### ナショナルカンファレンス\n\n藤田ディレクターコンサルタントより、翌年5月に大阪で開催されるナショナルカンファレンスについて案内。全国約12,000人のメンバーから3,000人規模の積極的なメンバーが集まる予定で、DragonFlyメンバーからも参加表明が出ている。\n\n### ビジネス交流会\n\n2026-05-20 に加藤さんのステーキハウスで、BNIと倫理法人会のビジネス交流会が予定されている。文字起こし要約は末尾が途切れているため、詳細は要確認。\n\n---\n\n## 次廣視点メモ\n\n### 重要な接点\n\n- **西浦雅さん → 次廣淳:** Web制作会社社長との協業可能性。AI業務改善単独ではなく、Web制作・SNS・業務導線改善とのパワーチーム化の入口。\n- **丹羽さくらさん:** 業務改善コンサルタント。IT/AI活用・バックオフィス自動化の領域が近く、協業または棲み分け確認の1to1候補。\n- **鶴岡江里子さん:** Web制作・写真撮影。LP/WordPressと業務改善導線の接続候補。\n- **田辺光さん:** 通信・新電力・SNS運用代行。船津さん紹介のゲストで、後続の1to1候補として管理済み。\n\n### 学び\n\n今回の教育コーナーは、次廣のプレゼン改善に直結する。今後は「AI」「システム」から入らず、**誰が、どんな手作業・属人化・時間不足に困っているか** を先に伝える。紹介依頼は「中小企業の社長」ではなく、業種・規模・発していそうな言葉まで絞る。\n\n---\n\n## 要確認事項\n\n- 今週リファーラルの正確な内訳（提供要約の「内部34・外部300・合計244」が不整合）。\n- 代理出席者の人数と片山あつしさんの出席有無（PDF/CSVでは浜名靖博さんのみ確認）。\n- 開始・終了時刻のZoom録画メタ確認（PDF上は 10:00–11:45頃）。\n- ビジネス交流会（2026-05-20）の正式名称・時間・参加条件。','docs/meetings/chapter/chapter_weekly_20260512.md','chapter_weekly','2026-05-12','10:00-11:45','参加者PDFのタイムスケジュールでは開場 09:45、定例会開始 10:00、閉会 11:45頃。Zoom録画メタの正確な開始・終了は要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-12）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":207,\"session_date\":\"2026-05-12\",\"session_time_jst\":\"10:00-11:45\",\"session_time_note\":\"\\u53c2\\u52a0\\u8005PDF\\u306e\\u30bf\\u30a4\\u30e0\\u30b9\\u30b1\\u30b8\\u30e5\\u30fc\\u30eb\\u3067\\u306f\\u958b\\u5834 09:45\\u3001\\u5b9a\\u4f8b\\u4f1a\\u958b\\u59cb 10:00\\u3001\\u9589\\u4f1a 11:45\\u9803\\u3002Zoom\\u9332\\u753b\\u30e1\\u30bf\\u306e\\u6b63\\u78ba\\u306a\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306f\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-12\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260512\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026-05-12.pdf\",\"..\\/..\\/pdf\\/260512\\/dragonfly_207_20260512_all_full.csv\"]}','2026-06-02 15:39:21','2026-06-02 15:39:21','2026-06-02 15:39:21'),
(2,11,'# DragonFly 定例会 — 第208回（2026-05-19）\n\n**日時:** 2026-05-19（火）JST **08:00–10:00**（定例枠・要確認）  \n**形式:** Zoom  \n**参加者:** メンバー 47・ビジター 10・代理出席 2・ゲスト 6 — **計 65 名**  \n**関連:** [定例会参加者リスト PDF](../../pdf/260518/定例会参加者リスト2026-05-19.pdf) · [参加者 CSV](../../pdf/260518/dragonfly_208_20260519_all_full.csv) · [スリーバイス チームMTG（同日朝）](../team/team_threebiz_20260519.md)\n\n---\n\n## サマリー\n\n今週のリファーラル **118 件**（内部 14・外部 104）。メインプレゼンは **西岡裕樹** 氏（外国人技能実習生派遣・建設業向け監理団体）。教育コーナーは「紹介しやすい人の条件」。シェアストーリーは **増本重孝** 氏。\n\n**決定:** 8/21 グローバルビジネスイベント参加費 4,000 円を予備費から全額補助／6月フォーラムのエヌキャス締切を **今週金曜 2026-05-22**／対面ミーティングのランチ・二次会を実施し参加表明は **来週定例会 2026-05-26** まで。\n\n4月度累計: リファーラル 698 件・サンキュー 32,625,000 円。発足以来累計サンキュー **1,061,311,000 円**。\n\n---\n\n## 決定事項\n\n| 項目 | 内容 |\n|------|------|\n| **グローバルビジネスイベント補助** | **2026-08-21 18:00 JST** 開催のグロビジイベント参加費 **4,000 円**を、予算の予備費から **全額補助** |\n| **6月フォーラム（エヌキャス）** | 締切を **2026-05-22（金）** に設定（未入力者あり） |\n| **対面ミーティング** | 当日 **ランチ会・二次会** を実施。参加表明の回答期限は **2026-05-26** 定例会まで（LINE 案内予定） |\n\n---\n\n## 今週の実績\n\n### 参加・リファーラル\n\n| 指標 | 数値 |\n|------|------|\n| 参加 | メンバー 47 / ビジター 10 / 代理 2 / ゲスト 6 — **計 65** |\n| 今週リファーラル | **118**（内部 14 / 外部 104） |\n\n### リファーラル Top 3\n\n| 順位 | メンバー | カテゴリー | 件数 |\n|------|----------|------------|------|\n| 1 | 山本功太 | デザインに強いウェブ制作 | 15 |\n| 2 | 増本重孝 | 虫が建物に近寄らない害虫ブロック | 7 |\n| 3 | 松倉健治 | エアロゲル透明断熱フィルム | 6 |\n\n### 主要リファーラル事例\n\n| 紹介元 | 紹介先 | 内容 |\n|--------|--------|------|\n| 西浦みやび | 福上大輝 | 愛知の工務店紹介 → 工事契約 2 件・売上 **10,000,000 円** |\n| 中村啓吾 | 里見允二 | ネクタイのギフトボックス **200 個** 発注 |\n| 山本功太 | 木村健悟 | ナショナルカンファレンス用 T シャツプリント依頼 |\n\n---\n\n## メインプレゼンテーション：外国人技能実習生派遣\n\n**プレゼンター:** 西岡裕樹（29歳）\n\n### プロフィール要点\n\n- 中学卒後 **13 年** 型枠解体の職人。オーストラリア・フィリピンで計 **3 年** 海外経験\n- 現場の厳しさ・怪我・言葉の壁を経験したからこそ、実習生に寄り添う姿勢\n\n### 差別化\n\n| 柱 | 内容 |\n|----|------|\n| **同行サポート** | 通院・技能試験への付き添いを **追加費用なし**。社長・事務の時間を奪わない |\n| **日本語力** | 配属前の定期ウェブ面談。専門用語・道具名・安全合図を元職人視点で事前レクチャー。専属通訳と現場の言葉 |\n| **直接対応** | オンライン完結にせず現場の声を聞く。配属後も不安・不明点に直接対応 |\n\n### ターゲット\n\n- 人手不足の建設業\n- 既に実習生を雇うが組合サポートに不満がある企業\n- 付き添いの追加費用に疑問を持つ企業\n\n### プレゼント抽選\n\n西岡氏提供の **防水スマホケース**（4色）→ **福上大輝** 氏当選。福上氏コメント: シャワー派だが湯船に浸かる予定。「人手不足はチャンス」が刺さった。中卒・現場経験に基づく伴走の質が腑に落ちた、等。\n\n---\n\n## 教育コーナー：紹介しやすい人の条件\n\n### 紹介しにくい人\n\n1. **ターゲットが広すぎる** — 思考がフリーズし、誰の顔も浮かばない\n2. **レスポンスが遅い** — 紹介者の信頼を削り、「紹介を出せない」レッテルに\n\n### 紹介しやすい人\n\n1. **圧倒的な具体性** — 規模・業種・困りごとまで具体化し、声のかけ方までセットで渡す\n2. **絶対的な安心感** — 「顔はつぶさない。期待以上の対応を約束する」\n\n### 今週のタスク（チャプター）\n\nワントゥーワンや定例会後に、**「私がもっと紹介しやすい人になるために、私に足りない情報は何ですか？」** とメンバー同士で聞き合う。\n\n---\n\n## シェアストーリー：増本重孝\n\n| 項目 | 内容 |\n|------|------|\n| BNI 歴 | 4 年半 |\n| 累計サンキュー | **230,000,000 円** |\n\n**ビジネス改革 2 点:** (1) 出張商談をすべてリモート化 → 商談回数増 (2) 出張費削減 → 浮いた予算を地域システム構築へ。メンバー・リファーラル経由で具体的コメントを依頼。\n\n**BNI の 3 ベネフィット:** 接触頻度の高さ／生涯学習（東京 NE 年間 280 回超）／進化し続けるビジネスチーム。\n\n---\n\n## ビジター・代理・ゲスト\n\n### ビジター（10名）\n\n| # | 氏名 | 事業・エリア |\n|---|------|----------------|\n| 1 | 神麻のり子 | イタリアンジェラート製造卸（静岡市） |\n| 2 | 宮地義和 | インテリアリフォーム・家具デザイン（大阪中心・全国） |\n| 3 | 佐藤圭佑 | 産業機器メンテナンス（北海道） |\n| 4 | 神山英樹 | 中小企業診断士（千葉・市川市行徳） |\n| 5 | 中村まどか | 組織改革コーチング・社外 CHRO（つくば・**6月会社設立予定**） |\n| 6 | 山田桃子 | マルシェ運営（大阪・全国31箇所・1回700名） |\n| 7 | 福田康平 | オンライン家庭教師（公立小中学生・オーダーメイド塾テキスト） |\n| 8 | 池田正 | 電気代削減（高圧・全国、特に北海道・東北・北陸） |\n| 9 | 松下真紀子 | 中古介護ベッド（静岡・定価1/10・10年保証・全国） |\n| 10 | 南部ユースケ | コンサル（福井・神戸・大阪・LP/バナー等） |\n\n### 代理出席（2名）\n\n| 氏名 | 代理 | 事業 |\n|------|------|------|\n| 堺けんじ | 倉持 | 中国向け物販（中国 SNS インフルエンサー） |\n| 牧真一 | 野口裕子 | 若返り育毛ヘッドスパ（オゾン・水素） |\n\n### ゲスト（6名）\n\n古谷修二（通信・不動産）、海明子（化粧品）、村野秀二（非破壊検査 AI・ロボット／元キリンチャプター）、人形宗一郎（総合防災）、山本杏那（事務効率化）、佐野林（損害保険）。\n\n### ビジター・ゲストの声（抜粋）\n\n- **中村まどか:** 温かさ・繋がりを共有する場だと実感\n- **神山英樹:** プレゼンのピンポイントさを学びたい\n- **池田正:** 全国・多業種で勉強になった\n- **村野秀二:** キリンとの違いとして良い緊張感・本気度。含有率に感動\n- **山本杏那:** 朝から洗練・クオリティ・プロフェッショナル感\n\n**越賀さんの気づき:** 福田氏（オンライン家庭教師）から「次廣さんの聞き方が素晴らしい」とのコメント → ビジターはメンバーの参加姿勢を見ている。\n\n---\n\n## BNI・チャプター情報（例会内共有）\n\n### 基本用語\n\nリファーラル／チャプター／サンキュー金額の説明あり。\n\n### ドラゴンフライ\n\n| 項目 | 内容 |\n|------|------|\n| ビジョン | フライングスカイ — つながりを世界の果てまで |\n| コアバリュー | クオリティ・プライド・チャレンジ |\n| 今期スローガン | 百花繚乱 |\n\n### 統計（4月度・累計）\n\n**4月度:** リファーラル 698（内124/外574）・ビジター 31・1to1 915・サンキュー 32,625,000 円  \n\n**発足以来:** リファーラル 26,433（内5,742/外20,656）・ビジター 1,420・サンキュー **1,061,311,000 円**\n\n### メンバーシップ委員会 — 募集中カテゴリー\n\n広告代理店 / SNSマーケティング / 経営コンサル / 中小企業診断士\n\n### 推薦の言葉\n\n**越賀 → 梅澤:** 脱炭素経営をゲームで学ぶ TGX。中小企業のペナルティ時代に有用。梅澤氏は全国展開・地球温暖化への企業取り組みを表明。\n\n### 役員・サポート（紹介のみ）\n\n- **プレジデント:** 平山真由美\n- **VP:** 芳賀崇利\n- **書記兼会計:** 岡本智美\n- サポート: 船杉（メンター）、竹内（EC）、西浦（ビジホス）、山本（トレーニング）、渡辺（フォーラム）、中村（対面）、太田（1to1）、倉松（ウェブマスター）、飯田かおり（BCP）、飯田千穂（オンラインコミュ）、藤井（グローバルビジネス）、福上（EOD）\n- チャプターサポート: 藤田真希（DC）、山崎ゆういち（GAD）、木下薫（東京 NE ED）\n\n---\n\n## 今後のメインプレゼン\n\n| 日付 | スピーカー | メモ |\n|------|------------|------|\n| **2026-05-26** | 木村健悟（Tシャツプリント）、中村啓吾（日本製ものづくり再興） | ものづくり関連ビジター招待推奨 |\n\n---\n\n## 入会案内（共有内容）\n\n1. 登録費・プログラム利用料の入金  \n2. 申込書をメンバーシップ委員会へ  \n3. 面談・振込明細・信用紹介先を VP へ  \n\n**費用:** 登録費 50,000 円（税別）／プログラム 190,000 円/年（2年 -80,000 / 5年 -150,000）／チャプター運営費 5,000 円/月  \n\n審査承認後、競合は当チャプターに入会不可。\n\n---\n\n## アクションアイテム\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| 各チームリーダー | エヌキャス **役職名更新** | — |\n| メンバー | **6月フォーラム** エヌキャス入力 | **2026-05-22（金）** |\n| メンバー | **対面 MTG** ランチ・二次会の参加表明（LINE 案内） | **2026-05-26** 定例会まで |\n| メインプレ担当 | 本日 **14:00 JST** リハーサル | 2026-05-19 |\n| メンタリング | 初めの一歩（原田・山本・久米）、何でも相談室（次廣） | 定例後 |\n\n---\n\n## 次回予告\n\n- **次回定例会:** 2026-05-26（火）— メインプレ 木村・中村（上表）\n- **2026-06-05 フォーラム:** 4月ナショナルカンファレンスのシェア。35名以上登壇。DragonFly から **原田**（ブース出展）、**田口**、**太田**\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-05-19 12:39 | 初版。Zoom 文字起こし要約を議事録化。 |','docs/meetings/chapter/chapter_weekly_20260519.md','chapter_weekly','2026-05-19','08:00-10:00','DragonFly 定例枠（火曜）。開始・終了の正確な時刻は Zoom 録画メタで要確認。同日 08:00–08:45 にスリーバイスチーム MTGあり。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-19）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":208,\"session_date\":\"2026-05-19\",\"session_time_jst\":\"08:00-10:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306e\\u6b63\\u78ba\\u306a\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\\u540c\\u65e5 08:00\\u201308:45 \\u306b\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\\u30c1\\u30fc\\u30e0 MTG\\u3042\\u308a\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-19\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260518\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026-05-19.pdf\",\"..\\/..\\/pdf\\/260518\\/dragonfly_208_20260519_all_full.csv\"]}','2026-06-02 15:39:21','2026-06-02 15:39:21','2026-06-02 15:39:21'),
(3,12,'# BNI DragonFly 定例会議事録（2026/05/26）\n\n**日時:** 2026-05-26（火）JST **08:00–10:00**（定例枠・要確認）  \n**形式:** Zoom  \n**参加者:** ビジター 7・ゲスト 2 — **計 56 名**  \n**関連:** [定例会参加者リスト PDF](../../pdf/260526/定例会参加者リスト2026_05_26.pdf) · [参加者 CSV](../../pdf/260526/dragonfly_209_20260526_corrected_full.csv)\n\n---\n\n## 1. 定例会概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年5月26日（火） |\n| **参加人数** | 総勢 **56名** |\n| **ビジター** | **7名** |\n| **ゲスト** | **2名** |\n| **リファーラル** | **110件**（内部18・外部92） |\n\n新メンバー2名（米沢由佳氏・森園祐樹氏）の入会承認、メインプレ2件（Tシャツプリント・日本製ものづくり）、リファーラル110件の交換が実施された。教育コーナーは「紹介の解像度を上げる」、シェアストーリーは小中氏（AIツール情報発信）。ビジター7名・ゲスト2名を迎え、チャプターの成長と活性化が確認された。\n\n---\n\n## 2. 決定事項・重要事項\n\n### 新メンバー承認\n\n| 氏名 | カテゴリー | 紹介者 |\n|------|------------|--------|\n| **米沢由佳** | 反応率にこだわるウェブデザイン | 福上大樹 |\n| **森園祐樹** | AI×事務代行 | 平岡国彦 |\n\n- 両名とも倫理規定の宣誓を完了し、正式メンバーとして承認\n\n### メインプレゼンテーション実施\n\n| 登壇者 | カテゴリー | 内容 |\n|--------|------------|------|\n| **木村健吾** | Tシャツプリント | オリジナルTシャツ製作事業の詳細 |\n| **中村啓吾** | 日本製ものづくり再興事業プロデューサー | 日本製アパレルの現状と「日本製の覚悟展」（2026年7月3–4日・有楽町） |\n\n### リファーラル実績（今週）\n\n- **合計 110件**（内部18・外部92）\n- **Top 3:** 平岡国彦 12件 / 舩杉真紀子 9件 / 増本重孝 5件\n\n### リファーラル品質確認\n\n- **平岡国彦** → **清原かさみ**（サロン向け育毛機器・美容商材）\n- 美容室19店舗展開の取締役を紹介 → Zoom実施 → 数店舗でまつ毛美容液導入決定、育毛マシン検討機会も獲得。**売上につながるリファーラルとして確認完了**\n\n### 推薦の言葉\n\n- **原田沙織** → **木村健吾**（ナショナルカンファレンス用ロゴTシャツ・トートバッグ制作。丁寧なヒアリング・迅速対応・提案力・高品質・追加注文時の提案力を評価）\n\n### プレゼント抽選\n\n| 提供者 | 商品 | 当選者 |\n|--------|------|--------|\n| 木村健吾 | デニム雑貨（ペンケースまたはポーチ） | 倉持賢一 |\n| 中村啓吾 | 動物ハンカチ2柄 | 畠山憲之 |\n\n### チャプター実績\n\n**4月度**\n\n| 指標 | 数値 |\n|------|------|\n| リファーラル | 338件（内部57・外部281） |\n| ビジター | 32名 |\n| 1to1 | 514回 |\n| 請求金額 | 19,057,000円 |\n\n**発足以来累計**\n\n| 指標 | 数値 |\n|------|------|\n| リファーラル | 26,771件（内部5,799・外部20,937） |\n| ビジター | 1,452名 |\n| 請求金額 | 1,080,388,000円（約10.8億円） |\n\n**チャプター規模:** メンバー47名（プラチナチャプター基準50名以上を目指す75人体制では紹介ルート2,775ライン・約2.2倍）\n\n### 募集中カテゴリー\n\n保険代理店 / コンサル業 / ウェルネスサービス / 中小企業診断士 / コスト削減\n\n### コアバリュー共有\n\n**舩杉真紀子** — 「前向きな姿勢と態度」  \nうまくいかない時こそ姿勢が現れる。「まずやってみる」を大切にし、挑戦しないことの方がもったいない。周囲への連鎖がご縁とチャンスを広げる。\n\n---\n\n## 3. エデュケーション要点\n\n### テーマ\n\n**「紹介の解像度を上げる」**（担当：竹内俊太 — アスリート専門生命保険）\n\n### 学び — 属性の三段階絞り込み\n\n| 段階 | 例 | 評価 |\n|------|-----|------|\n| 第一段階 | 「経営者を紹介してください」 | ❌ 漠然としすぎて効果薄 |\n| 第二段階 | 「都内で従業員10–30名規模のIT企業の経営者を紹介してください」 | △ 輪郭が見えてくる |\n| 第三段階 | 「都内・従業員10–30名・IT企業の経営者で、最近オフィス移転または採用活動を始めた社長を紹介してください」 | ⭕ ピンポイントでヒット |\n\n**なぜ重要か:** 75人体制（2,775ライン）の強力なインフラに、**具体的で高精度なデータ**を流し込むことで、最強のビジネスインフラになる。\n\n### 顧客の悩み言語\n\n顧客はサービス名ではなく、**日常会話の症状**で語る。\n\n| ❌ サービス名で伝える | ⭕ 日常会話で出る言葉 |\n|----------------------|----------------------|\n| 「〇〇というサービスを探している」 | 「最近肩が痛くて眠れない」 |\n| 「AI業務改善システムをしています」 | 「今年の税金が高すぎて頭が痛い」 |\n| 「システム開発をしています」 | 「人を増やしたくないけど仕事が回らない」 |\n\n**プレゼンの言い換え:** 商品説明ではなく —  \n「今週あなたの周りで〇〇とぼやいている人がいたら、私につないでください」\n\n---\n\n## 4. メインプレゼン要点\n\n### 木村健吾（Tシャツプリント）\n\n#### 会社概要\n\n- **株式会社ハートプランニング**（創業36年・岡山県倉敷市）\n- 父の失明をきっかけに入社。47都道府県取引、最高一案件40,000枚\n\n#### 強み\n\n1. **何度でもデザインサポート** — 配色変更など修正対応\n2. **追加注文も初回同額** — 少量追加でも単価維持\n3. **1枚から作成可能** — シルク・転写・インクジェット・刺繍・レーザー加工を自社工場で一貫対応\n\n#### 求めている紹介先\n\n- スポーツチーム・クラブの監督・顧問\n- 展示会・イベントを開く企業\n- **特に:** 企業イベント企画担当（広告代理店業など）\n- **夢:** BNI内最大規模「24時間テレビのチャリティーTシャツ」級の紹介\n\n#### 印象に残ったポイント\n\n- 1枚1,000–2,000円程度。衣服ではなく「人をつなぎ、気持ちを高め、メッセージを伝えるツール」\n- Tシャツ以外にパーカー・エプロン・トート・作業着・ボトル・マグ・作業ヘルメット等も対応\n\n---\n\n### 中村啓吾（日本製ものづくり再興事業プロデューサー）\n\n#### 会社概要\n\n- **株式会社作物法制**（1968年創業・岡山県津山市）\n- 年間ネクタイ20,000本・ハンカチ25,000枚。SNSフォロワー180,000人超（倒産寸前から立て直し）\n\n#### 強み\n\n- 「作る」だけでなく **「作って伝えて売る」** まで現場で実践\n- 晩秋織りハンカチがXでバズ → 6ヶ月で25,000枚販売（最高インプレッション2,000万超）\n- 地方の小さな縫製工場でも、発信と届け方を変えれば全国に届くことを実証\n\n#### 求めている紹介先\n\n- 日本製の自社商品でものづくりをしている **町工場・職人・跡継ぎ**\n- 提供価値：同じ思いの仲間との出会い / 見せ方・伝え方・ブランドの見直し / SNS発信をともに学ぶ機会\n\n#### 印象に残ったポイント\n\n- 国内生産率：1990年50.1% → 2025年1.4%。必要なのは「作る力」＋「伝える力」＋「選ばれる力」\n- **日本製の覚悟展**（2026/7/3–4・有楽町東京交通会館12階・全国16社）— テーマ「守られる日本製ではなく、選ばれに行く日本製」\n- **将来の夢:** 両国国技館で同展を主催。BNIで仲間探しを加速\n\n---\n\n## 5. シェアストーリー・学び\n\n**登壇者:** 小中氏（使って学ぶAIツールの情報発信）\n\n### 売りたいもの（当初）\n\n- AI研修・コンサルティング\n- **課題:** 教える人が多い / 初対面で選ばれる動機がない / 高額で即決できない\n\n### 入り口戦略\n\n- フロントサービスを **月1,000円の情報発信** に変更\n- 導入しやすい価格帯で日々の情報発信 → 「AIに詳しい人」「教え方がうまい人」の認知獲得\n\n### 信頼構築方法\n\n- リファーラルマーケティングの設計要素を分解して実践：\n  - 誰がお客か / 何に困っているか / どう解決するか\n  - 誰とつながっていて、どう紹介してもらうか（入り口設計）\n  - つないでもらった後のカスタマージャーニー設計\n- 「誰でもいいです」という曖昧なリクエストでは仕組みにならない\n\n### BNIとの相性\n\n- トレーニングコンテンツが豊富\n- DragonFlyは50人の経営者が在籍、年間140件以上の紹介を受けられる\n- インプット（学び）とアウトプット（実践）の両方が同じ場で回る → **PDCAを早く回せる**\n\n---\n\n## 6. ビジター・新しいつながり\n\n### 石原孝之氏（次廣淳招待ビジター）\n\n| 項目 | 内容 |\n|------|------|\n| **現在** | 保険代理店 |\n| **経歴** | 元市議会議員 |\n| **関連領域** | 介護施設・保育園経営経験 |\n| **活動** | 地域イベント主催 |\n| **特徴** | 経営経験あり |\n\n→ **自分が招待したビジターとして今後フォロー対象。** BO後の個別面談・アンケートフォローを優先。\n\n### 印象に残ったビジター（つながり候補）\n\n| 氏名 | 事業 | ポイント |\n|------|------|----------|\n| **吉崎淳** | 肌着・布製品縫製工場（京都府綾部市・60年超） | 中村氏の「両国国技館での覚悟展」に参加したいと発言。小ロット100枚から対応 |\n| **山田智子** | 女性客に強いウェブ制作（千葉成田） | 営業ゼロで200社以上 |\n| **増田義久** | キャッサバスイーツ（栃木・農園運営） | 地域特産×ものづくり |\n\n### その他ビジター（7名）\n\n| 氏名 | 事業 |\n|------|------|\n| 青木博美 | 婚活サロン運営 |\n| 岡崎由香 | 赤州瓦原の焼き物制作（島根県西部） |\n| 熊谷隆章 | 通信費削減（ソフトバンク担当8年目） |\n\n### ゲスト（2名）\n\n佐藤氏（リラクゼーション専門店FC）/ 服田氏（骨盤底筋体操）\n\n### ビジター感想（抜粋）\n\n**吉崎淳:** 経営や業界の会話にまだ若く知らない言葉も多かったが、詳しい説明が勉強になった。中村氏の両国国技館での覚悟展に参加したい。\n\n---\n\n## 7. tugilo視点での気づき\n\n### 気づき\n\n今回の教育と小中氏のシェアストーリーは、**同じ構造**を指している。\n\n- 竹内氏：紹介リクエストを三段階で具体化する\n- 小中氏：高額サービスの前に、月1,000円の入り口で信頼を積む\n- 共通点：**「何を売っているか」ではなく「どんな状況の人か」を言語化する**\n\n75人体制の2,775ラインは「配線」。精度の低いリクエストを流すと配線は活きない。**悩み言語 × 具体属性**が、tugiloの紹介精度を決める。\n\n→ 詳細は [Living Document §10](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md#10-bni活用とビジネス設計2026-05-26-定例会からの学び) に整理済み。\n\n### 自社（tugilo）へ応用できそうなこと\n\n1. **ウィークリープレゼン（25秒）** — カテゴリー名ではなく「困りごと」を先に言う\n2. **1to1の入り口設計** — 相手に「私の紹介先、もっと具体化するなら何が足りない？」と聞く\n3. **フロント商品の再確認** — 小中氏モデルのように、高額伴走の前段に「触れやすい接点」を置く\n4. **石原氏フォロー** — 保険×介護福祉×地域イベント。経営者ネットワークと業務改善の接点を1to1で探索\n\n### AI業務改善への置き換え例\n\n| 今まで | 今後 |\n|--------|------|\n| 「AI業務改善システムをしています」 | 「最近、人を増やしたくないのに仕事が回らないと言っている社長いませんか？」 |\n| 「Excelの二重入力を解決します」 | 「同じ内容を何度も入力しているとぼやいている担当者、周りにいませんか？」 |\n| 「システム開発をしています」 | 「売上は伸びているのに、現場の仕組みが追いついていない会社の社長を紹介してください」 |\n| 「経営者を紹介してください」 | 「従業員10–30名・IT以外の製造・小売で、採用または事務負担を最近増やした社長を紹介してください」 |\n\n---\n\n## 8. 次回までのアクション\n\n- [ ] **ウィークリープレゼン改善** — 悩み言語版に書き換え（25秒原稿を更新）\n- [ ] **紹介テンプレ作成** — 三段階絞り込み形式（属性＋状況＋タイミング）を1枚に\n- [ ] **石原孝之氏フォロー** — BO後の面談振り返り・1to1日程調整・紹介可能性の整理\n- [ ] **気になった方との1to1** — 吉崎淳氏（縫製×ものづくり）、必要に応じて中村氏との三角接続\n- [ ] **学びを自社提案へ反映** — 提案書・BO原稿・Living Document §2 ウィークリープレゼンに悩み言語を反映\n- [ ] **メンバーへ逆質問** — 「私をもっと紹介しやすくするために足りない情報は何ですか？」を1to1で実施\n\n---\n\n## 9. 一言まとめ\n\n**「誰を紹介してほしいか」ではなく、「どんな悩みを口にする人か」を共有することで、紹介精度は大きく変わる。**  \nチャプターの拡大は配線を増やすだけ。tugiloが次にやるべきは、75人体制に流し込む **高精度の悩み言語** を自分の言葉で定義し、毎週25秒で繰り返すこと。\n\n---\n\n## 付録：BNI・チャプター情報（例会内共有）\n\n### ドラゴンフライ\n\n| 項目 | 内容 |\n|------|------|\n| ビジョン | フライングスカイ — つながりを世界の果てまで |\n| コアバリュー | クオリティ・プライド・チャレンジ |\n| 今期スローガン | 百花繚乱 |\n\n### 世界のBNI\n\n77カ国・11,642チャプター・約350,000人。東京リージョン24チャプター・1,148名（日本一）。\n\n### 役員・サポート（紹介のみ）\n\n- **プレジデント:** 平山真由美\n- **VP:** 芳賀貴俊\n- **書記兼会計:** 岡本智美\n- サポート: 舩杉（メンター）、竹内（EC）、西浦（ビジホス）、山本（トレーニング）、渡辺（フォーラム）、中村（対面）、太田（1to1）、倉松（ウェブマスター）、飯田（BCP）、飯田千穂（オンラインコミュ）、藤井（グローバルビジネス）、福上（BOD）\n- チャプターサポート: 藤田真紀（DC）、山崎唯一（GAD）、木下かおる（東京 NE ED）\n\n### 入会案内（共有内容）\n\n1. 登録費・プログラム利用料の入金  \n2. 申込書をメンバーシップ委員会へ  \n3. 面談・振込明細・信用紹介先を VP へ  \n\n**費用:** 登録費 50,000円（税別）／プログラム 190,000円/年（2年 -80,000 / 5年 -150,000）／チャプター運営費 5,000円/月  \n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-05-26 17:53 | 初版。Zoom 文字起こし要約を議事録化。 |','docs/meetings/chapter/chapter_weekly_20260526.md','chapter_weekly','2026-05-26','08:00-10:00','DragonFly 定例枠（火曜）。開始・終了の正確な時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-26）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":209,\"session_date\":\"2026-05-26\",\"session_time_jst\":\"08:00-10:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306e\\u6b63\\u78ba\\u306a\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-26\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260526\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026_05_26.pdf\",\"..\\/..\\/pdf\\/260526\\/dragonfly_209_20260526_corrected_full.csv\"]}','2026-06-02 15:39:21','2026-06-02 15:39:21','2026-06-02 15:39:21'),
(4,13,'# BNI DragonFly 定例会議事録（2026/06/02）\n\n**日時:** 2026-06-02（火）JST **08:00–10:00**（定例枠・要確認）  \n**形式:** Zoom  \n**参加者:** ビジター 12名・ゲスト 1名・代理出席 1名  \n**関連:** [参加者 CSV](../../pdf/260601/dragonfly_210_20260602_all_full.csv)\n\n---\n\n## 1. 定例会概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年6月2日（火） |\n| **ビジター** | **12名** |\n| **ゲスト** | **1名** |\n| **代理出席** | **1名** |\n| **リファーラル** | **146件**（内部16・外部130） |\n| **メインプレゼン** | 田渕恭平（高級石材・庵治石） / 松倉健治（エアロゲル透明断熱フィルム） |\n\n新メンバー1名（木村アンナさん）の入会承認と、既存メンバー2名（畑山紀之さん・今西俊明さん）の更新承認が行われた。今週のリファーラルは146件（内部16・外部130）。メインプレゼンでは、田渕恭平さんが高級石材・庵治石の事業と「石と人の関係を構築する」ビジョンを紹介し、松倉健治さんがエアロゲル透明断熱フィルムの省エネ・防災価値を紹介した。\n\n---\n\n## 2. 決定事項・重要事項\n\n### メンバーシップ関連\n\n| 区分 | 氏名 | カテゴリー / 内容 | 補足 |\n|------|------|-------------------|------|\n| **新規入会承認** | **木村アンナ** | 建設業の業務改善パートナー | 講演者: 平岡邦彦 |\n| **更新承認** | **畑山紀之** | スイーツのOEM製造 | |\n| **更新承認** | **今西俊明** | 飲食店向け集客アプリ | |\n\n### 運営関連\n\n- 倉持賢一さんのパソコントラブルにより、小中さんが朝礼スライド共有のバックアップ対応を担当。\n- 朝礼資料は **バージョン2.02**、定例会ゼロは **バージョン1.01** が最新版として確認された。\n- 倉持さんは新しい MacBook の購入を検討（M5 の価格確認済み）。\n\n---\n\n## 3. 会議前の技術トラブル対応\n\n倉持さんのメインパソコンが熱による不具合で、30分程度しか稼働できない状態となった。エアコン・冷却ファンで対策したが、新しいパソコンへの切り替えが必要と判断され、当日はプログラミング教室用のパソコンで参加した。\n\n小中さんがスライド共有のバックアップ体制を整え、メッセンジャーでの連絡体制を確認した。\n\n---\n\n## 4. ビジター・ゲスト紹介\n\n横山尚武さん（ビジターホスト）より、ビジター12名・ゲスト1名・代理出席者1名が紹介された。\n\n| 氏名 | 事業・カテゴリー | 要点 |\n|------|------------------|------|\n| **門脇唯** | SNSマーケティング | 45日で1万フォロワー、広告ゼロで月300万円売上のノウハウ。400フォロワーから1万フォロワーへの成長実績 |\n| **岩本悠太** | 医療専門FP | 静岡県内で医療特化型FP。企業・医療機関向けセミナー、福利厚生導入支援 |\n| **寺本勲** | 経営者コンディショニングサロン | 声優・ナレーター23年の経験を活かした声・話し方のコンサルティング |\n| **林田直也** | 販管費削減コンサル | 電気代・水道代などインフラコスト見直しによる利益改善支援 |\n| **遠藤哲也** | 経営者マッチング | 経営者プラットフォーム「ユニオンプラス」。1,000人以上登録、3ヶ月無料キャンペーン中 |\n| **中西優斗** | YouTubeマーケティング | 成果報酬型SNS運用。10万人超チャンネル複数作成、問い合わせ・集客導線まで設計 |\n| **和合純也** | アパレルデザイナー | 自社ブランドとOEM/ODM。10枚から量産対応 |\n| **Hikaru** | シンガーソングライター | 6月20日に東京で5周年ライブ。SNS中心にライブ活動・PR業務 |\n| **溝渕剛彦** | 中小企業診断士 | 地方銀行34年。経営改善・資金調達・事業承継を銀行目線と経営者目線で支援 |\n| **竹葉ノア** | 統計学・量子力学コーチング | 周波数分析・調整と統計学による願望実現支援。40代以上の経営者向け |\n| **島田徹也** | 住宅設備 | 千葉県成田市。プロパンガス製造、給湯機器・住宅設備の交換工事 |\n\n---\n\n## 5. BNI概要説明・コアバリュー\n\n平山真由美プレジデントより、BNIの目的・コアバリュー・重要用語の説明が行われた。\n\n| 項目 | 内容 |\n|------|------|\n| **BNI規模** | 世界77カ国、11,654チャプター、約35万人のメンバー |\n| **重要用語** | リファラル、チャプター、サンキュー金額 |\n| **本日のコアバリュー** | **伝統と革新** |\n\n「伝統と革新」では、基盤としての伝統を大切にしながらイノベーションを生み出すことの重要性が共有された。\n\n---\n\n## 6. ネットワーキング学習コーナー\n\n**担当:** 竹内駿太（エデュケーションコーディネーター）  \n**テーマ:** 野球の配球の組み立て\n\n30秒プレゼンを、単発の自己紹介や商品説明ではなく **3週間の戦略的配球** として組み立てる考え方が共有された。\n\n野球のピッチャーが、1球ごとにただ全力で投げるのではなく、打者の反応を見ながらストレート・変化球・コースを組み合わせるように、BNIのウィークリープレゼンも **毎週の25秒・30秒を連続した流れとして設計する** という学び。1回で全部を伝えようとすると情報量が多くなり、聞き手は「結局、誰を紹介すればよいのか」を持ち帰りにくい。そこで、3週間を1セットにして、聞き手の理解を段階的に深める。\n\n| 週 | 役割 | 内容 |\n|----|------|------|\n| **1週目** | 課題提示 | 業界や顧客が抱える課題を提示する。「こういう困りごとがある人がいる」と、聞き手の周囲を思い浮かべてもらう |\n| **2週目** | 解決策提示 | 自分独自の解決策・価値を示す。課題に対して、なぜ自分が役に立てるのかを短く伝える |\n| **3週目** | ターゲット要求 | 紹介してほしい相手を明確にする。業種・立場・状況・発していそうな言葉まで絞り込む |\n\n75人体制のチャプターになった場合、2,775通りのパスコースが生まれるという説明があり、チャプターの紹介インフラを活かすには、プレゼン側の設計力が必要だと整理された。\n\n### 3週間配球の狙い\n\n| 観点 | 意味 |\n|------|------|\n| **聞き手の記憶に残す** | 毎週違う話題に飛ぶのではなく、同じテーマを角度を変えて伝えることで「この人はこの課題の人」と覚えてもらう |\n| **紹介者の負担を下げる** | いきなり「この人を紹介して」と言う前に、課題と解決策を共有しておくことで、紹介者が説明しやすくなる |\n| **紹介の精度を上げる** | 3週目でターゲットを絞るため、単なる見込み客ではなく、今まさに困っている人につながりやすくなる |\n| **反応を見て修正する** | 1週目・2週目のあと、BOや121で出た反応をもとに、3週目の紹介依頼を調整できる |\n\n### プレゼン設計の型\n\n1週目は「自分のサービス名」ではなく「相手が日常で言っていそうな困りごと」から入る。たとえば「AI業務改善をしています」よりも、「人を増やしたくないけど、事務作業が増えて現場が回らない会社が増えています」の方が、聞き手は周囲の人を思い出しやすい。\n\n2週目は、その課題に対して自分が何をしているかを伝える。ただし機能の羅列ではなく、Before / After で短く話す。「紙やLINEに散らばった報告を、あとから集計できる形に整える」「毎月の手作業を、確認だけで済む形にする」のように、聞き手が第三者へ説明しやすい言葉にする。\n\n3週目は、紹介してほしい相手を絞る。業種だけでなく、規模・役職・今起きている出来事・口にしていそうな悩みまで具体化する。紹介依頼は「経営者なら誰でも」ではなく、「最近、人を増やさずに事務作業を減らしたいと言っている、10〜30名規模の建設業・製造業の社長」のようにする。\n\n### 次廣のプレゼンへの落とし込み例\n\n| 週 | 方向性 | 25秒・30秒の骨子 |\n|----|--------|------------------|\n| **1週目** | 課題 | 「現場では、日報・見積・集計・問い合わせ対応など、売上に直結しない作業に時間を取られている会社が多いです。特に、社長やベテランだけが分かる作業が増えると、人を増やしても楽になりません。」 |\n| **2週目** | 解決 | 「私は、そうした手作業や属人化している流れを整理し、LINE・Web・AIを使って、確認だけで回る仕組みに変える仕事をしています。いきなり大きなシステムではなく、現場の1つの困りごとから始めます。」 |\n| **3週目** | 紹介依頼 | 「今週は、建設業・製造業・店舗運営で、毎月の集計や現場報告を誰かが手でまとめていて、『人を増やす前に何とかしたい』と言っている社長・店長・事務責任者をご紹介ください。」 |\n\n### 今後の実践メモ\n\n- 1テーマを3週間で使い切る前提で、毎週違う商品説明をしすぎない。\n- 1週目は「悩みの言葉」、2週目は「変化の言葉」、3週目は「紹介先の条件」に集中する。\n- BOや121で「それなら誰々が困っていそう」と言われた表現は、翌週のプレゼンに反映する。\n- 6月23日の次廣メインプレゼン前は、この3週間配球を使って、聞き手に「紹介してほしい相手」を先に温めておく。\n\n---\n\n## 7. 5月度 ネットワーキングリーダー\n\n| 部門 | 受賞者 | 実績 |\n|------|--------|------|\n| **リファラル部門** | 平岡邦彦 | 44件 |\n| **ビジター招待部門** | 平山真由美 | 4名 |\n| **ワントゥーワン部門** | 増本重孝 | 67件 |\n| **サンキュー金額部門** | 久米佳代子 | 600万円 |\n| **教育ポイント部門** | 太田一誠 | 31ポイント |\n\n---\n\n## 8. ウィークリープレゼンテーション\n\n全メンバーが25秒以内で自己紹介と紹介希望先を発表した。カテゴリー順は、建設・不動産、中小企業サポート、ライフサポート、金融・保険、士業コンサル、IT、飲食・製造、ファッション・デザイン、美容・健康。\n\n新メンバーの原田沙織さんは、デジタルサイネージの販売代理店募集について1分間のスタートダッシュプレゼンを実施。看板屋さんや電気工事士との相性の良さを強調した。\n\n---\n\n## 9. メインプレゼン要点\n\n### 田渕恭平 — 高級石材・庵治石\n\n#### 会社・背景\n\n- 1883年創業、143年の歴史を持つ田渕石材株式会社の六代目後継者。\n- 元消防士としての経験から、「守りたい」という気持ちで家業を承継する決意を語った。\n- 日本最高級の花崗岩 **庵治石** を扱う。\n\n#### 事業の特徴\n\n| 観点 | 内容 |\n|------|------|\n| **素材** | 庵治石は「花崗岩のダイヤモンド」と呼ばれる日本最高級石材 |\n| **実績** | 首相官邸の玄関・中庭、ZOZOタウン前澤社長の自宅など |\n| **提供体制** | 採石から加工・販売まで一貫した垂直統合型。中間業者を介さず高品質な石材をフルオーダーで提供 |\n\n#### ビジョン\n\n「令和の時代に新たな石器時代を作る」という夢を掲げ、石と人の関係を構築することを目指している。墓石だけでなく、内装デザイン、インテリア、建築材として石の新しい使い方を体現し、展示会やSNSで発信を続けている。\n\n#### 紹介希望先\n\n- 一泊20万円以上の高級宿・ホテルの設計会社\n- 5億円以上の超高級住宅建設会社\n- 富裕層向けコミュニティ運営者\n- デザイナー\n\n---\n\n### 松倉健治 — エアロゲル透明断熱フィルム\n\n#### 会社・背景\n\n- 営業歴28年、ガラスフィルム職人歴15年。\n- 世界初のNASA認定断熱素材 **エアロゲル** を使用した窓ガラスフィルムを紹介。\n\n#### 製品の特徴\n\n| 観点 | 内容 |\n|------|------|\n| **省エネ** | 夏のエアコン電気代 約23%カット、冬のエアコン電気代 約21%カット |\n| **通年効果** | 従来の遮熱フィルムと異なり、夏・冬の両方で省エネ効果 |\n| **太陽角度への適応** | 夏場（90度）は約3割遮熱、冬場（30度）は約8%のみ遮熱して太陽熱を取り込む |\n| **透明性** | 施工箇所が視覚的にほとんど判別できない |\n| **UV対策** | UV99%以上カット |\n| **結露対策** | 冬場の結露を約10分の1に抑制 |\n| **受賞歴** | 建築材料協会の特別賞を受賞 |\n\n#### 災害対策機能\n\n台風・地震による窓ガラス飛散を防ぐ効果があり、コーティングにはない安全性能を提供する。千葉県の台風被害事例を挙げ、小石による窓ガラス破損から家全体を守る重要性を説明した。\n\n#### 施工実績・紹介希望先\n\n- 事務所施工で約12万円。窓際からの冷気がなくなったという顧客の声を紹介。\n- 紹介希望先は、窓が大きく電気代が高い施設、設計士、リゾートホテルなど。\n\n---\n\n## 10. リファラル発表\n\n| 項目 | 数値 |\n|------|------|\n| **リファラル合計** | **146件** |\n| **内部リファラル** | 16件 |\n| **外部リファラル** | 130件 |\n| **サンキュー金額** | 後日報告予定 |\n\n### 今週のベスト3\n\n| 順位 | 氏名 | 件数 |\n|------|------|------|\n| **1位** | 次廣淳 | 9件 |\n| **2位** | 増本重孝 / 平岡邦彦 | 各7件 |\n| **3位** | 越賀俊江 | 6件 |\n\n主なリファラル内容は、建設業者の紹介、コンサルティングサービスの紹介、商材購入、ワントゥーワン実施など。\n\n---\n\n## 11. 5月度 統計報告\n\n**報告:** 芳賀崇利バイスプレジデント\n\n| 指標 | 5月度 |\n|------|------|\n| **リファラル合計** | 338件（内部66・外部272） |\n| **ビジター総数** | 23名 |\n| **ワントゥーワン回数** | 741回 |\n| **サンキュー金額** | 2,181万3千円 |\n\n### 発足以来累計\n\n| 指標 | 累計 |\n|------|------|\n| **リファラル** | 27,190件 |\n| **ビジター** | 1,475名 |\n| **サンキュー金額** | 11億221万円 |\n| **1定例会あたりサンキュー金額** | 530万円 |\n\n---\n\n## 12. シェアストーリー\n\n**登壇者:** 中村圭吾（日本製ものづくり最高事業プロデューサー）  \n**BNI歴:** 3年10ヶ月\n\n全国のオーダースーツ業者とつながるために入会し、100社以上とのつながりを構築。BNIのビジョン「世界のビジネスのやり方を変える」を「自社のビジネスのやり方を変える」と置き換え、全国の日本製ものづくり会社と手を取り合う新たなスタートを切ったと共有した。\n\n将来の夢は、両国国技館で **「日本製の覚悟展」** を開催すること。\n\n---\n\n## 13. 推薦の言葉\n\n**推薦者:** 岡本智美  \n**対象:** 山本洸太\n\nデザインのコンサルティングを受けた結果、「ゴールに対しての方程式」を定めることでクオリティが向上し、単価が5倍に上がり、リピート率も増加したと報告された。\n\n山本さんは「デザインは正解を探すものではなく、自分なりの方程式を見つけていくのが楽しいところ」とコメントした。\n\n---\n\n## 14. リファラル真性度確認\n\n**対象:** 太田一誠 → 船津麻理子\n\n太田さんは、リージョンカンファレンスでつながった高気密高断熱住宅を手掛ける高橋さんを、医療系やサロンへの人脈を求めていた船津さんへ紹介した。\n\n船津さんからは、太田さんが事業内容をしっかり理解した上でつないでくれたため、ワントゥーワン中にご来店予約までいただけたと報告された。\n\n---\n\n## 15. プレゼント抽選\n\n| 提供者 | 商品 | 当選者 |\n|--------|------|--------|\n| **田渕恭平** | 庵治石にドラゴンフライのロゴを彫ったペン立て | 平岡さん |\n| **松倉健治** | ナイレのペン | 福士さん |\n\n---\n\n## 16. 入会案内\n\n**説明:** 岡本智美（書記兼会計）\n\n| 項目 | 内容 |\n|------|------|\n| **登録費** | 5万円 |\n| **プログラム利用料** | 19万円（税別） |\n| **申込手順** | 入金 → 申込書をメンバーシップ委員会へ提出 → 面談審査 |\n| **複数年契約割引** | 2年で8万円割引、5年で15万円割引 |\n| **チャプター運営費** | 毎月5,000円 |\n\n---\n\n## 17. 確認待ち事項・アクション\n\n### 確認待ち事項\n\n- 募集カテゴリー: コンサル業、ウェブマーケティング、中小企業診断士、コスト削減\n- 今後4週間のメインプレゼンテーション担当者スケジュール\n\n### アクションアイテム\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **倉持さん** | 新しい MacBook の購入検討 | 未定 |\n| **各メンバー** | ビジターへのフォローアップとワントゥーワン実施 | 早め |\n| **平岡さん・福士さん** | プレゼンターへ配送先情報を提供 | 早め |\n| **ビジター** | 入会検討時はアテンドメンバーへ質問・相談 | 随時 |\n\n---\n\n## 18. 次回以降の予定\n\n| 日付 | 内容 |\n|------|------|\n| **2026-06-20** | Hikaru様 5周年ライブ（東京） |\n| **2026-07-03〜07-04** | 日本製ものづくり事業者向け通信販売イベント（東京・有楽町） |\n| **次週以降** | メインプレゼンテーション担当者は決定済み（詳細確認待ち） |\n\n---\n\n## 19. 閉会\n\n平山真由美プレジデントより、ビジターへの感謝とBNIの価値について総括が行われた。\n\n「誰かの成功を願い、誰かのために行動し、仲間と共に成長していく」というチャプター文化が強調され、新しい場所へ足を運ぶ勇気と、仲間として共にビジョンを叶えていくことの重要性が語られた。\n\nビジターは個別の部屋でアテンドメンバーとの質疑応答へ移動し、アンケートへの協力が依頼された。\n\n---\n\n## 20. 次廣視点の振り返りメモ\n\n### 自分の成果\n\n- 今週のリファラル **9件** で第1位。\n- 6月23日の自分のメインプレゼンに向けて、田渕さん・松倉さんの紹介希望先の具体性、ビジョンの出し方、製品価値の見せ方を参考にできる。\n\n### フォロー・1to1候補\n\n| 候補 | 接点 |\n|------|------|\n| **門脇唯さん / 中西優斗さん** | SNS・YouTubeマーケティング。tugilo の予約・LINE・業務改善導線との連携余地 |\n| **林田直也さん** | 販管費削減。固定費削減後の業務効率化・DX導線で相性あり |\n| **溝渕剛彦さん** | 中小企業診断士。補助金・経営改善・資金調達文脈で協業余地 |\n| **松倉健治さん** | エアロゲルフィルム。過去1to1済み。高級リゾートホテル・設計士紹介導線を再確認 |\n| **田渕恭平さん** | 高級石材。富裕層・設計・ホテル・デザイン系紹介先の整理対象 |\n\n### 学び\n\n- 30秒プレゼンは単発ではなく、3週間で「課題 → 解決策 → 紹介希望先」を組み立てる。\n- メインプレゼンでは、商品説明だけでなく、承継背景・ビジョン・紹介してほしい相手の条件をセットで伝えると記憶に残りやすい。\n- 「伝統と革新」は、自分の AI 業務改善の説明でも、既存の仕事・現場文化を壊すのではなく、良い部分を残して更新する文脈として使える。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-02 14:21 | Zoom 文字起こし要約をもとに初版作成 |','docs/meetings/chapter/chapter_weekly_20260602.md','chapter_weekly','2026-06-02','08:00-10:00','DragonFly 定例枠（火曜）。開始・終了の正確な時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-02）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":210,\"session_date\":\"2026-06-02\",\"session_time_jst\":\"08:00-10:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306e\\u6b63\\u78ba\\u306a\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-02\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260601\\/dragonfly_210_20260602_all_full.csv\"]}','2026-06-02 15:39:21','2026-06-02 15:39:21','2026-06-02 15:39:21');
/*!40000 ALTER TABLE `meeting_minutes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_participant_imports`
--

DROP TABLE IF EXISTS `meeting_participant_imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_participant_imports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `file_path` varchar(512) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'uploaded',
  `parsed_at` timestamp NULL DEFAULT NULL,
  `parse_status` varchar(20) NOT NULL DEFAULT 'pending',
  `extracted_text` longtext DEFAULT NULL,
  `extracted_result` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extracted_result`)),
  `imported_at` datetime DEFAULT NULL,
  `applied_count` int(10) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meeting_participant_imports_meeting_id_unique` (`meeting_id`),
  CONSTRAINT `meeting_participant_imports_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_participant_imports`
--

LOCK TABLES `meeting_participant_imports` WRITE;
/*!40000 ALTER TABLE `meeting_participant_imports` DISABLE KEYS */;
INSERT INTO `meeting_participant_imports` VALUES
(1,3,'meeting_participant_imports/3/8c7b5848-8489-44c3-a797-9ce9c19afaa9.pdf','定例会参加者リスト2026_03_17.pdf','uploaded','2026-03-18 07:45:49','success','BNI東京N.E.リージョン　　BNI　DragonFly\n第201回　2026/03/17\nBNI　DragonFly メンバー表\nNo.名前	よみがな	カテゴリー	役職	備考\n建設・不動産　\n1平岡　国彦	ひらおか　くにひこ\n千葉県成田市\n大型物件対応解体工事\n2増本　重孝	ますもと　しげたか\n静岡県島田市\n虫が建物に近寄らない害虫ブロック	BODコーディネーター/メンターサポー\nト\n3長谷川　貴志	はせがわ　たかし\n新潟県加茂市\n空き家問題を解決する不動産屋	BCP担当、対面イベントサポート\n4松倉　健治	まつくら　けんじ\n千葉県松戸市\nエアロゲル透明断熱フィルム\nAerogel Transparent Heat insulating Film\nビジターホストコーディネーター\n5福上　大輝	ふくがみ　たいき\n静岡県浜松市\n自宅で開業にちょうどいい小屋	プレジデント\n6太田　一誠	おおた　いっせい\nOhta Issei\nファインバブル（住宅設備機器）販売\n7高野　和義	たかの　かずよし\n千葉県袖ケ浦市\n足場部材販売\n中小企業サポート　\n8福士　利明	ふくし　としあき\n栃木県足利市\n日本企業からの海外専門安心物流	トレーニングサポート\n9後藤　岳久	ごとう　たけひさ\n静岡県島田市\n出張手配専門旅行会社\nTravel agency specializing in business trips\n対面イベントサポート\n10倉持　賢一	くらもち　けんいち\n埼玉県秩父市\n中国向け物販支援\nChina Marketing Support\nWEBマスター\n11岡元　智美	おかもと　ともみ\n福岡県筑後市\n勝てるプレゼン資料伈	1to1担当・書記兼会計補佐\n12西浦　雅	にしうら　みやび\n静岡県藤枝市\n外構工事特化型SNS集客	エデュケーションコーディネーター・O\nCCサポート\n13芳賀　崇利	はが　たかとし\n2\n地域情報サイト運営	イベント担当（フォーラム）\n\nBNI東京N.E.リージョン BNI　DragonFly\n第201回　2026/03/17\nBNI　DragonFly ミーティング参加者\nNo. お名前（敬称略）	お名前（ふりがな）	カテゴリー	紹介者	アテンド	オリエン	備考\nビジター様\n01帆苅　有希	ほかり　あき	toB向けビジネススクール	芳賀　崇利	平岡　国彦\n船津　麻理子\n佐藤　拓斗\n平岡　国彦\n02藤井　寛幸	ふじい　ひろゆき	健康支援サービス	里見　允二	廣田　誠悟\n横山　尚武\n今村　千絵\n廣田　誠悟\n03後藤　和樹	ごとう　かずき	ゲーム・ホビー・メディア専門買取	渡邊　真大	加藤　隆太\n吉田　俊之\n吉田　俊之\n04伊藤　剛志	いとう　たけし	ニッチナンバーワンプロデューサー	渡邊　真大	小中　貴晃\n山本　洸太\n立岡　海人\n小中　貴晃\n山本　洸太\n05福山　結花	ふくやま　ゆか	高齢者向けアプリ	渡邊　真大	渡邊　真大\n山本　三那子\n大竹　絵理香\n渡邊　真大\n山本　三那子\n06渡部　真知子	わたべ　まちこ	不動産管理　民泊	渡邊　真大	中村　啓吾\n木村　健悟\n長谷川　貴志\n中村　啓吾\n07吉川　昂伸	よしかわ　こうしん	古物商	渡邊　真大	越賀　淑恵\n槇村　翔磨\n越賀　淑恵\n08安信　みお	やすのぶ　みお	金融・クルーズ事業	渡邊　真大	竹内　駿太\n紀川　和弘\n竹内　駿太\n09淺倉　隆志	あさくら　たかし	ビューティービズサロン（コワーキング\nスペース＆レンタルサロン複合型施設F\nC本部）\n飯田　千帆	海沼　功\n佐久間　康丞\n望月　雅幸\n海沼　功\n10山本　葉子	やまもと　ようこ	ビジネスカード	増本　重孝	増本　重孝\n後藤　岳久\n西岡　優希\n増本　重孝\n11熊谷　紘樹	くまがい　ひろき	屋根工事業	畠山　憲之	畠山　憲之\n高野　和義\n福上　大輝\n畠山　憲之\n6\n\n12村上　彩子	むらかみ　あやこ	サステナビリティ×パーパス経営　研修	梅澤　朗広	梅澤　朗広\n飯田　千帆\n山口　薫\n梅澤　朗広\n13草野　修一	くさの　しゅういち	伐採・草刈り	倉持　賢一	倉持　賢一\n藤井　恵理子\n田渕　恭平\n倉持　賢一\n14只野　優子	ただの　ゆうこ	フェムケア	清原　佳彩美 今西　俊明\n清原　佳彩美\n次廣　淳\n今西　俊明\n清原　佳彩美\n15木村　篤樹	きむら　あつき	珈琲豆の「食べる資源化」クラウドファ\nンディング\n梅澤　朗広	里見　允二\n飯田　香\n里見　允二\n代理出席者様\n01西野入　直輝	にしのいり　なおき	シングルマザー専門事業コンシェルジュ	平山　真由美\n02小柳　真理子	こやなぎ　まりこ	エアロゲル透明断熱フィルム	松倉　健治\n03岡村　健美	おかむら　たけみ	ファインバブル（住宅設備機器）販売	太田 　一誠\nゲスト様\n01松居　外志美	まつい　としみ	応用脳科学を使った企業研修講師	舩杉　牧子	舩杉　牧子\n芳賀　崇利\n軍司　敦哉\n舩杉　牧子\n02八木　隆明	やぎ　たかあき	着物監修家/再生・オーダーディレクター	渡邊　真大	岡元　智美\n福士　利明\n岡元　智美\n7','{\"candidates\":[{\"name\":\"BNI\\u6771\\u4eacN.E.\\u30ea\\u30fc\\u30b8\\u30e7\\u30f3\\u3000\\u3000BNI\\u3000DragonFly\",\"raw_line\":\"BNI\\u6771\\u4eacN.E.\\u30ea\\u30fc\\u30b8\\u30e7\\u30f3\\u3000\\u3000BNI\\u3000DragonFly\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u7b2c201\\u56de\\u30002026\\/03\\/17\",\"raw_line\":\"\\u7b2c201\\u56de\\u30002026\\/03\\/17\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"1\\u5e73\\u5ca1\\u3000\\u56fd\\u5f66\\t\\u3072\\u3089\\u304a\\u304b\\u3000\\u304f\\u306b\\u3072\\u3053\",\"raw_line\":\"1\\u5e73\\u5ca1\\u3000\\u56fd\\u5f66\\t\\u3072\\u3089\\u304a\\u304b\\u3000\\u304f\\u306b\\u3072\\u3053\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5343\\u8449\\u770c\\u6210\\u7530\\u5e02\",\"raw_line\":\"\\u5343\\u8449\\u770c\\u6210\\u7530\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5927\\u578b\\u7269\\u4ef6\\u5bfe\\u5fdc\\u89e3\\u4f53\\u5de5\\u4e8b\",\"raw_line\":\"\\u5927\\u578b\\u7269\\u4ef6\\u5bfe\\u5fdc\\u89e3\\u4f53\\u5de5\\u4e8b\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"2\\u5897\\u672c\\u3000\\u91cd\\u5b5d\\t\\u307e\\u3059\\u3082\\u3068\\u3000\\u3057\\u3052\\u305f\\u304b\",\"raw_line\":\"2\\u5897\\u672c\\u3000\\u91cd\\u5b5d\\t\\u307e\\u3059\\u3082\\u3068\\u3000\\u3057\\u3052\\u305f\\u304b\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u9759\\u5ca1\\u770c\\u5cf6\\u7530\\u5e02\",\"raw_line\":\"\\u9759\\u5ca1\\u770c\\u5cf6\\u7530\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u866b\\u304c\\u5efa\\u7269\\u306b\\u8fd1\\u5bc4\\u3089\\u306a\\u3044\\u5bb3\\u866b\\u30d6\\u30ed\\u30c3\\u30af\\tBOD\\u30b3\\u30fc\\u30c7\\u30a3\\u30cd\\u30fc\\u30bf\\u30fc\\/\\u30e1\\u30f3\\u30bf\\u30fc\\u30b5\\u30dd\\u30fc\",\"raw_line\":\"\\u866b\\u304c\\u5efa\\u7269\\u306b\\u8fd1\\u5bc4\\u3089\\u306a\\u3044\\u5bb3\\u866b\\u30d6\\u30ed\\u30c3\\u30af\\tBOD\\u30b3\\u30fc\\u30c7\\u30a3\\u30cd\\u30fc\\u30bf\\u30fc\\/\\u30e1\\u30f3\\u30bf\\u30fc\\u30b5\\u30dd\\u30fc\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"3\\u9577\\u8c37\\u5ddd\\u3000\\u8cb4\\u5fd7\\t\\u306f\\u305b\\u304c\\u308f\\u3000\\u305f\\u304b\\u3057\",\"raw_line\":\"3\\u9577\\u8c37\\u5ddd\\u3000\\u8cb4\\u5fd7\\t\\u306f\\u305b\\u304c\\u308f\\u3000\\u305f\\u304b\\u3057\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u65b0\\u6f5f\\u770c\\u52a0\\u8302\\u5e02\",\"raw_line\":\"\\u65b0\\u6f5f\\u770c\\u52a0\\u8302\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u7a7a\\u304d\\u5bb6\\u554f\\u984c\\u3092\\u89e3\\u6c7a\\u3059\\u308b\\u4e0d\\u52d5\\u7523\\u5c4b\\tBCP\\u62c5\\u5f53\\u3001\\u5bfe\\u9762\\u30a4\\u30d9\\u30f3\\u30c8\\u30b5\\u30dd\\u30fc\\u30c8\",\"raw_line\":\"\\u7a7a\\u304d\\u5bb6\\u554f\\u984c\\u3092\\u89e3\\u6c7a\\u3059\\u308b\\u4e0d\\u52d5\\u7523\\u5c4b\\tBCP\\u62c5\\u5f53\\u3001\\u5bfe\\u9762\\u30a4\\u30d9\\u30f3\\u30c8\\u30b5\\u30dd\\u30fc\\u30c8\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"4\\u677e\\u5009\\u3000\\u5065\\u6cbb\\t\\u307e\\u3064\\u304f\\u3089\\u3000\\u3051\\u3093\\u3058\",\"raw_line\":\"4\\u677e\\u5009\\u3000\\u5065\\u6cbb\\t\\u307e\\u3064\\u304f\\u3089\\u3000\\u3051\\u3093\\u3058\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5343\\u8449\\u770c\\u677e\\u6238\\u5e02\",\"raw_line\":\"\\u5343\\u8449\\u770c\\u677e\\u6238\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u30a8\\u30a2\\u30ed\\u30b2\\u30eb\\u900f\\u660e\\u65ad\\u71b1\\u30d5\\u30a3\\u30eb\\u30e0\",\"raw_line\":\"\\u30a8\\u30a2\\u30ed\\u30b2\\u30eb\\u900f\\u660e\\u65ad\\u71b1\\u30d5\\u30a3\\u30eb\\u30e0\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"Aerogel Transparent Heat insulating Film\",\"raw_line\":\"Aerogel Transparent Heat insulating Film\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u30d3\\u30b8\\u30bf\\u30fc\\u30db\\u30b9\\u30c8\\u30b3\\u30fc\\u30c7\\u30a3\\u30cd\\u30fc\\u30bf\\u30fc\",\"raw_line\":\"\\u30d3\\u30b8\\u30bf\\u30fc\\u30db\\u30b9\\u30c8\\u30b3\\u30fc\\u30c7\\u30a3\\u30cd\\u30fc\\u30bf\\u30fc\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"5\\u798f\\u4e0a\\u3000\\u5927\\u8f1d\\t\\u3075\\u304f\\u304c\\u307f\\u3000\\u305f\\u3044\\u304d\",\"raw_line\":\"5\\u798f\\u4e0a\\u3000\\u5927\\u8f1d\\t\\u3075\\u304f\\u304c\\u307f\\u3000\\u305f\\u3044\\u304d\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u9759\\u5ca1\\u770c\\u6d5c\\u677e\\u5e02\",\"raw_line\":\"\\u9759\\u5ca1\\u770c\\u6d5c\\u677e\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u81ea\\u5b85\\u3067\\u958b\\u696d\\u306b\\u3061\\u3087\\u3046\\u3069\\u3044\\u3044\\u5c0f\\u5c4b\\t\\u30d7\\u30ec\\u30b8\\u30c7\\u30f3\\u30c8\",\"raw_line\":\"\\u81ea\\u5b85\\u3067\\u958b\\u696d\\u306b\\u3061\\u3087\\u3046\\u3069\\u3044\\u3044\\u5c0f\\u5c4b\\t\\u30d7\\u30ec\\u30b8\\u30c7\\u30f3\\u30c8\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"6\\u592a\\u7530\\u3000\\u4e00\\u8aa0\\t\\u304a\\u304a\\u305f\\u3000\\u3044\\u3063\\u305b\\u3044\",\"raw_line\":\"6\\u592a\\u7530\\u3000\\u4e00\\u8aa0\\t\\u304a\\u304a\\u305f\\u3000\\u3044\\u3063\\u305b\\u3044\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"Ohta Issei\",\"raw_line\":\"Ohta Issei\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u30d5\\u30a1\\u30a4\\u30f3\\u30d0\\u30d6\\u30eb\\uff08\\u4f4f\\u5b85\\u8a2d\\u5099\\u6a5f\\u5668\\uff09\\u8ca9\\u58f2\",\"raw_line\":\"\\u30d5\\u30a1\\u30a4\\u30f3\\u30d0\\u30d6\\u30eb\\uff08\\u4f4f\\u5b85\\u8a2d\\u5099\\u6a5f\\u5668\\uff09\\u8ca9\\u58f2\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"7\\u9ad8\\u91ce\\u3000\\u548c\\u7fa9\\t\\u305f\\u304b\\u306e\\u3000\\u304b\\u305a\\u3088\\u3057\",\"raw_line\":\"7\\u9ad8\\u91ce\\u3000\\u548c\\u7fa9\\t\\u305f\\u304b\\u306e\\u3000\\u304b\\u305a\\u3088\\u3057\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5343\\u8449\\u770c\\u8896\\u30b1\\u6d66\\u5e02\",\"raw_line\":\"\\u5343\\u8449\\u770c\\u8896\\u30b1\\u6d66\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u8db3\\u5834\\u90e8\\u6750\\u8ca9\\u58f2\",\"raw_line\":\"\\u8db3\\u5834\\u90e8\\u6750\\u8ca9\\u58f2\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u4e2d\\u5c0f\\u4f01\\u696d\\u30b5\\u30dd\\u30fc\\u30c8\\u3000\",\"raw_line\":\"\\u4e2d\\u5c0f\\u4f01\\u696d\\u30b5\\u30dd\\u30fc\\u30c8\\u3000\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"8\\u798f\\u58eb\\u3000\\u5229\\u660e\\t\\u3075\\u304f\\u3057\\u3000\\u3068\\u3057\\u3042\\u304d\",\"raw_line\":\"8\\u798f\\u58eb\\u3000\\u5229\\u660e\\t\\u3075\\u304f\\u3057\\u3000\\u3068\\u3057\\u3042\\u304d\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u6803\\u6728\\u770c\\u8db3\\u5229\\u5e02\",\"raw_line\":\"\\u6803\\u6728\\u770c\\u8db3\\u5229\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u65e5\\u672c\\u4f01\\u696d\\u304b\\u3089\\u306e\\u6d77\\u5916\\u5c02\\u9580\\u5b89\\u5fc3\\u7269\\u6d41\\t\\u30c8\\u30ec\\u30fc\\u30cb\\u30f3\\u30b0\\u30b5\\u30dd\\u30fc\\u30c8\",\"raw_line\":\"\\u65e5\\u672c\\u4f01\\u696d\\u304b\\u3089\\u306e\\u6d77\\u5916\\u5c02\\u9580\\u5b89\\u5fc3\\u7269\\u6d41\\t\\u30c8\\u30ec\\u30fc\\u30cb\\u30f3\\u30b0\\u30b5\\u30dd\\u30fc\\u30c8\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"9\\u5f8c\\u85e4\\u3000\\u5cb3\\u4e45\\t\\u3054\\u3068\\u3046\\u3000\\u305f\\u3051\\u3072\\u3055\",\"raw_line\":\"9\\u5f8c\\u85e4\\u3000\\u5cb3\\u4e45\\t\\u3054\\u3068\\u3046\\u3000\\u305f\\u3051\\u3072\\u3055\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u9759\\u5ca1\\u770c\\u5cf6\\u7530\\u5e02\",\"raw_line\":\"\\u9759\\u5ca1\\u770c\\u5cf6\\u7530\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u51fa\\u5f35\\u624b\\u914d\\u5c02\\u9580\\u65c5\\u884c\\u4f1a\\u793e\",\"raw_line\":\"\\u51fa\\u5f35\\u624b\\u914d\\u5c02\\u9580\\u65c5\\u884c\\u4f1a\\u793e\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"Travel agency specializing in business trips\",\"raw_line\":\"Travel agency specializing in business trips\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5bfe\\u9762\\u30a4\\u30d9\\u30f3\\u30c8\\u30b5\\u30dd\\u30fc\\u30c8\",\"raw_line\":\"\\u5bfe\\u9762\\u30a4\\u30d9\\u30f3\\u30c8\\u30b5\\u30dd\\u30fc\\u30c8\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"10\\u5009\\u6301\\u3000\\u8ce2\\u4e00\\t\\u304f\\u3089\\u3082\\u3061\\u3000\\u3051\\u3093\\u3044\\u3061\",\"raw_line\":\"10\\u5009\\u6301\\u3000\\u8ce2\\u4e00\\t\\u304f\\u3089\\u3082\\u3061\\u3000\\u3051\\u3093\\u3044\\u3061\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u57fc\\u7389\\u770c\\u79e9\\u7236\\u5e02\",\"raw_line\":\"\\u57fc\\u7389\\u770c\\u79e9\\u7236\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u4e2d\\u56fd\\u5411\\u3051\\u7269\\u8ca9\\u652f\\u63f4\",\"raw_line\":\"\\u4e2d\\u56fd\\u5411\\u3051\\u7269\\u8ca9\\u652f\\u63f4\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"China Marketing Support\",\"raw_line\":\"China Marketing Support\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"WEB\\u30de\\u30b9\\u30bf\\u30fc\",\"raw_line\":\"WEB\\u30de\\u30b9\\u30bf\\u30fc\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"11\\u5ca1\\u5143\\u3000\\u667a\\u7f8e\\t\\u304a\\u304b\\u3082\\u3068\\u3000\\u3068\\u3082\\u307f\",\"raw_line\":\"11\\u5ca1\\u5143\\u3000\\u667a\\u7f8e\\t\\u304a\\u304b\\u3082\\u3068\\u3000\\u3068\\u3082\\u307f\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u798f\\u5ca1\\u770c\\u7b51\\u5f8c\\u5e02\",\"raw_line\":\"\\u798f\\u5ca1\\u770c\\u7b51\\u5f8c\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u52dd\\u3066\\u308b\\u30d7\\u30ec\\u30bc\\u30f3\\u8cc7\\u6599\\u4f08\\u0010\\t1to1\\u62c5\\u5f53\\u30fb\\u66f8\\u8a18\\u517c\\u4f1a\\u8a08\\u88dc\\u4f50\",\"raw_line\":\"\\u52dd\\u3066\\u308b\\u30d7\\u30ec\\u30bc\\u30f3\\u8cc7\\u6599\\u4f08\\u0010\\t1to1\\u62c5\\u5f53\\u30fb\\u66f8\\u8a18\\u517c\\u4f1a\\u8a08\\u88dc\\u4f50\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"12\\u897f\\u6d66\\u3000\\u96c5\\t\\u306b\\u3057\\u3046\\u3089\\u3000\\u307f\\u3084\\u3073\",\"raw_line\":\"12\\u897f\\u6d66\\u3000\\u96c5\\t\\u306b\\u3057\\u3046\\u3089\\u3000\\u307f\\u3084\\u3073\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u9759\\u5ca1\\u770c\\u85e4\\u679d\\u5e02\",\"raw_line\":\"\\u9759\\u5ca1\\u770c\\u85e4\\u679d\\u5e02\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5916\\u69cb\\u5de5\\u4e8b\\u7279\\u5316\\u578bSNS\\u96c6\\u5ba2\\t\\u30a8\\u30c7\\u30e5\\u30b1\\u30fc\\u30b7\\u30e7\\u30f3\\u30b3\\u30fc\\u30c7\\u30a3\\u30cd\\u30fc\\u30bf\\u30fc\\u30fbO\",\"raw_line\":\"\\u5916\\u69cb\\u5de5\\u4e8b\\u7279\\u5316\\u578bSNS\\u96c6\\u5ba2\\t\\u30a8\\u30c7\\u30e5\\u30b1\\u30fc\\u30b7\\u30e7\\u30f3\\u30b3\\u30fc\\u30c7\\u30a3\\u30cd\\u30fc\\u30bf\\u30fc\\u30fbO\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"CC\\u30b5\\u30dd\\u30fc\\u30c8\",\"raw_line\":\"CC\\u30b5\\u30dd\\u30fc\\u30c8\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"13\\u82b3\\u8cc0\\u3000\\u5d07\\u5229\\t\\u306f\\u304c\\u3000\\u305f\\u304b\\u3068\\u3057\",\"raw_line\":\"13\\u82b3\\u8cc0\\u3000\\u5d07\\u5229\\t\\u306f\\u304c\\u3000\\u305f\\u304b\\u3068\\u3057\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"\\u5730\\u57df\\u60c5\\u5831\\u30b5\\u30a4\\u30c8\\u904b\\u55b6\\t\\u30a4\\u30d9\\u30f3\\u30c8\\u62c5\\u5f53\\uff08\\u30d5\\u30a9\\u30fc\\u30e9\\u30e0\\uff09\",\"raw_line\":\"\\u5730\\u57df\\u60c5\\u5831\\u30b5\\u30a4\\u30c8\\u904b\\u55b6\\t\\u30a4\\u30d9\\u30f3\\u30c8\\u62c5\\u5f53\\uff08\\u30d5\\u30a9\\u30fc\\u30e9\\u30e0\\uff09\",\"type_hint\":\"regular\",\"page_type\":\"members\",\"source_section\":null},{\"name\":\"BNI\\u6771\\u4eacN.E.\\u30ea\\u30fc\\u30b8\\u30e7\\u30f3 BNI\\u3000DragonFly\",\"raw_line\":\"BNI\\u6771\\u4eacN.E.\\u30ea\\u30fc\\u30b8\\u30e7\\u30f3 BNI\\u3000DragonFly\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u7b2c201\\u56de\\u30002026\\/03\\/17\",\"raw_line\":\"\\u7b2c201\\u56de\\u30002026\\/03\\/17\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"No. \\u304a\\u540d\\u524d\\uff08\\u656c\\u79f0\\u7565\\uff09\\t\\u304a\\u540d\\u524d\\uff08\\u3075\\u308a\\u304c\\u306a\\uff09\\t\\u30ab\\u30c6\\u30b4\\u30ea\\u30fc\\t\\u7d39\\u4ecb\\u8005\\t\\u30a2\\u30c6\\u30f3\\u30c9\\t\\u30aa\\u30ea\\u30a8\\u30f3\\t\\u5099\\u8003\",\"raw_line\":\"No. \\u304a\\u540d\\u524d\\uff08\\u656c\\u79f0\\u7565\\uff09\\t\\u304a\\u540d\\u524d\\uff08\\u3075\\u308a\\u304c\\u306a\\uff09\\t\\u30ab\\u30c6\\u30b4\\u30ea\\u30fc\\t\\u7d39\\u4ecb\\u8005\\t\\u30a2\\u30c6\\u30f3\\u30c9\\t\\u30aa\\u30ea\\u30a8\\u30f3\\t\\u5099\\u8003\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"01\\u5e06\\u82c5\\u3000\\u6709\\u5e0c\\t\\u307b\\u304b\\u308a\\u3000\\u3042\\u304d\\ttoB\\u5411\\u3051\\u30d3\\u30b8\\u30cd\\u30b9\\u30b9\\u30af\\u30fc\\u30eb\\t\\u82b3\\u8cc0\\u3000\\u5d07\\u5229\\t\\u5e73\\u5ca1\\u3000\\u56fd\\u5f66\",\"raw_line\":\"01\\u5e06\\u82c5\\u3000\\u6709\\u5e0c\\t\\u307b\\u304b\\u308a\\u3000\\u3042\\u304d\\ttoB\\u5411\\u3051\\u30d3\\u30b8\\u30cd\\u30b9\\u30b9\\u30af\\u30fc\\u30eb\\t\\u82b3\\u8cc0\\u3000\\u5d07\\u5229\\t\\u5e73\\u5ca1\\u3000\\u56fd\\u5f66\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u8239\\u6d25\\u3000\\u9ebb\\u7406\\u5b50\",\"raw_line\":\"\\u8239\\u6d25\\u3000\\u9ebb\\u7406\\u5b50\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u4f50\\u85e4\\u3000\\u62d3\\u6597\",\"raw_line\":\"\\u4f50\\u85e4\\u3000\\u62d3\\u6597\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5e73\\u5ca1\\u3000\\u56fd\\u5f66\",\"raw_line\":\"\\u5e73\\u5ca1\\u3000\\u56fd\\u5f66\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"02\\u85e4\\u4e95\\u3000\\u5bdb\\u5e78\\t\\u3075\\u3058\\u3044\\u3000\\u3072\\u308d\\u3086\\u304d\\t\\u5065\\u5eb7\\u652f\\u63f4\\u30b5\\u30fc\\u30d3\\u30b9\\t\\u91cc\\u898b\\u3000\\u5141\\u4e8c\\t\\u5ee3\\u7530\\u3000\\u8aa0\\u609f\",\"raw_line\":\"02\\u85e4\\u4e95\\u3000\\u5bdb\\u5e78\\t\\u3075\\u3058\\u3044\\u3000\\u3072\\u308d\\u3086\\u304d\\t\\u5065\\u5eb7\\u652f\\u63f4\\u30b5\\u30fc\\u30d3\\u30b9\\t\\u91cc\\u898b\\u3000\\u5141\\u4e8c\\t\\u5ee3\\u7530\\u3000\\u8aa0\\u609f\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u6a2a\\u5c71\\u3000\\u5c1a\\u6b66\",\"raw_line\":\"\\u6a2a\\u5c71\\u3000\\u5c1a\\u6b66\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u4eca\\u6751\\u3000\\u5343\\u7d75\",\"raw_line\":\"\\u4eca\\u6751\\u3000\\u5343\\u7d75\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5ee3\\u7530\\u3000\\u8aa0\\u609f\",\"raw_line\":\"\\u5ee3\\u7530\\u3000\\u8aa0\\u609f\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"03\\u5f8c\\u85e4\\u3000\\u548c\\u6a39\\t\\u3054\\u3068\\u3046\\u3000\\u304b\\u305a\\u304d\\t\\u30b2\\u30fc\\u30e0\\u30fb\\u30db\\u30d3\\u30fc\\u30fb\\u30e1\\u30c7\\u30a3\\u30a2\\u5c02\\u9580\\u8cb7\\u53d6\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u52a0\\u85e4\\u3000\\u9686\\u592a\",\"raw_line\":\"03\\u5f8c\\u85e4\\u3000\\u548c\\u6a39\\t\\u3054\\u3068\\u3046\\u3000\\u304b\\u305a\\u304d\\t\\u30b2\\u30fc\\u30e0\\u30fb\\u30db\\u30d3\\u30fc\\u30fb\\u30e1\\u30c7\\u30a3\\u30a2\\u5c02\\u9580\\u8cb7\\u53d6\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u52a0\\u85e4\\u3000\\u9686\\u592a\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5409\\u7530\\u3000\\u4fca\\u4e4b\",\"raw_line\":\"\\u5409\\u7530\\u3000\\u4fca\\u4e4b\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5409\\u7530\\u3000\\u4fca\\u4e4b\",\"raw_line\":\"\\u5409\\u7530\\u3000\\u4fca\\u4e4b\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"04\\u4f0a\\u85e4\\u3000\\u525b\\u5fd7\\t\\u3044\\u3068\\u3046\\u3000\\u305f\\u3051\\u3057\\t\\u30cb\\u30c3\\u30c1\\u30ca\\u30f3\\u30d0\\u30fc\\u30ef\\u30f3\\u30d7\\u30ed\\u30c7\\u30e5\\u30fc\\u30b5\\u30fc\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u5c0f\\u4e2d\\u3000\\u8cb4\\u6643\",\"raw_line\":\"04\\u4f0a\\u85e4\\u3000\\u525b\\u5fd7\\t\\u3044\\u3068\\u3046\\u3000\\u305f\\u3051\\u3057\\t\\u30cb\\u30c3\\u30c1\\u30ca\\u30f3\\u30d0\\u30fc\\u30ef\\u30f3\\u30d7\\u30ed\\u30c7\\u30e5\\u30fc\\u30b5\\u30fc\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u5c0f\\u4e2d\\u3000\\u8cb4\\u6643\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5c71\\u672c\\u3000\\u6d38\\u592a\",\"raw_line\":\"\\u5c71\\u672c\\u3000\\u6d38\\u592a\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u7acb\\u5ca1\\u3000\\u6d77\\u4eba\",\"raw_line\":\"\\u7acb\\u5ca1\\u3000\\u6d77\\u4eba\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5c0f\\u4e2d\\u3000\\u8cb4\\u6643\",\"raw_line\":\"\\u5c0f\\u4e2d\\u3000\\u8cb4\\u6643\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5c71\\u672c\\u3000\\u6d38\\u592a\",\"raw_line\":\"\\u5c71\\u672c\\u3000\\u6d38\\u592a\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"05\\u798f\\u5c71\\u3000\\u7d50\\u82b1\\t\\u3075\\u304f\\u3084\\u307e\\u3000\\u3086\\u304b\\t\\u9ad8\\u9f62\\u8005\\u5411\\u3051\\u30a2\\u30d7\\u30ea\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\",\"raw_line\":\"05\\u798f\\u5c71\\u3000\\u7d50\\u82b1\\t\\u3075\\u304f\\u3084\\u307e\\u3000\\u3086\\u304b\\t\\u9ad8\\u9f62\\u8005\\u5411\\u3051\\u30a2\\u30d7\\u30ea\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5c71\\u672c\\u3000\\u4e09\\u90a3\\u5b50\",\"raw_line\":\"\\u5c71\\u672c\\u3000\\u4e09\\u90a3\\u5b50\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5927\\u7af9\\u3000\\u7d75\\u7406\\u9999\",\"raw_line\":\"\\u5927\\u7af9\\u3000\\u7d75\\u7406\\u9999\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u6e21\\u908a\\u3000\\u771f\\u5927\",\"raw_line\":\"\\u6e21\\u908a\\u3000\\u771f\\u5927\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5c71\\u672c\\u3000\\u4e09\\u90a3\\u5b50\",\"raw_line\":\"\\u5c71\\u672c\\u3000\\u4e09\\u90a3\\u5b50\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"06\\u6e21\\u90e8\\u3000\\u771f\\u77e5\\u5b50\\t\\u308f\\u305f\\u3079\\u3000\\u307e\\u3061\\u3053\\t\\u4e0d\\u52d5\\u7523\\u7ba1\\u7406\\u3000\\u6c11\\u6cca\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u4e2d\\u6751\\u3000\\u5553\\u543e\",\"raw_line\":\"06\\u6e21\\u90e8\\u3000\\u771f\\u77e5\\u5b50\\t\\u308f\\u305f\\u3079\\u3000\\u307e\\u3061\\u3053\\t\\u4e0d\\u52d5\\u7523\\u7ba1\\u7406\\u3000\\u6c11\\u6cca\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u4e2d\\u6751\\u3000\\u5553\\u543e\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u6728\\u6751\\u3000\\u5065\\u609f\",\"raw_line\":\"\\u6728\\u6751\\u3000\\u5065\\u609f\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u9577\\u8c37\\u5ddd\\u3000\\u8cb4\\u5fd7\",\"raw_line\":\"\\u9577\\u8c37\\u5ddd\\u3000\\u8cb4\\u5fd7\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u4e2d\\u6751\\u3000\\u5553\\u543e\",\"raw_line\":\"\\u4e2d\\u6751\\u3000\\u5553\\u543e\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"07\\u5409\\u5ddd\\u3000\\u6602\\u4f38\\t\\u3088\\u3057\\u304b\\u308f\\u3000\\u3053\\u3046\\u3057\\u3093\\t\\u53e4\\u7269\\u5546\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u8d8a\\u8cc0\\u3000\\u6dd1\\u6075\",\"raw_line\":\"07\\u5409\\u5ddd\\u3000\\u6602\\u4f38\\t\\u3088\\u3057\\u304b\\u308f\\u3000\\u3053\\u3046\\u3057\\u3093\\t\\u53e4\\u7269\\u5546\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u8d8a\\u8cc0\\u3000\\u6dd1\\u6075\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u69c7\\u6751\\u3000\\u7fd4\\u78e8\",\"raw_line\":\"\\u69c7\\u6751\\u3000\\u7fd4\\u78e8\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u8d8a\\u8cc0\\u3000\\u6dd1\\u6075\",\"raw_line\":\"\\u8d8a\\u8cc0\\u3000\\u6dd1\\u6075\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"08\\u5b89\\u4fe1\\u3000\\u307f\\u304a\\t\\u3084\\u3059\\u306e\\u3076\\u3000\\u307f\\u304a\\t\\u91d1\\u878d\\u30fb\\u30af\\u30eb\\u30fc\\u30ba\\u4e8b\\u696d\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u7af9\\u5185\\u3000\\u99ff\\u592a\",\"raw_line\":\"08\\u5b89\\u4fe1\\u3000\\u307f\\u304a\\t\\u3084\\u3059\\u306e\\u3076\\u3000\\u307f\\u304a\\t\\u91d1\\u878d\\u30fb\\u30af\\u30eb\\u30fc\\u30ba\\u4e8b\\u696d\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u7af9\\u5185\\u3000\\u99ff\\u592a\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u7d00\\u5ddd\\u3000\\u548c\\u5f18\",\"raw_line\":\"\\u7d00\\u5ddd\\u3000\\u548c\\u5f18\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u7af9\\u5185\\u3000\\u99ff\\u592a\",\"raw_line\":\"\\u7af9\\u5185\\u3000\\u99ff\\u592a\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"09\\u6dfa\\u5009\\u3000\\u9686\\u5fd7\\t\\u3042\\u3055\\u304f\\u3089\\u3000\\u305f\\u304b\\u3057\\t\\u30d3\\u30e5\\u30fc\\u30c6\\u30a3\\u30fc\\u30d3\\u30ba\\u30b5\\u30ed\\u30f3\\uff08\\u30b3\\u30ef\\u30fc\\u30ad\\u30f3\\u30b0\",\"raw_line\":\"09\\u6dfa\\u5009\\u3000\\u9686\\u5fd7\\t\\u3042\\u3055\\u304f\\u3089\\u3000\\u305f\\u304b\\u3057\\t\\u30d3\\u30e5\\u30fc\\u30c6\\u30a3\\u30fc\\u30d3\\u30ba\\u30b5\\u30ed\\u30f3\\uff08\\u30b3\\u30ef\\u30fc\\u30ad\\u30f3\\u30b0\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u30b9\\u30da\\u30fc\\u30b9\\uff06\\u30ec\\u30f3\\u30bf\\u30eb\\u30b5\\u30ed\\u30f3\\u8907\\u5408\\u578b\\u65bd\\u8a2dF\",\"raw_line\":\"\\u30b9\\u30da\\u30fc\\u30b9\\uff06\\u30ec\\u30f3\\u30bf\\u30eb\\u30b5\\u30ed\\u30f3\\u8907\\u5408\\u578b\\u65bd\\u8a2dF\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"C\\u672c\\u90e8\\uff09\",\"raw_line\":\"C\\u672c\\u90e8\\uff09\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u98ef\\u7530\\u3000\\u5343\\u5e06\\t\\u6d77\\u6cbc\\u3000\\u529f\",\"raw_line\":\"\\u98ef\\u7530\\u3000\\u5343\\u5e06\\t\\u6d77\\u6cbc\\u3000\\u529f\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u4f50\\u4e45\\u9593\\u3000\\u5eb7\\u4e1e\",\"raw_line\":\"\\u4f50\\u4e45\\u9593\\u3000\\u5eb7\\u4e1e\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u671b\\u6708\\u3000\\u96c5\\u5e78\",\"raw_line\":\"\\u671b\\u6708\\u3000\\u96c5\\u5e78\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u6d77\\u6cbc\\u3000\\u529f\",\"raw_line\":\"\\u6d77\\u6cbc\\u3000\\u529f\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"10\\u5c71\\u672c\\u3000\\u8449\\u5b50\\t\\u3084\\u307e\\u3082\\u3068\\u3000\\u3088\\u3046\\u3053\\t\\u30d3\\u30b8\\u30cd\\u30b9\\u30ab\\u30fc\\u30c9\\t\\u5897\\u672c\\u3000\\u91cd\\u5b5d\\t\\u5897\\u672c\\u3000\\u91cd\\u5b5d\",\"raw_line\":\"10\\u5c71\\u672c\\u3000\\u8449\\u5b50\\t\\u3084\\u307e\\u3082\\u3068\\u3000\\u3088\\u3046\\u3053\\t\\u30d3\\u30b8\\u30cd\\u30b9\\u30ab\\u30fc\\u30c9\\t\\u5897\\u672c\\u3000\\u91cd\\u5b5d\\t\\u5897\\u672c\\u3000\\u91cd\\u5b5d\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5f8c\\u85e4\\u3000\\u5cb3\\u4e45\",\"raw_line\":\"\\u5f8c\\u85e4\\u3000\\u5cb3\\u4e45\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u897f\\u5ca1\\u3000\\u512a\\u5e0c\",\"raw_line\":\"\\u897f\\u5ca1\\u3000\\u512a\\u5e0c\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u5897\\u672c\\u3000\\u91cd\\u5b5d\",\"raw_line\":\"\\u5897\\u672c\\u3000\\u91cd\\u5b5d\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"11\\u718a\\u8c37\\u3000\\u7d18\\u6a39\\t\\u304f\\u307e\\u304c\\u3044\\u3000\\u3072\\u308d\\u304d\\t\\u5c4b\\u6839\\u5de5\\u4e8b\\u696d\\t\\u7560\\u5c71\\u3000\\u61b2\\u4e4b\\t\\u7560\\u5c71\\u3000\\u61b2\\u4e4b\",\"raw_line\":\"11\\u718a\\u8c37\\u3000\\u7d18\\u6a39\\t\\u304f\\u307e\\u304c\\u3044\\u3000\\u3072\\u308d\\u304d\\t\\u5c4b\\u6839\\u5de5\\u4e8b\\u696d\\t\\u7560\\u5c71\\u3000\\u61b2\\u4e4b\\t\\u7560\\u5c71\\u3000\\u61b2\\u4e4b\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u9ad8\\u91ce\\u3000\\u548c\\u7fa9\",\"raw_line\":\"\\u9ad8\\u91ce\\u3000\\u548c\\u7fa9\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u798f\\u4e0a\\u3000\\u5927\\u8f1d\",\"raw_line\":\"\\u798f\\u4e0a\\u3000\\u5927\\u8f1d\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"\\u7560\\u5c71\\u3000\\u61b2\\u4e4b\",\"raw_line\":\"\\u7560\\u5c71\\u3000\\u61b2\\u4e4b\",\"type_hint\":\"visitor\",\"page_type\":\"participants\",\"source_section\":\"visitor\"},{\"name\":\"12\\u6751\\u4e0a\\u3000\\u5f69\\u5b50\\t\\u3080\\u3089\\u304b\\u307f\\u3000\\u3042\\u3084\\u3053\\t\\u30b5\\u30b9\\u30c6\\u30ca\\u30d3\\u30ea\\u30c6\\u30a3\\u00d7\\u30d1\\u30fc\\u30d1\\u30b9\\u7d4c\\u55b6\\u3000\\u7814\\u4fee\\t\\u6885\\u6fa4\\u3000\\u6717\\u5e83\\t\\u6885\\u6fa4\\u3000\\u6717\\u5e83\",\"raw_line\":\"12\\u6751\\u4e0a\\u3000\\u5f69\\u5b50\\t\\u3080\\u3089\\u304b\\u307f\\u3000\\u3042\\u3084\\u3053\\t\\u30b5\\u30b9\\u30c6\\u30ca\\u30d3\\u30ea\\u30c6\\u30a3\\u00d7\\u30d1\\u30fc\\u30d1\\u30b9\\u7d4c\\u55b6\\u3000\\u7814\\u4fee\\t\\u6885\\u6fa4\\u3000\\u6717\\u5e83\\t\\u6885\\u6fa4\\u3000\\u6717\\u5e83\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u98ef\\u7530\\u3000\\u5343\\u5e06\",\"raw_line\":\"\\u98ef\\u7530\\u3000\\u5343\\u5e06\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u5c71\\u53e3\\u3000\\u85ab\",\"raw_line\":\"\\u5c71\\u53e3\\u3000\\u85ab\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u6885\\u6fa4\\u3000\\u6717\\u5e83\",\"raw_line\":\"\\u6885\\u6fa4\\u3000\\u6717\\u5e83\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"13\\u8349\\u91ce\\u3000\\u4fee\\u4e00\\t\\u304f\\u3055\\u306e\\u3000\\u3057\\u3085\\u3046\\u3044\\u3061\\t\\u4f10\\u63a1\\u30fb\\u8349\\u5208\\u308a\\t\\u5009\\u6301\\u3000\\u8ce2\\u4e00\\t\\u5009\\u6301\\u3000\\u8ce2\\u4e00\",\"raw_line\":\"13\\u8349\\u91ce\\u3000\\u4fee\\u4e00\\t\\u304f\\u3055\\u306e\\u3000\\u3057\\u3085\\u3046\\u3044\\u3061\\t\\u4f10\\u63a1\\u30fb\\u8349\\u5208\\u308a\\t\\u5009\\u6301\\u3000\\u8ce2\\u4e00\\t\\u5009\\u6301\\u3000\\u8ce2\\u4e00\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u85e4\\u4e95\\u3000\\u6075\\u7406\\u5b50\",\"raw_line\":\"\\u85e4\\u4e95\\u3000\\u6075\\u7406\\u5b50\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u7530\\u6e15\\u3000\\u606d\\u5e73\",\"raw_line\":\"\\u7530\\u6e15\\u3000\\u606d\\u5e73\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u5009\\u6301\\u3000\\u8ce2\\u4e00\",\"raw_line\":\"\\u5009\\u6301\\u3000\\u8ce2\\u4e00\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"14\\u53ea\\u91ce\\u3000\\u512a\\u5b50\\t\\u305f\\u3060\\u306e\\u3000\\u3086\\u3046\\u3053\\t\\u30d5\\u30a7\\u30e0\\u30b1\\u30a2\\t\\u6e05\\u539f\\u3000\\u4f73\\u5f69\\u7f8e \\u4eca\\u897f\\u3000\\u4fca\\u660e\",\"raw_line\":\"14\\u53ea\\u91ce\\u3000\\u512a\\u5b50\\t\\u305f\\u3060\\u306e\\u3000\\u3086\\u3046\\u3053\\t\\u30d5\\u30a7\\u30e0\\u30b1\\u30a2\\t\\u6e05\\u539f\\u3000\\u4f73\\u5f69\\u7f8e \\u4eca\\u897f\\u3000\\u4fca\\u660e\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u6e05\\u539f\\u3000\\u4f73\\u5f69\\u7f8e\",\"raw_line\":\"\\u6e05\\u539f\\u3000\\u4f73\\u5f69\\u7f8e\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u6b21\\u5ee3\\u3000\\u6df3\",\"raw_line\":\"\\u6b21\\u5ee3\\u3000\\u6df3\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u4eca\\u897f\\u3000\\u4fca\\u660e\",\"raw_line\":\"\\u4eca\\u897f\\u3000\\u4fca\\u660e\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u6e05\\u539f\\u3000\\u4f73\\u5f69\\u7f8e\",\"raw_line\":\"\\u6e05\\u539f\\u3000\\u4f73\\u5f69\\u7f8e\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"15\\u6728\\u6751\\u3000\\u7be4\\u6a39\\t\\u304d\\u3080\\u3089\\u3000\\u3042\\u3064\\u304d\\t\\u73c8\\u7432\\u8c46\\u306e\\u300c\\u98df\\u3079\\u308b\\u8cc7\\u6e90\\u5316\\u300d\\u30af\\u30e9\\u30a6\\u30c9\\u30d5\\u30a1\",\"raw_line\":\"15\\u6728\\u6751\\u3000\\u7be4\\u6a39\\t\\u304d\\u3080\\u3089\\u3000\\u3042\\u3064\\u304d\\t\\u73c8\\u7432\\u8c46\\u306e\\u300c\\u98df\\u3079\\u308b\\u8cc7\\u6e90\\u5316\\u300d\\u30af\\u30e9\\u30a6\\u30c9\\u30d5\\u30a1\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u30f3\\u30c7\\u30a3\\u30f3\\u30b0\",\"raw_line\":\"\\u30f3\\u30c7\\u30a3\\u30f3\\u30b0\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u6885\\u6fa4\\u3000\\u6717\\u5e83\\t\\u91cc\\u898b\\u3000\\u5141\\u4e8c\",\"raw_line\":\"\\u6885\\u6fa4\\u3000\\u6717\\u5e83\\t\\u91cc\\u898b\\u3000\\u5141\\u4e8c\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u98ef\\u7530\\u3000\\u9999\",\"raw_line\":\"\\u98ef\\u7530\\u3000\\u9999\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"\\u91cc\\u898b\\u3000\\u5141\\u4e8c\",\"raw_line\":\"\\u91cc\\u898b\\u3000\\u5141\\u4e8c\",\"type_hint\":\"regular\",\"page_type\":\"participants\",\"source_section\":null},{\"name\":\"01\\u897f\\u91ce\\u5165\\u3000\\u76f4\\u8f1d\\t\\u306b\\u3057\\u306e\\u3044\\u308a\\u3000\\u306a\\u304a\\u304d\\t\\u30b7\\u30f3\\u30b0\\u30eb\\u30de\\u30b6\\u30fc\\u5c02\\u9580\\u4e8b\\u696d\\u30b3\\u30f3\\u30b7\\u30a7\\u30eb\\u30b8\\u30e5\\t\\u5e73\\u5c71\\u3000\\u771f\\u7531\\u7f8e\",\"raw_line\":\"01\\u897f\\u91ce\\u5165\\u3000\\u76f4\\u8f1d\\t\\u306b\\u3057\\u306e\\u3044\\u308a\\u3000\\u306a\\u304a\\u304d\\t\\u30b7\\u30f3\\u30b0\\u30eb\\u30de\\u30b6\\u30fc\\u5c02\\u9580\\u4e8b\\u696d\\u30b3\\u30f3\\u30b7\\u30a7\\u30eb\\u30b8\\u30e5\\t\\u5e73\\u5c71\\u3000\\u771f\\u7531\\u7f8e\",\"type_hint\":\"proxy\",\"page_type\":\"participants\",\"source_section\":\"proxy\"},{\"name\":\"02\\u5c0f\\u67f3\\u3000\\u771f\\u7406\\u5b50\\t\\u3053\\u3084\\u306a\\u304e\\u3000\\u307e\\u308a\\u3053\\t\\u30a8\\u30a2\\u30ed\\u30b2\\u30eb\\u900f\\u660e\\u65ad\\u71b1\\u30d5\\u30a3\\u30eb\\u30e0\\t\\u677e\\u5009\\u3000\\u5065\\u6cbb\",\"raw_line\":\"02\\u5c0f\\u67f3\\u3000\\u771f\\u7406\\u5b50\\t\\u3053\\u3084\\u306a\\u304e\\u3000\\u307e\\u308a\\u3053\\t\\u30a8\\u30a2\\u30ed\\u30b2\\u30eb\\u900f\\u660e\\u65ad\\u71b1\\u30d5\\u30a3\\u30eb\\u30e0\\t\\u677e\\u5009\\u3000\\u5065\\u6cbb\",\"type_hint\":\"proxy\",\"page_type\":\"participants\",\"source_section\":\"proxy\"},{\"name\":\"03\\u5ca1\\u6751\\u3000\\u5065\\u7f8e\\t\\u304a\\u304b\\u3080\\u3089\\u3000\\u305f\\u3051\\u307f\\t\\u30d5\\u30a1\\u30a4\\u30f3\\u30d0\\u30d6\\u30eb\\uff08\\u4f4f\\u5b85\\u8a2d\\u5099\\u6a5f\\u5668\\uff09\\u8ca9\\u58f2\\t\\u592a\\u7530 \\u3000\\u4e00\\u8aa0\",\"raw_line\":\"03\\u5ca1\\u6751\\u3000\\u5065\\u7f8e\\t\\u304a\\u304b\\u3080\\u3089\\u3000\\u305f\\u3051\\u307f\\t\\u30d5\\u30a1\\u30a4\\u30f3\\u30d0\\u30d6\\u30eb\\uff08\\u4f4f\\u5b85\\u8a2d\\u5099\\u6a5f\\u5668\\uff09\\u8ca9\\u58f2\\t\\u592a\\u7530 \\u3000\\u4e00\\u8aa0\",\"type_hint\":\"proxy\",\"page_type\":\"participants\",\"source_section\":\"proxy\"},{\"name\":\"01\\u677e\\u5c45\\u3000\\u5916\\u5fd7\\u7f8e\\t\\u307e\\u3064\\u3044\\u3000\\u3068\\u3057\\u307f\\t\\u5fdc\\u7528\\u8133\\u79d1\\u5b66\\u3092\\u4f7f\\u3063\\u305f\\u4f01\\u696d\\u7814\\u4fee\\u8b1b\\u5e2b\\t\\u8229\\u6749\\u3000\\u7267\\u5b50\\t\\u8229\\u6749\\u3000\\u7267\\u5b50\",\"raw_line\":\"01\\u677e\\u5c45\\u3000\\u5916\\u5fd7\\u7f8e\\t\\u307e\\u3064\\u3044\\u3000\\u3068\\u3057\\u307f\\t\\u5fdc\\u7528\\u8133\\u79d1\\u5b66\\u3092\\u4f7f\\u3063\\u305f\\u4f01\\u696d\\u7814\\u4fee\\u8b1b\\u5e2b\\t\\u8229\\u6749\\u3000\\u7267\\u5b50\\t\\u8229\\u6749\\u3000\\u7267\\u5b50\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"},{\"name\":\"\\u82b3\\u8cc0\\u3000\\u5d07\\u5229\",\"raw_line\":\"\\u82b3\\u8cc0\\u3000\\u5d07\\u5229\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"},{\"name\":\"\\u8ecd\\u53f8\\u3000\\u6566\\u54c9\",\"raw_line\":\"\\u8ecd\\u53f8\\u3000\\u6566\\u54c9\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"},{\"name\":\"\\u8229\\u6749\\u3000\\u7267\\u5b50\",\"raw_line\":\"\\u8229\\u6749\\u3000\\u7267\\u5b50\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"},{\"name\":\"02\\u516b\\u6728\\u3000\\u9686\\u660e\\t\\u3084\\u304e\\u3000\\u305f\\u304b\\u3042\\u304d\\t\\u7740\\u7269\\u76e3\\u4fee\\u5bb6\\/\\u518d\\u751f\\u30fb\\u30aa\\u30fc\\u30c0\\u30fc\\u30c7\\u30a3\\u30ec\\u30af\\u30bf\\u30fc\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u5ca1\\u5143\\u3000\\u667a\\u7f8e\",\"raw_line\":\"02\\u516b\\u6728\\u3000\\u9686\\u660e\\t\\u3084\\u304e\\u3000\\u305f\\u304b\\u3042\\u304d\\t\\u7740\\u7269\\u76e3\\u4fee\\u5bb6\\/\\u518d\\u751f\\u30fb\\u30aa\\u30fc\\u30c0\\u30fc\\u30c7\\u30a3\\u30ec\\u30af\\u30bf\\u30fc\\t\\u6e21\\u908a\\u3000\\u771f\\u5927\\t\\u5ca1\\u5143\\u3000\\u667a\\u7f8e\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"},{\"name\":\"\\u798f\\u58eb\\u3000\\u5229\\u660e\",\"raw_line\":\"\\u798f\\u58eb\\u3000\\u5229\\u660e\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"},{\"name\":\"\\u5ca1\\u5143\\u3000\\u667a\\u7f8e\",\"raw_line\":\"\\u5ca1\\u5143\\u3000\\u667a\\u7f8e\",\"type_hint\":\"guest\",\"page_type\":\"participants\",\"source_section\":\"guest\"}],\"meta\":{\"pages\":[{\"page\":1,\"type\":\"ignore\"},{\"page\":2,\"type\":\"members\"},{\"page\":3,\"type\":\"ignore\"},{\"page\":4,\"type\":\"ignore\"},{\"page\":5,\"type\":\"ignore\"},{\"page\":6,\"type\":\"participants\"},{\"page\":7,\"type\":\"participants\"}],\"line_count\":136,\"parser_version\":2}}',NULL,NULL,'2026-03-17 13:10:31','2026-03-18 07:45:49'),
(2,2,'meeting_participant_imports/2/55994a3d-f0ff-4506-881f-bfdb8a9c52d4.pdf','メンバーリスト20260310.pdf','uploaded',NULL,'pending',NULL,NULL,NULL,NULL,'2026-03-17 13:15:17','2026-03-17 13:15:17'),
(3,1,'meeting_participant_imports/1/0f6efae7-5734-45b4-87ee-06129f8453a9.pdf','定例会参加者リスト2026_03_03-1.pdf','uploaded',NULL,'pending',NULL,NULL,NULL,NULL,'2026-03-17 13:16:46','2026-03-17 13:16:46'),
(4,6,'meeting_participant_imports/6/0ab98c6d-6d6c-44a5-8cf5-0c5d8f3fb58f.pdf','定例会参加者リスト0331.pdf','uploaded',NULL,'pending',NULL,NULL,NULL,NULL,'2026-03-30 23:59:58','2026-03-30 23:59:58'),
(5,9,'meeting_participant_imports/9/ad1a72e0-b3c5-4c19-ade8-891c2fbe05c2.pdf','定例会参加者リスト2026_04_21.pdf','uploaded','2026-04-20 22:18:57','failed',NULL,NULL,NULL,NULL,'2026-04-20 22:18:54','2026-04-20 22:18:57'),
(6,13,'meeting_participant_imports/13/f1752750-2920-4ed1-a254-6d0936f0db25.pdf','定例会参加者リスト2026_06_02.pdf','uploaded',NULL,'pending',NULL,NULL,NULL,NULL,'2026-06-02 17:05:53','2026-06-02 17:05:53');
/*!40000 ALTER TABLE `meeting_participant_imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meetings`
--

DROP TABLE IF EXISTS `meetings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meetings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `number` int(10) unsigned NOT NULL,
  `held_on` date NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `bo_count` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meetings_number_unique` (`number`),
  KEY `meetings_held_on_index` (`held_on`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meetings`
--

LOCK TABLES `meetings` WRITE;
/*!40000 ALTER TABLE `meetings` DISABLE KEYS */;
INSERT INTO `meetings` VALUES
(1,199,'2026-03-03','第199回定例会',2,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(2,200,'2026-03-10','第200回定例会',2,'2026-03-10 00:40:13','2026-03-10 00:40:13'),
(3,201,'2026-03-17','第201回定例会',2,'2026-03-16 23:42:36','2026-03-16 23:42:36'),
(4,202,'2026-03-24','第202回定例会',2,'2026-03-20 09:47:41','2026-03-20 09:47:41'),
(6,203,'2026-03-31','第203回定例会',2,'2026-03-30 23:59:39','2026-03-30 23:59:39'),
(7,204,'2026-04-07','第204回定例会',2,'2026-04-07 00:04:24','2026-04-07 00:04:24'),
(8,205,'2026-04-14','第205回定例会',2,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(9,206,'2026-04-21','第206回定例会',2,'2026-04-20 20:36:09','2026-04-20 20:36:09'),
(10,207,'2026-05-12','第207回定例会',2,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(11,208,'2026-05-19','第208回定例会',2,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(12,209,'2026-05-26','第209回定例会',2,'2026-05-25 17:33:03','2026-05-25 17:33:03'),
(13,210,'2026-06-02','第210回定例会',2,'2026-06-02 08:49:44','2026-06-02 08:49:44');
/*!40000 ALTER TABLE `meetings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_roles`
--

DROP TABLE IF EXISTS `member_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  `term_start` date DEFAULT NULL,
  `term_end` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `member_roles_role_id_foreign` (`role_id`),
  KEY `member_roles_member_id_term_start_index` (`member_id`,`term_start`),
  CONSTRAINT `member_roles_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `member_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=525 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_roles`
--

LOCK TABLES `member_roles` WRITE;
/*!40000 ALTER TABLE `member_roles` DISABLE KEYS */;
INSERT INTO `member_roles` VALUES
(1,2,1,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(2,3,2,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(3,4,3,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(4,5,4,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(5,8,5,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(6,9,6,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(7,10,7,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(8,11,8,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(9,12,9,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(10,13,10,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(11,18,11,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(12,19,12,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(13,20,13,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(14,21,7,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(15,22,12,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(16,24,12,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(17,25,14,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(18,26,15,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(19,27,16,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(20,28,12,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(21,29,14,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(22,30,17,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(23,32,18,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(24,33,19,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(25,34,20,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(26,36,12,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(27,37,21,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(28,38,22,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(29,39,14,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(30,40,14,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(31,42,23,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(32,43,16,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(33,44,24,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(34,45,25,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(35,46,26,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(36,47,16,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(37,48,27,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(38,49,28,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(39,50,29,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(40,51,21,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(41,52,30,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(42,53,31,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(43,54,32,'2026-03-05','2026-03-10','2026-03-05 01:49:21','2026-03-10 00:40:14'),
(44,2,33,'2026-03-10','2026-03-16','2026-03-10 00:40:14','2026-03-16 23:42:37'),
(45,5,4,'2026-03-10','2026-03-16','2026-03-10 00:40:14','2026-03-16 23:42:37'),
(46,20,13,'2026-03-10','2026-03-16','2026-03-10 00:40:14','2026-03-16 23:42:37'),
(47,2,1,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(48,3,2,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(49,4,3,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(50,5,4,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(51,8,5,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(52,9,6,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(53,10,7,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(54,11,8,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(55,12,9,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(56,13,10,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(57,18,11,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(58,19,12,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(59,20,13,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(60,21,7,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(61,22,12,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(62,24,12,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(63,25,14,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(64,26,15,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(65,27,16,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(66,28,12,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(67,29,14,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(68,30,17,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(69,32,18,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(70,33,19,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(71,34,20,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(72,38,12,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(73,39,21,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(74,40,22,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(75,41,14,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(76,42,14,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(77,44,23,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(78,45,16,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(79,46,24,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(80,47,26,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(81,48,16,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(82,49,27,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(83,50,28,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(84,51,29,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(85,52,21,'2026-03-16','2026-03-23','2026-03-16 23:42:37','2026-03-23 12:34:34'),
(86,2,1,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(87,3,2,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(88,4,3,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(89,5,4,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(90,8,5,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(91,9,6,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(92,10,7,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(93,11,8,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(94,12,9,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(95,13,10,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(96,18,11,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(97,19,12,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(98,20,13,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(99,21,7,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(100,22,12,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(101,24,12,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(102,25,14,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(103,26,15,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(104,27,16,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(105,28,12,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(106,29,14,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(107,30,17,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(108,32,18,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(109,33,19,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(110,34,20,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(111,38,12,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(112,39,21,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(113,40,22,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(114,41,14,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(115,42,14,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(116,44,23,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(117,45,16,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(118,46,24,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(119,47,26,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(120,48,16,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(121,49,27,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(122,50,28,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(123,51,29,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(124,52,21,'2026-03-23','2026-03-23','2026-03-23 12:34:34','2026-03-23 12:35:10'),
(125,2,1,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(126,3,2,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(127,4,3,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(128,5,4,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(129,8,5,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(130,9,6,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(131,10,7,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(132,11,8,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(133,12,9,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(134,13,10,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(135,18,11,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(136,19,12,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(137,20,13,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(138,21,7,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(139,22,12,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(140,24,12,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(141,25,14,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(142,26,15,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(143,27,16,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(144,28,12,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(145,29,14,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(146,30,17,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(147,32,18,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(148,33,19,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(149,34,20,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(150,38,12,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(151,39,21,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(152,40,22,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(153,41,14,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(154,42,14,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(155,44,23,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(156,45,16,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(157,46,24,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(158,47,26,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(159,48,16,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(160,49,27,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(161,50,28,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(162,51,29,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(163,52,21,'2026-03-23','2026-03-31','2026-03-23 12:35:10','2026-03-31 00:09:20'),
(164,2,1,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(165,3,2,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(166,4,3,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(167,5,4,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(168,8,5,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(169,9,6,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(170,10,7,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(171,11,8,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(172,12,9,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(173,13,10,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(174,18,11,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(175,19,12,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(176,20,13,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(177,21,7,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(178,22,12,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(179,24,12,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(180,25,14,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(181,26,15,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(182,27,16,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(183,28,12,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(184,29,14,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(185,30,17,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(186,32,18,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(187,33,19,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(188,34,20,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(189,36,7,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(190,38,12,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(191,39,21,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(192,40,22,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(193,41,14,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(194,42,14,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(195,44,23,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(196,45,16,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(197,46,24,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(198,47,26,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(199,48,16,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(200,49,27,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(201,50,28,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(202,51,29,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(203,52,21,'2026-03-31','2026-04-07','2026-03-31 00:09:20','2026-04-07 00:04:59'),
(204,2,1,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(205,3,2,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(206,4,3,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(207,5,33,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(208,6,34,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(209,8,5,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(210,9,6,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(211,10,24,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(212,11,7,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(213,12,13,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(214,13,9,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(215,14,10,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(216,18,35,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(217,20,4,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(218,21,36,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(219,22,10,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(220,23,12,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(221,25,12,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(222,26,14,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(223,27,15,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(224,28,16,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(225,29,12,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(226,30,14,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(227,32,18,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(228,33,19,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(229,34,20,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(230,36,7,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(231,38,12,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(232,39,21,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(233,40,22,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(234,41,14,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(235,42,14,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(236,44,23,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(237,45,16,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(238,46,37,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(239,47,16,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(240,48,27,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(241,49,38,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(242,50,29,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(243,51,21,'2026-04-07','2026-04-13','2026-04-07 00:04:59','2026-04-13 12:13:25'),
(244,2,39,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(245,3,2,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(246,4,40,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(247,5,33,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(248,6,34,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(249,8,41,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(250,9,42,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(251,10,7,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(252,11,13,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(253,12,9,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(254,13,10,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(255,17,35,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(256,18,39,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(257,19,4,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(258,20,36,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(259,21,10,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(260,22,12,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(261,24,12,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(262,25,14,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(263,26,15,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(264,28,16,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(265,29,12,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(266,30,14,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(267,32,18,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(268,33,19,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(269,34,20,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(270,36,7,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(271,38,12,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(272,39,21,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(273,40,22,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(274,41,14,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(275,42,14,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(276,44,23,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(277,45,16,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(278,46,37,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(279,47,16,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(280,48,27,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(281,49,38,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(282,50,29,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(283,51,21,'2026-04-13','2026-04-13','2026-04-13 12:13:25','2026-04-13 12:58:33'),
(284,2,39,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(285,3,2,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(286,4,40,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(287,5,33,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(288,6,34,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(289,8,41,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(290,9,42,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(291,10,7,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(292,11,13,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(293,12,9,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(294,13,10,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(295,17,35,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(296,18,39,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(297,19,4,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(298,20,36,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(299,21,10,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(300,22,12,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(301,24,12,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(302,25,14,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(303,26,15,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(304,28,16,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(305,29,12,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(306,30,14,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(307,32,18,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(308,33,19,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(309,34,20,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(310,36,7,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(311,38,12,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(312,39,21,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(313,40,22,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(314,41,14,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(315,42,14,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(316,44,23,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(317,45,16,'2026-04-13',NULL,'2026-04-13 12:58:33','2026-04-13 12:58:33'),
(318,46,37,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(319,47,16,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(320,48,27,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(321,49,38,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(322,50,29,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(323,51,21,'2026-04-13','2026-04-20','2026-04-13 12:58:33','2026-04-20 21:05:14'),
(324,2,39,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(325,3,2,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(326,4,40,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(327,5,33,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(328,6,34,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(329,8,41,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(330,9,42,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(331,10,7,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(332,11,13,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(333,12,43,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(334,13,10,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:43'),
(335,17,35,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(336,18,39,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(337,19,4,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(338,20,36,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(339,21,10,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(340,22,12,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(341,24,12,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(342,25,14,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(343,26,15,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(344,28,16,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(345,29,12,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(346,30,14,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(347,32,18,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(348,33,19,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(349,34,20,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(350,36,7,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(351,38,12,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(352,39,21,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(353,40,22,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(354,41,44,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(355,42,14,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(356,44,23,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(357,46,37,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(358,47,16,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(359,48,27,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(360,49,38,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(361,50,29,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(362,51,21,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(363,53,12,'2026-04-20','2026-05-12','2026-04-20 21:05:14','2026-05-12 08:00:44'),
(364,2,39,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(365,3,2,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(366,4,40,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(367,5,33,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(368,6,34,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(369,8,41,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(370,9,42,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(371,10,7,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(372,11,13,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(373,12,43,'2026-05-12','2026-05-18','2026-05-12 08:00:43','2026-05-18 22:56:51'),
(374,13,20,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(375,17,35,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(376,18,39,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(377,19,4,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(378,20,36,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(379,21,10,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(380,22,12,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(381,24,12,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(382,25,14,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(383,26,15,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(384,28,16,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(385,29,12,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(386,30,14,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(387,32,18,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(388,33,19,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(389,34,45,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(390,36,7,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(391,38,12,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(392,39,21,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(393,40,22,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(394,41,44,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(395,42,14,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(396,44,23,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(397,46,37,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(398,47,16,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(399,48,27,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(400,49,38,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(401,50,29,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(402,51,21,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(403,53,12,'2026-05-12','2026-05-18','2026-05-12 08:00:44','2026-05-18 22:56:51'),
(404,2,39,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(405,3,2,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(406,4,40,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(407,5,33,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(408,6,34,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(409,8,41,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(410,9,42,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(411,10,7,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(412,11,13,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(413,12,43,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(414,13,20,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(415,17,35,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(416,18,39,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(417,19,4,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(418,20,36,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(419,21,10,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(420,22,12,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(421,24,12,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(422,25,14,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(423,26,46,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(424,28,16,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(425,30,14,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(426,32,18,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(427,33,19,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(428,34,45,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(429,36,7,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(430,38,12,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(431,39,21,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(432,40,47,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(433,29,12,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(434,41,44,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(435,42,14,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(436,44,23,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(437,46,37,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(438,47,16,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(439,48,27,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(440,49,38,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(441,50,29,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(442,51,21,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(443,53,12,'2026-05-18','2026-05-25','2026-05-18 22:56:51','2026-05-25 17:33:03'),
(444,2,39,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(445,3,2,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(446,4,40,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(447,5,33,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(448,6,34,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(449,8,41,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(450,9,42,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(451,10,7,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(452,11,13,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(453,12,43,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(454,13,20,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(455,17,35,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(456,18,39,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(457,19,4,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(458,20,36,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(459,21,10,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(460,22,12,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(461,24,12,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(462,25,14,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(463,26,46,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(464,28,16,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(465,30,14,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(466,32,18,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(467,33,19,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(468,34,45,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(469,36,7,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(470,38,12,'2026-05-25',NULL,'2026-05-25 17:33:03','2026-05-25 17:33:03'),
(471,39,21,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(472,40,47,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(473,29,12,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(474,41,44,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(475,42,14,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(476,43,48,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(477,44,23,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(478,46,37,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(479,47,16,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(480,48,39,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(481,49,38,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(482,50,29,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(483,51,49,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(484,53,12,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55'),
(485,2,39,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(486,3,2,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(487,8,41,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(488,4,40,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(489,5,33,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(490,6,34,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(491,9,42,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(492,10,7,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(493,11,13,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(494,12,43,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(495,13,20,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(496,17,35,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(497,18,39,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(498,19,4,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(499,20,36,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(500,21,10,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(501,22,12,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(502,24,12,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(503,25,14,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(504,26,46,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(505,28,16,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(506,30,14,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(507,32,18,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(508,33,19,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(509,34,45,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(510,36,7,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(511,39,21,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(512,40,47,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(513,29,12,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(514,41,44,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(515,42,14,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(516,43,48,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(517,44,23,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(518,46,37,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(519,47,16,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(520,48,39,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(521,49,38,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(522,50,29,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(523,51,49,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(524,53,12,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44');
/*!40000 ALTER TABLE `member_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `name_kana` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `category_id` bigint(20) unsigned DEFAULT NULL,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `type` varchar(20) NOT NULL,
  `display_no` varchar(20) DEFAULT NULL,
  `ncast_profile_url` varchar(2048) DEFAULT NULL,
  `weekly_presentation_body` text DEFAULT NULL,
  `start_dash_presentation_body` text DEFAULT NULL,
  `introducer_member_id` bigint(20) unsigned DEFAULT NULL,
  `attendant_member_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `members_workspace_email_unique` (`workspace_id`,`email`),
  KEY `members_type_index` (`type`),
  KEY `members_introducer_member_id_index` (`introducer_member_id`),
  KEY `members_attendant_member_id_index` (`attendant_member_id`),
  KEY `members_category_id_foreign` (`category_id`),
  KEY `members_workspace_id_index` (`workspace_id`),
  CONSTRAINT `members_attendant_member_id_foreign` FOREIGN KEY (`attendant_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `members_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `members_introducer_member_id_foreign` FOREIGN KEY (`introducer_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `members_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES
(1,'平岡　国彦','ひらおか　くにひこ',NULL,21,1,'member','1',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(2,'増本　重孝','ますもと　しげたか',NULL,77,1,'member','2',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(3,'長谷川　貴志','はせがわ　たかし',NULL,78,1,'member','3',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(4,'松倉　健治','まつくら　けんじ',NULL,79,1,'member','5',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(5,'福上　大輝','ふくがみ　たいき',NULL,80,1,'member','6',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(6,'太田　一誠','おおた　いっせい',NULL,81,1,'member','7',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(7,'高野　和義','たかの　かずよし',NULL,82,1,'member','7',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-03-16 23:42:37'),
(8,'福士　利明','ふくし　としあき',NULL,245,1,'member','4',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(9,'中村　啓吾','なかむら　けいご',NULL,165,1,'member','8',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(10,'倉持　賢一','くらもち　けんいち',NULL,85,1,'member','9',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(11,'岡元　智美','おかもと　ともみ',NULL,86,1,'member','10',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(12,'西浦　雅','にしうら　みやび',NULL,87,1,'member','11',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(13,'芳賀　崇利','はが　たかとし',NULL,88,1,'member','12',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(14,'西岡　優希','にしおか　ゆうき',NULL,89,1,'member','13',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(15,'横山　尚武','よこやま　なおむ',NULL,90,1,'member','14',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(16,'Rii','りー',NULL,91,1,'member','16',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-04-13 12:13:25'),
(17,'佐藤　拓斗','さとう　たくと',NULL,92,1,'member','15',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(18,'原田　里織','はらだ　さおり',NULL,166,1,'member','16',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(19,'平山　真由美','ひらやま　まゆみ',NULL,93,1,'member','19',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(20,'舩杉　牧子','ふなすぎ　まきこ',NULL,40,1,'member','20',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(21,'渡邊　真大','わたなべ　まお',NULL,95,1,'member','21',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(22,'大竹　絵理香','おおたけ　えりか',NULL,96,1,'member','22',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(23,'山口　薫','やまぐち　かおる',NULL,97,1,'member','23',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(24,'海沼　功','かいぬま　いさお',NULL,98,1,'member','24',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(25,'紀川　和弘','きかわ　かずひろ',NULL,99,1,'member','25',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(26,'竹内　駿太','たけうち　しゅんた',NULL,100,1,'member','26',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(27,'山本　葉子','やまもと　ようこ',NULL,185,1,'member','27',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(28,'梅澤　朗広','うめざわ　あきひろ',NULL,101,1,'member','28',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(29,'加藤　隆太','かとう　りゅうた',NULL,217,1,'member','40',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(30,'越賀　淑恵','こしが　としえ',NULL,103,1,'member','29',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(31,'望月　雅幸','もちづき　まさゆき',NULL,105,1,'member','30',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(32,'佐久間　康丞','さくま　こうすけ',NULL,106,1,'member','31',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(33,'斎藤　和貴','さいとうかずき',NULL,107,1,'member','32',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(34,'小中　貴晃','こなか　たかあき',NULL,108,1,'member','33',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(35,'山本　洸太','やまもと　こうた',NULL,109,1,'member','34',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(36,'軍司　敦哉','ぐんじ　あつや',NULL,110,1,'member','35',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(37,'次廣　淳','つぎひろ　あつし','tugi@tugilo.com',149,1,'member','36',NULL,'AI業務改善システム構築の次廣です。\n時間を生み出すSEです。\n\n建設業や製造業で、Excel・手作業の見積、現場、請求を、\n1回の入力で回る仕組みにします。\n\n担当者しか分からない状態を、誰でも追える形に変えます。\n\nそんな会社様や、顧問先に持つ士業・コンサルの方とお繋ぎください。\n\nAI業務改善システム構築の次廣でした。','AI業務改善システム構築の次廣です。\n時間を生み出すSEです。\n\n私は、建設業や製造業、現場仕事の多い会社で、\nExcelや手作業で行っている見積、現場管理、請求業務を、\n1回の入力で回る仕組みに変えるお手伝いをしています。\n\n担当者しか分からない状態を、\n誰でも追えて、ミスなく回る形に整えます。\n\n実際に、DragonFlyメンバーの増本さんの害虫ブロック事業でも、\n業務の流れに合わせたシステムを構築し、\nかなり成果が出始めています。\n\n私が作っているのは、単なるシステムではなく、\n社長や現場の方が、本来やるべき仕事に集中するための時間です。\n\nご紹介いただきたいのは、\n建設業・製造業・現場仕事の多い会社で、\nExcel管理や手入力が多く、そろそろ仕組み化したい会社様です。\n\nまた、そういった会社を顧問先に持つ、\n士業・コンサルの方ともぜひお繋ぎください。\n\nAI業務改善システム構築の次廣でした。',NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(38,'吉田　俊之','よしだとしゆき',NULL,111,1,'member','35',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-18 22:56:51'),
(39,'里見　允二','さとみ　まさつぐ',NULL,112,1,'member','38',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(40,'畠山　憲之','はたけやま　のりゆき',NULL,113,1,'member','39',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(41,'今西　俊明','いまにし　としあき',NULL,114,1,'member','41',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(42,'廣田　誠悟','ひろた　せいご',NULL,115,1,'member','42',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(43,'田渕　恭平','たぶち　きょうへい',NULL,116,1,'member','43',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(44,'木村　健悟','きむら　けんご',NULL,117,1,'member','44',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(45,'立岡　海人','たつおか　かいと',NULL,118,1,'member','45',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-03-16 23:42:37'),
(46,'藤井　恵理子','ふじい　えりこ',NULL,120,1,'member','45',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(47,'今村　千絵','いまむら　ちえ',NULL,121,1,'member','46',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(48,'清原　佳彩美','きよはら　かさみ',NULL,218,1,'member','47',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(49,'船津　麻理子','ふなつ　まりこ',NULL,123,1,'member','48',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(50,'飯田　千帆','いいだ　ちほ',NULL,124,1,'member','49',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(51,'飯田　香','いいだ　かおり',NULL,125,1,'member','50',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(52,'野口　裕子',NULL,NULL,NULL,1,'member','50',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(53,'久米　加代子','くめ　かよこ',NULL,186,1,'member','51',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(54,'藤田　磨紀','ふじた　まき',NULL,126,1,'member','52',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(55,'上田　友顕','うえだ　ともあき',NULL,187,1,'visitor','V1',NULL,NULL,NULL,11,11,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(56,'渡井　みづき','わたい　みづき',NULL,188,1,'visitor','V2',NULL,NULL,NULL,41,12,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(57,'河北　竜也','かわきた　たつや',NULL,189,1,'visitor','V3',NULL,NULL,NULL,11,39,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(58,'天野　未央','あまの　みお',NULL,190,1,'visitor','V4',NULL,NULL,NULL,20,20,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(59,'渡邉　飛鳥','わたなべ　あすか',NULL,180,1,'visitor','V5',NULL,NULL,NULL,35,46,'2026-03-03 00:34:23','2026-06-01 13:52:09'),
(60,'林　敏史','はやし　としふみ',NULL,201,1,'guest','G1',NULL,NULL,NULL,20,41,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(61,'伊藤　剛','いとう　ごう',NULL,202,1,'guest','G2',NULL,NULL,NULL,29,34,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(62,'京極　祥平','きょうごく　しょうへい',NULL,184,1,'guest','G3',NULL,NULL,NULL,13,NULL,'2026-03-03 00:34:23','2026-04-07 00:04:59'),
(64,'小林　美香','こばやし　みか',NULL,200,1,'guest','P1',NULL,NULL,NULL,51,4,'2026-03-10 00:40:14','2026-04-13 12:58:33'),
(65,'山崎　勇一','やまざき　ゆういち',NULL,127,1,'member','53',NULL,NULL,NULL,NULL,NULL,'2026-03-16 23:42:37','2026-06-02 08:49:44'),
(67,'副島　陽祐','そえじま　ゆうすけ',NULL,191,1,'visitor','V7',NULL,NULL,NULL,6,28,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(68,'中村　雄季','なかむら　ゆうき',NULL,192,1,'visitor','V8',NULL,NULL,NULL,13,26,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(69,'渡邉　湖野美','わたなべ　このみ',NULL,193,1,'visitor','V9',NULL,NULL,NULL,36,30,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(70,'山口　智忠','やまぐち　ともただ',NULL,194,1,'visitor','V1',NULL,NULL,NULL,26,20,'2026-03-16 23:42:37','2026-04-20 21:05:14'),
(71,'新村　明香','しんむら　あすか',NULL,195,1,'visitor','V11',NULL,NULL,NULL,53,13,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(72,'細田　光孝','ほそだ　みつたか',NULL,196,1,'visitor','V12',NULL,NULL,NULL,18,10,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(73,'小森　悠史','こもり　ゆうし',NULL,197,1,'visitor','V13',NULL,NULL,NULL,49,32,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(74,'實島　賢','さねしま　けん',NULL,198,1,'visitor','V14',NULL,NULL,NULL,6,21,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(75,'右田　英里','みぎた　えり',NULL,199,1,'visitor','V15',NULL,NULL,NULL,20,15,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
(76,'二瓶　紗樹','にへい　さき',NULL,162,1,'guest','P2',NULL,NULL,NULL,27,NULL,'2026-03-16 23:42:37','2026-03-31 00:09:20'),
(77,'岡村　健美','おかむら　たけみ',NULL,146,1,'guest','P3',NULL,NULL,NULL,6,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(78,'木下　馨','きのした　かおる',NULL,128,1,'member','54',NULL,NULL,NULL,NULL,NULL,'2026-03-31 00:09:20','2026-06-02 08:49:44'),
(80,'山下　一樹','やました　かずき',NULL,181,NULL,'visitor','V17',NULL,NULL,NULL,13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(82,'花崎　勇佑','はなざき　ゆうすけ',NULL,203,NULL,'visitor','V1',NULL,NULL,NULL,30,17,'2026-04-20 21:05:14','2026-05-12 08:00:44'),
(83,'小森　保人','こもり　やすひと',NULL,204,NULL,'visitor','V3',NULL,NULL,NULL,19,2,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(84,'宮島　大輔','みやじま　だいすけ',NULL,205,NULL,'visitor','V4',NULL,NULL,NULL,13,24,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(85,'井上　万莉亜','いのうえ　まりあ',NULL,150,NULL,'visitor','V5',NULL,NULL,NULL,17,1,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(86,'村田　祐作','むらた　ゆうさく',NULL,206,NULL,'guest','P1',NULL,NULL,NULL,5,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(87,'頓所　壱晟','とんしょ　いっせい',NULL,207,NULL,'guest','P2',NULL,NULL,NULL,36,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(88,'丹羽　さくら','にわ　さくら',NULL,209,NULL,'visitor','V2',NULL,NULL,NULL,48,24,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(89,'鶴岡　江里子','つるおか　えりこ',NULL,210,NULL,'visitor','V3',NULL,NULL,NULL,17,5,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(90,'石原　悠雅','いしはら　ゆうが',NULL,211,NULL,'visitor','V4',NULL,NULL,NULL,22,9,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(91,'津澤　正人','つざわ　まさと',NULL,212,NULL,'visitor','V5',NULL,NULL,NULL,19,20,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(92,'小原　裕美','こばら　ゆみ',NULL,213,NULL,'visitor','V6',NULL,NULL,NULL,39,4,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(93,'浜名　靖博','はまな　やすひろ',NULL,214,NULL,'guest','P1',NULL,NULL,NULL,10,48,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(94,'田辺　光','たなべ　ひかる',NULL,215,NULL,'guest','G1',NULL,NULL,NULL,49,2,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(95,'髙橋　豊','たかはし　ゆたか',NULL,216,NULL,'guest','P1',NULL,NULL,NULL,21,NULL,'2026-05-12 08:00:44','2026-06-02 08:49:44'),
(96,'鈴木　健介',NULL,NULL,NULL,2,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 22:26:13','2026-05-17 22:29:31'),
(97,'飯塚氏（名 TODO）',NULL,NULL,NULL,3,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 22:26:13','2026-05-17 22:29:31'),
(98,'田村　広大',NULL,NULL,NULL,4,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 22:26:13','2026-05-17 22:29:31'),
(99,'木村　秀継',NULL,NULL,NULL,7,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 22:26:13','2026-05-21 16:18:58'),
(100,'伊藤　隆夫',NULL,NULL,NULL,3,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 22:26:13','2026-05-17 22:29:31'),
(101,'礒部　昌之',NULL,NULL,NULL,5,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 22:26:13','2026-05-17 22:29:31'),
(102,'神麻　乃梨子','じんま　のりこ',NULL,219,NULL,'visitor','V1',NULL,NULL,NULL,40,40,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(103,'宮地　慶和','みやち　よしかず',NULL,220,NULL,'visitor','V2',NULL,NULL,NULL,46,12,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(104,'佐藤　啓介','さとう　けいすけ',NULL,221,NULL,'visitor','V3',NULL,NULL,NULL,18,18,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(105,'神山　英輝','かみやま　ひでき',NULL,222,NULL,'visitor','V4',NULL,NULL,NULL,19,26,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(106,'中村　まどか','なかむら　まどか',NULL,223,NULL,'visitor','V5',NULL,NULL,NULL,26,24,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(107,'山田　桃子','やまだ　ももこ',NULL,224,NULL,'visitor','V6',NULL,NULL,NULL,20,51,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(108,'福田　航平','ふくだ　こうへい',NULL,225,NULL,'visitor','V7',NULL,NULL,NULL,30,30,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(109,'池田　雅史','いけだ　まさし',NULL,226,NULL,'visitor','V8',NULL,NULL,NULL,41,9,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(110,'松下　真紀子','まつした　まきこ',NULL,227,NULL,'visitor','V9',NULL,NULL,NULL,27,5,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(111,'南部　湧祐','なんぶ　ゆうすけ',NULL,228,NULL,'visitor','V10',NULL,NULL,NULL,18,4,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(112,'境井　健志','さかい　けんじ',NULL,214,NULL,'guest','P1',NULL,NULL,NULL,10,21,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(113,'古屋　周治','ふるや　しゅうじ',NULL,229,NULL,'guest','G1',NULL,NULL,NULL,2,35,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(114,'能見　芽衣子','のうみ　めいこ',NULL,230,NULL,'guest','G2',NULL,NULL,NULL,2,47,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(115,'村野　秀二','むらの　しゅうじ',NULL,231,NULL,'guest','G3',NULL,NULL,NULL,2,25,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(116,'高橋　聡一郎','たかはし　そういちろう',NULL,232,NULL,'guest','G4',NULL,NULL,NULL,2,32,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(117,'山本　杏那','やまもと　あんな',NULL,233,NULL,'guest','G5',NULL,NULL,NULL,13,2,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(118,'佐野　早紀','さの　はやき',NULL,234,NULL,'guest','G6',NULL,NULL,NULL,13,20,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(119,'前田　和良',NULL,NULL,NULL,NULL,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-21 16:13:21','2026-05-21 16:13:21'),
(120,'辻　亮',NULL,NULL,NULL,8,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-21 16:13:21','2026-05-21 17:09:19'),
(121,'下辻氏（名 TODO）',NULL,NULL,NULL,4,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-21 16:13:21','2026-05-21 16:13:21'),
(122,'藤本　勇輝',NULL,NULL,NULL,8,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-21 16:13:21','2026-05-21 16:18:58'),
(123,'権堂　千栄実',NULL,NULL,NULL,6,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-21 16:13:21','2026-05-31 10:44:05'),
(124,'御手洗宏樹',NULL,NULL,NULL,9,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-22 16:46:29','2026-05-31 10:44:05'),
(125,'山田　智子','やまだ　ともこ',NULL,235,NULL,'visitor','V1',NULL,NULL,NULL,19,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(126,'青木　裕美','あおき　ひろみ',NULL,236,NULL,'visitor','V2',NULL,NULL,NULL,19,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(127,'増田　佳久','ますだ　よしひさ',NULL,237,NULL,'visitor','V3',NULL,NULL,NULL,1,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(128,'石原　孝之','いしはら　たかゆき',NULL,238,NULL,'visitor','V4',NULL,NULL,NULL,37,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(129,'岡﨑　由香','おかざき　ゆか',NULL,239,NULL,'visitor','V5',NULL,NULL,NULL,20,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(130,'渡邉　菜都美','わたなべ　なつみ',NULL,240,NULL,'visitor','V6',NULL,NULL,NULL,13,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(131,'吉﨑　詢','よしざき　じゅん',NULL,241,NULL,'visitor','V7',NULL,NULL,NULL,9,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(132,'熊谷　龍笙','くまがい　りゅうしょう',NULL,242,NULL,'visitor','V8',NULL,NULL,NULL,34,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(133,'佐藤　久','さとう　ひさし',NULL,243,NULL,'guest','G1',NULL,NULL,NULL,31,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(134,'八田　奈緒美','はった　なおみ',NULL,244,NULL,'guest','G2',NULL,NULL,NULL,20,NULL,'2026-05-25 17:33:03','2026-05-26 09:03:23'),
(135,'森園　友喜','もりぞの　ゆうき',NULL,246,NULL,'member','17',NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:02:55','2026-06-02 08:49:44'),
(136,'米澤　侑桂','よねざわ　ゆか',NULL,248,NULL,'member','37',NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:02:55','2026-06-02 08:49:44'),
(137,'南方　優馬','なんぽ　ゆうま',NULL,NULL,10,'visitor',NULL,NULL,NULL,NULL,31,NULL,'2026-05-27 17:00:47','2026-05-27 17:00:47'),
(138,'神保　玲太',NULL,'ryotadesu.jp@gmail.com',NULL,2,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-28 17:08:50','2026-05-28 17:08:50'),
(139,'福田航平','ふくだこうへい',NULL,NULL,NULL,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:23:27','2026-05-30 13:23:27'),
(140,'寺田直史','てらだ',NULL,NULL,10,'member',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:24:25','2026-05-30 13:24:25'),
(143,'藤本勇輝',NULL,NULL,NULL,8,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:27:05','2026-05-30 13:27:05'),
(144,'山梨麗',NULL,NULL,NULL,NULL,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:27:29','2026-05-30 13:27:29'),
(145,'田辺光',NULL,NULL,NULL,NULL,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:28:06','2026-05-30 13:28:06'),
(146,'深澤 歩',NULL,NULL,NULL,2,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:33:45','2026-05-30 13:33:45'),
(147,'岩原 聡',NULL,NULL,NULL,8,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:34:19','2026-05-30 13:34:19'),
(148,'加門 紀乃',NULL,NULL,NULL,9,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-30 13:35:12','2026-05-30 13:35:12'),
(149,'木村　杏那','きむら　あんな',NULL,247,NULL,'member','18',NULL,NULL,NULL,NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(150,'門脇　優衣','かどわき　ゆい',NULL,249,NULL,'visitor','V1',NULL,NULL,NULL,11,11,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(151,'岩本　裕太','いわもと　ゆうた',NULL,250,NULL,'visitor','V2',NULL,NULL,NULL,17,20,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(152,'寺本　勲','てらもと　いさお',NULL,251,NULL,'visitor','V3',NULL,NULL,NULL,11,34,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(153,'林田　直也','はやしだ　なおや',NULL,151,NULL,'visitor','V4',NULL,NULL,NULL,30,2,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(154,'山中　享','やまなか　とおる',NULL,252,NULL,'visitor','V5',NULL,NULL,NULL,42,42,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(155,'遠藤　哲也','えんどう　てつや',NULL,253,NULL,'visitor','V6',NULL,NULL,NULL,48,41,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(156,'中西　優斗','なかにし　ゆうと',NULL,254,NULL,'visitor','V7',NULL,NULL,NULL,43,9,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(157,'和合　純弥','わごう　じゅんや',NULL,255,NULL,'visitor','V8',NULL,NULL,NULL,43,43,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(158,'Hikaru.','ひかる',NULL,256,NULL,'visitor','V9',NULL,NULL,NULL,2,12,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(159,'溝渕　善彦','みぞぶち　よしひこ',NULL,257,NULL,'visitor','V10',NULL,NULL,NULL,43,24,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(160,'瀧葉　乃葵','たきは　のあ',NULL,258,NULL,'visitor','V11',NULL,NULL,NULL,18,18,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(161,'島田　哲也','しまだ　てつや',NULL,259,NULL,'visitor','V12',NULL,NULL,NULL,1,1,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(162,'石塚　侑輝','いしづか　ゆうき',NULL,260,NULL,'guest','G1',NULL,NULL,NULL,13,5,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(163,'垣谷直人',NULL,NULL,NULL,4,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-04 12:34:16','2026-06-04 12:34:16'),
(164,'遠藤　聡美','えんどう　さとみ','mirai.realestate7678@gmail.com',150,11,'visitor',NULL,'https://ne001.ncas.jp/bni_meibo/viewsheets.php?id=NUN4RWw3aGl5SFNJQWlqeHBHVFUvUT09&chapter=bzlaQzRNTEExZ2x1dk1vUjUvVFdOUT09',NULL,NULL,NULL,NULL,'2026-06-04 07:33:36','2026-06-04 07:33:36');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2026_03_03_100001_create_members_table',1),
(5,'2026_03_03_100002_create_meetings_table',1),
(6,'2026_03_03_100003_create_participants_table',1),
(7,'2026_03_03_100004_create_breakout_rooms_table',1),
(8,'2026_03_03_100005_create_participant_breakout_table',1),
(9,'2026_03_03_100006_create_breakout_memos_table',1),
(11,'2026_03_03_100007_create_dragonfly_contact_flags_table',2),
(12,'2026_03_03_100008_create_dragonfly_contact_events_table',3),
(13,'2026_03_04_100001_create_workspaces_table',4),
(14,'2026_03_04_100002_create_contact_memos_table',4),
(15,'2026_03_04_100003_create_introductions_table',4),
(16,'2026_03_04_100004_create_one_to_ones_table',5),
(17,'2026_03_04_100005_add_memo_type_and_one_to_one_id_to_contact_memos_table',5),
(18,'2026_03_04_100006_add_workspace_id_to_contact_memos_introductions_flags',6),
(19,'2026_03_04_120000_add_notes_to_breakout_rooms_table',7),
(20,'2026_03_04_140000_create_breakout_rounds_table',8),
(21,'2026_03_04_140001_add_breakout_round_id_to_breakout_rooms_table',8),
(22,'2026_03_05_100000_add_bo_count_to_meetings_table',9),
(23,'2026_03_05_100001_remove_round_from_breakout_rooms_table',9),
(24,'2026_03_05_100001_create_categories_table',10),
(25,'2026_03_05_100002_add_category_id_to_members_table',10),
(26,'2026_03_05_100003_migrate_members_category_to_categories',10),
(27,'2026_03_05_100004_remove_category_from_members_table',10),
(28,'2026_03_05_100005_create_roles_table',11),
(29,'2026_03_05_100006_create_member_roles_table',11),
(30,'2026_03_05_100007_migrate_members_role_notes_to_member_roles',11),
(31,'2026_03_05_100008_remove_role_notes_from_members_table',11),
(32,'2026_03_05_120000_add_owner_member_id_to_users_table',12),
(33,'2026_03_17_100001_create_meeting_participant_imports_table',13),
(34,'2026_03_17_120000_add_parse_fields_to_meeting_participant_imports',14),
(35,'2026_03_17_140000_add_extracted_fields_to_meeting_participant_imports',15),
(36,'2026_03_17_160000_add_apply_history_to_meeting_participant_imports',16),
(37,'2026_03_17_200000_create_meeting_csv_imports_table',17),
(38,'2026_03_19_100000_add_imported_at_applied_count_to_meeting_csv_imports',18),
(39,'2026_03_17_220000_create_meeting_csv_apply_logs_table',19),
(40,'2026_03_17_230000_create_meeting_csv_import_resolutions_table',20),
(41,'2026_03_20_100000_create_bo_assignment_audit_logs_table',21),
(42,'2026_03_20_120000_add_default_workspace_id_to_users_table',22),
(43,'2026_03_20_150000_add_workspace_id_to_members_table',22),
(44,'2026_03_31_120000_add_ncast_profile_url_to_members_table',22),
(45,'2026_04_07_110000_add_weekly_presentation_body_to_members_table',23),
(46,'2026_04_08_090000_create_countries_regions_add_region_id_to_workspaces',24),
(47,'2026_05_17_220800_add_start_dash_presentation_body_to_members_table',24),
(48,'2026_05_18_080000_add_referral_kind_to_introductions_table',25),
(49,'2026_05_18_080100_create_internal_referrals_table',25),
(50,'2026_05_18_120459_add_email_to_members_table',26),
(51,'2026_05_18_120700_create_personal_access_tokens_table',27),
(52,'2026_05_18_121111_add_religo_role_to_users_table',28),
(53,'2026_05_30_060000_create_zoom_accounts_table',29),
(54,'2026_05_30_060100_create_zoom_meeting_imports_table',29),
(55,'2026_05_30_060200_add_zoom_columns_to_one_to_ones_table',29),
(56,'2026_05_30_060300_create_zoom_import_apply_logs_table',29),
(57,'2026_05_30_103000_create_user_ai_credentials_table',30),
(58,'2026_05_30_103100_create_one_to_one_attachments_table',30),
(59,'2026_06_02_153400_create_meeting_minutes_table',31),
(60,'2026_06_03_131800_add_cancel_fields_to_one_to_ones_table',32),
(61,'2026_06_04_120000_create_user_zoom_credentials_table',33),
(62,'2026_06_04_100000_rename_default_workspace_to_dragonfly',34);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `one_to_one_attachments`
--

DROP TABLE IF EXISTS `one_to_one_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `one_to_one_attachments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `one_to_one_id` bigint(20) unsigned NOT NULL,
  `target_member_id` bigint(20) unsigned DEFAULT NULL,
  `uploaded_by_user_id` bigint(20) unsigned DEFAULT NULL,
  `source_type` varchar(20) NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `source_url` varchar(1024) DEFAULT NULL,
  `original_name` varchar(255) DEFAULT NULL,
  `extracted_text` longtext DEFAULT NULL,
  `parsed_profile` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`parsed_profile`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `one_to_one_attachments_uploaded_by_user_id_foreign` (`uploaded_by_user_id`),
  KEY `one_to_one_attachments_one_to_one_id_index` (`one_to_one_id`),
  KEY `one_to_one_attachments_target_member_id_index` (`target_member_id`),
  CONSTRAINT `one_to_one_attachments_one_to_one_id_foreign` FOREIGN KEY (`one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `one_to_one_attachments_target_member_id_foreign` FOREIGN KEY (`target_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_one_attachments_uploaded_by_user_id_foreign` FOREIGN KEY (`uploaded_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `one_to_one_attachments`
--

LOCK TABLES `one_to_one_attachments` WRITE;
/*!40000 ALTER TABLE `one_to_one_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `one_to_one_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `one_to_ones`
--

DROP TABLE IF EXISTS `one_to_ones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `one_to_ones` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `target_member_id` bigint(20) unsigned NOT NULL,
  `meeting_id` bigint(20) unsigned DEFAULT NULL,
  `zoom_meeting_id` varchar(255) DEFAULT NULL,
  `zoom_meeting_uuid` varchar(255) DEFAULT NULL,
  `external_source` varchar(20) NOT NULL DEFAULT 'manual',
  `scheduled_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `cancel_reason` varchar(32) DEFAULT NULL,
  `cancel_remark` text DEFAULT NULL,
  `canceled_at` datetime DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `one_to_ones_workspace_id_foreign` (`workspace_id`),
  KEY `one_to_ones_target_member_id_foreign` (`target_member_id`),
  KEY `one_to_ones_owner_member_id_target_member_id_index` (`owner_member_id`,`target_member_id`),
  KEY `one_to_ones_scheduled_at_index` (`scheduled_at`),
  KEY `one_to_ones_meeting_id_index` (`meeting_id`),
  KEY `one_to_ones_zoom_meeting_id_index` (`zoom_meeting_id`),
  KEY `one_to_ones_zoom_meeting_uuid_index` (`zoom_meeting_uuid`),
  CONSTRAINT `one_to_ones_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_ones_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `one_to_ones_target_member_id_foreign` FOREIGN KEY (`target_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `one_to_ones_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `one_to_ones`
--

LOCK TABLES `one_to_ones` WRITE;
/*!40000 ALTER TABLE `one_to_ones` DISABLE KEYS */;
INSERT INTO `one_to_ones` VALUES
(6,1,37,31,NULL,NULL,NULL,'manual','2026-03-06 05:00:00',NULL,'2026-03-06 06:00:00','completed',NULL,NULL,NULL,'お互いのビジネスの紹介\nシステムと助成金で協業できそう。見積もりが作成できればOK','2026-03-23 12:47:04','2026-03-23 12:47:04'),
(7,1,37,42,NULL,NULL,NULL,'manual','2026-03-11 04:00:00',NULL,'2026-03-11 05:00:00','completed',NULL,NULL,NULL,'お互いのビジネス紹介','2026-03-23 12:48:50','2026-03-23 12:48:50'),
(8,1,37,44,NULL,NULL,NULL,'manual','2026-03-12 05:00:00',NULL,'2026-03-12 06:00:00','completed',NULL,NULL,NULL,'アナログな生産管理をシステム化に前向き\n提案書を提出済み','2026-03-23 12:49:51','2026-03-23 12:49:51'),
(9,1,1,11,NULL,NULL,NULL,'manual','2026-03-16 02:00:00',NULL,'2026-03-16 03:00:00','completed',NULL,NULL,NULL,'お互いのビジネスの紹介','2026-03-23 12:51:50','2026-03-23 12:51:50'),
(10,1,37,10,NULL,NULL,NULL,'manual','2026-04-02 06:00:00',NULL,'2026-04-02 07:00:00','completed',NULL,NULL,NULL,'エアコン本舗案件メモ（保存用）\n\n■ 概要\n	•	倉持氏との打ち合わせにて以下2点が前進\n	•	ウェブマスター役割の打診 → 前向きに検討\n	•	エアコン本舗案件 → 開発チーム参画の可能性あり\n	•	次回アクション：4月13日 1to1（11:00〜12:00）\n\n⸻\n\n■ 決定事項\n\n① ウェブマスター\n	•	次廣が担当する方向で調整\n	•	BNI内の運営・情報管理ポジション\n\n② 1to1ミーティング\n	•	日時：4月13日 11:00〜12:00\n	•	倉持氏よりZoom URL共有予定\n\n③ エアコン本舗案件\n	•	チーム参画の方向で検討開始\n	•	本格開発は秋頃予定\n\n⸻\n\n■ ウェブマスター業務（理解整理）\n\n● 主業務\n	•	BNIサイト管理（メンバー情報・公開設定）\n	•	定例会サポート（Zoom・スライド・録画）\n	•	動画編集・アップロード（週次）\n	•	SNS運用（Facebook / LINEの使い分け）\n	•	ビジター情報管理（Nキャス）\n\n● 使用ツール\n	•	BNIコネクト\n	•	Nキャス\n	•	Zoom\n	•	Facebook / LINE\n\n⸻\n\n■ エアコン本舗案件（重要）\n\n● 課題\n	•	業務フローが非効率（受注〜施工）\n	•	売上・利益の可視化が遅い（約1ヶ月遅延）\n\n● 提案内容（予定）\n	•	受注管理システム\n	•	在庫・発注の自動化\n	•	アサイン最適化\n	•	AI電話による日程調整\n\n● 開発タイミング\n	•	夏：計測・準備フェーズ\n	•	秋：本格開発\n\n● 体制\n	•	PM：倉持氏\n	•	PMコーチ：佐野氏（元アクセンチュア）\n	•	技術：伊藤氏（GPS最適化）\n	•	開発候補：次廣（tugilo）\n\n⸻\n\n■ 自分の強み（再認識）\n	•	工程管理・アサイン系システムの構築経験あり\n	•	LINE連携システム実績あり\n	•	フルスタック対応（BE/FE/インフラ）\n	•	業務理解＋エンジニア橋渡しができる\n\n⸻\n\n■ 4/13 1to1の目的\n\n● ゴール\n	•	エアコン本舗案件の関わり方を具体化\n	•	自分の役割ポジションを明確にする\n\n⸻\n\n■ 1to1で確認すること\n\n● ウェブマスター\n	•	期待されている役割範囲\n	•	工数・優先度\n\n⸻\n\n● エアコン本舗（最重要）\n\n現状把握\n	•	一番のボトルネックはどこか\n	•	現場 or 管理どちらが詰まっているか\n	•	現在の業務フロー\n\n深掘り質問（tugilo視点）\n	•	人依存になっている部分は？\n	•	同じ入力を何回しているか？\n	•	数字はいつ確定しているか？\n\n⸻\n\n■ 提案方針（tugilo式）\n\n❌ いきなり開発しない\n\n⭕ 小さく始める\n\n⸻\n\n● フェーズ設計\n\nPhase1：見える化\n	•	データ収集・現状把握\n\nPhase2：整理\n	•	フロー整理・無駄削減\n\nPhase3：システム化\n	•	必要部分のみ実装\n\n⸻\n\n■ キーメッセージ\n\n👉\n「現場は変えない。でも、気づいたら楽になっている状態を作る」\n\n⸻\n\n■ 次アクション\n\n事前\n	•	1to1質問整理\n	•	エアコン業界の流れ軽く把握\n\n事後\n	•	業務フローの構造図作成\n	•	フェーズ提案資料作成\n\n⸻\n\n■ メモ（気づき）\n	•	ウェブマスターは信頼獲得ポジション\n	•	エアコン本舗はtugiloの勝ちパターン案件\n	•	「いきなり作らない」が今回のキー','2026-04-02 21:05:22','2026-04-02 21:05:22'),
(11,1,37,17,NULL,NULL,NULL,'manual','2026-04-02 22:15:00',NULL,'2026-04-02 23:15:00','completed',NULL,NULL,NULL,'#### 基本情報\n\n- **日時:** **2026-04-03（金）JST 07:15–08:15**（60分）。**取得元:** ユーザー確認（当日の1to1実績）。※過去の Zoom要約段階では日時未記載だったため、本項で確定。\n- **実施方法:** Zoom\n\n#### 話した内容（重要）\n\n※**削減せず**蓄積。以下は Zoom要約・当時の整理メモからの**記録**。\n\n- **主な流れ:** 次廣淳（AI・業務改善システム構築）と佐藤拓斗（高校生新卒採用コンサル）が BNI ドラゴンフライチャプターで **初回 1on1**。両者の事業内容を共有し、**テレアポリスト自動作成システム**の開発可能性について具体的検討を開始。静岡県藤枝市という地元の共通点から、今後の協力関係構築の基盤を確立した、との整理。\n- **決定・合意:**\n  - **リスト作成システムの検討開始:** 佐藤氏のテレアポリスト作成業務（現在手作業で **1時間100件**）を自動化するシステムについて、次廣氏が **技術的実現可能性を調査**。\n  - **求人媒体からのデータ取得:** リクナビネクスト等の求人サイトから、**従業員数30名以下** などの条件で自動抽出する仕組みを検討。**スクレイピング技術の活用**、ただし **法的リスクの確認が必要**。\n  - **5月中旬の再会:** 佐藤氏の静岡帰省時（**5月16–17日頃**）に **対面ミーティング** を設定する方向。\n- **次廣側で共有された事業内容:**\n  - **業務改善システム構築:** エクセル・スプレッドシートで分散管理されているデータを一元化し、リアルタイムでの進捗確認を実現。\n  - **LINE活用システム:** 問い合わせから見積もり、請求までを LINE 公式アカウントで完結させる仕組み（建設業向け）。\n  - **スタンプラリー・ビンゴシステム:** 静岡観光協会向けに **5年間運用中**。\n  - **施工管理・日報システム:** 名古屋のシーリング会社向けに、外国人労働者でも入力しやすい LINE ベースの業務日報システムを構築。\n  - **事業の特徴:** ゼロから1を作れる／既製ツールの押し付けではなく現場フローに合わせたカスタマイズ。**小さく始めて改善**（大規模を一気に入れず、入力から段階拡張）。**現場負担の最小化**（経営と現場のギャップを埋め、現場にベネフィットを与える設計）。\n  - **経歴・背景:** システム開発歴 **25–26年**（大学中退後一貫、現在 **52–53歳**）。BNI は増本氏・今西氏との静岡出世クラブでの **約10年の付き合い** から **2024年** にドラゴンフライ参加を決意。動機は技術一辺倒からの転換・仕事の幅拡大。**MSP（メンバーサクセスプログラム）** で学んだビジネススキルに感銘、トレーニング注力中。\n- **佐藤側で共有された事業内容（1to1上の詳細・プロフィールと照合可）:**\n  - **高校生新卒採用の仕組み構築:** ホームページ制作、パンフレット・動画制作、学校訪問代行、求人資料郵送代行まで一括。\n  - **4月依頼でも7月解禁に間に合う** 短期対応が可能。**全国対応**（BNI参加により全国展開が加速）。\n  - **ターゲット:** 従業員 **30名以下** が中心（プロフィールは **20〜30名以下** — 会話では30名以下条件でリスト抽出の話あり）。タイプ **3つ**: ①高校生採用のやり方が分からない ②やりたいが時間・人員不足 ③応募が来ない（我流で抜けがある）。業種: 建設業、製造業、自動車整備、ビルメンテナンス、清掃、介護福祉など。\n  - **実績:** **2024年度** 29社サポート、14社で採用成功（成功率 **約48%**）。**過去5年** 毎年40社以上サポート（2023年32社、2024年は50社近く）。\n  - **経歴・背景:** 事業歴 **5年**。新卒で高校生新卒採用コンサル会社に入社、**2024年3月に独立**（当時 会社設立から **1年** と共有）。学歴: 清水東高校→静岡大学→早稲田大学編入→早稲田大学大学院（**教員免許保有**）。**将来ビジョン:** 高校生以下を対象としたキャリア教育事業。**五教科と社会を結びつける授業** で子どもの将来の選択肢を広げたい。\n- **確認待ち（会話上の論点）:**\n  - リクナビネクストからのデータ取得: **技術的実現可能性** と **法的リスク（利用規約上の二次利用制限）** を次廣氏が調査中。\n  - Google マイビジネス API: 個人事業主リスト作成について、**二次利用禁止ルール** があり、公開情報からの取得方法を検討。\n- **共通点・シナジー:**\n  - **地元:** 両者とも静岡県藤枝市出身・在住。佐藤氏は藤枝市古利（西焼津小学校区）、次廣氏は青葉町（青島中学校区）。\n  - **教育への関心:** 次廣氏は娘の受験を控え、佐藤氏のキャリア教育理念（五教科と社会の結びつけ）に強く共感。\n  - **システム×採用:** 次廣氏は静岡県の大卒求人サイト **「三並び」** のアプリ開発を受注中。**大学生がメールを見ない** ため通知機能が必要、という課題を共有。\n- **アクションアイテム（当時の整理）:**\n  - 次廣氏: 求人媒体からのリスト自動作成システムの **技術調査・提案準備**。\n  - 佐藤氏: **5月中旬の静岡帰省日程確定後**、次廣氏に連絡。\n  - 両者: **名古屋出世クラブ（5月末）** への参加可能性を検討（今西氏が佐藤氏を誘致中）。\n- **次回ミーティング:** **5月16–17日頃**、佐藤氏静岡帰省時に **対面** で実施予定。\n- **プライベート文脈（会話に出た事実の記録・紹介判断とは分離）:** 婚活、飯田氏からの占い（**32歳で結婚** 等）、保険担当の高校同級生からの紹介の動きなどが要約に含まれる。**取り扱い注意。本人確認のうえ参照。**\n\n#### 抽出された課題（事実：会話で言及）\n\n- テレアポ用リスト作成の **手作業負荷**（約1時間100件ペース）。\n- 求人媒体からの自動取得は **技術** に加え **利用規約・法的リスク（二次利用）** の確認が必要、との合意。\n- Google マイビジネス／公開情報は **二次利用禁止** の話題があり、個人事業主リストは **取得経路の設計** が課題。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** リスト作成が **コンサル本業とリソース競合** している。**根拠:** 手作業1時間100件の共有。**構造（仮説）:** リード前処理が属人・手作業 → 営業・提案に振る時間が圧迫 → スケールしにくい。\n- **課題②:** データ取得は **「作れるか」より「取ってよいか」** が先に決まる。**根拠:** スクレイピング・API の **法的リスク確認** が合意事項。**構造（仮説）:** 技術要件とコンプライアンスが分離できないと、開発が進んでも運用不能になりうる。\n- **シナジー:** 「採用」周辺に **通知・進捗・フォロー** のデジタル化が横展開しうる。**根拠:** 三並び案件で **メールを見ない大学生** と通知ニーズの共有。**仮説**としての展開可能性。\n\n#### 次アクション\n\n- 次廣: 技術調査・法務・規約リスク整理・提案準備。\n- 佐藤: 帰省日程確定後に連絡 → 5/16–17頃 対面設定。\n- 双方: 名古屋出世クラブ（5月末）参加の検討。','2026-04-07 03:35:52','2026-04-13 14:11:46'),
(12,1,37,136,NULL,NULL,NULL,'manual','2026-04-08 09:00:00','2026-04-08 09:00:00','2026-04-08 10:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_yonezawa_yuka_comechan_design.md】\n\n# 1to1整理：米澤 侑桂（Comechan Design）\n\n---\n\n**文書の位置づけ:** BNI DragonFly の **ビジター／見込み** に対し、「協業可能性の検討」と「次アクション明確化」を目的とした整理。**単なる議事録ではなく**、tugilo 視点（課題発見・価値提供・仕組み化）でまとめた。**§10〜14** は **2026-04-08 時点で確定した協業内容・案件・スキル・稼働・成功要因**（要約入力ベース）。**§15〜18** は **それ以前に作成した再現用ナレッジ**（ヒアリング構成・台本・改善・施策）；**§15〜16 のドラフト**は、今回の合意後も **別種の1to1用テンプレ** として残す。**更新箇所**は見出し付近の **【2026-04-08 更新】**、または本文での **「当初仮説／実際の会話で判明」** の対比で明示。\n\n---\n\n## 1. 基本情報\n\n**【2026-04-08 更新】**\n\n- **日付（ドキュメント・協業要約反映）:** **2026-04-08**\n- **第1回 1to1 実施日時（JST）:** **2026-04-08（水）09:00–10:00**（**1時間**）\n- **Religo 1to1 レコード:** `one_to_ones.id = 12`（**1セッション＝DB 1行**）\n- **相手名:** 米澤 侑桂（よねざわ ゆか）\n- **事業内容:** Web デザイン〜**コーディング・実装まで一貫**（**2026-04-08 1to1 で確認**）\n- **現在のステータス（BNI）:** **ビジター**（シート上の経緯は以下も参照）。**オリエン:** 2026-04-07 実施（太田氏）。**協業（tugilo×米澤）:** **合意済み**（別レイヤーで管理）\n\n---\n\n## 2. 1to1の要約（サマリ）\n\n**【2026-04-08 更新】**\n\n- **主な成果:** 米澤は **デザインからコーディング・実装まで一貫対応可能** な Web デザイナー兼エンジニアであることを **確認**。次廣は **来週契約予定の「学生向け求人サイト」アプリ化案件**において、**フロント部分のデザインとコーディングを米澤に依頼する方向で合意**した。\n- **協業の位置づけ:** 「検討」ではなく **協業開始の合意**（範囲・単価帯・次工程は **来週以降の契約・打ち合わせで確定**）。\n- **並行案件:** **古紙回収** の LINE アプリ用 **リッチメニュー 2 件**（法人用・個人用）を米澤に依頼することを **決定**。\n- **価格:** リッチメニュー **4,000〜5,000 円／枚**、LP は **規模に応じた工数ベース見積もり**（**2026-04-08 合意**）。\n- **補足（過去の第三者メモ等）:** 福上氏・廣田氏・倉持氏メモにあった「コスパ・反応率・コーディング可」等は **引き続き有効な背景情報**。BNI 入会は別論点（§7 参照）。\n\n---\n\n## 3. 相手のビジネス理解（As-Is）\n\n### 3.1 提供サービス\n\n- **Web:** LP 制作、サイト制作、画像・バナー、印刷物デザイン（ポートフォリオ・過去情報）\n- **プロセス:** お問い合わせ後の返信 SL（2営業日）、ヒアリング、制作、確認／修正、納品・公開（[サービスの流れ・料金](https://comechan-design.com/flow-services-fees/)）\n- **【2026-04-08 更新】1to1で確認:** デザインに加え **コーディング・実装・ディレクション**まで対応可能。**資料・ロゴ等も依頼に応じて対応**（「基本何でも対応」方針）\n\n### 3.2 強み\n\n- **実績・評価:** 協業パートナーとして「コストと品質のバランス」「デザイン連携に推薦」という紹介メモあり\n- **他との違い:** 「かっこいい・可愛い」だけでなく **反応率・成果** にフォーカスするデザイン、とのメモあり\n- **【2026-04-08 更新】1to1で確認:** **Tailwind CSS**、**JavaScript フレームワーク（React Native 含む）** の実装経験、**レスポンシブ**、**アプリデザイン経験**（例：マッチングアプリでデザイン・ディレクター）。**AI 活用:** Claude Code、ChatGPT、Gemini でコーディングの統一化・効率化\n\n### 3.3 案件の特徴\n\n- **クライアント層:** 中小〜法人向け Web／LP 需要\n- **単価・ボリューム:** **2026-04-08 合意:** リッチメニュー **4,000〜5,000 円／枚**、LP は **工数ベース**。**短納期例:** 1 週間で Studio 上 LP（デザイン＋コーディング同時進行・約 20 時間）。**通常:** デザイン＋コーディングで **約 3 週間** 程度\n\n---\n\n## 4. 課題・ボトルネック（Fit & Gap視点）\n\n### 4.1 現在の課題（As-Is）\n\n- **当初仮説（CRM・オリエン前）:** クライアント案件中心で **4〜5月は時間が取りにくい**、属人的オペレーション\n- **【2026-04-08 更新】実際の会話で判明:** 昨年は **Web 講師業務**で多忙だったが、**現在は卒業し余裕が出ている**。**業務委託先 2 社と継続契約**（クラウドワークス経由で獲得、**2 年以上継続**）。**定常の業務委託より、個人案件で一緒に作り上げる仕事を増やしたい**意向\n- **詰まっている業務・非効率:** 求人サイト案件では **メール開封率の低さ** → **プッシュ通知**で解消する設計が論点（§11）。詳細仕様は **来週以降の契約・打ち合わせ後** に詰める\n\n### 4.2 理想状態（To-Be）\n\n- **望む働き方:** **長期的なクライアント関係**・**量より質**（当初メモの要旨）\n- **【2026-04-08 更新】** **個人案件として共同で作る仕事**を増やしたい（tugilo 案件との協業と方向性が一致）\n\n### 4.3 ギャップ\n\n- **当初:** マーケ仕組みまで一気通貫はリソース不足しがち、と整理\n- **【2026-04-08 更新】** ギャップは **案件単位で解消に動いている**（フロントは米澤、基盤・通知・アプリは次廣側で分担予定）。**残る論点:** **Flutter / React Native**、**WebView 実装**の最終選定（保留）\n\n---\n\n## 5. tugilo視点での価値提供可能性\n\n**【2026-04-08 更新】**\n\n- **確定案件ベース:** **学生向け求人サイト** — 既存 **PHP ベース Web** を **WebView でアプリ化**、**プッシュ通知**で **メール未到達**を補う。**次廣:** アプリ基盤・契約・バックエンド／通知周り。**米澤:** **フロントのデザイン・コーディング**（合意済み）。\n- **LINE:** **古紙回収** LINE アプリの **リッチメニュー 2 枚** — 次廣が要件提示、米澤が制作（単価レンジ合意済み）。\n- **抽象からの落とし込み:** 「計測・フォーム連携」一般論に加え、上記 **2 案件** を **そのまま SOW に落とす**ことが次ステップ（§8・§11）。\n\n---\n\n## 6. 協業パターン整理（具体案）\n\n### 確定協業パターン（2026-04-08 時点）\n\n| 項目 | 内容 |\n|------|------|\n| **体制** | 次廣の **システム開発案件**に、米澤が **デザイン・コーディング・実装（フロント）** を担当する形で **協業開始に合意** |\n| **案件①** | **学生向け求人サイトアプリ化** — フロントのデザイン＆コーディングを **米澤へ依頼する方向で合意**（**来週契約**予定のプロジェクト） |\n| **案件②** | **古紙回収 LINE** — リッチメニュー **2 件**（**法人用・個人用**）を米澤へ **依頼決定** |\n| **価格** | リッチメニュー **4,000〜5,000 円／枚**、**LP** は **規模に応じ工数ベース見積もり** |\n\n### パターンA：案件分担型（当初案・参考）\n\n- **内容:** 米澤 **デザイン＋コーディング**／tugilo **フォーム・DB・通知・集計** — **→ 実案件ではこの型で進行する見込み**（§10 参照）\n\n### パターンB：共同提案型（当初案・参考）\n\n- **内容:** 「LP＋改善プラン」等 — **並行して**中長期で使えるテンプレ。**今回の合意案件とは別枠**で検討可\n\n### パターンC：紹介連携型（当初案・参考）\n\n- **内容:** 福上氏・西浦氏経由のパートナー固定 — **関係継続用**。**確定協業**（上表）が最優先の実行単位\n\n---\n\n## 7. 相性評価（重要）\n\n| 観点 | 評価 | メモ |\n|------|------|------|\n| **スキル相性** | **◎** | **2026-04-08:** デザイン〜実装一貫・Tailwind／RN 経験等を **会話で確認**。フロント分担が明確 |\n| **価値観相性** | **◎〜○** | **個人案件で共創**を増やしたい意向と、tugilo 側の案件が接続 |\n| **コミュニケーション** | **○** | **合意に至った**。**保留**は仕様・技術選定のみ（§11） |\n| **パートナー適性** | **◎（案件上）** | **協業が具体案件に落ちた**。BNI 入会は別 KPI |\n\n---\n\n## 8. 次アクション（必ず明確化）\n\n**【2026-04-08 更新】**\n\n### 次廣（tugilo）がやること\n\n| 期限目安 | 内容 |\n|----------|------|\n| **来週（契約締結後）** | **学生向け求人サイトアプリ化**の **具体仕様**を米澤と **再度打ち合わせ**（契約・社内手続き後の最初の工程として実施） |\n| **至急** | **古紙回収 LINE リッチメニュー 2 件**について、**要件（文言・導線・ブランドトーン・サイズ制約）** を米澤に **共有** |\n| **運用** | Religo の **1to1 レコード**に **第1回: 2026-04-08 09:00–10:00（JST）** を **`started_at` / `ended_at`** で登録。**`notes`** に本要約の要点を転記 |\n\n### 米澤がやること\n\n| 期限目安 | 内容 |\n|----------|------|\n| **要件受領後** | リッチメニュー **2 件**の **制作・納品**（単価は **4,000〜5,000 円／枚** で合意済み — **最終見積は枚数・修正回の条件で確定**） |\n| **詳細打ち合わせ後** | 求人サイトアプリ化の **フロント見積・スケジュール**を提示 |\n\n### 次回ミーティング\n\n- **来週以降:** **学生向け求人サイトアプリ化**の **詳細打ち合わせ**（**契約打ち合わせ完了後**が前提）\n\n---\n\n## 9. メモ・気づき\n\n- **【2026-04-08 更新】** **協業が「具体案件＋単価レンジ」まで到達** — 当初の「メンバー化より先に協業実績」の方針と整合\n- **印象的な点:** **短納期 LP（1 週間・約 20h）**、**太田氏案件でコーディング専任 2 件** — BNI 内連携の実績あり\n- **BNI視点:** ビジター枠と **案件パートナー枠** は分けて管理（混同しない）\n\n---\n\n## 10. 実績ベースの協業内容\n\n**【2026-04-08 新規】**\n\n| 項目 | 確定内容 |\n|------|----------|\n| **協業体制** | 次廣の **システム開発案件**において、米澤が **デザイン・コーディング・実装（フロント中心）** を担当する形で **協業開始に合意** |\n| **担当分担** | **次廣:** プロジェクト全体・契約・アプリ／通知／WebView 側の実装方針。**米澤:** **フロントのデザインとコーディング**（求人サイトアプリ化）。**リッチメニュー:** 米澤が **制作**、次廣が **要件提示・運用コンテキスト（古紙回収 LINE）** |\n| **案件内容（合意済み）** | ① **学生向け求人サイトアプリ化**（フロント依頼）② **古紙回収 LINE リッチメニュー** 法人・個人の **2 件** |\n| **価格感** | **リッチメニュー:** **4,000〜5,000 円／枚**。**LP:** **規模に応じ工数ベース**（案件ごと見積もり） |\n\n---\n\n## 11. プロジェクト詳細\n\n**【2026-04-08 新規】**\n\n### 11.1 学生向け求人サイトアプリ化\n\n| 項目 | 内容 |\n|------|------|\n| **背景** | 既存 **PHP ベース Web サイト**を **WebView 形式でアプリ化**。**メール開封率の低さ**を補うため **プッシュ通知**を実装 |\n| **技術スタック** | **WebView ベース**で iOS／Android。**Flutter 採用を検討中**（**React Native** との **最終選定は保留**） |\n| **納期・公開** | **オープン予定: 2026年4月**（入力メモに「2025年4月」の表記あり — **年度誤記の可能性大**。**カレンダー上は 2026-04 を正として要確認**）。**段階的リリース**で機能追加 |\n| **デザイン要件（合意・方向性）** | 画面下部に **リッチメニュー風ナビ**（ホーム、マイページ等）＋ **Web 画面表示** |\n| **保留** | **具体仕様**は **来週以降の契約打ち合わせ後**に詰める。**Flutter / RN**、**WebView の実装方法**は **技術選定として別途協議** |\n\n### 11.2 古紙回収 LINE — リッチメニュー 2 件\n\n| 項目 | 内容 |\n|------|------|\n| **概要** | 次廣が運営する **古紙回収** の **LINE アプリ**用リッチメニュー **法人用・個人用** の **2 件** |\n| **決定事項** | 米澤への **依頼を決定**。単価 **4,000〜5,000 円／枚** |\n| **次アクション** | 次廣が **具体要件を共有** → 米澤が **制作** |\n\n---\n\n## 12. スキル・評価（実証ベース）\n\n**【2026-04-08 新規】**（1to1で確認した内容のみ）\n\n- **技術範囲:** **デザイン、コーディング、実装、ディレクション**まで **一貫対応可能**（本人確認）\n- **スタック・経験:** **Tailwind CSS**、**JavaScript フレームワーク（React Native 含む）**、**レスポンシブ**、**アプリデザイン経験**（例：**マッチングアプリ**でデザイン・ディレクター）\n- **対応スタイル:** **「基本何でも対応する」** — 資料作成・ロゴ等も **依頼に応じて対応**\n- **AI 活用:** **Claude Code、ChatGPT、Gemini** でコーディングの **統一化・効率化**\n- **案件実績（会話ベース）:** **1 週間**で Studio 上 **LP**（デザイン＋コーディング同時進行・**約 20 時間**）。**通常** デザイン＋コーディング **約 3 週間**。**太田氏**から **デザインデータのみ**受領し **コーディングのみ**した案件 **2 件**\n\n---\n\n## 13. 稼働状況\n\n**【2026-04-08 新規】**\n\n- **業務委託:** **2 社**と **継続契約中**（**クラウドワークス**経由で獲得、**2 年以上**）\n- **稼働:** **昨年**は **Web 講師**で多忙 → **現在は卒業し余裕**が出ている\n- **方向性:** **業務委託の定常業務より**、**個人案件で一緒に作り上げる仕事**を増やしたい\n\n---\n\n## 14. 成功要因分析（重要）\n\n**【2026-04-08 新規】**\n\n1. **スキル境界の明確化:** 「デザインだけでなく **実装まで**」を **会話で実証**でき、次廣側の **フロント外注** にそのまま載せられた。\n2. **案件の具体度:** 「いつか協業」ではなく、**来週契約予定の求人サイト案件**と **単価決定済みのリッチメニュー**があり、**SOW に落としやすい**。\n3. **単価レンジの合意:** リッチメニュー **4,000〜5,000 円／枚**、LP **工数ベース**で **認識齟齬を先に潰した**。\n4. **志向の一致:** 米澤の **個人案件で共創したい**と、tugilo 側の **外注パートナー需要**が一致。\n5. **保留の切り分け:** 仕様・**Flutter/RN** は **保留にしたまま**、**フロント依頼とリッチメニュー**は **決められた** — 決められるところから進める形。\n\n---\n\n## 15. 1時間ヒアリング構成（実施ベース・再現用ドラフト）\n\n### 15.0 実施状況（事実／未実施の切り分け）\n\n| 区分 | 内容 |\n|------|------|\n| **事実** | **第1回 1to1:** **2026-04-08 JST 09:00–10:00**。協業合意・要約を本文に反映済み |\n| **参照できた事実** | **第三者** の対応履歴メモ（倉持氏 等）は、**背景理解**に有用 |\n| **§15.1 の扱い** | **次回** 別相手／別回で **同品質のヒアリング**をするための **推奨タイムライン（ドラフト）** |\n| **§15.2 の扱い** | (A) 第三者メモからの型 (B) **次回**用の質問表。**今回の合意後**、(B) の一部は **§12 で事実化済み** |\n\n---\n\n### 15.1 タイムライン\n\n**【ドラフト・次回1to1用】協業仮説の検証に最適化した 60 分**\n\n- **0〜10分：** アイスブレイク、**今日の目的の合意**。BNI はプレッシャーをかけない。\n- **10〜30分：** **仕事の型** — 案件の流れ、得意ジャンル、デザインとコーディングの **役割分担**。\n- **30〜45分：** **ボトルネックと理想** — 成果の見せ方、tugilo の価値を **1例** で提示。\n- **45〜60分：** **協業の切り口**を **1つに絞る**、次の一手・次回接触日。\n\n※ **実1to1の文字起こしがある場合**、各帯を **事実** で上書きし、**§2・§10** と整合させる。\n\n---\n\n### 15.2 実際に効果的だった質問\n\n#### (A) 第三者対応履歴から見える「深掘りの型」（事実：メモに結果が残っている）\n\n（変更なし — 倉持氏メモ等の分析）\n\n#### (B) 次回 tugilo が使う推奨質問（未確認／ヒアリングで埋める）\n\n※ **2026-04-08 時点で §12・§11 に一部回答済み**。残りは案件進行中に更新。\n\n| 質問内容（例） | 相手の反応（記入予定） | 得られた気づき（記入予定） |\n|----------------|------------------------|----------------------------|\n| 納品後の効果の見せ方 | **§12 参照** — 必要なら案件ごとに追記 | |\n| 協業時の窓口 | **次回打ち合わせで確定** | |\n| Flutter/RN・WebView | **保留**（§11.1） | |\n\n---\n\n## 16. 1to1台本（再現用）\n\n**【ドラフト】** 同種の相手（デザイン事業・ビジター・多忙・協業検討）に転用可。**丸暗記ではなく「抜けたら戻る目印」** として使う。実施後、**実際の言い回し** で差し替え。\n\n### 16.1 導入\n\n**台本（例）：**\n\n「今日は時間を取っていただきありがとうございます。僕は **業務改善とシステム** をやっていて、デザイン会社さんとは **フロントの外側—計測やフォーム連携** でよく組んでいます。今日は **米澤さんの仕事の流れと、一緒に案件が作れるか** を知りたくてきました。BNI の入会とかは今日決めなくて大丈夫です。」\n\n### 16.2 深掘りパート（テーマ別）\n\n#### ■ 仕事理解\n\n| | 内容 |\n|---|------|\n| **質問** | 「よくある案件の流れを、お客さんが来てから納品まで **15分で** 教えてもらえますか？」 |\n| **想定される回答** | 問い合わせ → 返信 → ヒアリング → 制作 → 修正 → 納品（サイトの [サービスの流れ](https://comechan-design.com/flow-services-fees/) と整合） |\n| **深掘り質問** | 「その中で **米澤さんの手が一番止まる** のはどこですか？」「**パートナーに出す／全部やる** の線引きは？」 |\n\n#### ■ 強み\n\n| | 内容 |\n|---|------|\n| **質問** | 「紹介で選ばれるとき、**何と言われますか？**（コスパ、反応率、トーンなど）」 |\n| **深掘り** | 「**デザインだけ** の案件と **実装まで** の案件の比率は？」「逆に **やらない** 仕事は？」 |\n\n#### ■ ボトルネック\n\n| | 内容 |\n|---|------|\n| **質問** | 「今いちばん **忙しいのは案件のどのフェーズ** ですか？ お客さんの **成果の説明** で困ることはありますか？」 |\n| **深掘り** | 「**計測** は誰が見ますか？ **フォームの問い合わせ** はどこに溜まっていますか？」 |\n| **→ tugiloの関与余地** | 「納品後の **数字の見える化** と、**問い合わせ〜社内の一元化** はこちらでよく組みます。**デザインは米澤さん、仕組みは僕** でパッケージにすると、お客さんに **セットで説明しやすい** です。」 |\n\n#### ■ 将来\n\n| | 内容 |\n|---|------|\n| **質問** | 「**1年後**、お客さんとの関係で **増やしたいもの／減らしたいもの** はありますか？」 |\n| **深掘り** | 「BNI は **紹介の幅** 目的ですか、それとも **学び** 目的ですか？ **無理のない頻度** はどのくらいですか？」 |\n\n#### ■ 協業導線\n\n| | 内容 |\n|---|------|\n| **自然な切り出し** | 「もしよければ **LP1本を想定** に、**納品後3ヶ月だけ** 計測と改善の枠を付けたとき、**米澤さんの見積もりの置き方** はどうなりますか？ 僕側は **◯万から** のイメージで…（※実数値は別紙）」 |\n| **相手の反応** | **2026-04-08 以降:** 合意の事実は **§8・§10** を正とする |\n\n### 16.3 クロージング\n\n| | 内容 |\n|---|------|\n| **次に繋げる一言（例）** | 「今日の話を踏まえて **A4一枚の分担図** を作ります。**◯日まで** に共有して、**15分だけ** フィードバックもらえますか？ 忙しければ **6月** でも大丈夫です。」 |\n| **実際の反応** | **2026-04-08 以降:** 合意内容は **§8・§10** を正とする |\n\n---\n\n## 17. 会話改善ポイント\n\n### 17.1 良かった点\n\n- **第三者メモから見える「話しやすさ」の要因（推定）:** 仕事の話に **具体名（協業先・関係者）** が出ると、**シーンが浮かぶ**（倉持氏メモのパターン）。tugilo も **紹介者名・案件タイプ** を1つ聞くと同効果が狙える。\n- **深掘りできた理由（参考）:** 「デザインだけでなく **どこまでやるか**」「**件数と関係性**」の **二軸** がメモに残っている → tugilo も同じ二軸で **聞き漏れ** を防ぐ。\n\n### 17.2 改善点\n\n- **詰まりやすい箇所（想定）:** **入会・BNI** の話が前に出すぎると、協業の時間が削られる → **冒頭で目的を言い切る**（§16.1）。\n- **聞ききれていない内容（案件で埋める）:** **§11 保留**（仕様・Flutter/RN）— **契約後の打ち合わせで確定**。**§15.2 (B)** の表と突合。\n\n---\n\n## 18. 協業確度アップ施策\n\n今回の **§10〜14** で **協業は具体化済み**。以下は **継続的な関係強化**用。\n\n### 案件化のための一手\n\n- **求人サイト:** 契約後 **SOW・画面遷移・納品物定義** を共有し、**見積・マイルストーン**を固定\n- **リッチメニュー:** **要件書 1 枚**（サイズ、文言、画像、リンク先）を先に渡す\n\n### 関係構築の次ステップ\n\n- **紹介者ルート:** 西浦氏・福上氏への **進捗共有**（一文）\n- **BNI内:** ビジター／名刺希望は **§1・シート** に従い **本人ペース**\n\n### タイミング戦略\n\n- **技術選定:** **Flutter vs RN** — **次回技術打ち合わせ**で決定表を残す\n- **Religo運用:** **`one_to_ones.notes`** に **その回の事実** を記録。本ファイルの **§2・§8・§10** と **二重管理しない**（SSOT は本ファイルまたは Religo のどちらかを決める）\n\n---\n\n## 文書変更ログ\n\n| 日付 | 内容 |\n|------|------|\n| 2026-04-08 | 初版。参加者シート・対応履歴・[サービスの流れ・料金](https://comechan-design.com/flow-services-fees/) に基づき協業整理テンプレで作成。tugilo 直接1to1の日時は未記録 |\n| 2026-04-08 | §10〜13 追加：1時間構成（※実1to1未入手のためドラフト）、第三者メモからの質問の型、再現用台本、改善ポイント、協業確度アップ施策。YAML に `interview_script_status` |\n| 2026-04-08 | 要約入力に基づき **協業合意を反映**。**新 §10〜14**（実績協業・プロジェクト詳細・スキル・稼働・成功要因）。旧 §10〜13 を **§15〜18** に繰り下げ。**§2・4・5・6・7・8・9** 更新。YAML `collaboration_status`・`collaboration_agreement_recorded_at`・`sources_note` 更新 |\n| 2026-04-08 | **第1回 1to1 実施日時を確定:** **JST 09:00–10:00**。YAML `first_session_date` / `first_session_time_jst`、§1・§15.0・§8 運用行を更新 |','2026-04-08 01:09:53','2026-06-04 10:53:02'),
(13,1,37,19,NULL,NULL,NULL,'manual','2026-04-08 11:00:00',NULL,'2026-04-08 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_hirayama_mayumi_lifesupport.md】\n\n# 1to1_平山真由美_ライフサポート\n\n---\n\n**文書の位置づけ:** 同一人物との 1to1 を **1ファイルで時系列管理**する。BNI DragonFly の会員情報をベースに、回ごとに追記してサマリー・累積インサイトを更新する。  \n**整理:** tugilo（次廣 淳）  \n**チャプター:** BNI DragonFly\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※BNI 会員名簿ベース（**変わらない情報**）。名簿・Web の改定があったら本節のみ更新する。\n\n- **名前:** 平山 真由美（ひらやま まゆみ）\n- **カテゴリー:** ライフサポート\n- **事業表示:** シングルマザー専門事業コンシェルジュ\n- **チャプター上の役職（参照時点）:** プレジデント（2026年4月時点の参加者リストより）\n\n**補足:** シングルマザー支援事業、カーマッチ連携構想、美容業界向けシステム・Lステップ×AI 等の協業アイデアは 1to1 で共有済み（第1回）。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係性:** BNI DragonFly 内で **第1回 1to1 実施済み**（**2026-04-08（水）JST 11:00〜**・終了時刻は未取得 **TODO**）。\n- **合意した支援線:** 倉本氏のウェブマスター負荷軽減のため、次廣が **システム面からウェブマスター業務を支援**する方向。倉本氏との業務内容すり合わせは次廣側アクション。\n- **紹介・連携:** 平山様より **40人リスト用テンプレート** 提供予定、**神山氏（中小企業診断士）** の紹介・ビジター招待を検討。次廣より **静岡の車屋2名** を紹介し **カーマッチ** との連携を検討。\n- **次の論点:** プロフィールシート（コンタクトサークル上位3業種等）、紹介車両の在庫・HP・顧客適合性の確認。パスポートの **メンバーシップ** 完了（次廣・畑氏・来週月曜目安）。**リージョンフォーラム（2026-11-09）** で対面予定。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-08\n\n#### 基本情報\n\n- **日時:** **2026-04-08（水）JST 11:00〜**（終了時刻・取得元は **TODO**：カレンダー／Zoom で確定後に本項を更新）\n- **実施方法:** Zoom（要約ベースの記録）\n- **Religo 1to1 レコード:** `one_to_ones.id = 13`（**1セッション＝DB 1行**）\n\n以下、**クライアント共有用**の議事録体裁（tugilo式）。\n\n#### ■ 概要\n\n- **日時:** 2026年4月8日（水）11:00〜（JST）\n- **参加者:** 次廣 淳、平山 真由美 様\n\n#### ■ 主な成果\n\n- 次廣はパスポートプログラムをほぼ完了し（メンバーシップ分を除く）、今後の活動の土台を整えた。\n- 倉本氏の業務負荷軽減を目的に、ウェブマスター業務をシステム面から支援する方針で合意した。\n- 平山様のシングルマザー支援事業とカーマッチとの提携構想を共有し、協業の可能性を複数確認した。\n\n#### ■ 決定事項・合意内容\n\n- **ウェブマスター支援:** 次廣がシステム面を中心にサポートし、業務負荷を分散する。\n- **40人リスト:** 平山様よりテンプレートを提供し、リファラル創出を強化する。\n- **車屋の紹介:** 次廣より静岡の車屋2名を紹介し、カーマッチとの連携可能性を検討する。\n- **中小企業診断士の紹介:** 平山様より神山氏を紹介する（ビジター招待も検討する）。\n\n#### ■ フィードバック・示唆\n\n- メンターはタスク説明にとどまらず、BNIの価値を伝えながら伴走することが重要である。\n- 新入会員に限らず、全会員への支援意識が求められる。\n- プロフィールシートでは「不適切なリファラル」は削除し、「金の卵」には将来的にツール導入意欲のある見込み顧客を記載する。\n- システム導入は大規模開発一括ではなく、最も困っている部分から小さく始め、段階的に改善するのが現実的である。\n- トレーニングは1日2件以上を避け、理解と定着を優先したペースがよい。\n\n#### ■ 確認事項（保留）\n\n- プロフィールシートの「コンタクトサークル」記入（上位3業種）の扱い。\n- 静岡の車屋2名について: 在庫保有状況、ホームページの有無、平山様顧客への販売適合性。\n\n#### ■ アクションアイテム\n\n##### ▼ 平山 真由美 様\n\n- 40人リスト用テンプレートの送付（期限: 来週月曜日）\n- 神山氏（中小企業診断士）の紹介およびビジター招待の検討（期限: 協議のうえ設定）\n\n##### ▼ 自分（次廣）\n\n- 静岡の車屋2名へ連絡し、在庫・ホームページ・顧客適合性を確認する（期限: 速やかに）\n- カーマッチとの提携可否を検討する（期限: 協議のうえ設定）\n- パスポートプログラムのメンバーシップを完了する（畑氏と対応／期限: 来週月曜日）\n- 倉本氏とウェブマスター業務の具体的内容をすり合わせる（期限: 協議のうえ設定）\n\n#### ■ 協業機会（あれば）\n\n- 美容業界向け: 予約・問い合わせの自動化をサブスク型で提供する構想。\n- LステップとAI連携による問い合わせ対応の自動化（チャットボット等）。\n- カーマッチとシングルマザー支援の連携（車両販売とスポット業務提供の仕組み）。\n- 福利厚生システムとドラゴンフライ連携を想定した、美容業界向けの共同開発。\n\n#### ■ 次回予定\n\n- リージョンフォーラム（**2026年11月9日**）にて対面で連絡予定。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **役割の移行:** 支援を受ける側から、ウェブマスター支援など **チャプター貢献（システム面）** に踏み込むステージへ進んでいる。\n- **システム化の伝え方:** 「一番困っているところから小さく」「段階改善」が相手に伝わりやすい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 倉本氏・平山様双方にとって負荷が上がらないよう、**ウェブマスター支援の範囲を具体化**してから着手する。\n- 車・カーマッチ線は **紹介先の事実確認** を先に取り、平山様顧客への適合を判断できる材料を揃える。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- 40人リストテンプレートで **リファラル創出** を強化する流れに合わせ、次廣側の紹介（静岡車屋→カーマッチ検討）を **具体的なリファラルストーリー** に落とす。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 単なる情報交換にとどまらず、**紹介・協業・役割** の三点が動いたセッションとして整理できる。\n\n---\n\n**運用メモ:** 新規セッションは **【第2回】** を上に追記し、**サマリー** を更新する。共有用議事録は各回の節に同じ見出し構成で追記可能。','2026-04-13 14:14:45','2026-06-04 10:53:02'),
(14,1,37,10,NULL,NULL,NULL,'manual','2026-04-13 11:00:00',NULL,'2026-04-13 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kuramoto_kenichi_webmaster.md】\n\n# 1to1_倉持賢一_WEBマスター\n\n---\n\n**文書の位置づけ:** 同一人物との 1to1 を **1ファイルで時系列管理**する。BNI DragonFly の会員情報をベースに、回ごとに追記してサマリー・累積インサイトを更新する。  \n**整理:** tugilo（次廣 淳）  \n**チャプター:** BNI DragonFly\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※BNI 会員名簿ベース（**変わらない情報**）。\n\n- **名前:** 倉持 賢一（くらもち けんいち）\n- **カテゴリー:** 中小企業サポート\n- **事業表示:** 中国向け物販支援\n- **チャプター上の役職（参照時点）:** WEBマスター\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係性:** **第2回 1to1 実施済み**（**2026-04-13（月）JST 11:00–12:00**・Zoom）。ITウェブパワーチーム参加、ジオロケーションテクノロジー（坂木氏）・双葉企画・ロジカルシンキング講座など、**継続的な協業・案件ルート**が具体化した段階。\n- **進行中のテーマ:** ① エアコン会社案件（来週提案・受注後は5月頃から要件定義参画の可能性）② Excel 顧客管理の DB 化（代理店500人超）③ LP 等コーディング軽案件 ④ 都内対面（双葉企画関係者等）⑤ N-CAS 自己紹介資料の解像度向上・法人化・ポジショニング（次廣側）\n- **次アクション:** **倉持** — ITウェブパワーチーム招待、坂木氏紹介、エアコン会社へ提案（来週）。**次廣** — N-CAS 資料ブラッシュアップ、法人化・ポジショニング検討。次回日程は未定（エアコン案件進捗見て5月頃連携開始想定）。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-02\n\n#### 基本情報\n\n- **日時:** **2026-04-02（水）**（開始・終了の時刻は **`one_to_ones` 登録** を正とする。未取得の場合は TODO）\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 10`\n\n**要点（保存用メモとの整合）:** ウェブマスター役割・エアコン本舗案件・開発チーム参画の可能性、4/13 の 1to1 打ち合わせ予定など。詳細は当該時点の DB メモ・過去整理稿を参照。\n\n---\n\n### 【第2回】2026-04-13\n\n#### 基本情報\n\n- **日時:** **2026-04-13（月）JST 11:00–12:00**\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 14`（**1セッション＝DB 1行**。第1回は id 10）\n\n以下、**クライアント共有用**の議事録体裁（tugilo式）。\n\n#### ■ 概要\n\n- **日時:** 2026年4月13日（月）11:00〜12:00（JST）\n- **参加者:** 次廣 淳、倉持 賢一 様\n\n#### ■ 主な成果\n\n- 次廣のシステムエンジニアとしての経験および AI 活用スキルが、DragonFly における事業展開に有効であることを確認した。\n- 倉持様より、業務システム構築・顧客管理のシステム化・コーディング案件など、複数の具体的な協業機会が提示され、連携の方向性が明確になった。\n- 次廣の強み（現場に寄り添った設計・小さく始めるアプローチ・属人化解消）が評価され、今後の案件参画の可能性が高まった。\n\n#### ■ 決定事項・合意内容\n\n- **ITウェブパワーチームへの参加:** 倉持様より Facebook グループへ招待する（約500名規模）。\n- **ジオロケーションテクノロジー社の紹介:** 坂木氏（IPデータ・アクセス解析サービス提供）を紹介予定。\n- **双葉企画との連携検討:** デザイナー約100名規模の体制を活用し、システム案件のフロントとして協業を検討する。\n- **ロジカルシンキング講座の紹介:** 佐藤正夫氏の講座（10月開始予定）を、タイミングを見て案内する。\n\n#### ■ フィードバック・示唆\n\n- **次廣の強み:** 業務フローに沿った現場負担の少ない設計、小さく始めて段階的に改善するアプローチ、属人化を解消する仕組み化の実績。\n- **今後の成長ポイント:** 提案内容の解像度をさらに高めること、法人化やポジショニングの明確化、フロントに立つパートナーの選定。\n- **AI 活用の価値:** 提案スピード・単価向上と顧客負担軽減の両立が実現できている点が強み。\n\n#### ■ 確認事項（保留）\n\n- **エアコン会社案件:** 来週提案予定。受注後は5月頃から要件定義フェーズに参画する可能性あり。\n- **Excel 顧客管理のシステム化:** 代理店管理（500人超）の限界改善のため、DB 化提案を検討中。\n- **コーディング業務:** LP 制作等の軽案件での協力依頼の可能性。\n- **都内対面イベント:** 双葉企画など関係者との対面紹介を検討。\n\n#### ■ アクションアイテム\n\n##### ▼ 倉持 賢一 様\n\n- ITウェブパワーチームへ招待する（期限: 速やかに）\n- 坂木氏（ジオロケーションテクノロジー社）を紹介する（期限: 協議のうえ設定）\n- エアコン会社への提案を実施する（期限: 来週）\n\n##### ▼ 自分（次廣）\n\n- N-CAS 用の自己紹介資料をブラッシュアップする（提案解像度の向上）（期限: 協議のうえ設定）\n- 法人化およびポジショニングを検討する（期限: 協議のうえ設定）\n\n#### ■ 協業機会（あれば）\n\n- **業務システム構築（エアコン会社）:** 要件定義からの参画の可能性あり。\n- **顧客管理システムの再設計:** Excel 運用からの脱却（データベース化）。\n- **制作×システムの分業体制:** 双葉企画との連携によるフロント・制作分離。\n- **スポット開発案件（LP 等）:** 小規模案件から関係構築。\n\n#### ■ 次回予定\n\n- 未定（エアコン会社案件の進捗に応じ、**5月頃**に連携開始予定）。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **案件供給:** 「単発の紹介」ではなく、継続的な案件供給ルートが見え始めている。\n- **認識:** 倉持様側に「売れる人材」としての認識が育っているフェーズ。\n- **次の鍵:** 提案の解像度、フロント連携、ポジショニング（法人化を含む）——**案件が来る準備を整えるフェーズ**。\n\n---\n\n## ■ tugiloとしての戦略\n\n- N-CAS・提案資料で **課題→解決の解像度** を一段上げ、双葉企画・坂木氏線と **役割分担が説明できる状態** にする。\n- 法人化・ポジショニングは **案件の規模・請求形態** とセットで検討する。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- ITウェブパワーチーム・都内対面を通じ、**制作フロントと自分のシステム側**の組み合わせを紹介しやすいストーリーに整理する。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 倉持様からの提示が **具体案件・紹介先・コミュニティ** まで踏み込んでおり、パートナーとしての期待が明確。\n\n---\n\n**運用メモ:** 新規セッションは **【第3回】** を上に追記し、**サマリー** を更新する。','2026-04-13 23:18:48','2026-06-04 10:53:02'),
(15,1,37,49,NULL,NULL,NULL,'manual','2026-04-13 14:30:00',NULL,'2026-04-13 15:30:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_funatsu_mariko_aicare_lab.md】\n\n# 1to1_船津麻理子_アイケアラボ\n\n---\n\n**文書の位置づけ:** 船津さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録を詳細化する。  \n**整理:** tugilo（次廣 淳）と船津さんは、同じ **BNI DragonFly** チャプターのメンバー。相互理解、リファラル、FC本部システム化、1on1記録整理の協業可能性を確認した。  \n**日時:** 既存記録では **2026-04-13 JST 14:30–15:30**。今回提供のZoom要約タイトルは **2026-04-13 15:37(GMT+9:00)** のため、正式な開始・終了時刻はカレンダー／Zoom録画メタ等で要確認。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は BNI 会員名簿および Zoom 文字起こし要約ベース。正式な事業表記・Webサイト・BNIプロフィール等で確定情報が取れたら更新する。\n\n- **名前:** 船津 麻理子（ふなつ まりこ）\n- **カテゴリー:** 美容・健康・生活\n- **事業表示:** アイケアラボ／眼の整体院\n- **チャプター上の役職（参照時点）:** メンターコーディネイター（2026年4月時点の参加者リストより）\n- **専門領域:** 予防眼科・視力回復トレーニング。低周波施術、ホームケア指導、パーソナルトレーニングを組み合わせた目のケア。\n- **背景:** 保育士として6年経験した後、子どもに関わる事業として起業を決意。\n- **実績:** 自身の視力が 0.2 から 0.7〜1.0 へ改善。運転恐怖症があった40代顧客の視力回復事例あり。\n- **提携・拡張:** 福岡アビスパ、航空会社から提携打診あり。フランチャイズ本部側ではカルテ手書き・スプレッドシート管理の限界が課題。\n- **現在の紹介ニーズ:** 柏エリアで提携可能な眼科医。都内の提携先は顧客が通いづらいため、関東圏・近隣での連携先を探している。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-04-13・Zoom）。船津さんのアイケアラボ事業と、次廣のAI活用・業務改善・システム構築事業について相互理解が深まった。\n- **主な成果:** 具体的な紹介候補として、船津さん側から藤本氏（税理士）と秋田の財務コンサル、次廣側から関東圏の眼科医候補を確認する流れになった。\n- **案件化・協業の芽:** 船津さんのフランチャイズ本部に対し、次廣がカルテ・顧客管理・スプレッドシート管理のシステム化を提案できる可能性がある。船津さんは次廣の1on1記録・BO管理を含む顧客管理システムに強い関心を示した。\n- **次アクション:** 船津さんは藤本税理士と秋田の財務コンサルへ次廣との1on1を打診。次廣は脳神経外科医経由で関東圏の眼科医紹介が可能か確認し、船津さん向けのリファラル提案を整理する。\n- **確認事項:** 既存記録の時刻（14:30–15:30）と今回Zoom要約タイトルの時刻（15:37）に差異あり。正式な開始・終了時刻は TODO。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-13 実施済み（正式時刻は TODO 確認）\n\n#### 基本情報\n\n- **日時:** **2026-04-13（月）JST 14:30–15:30**（既存記録）。ただし、今回提供のZoom要約タイトルは **2026-04-13 15:37(GMT+9:00)** のため、正式時刻は要確認。\n- **実施方法:** Zoom\n- **参加者:** 次廣 淳、船津 麻理子\n- **Religo 1to1 レコード:** `one_to_ones.id = 15`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 船津さんは、アイケアラボとして予防眼科・視力回復トレーニングを提供している。単なる目のマッサージではなく、低周波施術によるリハビリ、ホームケア指導、パーソナルトレーニングを組み合わせる点が特徴。\n- 次廣は、AI活用・業務改善・システム構築を専門とする個人事業主SEとして、Excel・スプレッドシート運用が限界に近い中小企業やフランチャイズ事業者向けに、現場に合わせた小規模スタートのシステム構築を行っている。\n- 両者は同じ BNI DragonFly メンバーとして、紹介できる相手、紹介してほしい相手、DragonFly 内での協業可能性、フランチャイズ本部へのシステム化提案の可能性を確認した。\n\n**主な成果**\n\n- 船津さんのアイケアラボ事業と、次廣のシステム構築事業について相互理解が深まった。\n- 具体的な紹介先候補として、藤本氏（税理士）、秋田の財務コンサル、関東圏の眼科医を確認した。\n- 次廣は、船津さんのフランチャイズ本部に対するシステム化提案に強い関心を示した。\n- 船津さんは、次廣の顧客管理システム、特に1on1記録・ブレイクアウトルーム管理・PDF自動取込の仕組みに興味を持ち、エヌキャスでの販売可能性にも言及した。\n\n**決定事項・合意内容**\n\n- **紹介先の相互確認:** 船津さんは藤本氏（税理士）と秋田の財務コンサルタントを、次廣に紹介できるか確認する。\n- **眼科医の紹介検討:** 次廣は、脳神経外科医経由で関東圏の眼科医を船津さんに紹介できるか確認する。\n- **システム化の方向性:** 船津さんのフランチャイズ本部に対し、次廣がシステム化提案を行う可能性を確認した。\n- **顧客管理の軽量版:** 船津さん自身の1on1記録整理にも、次廣の顧客管理システムの簡易版が役立つ可能性がある。\n\n**交換されたフィードバック**\n\n次廣から船津さんへ:\n\n- アイケアラボの予防眼科コンセプトと、視力回復の仕組みに強い関心を示した。\n- 施術が単なるマッサージではなく、リハビリとトレーニングを組み合わせた仕組みである点を高く評価した。\n- 名刺デザインで「視力0.1の見え方」を表現している工夫を称賛した。\n\n船津さんから次廣へ:\n\n- プロフィールシートの充実度と、ワークショップでの高評価を称賛した。\n- 次廣の顧客管理システム、特に1on1記録・ブレイクアウトルーム管理の完成度に驚き、エヌキャスでの販売可能性を提案した。\n- 増本氏のフランチャイズ管理システム構築実績を評価した。\n\n**次廣側の事業概要**\n\n- **専門分野:** AI活用、業務改善、システム構築。個人事業主SEとして20年以上の経験。\n- **強み:** 現場に合わせて小さく始めるシステム構築。既存ツールを押し付けず、業務に合わせて伴走しながら育てる。\n- **実績:** 増本氏のフランチャイズ管理システム（200店舗から500店舗への拡大対応）、LINE公式アカウント連携、スタンプラリーシステムなど。\n- **顧客管理:** 脳梗塞経験後、外部記憶として独自システムを構築。1on1記録、ブレイクアウトルーム管理、PDF自動取込などを備える。\n\n**船津さん側の事業概要**\n\n- **事業内容:** アイケアラボ。予防眼科・視力回復トレーニング。\n- **背景:** 保育士6年経験後、子どもに関わる事業として起業を決意。\n- **メソッド:** 低周波施術によるリハビリ、ホームケア指導、パーソナルトレーニング。\n- **実績:** 自身の視力が 0.2 から 0.7〜1.0 へ改善。運転恐怖症があった40代顧客の視力回復事例あり。\n- **提携状況:** 福岡アビスパ、航空会社から提携打診あり。\n- **課題:** 柏エリアで提携可能な眼科医を探している。都内の提携先は遠方で、顧客が通いづらい。\n\n**相互理解のポイント**\n\n- 次廣は、船津さんのフランチャイズ本部にシステム化ニーズがある点に強く反応した。カルテ手書き、スプレッドシート管理、現場運用の限界が具体的な入口になり得る。\n- 船津さんは、次廣の顧客管理システムの簡易版に関心を示した。現状、1on1記録がピージーズ上に羅列されており、整理・検索・振り返りに課題がある。\n- 増本氏がITスキルを向上させたこと、DragonFly メンバーの温かさについて共通認識があった。\n\n#### 確認待ち事項\n\n- 船津さんが、藤本氏（税理士）と秋田の財務コンサルに、次廣との接続可能性を確認する。\n- 次廣が、脳神経外科医を通じて関東圏の眼科医を船津さんに紹介できるか調整する。\n- 船津さんのアイケアラボ本部に対するシステム化提案の実現可能性、提案先、提案タイミングを確認する。\n- 第1回 1to1 の正式な開始・終了時刻を確認する。\n\n#### アクションアイテム\n\n- **船津さん:** 藤本税理士と秋田の財務コンサルに、次廣との1on1を打診する。\n- **船津さん:** 1on1記録の整理方法を改善する。現状のピージーズ上の羅列管理から、後で検索・活用しやすい形へ見直す。\n- **次廣:** 脳神経外科医に、関東圏の眼科医紹介を相談する。\n- **次廣:** 船津さん向けのリファラル提案を作成し、紹介先候補を整理する。\n- **次廣:** フランチャイズ本部向けのシステム化提案の入口を、カルテ管理・顧客管理・スプレッドシート限界のどこに置くか整理する。\n\n#### 協業機会\n\n- **フランチャイズ本部のシステム化:** 手書きカルテ、顧客管理、店舗運営管理、スプレッドシート管理の限界を起点に提案できる。\n- **顧客管理システムの簡易版:** 1on1記録・顧客情報・紹介候補を整理する軽量版として、船津さん自身の課題解決に使える可能性がある。\n- **医療・ヘルスケア領域での連携:** 柏・関東圏の眼科医との接続により、アイケアラボの信頼性と顧客導線を強化できる。\n- **BNI内での横展開:** 1on1記録整理や紹介候補管理は、DragonFly メンバーにも共通する課題になりやすい。\n\n#### ■ 次回予定\n\n- **翌日の DragonFly イベント**にて再会予定。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 船津さんは、単なる目の施術者ではなく、予防眼科・子ども・スポーツ・航空・FC展開の複数文脈を持つ事業者。紹介先の切り口を相手別に変えやすい。\n- アイケアラボの強みは、視力回復の体験談だけでなく、リハビリ＋ホームケア＋パーソナルトレーニングという再現性のある仕組みにある。\n- 船津さん側の課題は、紹介先としての眼科医開拓と、FC本部・店舗運営側のシステム化。リファラルと案件化が同時に動く可能性がある。\n- 次廣の顧客管理システムへの反応が強い。1on1記録・BO管理・PDF取込は、Religo の価値を非エンジニアにも伝える具体例として使える。\n- 増本氏のFC管理システム実績が、船津さんの本部提案への信用材料になる。FC本部向けには「大きく作る」より、まずカルテ・顧客管理・店舗別状況把握から入る方が自然。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 船津さんへの提案は、最初から本部向け大規模システムにせず、**カルテ管理・顧客管理・1on1記録整理の軽量版**から具体化する。\n- FC本部向けには、増本氏の事例を「店舗数が増えても管理が破綻しない仕組み」として紹介し、アイケアラボの現状課題に接続する。\n- 眼科医紹介は、医療連携・信頼性・顧客導線の強化という文脈で伝える。単なる紹介ではなく、柏エリアで顧客が通いやすい提携先を探している背景を添える。\n- エヌキャス販売の話は、すぐ商品化に飛ばさず、まずは船津さん自身の記録整理課題を小さく解決し、使い勝手と訴求を検証する。\n- リファラル提案は、税理士・財務コンサル・眼科医・FC本部関係者ごとに、紹介文を1文ずつ用意する。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- **船津さんに紹介したい相手:** 柏・関東圏の眼科医、子ども・スポーツ・航空・教育領域と接点を持つ事業者、健康経営に関心がある企業。\n- **次廣が紹介してほしい相手:** 税理士、財務コンサル、FC本部、店舗展開企業、スプレッドシートや手書き管理が限界に近い事業者。\n- **紹介時の切り口（船津さん向け）:** 「視力回復」だけでなく、「予防眼科」「子どもの目のケア」「通いやすい医療連携」「リハビリ＋トレーニング」として伝える。\n- **紹介時の切り口（次廣向け）:** 「FC本部や複数店舗の現場運用を、手書き・Excel・スプレッドシートから無理なくシステム化する人」として伝える。\n- **DragonFly 内での活用:** 船津さんの1on1記録整理課題を、Religo の具体ユースケースとして扱える可能性がある。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 船津さんは、相手のプロフィールシートやワークショップ評価、システムの実用性を具体的に見てフィードバックしてくれる。\n- 次廣のシステムを「売れる可能性があるもの」として捉えており、単なる社交辞令ではなく、使い道を考えながら話している温度感。\n- 名刺デザインや視力回復の仕組みなど、伝え方に工夫がある。紹介文を作る際も、視覚的・体験的に伝わる言葉を使うと相性がよい。\n- 1on1記録が羅列状態という悩みは、船津さん個人だけでなく BNI メンバー全体の潜在課題かもしれない。\n\n---\n\n**運用メモ:** 新規セッションは **【第2回】** を上に追記し、**サマリー** を更新する。','2026-04-13 23:22:13','2026-06-04 10:53:02'),
(16,1,37,40,NULL,NULL,NULL,'manual','2026-04-13 18:00:00',NULL,'2026-04-13 19:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_hatakeyama_noriyuki_wagashi_oem.md】\n\n# 1to1_畠山憲之_和スイーツOEM\n\n---\n\n**文書の位置づけ:** 同一人物との 1to1 を **1ファイルで時系列管理**する。BNI DragonFly の会員情報をベースに、回ごとに追記してサマリー・累積インサイトを更新する。  \n**整理:** tugilo（次廣 淳）  \n**チャプター:** BNI DragonFly\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※BNI 会員名簿ベース（**変わらない情報**）。\n\n- **名前:** 畠山 憲之（はたけやま のりゆき）\n- **カテゴリー:** 食品・製造\n- **事業表示:** 和スイーツの OEM 製造\n- **チャプター上の役職（参照時点）:** BCP 担当（2026年4月時点の参加者リストより）\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係性:** **第1回 1to1 実施済み**（**2026-04-13（月）JST 18:00–19:00**・Zoom）。メンバーシップ完了の共有、和菓子製造の業務課題（Excel・属人化・業務過多）とシステム化の方向性を確認。\n- **合意:** 採用活動後にシステム化の優先順位を整理し段階的に検討。詳細ヒアリング目的で **再度 1on1** を実施する。\n- **次の論点:** 対象業務の範囲、採用後体制に合わせた優先順位、木村氏（岡山・T シャツ事業）の属人化課題との接続可能性。定例会フォロー＋別途 1on1 で深掘り。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-13\n\n#### 基本情報\n\n- **日時:** **2026-04-13（月）JST 18:00–19:00**\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 16`（**1セッション＝DB 1行**）\n\n以下、**クライアント共有用**の議事録体裁（tugilo式）。\n\n#### ■ 概要\n\n- **日時:** 2026年4月13日（月）18:00〜19:00（JST）\n- **参加者:** 次廣 淳、畠山 憲之 様\n\n#### ■ 主な成果\n\n- 次廣のメンバーシップ・パスポートプログラムが完了したことを共有した。\n- 次廣の AI 活用・業務改善システム構築の実績と開発スタイルについて理解を共有した。\n- 畠山様の和菓子製造における業務課題（Excel 管理・属人化・業務過多）を整理し、システム化による改善の方向性を確認した。\n\n#### ■ 決定事項・合意内容\n\n- **業務効率化に向けた検討の継続:** 採用活動後、システム化の優先順位を整理し、段階的に検討する。\n- **再度の 1on1 の実施:** 詳細ヒアリングを目的に、改めて面談を実施する。\n\n#### ■ フィードバック・示唆\n\n- **次廣の開発スタイル:** 小さく作って育てる「伴走型開発」が現場に適している。ワークフローを変えずにシステムを馴染ませる設計が強み。\n- **畠山様の業務状況:** Excel ベースの複数管理による非効率が顕在化。属人化により休暇が取れない状態。OEM 受注増加により業務負荷が限界に近い。\n- **システム化の本質的価値:** 入力の一元化による作業削減、属人化解消による経営リスク低減、「不在でも回る仕組み」の構築。\n\n#### ■ 確認事項（保留）\n\n- システム化の対象範囲（どの業務から着手するか）。\n- 採用活動後の体制を踏まえた優先順位の整理。\n- 木村氏（岡山・T シャツ事業）の属人化課題への対応可能性。\n\n#### ■ アクションアイテム\n\n##### ▼ 畠山 憲之 様\n\n- 採用活動を優先し、業務整理を実施する（期限: 協議のうえ設定）。\n- 落ち着いた段階でシステム化の優先順位を検討する（期限: 協議のうえ設定）。\n\n##### ▼ 自分（次廣）\n\n- 畠山様との再度の 1on1 を設定し、詳細ヒアリングを実施する（期限: 協議のうえ設定）。\n- 現状業務の整理を踏まえた改善提案を準備する（期限: 協議のうえ設定）。\n\n#### ■ 協業機会（あれば）\n\n- **製造業向け業務管理システム:** 原価計算・成分管理・原材料管理の一元化。\n- **入力一元化システム:** 1 回の入力で複数帳票へ自動反映。\n- **シフト・労務管理の可視化:** 労働時間・負荷の見える化（アラート機能）。\n- **属人化解消の仕組み構築:** 誰でも業務が回る体制づくり。\n\n#### ■ 次回予定\n\n- 定例会で継続フォロー。\n- 別途 1on1 を設定し、詳細ヒアリングを実施する。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **課題の明確さ:** Excel 限界・属人化・業務過多。本人が休めていない状態と OEM 拡大が重なり、「今やらないとまずい」に近い。\n- **アプローチ:** 最初から大規模提案ではなく、**1 箇所の入力統合**から入れると tugilo 流と相性が良い。\n- **案件の種:** 課題・痛み・成長が同時に揃いやすいパターン。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 再 1on1 では **業務フローと入力の重複** を時系列で整理し、**最小の一元化**から提案する。\n- 木村氏線は **属人化の類型** として参照しつつ、畠山様の優先順位を最優先にする。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- 製造・OEM 文脈で **同じ課題パターン** のメンバーに紹介しやすいストーリーへ整理する。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 現場のしんどさが言語化できており、**伴走型・小さく始める**説明が刺さっている。\n\n---\n\n**運用メモ:** 新規セッションは **【第2回】** を上に追記し、**サマリー** を更新する。','2026-04-13 23:27:04','2026-06-04 10:53:02'),
(17,1,37,96,NULL,NULL,NULL,'manual','2026-04-17 09:55:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_suzuki_kensuke_studio_suzu.md】\n\n# 1to1_鈴木健介_合同会社スタジオ鈴\n\n---\n\n**文書の位置づけ:** 鈴木健介さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録として整理する。  \n**整理:** tugilo（次廣 淳／BNI DragonFly）と鈴木健介さん（合同会社スタジオ鈴／BNI Diana）は、鈴木さんのスタートアッププレゼン練習、写真・動画・VR撮影事業、次廣の AI 業務改善システム構築について相互理解を深め、VR×サウナ、飲食店向け AI 問い合わせ対応などの協業可能性を確認した。  \n**日時:** 第1回は **2026-04-17 JST 09:55〜**。終了時刻は **TODO**（カレンダー／Zoom 録画メタ等で確認後に更新する）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は Zoom 文字起こし要約ベース。正式な読み、Webサイト、BNIプロフィール等で確定情報が取れたら更新する。\n\n- **名前:** 鈴木健介\n- **所属:** 合同会社スタジオ鈴\n- **BNI:** Diana チャプター\n- **カテゴリー:** 写真撮影／動画制作／フード撮影／ドローン撮影\n- **専門領域:** ファッション、雑誌、フード撮影、動画制作、ドローン撮影。撮影から納品まで一貫対応。\n- **紹介してほしい相手:** 飲食フランチャイズオーナー、飲食コンサルタント。\n- **関心領域:** サウナ、VR撮影、サウナ施設の360度コンテンツ化。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-04-17 JST 09:55〜、Zoom 文字起こし要約を 2026-05-17 21:56 JST に本ファイルへ反映。終了時刻は TODO）。\n- **主な成果:** 鈴木さんのスタートアッププレゼン（2分20秒版）を実践練習し、オンライン環境でのアニメーション表示課題を確認。VR撮影事業での協業可能性を発見した。\n- **合意事項:** 次廣は藤原氏（VR推進協会）のコンタクト情報を鈴木さんへ共有する。次廣の次回東京訪問時に、北欧サウナ（上野）で初心者向けサウナ体験を企画する。\n- **案件化・協業の芽:** VR×サウナ施設360度コンテンツ、飲食店向け24時間 AI コールセンター、飲食フランチャイズ向けフード撮影・動画制作で接続可能性がある。\n- **次アクション:** 次廣は藤原氏紹介、東京訪問時のサウナ予約、AIコールセンター需要企業情報の受領対応を進める。鈴木さんはプレゼンPDF化、写真要素のブラッシュアップ、サウナ初心者向けツアープラン作成を進める。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-17 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-17（金）JST 09:55–TODO**（開始時刻: ユーザー提供「合同会社スタジオ鈴 鈴木健介さん：1to1調整用 2026-04-17 09:55(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、鈴木健介\n- **Religo 1to1 レコード:** `one_to_ones.id = 17`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 鈴木さんは、来週実施予定のスタートアッププレゼン（2分20秒・7枚構成）を次廣に向けて練習した。\n- 写真を活用したビジュアル表現は効果的で、ファッション・雑誌・フード撮影の経歴が明確に伝わった。\n- 一方で、オンライン環境ではアニメーションのコマ落ちが発生し、スライドの伝わり方に課題があることを確認した。\n- 次廣は、AIを活用したホームページ作成、記事生成、プログラミング支援、B2B業務改善システム構築の実例を共有した。\n- 両者は、VR撮影、サウナ、飲食店向け AI 問い合わせ対応を中心に、具体的な協業・紹介の芽を確認した。\n\n**主な成果**\n\n- 鈴木さんのスタートアッププレゼンの改善ポイントが明確になった。\n- オンライン発表時は、アニメーションが重い場合に PDF 形式で共有する方針を確認した。\n- 次廣が、藤原氏（VR推進協会）と鈴木さんをつなぎ、サウナ施設の360度VRコンテンツ制作の可能性を探ることになった。\n- 次廣の次回東京訪問時に、北欧サウナで初心者向けサウナ体験を実施する方向で合意した。\n\n**決定事項・合意内容**\n\n- **スタートアッププレゼン改善:** 写真を追加してビジュアル要素を強化し、仕事内容と人となりのバランスを調整する。\n- **オンライン発表時の対応:** アニメーションが重い場合は PDF 形式で共有し、表示崩れ・コマ落ちのリスクを下げる。\n- **VR事業での協業検討:** 次廣が藤原氏（VR推進協会）と鈴木さんを紹介し、サウナ施設の360度VRコンテンツ制作を検討する。\n- **サウナツアー企画:** 次廣の次回東京訪問時に、北欧サウナ（上野）で初心者向けサウナ体験を実施する。\n\n**鈴木さんのプレゼンフィードバック**\n\n- **強み:** 写真を活用したビジュアル表現が効果的で、撮影者としての実績・世界観が伝わりやすい。\n- **強み:** ファッション、雑誌、フード撮影の経歴が明確で、飲食・フランチャイズ領域への紹介につなげやすい。\n- **改善提案:** オンライン環境ではアニメーションのコマ落ちが発生するため、PDF版も用意しておく。\n- **改善提案:** 仕事内容だけでなく人となりも伝わるよう、写真要素とストーリーのバランスを調整する。\n\n**次廣側の事業共有**\n\n- 次廣は、ホームページ作成、記事生成（150件以上）、プログラミング支援などを AI で自動化している。\n- AI活用は単なる自動生成ではなく、顧客要望の言語化、ヒアリング、業務フロー理解と組み合わせて価値が出ると説明した。\n- 25年のシステム開発経験により、顧客の言語化されていない要望を整理し、現場負荷を下げる設計ができる点を差別化要素として共有した。\n- ターゲットは、Excel 管理で困っている中小企業、士業・コンサルタント、B2B 業務改善案件。\n- 音声入力・タッチパネル活用により、手書き業務や二重入力を減らす提案が可能。\n\n**鈴木さん側の紹介ニーズ**\n\n- **ターゲット:** 飲食フランチャイズオーナー、飲食コンサルタント。\n- **提供価値:** フード撮影全般、動画制作（撮影〜納品一貫）、ドローン撮影。\n- **紹介時の切り口:** 飲食店・フランチャイズのメニュー写真、店舗紹介動画、SNS/採用/販促向けコンテンツ制作。\n\n**具体的な協業可能性**\n\n- **VR×サウナコンテンツ:** 全国のサウナ施設を360度撮影し、音響付きVRツアーとして制作する。\n- **サウナ施設向け販促:** サウナ未経験者にも雰囲気・導線・楽しみ方が伝わる体験コンテンツとして展開できる可能性がある。\n- **AI×問い合わせ対応:** 飲食店向け24時間 AI コールセンターシステムの開発可能性。\n- **飲食フランチャイズ支援:** 鈴木さんの撮影・動画制作と、次廣の業務効率化・AI対応を組み合わせた提案余地がある。\n\n**BNI活動状況**\n\n- 次廣は、トレーニング強化月間として13個のワークショップを1ヶ月で受講予定。全額返金制度を活用している。\n- 次廣は、メンバーアクセラレーター、ネットワークスキルトレーニング、メインプレゼントレーニング等を受講済み。\n- 次廣の所属は DragonFly チャプター（NEDリージョン、53名規模）。\n- 次廣は、ワークショップ参加者に即座にリファラルを提出するなど、BNI活動を強化している。\n- 鈴木さんは Diana チャプター所属。月1回の対面ミーティングがある。\n- 鈴木さんは、朝7時開始・2時間半のチャプターディベロップメントに参加している。\n\n#### 確認待ち事項\n\n- VR撮影の具体案件は、鈴木さんが藤原氏との打ち合わせ後に詳細を検討する。\n- サウナツアーの日程は、次廣の次回東京訪問予定が確定次第調整する。\n- AIコールセンターシステムについて、24時間自動応答の引き合いがある企業情報を鈴木さんから共有予定。\n- 第1回 1to1 の終了時刻を確認する。\n- 合同会社スタジオ鈴の正式な読み、Webサイト、BNIプロフィール URL を確認する。\n\n#### アクションアイテム\n\n- **次廣:** 藤原氏（VR推進協会）のコンタクト情報を鈴木さんに共有する。\n- **次廣:** 東京訪問時に北欧サウナ（上野）を予約し、鈴木さんに連絡する。\n- **鈴木さん:** スタートアッププレゼンを PDF 版に変換し、写真要素をブラッシュアップする。\n- **鈴木さん:** サウナ初心者向けツアープランを作成する（低温サウナ室＋外気浴重視）。\n- **鈴木さん:** AIコールセンターシステムのニーズがある企業情報を次廣に提供する。\n\n#### 次回1on1\n\n- **未定。** 次廣の次回東京訪問時に調整予定（サウナ体験込み）。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 鈴木さんは、写真・動画・フード撮影の実績を持ち、飲食・フランチャイズ領域への紹介と相性が良い。\n- スタートアッププレゼンでは、写真の強さが伝わる一方、オンライン環境ではアニメーションより PDF の安定性を優先した方がよい。\n- サウナへの関心が強く、VR撮影・360度コンテンツと掛け合わせることで、単なる撮影案件ではなく体験設計・施設販促の提案に広げられる。\n- 藤原氏（VR推進協会）への紹介は、鈴木さんの撮影スキルと次廣側のネットワークをつなぐ具体的なアクションになる。\n- 飲食フランチャイズ領域では、鈴木さんの撮影・動画制作と、次廣の AI 問い合わせ対応・業務効率化が補完関係になりうる。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 鈴木さんへの紹介は、「撮影できる人」ではなく、**飲食・フード・動画・ドローンまで一貫して販促コンテンツを作れる撮影パートナー**として伝える。\n- 飲食フランチャイズや飲食コンサルへの紹介時は、写真単体ではなく、メニュー写真、店舗動画、SNS素材、採用・販促コンテンツまで含めた提案にすると紹介しやすい。\n- VR×サウナは、まず藤原氏との接続で実現性・単価感・制作フローを確認し、サウナ施設向けの小さな実証案件に落とす。\n- AIコールセンターのニーズ企業を受け取った場合は、問い合わせ種別、営業時間外対応、予約・注文・FAQ・クレーム一次受けなど、業務範囲を分解してヒアリングする。\n- サウナ体験は関係構築として有効。次回東京訪問時のリアル接点で、VR・撮影・飲食店支援の具体化につなげる。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- **鈴木さんに紹介しやすい相手:** 飲食フランチャイズオーナー、飲食コンサルタント、店舗開発担当、サウナ施設運営者、ホテル・旅館、観光施設、SNS運用担当者。\n- **紹介時の切り口:** 「フード撮影・動画・ドローンまで一貫対応できる」「飲食店の魅力を写真と動画で伝えられる」「VR・360度撮影の可能性もある」。\n- **鈴木さんから tugilo への紹介導線:** 飲食店・フランチャイズ本部で、電話対応、予約対応、問い合わせ、スタッフ教育、Excel管理、複数店舗管理に困っている相手がいたら次廣へつなぐ。\n- **共同提案の切り口:** 飲食店向けに「見せ方（写真・動画）」と「受け皿（AI問い合わせ対応・業務システム）」をセットで改善する。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 鈴木さんはプレゼンを実践練習し、フィードバックを受けて改善する姿勢がある。\n- 写真・動画という視覚表現の強みが明確で、BNIの短時間プレゼンでもビジュアルを活かすほど伝わりやすい。\n- サウナという共通体験を通じて、ビジネスだけでなく人となりの関係構築が進みやすい。\n- Diana チャプターとのクロスチャプター接点として、DragonFly外の飲食・撮影・VR周辺ネットワークを広げる起点になりそう。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(18,1,37,26,NULL,NULL,NULL,'manual','2026-04-20 15:53:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md】\n\n# 1to1_竹内駿太_アスリート専門生命保険\n\n---\n\n**文書の位置づけ:** 竹内駿太さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録として整理する。  \n**整理:** tugilo（次廣 淳）と竹内さんは、同じ **BNI DragonFly** チャプターのメンバー。次廣の AI 業務改善システム構築と、竹内さんのアスリート専門保険・キッズマネー教育の相互紹介可能性を確認した。  \n**日時:** 第1回は **2026-04-20 JST 15:53〜**。終了時刻は **TODO**（カレンダー／Zoom 録画メタ等で確認後に更新する）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は Zoom 文字起こし要約と DragonFly メンバーCSV上の表記をもとに整理。正式社名・Webサイト・BNIプロフィール等で確定情報が取れたら更新する。\n\n- **名前:** 竹内駿太\n- **所属:** エグゼクティブランス（正式表記 TODO）\n- **BNI:** DragonFly チャプター\n- **カテゴリー:** 金融・保険・資金サポート／アスリート専門生命保険\n- **経歴:** ソニー生命、ジブラルタ生命を経て、2024年9月から現職。保険業界7年目。\n- **専門領域:** アスリート専門保険。顧客の約8割がサッカー関連。\n- **実績:** 2024年度 MDRT 達成（業界トップ1%水準）。\n- **主な展開:** キッズマネー教育、アスリートのセカンドキャリア支援、法人営業へのシフト。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-04-20 JST 15:53〜、Zoom 文字起こし要約を 2026-05-17 に本ファイルへ反映。終了時刻は TODO）。\n- **主な成果:** 次廣の AI 業務改善システム構築と、竹内さんのアスリート専門保険・キッズマネー教育について相互理解を深めた。\n- **合意事項:** 次廣は、静岡のサッカーパパコーチや小学校 PTA ネットワークへ、竹内さんのキッズマネーセミナーを紹介できる可能性を探る。\n- **次アクション:** 次廣は静岡のサッカーパパコーチ・現 PTA 会長への紹介可能性を確認する。竹内さんは法人経営者へのヒアリング時に業務効率化ニーズがあれば次廣へ紹介する。\n- **案件化・協業の芽:** キッズマネーセミナーの静岡展開、法人営業先での DX ニーズ紹介、士業・行政書士・経営コンサルとの補完関係づくりがある。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-20 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-20（月）JST 15:53–TODO**（開始時刻: ユーザー提供「2026-04-20 15:53(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、竹内駿太\n- **Religo 1to1 レコード:** `one_to_ones.id = 18`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣は、静岡県藤枝市でシステムエンジニアとして活動し、業務改善システム・AI活用・プロジェクトマネジメントを提供している。\n- 竹内さんは、保険代理店としてアスリート専門保険を展開し、顧客の多くがサッカー関連。今後は個人保険中心から法人営業へシフトする方向性を検討している。\n- 両者は、次廣の静岡 PTA・サッカーパパコーチ人脈と、竹内さんのキッズマネー教育が接続しやすいことを確認した。\n- 竹内さんが法人経営者にヒアリングする場面では、業務効率化・システム化ニーズを次廣へ紹介できる可能性がある。\n\n**決定事項・合意内容**\n\n- **静岡エリアでの協業検討:** 次廣が、静岡のサッカーパパコーチや小学校 PTA ネットワークに、竹内さんのキッズマネーセミナーを紹介できるか検討する。\n- **システム開発での連携:** 竹内さんが法人営業を強化する中で、経営者へのヒアリング時に業務効率化ニーズがあれば次廣へ紹介する。\n- **相互補完関係:** 次廣はシステム構築が専門で、助成金・補助金の対応はできないため、行政書士や経営コンサルとの連携を模索している。\n- **同業・周辺メンバーとの協業:** 竹内さんから、システムエンジニア系メンバーとのカテゴリー重複・協業可能性が話題に上がり、次廣は協業可能と前向きに整理した。\n\n**次廣側の事業概要**\n\n- **経歴:** システムエンジニア歴25年、AI活用歴3年。\n- **事業形態:** 個人事業主として、営業から開発・運用まで一人で対応。\n- **専門領域:** B2B/B2C の業務改善システム、プロジェクトマネジメント、AI活用。\n- **AI活用:** プログラミング作業の多くを AI に委託し、開発効率を高めている。\n- **主な実績:** フランチャイズ管理システム、解体業向け LINE 連携システム、観光協会向けデジタルスタンプラリー、インテリア商社の受発注管理、防水工事業の工程管理・日報、動物病院予約管理、飲食フランチャイズ業務システム。\n- **開発姿勢:** 大規模導入を避け、現場負担の軽減から小さく始め、既存ワークフローを大きく変えずに段階的に拡張する。\n\n**竹内さん側の事業概要**\n\n- **所属:** エグゼクティブランス（保険代理店、正式表記 TODO）。\n- **経歴:** ソニー生命、ジブラルタ生命を経て、2024年9月から現職。保険業界7年目。\n- **専門:** アスリート専門保険。顧客の約8割がサッカー関連。\n- **実績:** 2024年度 MDRT 達成。\n- **キッズマネー教育:** お店屋さんごっこ形式で、子どもが塗り絵を販売し、親への感謝やお金の大切さを学ぶ。15分のマネーセミナーを通じて、親御さんの個別相談につなげる。\n- **連携先:** スポーツクラブ、PTA、住宅展示場、カーディーラーなど。夏休み・冬休みの集客ツールとして展開しやすい。\n- **アスリートセカンドキャリア支援:** パパアスリートのビジネス活用事例をインタビューし、Web記事として無料掲載。経営者との接点から、財務ヒアリング・アドバイス・保険提案へ展開する。\n- **現在の方向性:** BNI 入会から2年が経過し、個人保険から法人営業へシフトすることを検討中。ゴールデンウィーク頃にウィークリープレゼン内容を法人向けへ変更予定。\n\n**連携の具体案**\n\n- **次廣から竹内さんへ:** 静岡のサッカーパパコーチに、竹内さんのキッズマネーセミナーを提案する。\n- **次廣から竹内さんへ:** 元 PTA 会長としての人脈を活用し、小学校イベントでのセミナー開催可能性を探る。\n- **竹内さんから次廣へ:** 法人経営者へのインタビュー時に、業務効率化・DX・システム化ニーズがあれば次廣へ紹介する。\n- **周辺連携:** 助成金・補助金、行政書士、経営コンサル、同業 SE メンバーとの役割分担を整理し、案件に応じたチーム提案を検討する。\n\n**BNI・人物面の共有**\n\n- 次廣は、増本さんのプロテクトラボシステム開発をきっかけに BNI との接点ができ、今西さんの誘いで DragonFly に入会した。\n- 次廣は、先週 BarBubble に初参加し、ビジター向けクロージングの場として機能していることを体感した。\n- 福上さん（デザイナー、GW頃入会予定）とは、UI/UX 領域での協業可能性がある。\n- 竹内さんは、杉並区選抜キャプテン経験があり、18チームに助っ人登録している。\n- 竹内さんの家族構成は、妻、0歳の娘、父母、弟2人。\n- 次廣の家族構成は、妻、娘2人（中3・小6）、猫4匹。趣味はキャンプ、ジム、家族との時間。高校時代は水球部。\n\n#### 確認待ち事項\n\n- 竹内さんが東京から静岡へ移動してリアル開催のキッズマネーセミナーを実施できるか。新幹線で1時間半〜2時間程度の移動が想定される。\n- 次廣が、現 PTA 会長へ竹内さんを紹介する具体的なタイミングと方法。\n- 次廣が、静岡のサッカーパパコーチへ竹内さんを紹介する具体的な相手・導入文。\n- 倉持さんへのシステムテスト協力依頼について、具体案件が出た際の相談方法。\n- 第1回 1to1 の終了時刻を確認する。\n- 竹内さんの所属会社名の正式表記、Webサイト、BNIプロフィール URL を確認する。\n\n#### アクションアイテム\n\n- **次廣:** 静岡のサッカーパパコーチに、竹内さんのキッズマネーセミナーを紹介する。\n- **次廣:** 現 PTA 会長へ竹内さんを紹介できるか確認する。\n- **竹内さん:** 法人経営者へのインタビュー時に、業務効率化ニーズをヒアリングし、該当があれば次廣へ紹介する。\n- **竹内さん:** Dリーグ（ダンスプロリーグ）について調査する。次廣の娘が所属チームのスクールに通っている接点がある。\n- **次廣:** 助成金・補助金が絡む案件で連携できる行政書士・経営コンサル候補を整理する。\n\n#### 次回1on1\n\n- **未定**\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 竹内さんは、サッカー・アスリート領域に強い保険営業であり、単なる保険販売ではなく、スポーツコミュニティ・親子教育・法人経営者接点を持っている。\n- キッズマネー教育は、PTA・スポーツクラブ・住宅展示場・カーディーラーなどのイベント集客と相性が良い。静岡では、次廣の PTA 会長経験とサッカーパパコーチ人脈が紹介導線になる。\n- 竹内さんが法人営業へシフトする場合、経営者との財務ヒアリングの中で、業務効率化・属人化・Excel 管理限界などの DX ニーズを拾える可能性がある。\n- tugilo 側は助成金・補助金を単独では扱わないため、竹内さんの法人営業先に対しては、システム開発・保険・士業・行政書士・経営コンサルの役割分担を明確にすると紹介しやすい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 竹内さんへの紹介は、「保険の営業」ではなく、**親子向けマネー教育コンテンツを持つアスリート専門の金融・保険パートナー**として伝える。\n- 静岡のサッカーパパコーチには、子ども向けイベント・保護者向け15分セミナー・スポーツクラブの集客企画という切り口で紹介する。\n- PTA への接続では、金融商品の販売色を前面に出しすぎず、「子どもがお金と感謝を学ぶ体験型セミナー」として説明する。\n- 竹内さんの法人営業シフトに合わせ、経営者ヒアリングで出やすいキーワード（Excel限界、二重入力、属人化、請求・契約・顧客管理、LINE連携）を事前に共有しておく。\n- 同業 SE メンバーとの重複は競合ではなく、案件規模・得意領域・上流設計・テスト・UI/UX で役割分担できる関係として整理する。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- **竹内さんに紹介しやすい相手:** サッカークラブ、スポーツ少年団、パパコーチ、PTA 会長・役員、住宅展示場、カーディーラー、親子イベント主催者、アスリート支援に関心のある法人。\n- **紹介時の切り口:** 「子どもがお店屋さんごっこでお金と感謝を学ぶ」「親御さん向けに短時間のマネーセミナーができる」「スポーツクラブや PTA の親子イベントに向いている」。\n- **竹内さんから tugilo への紹介導線:** 法人経営者への財務・保険ヒアリング時に、Excel 管理、二重入力、顧客管理、請求、契約、現場日報、LINE対応などの困りごとが出たら、次廣を紹介してもらう。\n- **DragonFly 内の連携:** 福上さんの UI/UX、倉持さんの上流設計・テスト協力、行政書士・経営コンサル候補との補完関係を整理し、紹介時に「チームで受けられる」印象を作る。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 竹内さんは、サッカー経験と保険営業を組み合わせた明確な専門性を持っている。\n- 0歳の娘がいる父親として、キッズマネー教育や親子向けイベントへの思いが伝わりやすい。\n- 次廣側の PTA・子育て・スポーツ・Dリーグ接点と、竹内さんのサッカー・親子教育・法人営業接点は相性が良い。\n- 初回 1to1 時点で、相互紹介の方向性が具体的に見えている。まずは静岡でのキッズマネーセミナー紹介が最初の行動になりそう。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(19,1,37,4,NULL,NULL,NULL,'manual','2026-04-24 11:30:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_matsukura_kenji_glassfilm_coating.md】\n\n# 1to1_松倉Kenji_ガラスフィルム・コーティング\n\n---\n\n**文書の位置づけ:** 松倉さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録として整理する。  \n**整理:** tugilo（次廣 淳）と松倉さんは、同じ **BNI DragonFly** チャプターのメンバー。相互理解、紹介可能性、DragonFly 内での協業・役割分担を確認した。  \n**日時:** 第1回は **2026-04-24 JST 11:30〜**。終了時刻は **TODO**（カレンダー／Zoom 録画メタ等で確認後に更新する）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は Zoom 文字起こし要約ベース。正式社名・BNIプロフィール・Webサイト等で確定情報が取れたら更新する。\n\n- **名前:** 松倉 Kenji\n- **事業名:** ガラスフィルム施工・コーティング事業（正式社名 TODO）\n- **拠点:** 千葉県松戸市\n- **BNI:** DragonFly チャプター\n- **事業領域:** ガラスフィルム施工、コーティング、エアロゲル透明断熱フィルムの提案・施工。\n- **体制:** ガラスフィルム施工職人15人を抱え、自身も営業と施工を兼務。\n- **主な顧客:** 高級リゾートホテル、星野リゾートなど。15年来の付き合いがある顧客も多い。\n- **強み:** 全国5社のうちの1社としてエアロゲル透明断熱フィルムを扱う。夏冬両対応、透明性、結露防止、飛散防止、防災効果を訴求できる。\n- **DragonFly 内実績:** 貝沼さん・畑山さんの事務所や自宅に施工実績あり。新築案件よりも、住んでからの困りごと解決が中心。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-04-24 JST 11:30〜、Zoom 文字起こし要約を 2026-05-17 に本ファイルへ反映。終了時刻は TODO）。\n- **主な成果:** 松倉さんのガラスフィルム・コーティング事業と、次廣の AI 業務改善システム構築について相互理解を深めた。\n- **合意事項:** 次廣は、静岡のインテリア資材卸売会社の社長を通じて、松倉さんのガラスフィルム事業を紹介できるか検討する。\n- **次アクション:** 次廣は、6月23日のメインプレゼンに向けてビジター招待を強化する。松倉さんは、内部リファーラル発表時に企業名・肩書を強調し、紹介の価値が伝わる表現へ改善する。\n- **案件化・協業の芽:** 高級ホテル・建築・インテリア・防災・省エネ領域で、松倉さんの施工商材と次廣の士業・コンサル・中小企業ネットワークを接続できる可能性がある。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-24 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-24（金）JST 11:30–TODO**（開始時刻: ユーザー提供「次廣さん⇔松倉 Zoom ミーティング 2026-04-24 11:30(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、松倉 Kenji\n- **Religo 1to1 レコード:** `one_to_ones.id = 19`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣は、静岡でシステムエンジニアとして活動しており、Excel 管理の限界を感じている中小企業向けに業務改善システムを構築している。\n- 松倉さんは、松戸を拠点にガラスフィルム施工とコーティング事業を展開しており、エアロゲル透明断熱フィルムを扱う全国5社のうちの1社として、高級リゾートホテルを中心に営業している。\n- 両者は同じ BNI DragonFly メンバーとして、事業内容、紹介しやすい相手、DragonFly 内での協業可能性を確認した。\n\n**決定事項・合意内容**\n\n- **静岡の紹介可能性:** 次廣は、静岡のインテリア資材卸売会社の社長を通じて、松倉さんのガラスフィルム事業を紹介できるか検討する。\n- **ITチーム内の役割分担:** コナカさんはシステム開発を担当しない AI 活用コンサル、次廣はシステム開発担当として役割を分け、大規模案件では協業する方向性を確認した。\n- **次廣の顧客ターゲット:** Excel・スプレッドシート運用が限界に近い中小企業の経営者を中心に、士業・コンサル経由の紹介を重視する。\n\n**交換されたフィードバック**\n\n松倉さんから次廣へ:\n\n- ウィークリープレゼンでの表現力を高く評価。\n- リファーラルプレゼンでは、内部取引であっても企業名や肩書を強調し、「誰に紹介したか」「どれだけすごい取引か」が伝わるようにするとよい。\n- DragonFly 内のウェブマスター業務は倉持さんに負荷が集中しており、サポート体制が必要ではないかと指摘。\n\n次廣から松倉さんへ:\n\n- BNI の学びが仕事に活かせており、会費以上の価値を感じている。\n- 初月はトレーニングと 1to1 の多さに苦労したが、脳梗塞の経験から記憶だけに頼らず、全ミーティングを AI で記録・データベース化している。\n\n**次廣側の事業概要**\n\n- **屋号:** tugilo（つぎろ）\n- **経歴:** システムエンジニア歴25〜26年。\n- **事業内容:** Excel・スプレッドシートで管理している業務を一元化し、一回の入力で回る仕組みを構築する。\n- **主な実績:** 増本さんのフランチャイズ管理システム（70%効率化、120万円で構築）、解体業の問い合わせ〜請求管理、観光局のスタンプラリー管理、防水工事会社の工程管理など。\n- **強み:** 既存ツールを押し付けず、現場の業務フローに合わせてゼロベースで開発する。小さく作って確実に育てる伴走型アプローチ。\n- **AI活用:** AI 活用で開発効率を8割改善し、その時間を BNI 活動に充てている。\n\n**松倉さん側の事業概要**\n\n- **事業内容:** ガラスフィルム施工、コーティング、エアロゲル透明断熱フィルムの提案・施工。\n- **体制:** ガラスフィルム施工職人15人を抱え、自身も営業と施工を兼務。\n- **商材:** エアロゲル透明断熱フィルムは世界初の技術。夏冬両対応、透明性、結露防止、飛散防止を実現する。\n- **防災効果:** 建築基準法の台風圧をクリアし、窓ガラスを守ることで屋根の飛散も防ぐ可能性がある。\n- **主要顧客:** 高級リゾートホテル、星野リゾートなど。15年来の付き合いがある顧客も多い。\n- **営業姿勢:** 営業中の施工依頼も多く、自身が対応することで顧客との信頼関係を構築している。\n- **DragonFly 内実績:** 貝沼さん・畑山さんの事務所や自宅に施工実績あり。新築案件は少なく、住んでからの困りごと解決が中心。\n\n**BNI活動について**\n\n- 次廣は、増本さんの紹介で約10年前から環境衛生協議会に参加していた。DragonFly 立ち上げ時にも誘われたが、時間的制約で見送り、約1ヶ月前に正式加入した。\n- 増本さんが静岡に来た際は10人以上が集まり、朝2時まで飲み会が続く文化がある。\n- 松倉さんは、外注ブロックの施工店として平岡さんの下で活動しており、増本さんが作ったフランチャイズ管理システムを利用している。\n- 松倉さんは、入会後すぐにウェブマスター、1to1、ビジターホストコーディネーターを歴任し、走りすぎたと振り返った。\n- リファーラルプレゼンは「ビジターへの例会プレゼン」として外向けに発表すべきで、内部取引でも企業名・肩書を強調することが重要だと確認した。\n\n#### 確認待ち事項\n\n- 次廣が、静岡のインテリア資材卸売会社の社長に松倉さんのガラスフィルム事業を紹介できるか確認する。\n- 次廣の BNI 役職アサインは、全トレーニング終了後に決定される見込み。\n- 松倉さんの正式社名・Webサイト・BNIプロフィール URL を確認する。\n- 第1回 1to1 の終了時刻を確認する。\n\n#### アクションアイテム\n\n- **次廣:** 静岡のインテリア資材卸売会社の社長に、松倉さんのガラスフィルム事業を紹介できるか確認する。\n- **次廣:** 6月23日のメインプレゼンに向けて、ビジター招待を強化する。\n- **松倉さん:** DragonFly メンバーへの内部リファーラル発表時に、企業名・肩書を強調した表現へ改善する。\n\n#### 次回1on1\n\n- **未定**\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 松倉さんは、施工技術・現場対応・営業対応の両方を持つ実務型の事業者。高級リゾートホテルなど、品質・信頼・継続関係が重視される顧客との接点が強い。\n- エアロゲル透明断熱フィルムは、断熱・透明性・結露防止・飛散防止・防災の複数メリットを持つため、ホテル、旅館、オフィス、住宅、インテリア、建築、防災、省エネ文脈で紹介しやすい。\n- DragonFly 内では、住んでからの困りごと解決や既存施設の改善ニーズと相性が良い。新築案件よりも、暑さ・寒さ・結露・飛散防止・防犯・省エネなどの「困りごと」起点で紹介する方が刺さりやすい。\n- 松倉さんは BNI 運営経験が深く、リファーラルプレゼンやチャプター運営負荷について実践的なフィードバックをくれる存在。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 松倉さんへの紹介は、単なる「窓ガラスフィルム」ではなく、**高級施設の快適性・省エネ・防災・資産保全**の文脈で伝える。\n- 静岡のインテリア資材卸売会社社長への接続は、建築・インテリア・ホテル・施設管理のネットワークに広がる可能性があるため、まずは軽い情報提供または紹介可否確認から進める。\n- tugilo 側の事業紹介では、Excel 管理の限界、二重入力、属人化、現場に合わせた小規模スタートを軸にする。松倉さんからのフィードバックを受け、紹介実績や相手企業の肩書・規模が伝わる表現を強める。\n- ITチーム内では、AI活用コンサルとシステム開発担当の違いを明確にし、大規模案件では役割分担して受けられる体制を整える。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- **紹介してほしい相手:** ホテル・旅館・リゾート施設、インテリア資材・建材・設計・施工関係者、結露・暑さ寒さ・省エネ・飛散防止に課題がある施設管理者。\n- **紹介時の切り口:** 「窓ガラスの暑さ寒さ対策」「透明な断熱フィルム」「高級リゾートホテルで使われる品質」「台風・飛散防止の防災対策」。\n- **tugilo側の紹介導線:** 静岡のインテリア資材卸売会社社長への紹介可否確認から始め、必要に応じて松倉さんの実績・商材説明・施工事例を共有する。\n- **次廣のプレゼン改善:** 内部リファーラルでも、紹介先の企業名・肩書・成果の大きさを明確にし、ビジターにも伝わる外向け表現へ寄せる。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 松倉さんは、BNI 活動量が多く、役職経験・運営側の視点を持っている。\n- 技術商材を扱う一方で、営業・施工・顧客対応を自ら担うため、現場感のある話ができる。\n- 次廣に対しては、プレゼン表現や BNI 活用方法について率直なフィードバックをくれる関係性。\n- 倉持さんのウェブマスター業務負荷についても言及があり、DragonFly 内の支援体制づくりの文脈で今後の接点があり得る。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(20,1,37,97,NULL,NULL,NULL,'manual','2026-04-27 10:58:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_iizuka_graphic_design.md】\n\n# 1to1_飯塚氏_グラフィックデザイン\n\n---\n\n**文書の位置づけ:** 飯塚さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録として整理する。  \n**整理:** tugilo（次廣 淳／BNI DragonFly）と飯塚さん（グラフィックデザイナー／BNI 大人なじみ）が初回 1on1 を実施し、相互の事業理解、紹介候補、システム×デザインの協業可能性を確認した。  \n**日時:** 第1回は **2026-04-27 JST 10:58〜**。終了時刻は **TODO**（カレンダー／Zoom録画メタ等で確認後に更新する）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は Zoom 文字起こし要約ベース。正式氏名・屋号・Webサイト・BNIプロフィール等で確定情報が取れたら更新する。\n\n- **名前:** 飯塚氏（名 TODO）\n- **BNI:** 大人なじみチャプター\n- **カテゴリー:** グラフィックデザイン／デザイン制作\n- **専門領域:** ロゴ、名刺、チラシ、パンフレット、パッケージ、キャラクター、Webデザイン。\n- **補足:** Webデザインは対応するが、コーディングは不可。\n- **実績:** Jリーグ、ファミリーマートなど大手企業のデザイン実績多数。\n- **訴求軸:** デザインを経営に取り入れる企業は売上成長率が高く、従業員からも愛されるという統計的根拠を重視。\n- **ロゴ価値の説明例:** NTT 5,000万円、ペプシ1億円、楽天は年間2億円規模のデザイン投資、ナイキは5,000円で作成されたロゴが巨大な利益を生んだ事例。\n- **スタートアップ向けサービス:** ロゴ + ホームページを 11万円で提供（条件付き：2案提案、修正制限あり）。\n- **BNI歴:** 4年超。夏更新で5年目。チャプターメンバーは32人規模。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-04-27 JST 10:58〜、Zoom 要約を 2026-05-17 21:51 JST に本ファイルへ反映。終了時刻は TODO）。\n- **主な成果:** 次廣の B2B 業務改善・システム構築サービスと、飯塚さんのデザインサービスについて相互理解が深まり、複数の具体的な紹介候補を確認した。\n- **合意事項:** 飯塚さんは、社労士の渋谷氏、雨漏り調査専門家（水漏れレコーデ）、システム開発デザイナーの竹本氏を次廣へ紹介する。次廣は、田渕恭平氏（庵治石を扱う石材業者）、行政書士の佐久間氏・望月氏を飯塚さんへ紹介する。\n- **案件化・協業の芽:** システム開発における UI/UX デザイン、B2C アプリの視覚設計、現場マニュアルの漫画化、フロントエンド／Webデザイン領域で協業可能性がある。\n- **次アクション:** 次廣は DragonFly メンバーリスト（写真付き）を飯塚さんへ送付し、田渕氏・行政書士メンバーへの紹介を進める。飯塚さんは自チャプターのメンバーリストを次廣へ送付し、次廣のプレゼン資料を関係者に展開する。\n- **次回予定:** 5月に再度実施予定（ゴールデンウィーク後）。月次 1on1 で継続的に関係構築する方針。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-27 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-27（月）JST 10:58–TODO**（開始時刻: ユーザー提供「飯塚様1to1 2026-04-27 10:58(GMT+9:00)」。終了時刻はカレンダー／Zoom録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、飯塚氏\n- **Religo 1to1 レコード:** `one_to_ones.id = 20`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣は、静岡で活動するシステムエンジニアとして、B2B 向けの業務改善・システム構築を提供している。\n- 飯塚さんは、ロゴ・名刺・チラシ・パンフレット・パッケージ・キャラクター・Webデザインを扱うグラフィックデザイナーとして活動している。\n- 両者は初回 1on1 で、お互いのビジネスモデル、紹介してほしい相手、紹介できそうな相手、システムとデザインの協業可能性を確認した。\n\n**主な成果**\n\n- 次廣の業務改善・システム構築サービスと、飯塚さんのデザインサービスについて相互理解が深まった。\n- 次廣側・飯塚さん側の双方で、具体的な紹介候補が複数明確になった。\n- システム開発における UI/UX、B2C アプリ、マニュアルの漫画化、Webデザイン協業など、将来的な協業領域を確認した。\n- 継続的な月次 1on1 の実施と LINE 連絡先交換に合意した。\n\n**決定事項・合意内容**\n\n- **相互紹介の実施:** 飯塚さんは、社労士の渋谷氏、雨漏り調査専門家（水漏れレコーデ）、システム開発デザイナーの竹本氏を次廣へ紹介する。\n- **香川の石材業者との連携:** 次廣は、田渕恭平氏（庵治石を扱う石材業者）を飯塚さんへ紹介し、ブランディング・商品開発の可能性を探る。\n- **DragonFly メンバーへの展開:** 次廣は、行政書士の佐久間氏・望月氏を、飯塚さんのスタートアップ向けサービスに接続できるか検討する。\n- **継続的な関係構築:** 月次での定期的な 1on1 実施に合意し、LINE 連絡先を交換した。\n- **メンバーリスト共有:** 次廣は DragonFly チャプターの写真付きメンバーリストを飯塚さんへ送付し、飯塚さんも大人なじみチャプターのメンバーリストを次廣へ送付する。\n\n**次廣側の事業概要**\n\n- **専門領域:** B2B 向け業務改善とシステム構築。システムエンジニア歴25〜26年、独立23年目。\n- **対象業種:** 建設業、製造業、複数拠点のサービス業、フランチャイズ。\n- **アプローチ:** 属人化の解消、一回入力で完結する仕組み、現場フローを変えない伴走型の構築。\n- **成果事例:** フランチャイズ200店舗の管理システム統合、複数拠点の予約・実績管理の一元化による作業時間50%以上削減。\n- **AI活用:** 25〜26年は手書きでプログラミングしてきたが、現在は AI を積極活用している。\n- **紹介してほしい相手:** 売上は伸びているが現場が追いつかない経営者、複数拠点のサービス業、フランチャイズ、顧客を持つ士業・コンサルタント。\n\n**飯塚さん側の事業概要**\n\n- **専門領域:** ロゴ、名刺、チラシ、パンフレット、パッケージ、キャラクター、Webデザイン。\n- **実績:** Jリーグ、ファミリーマートなど大手企業のデザイン実績多数。\n- **強みの説明:** デザインは単なる見た目ではなく、売上成長、採用・従業員エンゲージメント、企業価値に影響する経営資産として説明している。\n- **ロゴ価値の事例:** NTT、ペプシ、楽天、ナイキなどの事例を用いて、ロゴ・ブランドへの投資価値を伝えている。\n- **スタートアップ向け:** ロゴ + ホームページを 11万円で提供（条件付き：2案提案、修正制限あり）。\n- **紹介してほしい相手:** スタートアップ経営者、2代目・3代目経営者、リブランディング需要のある企業、経営コンサル、広告代理店、行政書士・司法書士など起業支援に関わる士業。\n\n**BNI活動状況**\n\n- **次廣:** DragonFly チャプター入会1ヶ月。4月に13のトレーニング受講を完了し、10人紹介を完了。\n- **飯塚さん:** BNI歴4年超。夏更新で5年目。大人なじみチャプターは32人規模。\n- **DragonFly:** 約50人規模。オンライン専門で全国から参加し、NE地域リージョンに所属。\n\n**協業可能性**\n\n- **UI/UXデザイン:** 次廣の B2C アプリ開発では、ボタン配置や視覚的なわかりやすさが重要になるため、飯塚さんのデザイン力を活用できる可能性がある。\n- **マニュアルの漫画化:** 文字を読まない現場向けに、飯塚さんの知人である漫画家と連携して、マニュアルを視覚化する案がある。\n- **フロントエンド協業:** 次廣はバックエンドを得意とし、Webデザイナーと組むことが多いため、飯塚さんとの協業余地がある。\n- **石材ブランディング:** 田渕氏の庵治石・石材事業に対し、飯塚さんがブランディングや商品開発面で提案できる可能性がある。\n\n#### 確認待ち事項\n\n- 次廣が、DragonFly チャプターの写真付きメンバーリストを飯塚さんへ送付する。\n- 飯塚さんが、大人なじみチャプターのメンバーリストを次廣へ送付する。\n- 飯塚さんが、次廣のプレゼン資料を関係者に展開する。\n- 飯塚さんが、田渕氏向けに石材ブランディング・商品開発の提案を準備する。\n- 飯塚さんの正式氏名、屋号、Webサイト、BNIプロフィール URL を確認する。\n- 第1回 1to1 の終了時刻を確認する。\n\n#### アクションアイテム\n\n- **飯塚さん:** 社労士の渋谷氏に、次廣の業務改善・システム構築サービスを提案する。\n- **飯塚さん:** 雨漏り調査専門家（水漏れレコーデ）に、次廣を紹介する。\n- **飯塚さん:** 竹本氏（BNIトレーニング一覧作成者）に、次廣の資料を送付する。\n- **次廣:** 田渕恭平氏（庵治石）を飯塚さんに紹介する。\n- **次廣:** 佐久間氏・望月氏（行政書士）を飯塚さんに紹介する。\n- **次廣:** DragonFly メンバーリスト（写真付き）を飯塚さんに送付する。\n- **飯塚さん:** 自チャプターのメンバーリストを次廣に送付する。\n\n#### 次回1on1\n\n- **5月に再度実施予定**（ゴールデンウィーク後）。\n- 継続的な月次 1on1 で信頼関係を構築する方針。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 飯塚さんは、デザインを「制作物」ではなく「経営資産」として説明できる人。紹介時は、ロゴ・チラシ単体ではなく、売上成長・採用・ブランド信頼・事業承継の文脈で伝えるとよい。\n- スタートアップ向けのロゴ + ホームページ 11万円パッケージは、行政書士・司法書士・創業支援者との相性が良い。DragonFly 内の士業メンバーへの紹介導線が作りやすい。\n- 次廣側のシステム開発では、B2C アプリや現場向け UI、マニュアルの漫画化など、非エンジニアに伝わる設計が重要な案件で協業可能性がある。\n- 飯塚さんは大人なじみチャプターで4年以上活動しており、次廣にとってクロスチャプター紹介の起点になり得る。実際に伊藤氏紹介へつながっている。\n- 田渕氏の石材・庵治石領域は、飯塚さんのブランディング力と相性が良い。高級商材・伝統産業・商品開発の切り口で接続するとよい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 飯塚さんへ次廣を紹介してもらう際は、**「売上が伸びて現場が追いつかない会社の、業務フローを壊さずシステム化する人」** として伝えてもらう。\n- 士業・コンサル向けには、次廣を「顧問先の業務改善・補助金後のシステム導入・属人化解消を受けられる開発パートナー」として紹介しやすい形に整える。\n- 飯塚さんへの紹介は、スタートアップ・事業承継・リブランディング・商品開発のどれかに文脈を絞る。単なる「デザイナー紹介」ではなく、相手の経営課題に接続して渡す。\n- 田渕氏紹介では、庵治石の価値を「高級石材」「空間プロデュース」「伝統産業の商品化」として整理し、飯塚さんが提案しやすい前提情報を添える。\n- UI/UX・漫画マニュアル・Webデザイン協業は、すぐ案件化を狙うより、次廣の既存案件で「視覚化が必要な局面」が出たときに相談できる関係として温める。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n- **飯塚さんに紹介したい相手:** 起業直後の経営者、2代目・3代目経営者、リブランディングを検討している会社、商品開発・パッケージ改善が必要な事業者、行政書士・司法書士など創業支援の士業。\n- **飯塚さんへの紹介時の切り口:** 「ロゴ・Web・パッケージを、経営資産として整えてくれるグラフィックデザイナー」。価格訴求だけでなく、ブランド価値・社内外への伝わり方を強調する。\n- **次廣が紹介してほしい相手:** 士業・コンサル、フランチャイズ、複数拠点サービス業、建設業・製造業、手入力・二重入力・属人化で現場が詰まっている経営者。\n- **次廣への紹介時の切り口:** 「Excel・スプレッドシート運用の限界を、現場の流れを変えずに一回入力で回る仕組みにするSE」。\n- **クロスチャプター活用:** 大人なじみチャプターの士業・専門家ネットワークと、DragonFly の士業・石材・スタートアップ支援接点をつなぐハブとして関係を育てる。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 飯塚さんは、紹介先を具体名で出してくれる実行寄りの人。初回から社労士・雨漏り調査・システム開発デザイナーなど複数の接続候補が出ている。\n- デザインの価値を、金額事例や統計的根拠で説明するスタイル。紹介文にも「なぜデザインが経営に効くか」を入れると相性がよい。\n- 月次 1on1 に合意しており、単発の紹介交換ではなく、継続的な相互理解の関係に発展させやすい。\n- 大人なじみチャプターへの入口として重要。飯塚さん経由の紹介・メンバーリスト共有は、クロスチャプター展開の基盤になる。\n\n---\n\n**運用メモ:** 新規セッションは **【第2回】** を上に追記し、**サマリー** を更新する。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(21,1,37,98,NULL,'89157467602','IwdcYnOrRzeXiyNsb0v2pA==','manual','2026-05-07 15:57:00','2026-05-07 16:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_tamura_kodai_money_cooking.md】\n\n# 1to1_田村広大_お金の料理教室\n\n---\n\n**文書の位置づけ:** 田村広大さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録として整理する。  \n**整理:** tugilo（次廣 淳）の接点チャプター: **BNI DragonFly**。田村さんは大阪の **お金の料理教室**、BNI カーネルチャプター所属。  \n**日時:** 第1回は **2026-05-07 JST 15:57〜**。終了時刻は **TODO**（カレンダー／Zoom 録画メタ等で確認後に更新する）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は Zoom 文字起こし要約ベース。名刺・Web・BNIプロフィール等で確定情報が取れたら更新する。\n\n- **名前:** 田村広大\n- **事業名:** お金の料理教室\n- **拠点:** 大阪\n- **BNI:** カーネルチャプター。30番目に加入。現在メンバー28名中、紹介が1名に集中していることが課題。\n- **職歴:** 三井住友銀行2年、消防士3年を経て、保険代理店13年目。\n- **事業領域:** 49社の保険、SBI証券・楽天証券を扱える独立系アドバイザー。\n- **強み:** 手数料構造を透明にし、顧客利益を優先した保険・投資設計を行う。積立NISAなど手数料ゼロの商品も推奨し、長期的な顧客資産増加から継続収益を得る設計。\n- **主なターゲット:** 建設業者、損保支払いが年200万円以上の企業、財務コンサル経由で紹介される法人。\n- **実績例:** 損保1,500万円を800万円に削減し、浮いた70万円/月を投資へ回すことで、15年後2,500万円の退職金原資に転換する提案。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-05-07 JST 15:57〜、Zoom 文字起こし要約を 2026-05-17 に本ファイルへ反映。終了時刻は TODO）。\n- **主な成果:** 田村さんの金融・保険・投資助言モデルと、次廣の AI 業務改善システム開発について相互理解を深めた。\n- **合意事項:** 田村さんから、岡山のSEメンバー（下辻氏）、SEOコンサルタント、FCコンサルタントの紹介を検討・実施する。下辻氏との第1回 1to1 **実施済み**（**2026-05-19 JST 14:00〜**・Zoom）→ [`1to1_shimotsuji_hs_neo_project.md`](1to1_shimotsuji_hs_neo_project.md)（同業・協力体制・友達申請合意。SEO・FC紹介は **TODO**）。\n- **次アクション:** 次廣は田村さんへ、自身の保険・投資商品の個別相談を依頼する。田村さんには、次廣の DragonFly 内建設業ネットワークを紹介できる可能性を探る。\n- **案件化・協業の芽:** 建設業向けに、田村さんの損保削減・投資プランと、次廣のDXシステム導入を組み合わせた提案余地がある。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-07 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-07（木）JST 15:57–TODO**（開始時刻: ユーザー提供「田村様1to1 2026-05-07 15:57(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 21`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 田村さんの「お金の料理教室」と、次廣の「AI業務改善システム構築」について、ビジネスモデル・強み・紹介しやすい相手を相互に確認した。\n- 田村さん側からは、建設業者向けの損保削減・投資設計、金融業界の手数料構造、顧客利益を優先する営業姿勢が共有された。\n- 次廣側からは、現場に合わせたウェブベースの業務システム開発、小さく始めて育てる開発方針、AI活用による業務改善実践が共有された。\n- 具体的な協業可能性として、建設業向けサービス、SEO・FC専門家との連携、SE同士の協業が話題になった。\n\n**決定事項・合意内容**\n\n- **相互紹介:** 田村さんが次廣に、岡山のSEメンバー（下辻氏）、SEOコンサルタント、FCコンサルタントの3名を紹介する。\n- **個別相談:** 次廣が田村さんに、自身の保険・投資商品について個別相談を依頼する。\n- **建設業ネットワーク活用:** 次廣の DragonFly チャプター内の建設業メンバーを、田村さんに紹介できる可能性を検討する。\n- **チャプター内紹介:** 田村さんのチャプター内にいる組織開発・販促コンサル系メンバーへ、次廣を紹介する可能性を検討する。\n\n**交換されたフィードバック**\n\n田村さんから次廣へ:\n\n- システム開発の「小さく始めて育てる」段階的アプローチは、紹介時に提案しやすい。\n- 既存顧客からの紹介実績が、信頼性の証明になっている。\n- 直接取引によって中間コストを削減できる点が、顧客にとって魅力的。\n\n次廣から田村さんへ:\n\n- 金融商品の説明が非常にわかりやすく、初めて納得できる内容だった。\n- 手数料構造の透明性が、他の金融業者と一線を画している。\n- 顧客利益を優先する姿勢に共感した。会話内では「南の帝王」的な、相手の実利に踏み込むアプローチとして印象に残った。\n\n**田村さん側の事業概要**\n\n- **職歴:** 三井住友銀行2年、消防士3年、保険代理店13年目。\n- **提供範囲:** 49社の保険、SBI証券・楽天証券を扱える独立系アドバイザー。\n- **収益モデル:** 手数料ゼロの積立NISAも推奨し、長期的な資産増加に伴う年0.1%程度の継続手数料を重視。\n- **ターゲット:** 建設業者、損保200万円以上支払い企業、財務コンサル経由の紹介先。\n- **実績例:** 損保1,500万円を800万円に削減し、浮いた70万円/月を投資に回すことで、15年後2,500万円の退職金に転換する提案。\n- **課題:** BNI カーネルチャプターでは紹介が一部メンバーに集中しており、紹介経路の拡大がテーマ。\n\n**次廣側の事業概要**\n\n- **経歴:** SE歴25年、30歳で独立し、独立23年目。\n- **事業内容:** 現場に合わせたウェブベースの業務システム開発、保守サポート型の伴走。\n- **強み:** 既存ワークフローを大きく変えず、現場が楽になる仕組みを小さく始めて育てる。\n- **ターゲット:** Excel管理が限界の企業、二重入力に苦しむ中小企業、属人化・ファイル分散で困っている企業。\n- **実績:** FC本部200店舗管理システム、解体業LINE連携システム、防水工事業工程管理など。\n- **AI活用:** 2年前から自身の業務にAIを取り入れ、業務効率を9割改善。プログラム作成もAIと協業している。\n- **BNI:** DragonFly チャプターに3月17日加入、4月末にグラデュエート取得。最速記録として共有。\n\n**協業可能性の検討**\n\n- **建設業向けパッケージ:** 田村さんの損保削減・投資プランと、次廣のDXシステム導入を組み合わせる。浮いた保険料の一部をシステム導入費用に充てられる可能性がある。\n- **DragonFly 建設業ネットワーク:** DragonFly チャプター内には建設業メンバーが複数おり、田村さんのターゲットと接続しやすい。\n- **IT業界向けサービス:** 田村さんは、ウェブ制作会社に特化した社保削減提案（国の制度活用）を検討中。ウェブ制作会社経由で多業種へリーチできる可能性がある。\n- **SEO専門家との連携:** 次廣のシステム開発と、田村さんが紹介可能なSEO専門家の協業余地がある。\n- **システム会社間連携:** SE同士の協業で苦手分野を補完し、直接取引による中間マージン削減を顧客メリットとして出せる。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 田村さんは、BNI 内で紹介が一部メンバーに集中しており、紹介経路を広げたい。\n- 次廣は、自身の保険・投資商品について、田村さん視点で見直し提案を受ける余地がある。\n- 田村さんのチャプター内メンバー（SEO、FC、SE専門家）との連携方法は、具体的な紹介後に詰める必要がある。\n- DragonFly チャプター内の建設業メンバーと田村さんの面談設定は、相手候補の選定が未確定。\n\n#### 仮説（tugilo視点）\n\n- **最初の協業テーマ:** 建設業者向けに「保険料削減で原資を作る → 業務システム化で現場改善する」という流れを作ると、双方の価値が伝わりやすい。\n- **紹介の切り口:** 田村さんは金融商品の売り込みではなく、手数料構造と長期資産形成の透明性で信頼を取れる。建設業経営者・財務相談に近い相手と相性が良い。\n- **次廣側の商談化:** SEO・FC・SE専門家の紹介は、すぐ案件化よりも協業パートナー開拓として捉え、相手の顧客層・得意領域・紹介し合える課題を確認する。\n- **個別相談の価値:** 次廣自身の保険・投資相談を先に行うことで、田村さんの説明品質を実体験として語れるようになり、紹介時の説得力が増す。\n\n#### アクションアイテム\n\n- **田村さん:** 岡山のSE（下辻氏）、SEOコンサルタント、FCコンサルタントの連絡先を次廣に共有する（期限未定）。\n- **田村さん:** チャプター内の組織開発・販促コンサルメンバーに次廣を紹介する（期限未定）。\n- **次廣:** DragonFly チャプター内の建設業メンバーを田村さんに紹介する候補として検討する（期限未定）。\n- **次廣:** 田村さんに対し、保険・投資の個別相談を依頼する（期限未定）。\n- **次回:** 田村さんの紹介予定者（SE・SEO・FC）との具体的な接点、DragonFly 建設業メンバーとの面談設定、次廣自身の保険見直し相談を確認する。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 田村さんは、金融商品の販売者というより、手数料構造を透明化し、顧客にとって本当に得になる選択肢を出すアドバイザーとしての色が強い。\n- 日本の金融業界では、手数料が高い商品ほど販売側に評価されやすく、顧客利益最大化商品（積立NISA等）が売られにくい構造がある、という問題意識が明確。\n- 保険経由の商品と積立NISAでは、同じ運用会社の商品でも手数料差により結果が大きく変わる。会話では、妻は8年で2倍、母は±ゼロという対比が印象的だった。\n- 建設業者に対しては、損保削減と退職金原資づくりを組み合わせた具体的な成功事例があり、次廣の建設業DX支援と組み合わせやすい。\n- 次廣側の「小さく始めるシステム開発」は、田村さんから見ても紹介しやすい特徴として受け止められた。\n- AI活用については、業務システム開発だけでなく、トレーニングメニュー、献立、買い物リスト、子どものSNS画像真偽判定まで実生活で使っていることが共有され、次廣の実践者としての信頼材料になる。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **個別相談を先に進める:** 田村さんに保険・投資の見直しを依頼し、説明品質・提案姿勢・実利を自分の体験として把握する。\n- **建設業紹介の軸:** DragonFly 内の建設業メンバーには、「保険料削減」「退職金原資」「DX原資づくり」を切り口に、田村さんを紹介できるか検討する。\n- **協業パッケージ案:** 建設業者向けに、田村さんが固定費・保険・資産形成を見直し、次廣が浮いた原資の一部で現場システム化を進める形を仮説として持つ。\n- **紹介先との向き合い方:** SEO、FC、SE専門家の紹介を受けたら、案件獲得より先に、相手の既存顧客にどんな業務課題が多いかを聞く。\n- **紹介文の作り方:** 田村さんを紹介する際は、「保険屋さん」ではなく、「保険料・手数料・投資原資を経営者目線で見直す人」と伝える。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣が田村さんに紹介してほしい相手\n\n- Excel・スプレッドシート・紙・LINEで現場管理が限界になっている中小企業\n- FC本部、加盟店管理、複数拠点管理に課題がある企業\n- SEO・Web集客支援先のうち、問い合わせ後の業務処理や顧客管理が詰まっている企業\n- システム会社・SEで、業務システム、AI活用、保守運用の補完先を探している人\n- 建設業・工事業で、工程管理、見積、請求、LINE連携、写真管理などに困っている企業\n\n**紹介文たたき台（次廣向け）**\n\n> 次廣さんは、Excelや紙、LINEで何とか回している業務を、現場の流れを大きく変えずに小さくシステム化できる方です。FC本部、建設業、複数拠点管理などで、二重入力や属人化に困っている会社さんがいれば一度つなげられます。\n\n### 田村さんに紹介できそうな相手\n\n- 損害保険料が高く、毎年の固定費に課題を感じている建設業者\n- 退職金原資、役員保障、資産形成を整理したい中小企業経営者\n- 保険・投資商品の手数料構造を透明に理解したい人\n- 財務コンサル・士業の顧客で、保険や投資設計の見直し余地がある法人\n- ウェブ制作会社やIT会社で、社保削減・制度活用に関心がある経営者\n\n**紹介文たたき台（田村さん向け）**\n\n> 田村さんは、保険や投資商品を売る前に、手数料や固定費、将来の資産形成まで見てくれる独立系アドバイザーです。特に建設業など、保険料が大きい会社さんには、削減した原資を退職金や投資に回す提案ができそうです。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 田村さんの説明は、金融商品に詳しくない相手にも構造が伝わるほどわかりやすかった。\n- 手数料ゼロの商品を勧める姿勢から、短期の販売手数料より長期の顧客利益と信頼を重視している印象。\n- 次廣の直接取引・段階開発・既存顧客紹介の実績は、田村さんにとって紹介しやすい要素として受け止められた。\n- 建設業は双方の接点が重なりやすい。田村さんは保険・財務・投資、次廣は現場システム・DX・AI改善で役割分担できる。\n- 次回1to1は未定。まずは紹介3件、保険・投資相談、DragonFly 建設業メンバー候補の確認を進める。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(22,1,37,99,NULL,NULL,NULL,'manual','2026-05-08 14:00:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md】\n\n# 1to1_木村秀継_株式会社国宝社\n\n---\n\n**文書の位置づけ:** 木村秀継さんとの 1to1 を **1ファイルで時系列管理**する。今回はユーザー提供の **Zoom 文字起こし要約**をもとに、第1回の議事録として整理する。  \n**整理:** tugilo（次廣 淳）の接点チャプター: **BNI DragonFly**。木村秀継さんは **BNI SPREAD** 所属の他チャプターメンバー。  \n**日時:** 第1回は **2026-05-08 JST 14:00〜**。終了時刻は **TODO**（カレンダー／Zoom 録画メタ等で確認後に更新する）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は Zoom 文字起こし要約ベース。名刺・Web・BNIプロフィール等で確定情報が取れたら更新する。\n\n- **名前:** 木村秀継\n- **事業名:** 株式会社国宝社\n- **BNI:** SPREAD チャプター（他チャプター）\n- **事業領域:** 製本業、家系図・ルーツ調査サービス\n- **会社概要:** 創業160年の製本会社。ジャンプ・マガジン等の製本を手掛けている。\n- **組織規模:** 社員数68名。\n- **業界背景:** 25年で89.2%が廃業する厳しい製本業界の中で、V字回復を達成。\n- **新規事業:** 戸籍情報と文献調査を組み合わせた **家系図・ルーツ調査**を展開中。\n\n**家系図・ルーツ調査サービス**\n\n- 戸籍情報から家系図を作成し、国会図書館の文献調査により先祖のルーツを解明する。\n- 日本で3社しか持たない調査技術とスキルを保有。\n- 成果物は、NHK「ファミリーヒストリー」のスライド版のようなイメージ。\n- 経営者や事業承継者が、自身の原点・強み・頑張る理由を見つけるツールとして活用できる。\n\n**YouTubeチャンネル**\n\n- 2024年4月開始。\n- 現在の登録者数は **7,830人**。\n- 目標は **30,000人**。家系図チャンネルとして圧倒的1位を目指している。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第2回 1to1 実施済み**（2026-05-29 JST 14:00–15:00、Zoom 文字起こし要約を 2026-05-29 に本ファイルへ反映）。\n- **主な成果:** 木村さん（BPS木村／株式会社国宝社）の製本システムにおける具体的な業務課題をヒアリング。月間300〜400件規模の **PDF注文書の手入力** を最優先課題として確認し、既存 VB + Oracle に直接手を入れず、社内サーバー上の Web インターフェースから PDF 解析・確認・DB登録する改善案で合意。\n- **合意事項:** Google Workspace / GAS は外部アクセス・セキュリティ観点から今回は主軸にせず、既存 VPN と社内ネットワークを活かした **社内完結型の Web システム**を検討する。第一段階は PDF 入力自動化、第二段階以降で Excel 帳票の Web化を検討。\n- **次アクション:** 次廣が数日以内に **提案書と簡易モックを無償作成**し、実現可能性・進め方・費用感を提示。木村さんはデータベース定義書とサンプル PDF を共有する。\n- **案件化の芽:** PDF 注文書自動入力、Oracle 直接連携、Hyper-V 上の Linux Web サーバー、社内 Wi-Fi / VPN アクセス、将来的な得意先直接入力システムまで段階展開の余地がある。\n- **要望整理:** 第2回 121 から提案書・簡易モック向けに切り出した要求は [木村秀継さん 第2回121 要望整理](1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md) を参照。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-08 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-08（金）JST 14:00–TODO**（開始時刻: ユーザー提供「木村秀継ミーティング 2026-05-08 14:00(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 22`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 木村さんの家系図・ルーツ調査事業と、次廣の AI 業務改善システム開発について相互理解を深めた。\n- 次廣が、木村さんの既存システム（VB + Oracle）のクラウド移行・Web化支援を提案。\n- 既存システム改善について、別途ヒアリングと提案の場を設けることで合意した。\n\n**決定事項・合意内容**\n\n- **既存システム改善のヒアリング:** 木村さんの既存システム改善について、次廣が別途ヒアリングと提案を実施する。\n- **日程調整:** 次廣が Messenger 経由で日程調整用リンクを送付する。\n- **事前整理:** 木村さんが、既存システムの課題と理想像を箇条書きレベルで整理する。手書きラフでも可。\n- **情報共有:** 次廣がホームページ URL を Messenger で送付する。\n\n**木村さん側の事業概要**\n\n- **株式会社国宝社:** 創業160年の製本会社。ジャンプ・マガジン等の製本を手掛ける。\n- **組織・実績:** 社員数68名。25年で89.2%が廃業する業界で、V字回復を達成。\n- **新規事業:** 家系図・ルーツ調査を展開中。\n- **調査内容:** 戸籍情報から家系図を作成し、国会図書館の文献調査で先祖のルーツを解明する。\n- **独自性:** 日本で3社しか持たない調査技術とスキルを保有。\n- **成果物イメージ:** NHK「ファミリーヒストリー」のスライド版。\n- **顧客価値:** 経営者や事業承継者が、自分の原点・強み・頑張る理由を発見するツールになりうる。\n- **YouTube:** 2024年4月開始、登録者7,830人。目標は30,000人で、家系図チャンネルとして圧倒的1位を目指す。\n\n**次廣側の事業概要**\n\n- **経歴:** システムエンジニア歴25〜26年。30歳で独立し、個人事業として22年運営。\n- **AI活用:** AI による業務効率化で BNI 参加の時間を確保。AI にコーディングを任せることで、開発スピードとコストを大幅に削減。\n- **BNI:** 2024年3月17日に DragonFly チャプター入会。4月にトレーニング強化月間として全トレーニングを受講。\n- **対応範囲:** インフラ構築、営業、サポート、B2B 業務システム、B2C システム、要件定義・設計支援、ネットワークトラブル対応まで幅広く対応。\n- **開発方針:** 現場のワークフローを無理に変えずに改善する。小規模に始め、必要な機能を段階的に追加する伴走型開発。\n\n**次廣の実績事例**\n\n- **フランチャイズ管理システム:** 全国200店舗（目標500店舗）の FC 向け。Googleフォーム・スプレッドシート・Excelで分散していた注文・顧客管理を統合。注文管理、契約店管理、請求管理、マニュアルコンテンツ配信を一元化。開発費は初期120万円から最終180万円程度、保守費は月額2〜3万円。\n- **在庫管理システム移行:** VB + PostgreSQL から Web化への移行。日報と在庫管理で約200万円の開発費。\n- **LINE連携:** 動物病院の予約管理システム、観光協会との周遊イベント用スタンプラリー・ビンゴシステム。\n\n**木村さんの既存システム改善テーマ**\n\n- **現状:** VB + Oracle のスタンドアローンシステム。Excel で ODBC 接続してデータ加工している。\n- **課題:** Google スプレッドシートとの連携、GAS（Google Apps Script）による自動化を希望。\n- **次廣の提案:** Oracle を維持しながら、Web化・クラウド移行が可能。サポート期間の問題解決とメンテナンス性向上につなげられる。\n- **次回ヒアリングの前提:** 木村さんが「困っていること」「理想の状態」を箇条書きで整理し、次廣が現状把握と提案を行う。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 既存システムが **VB + Oracle のスタンドアローン**で、今後の保守・サポート・拡張に不安がある。\n- Excel の ODBC 接続でデータ加工しており、Google スプレッドシートや GAS との連携に課題がある。\n- 現場運用を崩さずに、クラウド化・Web化・自動化できるかを確認したい。\n- 木村さん側で、課題と理想像がまだ詳細要件としては整理されていない。\n\n#### 仮説（tugilo視点）\n\n- **最初の提案テーマ:** 既存 Oracle をすぐ捨てるのではなく、現行 DB を活かした Web フロント／連携基盤から入ると、移行リスクを抑えやすい。\n- **価値の出しどころ:** サポート切れ・属人化・Excel加工の手間・Google連携の不安をまとめて「止まらない業務基盤」へ置き換える提案が刺さりやすい。\n- **進め方:** いきなり全刷新ではなく、課題一覧 → 現行構成確認 → 小さな改善案 → 段階移行案、の順が安全。\n\n#### アクションアイテム\n\n- **次廣:** Messenger で日程調整リンクを送付する。\n- **次廣:** ホームページ URL を Messenger で送付する。\n- **次廣:** 困っていること・相談したいことがあれば Messenger で共有する。\n- **木村さん:** システム改善の課題と要望を箇条書きで整理する（手書きラフ可）。\n- **次回:** 既存システムの構成、Oracle の利用範囲、Excel／ODBC の具体処理、Google スプレッドシート・GAS 連携の理想像を確認する。\n\n---\n\n### 【第2回】2026-05-29 実施済み（業務改善ヒアリング）\n\n#### 基本情報\n\n- **日時:** **2026-05-29（金）JST 14:00–15:00**\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 38`（**1セッション＝DB 1行**）\n- **目的:** 前回終盤に出た **業務改善・既存システム改善**について、現在の具体的な困りごとをヒアリングする。\n- **結果:** PDF注文書の手入力自動化を第一段階とし、既存 VB + Oracle を温存した社内 Web インターフェース案で提案書・簡易モック作成へ進む。\n\n#### 今日の進め方（次廣側メモ）\n\n最初から提案を押し出すのではなく、まず困りごとを聞く。そのうえで、Google Workspace / GAS で小さく試せる例を提示し、木村さんの現場に近いものがあるか確認する。\n\n**冒頭トーク案**\n\n> 前回、VB + Oracle の既存システムや、Excel で ODBC 接続して加工されている話を伺いました。  \n> 今日はまず、いま実際にどこで困っているかを教えていただきたいです。  \n> そのうえで、全部をいきなり作り替えるのではなく、Google Workspace や GAS を使って、今の運用を活かしたまま小さく効率化できる部分があるかもしれません。  \n> いくつか例を持ってきたので、近いものがあるか見ながらお話しできればと思っています。\n\n#### Google Workspace / GAS 活用例（話題提供）\n\n**1. Oracle / Excel の集計結果を Google スプレッドシートに自動反映**\n\n- **現状イメージ:** Excel で ODBC 接続し、手作業で加工・集計している。\n- **例:** 毎日・毎週決まったタイミングで CSV 出力 → Google スプレッドシートに取り込み → 集計表を自動更新。\n- **効果:** 確認用の表を毎回作り直さなくてよくなり、社内共有もしやすくなる。\n- **確認したいこと:** 今、Excel で毎回作っている表・一覧・集計は何か。\n\n**2. 案件・調査・製本工程の進捗管理表を Google スプレッドシート化**\n\n- **現状イメージ:** 案件・調査・製本工程の状態が、個別 Excel、口頭確認、担当者の記憶に散らばっている。\n- **例:** 案件ごとに「受付中／調査中／確認待ち／制作中／納品済み」などを一覧化。\n- **効果:** 誰が見ても、今どこで止まっているか分かる。\n- **確認したいこと:** 「あの案件どうなっている？」と確認が発生しやすい業務はどこか。\n\n**3. Google フォームで社内依頼・確認事項を受ける**\n\n- **現状イメージ:** メール、口頭、LINE、紙などで依頼や修正指示が散らばる。\n- **例:** 製本依頼、調査依頼、修正依頼、確認事項を Google フォーム入力にし、回答をスプレッドシートに蓄積。\n- **効果:** 依頼内容の抜け漏れを減らし、後から検索できる。\n- **確認したいこと:** 依頼内容が散らばって困っている業務はあるか。\n\n**4. GAS で期限・確認漏れを自動通知**\n\n- **現状イメージ:** 担当者が覚えている、または手作業で追いかけている。\n- **例:** 「3日以上未対応」「納期前日」「確認待ち」の案件をメールや Google Chat に通知。\n- **効果:** 催促・確認・抜け漏れチェックの手間を減らせる。\n- **確認したいこと:** 納期前・確認待ち・未対応で、毎回人が見に行っているものは何か。\n\n**5. 顧客ごとの Google Drive フォルダを自動作成**\n\n- **現状イメージ:** 資料の保存場所やファイル名が人によって違い、探す時間が発生する。\n- **例:** 新規案件登録時に、顧客名・案件番号付きフォルダを自動作成し、テンプレ資料も配置。\n- **効果:** 資料の置き場所が統一され、引き継ぎや確認が楽になる。\n- **確認したいこと:** 顧客資料・調査資料・成果物の保存ルールは統一されているか。\n\n**6. 家系図・ルーツ調査の調査メモ管理**\n\n- **現状イメージ:** 戸籍、文献、調査メモ、成果物、顧客対応履歴が分散しやすい。\n- **例:** 顧客ごとに調査ステータス、参照文献、確認事項、成果物リンクをまとめる。\n- **効果:** 過去案件を再利用しやすくなり、調査ノウハウが社内資産化する。\n- **確認したいこと:** 過去の調査記録・文献メモ・成果物テンプレを再利用できる状態になっているか。\n\n#### 今日の着地点\n\nGoogle Workspace / GAS で全部を解決するのではなく、次の3分類に整理する。\n\n1. **GASで小さく改善できるもの**\n2. **既存 Oracle を活かして連携した方がいいもの**\n3. **Web化・クラウド化まで考えた方がいいもの**\n\n**締めトーク案**\n\n> Google Workspace や GAS で全部を解決するというより、まずは「今の業務を変えずに、手作業・確認・転記を少し減らせる場所」を探すイメージです。  \n> 今日お聞きした内容から、GASで小さく改善できるもの、既存 Oracle を活かして連携した方がいいもの、Web化・クラウド化まで考えた方がいいものに分けて整理できればと思っています。\n\n#### 必ず聞く質問\n\n- 毎週・毎月、必ず手作業で作っている表や資料はありますか？\n- 「この人に聞かないと分からない」業務はどこですか？\n- Excel で ODBC 接続している処理のうち、特に手間が大きいものは何ですか？\n- Google スプレッドシートや GAS で、まず自動化したい作業を1つ選ぶなら何ですか？\n- 顧客資料・調査資料・成果物は、どこに、どのルールで保存されていますか？\n\n#### 実施後議事録（Zoom文字起こし要約ベース）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣が、BPS木村／株式会社国宝社の製本システムにおける業務効率化ニーズをヒアリング。\n- 木村さんは、三菱関連会社が開発した **VB + Oracle の基幹システム**を運用しており、PDF注文書の手入力が大きな負担になっていると共有。\n- 次廣は、既存 VB システムに直接手を加えず、新たな Web インターフェースを社内サーバー上に構築し、PDF注文書を解析して Oracle DB に登録する改善案を提示。\n- 数日以内に、次廣が **提案書と簡易モックを無償で作成**し、実現可能性と費用感を提示することで合意。\n\n**決定事項・合意内容**\n\n- **PDF自動入力の実現方針:** 既存 VB システムには手を加えず、新しい Web ベースの入力画面を作る。PDF注文書をアップロードし、解析結果を確認・修正してから Oracle DB に書き込む。\n- **システム構成:** 既存 Windows サーバーの **Hyper-V** 上に Linux ベースの Web サーバーを構築し、社内ネットワーク経由でアクセスできる構成を検討する。\n- **Google Workspace は今回は主軸にしない:** 外部アクセスやセキュリティリスクを考慮し、既存 VPN 環境を活かした **社内完結型**を優先する。\n- **段階的な実装:** 第一段階は最も負担の大きい **PDF入力自動化**。第二段階で日報などの Excel 帳票の Web化、多端末対応を検討する。\n- **得意先直接入力:** 将来的には得意先向けの直接入力システム提供も可能性として認識。ただし初期スコープには入れない。\n\n**現状の課題**\n\n- **手入力の負担:** 事務員が月間300〜400件（大口顧客のみ）、全体ではその倍近い件数の PDF 注文書を手作業で入力している。\n- **システム構成:** 三菱関連会社が開発した VB + Oracle の基幹システムが稼働中。\n- **データ構造:** ヘッダーとフッターが 1:N の関係。本のパーツごと（表紙、本文、カバー等）に銘柄やメーカーを選択する必要がある。\n- **注文書フォーマット:** 出版社ごとに注文書フォーマットが異なる。PC作成データだけでなく、手書きのものも存在する。\n- **既存改善:** ODBC 経由で Oracle からデータを読み出し、日報作成・分析・伝票出力に活用している。\n\n**提案された解決策**\n\n- **PDF自動入力システム:** 大口顧客の PC 作成 PDF 注文書から優先的に自動化する。手書きは初期対象外または後回し。\n- **入力画面:** ブラウザ上で PDF をドラッグ&ドロップし、解析結果を画面上で確認・修正してから登録する。\n- **DB連携:** Oracle のテーブル定義書を参照し、キー項目、英字項目名、画面項目との対応、シーケンス番号、トリガーに配慮した書き込みロジックを設計する。\n- **サーバー環境:** Windows サーバー上の Hyper-V に Linux Web サーバーを立てる。PC やスマートフォンから社内 Wi-Fi 経由でアクセス可能にする。\n- **セキュリティ:** 外部インターネット公開は行わず、外部からは既存 VPN を利用する。新規外部回線は不要。\n- **参考事例:** 次廣が別顧客向けに進めている VB + SQL Server 環境から Web ベースへ移行する案件と同様の考え方で進められる。\n\n**確認待ち事項**\n\n- **データベース定義書:** テーブル構造、キー項目、英字項目名と画面項目の対応関係。\n- **サンプルPDF:** 注文書フォーマットの実例。機密情報はマスクまたは非公開扱いでよい。\n- **DB書き込み権限:** ODBC 経由で書き込み設定が可能か、または別接続方式が必要か。\n- **VBシステム保守体制:** 三菱関連会社への相談状況、既存システムの保守・改修方針。\n\n**アクションアイテム**\n\n- **次廣:** 数日以内に提案書と簡易モックを作成し、実現可能性と費用感を提示する（無償対応）。\n- **木村さん:** データベース定義書とサンプル PDF を次廣へ共有する。\n- **次廣:** 1to1後のアンケートに回答し、リファラル機会を探る。\n\n**BNI活動・パワーチーム知見**\n\n- 木村さんは 1to1 を **週8件**目標、1件につき1リファラル創出を目標にしている。最大で1日8〜10件行うこともある。\n- 週次計画表で家族時間、トレーニング、商談、BNI活動を色分け管理。2034年のゴールから逆算して、年・月・週に落とし込んでいる。\n- 1to1後に Google フォームで興味分野をチェックしてもらい、リファラルにつなげる運用をしている。\n- パワーチーム構想として、創業30年以上の老舗企業向けに、理念整理、ホームページ、システム改善を一体で提供する **第二創業支援**が話題になった。\n- 次廣側は、1to1やブレイクアウトルームの会話を Markdown で記録し、AIで紹介先を提案する仕組みを自作していると共有。\n\n**技術・AI活用に関する議論**\n\n- 社員が個人レベルで ChatGPT 等へ機密情報を投げる **シャドーAI問題**への懸念を共有。\n- 日本企業は今後1〜2年で AI 利用ガイドライン整備が必要になる、という見立て。\n- AI の普及により非技術者でも技術者風の発言ができる一方、実装後のトラブル増加が懸念される。\n- 補助金を引き出すことが目的化したグレーなシステム提案は断った経験を次廣が共有。信頼できる技術パートナーの見極めが重要。\n\n**交換されたフィードバック**\n\n- **木村さん → 次廣:** YouTube や SNS での話し方のテンポ、人を引き込む表現力、技術的理解の深さ、DB構造を把握している点への安心感。\n- **次廣 → 木村さん:** 家系が政治家や教師という背景による話術の資質、時間管理と BNI 活動の計画性、1to1からリファラルを生むアンケート活用への評価。\n\n**次回予定**\n\n- 次廣が提案書と簡易モックを提示した後、具体的な実装範囲と費用について協議する。\n- 引き続き 1to1 を通じて、BNI活動の知見交換と相互支援を継続する。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 木村さんは、既存の製本業を守りながら、家系図・ルーツ調査という新規事業を伸ばしている。\n- 家系図サービスは、単なる調査商品ではなく、経営者・事業承継者の **自己理解・原点発見・ストーリー化**に価値がある。\n- YouTube 登録者数 7,830人まで伸ばしており、家系図領域での認知拡大に本気度がある。\n- 既存システム改善は、単なる IT 相談ではなく、国宝社の基幹業務・新規事業拡張・今後のデータ活用に関わる可能性がある。\n- 次廣側の強みは、既存業務を壊さず、段階的にシステム化すること。木村さんの課題と相性が良い。\n- 第2回で、抽象的なクラウド移行相談から **PDF注文書の手入力自動化**という具体課題に絞り込まれた。\n- Google Workspace / GAS よりも、現時点では **社内ネットワーク内の Web インターフェース + Oracle 直接連携**が優先度高い。\n- 木村さんは BNI 活動を計画的に運用しており、1to1 → アンケート → リファラル創出の仕組み化が進んでいる。tugilo の BNI 運用にも学びが大きい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **初回提案の軸:** 「Oracle を捨てる／全部作り直す」ではなく、現状を活かした段階移行を前提にする。\n- **第2回後の最優先提案:** PDF注文書の自動入力。既存 VB は温存し、社内 Web 画面から PDF 解析・確認・Oracle 登録を行う。\n- **ヒアリングで見る点:** 業務フロー、既存 VB 画面、Oracle テーブル、Excel ODBC の使い方、Google スプレッドシート／GAS でやりたい自動化、社内利用者数、保守担当の有無。\n- **提案パターン:** \n  - 現行システム延命＋データ連携\n  - Web フロント追加\n  - クラウド移行\n  - Google スプレッドシート／GAS 連携\n  - 段階的リプレイス\n- **直近成果物:** 数日以内に、提案書と簡易モックを無償で作成する。モックは PDF ドラッグ&ドロップ → 解析結果確認 → 修正 → 登録、の流れが見えるものにする。\n- **価格感:** 過去実績として、FC管理システム 120万〜180万円、在庫管理・日報 Web化 約200万円の事例を参考に、スコープ別に小さく切る。\n- **注意:** 既存システムは業務の心臓部である可能性が高い。まずは調査・整理フェーズを明確にし、いきなり実装確約しない。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣が木村さんに紹介してほしい相手\n\n- 士業（補助金・助成金関連で協業できる方）\n- 業務改善コンサルタント\n- Excel・ファイル管理で限界を感じている企業\n- 複数ファイルで同じ内容を重複入力している企業\n- 特定の人がいないと業務が回らない企業\n\n**紹介文たたき台（次廣向け）**\n\n> Excel や古い業務システムで何とか回しているけれど、入力の重複や属人化で限界を感じている会社さんがいたら、現場の流れを大きく変えずに小さく業務システム化できる次廣さんをご紹介できます。\n\n### 木村さんに紹介できそうな相手\n\n- 珍しい名字の人、家系に興味がある人\n- 経営者・事業承継者\n- 自分のルーツや、頑張る理由を知りたい人\n- 1to1で送付する資料がない人、ライフストーリー作成に関心がある人\n\n**紹介文たたき台（木村さん向け）**\n\n> 木村さんは、戸籍と文献調査をもとに家系図や先祖のルーツを整理されている方です。経営者や事業承継者で、自分の原点や強み、事業を続ける理由を言語化したい方には特に合いそうです。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 木村さんは、創業160年企業の事業承継・V字回復・新規事業展開を経験しており、経営者としてのストーリーが強い。\n- 家系図・ルーツ調査は、次廣の珍しい名字（静岡県浜松市西部にしかない、静岡県全体で約20人）とも会話の接点がある。\n- 次廣の家族構成（妻、娘2人、猫4匹）や、36歳で結婚後にキャンプ・旅行を家族で楽しむようになった話も共有済み。\n- 木村さんも中学3年生と小学5年生の子どもがおり、受験対応中。\n- 次回はシステム改善の商談色が強くなる可能性が高い。まずは「聞く」「整理する」「段階提案する」の順で進める。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(23,1,37,100,NULL,'85344850132','jYUX4zxRQLS/2d24XbPJHg==','manual',NULL,'2026-05-13 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_ito_takao_phoenix_jsp.md】\n\n# 1to1_伊藤隆夫_フェニックス人事労務\n\n---\n\n**文書の位置づけ:** 同一人物との 1to1 を **1ファイルで時系列管理**する。相手の G.A.I.N.S.（PDF・2026-04-21 更新）および略歴シート（2026-02-12 作成）を固定情報に統合。**初回はクロスチャプター**（紹介元：大人なじみ・飯塚さん）。  \n**整理:** tugilo（次廣 淳）の接点チャプター: **BNI DragonFly**。  \n**紹介経緯（事実）:** 飯塚さんとの 1to1 で「**社労士・士業、および補助金コンサルのような方と、次廣が協業できる可能性がある**」と伝えたところ、伊藤さんを紹介いただいた。  \n**事実と仮説:** 「抽出された課題」は**会話で言及された事実**中心。「仮説（tugilo視点）」は**解釈・構造づけ**（根拠を併記）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※相手提出の **G.A.I.N.S.ワークシート**・**メンバー略歴シート**ベース。Web・名簿の改定があったら本節のみ更新する。\n\n- **名前:** 伊藤隆夫\n- **チャプター（BNI）:** 東京 MS リージョン・**大人なじみ**\n- **カテゴリー:** 就業規則専門社会保険労務士\n- **事業名:** フェニックス人事労務サポートオフィス、**株式会社フェニックスミッション**（研修・コンサル・習慣伴走等）\n- **所在地（事務所）:** 東京都武蔵野市中町 1 丁目 15-8 メゾン・ド・武蔵野 206\n- **居住:** 東京都府中市（約 20 年）\n- **出身:** 秋田県大館市\n- **経験:** 独立・開業から 2026年4月で **10 周年**（社労士として 10 年目）\n- **前職:** 食品製造（現 Maruha Nichiro 系）**27 年** — 工場、商品開発、生産管理、ISO・環境・労働安全衛生 等。組合中央執行委員長（在籍のまま 1 年半）等の経験\n- **URL（価格表含む）:** https://phoenix-jsp.com/price.html\n- **補足役割:** 一般社団法人ひとり親支援協会 **理事**。デキる人材育成協会・公式 LINE 等\n\n**事業の柱（略歴より）**\n\n- 就業規則、労務相談、各種手続、給与、**助成金申請代行**（5年で申請代行金額 **約1億円**規模と記載）、研修、労働安全衛生、リーダーシップ研修 等\n- **東洋哲学に基づく** 就業規則・退職金規程・**出張**旅費規程コンサル\n- 「習慣力サポーター」として天命実践の伴走、メルマガ（平日）配信\n\n**Goals（相手が掲げる短期〜長期の要約）**\n\n- 短期：株式会社・社労士事務所の軌道、ひとり親スタッフ雇用で働きやすい職場、労安系講習事業、ウィスラー合宿型スキーコミュニティ（2027-02-07〜）等\n- 中期以降：ひとり親支援施設、後継者・自立型人材・著書累計部数、会長職、**80歳で氷河スキー** 等\n\n**Interests:** スキー、テニス、読書、料理、断捨離、成功哲学、タイムマネジメント、ひとり親支援、人材教育、陽明学、商業出版 など\n\n**Networks:** 社労士・税理士・司法書士・弁護士・コーチ・カウンセラー・コンサル、食品会社関係、医療・建設・製造の顧問先社長層、セミナー仲間\n\n**自己開示（略歴シート「誰も知らない私」）:** 氷河スキー目標のため、片道 **11 km ママチャリ通勤**（三鷹方面）、加重トレ等 — **本人が話題にしたときに**追認する程度が無難。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-05-13 時点で **Zoom 文字起こし要約**を本ファイルに反映。**開始・終了の正式日時は要約に無い**ため `first_session_*` は **カレンダー／録画メタで確定後に YAML・【第1回】へ追記**）。\n- **主な成果（要約ベース）:** 次廣（DragonFly）と伊藤氏（大人なじみ）が **大人なじみ・飯塚氏の紹介** で初対面（実施は **Zoom** とみなす）。**相互に事業を共有**。次廣より **補助金・助成金申請に絡むシステム導入支援での協業** を提案。伊藤氏は **業務改善助成金（9月受付開始想定）** を活用した **自社の業務効率化** に関心。**次アクション:** 次廣が **ローカル LLM（自前サーバー等）方式の提案書** を作成し、再ミーティング。伊藤氏側は **多摩でスキー・スノボする人** がいれば紹介希望（**80歳で兵庫の斜面を滑りたい**という目標 が要約にあり／略歴シートでは氷河スキー — **本人確認推奨**）。\n- **保留・探索:** 「ひとり親支援コミュニティ」と **DragonFly プレジデント（千葉・シングルマザー支援に関わる方／氏名要約なし）** の接点確認が話題に。**要約表記「一人親営業協会」** は **一般社団法人ひとり親支援協会** の聞き違いの可能性大。\n- **進行（事前想定どおりだったか）:** **前半・後半でお互い事業紹介〜質疑** が各約30分前後、という打合せ意図は台本どおり。**第1回後も、2回目以降・他相手向けに台本セクションはテンプレとして温存。**\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n**運用メモ:** **第1回は実施済み**（上記サマリー・【第1回】参照）。以下は **2回目以降／別セッション** に再利用できるたたき台。\n\n**進行イメージ:** **お互い「事業紹介 → 質疑応答」がだいたい各30分** くらいのゾーンになる想定。  \n**時間の配り方（目安）:**\n\n| パート | 内容 | 目安 |\n|--------|------|------|\n| オープニング | あいさつ・飯塚さん経由・今日の進め方の合意 | **約3分** |\n| **前半** | **伊藤さん**の事業紹介 → **こちらからの質問・ディスカッション** | **約30分** |\n| **後半** | **こちら**の事業紹介 → **伊藤さんからの質問・ディスカッション**（必要なら協業・紹介はこのブロック後半に挟む） | **約30分** |\n| クロージング | 次のアクション・TY | **約2〜5分** |\n\n- **合計が60分の枠**なら、オープン／締めを短くして、前半・後半を **各25〜27分** に寄せる。**90分**ならそのまま各30分＋余裕。\n\n**進め方の合意（オープンで一言足すと安心）**\n\n> 「今日は **前半で伊藤さんの御事業を紹介いただき、質問させてください。後半は僕のほうを逆にお話しして、伊藤さんからも聞かせてください** ——という形で進めてもよいですか？」\n\n### 1. オープニング（信頼の橋）\n\n> 「今日はお時間ありがとうございます。BNI DragonFly の次廣です。  \n> **大人なじみの飯塚さん**から、伊藤さんをご紹介いただきました。  \n> 飯塚さんとの 1to1 で、**社労士の先生や士業の方、補助金周りのコンサルと、僕のほうで協業の可能性がある**という話をしていたときに、『ぜひ伊藤さんと』とつないでくださいまして。本当にありがたいです。  \n> 初回は **お互いの事業を紹介しながら、質問を挟んで理解を深められたら** と思っています。よろしくお願いします。」\n\n→ 続けて **上記「進め方の合意」** を読む。  \n**（オンラインなら）** 途中抜け・ミュート・録画の希望があればこのタイミングで一言。\n\n### 2. 前半：伊藤さんの事業紹介〜質疑応答（目安30分）\n\n**こちらの立ち位置:** まず **話を聞く**。紹介が一段落したら **「ここまでで一言いいですか？」** で質問を挟む。\n\n※質問は**この順で畳みかけず**、相手の話の自然な区切りで 1 問ずつ。\n\n**紹介のあとに投げやすい広い質問**\n\n> 「いま、**伊藤さんにとって事業の中心はどこ** に置いていらっしゃいますか？社労士業務と株式会社の研修・コンサル、助成金、ひとり親支援——比率や体感的な重みでいうと。」\n\n**深掘り・質疑応答のネタ（必要なぶんだけ）**\n\n- 「**就業規則を専門** と掲げられているので、その強みで **最後まで手が離れない案件** はどんなパターンですか？」\n- 「**助成金申請代行** は、クライアントにとってどんなときに真価が出ますか？（僕のクライアントに士業がいるときの言い方の参考にしたくて）」\n- 「**ひとり親支援協会の理事** と、御社の事業を、今後どう結びつけたいですか？」\n- 「**理想的な紹介** —— こういう経営者・こういう局面の人、と言語化すると？」\n- 「逆に **DragonFly や僕のクライアント** に、伊藤さんから見て有益そうな紹介はどんな方ですか？」\n\n**趣味・スキー等が話題になったら**\n\n> 「G.A.I.N.S.にウィスラーのプロジェクトがあって。スキーは **ご自身のリフレッシュ** 寄りですか、それとも **コミュニティづくり** がメインですか？」\n\n（踏み込みすぎない。**相手が振ったら** 畳みかけない。）\n\n### 3. 後半：こちらの事業紹介〜質疑応答（目安30分）\n\n**紹介のたたき（そのままか、メインプレの骨格で5〜10分→質疑へ）**\n\n> 「僕は **tugilo** という屋号で、業務のデータが Excel やバラバラなツールに散らばって属人化しているところを、**小さく始めて現場に合わせて** システム化する仕事をしています。  \n> LINE 起点の問い合わせ〜請求、スタンプラリー、現場日報など、**士業やコンサルの先生方の顧問先で起きがちな『運用が回らない』** ところを一緒に整えることが多いです。  \n> 飯塚さんにもお話しした通り、**社労士先生や士業の方、補助金に詳しいコンサルと**、僕の実装力を組み合わせてクライアントに渡せる形があると思っています。  \n> **Religo** という、会のつながりを見える化して紹介の精度を上げるプロダクトも DragonFly で回していて、その文脈でもお話しできます。」\n\n→ 続けて **「ここまでの御説明で、気になる点や突っ込みたいところがあれば何でもどうぞ」** と開く。\n\n※**60 秒版・5 分版**の詳細は [ライブドキュメント](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) や [メインプレ](../../academy/キースキルズ/メインプレゼン/BNI_KeySkills_MainPresentation_5min_Tsugihiro_202604.md) に合わせて調整。\n\n### 4. 後半の終わり頃：協業の一言（飛ばしすぎない）\n\n※時間が押していたら **質疑のなかに溶かす** でよい。\n\n> 「たとえば、**助成金・労務の申請や手続のフロー** がクライアントで属人化しているときに、**申請のチェックリストや進捗の見える化** を一緒に作る、といった形はありそうだなと勝手に想像していました。  \n> 伊藤さんから見て **『こういう接続はあり／なし』**、忌違いがあれば教えてください。」\n\n### 5. ギバーズ（紹介の聞き方・時間が残る場合）\n\n> 「いま **紹介したい人は一人いますか？** 逆に、僕のほうから **士業・補助金・現場の運用で困っている経営者** をお繋ぎできるようにしておきたいのですが、伊藤さんの **Top 3 のターゲット** をもう一度教えていただけますか？」\n\n### 6. クロージング\n\n> 「今日お聞きしたことはこのファイルに整理して、次につなげます。**次回** は ○○ 週以内に、**対面／Zoom** どちらがやりやすいですか？  \n> 飯塚さんにも、ごきげんようの一言お伝えします。ありがとうございました。」\n\n**実施直後に自分メモ:** 次のアクションを **1行で** カレンダー登録（相手・自分・期限）。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】実施済み（日時は要約未記載 → TODO）\n\n#### 基本情報\n\n- **日時:** **TODO（曜）JST TODO–TODO**（開始・終了まで。**取得元:** カレンダー／Zoom 録画。文字起こし要約には **日時なし**・2026-05-13 に文書反映）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 23`（**1セッション＝DB 1行**。正式日時は TODO のため `scheduled_at = null`）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣（**静岡**・システムエンジニア／独立 **3年目**、**SE 歴 25〜26年**、**AI 活用 約3年**［ChatGPT 登場前後から］）と、伊藤（**東京**・社労士）が、**大人なじみ・飯塚氏の紹介**を通じて **初めて対面**（※チャプターは次廣＝DragonFly、伊藤＝大人なじみ、飯塚氏＝大人なじみ）。\n- お互いの事業を共有。**補助金・助成金申請時のシステム導入支援**での協業可能性を次廣から提案。伊藤氏は **業務改善助成金（9月受付開始）** を使った **自社の業務効率化** に関心。\n\n**次廣側（要約）**\n\n- **専門:** B2B 業務システム・現状は **Web 案件中心**。\n- **AI:** 開発工程の効率 **約9割改善**、「ほぼコーディング不要」に近い運用などと説明。\n- **姿勢:** 既製ツール押し付けではなく **現場フローに合わせゼロから設計**、**伴走・保守改善**。\n- **実績例（要約）:** FC 本部（Googleフォーム・Excel→統合 Web、**120万→最終180万**）、解体業 **LINE 問い合わせ〜請求**、静岡中部 **スタンプラリー4年連続**、防水工事 **外国人向け LINE 日報・材料費・進捗見える化**。\n- **協業イメージ:** **IT導入補助金・業務改善助成金**を絡める案件で、申請はコンサル、開発は次廣 — **過去に同型の協業実績あり**（要約どおり）。\n\n**伊藤側（要約・プロフィールと整合する点）**\n\n- **食品会社 27年** → **2016 社労士独立**（**47歳**、人事総務経験なしから、という文脈）。\n- **シングルファーザー**として育児と並行し **約4年で社労士**、その後 **約2年半で資格10個以上**。\n- **強み:** **東洋哲学（陽明学）ベースの就業規則**、**出張旅費規定を活用した社保コスト対策**、**一人法人向け** 等。\n- **助成金:** **開業5年で約1億円規模を扱う**（要約表現）。\n\n**課題・ツール検討（伊藤側）**\n\n- **Excel** 中心で **進捗確認が煩雑**、**入力が分散**。\n- **Notion**（kintone の安価代案として）、**Lark**（自由度・コスパ）を **複数回ヒアリング済み** と言及。\n\n**次廣アプローチの評価（伊藤側・要約）**\n\n- Notion／Larkは **利用者が業務をツールに合わせる** 側面があるのに対し、次廣は **業務整理からヒアリングし、必要な部分だけ提供**、**既存ワークフローを無理に変えず現場負担を増やさない** 点を **評価**。\n\n**技術トピック（要約）**\n\n- **開発支援:** ChatGPT、**Cursor**（複数モデル）でコード生成効率化。\n- **システム組込みAI:** 受注票（Excel/PDF）の **AI解析・データ化**（フォーマット固定なら AI 不要になりうる）。\n- **課金:** AI 組込み時 **トークン従量**。**数百人規模**ではコスト爆増しうる → **利用範囲の設計**が重要。\n- **セキュリティ:** 外部 AI への **個人情報送信リスク**。**マイナンバー** オンライン管理の規制緩和動向に注意。\n- **対策案:** **Mac mini 等の自前サーバー + ローカル LLM** で外部送信を抑える。\n- **Claude Code:** ローカル PC 上のファイル探索・PDF 解析に触れた、という要約。\n\n**応用アイデア（会話上）**\n\n- 伊藤氏の **過去データを資産化**し、**条件入力で就業規則ドラフトを出す**仕組みは **構築可能**という方向の話。\n- **前提:** **個人情報の取り扱いルール**を事前に決める必要。\n\n**制度・補助金（要約）**\n\n- **IT導入補助金:** 現状 **審査厳しめ**。\n- **業務改善助成金:** **9月受付開始** に向け伊藤氏が準備 — **次廣のカスタム開発はパッケージではない**ため **IT導入補助の対象になりにくい**、という **課題認識**（要約）。\n\n**労務・AI 一般論**\n\n- **AI で作業短縮**しても **時間ベース評価**だと **給与が下がる懸念**。**定型はAI、創造的業務へシフト** 等の議論。\n\n**次のステップ（合意・要約）**\n\n- 次廣: **ローカル LLM 方式の提案書**を作成 → **再調整して再ミーティング**。\n- 伊藤: **多摩でスキー・スノボする人**がいれば紹介（**80歳で兵庫の斜面**という目標、要約）。\n- **探索:** ひとり親支援まわりで、**DragonFly プレジデント（千葉・シングルマザー支援）** と伊藤氏側コミュニティの **接点確認**（要約。**協会名は「一人親営業協会」と要約されているが、伊藤氏の固定情報では一般社団法人ひとり親支援協会** — 要本人確認）。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 伊藤事務所の **Excel 分散・進捗管理の負荷**。\n- **業務改善助成金**で **自社業務の効率化** を進めたい（9月受付）。\n- **IT導入補助金**は審査厳しさ、**カスタム開発の「パッケージでない」ゆえの枠取りの難しさ**（要約）。\n- **AI・個人情報**（外部API vs ローカルLLM、マイナンバー動向）。\n- **人事評価制度とAI効率化**のすり合わせ（理念レベルの話題）。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** Notion/Lark 調査済みでも **「事務所オペの全体最適」まで到達していない**。**根拠:** Excel分散・進捗煩雑の本人発言。**仮説:** ツール比較フェーズから **業務設計＋軽量カスタム** に移るタイミング。\n- **課題②:** **助成金の枠**と **ソリューションの型**（パッケージ vs 開発）の **ミスマッチ**。**根拠:** IT導入補助の対象になりにくいという会話。**仮説:** 業務改善助成金の **ストーリー設計**を第2回で具体化しないと提案書が空振りしうる。\n- **シナジー:** **社労士のレギュレーション知見 × データ資産化（就業規則テンプレ＋条件分岐）**は差別化になりうる。**根拠:** 会話上の「条件入力で規程作成」案。**リスク:** **個人情報ガバナンス**が先。\n- **紹介:** **スキー共同体**（多摩）と **ひとり親ネットワーク** は関係維持の **非営業的接点**。**根拠:** 要約の次ステップ。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **紹介の質:** 飯塚経由で **「補助金×開発」の文脈が最初から共有**されており、**初回から協業・制度の話に入れた**。\n- **相手ニーズ:** **自社の事務所オペ改善**が具体（Excel・分散入力）。**業務改善助成金**は **本人の関心と時期（9月）が一致**。\n- **競合認知:** **Notion・Lark は「比較対象」**。次廣の価値は **業務適合型・現場負荷を上げない** と **本人が言語化**（要約）。\n- **次回までの宿題（次廣）:** **ローカル LLM 提案書**が **信頼の物的証拠**。**助成金のどのストーリーに載せるか**はセットで詰めるとよい。\n- **要確認:** スキー目標の **場所（兵庫 vs 略歴の氷河）**、**ひとり親側団体名**の要約ズレ。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **第1回後:** 「士業・補助金 × 開発」の **仮説は共有済み**。第2回は **業務改善助成金の申請ライン・自社業務のBefore/After** を数字かフローで1枚にするよう **伊藤さんに依頼**してもよい（相手の準備負担と天秤）。\n- **提案書:** **ローカル LLM（Mac mini 等）**は **セキュリティ懸念への回答**。**トークン従量の恐怖**とセットで **「何をローカル／何をクラウドにしないか」** を図示。\n- **差別化:** Notion/Lark は **自己実装コスト**。**「使う部分だけ・現場フロー維持」** は第2回でも繰り返し **一言で要約**できるようにしておく。\n- **制度:** **IT導入補助の厳しさ**と **カスタム開発**の関係は **誠実に**（過剰約束をしない）。**業務改善助成金**側の **文言・例**は社労士本人・補助コンサルと **整合を取る**前提。\n- **Religo / ひとり親:** **プレジデント経由の接点**は **第2回か別レーン**でフォロー。**氏名・団体名は確定してから** メモ更新。\n- **技術は従:** 就業規則自動生成は **個人情報ポリシー合意**が先。**デモより紙（同意範囲・保持データ）**でもよい。\n\n---\n\n## ■ 今後のTodo（次廣）\n\n### 最優先\n\n- [ ] **ローカル LLM 提案書を作成する。** 目的は「外部 AI に個人情報・機密情報を出さず、社労士事務所内の文書・規程・PDF を安全に検索／要約／ドラフト化できる」ことを伝える。構成は **現状課題 → リスク → ローカル構成 → できること → できないこと → 概算 → 次回ヒアリング項目**。\n- [ ] **業務改善助成金に載せる前提を整理する。** 提案書とは別に、伊藤事務所の **Before/After** を1枚で仮置きする。Before: Excel 分散、進捗確認が煩雑、入力箇所が多い。After: 案件・顧客・規程作成・進捗・期限・ファイルを一元化、確認時間を削減。\n- [ ] **第2回ミーティングを打診する。** 提案書のドラフトができたら、「業務改善助成金の対象にできるか、伊藤先生の視点で見ていただきたい」として 30〜60分で再調整。\n\n### 提案書に入れる論点\n\n- [ ] **Notion / Lark との違いを1枚で整理する。** Notion / Lark = 業務をツールに合わせる・自力構築が必要。tugilo = 業務整理から入り、必要な部分だけを現場フローに合わせて作る。\n- [ ] **AI利用範囲を分ける。** 例: ①フォーマット固定なら AI 不要 ②PDF・Excel読取は AI 補助 ③就業規則ドラフトは過去資産＋条件分岐＋人の確認 ④個人情報・マイナンバー系はローカル／扱わない等。\n- [ ] **クラウドAIとローカルLLMの使い分けを図示する。** クラウド = 汎用・低初期費用・情報持ち出し注意。ローカル = 初期構築あり・情報を外に出しにくい・モデル性能や運用保守に注意。\n- [ ] **費用の考え方を粗く置く。** Mac mini 等の機材、初期構築、保守、AIモデル更新、クラウドAI利用時の従量課金を分ける。金額は未確定なら「要見積」と明記。\n\n### 次回ヒアリングで確認すること\n\n- [ ] **伊藤事務所の現在の業務フローを聞く。** 顧客管理、案件管理、助成金、就業規則作成、期限管理、ファイル保管、進捗確認の流れ。\n- [ ] **最初に改善したい1業務を絞る。** いきなり全部ではなく、業務改善助成金に載せやすく、効果が見えやすい1領域を選ぶ。\n- [ ] **扱うデータの種類を確認する。** 個人情報、給与、マイナンバー、就業規則、顧問先情報、PDF、Excel、メール、LINE 等。**外部AIに投げてよい／不可**の境界を確認。\n- [ ] **助成金上の要件を伊藤氏に確認する。** 何が対象になりやすいか、カスタム開発・機材・ソフト・研修・保守の扱い、9月受付に向けた逆算。\n\n### 紹介・関係構築\n\n- [ ] **飯塚さんへTYを返す。** 「伊藤先生と初回 1to1 実施、業務改善助成金・社労士事務所DXで次回提案予定」と簡潔に報告。**紹介直後の信頼維持として優先度高。**\n  - **送信用たたき台:**  \n    「飯塚さん、伊藤隆夫先生をご紹介いただきありがとうございました。本日初回の1to1をさせていただき、社労士事務所の業務効率化や業務改善助成金、ローカルAI活用の可能性について具体的にお話しできました。次回、私のほうで提案書をまとめて再度お時間をいただく流れになりそうです。貴重なご縁をつないでいただき、ありがとうございました。」\n- [ ] **DragonFly プレジデントとの接点を確認する。** 千葉のシングルマザー支援コミュニティと、伊藤氏の **一般社団法人ひとり親支援協会** が接続できるか確認。協会名・相手氏名はファクトチェックしてから動く。\n- [ ] **多摩エリアのスキー・スノボ人脈を探す。** 紹介できそうな人がいれば、競技レベル・居住エリア・紹介可否を確認してから伊藤氏へ。\n\n### 記録・整備\n\n- [ ] **第1回の正式日時を確定する。** カレンダー／Zoom メタから `first_session_date` / `first_session_time_jst` と【第1回】基本情報を更新。\n- [ ] **スキー目標の表記を本人確認する。** 要約では「兵庫の斜面」、略歴では「氷河スキー」。次回以降は本人の言い方に合わせる。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n**tugilo → 伊藤さんへ（想定）**\n\n- 助成金・就業規則・労務トラブル前後の **製造・建設・中小サービス** の経営者・人事担当\n- **ひとり親雇用・多様な雇用** を検討している会社\n- 独立系コンサル・コーチのクライアントで **働き方制度を固めたい** 経営者\n- **第1回で話題:** **多摩エリアでスキー・スノボ**する人材・コミュニティ（伊藤氏の紹介リクエスト。**目標斜面は要約では兵庫／略歴では氷河** — **本人に合わせる**）\n\n**伊藤さん → tugilo へ（確認したいこと）**\n\n- 顧問先で **Excel・LINE・属人オペ** が限界、と社労士が感じる局面の言語化\n- **補助金コンサル・税理士** との三角で、システム化ニーズが出るパターン\n\n**クロスチャプター・コミュニティ**\n\n- **ひとり親支援まわり:** DragonFly **プレジデント（千葉・シングルマザー支援）** と伊藤氏側の接続は **要約で保留**。**協会名・氏名のファクトチェック後** に TY または二者面談を検討。\n- **Messenger接続の流れ:** 2人の了承が取れたら、Messengerでグループを作成し、次廣から **それぞれの紹介を簡潔に投稿**する。紹介文は「なぜ繋ぐか」「相手の強み」「話してほしい接点」を短く置き、以降は2人が会話しやすい余白を残す。\n\n**Messenger紹介文たたき台**\n\n> 伊藤さん、〇〇さん、こちらでお繋ぎします。  \n>  \n> 伊藤さんは、東京MSリージョン・大人なじみチャプターの社会保険労務士で、就業規則や助成金、ひとり親支援にも力を入れていらっしゃいます。  \n>  \n> 〇〇さんは、DragonFlyでご一緒している方で、千葉でシングルマザー支援／ひとり親支援に関わる活動をされています。  \n>  \n> お二人とも「ひとり親の方が仕事や生活を前向きに整えていく支援」という接点があると思い、お繋ぎしました。  \n> まずは簡単な情報交換からしていただけたら嬉しいです。よろしくお願いします。\n\n**クロスチャプター運用（BNI）**\n\n- 大人なじみ・飯塚さんへの **TY（Thank You）** を忘れない。必要なら **二者面談** や二次紹介の打診は伊藤さんとの信頼形成後。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **略歴のトーン:** チャレンジ・天命・「諦めない」が軸。**プラス・高エネルギー** の対話が合いそう。\n- **距離感:** 初回から理念を深掘りしすぎず、**商いと紹介の現実ライン** を尊重。\n- **注意:** 家族・死別等は **相手から出た話題に限定**。こちらから積極的に触れない。\n- **第1回（要約ベース）:** **ツール比較に踏み込んだ質問**あり。**対話の誠実さ**は評価されつつ、**制度・セキュリティは慎重**。**次回は提案書で真剣さを示して信頼を固める**とよさそう。\n\n---\n\n**参照:** G.A.I.N.S. 略歴シート（大人なじみ・伊藤隆夫・PDF、2026-04 入手）。**第1回:** Zoom 文字起こし要約（2026-05-13 文書反映）。**正式日時**はカレンダー等で確定後、YAML・【第1回】を更新する。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(24,1,37,101,NULL,'82280318209','qCJSEwAqQLCYSQDmSPCceQ==','manual','2026-05-14 10:00:00','2026-05-14 10:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_isobe_masayuki_nestle_detective.md】\n\n# 1to1_礒部昌之_ネスレ探偵事務所\n\n---\n\n**文書の位置づけ:** レブリー（reverie）チャプター・礒部昌之さんとの 1to1 を **1ファイルで時系列管理**する。相手プロフィール画像・G.A.I.N.S.・略歴シート情報を固定情報に統合し、Zoom 文字起こし要約を時系列で追記する。  \n**整理:** tugilo（次廣 淳）の接点チャプター: **BNI DragonFly**。  \n**日時:** 2026-05-14 第1回実施済み。開始・終了時刻は **TODO**（カレンダー等で確定後に YAML と【第1回】へ反映）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供のプロフィール画像・G.A.I.N.S.・略歴シートベース。Web・名簿の改定があったら本節のみ更新する。\n\n- **名前:** 礒部昌之（いそべ まさゆき / Masayuki Isobe）\n- **チャプター（BNI）:** レブリー（reverie）\n- **カテゴリー:** 探偵 / detective\n- **事業名:** ネスレ探偵事務所\n- **役職:** 代表\n- **所在地:** 東京都品川区上大崎 2-11-3 パインハイツめぐろ303\n- **電話:** 0120-687-715\n- **メール:** mail@nestle-d.com\n- **Web:** https://nestle-d.com/\n- **BNI役職:** メンバーシップ委員\n- **入会日:** 2024-12-26\n- **ビジネス経験:** 探偵業 15年。過去職は人材派遣会社取締役、サービス業運営会社管理職。\n- **会話上の補足:** 日系金融機関子会社で経理・営業を経験後、学生時代の知人（探偵歴20年超）の紹介で探偵業へ。従業員は雇わず、フリーランス調査員と協力する形態。\n- **要確認:** Zoom 要約では屋号が **「レムリ（フランス語で夢）」** とされている。プロフィール画像上の「ネスレ探偵事務所」との整合は本人または名刺で確認する。\n\n**主な業務領域**\n\n- 従業員の素行調査（不正・サボり等の証拠撮影）\n- 配偶者の浮気調査、浮気相手の特定（名前・住所）\n- 人探し、所在確認、公示送達のための居住確認\n- 結婚前調査、盗聴器・盗撮器発見調査\n\n**強み・実績**\n\n- 15年間、調査内容や調査料金についてお客様とトラブルになったことが一度もない。\n- 受注件数は個人から約830件、法人から約180件。\n- 行動調査約780件、所在調査約90件、浮気調査約80件、盗聴器発見約40件、その他約20件。\n\n**G.A.I.N.S. 要約**\n\n- **Goal:** 調査クオリティ・信用度で城南エリア No.1。売上高 2,500万円（内 BNI 500万円）。\n- **Interests:** 政治、読書、映画、ゴルフ練習・ゴルフスイング研究。\n- **Networks:** 倫理法人会、守成クラブ、同業者、前職の人材派遣業界。\n- **Skill:** 警備員指導教育責任者、大型自動二輪、簿記2級。\n- **成功の鍵:** できる限り多くの方と会い、「探偵」と「私」を理解してもらい、少しでも信用を得ること。\n\n**リファーラル情報**\n\n- **質の高い紹介:** 弁護士、社労士、生命保険、損害保険、政治家秘書、不動産業、建設業、離婚カウンセラー、占い師、コーチ、インフルエンサー、ご相談者を紹介できる方。\n- **不適切な紹介:** 「探偵」にまったく興味がない方。\n- **Top3:** 弁護士、社労士、離婚カウンセラー。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-05-14、Zoom 文字起こし要約を反映。開始・終了の正式時刻は TODO）。\n- **主な成果:** 礒部さん（探偵業）と次廣（システムエンジニア）が初回 1to1 で相互の事業内容・紹介可能な顧客層を確認。礒部さんは **保険営業担当者との連携** を希望し、次廣は **税理士・社労士との協業** を模索していることを共有。\n- **合意事項:** 礒部さんが所属チャプターのメンバー表を次廣へ送付。次廣は DragonFly のメンバー表を入手して礒部さんへ送付し、DragonFly 内の **保険業従事者 2〜3名** を紹介する。\n- **保険業との相性:** 礒部さんの文脈では、保険営業担当者は直接の顧客というより、**相談者と日常的に接点を持つ紹介チャンネルの1つ**。家庭・相続・事故・法人リスク・従業員トラブルなど、保険営業が受ける相談の周辺に「事実確認が必要だが誰に相談すべきかわからない」ケースがありうる。\n- **保留・探索:** 両チャプターとも税理士不在。BNI／倫理法人会まわりのゲスト管理・入会促進プロセスのシステム化余地が話題になったが、予算不足が課題。\n- **注意:** 浮気調査が売上の大半を占めるため、紹介時は詳細を聞きすぎず、事実確認が必要な相談として適切に礒部さんへつなぐ。\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n**進行イメージ:** お互い「事業紹介 → 質疑応答」がだいたい各30分。  \n**時間の配り方（目安）:**\n\n| パート | 内容 | 目安 |\n|--------|------|------|\n| オープニング | あいさつ・今日の進め方の合意 | 約3分 |\n| 前半 | 礒部さんの事業紹介 → こちらから質問 | 約30分 |\n| 後半 | こちらの事業紹介 → 礒部さんから質問 | 約30分 |\n| クロージング | 紹介・次アクション確認 | 約2〜5分 |\n\n### 1. オープニング（信頼の橋）\n\n> 「礒部さん、本日はお時間ありがとうございます。BNI DragonFly の次廣です。  \n> 今日は、まず礒部さんのお仕事をしっかり理解して、僕がどんな方をご紹介できるのか、逆に紹介してはいけないケースも含めて教えていただけたらと思っています。  \n> 後半で、僕の業務システム・AI活用支援の仕事もお話ししますので、礒部さんから見て『こういう人なら合いそう』という視点で聞いていただけるとうれしいです。  \n> 前半は礒部さん、後半は僕、という流れで進めてもよいですか？」\n\n### 2. 前半：礒部さんの事業紹介〜質疑応答\n\n**まず聞く姿勢で入る。探偵業はセンシティブなので、案件の具体名より「紹介者としての理解」を目的にする。**\n\n> 「探偵のお仕事は、こちらが想像している以上に幅が広いと思うのですが、いま礒部さんの中で一番多いご相談、または一番力を入れている領域はどこですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n- 「従業員の素行調査や不正の証拠撮影は、経営者がどんな状態になったときに相談するのが一番よいですか？」\n- 「浮気調査や離婚前後の相談は、弁護士さん・離婚カウンセラーさんとの連携が重要そうですが、紹介の流れとして理想形はありますか？」\n- 「15年間お客様とのトラブル0件というのはすごいですね。調査前の説明や見積もりで、特に大事にされていることは何ですか？」\n- 「『質の高いリファーラル』として、弁護士・社労士・保険・不動産・建設業とありますが、この中で今いちばん増やしたい接点はどこですか？」\n- 「逆に、探偵業で紹介されても困るケース、事前に確認してほしいことはありますか？」\n- 「僕が第三者に礒部さんを紹介するとしたら、どんな一言で伝えると一番ずれが少ないですか？」\n\n**紹介文を作るための確認**\n\n> 「たとえば『従業員の不正や家庭の問題で、感情ではなく事実確認が必要なときに、15年トラブルなしで相談できる探偵の方』という紹介の仕方は、礒部さんの感覚に合っていますか？」\n\n### 3. 後半：こちらの事業紹介〜質疑応答\n\n**紹介のたたき**\n\n> 「僕は tugilo という屋号で、業務の情報が Excel や LINE、紙、個別ツールに散らばって、確認や転記に時間がかかっている会社向けに、業務システムを作っています。  \n> 既製品をそのまま入れるというより、現場の流れを聞いて、必要なところだけを小さくシステム化する仕事です。  \n> 最近は AI も使いながら、問い合わせ対応、日報、見積・請求、案件管理、PDFやExcelの整理などを、現場に合わせて作ることが多いです。  \n> BNIでは、士業・コンサル・不動産・建設・サービス業の方の先にいる『現場が回らなくなってきた経営者』をご紹介いただくことが多いです。」\n\n→ 続けて:\n\n> 「礒部さんのお仕事でいうと、調査そのものに踏み込むというより、相談受付、案件進捗、書類・写真・報告書まわりの整理など、裏側の業務効率化でお役に立てる可能性があるかもしれないと思いました。」\n\n### 4. 協業・紹介の可能性を探る一言\n\n> 「礒部さんの周りには、弁護士さん、社労士さん、不動産業、建設業、保険関係の方が多いと思います。  \n> その方々の中で、顧問先や相談者の情報整理、案件管理、LINEやExcel運用で困っている方がいれば、僕の仕事と相性があるかもしれません。  \n> 逆に僕の周りで、従業員トラブルや離婚・相続前後、不動産まわりで『事実確認が必要そうだが、誰に相談したらよいかわからない』という方がいたら、まず礒部さんに相談してよいか確認したいです。」\n\n### 5. ギバーズ（紹介の聞き方）\n\n> 「今日の時点で、礒部さんにとって一番ありがたい紹介先を1つに絞ると、弁護士さん、社労士さん、離婚カウンセラーさんのどなたに近いですか？  \n> それと、紹介前に僕が相手へ確認しておくべきことがあれば教えてください。」\n\n**具体紹介につなげる確認**\n\n- 「DragonFly 内または周辺で、士業・不動産・保険の方におつなぎできそうか確認します。」\n- 「紹介時は、相談内容を細かく聞きすぎず、礒部さんに直接相談してもらう形がよいか確認します。」\n- 「緊急度が高い相談と、まず情報収集したい相談で、つなぎ方を分けたほうがよいですか？」\n\n### 6. クロージング\n\n> 「今日はありがとうございました。探偵業は、困ってから探す方が多いと思うので、僕の中で『こういうときは礒部さんに相談』という引き出しを作れたのがありがたいです。  \n> 今日の内容を整理して、紹介できそうな方がいないか確認します。  \n> 次回、こちらから紹介候補や、僕の仕事との接点が見えたら、改めてご相談させてください。」\n\n**実施直後に自分メモ:** 紹介可能性を **士業 / 不動産 / 保険 / 建設 / 離婚カウンセラー** の5カテゴリで確認する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-14 実施済み（時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-14（木）JST TODO–TODO**（開始・終了まで。取得元: カレンダー等で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 24`（**1セッション＝DB 1行**。正式時刻は TODO のため `scheduled_at = null`）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 礒部昌之さん（探偵業）と次廣淳（システムエンジニア）が初回 1to1 を実施し、互いのビジネス内容と紹介可能な顧客層を確認。\n- 礒部さんは **保険営業担当者との連携** を希望。次廣は **税理士・社労士との協業** を模索していると共有。\n- 引き続き連携する意向は確認したが、次回日程は未設定。\n\n**決定事項・合意内容**\n\n- **メンバー表の相互共有:** 礒部さんが所属チャプターのメンバー表を次廣へ送付。次廣も DragonFly のメンバー表を入手して礒部さんへ送付する。\n- **保険営業担当者への紹介:** 次廣のチャプターに所属する **保険業従事者 2〜3名** を礒部さんへ紹介する。\n- **BNI／倫理法人会まわりのシステム改善可能性:** ゲスト管理や入会促進プロセスがシステム化されていない課題が共有され、次廣が改善余地を認識。\n\n**礒部さん側（探偵業務）**\n\n- **事業概要:** 独立探偵として 15年間活動し、トラブルゼロの実績。Zoom 要約では「レムリ（フランス語で夢）」という屋号表記あり（プロフィール上の「ネスレ探偵事務所」と要確認）。\n- **主要業務:** 売上の **75% が浮気調査**。残りは企業調査（横領・詐病確認など）。\n- **料金体系:** タイムチャージ制。関東圏は交通費込み、車両費以外はすべて含む。\n- **運営体制:** 従業員を雇わず、フリーランス調査員と協力。就業規則の複雑さと交通リスクを避けるため。\n- **顧客対応方針:** 納得いかない結果には料金請求せず、顧客との揉め事を回避。\n- **経歴:** 日系金融機関子会社で経理・営業を経験後、学生時代の知人（探偵歴20年超）の紹介で転職。\n- **地域的背景:** 義父が藤枝東高校出身で、静岡県藤枝市と縁がある。\n\n**次廣側（要約）**\n\n- **事業内容:** AI 活用による業務改善システム構築。Excel・ファイル管理の限界を感じる中小企業向け。\n- **経歴:** 獨協大学フランス語学科に6年在籍後、システム会社社長のスカウトで中退し IT 業界へ。SE 歴26年、AI 活用歴3年超。\n- **AI活用の特徴:** プログラミング作業の大部分を AI に委託し、要件定義と運用に集中。従来 400〜800万円規模のシステムを 180万円程度・短納期で提供できると説明。\n- **実績例:** 外壁ブロック FC 本部の受発注・加盟店管理、LINE 連携の見積・請求、スタンプラリーのデジタル化、予約管理、防水工事業の工程管理・外国人職人向け日報。\n- **開発方針:** 現場ワークフローを変えず効率化し、小さく始めて段階的に機能追加する伴走型。\n- **BNI:** DragonFly 所属2ヶ月、全トレーニング修了済み。「何でもできます」から「わかりやすい専門性」へ営業方針を転換。\n- **自己開示:** 妻、中3・小6の娘2人、猫4匹（チンチラペルシャ3匹＋保護猫1匹）。\n\n**保留・確認事項**\n\n- 次廣が DragonFly のメンバー表を入手し、改定状況も確認して礒部さんへ送付する。\n- 両チャプターとも税理士不在。税理士は重点カテゴリーだが、既存メンバーとの関係で新規加入が難しい可能性。\n- BNI／倫理法人会のゲスト管理・追跡プロセスには改善余地があるが、予算不足が課題。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 礒部さんは **保険営業担当者との接点** を増やしたい。\n- DragonFly 側のメンバー表を次廣がまだ手元に持っておらず、共有が必要。\n- 両チャプターとも **税理士不在**。重点カテゴリーだが新規加入には難しさがある。\n- BNI／倫理法人会まわりで **ゲスト管理・入会促進プロセスがシステム化されていない**。\n- 上記システム化は、改善余地はあるが **予算不足** が課題。\n\n#### 仮説（tugilo視点）\n\n- **紹介導線:** 礒部さんへの初回アクションは、探偵業務の直接案件よりも **保険営業担当者への接続** が最短。まず DragonFly 内の保険 2〜3名を確実に紹介する。\n- **協業接点:** 税理士・社労士・保険・不動産・弁護士の周辺で、事実確認・リスク管理・証拠化の相談が発生しやすい。次廣の士業開拓とも重なる。\n- **保険営業が紹介チャンネルになる理由:** 保険営業は、契約前後のヒアリングや保全活動で家族構成・相続・事故・病気・事業リスクなどの相談を受けやすい。そこで浮気・離婚・所在確認・従業員不正・法人トラブルの兆しが出たとき、保険営業本人が踏み込まず、礒部さんへ専門家としてつなげる導線になりうる。\n- **システム化候補:** BNI／倫理法人会のゲスト管理は、予算制約があるため即案件化よりも **課題メモ化・小規模プロトタイプ・関係者ヒアリング** が現実的。\n- **信頼形成:** 礒部さんは「トラブルゼロ」「納得できない結果には請求しない」という信頼軸が強い。紹介文ではここを中心にする。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **紹介の肝:** 探偵業は「興味がある人」ではなく、弁護士・社労士・不動産・保険・建設・離婚カウンセラー等が相談者を抱えたときに紹介しやすい。初回会話では特に **保険営業担当者** との連携希望が明確。\n- **信頼の軸:** 15年トラブル0件、調査品質、料金説明、相談時の安心感が差別化。会話上は **納得いかない結果には料金請求しない** という顧客対応方針も重要。\n- **事業実態:** 売上の75%は浮気調査。企業調査（横領・詐病確認など）もあり、経営者・士業・保険・不動産との接点が作りやすい。\n- **関係構築:** 藤枝市との縁、猫・家族などの自己開示もあり、単なるビジネス紹介だけでなく人となりの接点を作りやすい。\n- **システム化の芽:** BNI／倫理法人会のゲスト管理・入会促進プロセスに非効率がある。ただし予算不足が前提なので、すぐ売り込まず構造整理に留める。\n- **注意点:** 家庭問題・浮気・従業員不正はセンシティブ。紹介者が詳細を聞きすぎず、適切に専門家へつなぐ動きがよい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **まずは紹介理解:** 礒部さんを「探偵」としてではなく、**事実確認が必要な局面で相談できる専門家**として言語化する。\n- **最優先アクション:** DragonFly 内の **保険業従事者 2〜3名** を確認し、礒部さんへの紹介可否を取る。\n- **紹介順:** 竹内駿太さんは次廣が 1to1 済みで関係性があるため、最初の接続先として最適。まず竹内さん本人に紹介可否を確認し、了承後に礒部さんへつなぐ。\n- **竹内さんへの説明軸:** 「保険営業の方が探偵案件を探す」という話ではなく、**保険営業の方が顧客から人生・家庭・事業リスクの相談を受けたときの専門家ネットワークの1つ**として礒部さんを知ってもらう、という伝え方が自然。\n- **tugilo側の接点:** 士業・不動産・建設・保険関係者の先に、業務効率化や案件管理ニーズがある可能性を探る。特に税理士・社労士との協業探索と礒部さんの紹介希望は重なりやすい。\n- **システム化は別レーン:** BNI／倫理法人会のゲスト管理は面白いが、予算制約が強い。現時点では「課題として覚えておく」位置づけ。\n- **直接営業しすぎない:** 初回後は、まず約束したメンバー表共有と保険紹介を優先し、信頼形成を進める。\n\n---\n\n## ■ 今後のTodo（次廣）\n\n- [ ] 第1回の正式時刻・実施方法を確定し、YAML と【第1回】基本情報を更新する。\n- [ ] DragonFly のメンバー表を入手し、改定状況を確認して礒部さんへ送付する。\n- [x] DragonFly 内の保険業従事者 2〜3名を確認する。**2026-05-14 16:16 JST DB確認:** 紀川和弘さん（建設業特化型損害保険）、竹内駿太さん（アスリート専門生命保険）が本命。周辺候補として海沼功さん（企業型確定拠出年金導入サポート）、山本葉子さん（ビジネス特化型クレジットカード）。\n- [x] **竹内駿太さんを優先紹介候補にする。** 次廣が過去に 1to1 済みのため、まず竹内さんへ「探偵業の礒部さんが保険営業担当者との接点を希望している」と紹介可否を確認。**2026-05-14 16:33 JST:** 竹内さん了承済み。次は礒部さんへ紹介連絡。\n- [ ] 礒部さんへ竹内駿太さんを紹介し、双方をつなぐ。\n- [ ] 必要に応じて、紀川和弘さん（建設業特化型損害保険）にも紹介可否を取る。\n- [ ] 礒部さんからレブリー側のメンバー表を受領したら、税理士・社労士・保険・不動産・建設周辺の接点を確認する。\n- [ ] 礒部さん向けの紹介文を、本人確認後に1〜2文で固定する。\n- [ ] 屋号の表記ゆれ（ネスレ探偵事務所／レムリ）を名刺または本人確認で確定する。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n**tugilo → 礒部さんへ（想定）**\n\n- DragonFly 内の保険業従事者 2〜3名（初回合意事項）\n  - **紀川和弘さん:** 建設業特化型損害保険（金融・保険・資金サポート）\n  - **竹内駿太さん:** アスリート専門生命保険（金融・保険・資金サポート）\n  - **海沼功さん:** 企業型確定拠出年金導入サポート（金融・保険・資金サポート）\n  - **山本葉子さん:** ビジネス特化型クレジットカード（金融・保険・資金サポート／保険そのものではなく周辺候補）\n- 弁護士、社労士、司法書士、行政書士など、相談者の事実確認ニーズを抱える士業\n- 不動産業者、建設業者、保険関係者\n- 離婚カウンセラー、コーチ、相談業\n- 従業員不正・サボり・トラブルの証拠化で悩む経営者\n- 盗聴器・盗撮器、所在確認、人探しなどで困っている相談者\n\n**礒部さん → tugilo へ（確認したいこと）**\n\n- 顧問先や知人で、Excel・LINE・紙で案件管理が限界になっている経営者\n- 士業・不動産・建設・保険関係者で、顧客対応や書類管理の効率化に困っている方\n- 税理士・社労士など、補助金や労務・会計まわりでシステム化ニーズを持つ専門家\n- BNI／倫理法人会まわりで、ゲスト管理・入会促進・追跡プロセスに課題を感じている運営関係者\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **トーン:** 探偵業への興味本位ではなく、紹介者として正しく理解したい姿勢で入る。\n- **強みの伝え方:** 「15年トラブルなし」「調査クオリティ」「相談しやすさ」を中心にする。\n- **第1回の印象:** 保険営業担当者への紹介希望が具体的。次廣側の自己紹介も、AI活用・小さく始める業務改善として共有済み。\n- **注意:** 浮気・家族・従業員不正などは相手が話した範囲に限定。具体案件の詳細には踏み込みすぎない。\n\n---\n\n**参照:** ユーザー提供プロフィール画像・G.A.I.N.S.・略歴シート（2026-05-14 入手）。第1回: Zoom 文字起こし要約（2026-05-14 文書反映）。正式時刻はカレンダー等で確定後、YAML・【第1回】を更新する。','2026-05-17 22:26:13','2026-06-04 10:53:02'),
(25,1,37,119,NULL,'89314073650','Xswm1pOmRfezElNCaBsjPg==','manual','2026-05-18 17:00:00','2026-05-18 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_maeda_referral_imaishi.md】\n\n# 1to1_前田和良（今西様紹介・非BNI）\n\n---\n\n## 文書の位置づけ\n\n- **対象関係:** 次廣（tugilo）と **前田 和良** さんの 1to1 を **1ファイルで時系列管理**する。\n- **接点チャプター（自分側・整理用）:** BNI DragonFly（Religo が利用されているコミュニティ）メンバーとしての活動文脈。相手側は **BNI メンバーではない**ため、YAML の `chapter_primary` は **`other_organization`** とし、その他団体・紹介ネットワーク由来の記録として扱う。\n- **紹介経路:** 今西様からの紹介。**接続経路の補足（第1回要約）:** **ドラゴンフライ・平山氏**経由で今西様と前田さんが繋がっている、との共有あり。\n- **紹介時の意図（事前メモ）:** マーケ伴走・**お互いの AI 活用の情報交換**。**第1回**ではこれに加え、**思考 R 診断システム**の開発相談・事例共有まで進んだ。\n- **ソース:** **【第1回】**はユーザー提供の **Zoom 文字起こし要約**（`[引用]` 省略）。**YAML の初回日時は要約に無いため TODO** — カレンダー／Zoom メタで確定すること。\n\n---\n\n## 紹介コンテキスト（確定済みのみ）\n\nユーザー提供・今西様メッセージの要約（原文の保存が必要ならチャットログを別途参照）。**第1回オンライン面談実施済み**のため、確定情報は **【第1回】・基本プロフィール** を優先する。\n\n- 毎月 ZOOM での実施がある（または、同様のオンライン定例環境）。\n- メイン領域は **マーケティング**。SNS 集客など **幅広い伴走**が可能な人物像。\n- **AI を実務で活用されている**とのこと。**単に「興味がある」ではなく、自分側の使い方も含めて相互に情報交換したい**ニュアンスと捉えてよい。**「今日次さんの話をしたらお話したい」** との流れがある。\n- 参照リンク（プロフィール等・要ログイン環境があり得る）: `https://www.facebook.com/share/18N5xY3Q8m/?mibextid=wwXIfr`\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※本節は **第1回 Zoom 要約**ベース。**屋号・正式表記・連絡先は名刺／Web で要確認**。\n\n- **名前:** 前田 和良（まえだ かずよし／読みは本人確認 **TODO**）\n- **居住地:** 群馬県（第1回要約）\n- **事業領域:** マーケティング・コンサルティング。**SNS に限定せず**、リアル・オンラインを含めた提案と実装（第1回要約）\n- **スタンス転換:** **コンサル（宿題型）から実装ベースへ**。クライアントが宿題を進めない課題への対応として、動線まで含めて手を動かす方式へ変更した（第1回要約）\n- **過去の学び:** コンサル経由案件で相手が離脱し、**約300〜400万円規模の赤字**経験あり（第1回要約。**詳細は本人確認のうえ外部共有を慎む**）\n- **開発ニーズ（社内／関連）:** **思考 R 診断システム**（教会関連コンテキストでの診断。**詳細・表現は本人・当事者との合意が前提**）。現状フローは Google Form → スプレッドシート数値 → 手入力で別システム → PDF 生成（第1回要約）\n- **AI 活用（実務）:** SNS 画像作成、ライティング整形、LP 作成（**Genspark** 利用の旨、第1回要約）。山形県最上町の商工会から **AI 活用セミナー**依頼あり、移動 **6時間超**で訪問予定とのこと（第1回要約）\n- **定期オンライン:** 紹介時メモでは毎月 ZOOM の旨あり。第1回要約では詳細未確認 → **TODO**\n\n---\n\n### 次廣側（このファイルのオーナー・参照）\n\n※第1回で話した内容の要約。**ライブドキュメントとのズレがあればライブ側を業務 SSOT とする。**\n\n- **居住地:** 静岡県藤枝市（既存ライブドキュメントと整合）\n- **経歴:** システムエンジニア歴 **約25〜26年**、年齢 **53歳**（第1回要約）\n- **対象顧客:** **B2B 中心**。製造業・建築業の顧客管理・工程管理等（第1回要約）。ライブドキュメントの業種例とも整合。\n- **開発スタイル:** **プロトタイプ開始→ニーズに合わせて育てる伴走型**（第1回要約・ tugilo の一貫表現）\n- **価格・事例の一例（第1回で共有した数字）:** 従来 **600〜800万円規模**とされる類似システムを **約180万円**（初期120万＋追加機能）で提供した事例として **プロテクトラボ社フランチャイズ管理**を説明（第1回要約。**見込み客への転載は本人確認・プレス許諾を要する**）\n\n---\n\n## ■ 初回 1時間の設計（アジェンダ素案）\n\n※**第1回は実施済み**。以下は事前計画のアーカイブ。実際の論点は 【第1回】を参照。 （1）**事業の相互理解**（2）**AI 活用の相互情報交換**（ツール・用途・運用レベルを含めて双方向）。\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 感謝（今西様・時間）、録画・資料共有の合意、**上記二本柱**をそのまま目的として共有 |\n| 5〜20分 | **相手（前田様）** | 事業・得意領域、得意な顧客像、定期 ZOOM での進め方、事例1つ |\n| 20〜32分 | **自分（次廣／tugilo）** | 一言 Pitch＋典型事例、現在のチャネルと課題（詳細ダイブは次回にも回せる） |\n| **32〜48分** | **AI 活用の情報交換（双方向）** | **前田様:** 業務での使い分け（コンテンツ案・構成・調査／クライアント向け伴走での使いどころ等）、使っているサービス・制約。**次廣:** 開発／業務改善での使い方の要点。**お互い:** 効いているワークフロー1つずつ／うまくいかなかった試し／著作権・クライアント情報の扱いの線引きなど、運用論で止めてデモ競争にならなくてよい |\n| 48〜53分 | **紹介のすり合わせ** | お互いに渡せる／欲しい理想の紹介（業種・課題の言語化・地雷の確認） |\n| 53〜60分 | **クローズ** | ネクストアクション（資料送付、紹介文共有、AI 関連で共有したリンク、フォローの日時） |\n\n**時間が押したとき:** 紹介パートを短縮し、**AI 情報交換を最低でも 12〜15 分は確保**する形を優先してよい（今回の紹介経路と期待に直結）。\n\n**事前に用意しておく短い準備:**\n\n- **60秒自己紹介**（誰のどんな状態から、どこまで短く運ぶか）\n- **AI メモ（各2〜3分で話せる分量）:** 日常的に触れているサービス、**業務での用途が分かる具体例 1〜2個**、「クライアント案件ではここまで／自分の会社ではここまで」という境界があれば一言\n- **紹介してほしい相手を3条件**（例：年商規模／業種／課題の言い方）\n- **自分から返せそうな紹介／案件** を1〜2個（過剰請求しない範囲）\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回オンライン面談（Zoom）実施済み**（ユーザー提供・文字起こし要約ベース。**開始・終了の正式時刻は YAML・本文とも TODO**。カレンダー／録画メタで確定）。\n- **主な成果:** 初対面で **AI 活用・システム開発事例**を共有。**思考 R 診断システム**について現状フロー（Google Form→スプレッドシート→手入力→PDF）と課題（Vibe Coding 系ツールでの開発が修正時に不安定・UX 微妙）を整理。**最小構成の開発費用**として次廣から **約50〜80万円程度**の見積レンジを提示し、段階拡張の余地あり。**協力・継続検討**の前提ができた。\n- **事例共有:** プロテクトラボ社フランチャイズ管理（分散していた入力を統合、人数を増やさず規模対応／金額は第1回会話として記録）。次廣側の AI 活用（Cursor・ブログ自動化・配信）・前田側（Genspark・セミナー）を交換。\n- **長期論点:** ローカル LM による社内文書管理構想（次廣・実証継続）、コンテンツ自動生成の **再現性**（他者への展開可否）、AI 開発の **保守・セキュリティ**への関心。\n- **次アクション:** 【第1回】アクション一覧を参照。**対面面談**（前田さんの静岡訪問時・今西様同席）は日程未定。\n\n---\n\n## ■ 議事録に必ず書くチェックリスト（初回〜）\n\n実施後、各セクションに箇条書きで転記できるよう残す。\n\n**メタ:** 実施日時（開始・終了 **JST 明示**）・オンライン手段・参加者\n\n**相手側:** 事業の一枚化、メニュー、得意顧客、成果の見せ方、「毎月 ZOOM」の中身\n\n**AI（前田様側）:** 利用サービス／用途マップ（マーケ・SNS と自社バックオフィスの分け）、**クライアントワークでの使い方と自己利用の線引き**、オススメの型・地雷\n\n**自分側:** 修正した Pitch 表現メモ、今の課題\n\n**AI（次廣側・共有した内容メモ）:** 業務改善・開発での活用の例（粒度は相手向け）、前田様から得た示唆を一言\n\n**合意・アクション:** 誰が／いつまでに／具体物（資料、繋ぎ）\n\n**フォロー用:** 一言印象、具体的な紹介候補名（未定なら「候補メモのみ」）\n\n---\n\n## ■ 1to1 履歴\n\n### 【第1回】実施済み（正式日時 **TODO**）\n\n#### 基本情報\n\n- **日時:** **TODO（開始・終了・曜日・JST はカレンダー／Zoom 録画メタで確定）**\n- **実施方法:** Zoom（オンライン面談・文字起こし要約より）\n- **参加者:** 次廣 淳、前田 和良（かずよし／読みは本人確認 **TODO**）\n- **紹介・接続:** 今西様からの紹介。**ドラゴンフライ・平山氏**経由で今西様と前田さんが繋がっている旨の共有あり（要約）。\n- **ソース:** ユーザー提供 **Zoom 文字起こし要約**（`[引用]` 省略）。\n- **Religo 1to1 レコード:** `one_to_ones.id = 25`（**1セッション＝DB 1行**。正式日時は TODO のため `scheduled_at = null`）\n\n#### 主な成果（エグゼクティブサマリー）\n\n- 初対面オンライン面談。**AI 活用とシステム開発の実践事例**を共有。\n- **思考 R 診断システム:** 現状フロー・課題を整理。**最小構成で開発費おおよそ50〜80万円**の見積レンジ提示、機能追加で段階拡張可能。**詳細要件確定後に要件共有→協力可否判断**の流れ。\n- **協業可能性:** 前向きに確認。**対面面談**（静岡・今西様同席）は別途日程調整。\n\n#### 話した内容（重要）\n\n**参加者・背景**\n\n- **前田 和良:** 群馬在住。マーケティング・コンサルティング。**教会関連の思考 R 診断**システムの開発ニーズ（表現・公開範囲は当事者合意前提）。\n- **次廣 淳:** 静岡在住。SE 歴 **約25〜26年**、**53歳**。B2B 中心のシステム開発。\n\n**ビジネスモデル・サービス**\n\n- **前田さん:** SNS に限定しない。**コンサルから実装ベースへ**シフトし、宿題が進まない問題に対し **動線まで含めて手を動かす**。過去にコンサル案件で相手が離脱し **約300〜400万円の赤字**経験（要約。**外部への詳細共有は慎重に**）。\n- **次廣さん:** **プロトタイプから開始し伴走で育てる**。価格の一例として、従来 **600〜800万円規模**とされる類いを **約180万円**（初期120万＋追加）で実現した事例（**プロテクトラボ社・フランチャイズ管理**）を説明。\n\n**AI 活用の実践（情報交換）**\n\n- **前田さん:** SNS 画像、ライティング整形、LP（**Genspark**）。山形県最上町の商工会から **AI 活用セミナー**依頼、**移動6時間超**で訪問予定とのこと。\n- **次廣さん:** **Cursor（Claude Code 利用）**で実装を AI に依頼、**約2〜3年**。今年から修正も AI に依頼する運用とのこと。**ブログ:** 約 **200記事**ストックから重複なく **5日分タイトル**を選び **約3,500〜4,000字**の記事を自動生成、**Facebook・X にランダム配信**、SEO・アクセス解析。\n\n**システム開発（相談案件：思考 R 診断）**\n\n- **現状:** Google Form で回答 → スプレッドシートに数値 → **手動で別システム入力** → PDF 結果。\n- **課題:** Vibe Coding 等で試作したが **修正で他が崩れる**、UX・デザインが微妙。\n- **見積:** **最小構成 約50〜80万円**、段階的拡張。\n\n**事例詳細（プロテクトラボ社）**\n\n- 全国約 **200社**取扱店の外壁ブロックメーカー。**Google Form・スプレッドシート・Excel**に分散していた業務を統合。\n- **機能:** 注文・ステータス・店別売上分析・マニュアル／動画・権限管理等。**人数を増やさず規模拡大に対応**したとの共有。\n\n**技術・業界の話題**\n\n- Access／VB 等から **Web・スマホ対応**への移行が進む。\n- **工数目安見積の限界:** AI で短期完成する案件もあり **価値ベース見積**の必要性。\n- **職業観:** ホームページビルダー時と同様、プロ領域は残り **本質的価値**がより重要。**デザイン知識あり／なしで AI 活用の質が異なる**。エンジニアも「簡単に作れる時代だからこそ」経験が効く、との議論。\n\n**次廣側・構想メモ（ローカル LM 文書管理）**\n\n- 社内の「資料探索」「重複作成」「最新版不明」へのニーズ。**ローカルネット内**で解析・要約・検索し **外部に出さない**設計。**AI に任せる領域と人の領域の分離**、上書き・削除ルールの事前定義。**実証実験継続・サービス化検討中**とのこと。\n\n#### 確認待ち（要件・論点）\n\n- 診断システム:**PDF ダウンロード vs Web 表示**、**履歴管理の範囲**。\n- ローカル LM サービス:**実証の進捗・サービス化タイミング**。\n- **コンテンツ自動生成:** 次廣手法の **他者への再現性**（再現手法・プロダクト化の検討）。\n\n#### オープンクエスチョン（未決）\n\n- Vibe Coding 系でつくったシステムの **長期安定性・保守性**。\n- Claude Code 等の **データ消失リスク**への対応。\n- コンサル一般:**成果が出ない場合の責任分界**。\n\n#### 決定事項・合意内容\n\n- **思考 R 診断:** 詳細要件が固まり次第、前田さんから次廣へ共有 → **見積・開発可否を具体化**する方向で一致（要約ベース）。\n- **対面面談:** 前田さんの **静岡訪問時**に **今西様も含め**リアルで面談・懇親の意向（日程未定）。\n\n#### アクション一覧\n\n| 担当 | 期限 | 内容 |\n|------|------|------|\n| 前田 和良 | TODO | **思考 R 診断システム**の詳細要件整理（PDF/Web、履歴範囲等）→ 次廣へ共有 |\n| 次廣 淳 | TODO | **ローカル LM 文書管理**の実証継続・サービス化の検討 |\n| 両名 | TODO | **コンテンツ自動生成・再現性**の論点は継続検討 |\n| 両名＋今西様 | TODO | **静岡でのリアル面談・懇親**（前田さん訪問時・日程調整） |\n\n#### 次回\n\n- **日程未定。** 静岡での対面を予定（今西様同席の旨、要約）。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n※セッションを重ねたらだけでなく、初回でも「引っかかった言葉」を1〜2語メモすると後で効く。\n\n- **実装までやるマーケ:** 「宿題が終わらない」への回答として **動線まで背負う**転換は、システム側の「現場で回るまで」のスタンスと近い。\n- **AI 開発の落差:** **プロトタイプは個人でもできるが、保守・修正連鎖・セキュリティ**でプロ領域が残る——診断システムニーズと整合。\n- **価値ベース見積:** AI で実装コストが下がるほど **見積の説明軸**が変わる（第1回で共通の関心事）。\n- **再現性:** 自動コンテンツ生成は **自分の運用として強いが、他者へのパッケージ**は別問題として認識共有。\n\n---\n\n## ■ tugilo としての戦略（この関係での役割）\n\n- **システム:** **思考 R 診断**は要件確定後に **最小構成〜段階拡張**で提案。**教会関連表現・公開範囲**はディレクションと当事者合意を最優先。\n- **パートナー:** BNI メンバーではないが、**マーケ×実装×AI** の実務ピアとして関係が立ち上がっている。**質の高い紹介・協業**（クライアントの動線〜仕組み）を探す。\n- **自分の構想:** **ローカル LM 文書管理**は別線で実証。**前田さん側ニーズ（コンテンツ・業務効率）と交差するか**は継続観察。\n- **情報交換:** マーケ文脈の AI と開発文脈の AI は **競わず補完**。デモ競争より **運用・保守・責任分界**で信頼を積む。\n\n---\n\n## ■ 紹介・アライアンス視点（非BNIでも使える）\n\n- **前田さんに紹介したいタイプ:** Excel／フォーム運用が限界で **現場の入力・診断・顧客対応を一枚化したい**経営者・団体。**マーケと実装の両方がボトルネック**になっているケース。\n- **前田さんから紹介してほしいタイプ:** 同上。**動線設計まで必要なマーケ案件**で、バックエンドが Forms＋スプレッドシート止まりの組織。\n- **越境時の地雷（しないこと）:** 教会・信仰コンテキストの **表現・画像・個人情報**は勝手に広告や事例にしない。**赤字経験などセンシティブな話題**は本人許可なく第三者へ転載しない。\n\n---\n\n## ■ 自分側メモ・次廣（tugilo）の AI の使い方（情報交換・会話用）\n\n**（追記・第1回後）** 面談で話した **ツール名・自動ブログ運用の詳細**は 【第1回】「AI 活用の実践」を正とする。以下は事前のスタンス整理。\n\n**根拠（SSOT 相当）:** [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md)、[1to1_kimura_hidetsugu_kokuhosha.md](./1to1_kimura_hidetsugu_kokuhosha.md)、[1to1_okamoto_kachiteru_present.md](./1to1_okamoto_kachiteru_present.md)、[meetings/2026-03-30_gunji_lstep_webhook_ai_proposal.md](../2026-03-30_gunji_lstep_webhook_ai_proposal.md)。**細かいツール名は場の空気で足す。** ここは「何をしている人か」の会話ネタ用。\n\n### スタンス（役割）\n\n- AI はゴールではなく **手段**。先に現場・経営の **業務分解と構造化** をし、そのうえで **AI も通常のシステムも**、目的から逆算して選ぶ（ライブ §0・§6）。\n- 「AI ツールの使い方を教える人」ではない。**業務・システムに AI を組み込んだ設計と開発**が主務。キーワードは **時間を生み出す／人を増やす前に構造を整える／業務分解 × AI の組み込み**（ライブ §1・§5）。\n- 伴走スタンス：**仕様の押し付けはしない**。**小さく作って伸ばす**。現場の動きはできるだけ変えず、裏側の仕組みを最適化する（軍司様提案書 §1 と tugilo の一貫表現）。\n- 「何をなぜ作るか」から一緒に考える **構想パートナー**。技術は **時間・判断力・次の選択肢** を届けるための手段（ライブ §6）。\n\n### 自分のワークフローで AI を使っていること（ツール活用）\n\n※クライアント向けの「提供メニュー」とは別に、**自分の生産性**として。\n\n- **開発:** 生成 AI を **実装の補助**に使い、コーディングを任せられる部分は任せて **スピードとコストを下げる**（木村様 1to1 要約で本人が説明した内容と整合）。\n- **結果として:** AI 活用による効率で、**例会・ネットワーク活動などに割く時間も確保**しやすい、という自分側の運用論（同上）。\n- **ドキュメント・提案:** 「叩き台・要約などは AI が補助し、最終トーンや事実は人が責を持つ」という **分担の型**を、共創検討のときにも区別できる（岡元様 1to1 の整理）。\n\n### クライアント協業での AI の当て方（伝え方）\n\n- **業務側:** Excel・手入力・属人管理の「限界」を、入力の二度手間を減らす **ワークフローとシステム**に落とす。必要なら **要約・照合・FAQ ドラフト生成**など、業務要件にぶら下がった AI 活用を検討（岡元案・製造業向け 1to1 の「資料・仕様」仮説と同種の思考）。\n- **実装側（例）:** LINE（Lステップ）の Webhook と外部 API をつなぎ、**AI が返答草稿を生成し記録までつなぐ**——「便利な単体機能」より **売る仕組みと回る仕組みの両立** が設計目標（軍司様提案）。\n- **越境しないこと:** クライアント案件では **著作権・トーン・事実確認**のプロセスをセットにする。**AI の出力そのまま**をブランド文言や対外確定情報にしない（岡元 1to1 の注意）。\n\n### 前田様との「相互情報交換」で話すと伝わりやすい一文\n\nマーケ・SNS と同じレイヤーの「コンテンツ案」だけでなく、**業務要件に紐づけて AI と DB／API と画面をひとつの流れとして設計する**のが自分の業務であり、開発では **自分自身も AI を開発の増幅装置として日常的に使っている**、という二本立てでよい。\n\n---\n\n## ■ メモ（人物・温度感）\n\n※個人情報・センシティブ情報の取り扱いに注意。\n\n- **実務志向が強い:** コンサルから実装へシフト、赤字経験を踏まえた **リスク感覚**がストーリーとして印象に残りやすい。\n- **AI:** セミナー講師依頼レベルで **発信・実務の両方**に踏み込んでいる。','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(26,1,37,120,NULL,'82792118979','xG0mAVPKS1Gn4YNQBvNlxA==','manual','2026-05-18 16:00:00','2026-05-18 16:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_tsuji_ryo_mainc_meo.md】\n\n# 1to1_辻亮_株式会社MainC_MEO\n\n---\n\n## 文書の位置づけ\n\n- **対象関係:** 次廣（tugilo）と **辻亮** さん（**株式会社MainC**）の 1to1 を **1ファイルで時系列管理**する。\n- **接点:** 両者とも **NEリージョン**。リージョンフォーラム等で**対面機会あり**（要約）。辻氏は **BNI TRES STELLAS（トレスステラ）** 所属の他チャプターメンバーで、**守成クラブ**、**新生会・ニック・トピック**など他ネットワークにも参加とのこと。次廣は **BNI DragonFly**（**Religo** が利用されているコミュニティ）メンバー。\n- **紹介経路:** **髙月**さんとの 121 を経由。**紹介時の場・カテゴリ文脈:** **トレスステラ**。**所属法人:** **株式会社MainC**。\n- **ソース（第1回）:** ユーザー提供の **Zoom 文字起こし要約**（`[引用]` は本ファイルでは省略）。**開始時刻:** ユーザー確認により **2026-05-18 JST 16:00**（1to1調整行に **15:59 (GMT+9)** 表示があったが**16:00開始でOK**と合意）。**終了時刻:** **TODO**（Zoom 録画メタ等）。\n\n---\n\n## 紹介コンテキスト（事前〜第1回まで）\n\n- **事前紹介の要点:** トレスステラ・MEO（店舗）、実績、SNS・HP。\n- **Religo DB:** `one_to_ones.id = 26`。辻亮さんの所属チャプターは `members.workspace_id = 8`（BNI トレスステラ）へ反映済み。\n\n---\n\n## 初回セッション設計（アーカイブ・事前計画）\n\n※**第1回は実施済み**。実際の内容は **【第1回】** を参照。\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 髙月さんへのお礼、本日の目的、録画・メモの合意 |\n| 5〜35分 | **辻さん** | 事業・提供範囲、実績、繋がりたい人 |\n| 35〜65分 | **次廣** | Religo／DragonFly／tugilo、紹介依頼の言語化 |\n| 65〜70分 | クローズ | 次アクション、DB 登録の有無 |\n\n### 辻さん側・ヒアリング（第1回で多く確認済み → 詳細は【第1回】）\n\n- [x] MEOの範囲・検索施策の一貫提供\n- [x] 店舗系7割・他業種の扱いは本文参照\n- [x] SNSは自社アカウント実績をクライアント展開\n- [x] 紹介希望（業務改善コンサル、補助金、建設業士業、同業協業、FC本部）\n- [x] DragonFly における SEO/MEO 需要在籍専門家不在（要約）\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※第1回 Zoom 要約ベース。**数値・事例の対外転載は本人許諾を要する。**\n\n### 辻亮 さん\n\n- **名前:** 辻亮（読み **TODO** 本人確認）\n- **組織:** **株式会社MainC**\n- **体制:** 業務委託含め約 **20名**。**女性比率が高く比較的若い年齢層**とのこと（要約）。\n- **コミュニティ:** **BNI 新東京セントラル（赤坂）・守成クラブ**。**新生会・ニック・トピック**等の経営者ネットワーク参加（要約）。\n- **事業モデル:** **店舗系クライアント約7割**。**MEO、SEO、ホームページ制作**など**検索周りを一貫**提供（要約）。\n- **MEO実績（要約）:** **5,000店舗以上**。**飲食・医療・美容**が中心顧客。\n- **自社SNS実績の展開（要約）:** 自社運用の実績をクライアントに展開。**YouTube 約4.8万人、Instagram 約5,000、TikTok 約1.3万人**。\n- **自社プロダクト:**\n  - **ローコミ:** 店舗と **Google口コミを書く人**をマッチングするプラットフォーム。**約1,500名登録**（要約）。\n  - **Muスコープ:** **GoogleマップデータとGoogleの裏データ**を紐づけた**出店分析ツール**。**先月末リリース**（要約時点）。開発期間 **4〜6ヶ月**、開発費 **約200万円**、**Googleライセンス契約**により実現（要約）。\n\n### 次廣側（このファイルのオーナー・参照）\n\n※ライブドキュメント [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) とズレがあればライブ側を業務 SSOT とする。\n\n- **BNI DragonFly:** **2025-03-17 入会**（要約）。**2025年4月中**に **13トレーニング完了**し**グラデュエート資格**取得（要約）。\n- **キャリア:** 大学卒業後**文系からITへ転身**。**システムエンジニア歴は26年目**、**AI活用歴は約3年**（要約）。\n- **屋号・事業:** tugilo。業務システム構築。**AIによるコーディング自動化**で工数ベース見積からの脱却を進めている（要約）。\n- **価格事例（要約・対外転載注意）:** フランチャイズ本部向けについて、類似が **600〜800万円相当**とされる規模を、**スタート120万円・最終180万円以下**で収めた事例を共有（要約）。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**。**2026-05-18（月）JST 16:00〜**・**Zoom**（**終了時刻 TODO**）。\n- **相互の評価:** 辻氏は次廣の**開発実績**（FC本部、防水工事の日報、スタンプラリー等）に**強い関心**。**「現場に合わせた仕組み」「小さく始めて改善」「人に頼らない状態」**への共感（要約）。価格について **AI効率化を反映した先駆的な取り組み**と理解（要約）。\n- **協業の芽:** 辻氏希望の**業務改善コンサル・補助金・建設業士業**と次廣ネットワークの**合致**。**DragonFly に SEO/MEO 専門家がおらず重点カテゴリ**（要約）。辻氏は**同業（マーケ・Web・SEO）との協業・下請け**も可。**FC本部**希望あり、次廣クライアントの**第一ブロックFC本部（全国約200店舗規模）**との接続可能性に言及（要約）。\n- **合意したアクション（要約）:**\n  - **辻→次廣:** 業務改善コンサル、補助金関係、建設業向け士業の**紹介**。\n  - **次廣→辻:** **飲食店コンサル**を行う知人の紹介。DragonFly で **SEO/MEO 需要のあるメンバー**の紹介。\n  - **両者:** **2026-06-05 リージョンフォーラム**で**対面名刺交換**（辻氏は**コンペ予定**があり**オンライン参加の可能性**あり（要約））。\n- **オープン論点:** **Muスコープ**のライセンス上限（**10社まで**等の制約）、展開方針（エンタープライズ／開業コンサル寄りへの転換、**レポート代行1件約3万円**モデルの可能性）、**不動産検索との座組**（要約）。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-18 実施済み（終了時刻 **TODO**）\n\n#### 基本情報\n\n- **日時:** **2026-05-18（月）JST 16:00–TODO**（**開始:** ユーザー確認「16:00からでOK」。調整用表示 **15:59 (GMT+9)** あり。**終了:** カレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、辻亮（株式会社MainC）\n- **Religo 1to1 レコード:** `one_to_ones.id = 26`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※`[引用]` は省略。\n\n**共通コンテキスト**\n\n- 両者 **NEリージョン**。フォーラム等での**対面機会**（要約）。\n- 次廣: DragonFly 入会・トレーニング完了の経緯。辻: 赤坂チャプターと他ネットワーク。\n\n**辻氏の事業・強み**\n\n- 店舗**7割**、**MEO〜SEO〜HP**の一貫。**5,000店舗超**MEO実績、**飲食・医療・美容**。\n- 自社SNSフォロワー規模をクライアントに展開（YouTube / Instagram / TikTok の数値は要約参照）。\n- **ローコミ**（口コミマッチング、登録者数は要約参照）。\n- **Muスコープ**（出店分析、リリース時期・開発規模・費用・Googleライセンスは要約参照）。\n\n**次廣側の事業・スタンス**\n\n- 26年SE、3年AI活用、文系からIT。**FC案件の価格帯事例**（600〜800万相当感と120万スタート・180万以下完了の対比）を共有（要約）。\n- **AIコーディング**で見積前提を変えている（要約）。\n\n**協業・紹介のすり合わせ**\n\n- 辻: **業務改善コンサル・補助金・建設士業**希望 → 次廣ネットと合致（要約）。\n- DragonFly: **SEO/MEO枠は重点だが専門家不在**（要約）。\n- 辻: **同業協業・下請け可**。**FC本部**接点希望 ↔ 次廣側 **第一ブロックFC本部**（要約）。\n\n**ディスカッション（品質・業界動向）**\n\n- **SNS再現性:** 次廣が「バズ偶然 vs 体系化」を質問。辻: **仕組み・言語化は一定あり**、トレンド分析・強み深掘り・テクニックの検証の組み合わせ（要約）。\n- **SEOの将来:** **AIO/LLM最適化**にも言及。**しっかりSEOすればAIにも拾われやすい**との見立て（辻、要約）。\n- **SEO単体公司的な厳しさ:** 両者**同意**（要約）。次廣: **「狙ったキーワード」より生の言葉**での検索の重要性（例として「システム開発 静岡」ではなく**「エクセルが限界」**等）（要約）。次廣自身のサイトでは**AI記事自動投稿を半年〜1年**継続し**想定外KWからの流入**が増えたとの分析（要約）。辻: **業種によってはまだクリックされている**、完全AIシフトではない（要約）。\n\n**Muスコープ・データ・規約**\n\n- **ライセンス制約**により並行導入に上限（**10社まで**等、要約）。方針を**小規模民間→エンタープライズ／開業コンサル**寄りに再整理（要約）。\n- **ライセンスなし**ルートとして**レポート作成代行（1件約3万円）**も検討余地（要約）。**不動産探しとの座組**志向（要約）。\n- 次廣: **Googleマイビジネスデータを全系統合**すれば他データと組み合わせ可能、との視点（要約）。辻: **政府オープンデータとの掛け合わせ**検討、ただ **データは約2年前**などの課題（要約）。開業コンサルからのデータニーズに応えうる（要約）。\n\n**SNSオペレーション（リスク・手法）**\n\n- **顔出しNG**時は**キャスティング（撮影のみ出演者）**提案（要約）。従業員前面アカウントの**退職リスク**にも言及（要約）。**飲食以外（JRグループ会社等）**でも再生・フォロワー実績（要約）。\n\n**Googleデータ・コンプライアンス**\n\n- 次廣: 過去 **GBP起点のスクレイピング案件は断った**経緯（要約）。**規約上スクレイピングは厳しく、ライセンスが現実解**との共通認識（要約）。\n\n**DragonFly 展開の現実**\n\n- SEO/MEOは需要あるが**飲食オーナーは時間をかけられない**、**金額折り合い**が課題（要約）。辻のような**紹介先を複数**持てるとよい（次廣側コメント、要約）。\n\n#### アクションアイテム（要約どおり）\n\n| 誰 | 内容 |\n|----|------|\n| 辻 | 業務改善コンサル・補助金・建設業士業 → **次廣へ紹介** |\n| 次廣 | 飲食店コンサルの知人 → **辻へ紹介** |\n| 次廣 | DragonFly で **SEO/MEO需要のあるメンバー** → **辻へ紹介** |\n| 両者 | **2026-06-05 NEリージョンフォーラム**で**名刺交換**（辻はコンペ兼務で**オンラインの可能性**） |\n\n#### 確認待ち事項\n\n- [ ] 第1回 Zoom の**終了時刻**（JST）を YAML・本節へ反映\n- [x] `one_to_ones.id`（Religo 登録済み: `one_to_ones.id = 26`）\n- [ ] **新生会／ニック／トピック**の正式名称確認（表記ゆれ）\n- [ ] **6/5 フォーラム**の参加形式（辻氏オンライン可否の確定）\n- [ ] 紹介先の**具体名**・許諾（飲食コンサル、DragonFly メンバー、士業等）\n- [ ] **Muスコープ**の対外説明可能範囲・ライセンス条件の再確認\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **領域の補完:** 辻＝**検索・店舗集客の上流〜中流域**、次廣＝**業務オペ・システム**。同一クライアント（FC・店舗）で**表裏**の紹介がありうる。\n- **チャプターギャップ:** DragonFly に **SEO/MEO の座**があり、**信頼できる専門家紹介**はレバレッジが高い。**金額感・手離れ**を先にすり合わせないと案件化しにくい**飲食オーナー**もいる（要約）— **期待値調整**が紹介の質を左右する。\n- **コンプライアンス:** Googleデータは**スクレイピング頼みの開発は危険**。**ライセンス型**や**代行レポート**など正規ルート志向が双方とも合致。\n- **Muスコープ:** **供給制約（10社等）**があるプロダクトは、**坐売りではなくパートナー・業種選定**が必要。不動産・開業コンサル軸は自然（要約）。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **紹介の切り口:** 「Excel限界」「現場フロー」「FC本部の統合管理」など**生の課題語**でつなぐ。検索キーワード戦略は辻側と分担。\n- **開発の説明:** **AI活用による納得感ある価格帯**（要約で辻氏が理解）を維持しつつ、**規約遵守（Google等）**を明示して安心感を担保。\n- **6/5 フォーラム:** 名刺・フォローの短いメモまで**当日終了時に**追記する習慣。\n\n---\n\n## ■ リファーラル戦略（BNI・紹介ネットワーク）\n\n- **次廣 → 辻:** **DragonFly** で **MEO/SEO/HP・SNS**ニーズを持つメンバー（**業種・予算感・オーナーの手離れ**を一言添える）。**飲食店コンサル**知人。長期的に **FC本部**系。\n- **辻 → 次廣:** **業務改善コンサル・補助金・建設業士業**。制作・マーケ先で**バックオフィス限界**が見えたら橋渡し。\n- **同業連携:** 辻側が**下請け・協業**可能—大案件時の**役割分担**を早めに言語化しておくと摩擦が減る。\n- **髙月さんへの礼:** 初回で得た**具体紹介**が動いたら短く報告。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 辻氏: **数字とプロダクト**で説明が具体的。**業界の難所（SEO単体、規約）に現実的**。次廣の開発哲学に**共感**（要約）。\n- 次廣: **再現性・倫理・規約**を気にする質問が多く、**長期協業に向く**対話だった印象（要約）。\n- **注意:** KPI数値・クライアント名は**対外・コピペ紹介**の際は**許諾確認**。\n\n---\n\n**運用:** 新規セッションは **【第n回】** を追記し、**サマリー・累積・戦略**を更新する。','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(27,1,37,121,NULL,'89357445297','/kmKTakIRh+J3YUhtah6dQ==','manual','2026-05-19 14:00:00','2026-05-19 14:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_shimotsuji_hs_neo_project.md】\n\n# 1to1_下辻_株式会社hsネオプロジェクト\n\n---\n\n## 文書の位置づけ\n\n- **対象関係:** 次廣（tugilo）と **下辻** さん（**株式会社hsネオプロジェクト**）の 1to1 を **1ファイルで時系列管理**する。\n- **接点:** 次廣は **BNI DragonFly**（約50名・今期75名目標）。下辻さんは **BNI カーネル**（約20名・B2B中心）。\n- **紹介経路:** [**田村広大**](1to1_tamura_kodai_money_cooking.md) さん第1回で「岡山のSE（下辻氏）」紹介約束 → 本セッション。\n- **既存接点:** リファラル・トレーニングで**旅行**の話をしたことがあり、次廣が DragonFly メンバー紹介を約束したまま未実現だったエピソードを双方が想起（要約）。BO議事録の DragonFly **下辻さん**（奈良一人旅）との同一性は **未照合** — 別人の可能性も残す。\n- **同姓別人注意:** 上記 BO 下辻が別人の場合のみ [`BNI_DragonFly_BO_Step1_Referral_Minutes_20260402.md`](../../workshop/BNI_DragonFly_BO_Step1_Referral_Minutes_20260402.md) を参照。\n- **ソース（第1回）:** ユーザー提供 **Zoom 文字起こし要約**（`[引用]` は本ファイルでは省略）。\n\n---\n\n## 紹介コンテキスト（事前メッセージ）\n\n> 初めまして、システム開発、業務改善などしている株式会社HS-neo-projectの下辻と申します。是非121よろしくお願い致します。\n\n- 法人表記は要約・会話では **株式会社hsネオプロジェクト**（名刺で最終確認 **TODO**）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※第1回 Zoom 要約ベース。**数値・事例の対外転載は本人許諾を要する。**\n\n### 下辻 さん\n\n- **組織:** **株式会社hsネオプロジェクト**\n- **沿革:** 独立 **3年半**、**法人化から1年1ヶ月**（要約時点）\n- **事業:** **受託開発中心**（全体の **7〜7.5割**）。オンプレ→クラウド移行、需要予測システムなど**大規模案件**あり\n- **技術:** **PHP、JavaScript、Python、Unity、React Native**。**Laravel** 環境での開発が主流（要約）\n- **体制:** プロパー＋協力会社含め **約10名**。**全員に Claude Code 使用を必須化**（品質統一）\n- **AI活用:** **バイブコーディング**で開発工数 **約3割削減**、見積もりも **約3割下げ**て競争力を確保。外注はコアを任せず**パーツ単位**＋**コーディングルール**で品質担保\n- **スタンス:** 「**エンジニアにプライドを持っていない**」ため手を動かさず**営業・社長業**に徹できる — 組織拡大の要因（要約）\n- **業務改善実績:** 元**コールセンター部門DX担当**。紙・Excel横行現場をシステム・研修・フロー明確化で改善。**数千万円赤字を2年で黒字化**、売上 **200万円アップ**（要約）\n- **顧客獲得:** **士業紹介はほぼなし**（次廣と経路が異なる）。リテラシー・利益率が低い企業が多く、**補助金活用提案**で案件獲得。システムは通りにくく**多めに見積**するが、**複数通過**でリソース不足が課題\n- **ウェブ:** システムと**同単価**で受注でき**手離れが良い**収益性。**LP**を増やしたい。ウェブチームは**ほぼ1名**、各PJは社内エンジニアが管理\n- **BNI:** **カーネル**（約20名・B2B中心）\n- **AI懸念（本人見解）:** Anthropic の赤字、電力・原材料コスト、Claude の性能低下事例、サーバー買収によるリソース不足 — **高性能AIの持続性**に懸念。**企業レベル本格導入は10年程度先**の見通し。画像・動画生成AIはパケット消費で衰退傾向（要約）\n\n### 次廣側（このファイルのオーナー・参照）\n\n※[BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) と整合。\n\n- **形態:** **個人事業主**、SE歴 **26年目**、静岡県**藤枝市**、地域密着 **B2B** システム開発\n- **AI:** **Cursor・Claude Code** メイン。コーディングはほぼAI委任。**初心者のバイブコーディングは破綻リスク** — 下辻さんと認識一致\n- **顧客獲得:** 地元**信用金庫・税理士等の士業**紹介が中心。**補助金・助成金**案件から関係構築。小さな改善（ファイル名ルール等）から入り信頼を積む\n- **見積:** **ROI・効率化**の価値ベースへ移行したいが、規模・温度感で柔軟。**一人で年500〜600万×複数**が理想だが待てない案件もあり規模コントロールに悩み\n- **法人化:** 検討中だが**一人で回せる範囲**に現状満足の面も。下辻さんからは大企業取引・税・信頼で法人化メリットの助言\n- **協業課題:** **反射神経的対応**を他者に再現しにくく、基本**自分で全対応**\n- **BNI:** **DragonFly** 約50名、今期 **75人**目標\n\n---\n\n## ■ 初回セッション設計（アーカイブ・事前計画）\n\n※**第1回は実施済み**。実際の内容は **【第1回】** を参照。\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 田村さんへのお礼、目的、録画合意 |\n| 5〜25分 | **下辻さん** | 会社・体制・AI・顧客経路 |\n| 25〜45分 | **次廣** | 事業・事例・獲得パターン |\n| 45〜55分 | **同業論点** | AI・協業・法人化・案件規模 |\n| 55〜60分 | クローズ | 友達申請・協力体制 |\n\n### 同業向けヒアリング（第1回で多く確認済み）\n\n- [x] 受託比率・案件規模・スタック・体制\n- [x] 業務改善の入り方（コールセンターDX実績）\n- [x] AI 活用・Claude Code 必須化・3割工数削減\n- [x] 顧客獲得経路の差（士業 vs 補助金中心）\n- [x] 協業境界（パーツコーディング・API連携・案件ごと相談）\n- [ ] 紹介してほしい相手の3条件（明示リストは **TODO**）\n- [ ] 田村さん経由 SEO・FC 2名の紹介状況（**TODO**）\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（**2026-05-19 JST 14:00〜**、**Zoom**、終了時刻 **TODO**）。\n- **関係の質:** **同業**として AI・見積・業務改善・法人化まで深く対話。**協力体制**（下辻側の提案書複数通過時のリソース不足）を**案件確定時**に検討する合意。\n- **共通認識:** AIで **約3割**工数削減は両者実感。**設計・モック・提案資料**が特に効く。エンジニア完全不要論には不同意。**デザイナー・ライター仕事は減っておらず増加** — 信頼・仕上げは人間。\n- **差分・補完:** 士業チャネル（次廣◎・下辻△）、補助金提案（下辻◎）、ウェブ/LP収益（下辻）、大規模受託＋10名体制（下辻） vs 伴走・小さく入る現場改善（次廣）。\n- **次アクション:** 友達申請・継続情報交換（**近日**）。次廣は協力依頼時に**予算・タイミング**で提案準備。Religo `one_to_ones.id = 27`。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-19 実施済み（終了時刻 TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-19（火）JST 14:00–TODO**\n- **実施方法:** **Zoom**（文字起こし要約）\n- **Religo 1to1 レコード:** `one_to_ones.id = 27`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n**全体像**\n\n- 同業（受託開発・業務改善）として会社概要・AI活用・見積戦略・顧客獲得・BNI・協業可能性を相互共有。\n- **AI:** 両者とも Claude Code / Cursor 中心。工数・見積 **約3割**削減。設計・モック・提案資料で受注率向上。「秒でできる」ことで案件数増のメリット。ドキュメントはAI＋人間の読みやすさ調整。初心者のバイブコーディング破綻リスクは共有。\n- **AI持続性:** 下辻さんは Anthropic 赤字・インフラ・Claude性能低下・電力コスト等に懸念。次廣も運用リスクは認識。\n- **人材・仕事:** デザイナー・ライターはAI後も**仕事減らず増加**。「誰に頼むか」の信頼はAI代替不可。\n- **組織:** 下辻さんは法人・約10名・外注ルール化・社長は手を動かさない。次廣は個人・反射神経対応の再現困難・法人化は検討中。\n- **案件規模:** 次廣は一人で **500〜600万×複数**理想だが難しい案件も。下辻さん助言 — 一人なら **200〜300万×複数**が現実的、**600万以上は厳しい**。\n- **協業:** 設計済みの**部分コーディング**、**API連携**等の単発。見積・納期は**案件ごと相談**。\n\n**下辻さん側（会社・事業）**\n\n- 株式会社hsネオプロジェクト。独立3年半、法人化1年1ヶ月。受託 **7〜7.5割**。大規模（クラウド移行・需要予測等）。\n- 約10名、全員 Claude Code 必須。バイブコーディングで工数・見積各3割削減。\n- コールセンターDX出身。赤字→2年で黒字、売上+200万の改善実績。\n- 士業紹介は少ない。補助金提案型。見積多めだが複数通過でリソース逼迫。ウェブ・LPは収益性高く増やしたい。\n\n**次廣側（共有した要点）**\n\n- 藤枝・士業・信金紹介、補助金からの関係構築。小さな改善から入る伴走型。\n- **FC本部システム**（全国200店→500店予定）: Excel/スプレッドシートからReact Web化。通常600〜800万相当を **AIコーディングで約200万**（要約。**対外は許諾要**）。今後は価値ベース見積へ。\n- **防水工事:** 外国人多い現場、手書き日報→**LINE**入力、材料費・人件費集計。\n- **観光:** 山岳サイトはオープンWeather不十分→ジャパンWeather API（月3万）カスタムプラグイン。中部五市町**LINEビンゴ・スタンプラリー**。\n- 建設・製造など**リテラシー低い業界**向け「誰でも使える」仕組みが多い。\n\n**BNI・その他エピソード**\n\n- DragonFly 50→75目標。カーネル20名B2B。木村氏・中村氏等「買い物系」メンバー、立て岡氏（靴）は他チャプターへ移籍（要約）。\n- リファラル・トレーニングの**旅行**話で次廣が紹介約束したが未実現 — 本日想起。\n\n#### 決定事項・アクション\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| **下辻** | 提案書が複数通った場合のリソース不足に備え、次廣との**協力体制を検討** | **案件確定時** |\n| **次廣** | 下辻からの協力依頼に**予算・タイミング**に応じて提案準備 | **依頼時** |\n| **両者** | **友達申請**、継続的な情報交換・案件ベース協力 | **近日中** |\n\n#### 未解決・フォローアップ\n\n- 協力の**具体的見積基準・納期テンプレ**（案件ごと相談で合意済み、次回案件で実証）\n- 紹介してほしい相手の言語化（双方 **TODO**）\n- 田村さん経由 **SEO・FC** 紹介の進捗（**TODO**）\n- BO／RT 下辻さんとの**同一人物か**（**TODO**）\n- 初回**終了時刻**・Religo **id**\n\n---\n\n## ■ 累積インサイト（超重要）\n\n1. **同業でもチャネルが違う** — 士業×補助金（次廣）と、補助金提案×大規模受託×10名（下辻）は補完しうる。士業紹介を下辻さんに渡す文脈は弱いが、**リソース溢れ時のパーツ開発**は現実的。\n2. **AI3割削減は両者の現場感** — 差は「組織で Claude Code 必須化できるか」。次廣は個人で最大化、下辻は協力会社まで統一。\n3. **一人の案件上限** — 下辻さんの **200〜300万×複数** は次廣の規模感コントロールの参考値。600万超は協力か断る設計が必要。\n4. **ウェブ/LP** — 両者とも手離れ・収益性に同意。次廣がウェブを増やすなら下辻さんの運用知見が参考になりうる。\n5. **信頼は人間** — AI全盛でもデザイン・ライター・最終仕上げは「誰に頼むか」。BNI1to1の価値と一致。\n6. **見積は価値ベースへ** — 両者とも工数だけではなく ROI・補助金・効率化の語りが必要。下辻さんは「多め見積→複数通過」リスク、次廣は「安く出しすぎ」リスクの両面。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **協力:** いきなり共同受注より、**設計済みパーツ・API連携**から。次廣は「依頼時に提案できる状態」を維持（稼働枠の明示が信頼につながる）。\n- **紹介:** 建設・製造の**小さく入る改善**案件は次廣が主。下辻さんが溢れた**200〜300万未満の実装**やクラウド移行の一部は相談余地。\n- **田村さん:** 本1to1完了を田村さんに一言。**SEO・FC** 2名の紹介が下辻ルートか確認。\n- **法人化:** 下辻さんの助言をメモとして残し、大企業案件・税・信頼のトリガーが来たら再検討。\n\n---\n\n## ■ リファーラル戦略（BNI・クロスチャプター）\n\n- **次廣 → 下辻:** 大規模クラウド・需要予測クラスは下辻本線。次廣からは**オーバーフロー時の実装リソース**・士業経由の**補助金対象中小**の紹介（下辻の獲得パターンに合うか要確認）\n- **下辻 → 次廣:** 提案書複数通過時の**協力**。カーネル内で士業・中小改善ニーズがあれば次廣の伴走型が合う可能性\n- **DragonFly:** 買い物系・旅行アテンド未実現エピソード — 別チャプター移籍メンバー含め**紹介候補リスト**を整理すると RT の約束を回収できる\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 同業として技術・経営・AI・業界観まで率直。**AI持続性への懸念**は思想面でも話が合う。\n- 「エンジニアにプライドがない」＝手を離して組織を回す型。次廣の「自分で全部」型とは対照的で、**協業は役割分担が明確なとき強い**。\n- ウェブ収益性・LP増強 — 次廣の「ウェブの方が手離れも早そう」同意あり。温度感良好。\n\n---\n\n**関連:** [`1to1_tamura_kodai_money_cooking.md`](1to1_tamura_kodai_money_cooking.md) · [`BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md)','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(28,1,37,9,NULL,'83444991178','05lRf6XqSNu4hCFaDrAgGQ==','manual','2026-05-21 09:00:00','2026-05-21 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nakamura_keigo_shakumoto.md】\n\n# 1to1_中村啓吾_笏本縫製\n\n---\n\n**文書の位置づけ:** DragonFly メンバー・中村啓吾さんとの 1to1 を **1ファイルで時系列管理**する。ユーザー提供の **プロフィールシート画像群**・[笏本縫製／SHAKUNONE 公式サイト](https://shakumoto.co.jp/) を固定情報に統合し、**初回121台本**を事前用に記載する。  \n**整理:** tugilo（次廣 淳）と中村さんは、同じ **BNI DragonFly** チャプター。中村さんは元チャプタープレジデント・ビジターホスト統括など運営経験が深い。  \n**日時:** 第1回は **2026-05-21 実施済み**（開始・終了時刻は TODO。カレンダー／Zoom メタ確認後に YAML・【第1回】へ反映）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供の ONE to ONE シート・G.A.I.N.S.・略歴シート・直近顧客・コンタクトサークル・推薦のことば・Myプロフィール（dragonfly）ベース。[会社概要](https://shakumoto.co.jp/company/) で補足。\n\n### 人物・会社\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 中村 啓吾（なかむら けいご / Keigo Nakamura） |\n| **生年月日** | 1992年9月24日 |\n| **出身** | 京都市伏見区（伏見稲荷で有名） |\n| **現住所** | 岡山県津山市（B\'z・稲葉浩志さんの出身地）・居住9年 |\n| **会社** | [株式会社笏本縫製](https://shakumoto.co.jp/) |\n| **役職** | 専務取締役／**SHAKUNONE Project Leader** |\n| **所在地** | 〒709-4623 岡山県津山市桑下1333-6 |\n| **電話** | 090-1587-4929 |\n| **メール** | keigo.nakamura@shakumoto.co.jp |\n| **Web** | https://shakumoto.co.jp/ |\n| **BNI** | DragonFly 入会 **2022-09-06** |\n| **カテゴリー（現行・2026-04〜）** | **中小企業サポート** ／ 専門分野: **日本製ものづくり再興事業プロデューサー**（英: Necktie made by a craftsman in a town factory） |\n| **カテゴリー（変更前・〜2026-03）** | **ファッション・デザイン** ／ 専門分野: **町工場の職人が作るネクタイ** |\n| **カテゴリー変更の時期（名簿）** | **2026-04-07** 定例会参加者リスト（第204回）から現行表記。直前（3/24・第202回）まで旧カテゴリー。※変更の**本人の真意・意図**は121で確認（TODO） |\n| **チャプター役職（2026-05 名簿）** | 対面イベント・ビジターホストサポート（過去: プレジデント、ビジターホスト統括、書記兼会計補佐、ビジネスホストリーダー等） |\n\n### 会社・ブランド（サイト・シート統合）\n\n- **創業:** 1968年（自宅一室）。約半世紀の縫製ノウハウ。代表取締役・笏本達宏。従業員約10名。\n- **専門:** ネクタイ・ポケットチーフ・スカーフ。裁断〜縫製〜検品〜出荷まで **社内一貫**。\n- **オリジナルブランド:** **SHAKUNONE（笏の音）** — 2015年立ち上げ。**日本で縫製工場が直接立ち上げた唯一のネクタイブランド**（本人シート表現）。丹後絹・甲斐絹など高級絹を使用。\n- **関連ブランド／導線:** [つやまスーツ（tsuyama suit）](https://shakumoto.co.jp/)、オンラインショップ（NCAS Net Shop リンクあり）、コンセプト **「人に会いたくなる一張羅」**／**「縫製は、かっこいい。」**\n- **ビジネスモデル:** コロナ前は OEM 7割・自社ブランド 3割 → **2023年以降は自社ブランド主導に逆転**。百貨店（阪急メンズ大阪・東京、名古屋高島屋等）、オーダースーツ店卸、有名ブランド向けOEM、オンライン、記念ネクタイ（卒業式等）も。\n- **他社にない強み（シート）:** 裁断から出荷まで自社完結／工場直結の国内唯一クラスのネクタイブランド／30代代表で **日本最年少のネクタイ縫製工場社長**（サステナブル訴求）／小ロットからのオリジナルネクタイ。\n\n### 経歴・家族（略歴・ONE to ONE）\n\n- **2015/3** 大阪工業大学卒\n- **2015/4–2016/12** 大鉄工業（JR西日本 京都–大阪間 保線・現場監督）\n- **2016/12** 津山へ移住・結婚（妻は教員）\n- **2017/1–2020/3** 山陽道路工業（道路標識・ガードレール等・現場監督）\n- **2020/3** 笏本縫製入社\n- **2019/6** 長男・翔琉（6歳）、**2021/3** 長女・美結（4歳）\n- **配偶者:** 悠衣（32）・中学校・高校の養護教諭\n- **資格:** 測量士補、2級土木施工管理技士、色彩検定（学習中）\n- **趣味:** DIY（ピザ窯・BBQテーブル・「公園」建設）、家庭菜園、ボウリング最高265、筋トレ（ベンチ100kg目標）、子どもの英語教育（DWE）\n- **成功の鍵:** 謙虚であること\n- **人に知られていないこと:** 4歳の娘への溺愛\n\n### G.A.I.N.S. 要約\n\n| 区分 | 内容 |\n|------|------|\n| **Goal** | ① **2025年9月まで**に全国47都道府県のオーダースーツ店と接点（**2025年10月時点 25/47**） ② 自社ブランド **SHAKUNONE 年間1万本** 販売 |\n| **Accomplishments** | 2015 SHAKUNONE 立ち上げ／クラファン3回成功／阪急メンズ等ポップアップ／2020 マスクで存続／2022 **Mr.サンデー** 出演・Yahoo!ニュース1位／売上構成の逆転（自社ブランド主導） |\n| **Interests** | 筋トレ（自宅ジム・ベンチ100kg）、子どもの英語教育 |\n| **Networks** | BNI U35（第3木曜13:00）、BNI 47project（第3火曜19:00）、津山YEG（義理の兄が所属） |\n| **Skill** | 測量士補、2級土木施工管理技士、色彩検定（学習中） |\n\n### 直近10件の顧客（シート）\n\n1. 全国一般顧客（オンラインショップ）\n2. オーダースーツ店（SHAKUNONE 卸・別注）\n3. 百貨店（岡山県内中心）\n4. ビジネスシャツメーカー（OEM）\n5. ネクタイメーカー（有名ブランド向けOEM）\n6. ネクタイ専門店（店舗オリジナルブランドOEM）\n7. 観光地店舗（門司港・福岡）SHAKUNONE 卸\n8. 名門校（卒業記念ネクタイ）\n9. 社長個人（絆創膏工場など小規模製造）\n10. 保険営業員（個人販売）\n\n**流入:** Instagram・Twitter、Web問合せ、**BNIメンバーからの紹介**。提供: SHAKUNONE ネクタイ、他ブランド指定のOEM。\n\n### コンタクトサークル\n\n**Top3:** オーダースーツ業／衣料小売業／カラーコンサルタント\n\n**全体（10）:** オーダースーツ、パーソナルスタイリスト、パーソナルカラー、イメージコンサル、オーダーシューズ、オンラインスタイリング、写真家、メンズアクセサリー、ビジネスマナー講師、ブライダル関連\n\n### お客様になりやすい人・紹介の切り口（ONE to ONE）\n\n- かっこいいネクタイを着たい一般の方\n- オリジナルネクタイをまとめて作りたい団体・グループ\n- 全国のオーダースーツ店\n- **話の切り出し例:** 「小ロットからオリジナルネクタイが作れる人を知っている」「会社PR用にロゴ入りネクタイを作りたい」\n\n### リファーラル欄（シート）\n\n- 他の紹介提供者・質の高い紹介・不適切な紹介 → **シート上は未記入**（121でヒアリング）\n\n### チャプター内での人物像（推薦のことば・抜粋）\n\n- **リーダーシップ:** 元プレジデント、ビジターホスト統括、書記兼会計補佐、プレゼンコーチ。子育て中でも深夜対応・代理出席・運営を支える。\n- **人物:** 素直・誠実・働き者。観察力が高く、メンバーの状態に敏感。スピード感（「やりたい」を即実行）。本質を突くアドバイス。フォローアップが丁寧。\n- **哲学:** 「すべては経験」（柿ノ木氏とのエピソード）。謙虚さを成功の鍵とする。\n- **ビジネス:** メンバー向けにネクタイ選定・トンボ柄ギフト・ポップアップ案内。津山スーツへの期待の声あり。\n\n---\n\n## ■ サイトコラム分析（[INFORMATION](https://shakumoto.co.jp/column/information/)）\n\n**確認範囲:** 一覧 **18ページ分**（各ページ約10〜12記事）＋ [コンセプト](https://shakumoto.co.jp/concept/) ＋ 特集（コラボレーション／ネクタイプレゼント）。執筆の中心は **代表・笏本達宏（プロダクトマネージャー／「ネクタイ王子」「シャクモト」）**。中村専務の121では **「会社・ブランドの思想」** として参照し、**中村さん自身の言葉との接続** を聞く。\n\n### コンテンツの全体像（何を発信しているか）\n\n| 柱 | 内容例 |\n|----|--------|\n| **思想・ストーリー** | 日本製を諦めない、祖母からの針と糸、町工場の誇り、家業継承のリアル |\n| **商品・技法** | ネクタイ選び・結び方・メンテナンス、origami技法、シルク産地（丹後・甲斐・山梨職人） |\n| **贈答・シーン** | 父の日、クリスマス、就職・新卒、冠婚葬祭、年齢別プレゼント、彼氏・夫へ |\n| **販売・運営** | ECフロー、FAQ、ギフト梱包有料化、オンラインショップ刷新、予約受注（ハンカチ3日1.5万点） |\n| **コロナ期の転換** | 布マスク（まかない／剣道面KEN-to-01）、メディア・Yahoo!1位、マスク価格改定の説明 |\n| **B2B・協業** | THE SUIT COMPANY 全国コラボ、オーダースーツ店連携、OEM縫製依頼、アンバサダー募集 |\n| **横展開** | つやまスーツ、リボンシュシュ（社長のドジから生まれた）、鞄コラボ、播州織ハンカチ |\n| **顧客対話** | 仕立て直し相談、汚れトラブル、購入者エピソード（実名は伏せて記事化） |\n\n**カテゴリー（サイト側）:** ネクタイの選び方／プレゼント意味／縫製工場にできること／made in Japan ブランドとは／ECとお店／コラボ 等 **SEO＋教育コンテンツ** が厚い。\n\n### 根幹にある「思い」（要約）\n\n1. **ネクタイ＝「大切な人を想う」行為**  \n   仕事・贈答・祝福・悲しみ。派手な個性ではなく **着る人が魅力的になる** 一本。胸元は **第0.5印象**（画面越しのZOOM時代にも言及）。\n\n2. **愛されるブランドは理屈より距離**（[コンセプト](https://shakumoto.co.jp/concept/)）  \n   職人が店頭に立ち **生の声** を聞く → 直感と技術 → 「静かな迫力」。D2Cは **作り手にユーザーの声が届かないOEM構造を変える** ため。\n\n3. **「縫製は、かっこいい」／日本製を諦めない**  \n   2025年9月の [「日本製を諦めない──私たちが守り、紡ぐもの」](https://shakumoto.co.jp/column/information/) — 安価な海外製品の中で、**57年・祖母の手からの糸** を今も手に。カテゴリー **「ものづくり再興事業プロデューサー」** と文言が一致。\n\n4. **挑戦と誠実**  \n   - 「成功の反対は失敗ではなく **やらないこと**」（2025.02）  \n   - ブランド発信で伝えたい3つ（町工場／…／…）— 小ささを隠さない  \n   - お詫び・再販説明・ギフト梱包有料化 — **コストと価値を正直に伝える**  \n   - 予約販売は **順番通り・特別扱いしない**（マスク混雑期）\n\n5. **危機を製造力で乗り越える**  \n   コロナで「縫製工場が殺される」危機感 → マスク・剣道面で **技術転用** → Mr.サンデー（2022）・SNSフォロワー1万超 → その後 **自社ブランド比率逆転**。ハンカチ再受注は **SNS共創型**（3日・約6,000件・15,000点超）。\n\n6. **町工場・家業のリアル**  \n   20代で「田舎の縫製工場はダサい」と笑われたが継承、美容師志望→家業、いじめ経験、妻・SNSと家庭の話。**人間味** を隠さない発信。\n\n7. **つながりで広げる**  \n   青山商事 THE SUIT COMPANY 全国コラボ、西陣シルク、山梨の織物職人（「ブランドを作る」と言った無名工場時代）、鞄屋5代目、Lomy.s（布ナプキン）など **「守り・紡ぐ」同盟**。\n\n### 中村さん・121との接続（コラムから読み取れる問い）\n\n- カテゴリー変更は、コラムの **「ネクタイメーカー」→「日本製ものづくりの再興を語るプロデューサー」** への発信拡大と **同じ方向** に見える。中村さんは **現場・営業・チャプター** 側からどう位置づけているか。\n- コラム執筆は笏本代表が中心。**専務・中村** の役割（47都道府県スーツ店、OEM、対面イベント）はコラムに出てこない → **121で補完**。\n- 共感フック例: 「日本製を諦めない」／「やらないことが本当の失敗」／ハンカチ **共創型受注** の運営負荷／EC刷新（もっと日本製を届けるための道の再整備）。\n\n### 121で触れてよいコラム話題（短いアイスブレイク）\n\n- [ダブルガーゼハンカチ Season3](https://shakumoto.co.jp/column/information/)（2026.02・3日限定再受注の反響）\n- 「日本製を諦めない」記事（ものづくり再興カテゴリーとの接続）\n- リボンシュシュ（ネクタイシルクの余り・社長のエピソードから生まれた商品）\n- つやまスーツ東京オーダー会（代官山・完全予約制）\n\n---\n\n## ■ メインプレゼン（2026-05-26）・リハーサルメモ\n\n**本番:** 定例会 **2026-05-26（火）** メインプレ担当（チャプター週次メモ・木村健悟さんと同日の記載あり。中村さんの枠・順番は当日運営要確認）。\n\n**リハーサル:** 次廣が **先日参加**（正式日時はカレンダー／Zoom で **TODO**）。\n\n### 中村さんが強調していたこと（事実メモ）\n\n- **「コンサルをしようとしているのではない」** と明言されていた（リハーサル時・中村さん発言として記録）。\n- **読み取り（121・紹介用）:**\n  - カテゴリー **「中小企業サポート」** や **「ものづくり再興事業プロデューサー」** を、**経営コンサル・課題診断屋** と誤解されないようにしたい意図が強い可能性。\n  - 本体は **笏本縫製／SHAKUNONE／縫製・製造・ブランド・OEM・つやまスーツ**。**プロデューサー＝ものを作り・届け・つなぐ** 側のイメージで聞くのが安全。\n  - コラムの **「日本製を諦めない」「職人・工場の声」** は **思想・製造の物語** であり、**コンサルティングサービス** ではない（§サイトコラム分析と整合）。\n\n### 121・紹介で避けるフレーミング\n\n| 避けたい | 代わりに |\n|----------|----------|\n| 経営コンサル、課題診断、伴走コンサル | **日本製ネクタイ・縫製工場・小ロット別注・OEM・ブランド SHAKUNONE** |\n| ものづくり再興＝アドバイス業 | **ものづくり再興＝作る・売る・つなぐ・ストーリーを届ける**（本人の定義を121で確認） |\n| 士業・コンサル向けの「顧問」文脈だけで紹介 | **オーダースーツ店・衣料小売・記念品・法人ノベルティ・ファッション** |\n\n### 121で確認する一言（リハーサルへの接続）\n\n> 「リハーサルで、コンサルではないとおっしゃっていたのが印象に残っています。**『プロデューサー』とおっしゃるとき、僕たちが紹介するときに一番ズレない言い方**はどう伝えるのがよいですか？」\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** **第1回 1to1 実施済み**（2026-05-21、正式時刻 TODO）。プロフィール・サイト・コラム・メインプレリハーサル文脈を踏まえ、次廣の事業、中村さんの新カテゴリー、今後の協業可能性を相互確認した。\n- **主な成果:** 次廣の **AI活用・業務改善システム構築**、BNI 入会経緯、主要実績、予約管理システムの開発状況、料金体系パッケージ化の課題を中村さんに共有。中村さんからは、新カテゴリー **「日本製ものづくり再興事業プロデューサー」** の真意、コンサルではなく **日本製の良いものを作る町工場のチーム形成・共同プロモーション** を目指す構想が共有された。\n- **合意事項:** 中村さんが **宮城氏（トレスステラ）** と次廣をつなぐ。予約システム同士のバッティング可能性はあるが、知見共有と協業可能性の確認を優先する。\n- **協業の芽:** 中村さんのチーム参加企業（現在16社）には、業務改善・AI導入・予約／受注管理などの潜在ニーズがある。DragonFly メンバー紹介も含め、**ものづくり企業の実務改善** で連携余地あり。\n- **次アクション:** 中村さんは宮城氏を紹介。次廣は予約管理システムを夏までにリリースし、料金体系の入口・パッケージ化を検討。中村さんはメインプレゼンで **コンサルではないこと** が伝わるようカテゴリープレゼンを改善。\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n※第1回実施後も、**事前台本・再現用メモ** として保存する。\n\n**進行イメージ:** お互い「事業紹介 → 質疑応答」がだいたい各30分（合計60分前後）。  \n**中村さんは元プレジデント** のため、ギバーズ精神で **新メンバー・後輩側の話を先に聞く** 進行になりやすい。**冒頭で進行を確認し、言われた順でOK。**\n\n### 時間の配り方（2パターン）\n\n**パターンA（想定メイン）— 次廣先 → 中村さん**\n\n| パート | 内容 | 目安 |\n|--------|------|------|\n| オープニング | あいさつ・進行の合意 | 約3分 |\n| 前半 | **次廣の事業紹介** → 中村さんから質問 | 約30分 |\n| 後半 | **中村さんの事業紹介** → 次廣から質問 | 約30分 |\n| クロージング | 紹介・次アクション・（任意）プレゼン一言アドバイス | 約2〜5分 |\n\n**パターンB（標準）— 中村さん先 → 次廣**\n\n| パート | 内容 | 目安 |\n|--------|------|------|\n| 前半 | 中村さんの事業紹介 → 次廣から質問 | 約30分 |\n| 後半 | 次廣の事業紹介 → 中村さんから質問 | 約30分 |\n\n### 0. 事前にサイトで押さえておく話題（雑談・共感用）\n\n- [トップ](https://shakumoto.co.jp/)の **「人に会いたくなる一張羅」**、[コラム INFORMATION](https://shakumoto.co.jp/column/information/)（**§サイトコラム分析** 参照）。\n- **共感の核:** [「日本製を諦めない」](https://shakumoto.co.jp/column/information/)（2025.09）→ カテゴリー変更の **`ものづくり再興`** と接続して質問可。\n- ダブルガーゼハンカチ Season3（3日・約6,000件・15,000点超・SNS共創）→ **受注オペレーション** に触れられる。\n- **つやまスーツ**、**SHAKUNONE ORDER SUIT** → ネクタイ以外への拡張。\n- [コンセプト](https://shakumoto.co.jp/concept/)の **「お客様との距離感」「理屈じゃない」** → プレジ・ビジター運営の「人の声を聞く」と通じる。\n- **リハーサル:** 「コンサルではない」発言 → **§メインプレゼン・リハーサルメモ** の確認質問につなげる（押し付けず1問）。\n\n### 1. オープニング（信頼の橋）\n\n> 「中村さん、本日はお時間ありがとうございます。DragonFly の次廣です。  \n> プロフィールシートと [shakumoto.co.jp](https://shakumoto.co.jp/) を拝見しました。先日のメインプレリハーサルにも参加させていただき、『コンサルではない』というお話、と **ものを作って届ける側** という姿勢が伝わりました。  \n> 今日は、紹介するときにズレない言い方を含めて、お互いの事業を理解できればと思っています。**進め方は中村さんのご都合に合わせます。** 先に僕からでも、先に笏本さんのお話からでも、どちらでも大丈夫です。どう進めましょうか？」\n\n**中村さんが「先に次廣さんから」と言ったとき**\n\n> 「ありがとうございます。では先に、僕の仕事を短くお話しします。そのあとぜひ、SHAKUNONE や紹介してほしい方のお話を詳しく伺わせてください。」\n\n**中村さんが「先にうちから」と言ったとき**\n\n> 「ありがとうございます。ぜひ先に、中村さんのお仕事を教えてください。後半で僕の方もお話しします。」\n\n**チャプター運営への敬意（短く・押し付けない）**\n\n> 「プレジデントやビジターホストのとき、いつもメンバー想いの動きを拝見しています。今日は運営の話より、事業と紹介を中心にできればと思います。」\n\n---\n\n### 2A. 前半（パターンA）：次廣の事業紹介〜中村さんから質疑\n\n※**想定メイン。** 元プレジが「先にあなたの話を」と促したらこのブロックから入る。\n\n**紹介のたたき（Living Document 準拠・5〜8分）**\n\n> 「僕は tugilo という屋号で、**Excel や LINE、紙、バラバラのツールに散らばった業務**を、現場の流れに合わせて小さくシステム化しています。  \n> 既製品をそのまま入れるより、**一回の入力で見積・現場・請求まで回る**形を、製造業・建設・FC・サービス業の経営者向けに作ることが多いです。  \n> 最近は AI も使って、問い合わせ整理、案件管理、PDFや表の転記を減らす仕事をしています。  \n> DragonFly では、**売上は伸びているのに、現場の手作業と二重入力が限界**の経営者や、その顧問の士業・コンサルの方からの紹介が多いです。  \n> ※僕の仕事は **経営コンサルではなく、現場に合わせたシステムづくり** です。中村さんのお仕事とも、**作る・届ける・回す** で役割が違うと理解しています。」\n\n**中村さんに聞かれそうなら補足（短く）**\n\n- 入会約2ヶ月・グラデュエート取得。脳梗塞の経験から **ミーティング記録をAIで整理** している。\n- 増本さんFC（200→500店）、防水工事のLINE日報、解体業の見積〜請求など **小さく始めて育てる** 開発。\n\n**中村さんからの質問を促す**\n\n> 「笏本さんのように、受注チャネルが複数あるときの進捗管理など、刺さるかどうかは後で伺えればと思います。いま、気になる点や『こういう人に紹介できそう』があれば、遠慮なく聞いてください。」\n\n**プレジ経験者への一言（任意・後半前でも可）**\n\n> 「中村さんはプレゼンやビジターの見方にも詳しいと思うので、後半のあと、僕のウィークリーの伝え方で **1点だけアドバイス** をいただけたらうれしいです。」\n\n---\n\n### 2B. 後半（パターンA）／前半（パターンB）：中村さんの事業紹介〜次廣から質疑\n\n**入り（傾聴）**\n\n> 「鉄道の保線や道路の現場監督から、2020年に笏本縫製に入られて専務取締役まで、という経歴はシートで拝見しました。いま中村さんがいちばん力を入れているのは、SHAKUNONE のブランド販売と、OEM、それともつやまスーツのどちらに近いですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n**カテゴリー変更（真意・121で優先して聞く）**\n\n※名簿上は **2026年4月頃** から `中小企業サポート`／`日本製ものづくり再興事業プロデューサー` へ。旧: `ファッション・デザイン`／`町工場の職人が作るネクタイ`。\n\n**入り（さりげなく・批判的にならないトーン）**\n\n> 「最近、カテゴリーが **中小企業サポート** と **日本製ものづくり再興事業プロデューサー** に変わっているのを拝見しました。リハーサルでは **コンサルではない** とおっしゃっていたので、**経営助言ではなく、製造・ブランド・つなぎ** のイメージで合っているか、教えていただけますか？」\n\n**深掘り（必要なぶんだけ）**\n\n- 「**なぜ今のタイミング**で変えられましたか？ 売上構成の逆転（自社ブランド主導）や、つやまスーツ、47都道府県の目標と関係はありますか？」\n- 「**プロデューサー** は、ネクタイ以外のものづくりにも広げる意味ですか？ それとも笏本縫製の **作る・届ける・ストーリーを伝える** 側で、**コンサルや診断とは線を引きたい** という理解でよいですか？」\n- 「**中小企業サポート** というカテゴリー名で、チャプター内に **誤解されやすいこと** はありますか？ リハーサルでおっしゃった『コンサルではない』に近い例があれば教えてください。」\n- 「**ファッション・デザイン** のときと比べて、**紹介してほしい相手のイメージ**は変わりましたか？ コンタクトサークルの Top3（オーダースーツ・衣料小売・カラー）はそのままですか？」\n- 「僕が紹介するとき、**『ネクタイの工場』** と **『ものづくり再興のプロデューサー』** どちらを入口にした方が、中村さんの意図に合いますか？」\n- 「ウィークリーやメインプレ（5/26予定）では、**新カテゴリーに合わせた伝え方**に寄せていますか？ うまくいっている一言があれば教えてください。」\n\n**聞いたあとメモすべきこと**\n\n- 変更の主目的（紹介の幅／ブランド／OEM／中小製造業支援／チャプター内差別化 等）\n- 紹介文の **推奨フレーズ1つ**（旧カテゴリー表現は使わない方がよいか）\n- 逆に **ネクタイ特化** で紹介してほしい場面があるか\n\n**ブランド・製造**\n\n- 「SHAKUNONE を **年間1万本** にするために、いま一番のボトルネックは製造・販路・認知のどれに近いですか？」\n- 「**47都道府県のオーダースーツ店** は25都道府県まで進んでいるとのことですが、残り22で特に欲しいエリアや、『この県に1店舗あれば十分』という基準はありますか？」\n- 「小ロットのオリジナルネクタイは、だいたい何本から・どのくらいの納期・単価感でお話しできますか？（紹介時に聞かれそうなので）」\n- 「百貨店・クラファン・テレビ出演のあと、**自社ブランド7割超** に逆転された要因は何でしたか？」\n\n**紹介・顧客**\n\n- 「直近のお客様リストでは、オンライン、オーダースーツ店、OEM、卒業記念、個人販売など幅があります。**いま一番増やしたい紹介**は、コンタクトサークルの Top3（オーダースーツ・衣料小売・カラーコンサル）のどれに近いですか？」\n- 「**BNIからの紹介**は、どんな相談が多かったですか？ うまくいった例と、逆にミスマッチだった例があれば教えてください。」\n- 「**質の高い紹介**と、**紹介しない方がよい相談**を、今日の時点で1つずつ教えていただけますか？（シートが空欄なので）」\n- 「僕が第三者に中村さんを紹介するとき、**一言で伝えるとズレが少ない**言い方はありますか？」\n\n**つやまスーツ・拡張**\n\n- 「サイトの **つやまスーツ** は、ネクタイ顧客への横展開ですか？ それとも別チャネル向けですか？」\n- 「記念ネクタイ（学校・企業PR）の相談は、デザイン確定から納品まで、どこを中村さんが窓口にされますか？」\n\n**紹介文の確認**\n\n> 「たとえば、『岡山・津山の縫製工場が作る、小ロットから対応できる日本製ネクタイ。オリジナルブランド SHAKUNONE と、百貨店・有名ブランド向けOEMの両方がある』という紹介の仕方は、中村さんの感覚に合っていますか？」\n\n**中村さん向けの接続（押し付けない・後半の締め前）**\n\n> 「笏本さんのように、**受注が一気に増えたとき・複数チャネル（百貨店・卸・EC・OEM）** の進捗や在庫、別注管理で、表やLINEに情報が散らばって困る、という話はありますか？  \n> もしあれば、どの工程から手を付けると一番楽になるか、一緒に整理するのは僕の仕事と相性があるかもしれません。今日はまず、必要かどうかだけ教えてください。」\n\n---\n\n### 3. パターンB用：後半＝次廣の事業紹介\n\n※中村さんが先に話す進行のときのみ。本文は **§2A と同一**（コピーせず §2A を後半として実施）。\n\n---\n\n### 4. 協業・紹介の可能性を探る一言（どちらのパターンでも終盤）\n\n> 「中村さんのコンタクトサークルにある、**オーダースーツ・スタイリスト・写真家・ブライダル** の方は、僕の周りにも士業・コンサル・制作系があります。  \n> 逆に、**製造業・小ロットものづくり・記念品・法人のノベルティ** で『日本製で相談できる工場』を探している方がいたら、中村さんに相談してよいか、紹介前の確認事項を教えてください。」\n\n**DragonFly 内の具体候補（会話のたたき台・名前は当日の関係で調整）**\n\n- **オーダースーツ・ファッション系:** チャプター内カテゴリー照合（紹介前に中村さんのOKを取る）。\n- **保険・個人販売:** 直近顧客に保険営業員あり → 竹内さん等との接点は **ギフト・ノベルティ文脈** で聞く。\n- **印刷・ノベルティ:** 芳賀さん・木村さん（倉敷屋）等、**ロゴ入り・小ロット** の相談が刺さるか。\n- **Web・EC:** 竹内（EC）、倉持（WEB）— 中村さん自身がWebまわりをサポートした経験あり、**協力の仕方** を聞く。\n\n### 5. ギバーズ（紹介の聞き方）\n\n> 「今日の時点で、中村さんにとって **いちばんありがたい紹介を1つ** に絞ると、オーダースーツ店、衣料小売、カラーコンサル、記念ネクタイの団体のどれに近いですか？  \n> 紹介の前に、僕が相手へ確認しておくべきこと（本数・納期・予算・デザインの有無）があれば教えてください。」\n\n**中村さんからのフィードバックをもらう（運営・プレゼンに詳しい方へ）**\n\n> 「もしよければ、僕のウィークリーや紹介の伝え方で、**ビジターにも伝わる言い方** にするコツを1点だけアドバイスいただけると嬉しいです。」\n\n※**次廣先で話した場合**は、このフィードバック依頼を **クロージング直前** に回すと自然（すでに自分の話を聞んだ前提）。\n\n### 6. クロージング\n\n**パターンA（次廣先）向け**\n\n> 「今日はありがとうございました。先に僕の話を聞いていただき、ありがたかったです。SHAKUNONE や47都道府県のお話、紹介の引き出しがかなり増えました。  \n> 内容を整理して、紹介できそうな方を確認します。5月のメインプレの前後でも、またお話しできればうれしいです。」\n\n**パターンB（中村さん先）向け**\n\n> 「今日はありがとうございました。工場直結のブランドと、全国のスーツ店ネットワークのお話、紹介の引き出しがかなり増えました。  \n> 内容を整理して、紹介できそうな方を確認します。次に繋がれそうな方がいれば、改めてご相談させてください。」\n\n**実施直後に自分メモ（チェックリスト）**\n\n- [ ] **カテゴリー変更の真意**（なぜ今・プロデューサーの意味・**コンサルではない** の線引き・紹介の入口）\n- [ ] 質の高い紹介／不適切な紹介の定義\n- [ ] 小ロット・納期・価格の目安（紹介用）\n- [ ] 47都道府県進捗・優先エリア\n- [ ] 業務システムニーズの有無（受注・OEM・EC）\n- [ ] 相互紹介候補3名以内\n- [ ] 次回・フォロー方法\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-21 実施済み（正式時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-21（木）JST TODO–TODO**（開始・終了時刻はカレンダー／Zoom メタで確認）\n- **実施方法:** TODO（対面 / Zoom）\n- **参加者:** 次廣 淳、中村 啓吾\n- **Religo 1to1 レコード:** `one_to_ones.id = 28`（**1セッション＝DB 1行**。正式時刻は TODO のため `scheduled_at = null`）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] マーカーは本文では省略。\n\n**全体像**\n\n- 次廣のシステムエンジニアとしての事業内容、BNI 入会の経緯、今後の協業可能性について相互理解を深めた。\n- 特に、予約管理システムの開発状況、料金体系のパッケージ化の必要性、宮城氏（トレスステラ）との協業可能性について具体的に議論した。\n- 中村さん側からは、笏本縫製／SHAKUNONE の事業概要、新カテゴリー **「日本製ものづくり再興事業プロデューサー」** の意図、コンサルではなく町工場チームとして日本製の価値を広げる構想が共有された。\n\n**決定事項・合意内容**\n\n- **宮城氏（トレスステラ）との接続:** 中村さんが、LINE 予約システム **「リピモ」** を提供する宮城氏と次廣をつなぐ。\n- **予約システムの情報交換:** 次廣の汎用予約管理システムと、宮城氏のリピモはバッティングする可能性があるが、知見共有を優先する。\n- **メインプレゼン改善:** 中村さんは、来週予定のメインプレゼンで **コンサルではないこと** がより伝わるよう、カテゴリープレゼンを改善する。\n- **継続連携:** 中村さんのチーム参加企業に業務改善ニーズがあるため、AI導入支援・業務改善システム構築で DragonFly メンバー含め連携を深める。\n\n**次廣側の事業概要**\n\n- **拠点:** 静岡県藤枝市。ほぼオンライン完結で全国の経営者と取引。\n- **経歴:** 外国語学部卒業後、インターネットブームをきっかけにシステム業界へ転身。SE 歴25〜26年。30歳で独立し、地元に戻って事業展開。\n- **業務形態:** 一人親方として、営業・開発・納品・運用保守まで一貫対応。\n- **強み:** 専門用語に頼らず、現場の業務を人間の言葉で理解し、既存システムを押し付けずワークフローに寄り添って設計する。\n- **AI活用:** AIとの協業により、この1〜2年で業務効率が大幅に向上。時間が生まれ、BNI 活動に参加できる状態になった。\n- **方針:** 小さく始めて確実に改善し、誰でも回せる仕組み・少人数で済む仕組みを作る。\n\n**BNI 入会の背景**\n\n- **入会時期:** 2026年3月（面談時点で約2ヶ月）。\n- **紹介者:** 増本氏から長年誘われていた。\n- **事前接点:** ビジター参加を重ね、宮城氏や平岡氏とも既に面識があった。\n- **入会のきっかけ:** AI 協業で時間が生まれ、「忙しいから無理」という言い訳を克服。信頼関係の中で紹介が生まれる BNI の理念に共感した。\n- **活動状況:** 4月はトレーニング漬けで多忙。5月から落ち着いて振り返り、再受講も検討。中村さんからは **「2回目、3回目で新たな気づきがある」** とアドバイス。\n- **メンバーサポート:** DragonFly メンバーは親身。平山氏と船津さんがメンターとして支援し、増本氏とはビジビリティ向上について継続相談。\n\n**主要プロジェクト事例**\n\n1. **フランチャイズ事業の業務改善（増本氏案件）**\n   - **課題:** 全国200店舗規模のFCで、Google フォームとスプレッドシートで注文管理。顧客管理、対応記録、作業管理が別シートで、同じ情報を何度も入力。属人化により担当者不在時の対応が困難。\n   - **解決:** 注文から発送までを Web 上で一元管理。確認の手間を削減し、誰でも回せる体制を構築。500店舗への拡大を見据えて設計。\n\n2. **防水工事業の日報システム**\n   - **課題:** 外国人職人が多く、手書き日報の文字が読めない。集計時の転記作業が負担。現場状況の即時把握が困難。\n   - **解決:** LINE で日報提出できる仕組みを構築。材料使用量、人数、作業内容を日本語で入力可能にし、現場ごとの人件費・材料費を確認しやすくした。請求時の集計作業も効率化。\n\n3. **観光協会のスタンプラリー**\n   - 静岡の観光協会と連携し、10年継続中のプロジェクト。中部5市2町を周遊するイベントで、LINE から参加・スタンプ収集・プレゼント応募まで完結。\n\n4. **動物園の予約管理システム**\n   - 従来は開園前に並ぶ必要があったが、LINE で予約可能に。電話対応の負担を LINE に集約し、受付業務を軽減。\n\n**今後の事業展開と課題**\n\n- **予約管理システム:** 汎用的な予約管理システムを開発中。完成度は約80%、夏までにリリース予定。\n- **特徴:** 従来の「顧客目線」ではなく **事業者目線** の予約管理。30分の空き時間を無駄にせず、事業者側から **「何日に空いているか」** を提案する形式。\n- **料金体系の課題:** 完全カスタム対応のため都度見積もりが必要で、紹介しにくい。業務改善システムは基本的に3桁万円規模になりやすい。\n- **改善方向:** フロント・ミドル・バックエンドのパッケージ化が必要。船津さんからも同様のアドバイスを受けている。入口を低くする重要性を認識しつつ、家族の時間を犠牲にしない範囲で対応する。\n\n**宮城氏（トレスステラ）との協業可能性**\n\n- 宮城氏は、月額1,100円（税込）の LINE 予約システム **「リピモ」** を提供。ホットペッパービューティーのような機能を LINE 公式上で実現する仕組み。\n- 代理店制度があり、導入サポートで追加収益の可能性もある。\n- 次廣の予約システムとバッティングする可能性はあるが、同業者・周辺事業者との協業実績（デザイナー、コウタ氏など）もあり、まずは知見を広げるために話を聞く方向。\n\n**理想的な紹介先（次廣）**\n\n- **業務改善の必要性を感じている企業:** Excel 管理に限界を感じている、同じ内容を何度も入力している、特定の人しか分からない業務がある、業務改善を後回しにしている。\n- **成長企業:** 売上は伸びているが、現場の仕組みが追いついていない会社。\n- **理想的な紹介者:** 顧問先を持つ税理士やコンサルタント。\n- **現在の獲得チャネル:** 人からの紹介が中心。銀行や税理士からの紹介、保守を通じた継続関係が多い。今後は BNI と派生リファーラルで紹介拡大を狙う。\n\n**中村さん側の事業紹介**\n\n- **会社:** 株式会社笏本縫製（要約上「尺元」と表記揺れあり。本ファイルでは正式表記に統一）。\n- **業種:** ネクタイ・スカーフの縫製工場。工場兼ショップ形式。\n- **経営陣:** 代表39歳、中村さん34歳と、縫製業界では若い。\n- **強み:** 日本でネクタイを生産可能な縫製工場は10社未満。裁断・縫製・検査・発送まで一貫対応。縫製工場としては唯一クラスの自社ブランド（B2C）展開。若さ自体も業界での強み。\n\n**新カテゴリー: 日本製ものづくり再興事業プロデューサー**\n\n- **変更時期:** 2026年4月頃からカテゴリー変更（要約では2025年4月表記あり。参加者リスト上は2026年4月から現行表記）。\n- **目的:** SNS 発信を強化し、日本製の価値を伝える。良いものを作る町工場を集めてチームを形成し、販売会を通じて共同プロモーションする。\n- **重要な線引き:** **コンサルティングではない。** チームとして日本製の価値を広げ、参加企業全体が盛り上がることで、それぞれが恩恵を受ける構想。\n- **ビジネスモデル:** 自社のネクタイ・ハンカチ販売、オンラインショップへの継続的な顧客誘導がキャッシュポイントにもなる。\n- **チーム運営:** 現在16社が参加。LINE グループで次回出店に向けて相互支援し、メンバー同士で知見を共有し助け合う文化がある。\n- **次廣への協業提案:** 参加企業それぞれに業務改善ニーズがある。AI導入支援などで DragonFly メンバーを紹介できる可能性がある。\n\n#### アクションアイテム\n\n- **中村さん:** 次廣と宮城氏（トレスステラ）をつなぐ。\n- **中村さん:** メインプレゼンで、カテゴリープレゼンをより分かりやすく改善し、**コンサルではないこと** を明確化する。\n- **次廣:** 予約管理システムを夏までにリリースする。\n- **次廣:** 料金体系のパッケージ化を検討する。\n- **次廣:** トレーニングの再受講を継続する。\n\n#### 次回予定・フォロー\n\n- 中村さんのメインプレゼンが **翌週（2026-05-26予定）** に控えている。\n- 宮城氏紹介後、予約システムの住み分け・代理店制度・導入サポートの可能性を確認する。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 中村さんは **「ものづくりの顔」＋「チャプター運営の実務家」** の二面性。紹介文ではブランド・工場・小ロットを前面に、運営話題は敬意と短さで。\n- 売上構成の **OEM→自社ブランド逆転** は、マーケ・D2C・メディア・クラファンの実行力の証拠。紹介時は「下請け工場」ではなく **「SHAKUNONE／日本製ネクタイのプロデューサー」** と伝える。\n- **カテゴリー変更（2026-04〜）:** `ファッション・デザイン`→`中小企業サポート`／`ものづくり再興事業プロデューサー` は、製品（ネクタイ）から **使命・つなぎ** へ軸を広げたシグナル。第1回で、**コンサルではなく、良いものを作る町工場チームの形成・共同プロモーション** であることを確認。\n- **ものづくりチーム:** 現在16社が参加。LINE グループで出店準備・相互支援・知見共有を行う。ここは tugilo にとって、単発の笏本縫製案件ではなく **複数の中小製造業との接点** になりうる。\n- **中村さんの紹介力:** 宮城氏（トレスステラ）紹介に合意。予約システムが競合しうる相手でも、知見共有を優先してつなぐ姿勢がある。\n- **47都道府県オーダースーツ店** は数値目標が明確。紹介の質は「店の格・客層・別注の頻度」が重要そう（要121確認）。\n- **鉄道・道路の現場監督経験** → 測量士補・施工管理技士。**丁寧な工程管理・謙虚さ** の人格説明と一致。\n- BNI U35・47project・津山YEG と **複数ネットワーク**。DragonFly 外の紹介も期待できるが、まずチャプター内のファッション・小売・制作系を整理。\n- 推薦文から、**プレゼンコーチ・深夜対応・フォロー** が強み。次廣のプレゼン改善フィードバックをもらう関係性が作りやすい。\n- **元プレジ** のため初回は **次廣先の進行** を想定。先に話すことで「教わる側」ではなく **対等な紹介パートナー** の印象を残しやすい。中村さんの質問・フィードバックを歓迎する姿勢が重要。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **紹介の軸:** 「小ロットからのオリジナルネクタイ・記念ネクタイ・会社PR」「日本製・工場直結・百貨店実績」「オーダースーツ店とのセット提案」。\n- **システム提案は二次:** 笏本縫製そのものには、受注・多チャネル・別注管理の課題有無を引き続き確認。ただし第1回後の主導線は、**中村さんのものづくりチーム参加企業** にある業務改善・AI導入ニーズ。\n- **相互紹介:** 製造・小ロット・ノベルティ・法人ギフト・ファッション系顧問。士業・コンサル経由の **「現場が回らない経営者」** は tugilo 標準ターゲット。中村さん経由では、**日本製の町工場・販売会参加企業** を入口にする。\n- **宮城氏（トレスステラ）接続:** 予約システム同士の競合可能性はあるが、リピモ（月額1,100円）・代理店制度・導入サポートの知見を確認し、次廣の事業者目線予約システムとの住み分けを探る。\n- **料金体系:** 完全カスタムのままだと紹介しにくい。予約管理システムや業務改善の入口を **パッケージ化** し、紹介者が説明できる価格帯・初期診断・小さな導入メニューを検討する。\n- **メインプレ前後（2026-05-26）:** 中村さんの **「コンサルではない」** が伝わる発表になっているか確認し、必要なら紹介文をアップデートする。\n- **Living Document 連携:** 自己紹介・紹介文は [`BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) を使用。中村さんからの「ビジター向け表現」フィードバックを反映。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 中村さんに紹介したい相手（候補・要121で確定）\n\n| 優先 | 相手像 | 切り口 |\n|------|--------|--------|\n| 高 | オーダースーツ店・メンズセレクト | 別注ネクタイ・SHAKUNONE 卸 |\n| 高 | パーソナルスタイリスト・イメージコンサル | クライアントへの一張羅提案 |\n| 中 | 企業・学校・団体（記念・PR） | 小ロットオリジナル・ロゴ入り |\n| 中 | ブライダル・写真家 | ギフト・コーディネート |\n| 中 | カラーコンサルタント | 色彩検定学習中との協業 |\n\n### 次廣が紹介してほしい相手\n\n- 全国のオーダースーツ店（特に未開拓22都道府県）\n- 衣料小売・百貨店バイヤー\n- 企業のノベルティ・記念品担当\n- EC・ブランディングで **ものづくりストーリー** を売りたい事業者\n\n### 紹介時の一言（ドラフト）\n\n**121前（旧カテゴリー寄り・暫定）**\n\n> 「岡山・津山のネクタイ専門縫製工場が、自社ブランド SHAKUNONE と、百貨店クラスのOEMをやっている専務取締役です。小ロットのオリジナルネクタイや記念ネクタイの相談から、オーダースーツ店向けの別注まで対応できます。」\n\n**121後に差し替え候補（新カテゴリー寄り・真意確認後に採用）**\n\n> 「日本製ものづくりの再興を、**津山の縫製工場から**届けている専務取締役です（**経営コンサルではなく**、ネクタイ・別注・OEMの製造とブランド SHAKUNONE）。小ロットオリジナルやオーダースーツ店向けの別注にも対応できます。」\n\n### 紹介前に確認すること（121で更新）\n\n- 最小ロット・納期・概算予算\n- デザイン・ロゴデータの有無\n- OEMか自社ブランドか\n- 法人か個人か\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 子育て（6歳・4歳）しながらチャプター役職を歴任。**「すべては経験」** のスタンスと謙虚さが推薦文で一貫。\n- DIY・菜園・筋トレ・ボウリング → アイスブレイクに使いやすい。娘への溺愛は親近感のフック。\n- 京都出身・津山在住・B\'z の地元など、雑談のネタが豊富。\n- プレゼン・ビジター・運営のフィードバックは **具体的・本質的・実行が早い**（船杉・福住・佐久間・松倉・福士各氏の推薦）。\n- 次廣が **運営の先輩** として敬意を示しつつ、事業パートナーとして対等に話すバランスがよい。\n\n---\n\n**運用メモ:** 第1回実施後は **【第1回】** に議事録を追記し、**サマリー・累積・戦略** を更新。YAML の `first_session_date` / `first_session_time_jst` を確定時刻で埋める。','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(29,1,37,122,NULL,NULL,NULL,'manual','2026-05-21 11:00:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_fujimoto_yuki_tax_advisor.md】\n\n# 1to1_藤本勇輝_税金アドバイザー\n\n---\n\n**文書の位置づけ:** 船津麻理子さん紹介で実施した、藤本勇輝さんとの初回 1to1 を **1ファイルで時系列管理**する。  \n**日時:** 第1回は **2026-05-21 JST 11:00 開始**（Zoomタイトル「1to1調整用 2026-05-21 11:00(GMT+9:00)」より。終了時刻は TODO）。  \n**整理:** 次廣は AI業務改善・システム構築、藤本さんは医療クリニック特化の税理士／税務セカンドオピニオン／未来会計を軸に相互理解した。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n### 藤本勇輝さん\n\n- **専門:** 医療クリニック特化税理士、税金アドバイザー、税務セカンドオピニオン、未来会計。\n- **BNI:** トレスステラチャプター（他チャプター）\n- **背景:** 両親が歯科医師、長男が歯医者、次男が医者、三男が税理士という医療系家族。医療系クライアントの事情を家族背景から理解しやすい。\n- **経験:** 医療系6年、相続系の経験あり。\n- **独立経緯:** BNI参加後に独立。両親が顧問税理士に悩んでいたことがきっかけ。\n- **主な顧客:** クライアントの7割が医療系（医師・歯科医師）。\n- **関連事業:** アイケアラボ神田駅前店、金融教育、健康・予防事業。\n- **所属・表記確認:** 所属チャプターは **BNI トレスステラ**。カテゴリー正式表記は次回確認。\n\n### 藤本さんの事業テーマ\n\n- **税理士の強みは人によって違う:** 税務に詳しいことは共通でも、相続・医療・補助金・経営支援など得意領域が大きく異なる。\n- **国税OB問題:** 税務署勤務から資格取得後に独立する先生は、公務員発想が強く、クライアント視点の伴走に慣れていないケースがある。\n- **セカンドオピニオン:** 顧問税理士以外の意見を聞くことで、法人化・所得分散・補助金・助成金・経営支援の選択肢が広がる。\n- **未来会計:** 確定申告・決算は過去の報告。藤本さんは将来の経営判断につながる数字の見方・助言を重視している。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** 船津麻理子さん紹介で第1回 1to1 実施済み。次廣の AI業務改善・システム構築と、藤本さんの医療系税理士・税務セカンドオピニオンを相互理解した。\n- **主な成果:** 次廣の事業概要、BNI参加経緯、主要実績、料金体系パッケージ化の課題を共有。藤本さんからは、法人化・顧問税理士の活用・税理士セカンドオピニオンの重要性について具体的な助言を受けた。\n- **藤本さんの強み:** 医師・歯科医師向けの税務・未来会計。税務判断が長期で数千万円〜億単位の差になることを、実例で伝えられる。\n- **次廣側の学び:** 年商約2,000万円の個人事業主として、法人化・所得分散・妻の役員化・社会保険料最適化を具体的に検討するタイミングに来ている。\n- **協業の芽:** 藤本さんの医療系顧客・経営者顧客には、業務フロー整理、予約・日報・問い合わせ管理、AI利用ルール整備、Google Workspace 等の活用支援ニーズがあり得る。\n- **次アクション:** 次廣は顧問税理士に強み・相談範囲を確認し、法人化タイミングを検討。藤本さんのセカンドオピニオンサービスを DragonFly 内でも紹介できるように整理する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-21\n\n#### 基本情報\n\n- 日時：**2026-05-21（木）JST 11:00–TODO**（開始は Zoom タイトルより。終了時刻は TODO）\n- 実施方法：Zoom\n- 紹介者：**船津麻理子さん**\n- **Religo 1to1 レコード:** `one_to_ones.id = 29`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n##### 1. 次廣の事業共有\n\n- **屋号:** tugilo（次廣 + エスペラント語 ligilo / つなぐ）。\n- **カテゴリー:** AI業務改善・システム構築。\n- **拠点:** 静岡県藤枝市。全国の経営者とオンラインで仕事。\n- **経歴:** エンジニア歴25〜26年。大学はフランス語学科、90年代後半のインターネット黎明期に独学で Web 制作を学び、大学中退後にシステム会社へ。30歳で独立。\n- **BNI参加経緯:** DragonFly 立ち上げ期から誘われていたが、多忙を理由に断り続けた。自身の業務も「Excel限界・二重入力・属人化」と同じ状態だったことに気づき、AI協業で開発工程・議事録・見積・要件定義を仕組み化。時間を作って参加。\n- **提供価値:** プログラムを書く前に業務フローを解きほぐし、必要な部分だけシステム化する。経営者と現場の間に入り、業務構造を整える。\n- **強み:** 既存ツールの押し付けではなく、現場の業務に合わせてゼロから構築できる。小さく始めて使いながら育てる。専門用語に寄りすぎず、人の言葉で業務を整理する。\n\n##### 2. 次廣の実績共有\n\n- **フランチャイズ本部（外注ブロック）:** 全国200社から500社へ拡大する際、人を増やさず管理できる仕組みを構築。Googleフォーム・スプレッドシート・メールに分散した注文管理を統合し、体感60〜70%の業務改善。\n- **防水工事業:** 外国人労働者が多い現場で、手書き日報が読めない・間違いが多い課題を LINE 連携の日報入力で解決。人件費・材料費・時間、請求時の集計を効率化。\n- **観光局イベント支援:** 静岡中部5市2町の周遊イベントで、LINE を使ったビンゴ・スタンプラリーシステムを提供。連続4年目、今年で5年目。\n- **動物病院予約管理:** 開院前に並ぶ状態を解消し、LINE予約システムを導入。\n\n##### 3. 藤本さんの税務セカンドオピニオン\n\n- **税理士は全員同じではない:** 税金には詳しいが、相続・医療・経営支援・補助金などの強みは経歴により違う。\n- **相続は専門性が高い:** 税理士10人中3人程度しか経験がない専門領域。\n- **顧問税理士以外の意見:** 多くの経営者は顧問税理士以外からアドバイスを受けていない。記帳・申告だけなら誰でもよいが、経営サポートを求めるなら複数意見が必要。\n- **具体例:** 個人事業主の歯科医師が年間2,000万円納税していたケースで、シミュレーションにより年間900万円の納税削減を実現。10年で1億円、30年で3億円規模の差になる。\n- **補助金・助成金:** 税理士全員が詳しいわけではないため、必要に応じて専門家をつなげることにも価値がある。\n\n##### 4. 次廣への法人化アドバイス\n\n- **現状:** 個人事業主で年間売上約2,000万円、頭打ち状態。事業拡大にはパワーチーム化と自分の作業削減が必要。\n- **法人化メリット:** 個人事業主と法人で交際費枠を分けられる。所得分散で税率・枠を最適化できる。\n- **妻の役員化:** 青色専従者給与の上限ではなく、法人役員として給与設計を検討できる。\n- **社会保険料:** 国民健康保険料が高額になりやすいため、法人役員報酬の設計で最適化余地がある。\n- **顧問税理士の活用:** 高校同級生の顧問税理士に、記帳・申告以外の強みや相談できる領域を確認する。\n\n##### 5. AI・ITツール活用\n\n- **AI利用の現状:** 個人・従業員レベルで先行利用が進んでいる一方、個人情報をクラウドAIに投げる運用は問題。\n- **今後の課題:** 企業としての AI 導入ルール、セキュリティ、ガバナンスが数年以内に重要になる。\n- **企業規模差:** 中小企業はAIを使って効率化を進めやすい一方、大企業はセキュリティ面で5〜10年遅れる可能性。\n- **契約しているが使えていない問題:** Microsoft Office や Google Workspace など、有料契約していても全体として活用できていないケースが多い。\n- **LINE活用:** 通常のLINE、公式LINE、LINE WORKS の違いを知らない人が多く、導入支援だけでも価値がある。\n\n##### 6. アイケア・健康の話題\n\n- 次廣は1日10時間以上パソコン・スマホを見ており、目・肩・首の負担が大きい。\n- 視力は良いが老眼が進行。\n- パソコン作業では同じ距離で左右のピント調整が固定されるため、ピント調整機能のトレーニングで改善可能性がある。\n- アイケア相談は継続検討。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **藤本さんは「税理士の選び方」を教育できる人:** 税務処理だけでなく、経営者が顧問税理士の強みを確認し、必要ならセカンドオピニオンを受けるべき理由を具体例で説明できる。\n- **医療系との相性が強い:** 医師・歯科医師の税務、法人化、投資・教育費、長期の資産形成まで話が広がる。\n- **次廣の紹介依頼と相性が良い:** 藤本さんの顧問先・相談者の中に、Excel限界、予約・問い合わせ管理、AI利用ルール整備、業務フロー整理の課題が出やすい。\n- **次廣自身の経営課題にも刺さった:** 個人事業主から法人化への判断、妻への給与設計、社会保険料最適化は、事業拡大の前提整理になる。\n- **士業向け説明の精度が上がる:** 「顧問先で現場の運用が追いついていない会社を一緒に整える」という紹介文は、税理士・社労士・補助金専門家に通じやすい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **藤本さんに紹介してほしい相手:** 医療クリニック、歯科医院、士業の顧問先で、予約管理・問い合わせ対応・日報・スタッフ運用・Excel管理が限界に近い経営者。\n- **藤本さんへの返礼:** DragonFly 内で「顧問税理士以外の意見を聞きたい経営者」「医師・歯科医師」「法人化や節税の判断で悩む個人事業主・小規模法人」に藤本さんを紹介できる。\n- **提案の入口:** いきなり開発ではなく、まず「契約済みツールの棚卸し」「AIに入れてよい情報・ダメな情報」「業務フローの見える化」から入ると、税理士顧問先にも紹介されやすい。\n- **次廣自身の宿題:** 顧問税理士へ強みを確認し、法人化の具体的な判断材料を揃える。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 藤本さんを紹介しやすい人\n\n- 顧問税理士がいるが、法人化・節税・未来会計について別意見を聞きたい経営者。\n- 医師・歯科医師で、税務・法人化・長期の納税差・資産形成に不安がある人。\n- 記帳・申告だけでなく、経営判断に使える数字の見方を求めている経営者。\n- 補助金・助成金・専門家ネットワークまで含めて相談したい小規模法人・個人事業主。\n\n### 藤本さんへ紹介してほしい人\n\n- 医療クリニック・歯科医院で、予約・問診・日報・スタッフ運用が紙やExcelで限界に近い経営者。\n- 顧問先の中で、成長しているが現場の仕組みが追いつかず、経営者が手作業・確認作業に追われている会社。\n- AIを使い始めているが、個人情報・社内ルール・セキュリティ面が不安な会社。\n- Google Workspace、Microsoft 365、LINE公式、LINE WORKS などを契約しているが使いこなせていない会社。\n\n---\n\n## ■ 今後のTodo\n\n- [ ] 藤本さんの正式な所属チャプター・カテゴリー表記を確認する。\n- [ ] Zoom終了時刻を確認し、YAML `first_session_time_jst` と本文に反映する。\n- [ ] 顧問税理士（高校同級生）に強み・相談可能領域・法人化タイミングを確認する。\n- [ ] 藤本さんの税務セカンドオピニオンを DragonFly 内で紹介する一言を作る。\n- [ ] 船津さんに紹介のお礼と、藤本さんとの1to1で得た主な気づきを共有する。\n- [ ] アイケア相談を継続するか検討する。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 藤本さんは、税理士を「申告する人」ではなく、経営者の未来判断に関わる専門家として位置づけている。\n- 事例の数字が大きく、セカンドオピニオンの価値を伝える力が強い。\n- 次廣の事業に対しては、士業の顧問先紹介・医療系顧客の業務改善という接点がある。\n- 船津さん経由のため、アイケア・健康・医療・税務・システム化の接点が横に広がりやすい。','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(30,1,37,123,NULL,'85349117783','4X2npZV5QGasXKVx+eKqEA==','manual','2026-05-21 13:00:00','2026-05-21 13:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_gondo_chiemi_campanula.md】\n\n# 1to1_権堂千栄実_Campanula\n\n---\n\n**文書の位置づけ:** 権堂千栄実さん（株式会社Campanula）との 1to1 を **1ファイルで時系列管理**する。  \n**日時:** 第1回は **2026-05-21 実施済み**（開始・終了時刻は TODO。カレンダー／Zoom／チャット等で確認後に YAML と本文へ反映）。  \n**整理:** 権堂さんの **企業研修・人材育成・業務改善コンサルティング** と、次廣の **AI業務改善・システム構築** は、建設業・製造業など現場密着型の支援で強い共通点がある。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供の 1to1 要約とプロフィール画像ベース。対外利用・紹介文に使う場合は、正式表記・所属・肩書を本人確認する。\n\n### 権堂千栄実さん\n\n- **会社:** 株式会社Campanula\n- **役職:** 代表取締役／社長\n- **会社名の由来:** カンパニュラの花言葉「感謝と誠実」\n- **ミッション:** 次世代の育成\n- **専門領域:** 企業研修、人材育成、業務改善コンサルティング。教育一筋30年。\n- **特徴:** 顧客企業の実際の業務内容を使い、現場の実務に合わせて研修・教育プログラム・評価制度・業務フロー改善を設計する。\n- **主な対象:** 建設業、製造業、現場人材の育成が必要な中小企業。\n\n### 経歴・バックグラウンド\n\n- 1964年4月、宮城県石巻市生まれ。\n- 1989年7月、日本ソフトバンク（現ソフトバンク株式会社）入社。営業事務として勤務。\n- 1994年1月、日本ソフトバンク退社後、パソコンインストラクターとして活動。\n- 1998年10月、結婚を機に福岡へ転居。翌年、長女出産。\n- 2000年1月、派遣スタッフとしてパソコンインストラクターの仕事へ復帰。\n- 2003年3月、株式会社大塚商会で J-PHONE → Vodafone → SoftBank Mobile のブランド移行時の研修プロジェクトを担当。\n- 2008年2月、株式会社Campanula 設立。人財戦略コンサルタントとして活動開始。\n- 2010年1月、教育CSR事業 Jobstudy.jp を開始。次世代の担い手育成をミッションとした教育CSR事業を開始。\n- 2011年2月、中小企業サポートネットワーク（略称スモールサン）キャリア構築プロデューサー。全国のスモールサン会員向け勉強会「ゼミ」で、人材育成・教育システムの作り方などの講座を担当。\n- 2014年2月、Jobstudy.jp の取り組みがキャリア教育アワード地域企業協働の部で優秀賞受賞。\n- 2015年8月、九州初のキャリア教育コーディネーター養成講座で育成機関認定。\n- 2019年4月、立教大学21世紀社会デザイン研究所入学。\n- 2021年3月、立教大学21世紀社会デザイン研究所卒業。キャリア教育と越境による学習の関連性を研究。\n\n### 支援実績\n\n#### 建設業：タイル技能者育成\n\n- **課題:** 職人ゼロの会社で、大卒者から一級タイル技能士を5年間で育成する必要があった。\n- **アプローチ:** 年次ごとの目標から逆算し、OJT プログラムを構築。現場職人との対話を通じて、計画的な育成設計に落とし込んだ。\n- **改善サイクル:** 毎年のフィードバックでプログラムをブラッシュアップ。\n- **成果:** 一級技能者2名、二級技能者4名を輩出し、20代若手8名の定着につながった。\n\n#### マネージャー育成：離職率改善\n\n- **課題:** 30代・40代の離職率が25%。\n- **アプローチ:** 実務を使った業務整理、部下への適切な権限移譲設計、月次ミーティングでの実践フィードバック、メール・チャットでの継続サポート。\n- **成果:** 5年間の研修継続により離職ゼロを達成。\n\n#### 評価制度構築\n\n- **特徴:** 社長の「妄想」を起点に、現場管理職が修正する行動ベース評価。\n- **仕組み:** 入社半年・1年・3年など段階的な目標設定。評価基準を全社員に見える形で掲示し、期待値を透明化。\n- **工夫:** 顧客・社内後輩からの名指しなど外部評価をインセンティブに連動。\n- **効果:** 若手社員の目標明確化と、会社・上司・本人の双方向の期待値共有。\n\n#### 業務フロー改善：クレーム削減\n\n- **課題:** 電気施工会社でクレームが多発。\n- **原因分析:** 業務フロー上は存在する工程が、実際には実施されていなかった。古参社員の属人的対応が問題を隠していた。\n- **解決策:** フロー通りの業務徹底、従わない社員の退職、若手中心の組織再編。\n- **成果:** 売上向上と組織の若返りにつながった。\n\n### 業務スタイル\n\n- 顧客業界の専門知識を都度学習する。建設業・携帯電話業界など、業界が変わっても現場に入り込む。\n- 現場との対話を重視し、わからないことは持ち帰って徹底的に調べる。\n- 営業経験ではなく、紹介・リファラルによる案件獲得が中心。\n- 研修だけで終わらせず、実務フロー・評価・マネジメント・定着までつなげる。\n\n### BNI・コミュニティ活動\n\n- コロナ禍で既存人脈が途絶え、新たなネットワーク構築を目的に BNI に参加。\n- 2020年11月入会予定。2025年11月で5年目の見込み。\n- リファラルマーケット講座に毎週土曜日朝7時から参加。\n- 建設業サポートコミュニティ福岡支部を主催。月1回の交流会を開催。\n- 横浜の BNI メンバーが創設した建設業特化型コミュニティがフランチャイズ化しており、福岡支部を担当。\n\n### 次廣側（共有した固定情報）\n\n- **カテゴリー:** AI業務改善システム構築。\n- **拠点:** 静岡県藤枝市。オンラインで全国対応。\n- **経験:** システムエンジニア歴26年。\n- **経歴:** 大学はフランス語学科。趣味の DTM とホームページ制作から IT に入り、東京のシステム会社へ就職。コンピューター組み立て、インフラ構築、システム設計・開発、営業を経験し、30歳で独立。\n- **強み:** 専門用語に頼らず、人間の言葉で業務を解く。言われたものを作るだけでなく、現場のワークフローを変えすぎずにシステム化する。\n- **AI活用:** 開発工程、議事録、見積もり、要件整理、提案資料作成を AI と協業して効率化。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** 第1回 1to1 実施済み（2026-05-21、時刻 TODO）。権堂さんの企業研修・人材育成・業務改善支援と、次廣の AI業務改善・システム構築を相互共有した。\n- **主な成果:** 両者とも、顧客の業務フローに深く入り込み、現場の実務を題材にして課題を解決するスタイルであることを確認。建設業・製造業を中心とした現場密着型支援で強い共通点が見えた。\n- **権堂さんの強み:** 教育プログラム設計、評価制度構築、組織文化改革、現場マネージャー育成、若手定着。\n- **次廣の強み:** 業務フロー整理、AI活用、Webシステム構築、LINE連携、紙・Excel・スプレッドシートの限界突破。\n- **協業の芽:** 権堂さんが設計した評価制度・育成プログラム・業務フローを、次廣がシステム化・ストック化する連携が考えられる。\n- **次アクション:** 権堂さんからリファラルマーケット講座6月の申込フォームを送付。次廣は建設業サポート静岡支部の日程を佐藤氏に確認し、参加を検討する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-21 実施済み（開始・終了時刻 TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-21（木）JST TODO**\n- **実施方法:** TODO（Zoom 等、正式記録を確認）\n- **Religo 1to1 レコード:** `one_to_ones.id = 30`（**1セッション＝DB 1行**。正式時刻は TODO のため `scheduled_at = null`）\n- **ソース:** ユーザー提供 1to1 要約、プロフィール画像\n\n#### 話した内容（重要）\n\n##### 1. 権堂さんの事業共有\n\n- 株式会社Campanula として、企業研修・人材育成・業務改善コンサルティングを提供。\n- 教育CSR事業 Jobstudy.jp、スモールサン会員向け勉強会、キャリア教育コーディネーター養成など、教育・人材育成の実績が厚い。\n- 研修は一般論ではなく、顧客企業の実際の業務内容を使ってカスタマイズする。\n- 建設業・製造業のような現場産業に入り込み、職人・管理職・若手の成長設計を支援している。\n\n##### 2. 権堂さんの具体事例\n\n- **タイル技能者育成:** 職人ゼロの会社で、一級タイル技能士を5年で育てるプログラムを構築。一級2名・二級4名・20代若手8名定着。\n- **マネージャー育成:** 離職率25%の会社で、業務整理・権限移譲・月次フィードバックを継続し、離職ゼロを達成。\n- **評価制度:** 社長の理想から始め、現場管理職が行動ベースに修正する制度設計。全社員に基準を見える化し、外部評価もインセンティブに反映。\n- **業務フロー改善:** フロー上の工程が実際には抜けていた施工会社で、運用徹底と組織再編によりクレーム削減・売上向上・若返りを実現。\n\n##### 3. 次廣の事業共有\n\n- AI業務改善システム構築として、業務フロー整理からシステム化までを支援。\n- システムエンジニア歴26年。文系出身、DTM・ホームページ制作から IT に入り、東京のシステム会社勤務を経て30歳で独立。\n- コロナ前からオンライン業務を行い、コロナ禍でオンライン対応が追い風になった。\n- AI登場により、開発工程、議事録、見積もり、要件整理、提案資料作成が効率化した。\n\n##### 4. 次廣の具体事例\n\n- **外構ブロックフランチャイズ本部:** 全国200店舗の施工店管理が Googleフォーム・スプレッドシート・メール・Excel に分散。1年で500店舗へ拡大しても人を増やさないため、Web受注から工程管理まで一元化。\n- **防水工事業:** 外国人職人が多く、紙の日報で文字間違い・計算ミスが頻発。LINE公式アカウントから日報・工程管理を入力できる仕組みを構築し、月次請求・給与支払いの集計も自動化。\n- **観光局:** 静岡中部の地域周遊イベントで、LINEスタンプラリー・ビンゴ・アンケート機能を提供。4年継続中。\n- **動物病院:** 電話予約と窓口順番待ちを、LINE予約システムで改善。\n\n##### 5. BNI・リファラルマーケット講座\n\n- 権堂さんはリファラルマーケット講座を強く推奨。\n- 「あなたの商品・サービスは断れないほど魅力的か」「誰と一緒にビジネスをやりたいか」など、ビジネスの根幹を問う内容。\n- 一人でビジネスを作ってきたタイプにとって、衝撃的な学び・体系的なビジネス思考の習得になる。\n- 次廣は権堂さんの推奨を実行する意向を示した。\n\n##### 6. 建設業サポートコミュニティ\n\n- BNIメンバーが運営する建設業特化型コミュニティ。\n- 建設業と建設業サポート事業者が、共通言語で困りごとや協力要請を共有できる場。\n- 権堂さんは福岡支部を主催。\n- 静岡支部は次廣の居住地（藤枝市）から車で約1時間の静岡市内で開催。\n- DragonFly AI メンバーの佐藤氏が名古屋支部に参加しており、次廣も佐藤氏から誘われていた。\n\n#### 決定事項・アクション\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| **権堂さん** | リファラルマーケット講座6月の申込フォームを次廣へ送付 | TODO |\n| **次廣** | 建設業サポート静岡支部の日程を佐藤氏に確認し、参加を検討 | TODO |\n| **両者** | 継続的な情報交換と協業機会の模索 | 継続 |\n\n#### 未解決・フォローアップ\n\n- 権堂さんの正式なカテゴリー表記。\n- 権堂さんのお名前の正式な読み・漢字表記。\n- 第1回の開始・終了時刻、実施方法。\n- リファラルマーケット講座6月申込フォームの受領確認。\n- 建設業サポート静岡支部の日程・参加可否。\n- 建設業サポートコミュニティの静岡支部・名古屋支部の参加メンバー確認。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **現場に入り込む姿勢が共通:** 権堂さんは教育・評価・マネジメントから、次廣は業務フロー・システムから入る。入口は違うが、どちらも現場の実務を理解してから設計する。\n- **建設業・製造業に強い接点:** 権堂さんは建設業の人材育成・評価制度・業務改善。次廣は建設・製造・現場系の紙・Excel・LINE・工程管理の改善。紹介先の業界が重なりやすい。\n- **教育設計とシステム化は補完関係:** 権堂さんが作る育成プログラム・評価制度・業務フローは、次廣がデジタル化・運用管理・可視化しやすい。\n- **一人ビジネスからパワーチームへ:** 権堂さんは、次廣が人に任せる・パワーチームを組む考え方へ移る必要性を示唆。次廣自身の課題に刺さった。\n- **リファラルマーケット講座は優先度高:** 次廣の BNI 活動・パッケージ化・紹介されやすい言語化に直結する可能性がある。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **権堂さんへ紹介してほしい相手:** 建設業・製造業で、紙・Excel・LINE・属人管理が限界になっている会社。特に、評価制度や育成プログラムを整えたが、日々の運用・記録・集計が追いついていない会社。\n- **権堂さんへ返せる価値:** 研修・評価制度・業務フロー改善の成果を、Webシステム・LINE入力・ダッシュボード・AI活用ルールとして定着させる支援。\n- **入口の提案:** 「研修で決めたことが現場で続く仕組み」「評価制度を日々の行動記録につなげる仕組み」「職人・外国人スタッフでも使える日報・工程管理」から入る。\n- **関係継続:** 建設業サポートコミュニティに参加し、権堂さんがいる建設業支援ネットワークと接点を持つ。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 権堂さんを紹介しやすい人\n\n- 建設業・製造業で、若手育成・職人育成・マネージャー育成に課題がある経営者。\n- 評価制度を作りたいが、抽象的な理念で止まっており、行動ベースに落とせていない会社。\n- 離職率が高く、現場リーダーへの権限移譲や部下育成が進んでいない会社。\n- 業務フローはあるが、実際には古参社員の属人対応で回っている会社。\n\n### 権堂さんへ紹介してほしい人\n\n- 権堂さんの研修・評価制度・業務改善先で、記録・集計・運用管理が紙やExcelに残っている会社。\n- 建設業サポートコミュニティ内で、日報・工程管理・見積・請求・職人管理に困っている会社。\n- 若手や外国人スタッフにも使いやすい現場入力の仕組みを探している会社。\n- 研修・制度設計とセットで、システム化・AI活用まで進めたい経営者。\n\n---\n\n## ■ 権堂さんにつなげられる候補\n\n※紹介前に、相手本人へ紹介可否・関心テーマを確認する。権堂さんへは「研修講師」ではなく、**現場の業務・人材・組織を実務に沿って作り直す人** として紹介する。\n\n### 優先度A：相性が高い候補\n\n| 候補 | 接続理由 | 最初の切り口 |\n|------|----------|--------------|\n| **中村啓吾さん（株式会社笏本縫製／SHAKUNONE）** | 日本製ものづくり再興、町工場・職人・チーム形成の文脈。中村さんのチーム参加企業（16社）にも、若手育成・現場教育・業務フロー整理のニーズが出やすい。 | 「ものづくり企業の人材育成・評価制度・現場教育に強い方」として情報交換。いきなり案件紹介ではなく、ものづくり支援者同士の接続。 |\n| **木村健悟さん（株式会社ハート・プランニング／倉敷屋）** | デニム雑貨・Tシャツプリント・OEM製造。小ロット多品種、製造指示、進捗、在庫、出荷など現場オペレーションがあり、人材育成・業務フロー改善と相性がある。 | 「製造現場の見える化・若手/スタッフ育成・現場が回る仕組み」の情報交換。 |\n| **伊藤隆夫さん（フェニックス人事労務／社労士）** | 就業規則、助成金、労務、研修、労働安全衛生。医療・建設・製造の顧問先社長層ネットワークあり。権堂さんの評価制度・人材育成と補完関係。 | 「評価制度・人材育成・労務制度を現場に落とす」パートナー候補として接続。社労士×教育コンサル×システム化の三角連携もあり得る。 |\n| **田村広大さん（お金の料理教室／BNI カーネル）** | 建設業者、損保支払いが大きい企業、財務コンサル経由法人が主ターゲット。建設業ネットワークが権堂さんの得意領域と重なる。 | 「建設業経営者に、財務・保険・人材育成・業務改善をまとめて支援できる可能性」の情報交換。 |\n\n### 優先度B：ニーズ確認後につなげる候補\n\n| 候補 | 接続理由 | 注意点 |\n|------|----------|--------|\n| **木村秀継さん（株式会社国宝社）** | 創業160年の製本会社。既存製本業を守りながら新規事業も進めており、老舗製造業の人材・組織・業務フロー改善テーマがあり得る。 | 現時点ではシステム改善・新規事業側の相談が中心。人材育成・評価制度への関心を本人確認してから。 |\n| **既存の防水工事業クライアント** | 外国人職人、日報、材料費・人件費集計、請求根拠など、権堂さんの現場教育・職人育成と相性が非常に高い。 | クライアント紹介は慎重。まずは匿名事例として権堂さんに共有し、本人許可が取れた場合のみ接続。 |\n| **外構ブロックFC本部案件の関係者** | 全国施工店管理、店舗拡大、人を増やさない運用設計。加盟店・施工店教育の文脈で権堂さんの経験が活きる可能性。 | 増本氏案件としての関係性・守秘を優先。直接紹介は、先方ニーズと紹介許可の確認後。 |\n\n### members一覧からの追加候補（DragonFly 第208回 CSV）\n\n※出典: `www/database/csv/dragonfly_208_20260519_all_full.csv`。1to1未実施・詳細未確認の人も含むため、まずは「紹介できそうか」の仮説として扱う。\n\n#### 建設・不動産系\n\n| 候補 | カテゴリー | 権堂さんとの接点 |\n|------|------------|------------------|\n| **平岡国彦さん** | 大型物件対応解体工事 | 建設現場・職人・安全・若手育成・業務フロー改善の課題が出やすい。権堂さんの建設業支援実績と直結。 |\n| **増本重孝さん** | 虫が建物に近寄らない害虫ブロック | 外構/建物まわりの施工・FC本部運用文脈。加盟店・施工店教育、業務標準化、評価制度の接点があり得る。 |\n| **長谷川貴志さん** | 空き家問題を解決する不動産屋 | 空き家・不動産再生では施工会社・職人・協力業者との連携が発生しやすい。建設業支援ネットワークの情報交換候補。 |\n| **福上大輝さん** | 自宅で開業にちょうどいい小屋 | 小屋・建築・施工側の教育や現場標準化の可能性。若手/協力業者育成テーマがあるか確認したい。 |\n| **太田一誠さん** | ファインバブル（住宅設備機器）販売 | 住宅設備・施工/販売店教育の可能性。販売施工フロー・顧客説明・現場対応の標準化が接点。 |\n\n#### 建設業支援・士業・組織支援系\n\n| 候補 | カテゴリー | 権堂さんとの接点 |\n|------|------------|------------------|\n| **西浦雅さん** | 外構工事特化型SNS集客 | 外構工事会社を支援する立場。集客後の現場育成・受注後フロー・職人定着まで広げると権堂さんと補完しやすい。 |\n| **西岡優希さん** | 外国人技能実習生支援団体 | 外国人材の教育・現場定着・コミュニケーション設計が接点。権堂さんの現場教育、次廣のLINE日報事例とも相性が高い。 |\n| **紀川和弘さん** | 建設業特化型損害保険 | 建設業経営者との接点が多い可能性。保険・安全・労務・教育の周辺課題から権堂さんへつなげられる。 |\n| **佐久間康丞さん** | 建設業専門行政書士 | 建設業許認可・経営者接点が強い。権堂さんの建設業育成・評価制度支援と紹介の相性が高い。 |\n\n#### 製造・食品・ものづくり系\n\n| 候補 | カテゴリー | 権堂さんとの接点 |\n|------|------------|------------------|\n| **吉田俊之さん** | 抗菌効果の強い漆塗りの食器販売 | 職人・製造・伝統工芸寄りの可能性。技能継承・若手育成・販路拡大時の組織化が接点。 |\n| **里見允二さん** | 顧客ニーズを超えるパッケージ制作 | 制作/製造工程・顧客対応・品質管理があり得る。スタッフ育成や工程標準化のテーマ確認候補。 |\n| **廣田誠悟さん** | 砂で造る高機能金属製品 | 金属製品製造で、技能・品質・工程管理・若手育成の接点が濃い。権堂さんの製造業支援と相性が高い。 |\n| **田渕恭平さん** | 高級石材の採掘・供給 | 石材・採掘・職人・施工/設計側との接点。技能継承や現場教育の文脈があり得る。 |\n| **藤井恵理子さん** | 播州織の日傘製造 | 繊維・製造・職人/工房系の可能性。製造体制・人材育成・品質管理の課題があれば接続候補。 |\n\n#### ビジター・ゲスト（紹介可否確認が必要）\n\n| 候補 | カテゴリー | 権堂さんとの接点 |\n|------|------------|------------------|\n| **神山英輝さん** | 中小企業診断士 | 組織・経営改善支援者として、権堂さんの人材育成/評価制度と補完関係。まずは紹介者の平山さんに接続可否確認。 |\n| **中村まどかさん** | 組織改革コーチング、社外CHRO | 権堂さんと領域が近い。競合というより、組織改革・人材育成支援者同士の情報交換候補。 |\n| **村野秀二さん** | 非破壊検査AIロボット | 製造/検査/現場技術系。人材教育・現場オペレーション・AI導入教育の接点があり得る。 |\n| **高橋聡一郎さん** | 総合防災設備業 | 設備・施工・点検・現場教育の文脈。建設業寄りの教育/業務フロー改善候補。 |\n| **佐藤啓介さん** | 産業機器メンテナンス | 現場技術者・保守・安全・技能継承の文脈。権堂さんの現場教育と相性がある可能性。 |\n\n#### 相互友達確認で除外（すでに権堂さんと接続済み）\n\n※Facebook の共通の友達一覧で確認できた範囲。紹介候補からは外し、必要なら「既につながっている前提で話題に出す」扱い。\n\n- **松倉健治さん**\n- **佐藤拓斗さん**\n- **望月雅幸さん**\n- **畠山憲之さん**\n\n### 紹介時の優先順位\n\n1. **中村さんへ情報交換可否を確認**  \n   「日本製ものづくり再興」と権堂さんの人材育成・現場教育がつながりやすい。\n2. **伊藤さん／佐久間さんなど士業系へ人材育成・評価制度テーマで接続可否を確認**  \n   社労士・助成金・評価制度・研修の補完関係が作れる。\n3. **木村健悟さん・廣田さんなど製造系は現場課題感を先に確認**  \n   具体課題があれば権堂さんの支援領域に入りやすい。\n4. **田村さん・紀川さんは建設業ネットワークの情報交換として接続**  \n   直接顧客というより、建設業支援者ネットワーク拡張の位置づけ。\n\n### 権堂さんへの紹介文たたき台\n\n> 権堂さんにぜひ情報交換いただきたい方が何名か浮かびました。  \n> 特に、ものづくり企業のチーム形成に取り組まれている中村さん、製造現場を持つ木村さん、社労士として評価制度や労務に強い伊藤さんは、権堂さんの「現場に入り込んで、人材育成・評価制度・業務フローを整える」お仕事と接点がありそうです。  \n> いきなり案件紹介というより、まずは支援者同士の情報交換としておつなぎできるか、先方にも確認してみます。\n\n---\n\n## ■ 今後のTodo\n\n- [x] 権堂さんの所属チャプターを確認する（BNI パッシオーネチャプター / PASSIONE）。\n- [ ] 権堂さんの正式なカテゴリー表記を確認する。\n- [ ] 権堂さんのお名前の正式な読み・漢字表記を確認する。\n- [ ] 第1回の開始・終了時刻と実施方法を確認し、YAML `first_session_time_jst` と本文へ反映する。\n- [ ] リファラルマーケット講座6月の申込フォームを受領・申込検討する。\n- [ ] 佐藤氏へ建設業サポート静岡支部の日程を確認する。\n- [x] DragonFly AI 内外の社労士・建設業・製造業ネットワークから、権堂さんに紹介できる候補を整理する。\n- [ ] 権堂さん向けに「研修・評価制度を現場運用システムに定着させる」紹介文を作る。\n- [ ] 中村啓吾さん・木村健悟さん・伊藤隆夫さん・田村広大さんへ、権堂さんとの情報交換可否を順に確認する。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 権堂さんは、研修講師というより **現場の業務・人材・組織を実務に沿って作り直す人** と捉えると紹介しやすい。\n- 顧客業界を都度学び、現場との対話から設計する点が次廣の仕事観と非常に近い。\n- 建設業・製造業では、教育・評価・業務フローとシステム化が分断されがち。両者が連携できると、制度を作って終わりではなく、日々の運用まで落とし込める。\n- 権堂さんからのリファラルマーケット講座推奨は、次廣の BNI 活動を次段階へ進める具体的な導線。','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(31,1,37,14,NULL,'84060508444','5WhkV5vUSc2lhAf6Lbg/SQ==','manual','2026-05-21 14:50:00','2026-05-21 14:45:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nishioka_foreign_trainee.md】\n\n# 1to1_西岡優希_外国人技能実習生\n\n---\n\n**文書の位置づけ:** DragonFly メンバー・西岡優希さんとの 1to1 を **1ファイルで時系列管理**する。  \n**日時:** 第1回は **2026-05-21 JST 14:50〜** 実施済み（終了時刻は TODO。カレンダー／Zoom／チャット等で確認後に YAML と本文へ反映）。  \n**整理:** 西岡さんは **外国人技能実習生の受入れ・監理支援**、次廣は **AI業務改善・現場に合わせたシステム構築**。両者とも建設業の現場課題に接点があり、人材不足と業務効率化の両面から支援できる可能性がある。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供の 1to1 要約ベース。対外利用・紹介文に使う場合は、西岡さんの正式氏名・組合名・役職・カテゴリー表記を本人確認する。\n\n### 西岡さん\n\n- **所属:** 外国人技能実習生受入れ事業／監理団体（正式名 TODO）\n- **BNI:** DragonFly メンバー\n- **前職・経験:** 建設業を約13年経験。\n- **現在の事業:** 約半年前から外国人技能実習生の受入れ事業を開始。\n- **主な対象:** 建設業を中心に、人材不足で若手採用・定着に困っている企業。\n- **主な強み:** 24時間対応、追加料金なしの手厚い実地サポート、月1回の寮訪問、日本到着後の生活・就労管理。\n- **送り出し国:** インドネシア等の送り出し機関（日本語学校）と提携。\n\n### 外国人技能実習生・育成就労制度の概要\n\n- 外国人技能実習生制度は古くからある制度で、2025年4月から **育成就労制度** へ移行予定。\n- 従来は「日本の技術を海外へ移転する国際貢献」という建前だったが、新制度では日本の人材不足を補う意味合いが強くなる。\n- 全国に監理団体・共同組合が約2,700社あるが、制度変更により半分近くまで減る可能性がある。\n- 西岡さん側の組合は、送り出し機関と連携し、日本に行きたい学生と受入れ企業をマッチングし、ビザ申請から日本到着後の管理までを担う。\n\n### サービスの特徴\n\n- **24時間対応:** 多くの組合がオンライン対応中心・配属後は薄い支援になりがちな中、現場対応を重視。\n- **病院付き添い:** 実習生が風邪・怪我をした際、社長や現場責任者の負担にならないよう組合が付き添う。\n- **月1回の寮訪問:** 法律上は3ヶ月に1回の訪問義務だが、西岡さん側では月1回訪問。日本の生活ルールを伝え、本人の不安や不満をヒアリングする。\n- **失踪リスクの低減:** 配属後に放置せず、生活面も含めて関係を保つことで、連絡不能・失踪を防ぐ。\n- **選考品質:** 面接時に日本のルールを守れるか、生活習慣や日本語能力を確認し、受入れ先企業が選んだ人材を配属する。\n\n### 実習期間・特定技能\n\n- 基本の実習期間は3年。\n- 試験に合格すれば **特定技能** として残ることができ、最大8年程度の就労が見込める。\n- さらに高度な試験（特定技能2号）に合格すると、家族帯同や永住に近い形も視野に入る。\n- 企業側にとっては、3年で終わらず、育てた若手が長く働いてくれる可能性が大きな価値になる。\n\n### 市場背景\n\n- インドネシアでは月給が約3万円前後に対し、日本では月14〜15万円が見込めるため、出稼ぎの動機が強い。\n- 日本の建設業では求人を出しても人が集まりにくく、同じ人材が同業内を回っている状態になりやすい。\n- 若手採用・教育に苦労する企業が多い一方、実習生は「お金を稼ぎたい」「日本に行きたい」という意欲を持って面接に来るため、仕事の覚えが早いケースがある。\n\n### 次廣側（共有した固定情報）\n\n- **カテゴリー:** AI業務改善システム構築。\n- **拠点:** 静岡県藤枝市。オンラインで全国対応。\n- **経験:** システム開発歴25年以上。\n- **経歴:** フランス語学科出身。90年代後半に Mac、音楽制作、Web制作に触れ、システム会社へ就職。コンピューター組み立て、インフラ構築、設計・開発、営業まで経験し、30代で独立。\n- **強み:** 顧客の困りごとを言語化し、既存ツールを押し付けず、現場の業務に合わせて小さく作り確実に育てる。\n- **AI活用:** 設計・要件定義・議事録・見積もり・プログラミングを AI と協業し、開発時間と費用を圧縮。\n- **価格感の例:** 通常600〜800万円規模になりがちなシステムを、120万円から開始し、200万円以下で着地させるケースがある。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** 第1回 1to1 実施済み（2026-05-21 JST 14:50〜、終了時刻 TODO）。同じ DragonFly メンバーとして初めて深く事業を共有した。\n- **主な成果:** 次廣の AI 業務改善・現場密着型システム構築と、西岡さんの外国人技能実習生受入れ支援は、どちらも建設業の人手不足・現場負担軽減に接続することを確認。\n- **西岡さんの強み:** 24時間対応、病院付き添い、月1回の寮訪問、配属後の生活管理、実習生と企業双方の不安解消。\n- **次廣の強み:** 建設業・製造業など IT リテラシーが高くない現場でも、LINE 連携・日報・勤怠・見積・受発注などを現場に合わせて仕組み化できる。\n- **協業の芽:** 西岡さんの周辺に多い建設業クライアントへ、実習生受入れと業務効率化の両面から提案できる。次廣側の既存建設業・製造業クライアントにも、西岡さんの実習生支援を紹介できる可能性がある。\n- **次アクション:** 次廣は建設業向けに「こんな感じのことができます」と見せられるモック資料を作成する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-21\n\n#### 基本情報\n\n- **日時:** 2026-05-21（木）JST 14:50〜TODO（ユーザー提供: `西岡さん121 2026-05-21 14:50(GMT+9:00)`）\n- **実施方法:** TODO（Zoom 等、確認）\n- **相手:** 西岡優希さん（DragonFly メンバー／外国人技能実習生事業）\n- **Religo 1to1 レコード:** `one_to_ones.id = 31`（**1セッション＝DB 1行**）\n- **目的:** 初回相互理解。事業内容、強み、BNIでの関係構築、相互リファラルの可能性を確認する。\n\n#### 話した内容（重要）\n\n##### 1. 次廣の事業背景\n\n- 次廣は現在52歳。文系・フランス語学科出身。\n- 90年代後半、インターネット黎明期に Mac を購入し、音楽制作と Web サイト構築に没頭。\n- 大学6年生の時にシステム会社の社長から声をかけられ、大学を中退して就職。この出会いがキャリアの原点。\n- 入社後は、コンピューター組み立て、インフラ構築、システム設計・開発、営業まで経験。\n- 技術職はコミュニケーションが苦手な人が多かったが、次廣は人と話すのが好きだったため、顧客の困りごとを聞き出し、言語化する力を鍛えた。\n- 30代で独立し、コロナ前からオンラインで全国の経営者とつながって仕事をする体制を構築していた。\n\n##### 2. AI活用による業務効率化\n\n- 以前は自分でプログラムを書いていたが、現在は設計・判断は次廣が行い、実装の多くを AI と協業して進める。\n- 議事録、要件定義、見積もり、提案資料作成も AI で仕組み化し、自分の時間を創出できるようになった。\n- この自社効率化が、DragonFly 参加の決め手にもなった。\n- 家族との時間を大切にしながら仕事を続けるためにも、頑張る人ほど時間がなくなる構造を変えたいという思いがある。\n\n##### 3. 次廣の開発哲学\n\n- 既存ツールを押し付けるのではなく、今の業務に即して現場に合わせて設計する。\n- 最初から大きく作らず、一番困っているところから小さく始め、必要なところを広げていく。\n- 最終的には「人に頼らない状態」「誰でもできる状態」を目指す。\n- 言われたものをそのまま作るのではなく、経営者や現場と話しながら、現場のワークフローを変えすぎずに負担を減らす方法を整理する。\n\n##### 4. 次廣の導入事例\n\n**外構ブロック事業（増本さんの会社）**\n\n- 全国200店舗の取扱店があり、受発注・顧客管理・対応記録が別々のツールで管理されていた。\n- Googleフォーム、スプレッドシート、メールで管理していたため、取扱店ごとの売上集計に時間がかかっていた。\n- 500店舗を目指すにあたり、人を増やさなくても回る仕組みを提案。\n- 注文受付、発送、売上管理、請求書発行、取扱店ごとの活動状況の見える化を一つの流れに整理。\n- 従来 USB メモリで配布していたマニュアルや動画も、スマホで見られるオンライン教材に変更し、教育面も支援。\n\n**防水工事業の工程・日報管理**\n\n- 名古屋の防水工事業者では、外国人職人が多く、手書き日報の字が読みにくい・間違いが多い課題があった。\n- 普段使っている LINE とシステムを連携し、LINE公式アカウントから日報を提出できる仕組みを構築。\n- 作業内容、労働時間、使用材料を現場から1日単位で提出でき、本部では請求管理・人件費・勤怠給与計算に使える形で集計できるようにした。\n\n**問い合わせ・見積作成システム（業種名は要確認）**\n\n- 問い合わせや見積依頼が紙・別ツール・LINE 等に分散し、情報引き継ぎミスが起きていた。\n- 入口を整え、顧客とは LINE でやり取りしながら、見積書・請求書の発行、問い合わせ対応をシステム上で完結できるようにした。\n- 案件状態が誰でも見えるようになり、見積もりから請求書作成までの効率が上がった。\n\n**観光業イベント支援**\n\n- 静岡の観光協会とのコラボで、周遊イベントのスタンプラリー・ビンゴを LINE で参加できる形にした。\n- 4年連続で採用されており、今後も継続予定。\n\n**動物病院・サロンの予約管理**\n\n- 電話対応の負担が大きく、顧客も待つ状況があった。\n- LINE で予約できる仕組みを導入し、顧客が自分で予約できるようにして受付負担を軽減した。\n\n##### 5. 西岡さんの事業\n\n- 建設業を約13年経験した後、約半年前から外国人技能実習生の受入れ事業を開始。\n- インドネシアなどの送り出し機関と連携し、日本に行きたい学生を受入れ先企業とマッチング。\n- ビザ申請から日本到着後の管理までを行う。\n- 多くの組合がオンライン限定や配属後は薄い対応になりがちな中、西岡さん側は実地サポートを重視。\n- 病院付き添い、24時間対応、月1回の寮訪問などを追加料金なしで提供する点が強み。\n- 実習生は異国での不安が大きく、小さな怪我や体調不良でも病院に行きたがることがあるため、組合が対応することは企業側の大きな負担軽減になる。\n- 面接時に日本のルールを守れるか、生活習慣、日本語能力を確認し、受入れ企業が選んだ人材を配属する。\n- 配属後も放置せず、日本のルールを口うるさく伝え、本人の不安を拾うことでトラブル・失踪リスクを下げる。\n\n##### 6. BNI活動・関係構築\n\n- 次廣は増本さんと5〜6年前から付き合いがあり、DragonFly 立ち上げ時から誘われていたが、忙しさを理由に断っていた。\n- AI 協業で自分の時間を作れるようになり、BOD のタイミングで改めて声をかけられ、2026年2月末に参加、3月17日に入会。\n- 入会後1ヶ月で13個のトレーニングを完了。マスモトチルドレンとしてビジビリティを上げる意識もあった。\n- トレーニングで傾聴の重要性を学び、リファラル時には相手の話を最後まで聞くことを意識している。\n- 西岡さんは「最初の1年は関係構築が一番大切」と認識しており、自分の周りでリファラルを出せるよう貢献したいと考えている。\n- 次廣も、まだ DragonFly 内でリファラルを出せていないため、メンバーとの 1to1 を増やしていきたい。\n\n##### 7. メインプレゼン\n\n- 次廣は6月にメインプレゼンを控えており、西岡さんに負けないよう頑張ると話した。\n- 西岡さんは先日メインプレゼンを実施。本人はうまくできなかったと感じているが、次廣は「人柄が伝わってくる、すごく良かった」と評価。\n- 西岡さんは建設業出身で、パソコンや人前での発表経験は多くなかったため、メインプレゼンはかなり緊張した。\n- DragonFly 内では、バーバブルの写真などで次廣の印象があり、西岡さんからは「目立っている」というイメージを持たれていた。\n\n##### 8. 相互リファラルの可能性\n\n- 西岡さんの周囲には建設業関係者が多い。\n- 次廣も、これまでのクライアントに建設業・製造業が多いため、実習生の話を聞いてみると応じた。\n- 建設業の社長は現状に満足していない一方、アナログで頭が固い人も多く、「もっと効率が良くなる」と言われてもピンと来ないことが多い。\n- 次廣は、建設業・製造業の現場に改善余地が大きい理由として、ITリテラシーが高くないこと、ただし紙が一番安心という現場感覚も理解していることを説明。\n- 今後は AI で画面の試作もすぐ作れるため、「今後こうなったらどうですか」と見せながら打ち合わせできる。\n- 西岡さんからは「業務のお悩み事から聞いてくれる人がいるよ」という形でつないでもらえればよい。\n- 次廣はすぐにシステムを売るのではなく、ヒアリングから入り、業務改善や現場の仕事を楽にすることを目的にする。\n- 建設業向けには、モック資料のような「こんな感じのことができます」と説明できる資料を作ることを約束。\n\n##### 9. 次廣の求めるリファラル\n\n- **金の卵:** 今、業務で困っている社長・管理者。\n- **金のガチョウ:** 経営者を支援しているコンサルタント・士業。\n- **協業相手:** B2C システムを作る際に協業できる Web デザイナー。\n- 「何でもできます」は答えているようで答えていないため、今後はターゲットを絞って伝える必要があると確認。\n\n##### 10. 個人背景\n\n- 次廣は10歳下の妻と結婚16年。中学3年生と小学6年生の娘がいる。\n- 猫4匹と暮らしており、チンチラシルバーの兄弟猫3匹と白黒猫1匹。\n- 趣味はキャンプ。結婚前に自分だけの趣味をやめ、夫婦・家族でできる趣味としてキャンプを始めた。\n- 旅行や健康維持のためのジムも続けている。\n- 高校時代は水球部。水中の格闘技とも言われる競技で、周囲を見ながらポジションを取り続ける経験が、全体を見渡す力につながっている。\n\n#### 決定・合意\n\n- 建設業クライアントでの相互リファラル可能性を継続検討する。\n- 西岡さんは、建設業関係者に「業務のお悩みを聞いてくれる人」として次廣をつなぐ可能性がある。\n- 次廣は、自分の建設業・製造業クライアントに実習生ニーズがあるかを聞ける可能性がある。\n- 次廣は、建設業向けにシステム化のイメージを見せられるモック資料を作成する。\n\n#### アクションアイテム\n\n- [ ] **次廣:** 建設業向けに「こんな感じのことができます」と説明できるモック資料を作成する。\n- [ ] **次廣:** 既存の建設業・製造業クライアントで、外国人技能実習生・育成就労への関心がありそうな先を思い出す。\n- [ ] **次廣:** 西岡さんの正式氏名、所属組合名、役職、終了時刻を確認して本ファイルへ反映する。\n- [ ] **西岡さん:** 建設業関係者の中で、業務改善・勤怠・日報・見積・受発注に困っていそうな社長を思い出す。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 西岡さんの事業は「人材不足の解決」だけでなく、受入れ後の生活・就労トラブルを減らす **現場負担の軽減サービス** として伝えると強い。\n- 建設業の社長に対しては、「システムを入れませんか」よりも「実習生・職人・管理者の現場負担を減らしませんか」の方が刺さりやすい。\n- 次廣の防水工事業 LINE 日報事例は、西岡さんの実習生支援と非常に相性が良い。外国人職人が多い現場で、言語・記録・集計の課題を同時に扱える。\n- 西岡さん経由の紹介では、最初から DX やシステムの話を前面に出さず、「業務のお悩みを聞いて整理してくれる人」として紹介してもらうのが自然。\n- 逆に次廣側から西岡さんを紹介する場合は、「外国人技能実習生」だけで相手に意味が通じやすい。すでに導入済みの企業にも「もっと手厚い組合を知っている」と紹介できる可能性がある。\n- 西岡さんは謙虚で、パソコンやプレゼンへの苦手意識があるが、現場経験・人への支援姿勢・24時間対応の強みははっきりしている。人柄が伝わる紹介が合う。\n\n---\n\n## ■ tugiloとしての戦略\n\n### 西岡さんから紹介してもらいやすい言い方\n\n> 建設業の現場で、日報・勤怠・見積・受発注・請求が紙やLINEやExcelに散らばって困っている会社があれば、業務の流れを聞いて、現場に合わせて楽にする方法を一緒に考える人がいます。\n\n### 西岡さんへ返せる紹介の言い方\n\n> 建設業や製造業で若手採用に困っている、外国人技能実習生を考えている、あるいは今の組合対応に不満がある会社があれば、配属後のサポートまで手厚く見てくれる方がいます。\n\n### 建設業向けモック資料の方向性\n\n- LINE 日報：作業内容、人数、時間、材料、写真を LINE から送れる。\n- 勤怠・給与集計：現場ごとの作業時間を自動集計し、給与・請求の根拠にする。\n- 案件ステータス：見積中、受注、施工中、請求済みなどを色分けで見える化。\n- 実習生管理との接続：寮訪問、病院付き添い、生活面のフォロー記録を将来的に管理できる可能性。\n- 紙を全否定しない：紙・ホワイトボード・LINE の現状を尊重し、集計や共有だけを楽にする見せ方にする。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 西岡さんに紹介できそうな相手\n\n- 建設業の社長・現場責任者\n- 外国人職人・若手採用で困っている企業\n- すでに技能実習生を入れているが、組合の対応に不満がある企業\n- 製造業で若手人材不足に困っている企業\n- 建設業に強い士業・コンサルタント・保険営業・金融系メンバー\n\n### 西岡さんから次廣へ紹介してもらいたい相手\n\n- 建設業で日報・勤怠・見積・請求が紙やExcelに散らばっている会社\n- 外国人職人が多く、記録・言語・集計の課題がある会社\n- 人を増やさずに現場管理・事務処理を回したい会社\n- 現場はアナログだが、社長が「このままではまずい」と感じている会社\n\n### ウィークリープレゼンへの反映候補\n\n- 「外国人職人が多い建設現場で、手書き日報が読めず、集計に困っている会社」\n- 「実習生や若手職人が増えて、現場の記録・勤怠・材料管理を簡単にしたい会社」\n- 「紙やLINEはそのまま使いながら、事務所側の集計だけ楽にしたい建設会社」\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 西岡さんは非常に謙虚で、「自分はまだペーペー」「パソコンも使い切れない」と話していた。\n- 次廣は、増本さんも以前は Zoom すら知らなかったが必要に応じて学んでいることを例に、人間は必要なことを学んでいくと励ました。\n- お互いに「リファラルを出せるように頑張る」と確認。\n- 西岡さんは、最初の1年は関係構築が重要で、仕事につなげる以前に信頼を積む段階だと理解している。\n- 次廣も同じ感覚を持っており、DragonFly メンバーとの 1to1 を増やしていく方針。\n\n---\n\n## ■ 未確認・TODO\n\n- [x] 西岡さんの下の名前・漢字表記（DragonFly members CSV / DB表記: 西岡優希）\n- [ ] 正式な組合名・法人名\n- [ ] BNI カテゴリー正式表記\n- [ ] 役職・肩書\n- [ ] 第1回の終了時刻\n- [ ] 実施方法（Zoom 等）\n- [x] Religo DB `one_to_ones.id` 登録有無（`one_to_ones.id = 31`）','2026-05-21 16:13:21','2026-06-04 10:53:02'),
(32,1,37,124,NULL,'85129485087','DGnP1OtXRv+Ud8UIRCc6TA==','manual','2026-05-22 09:00:00','2026-05-22 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_mitarai_fudotech.md】\n\n# 1to1_御手洗さん_株式会社風土テック\n\n---\n\n**文書の位置づけ:** BNI VORTEX の株式会社風土テック・御手洗さんとの 1to1 を **1ファイルで時系列管理**する。  \n**日時:** 第1回は **2026-05-22 JST 09:00〜** 実施済み（終了時刻は TODO。カレンダー／Zoom／チャット等で確認後に YAML と本文へ反映）。  \n**整理:** 御手洗さんは **建設業特化の採用支援**、次廣は **AI業務改善・現場に合わせたシステム構築**。建設業の「人が採れない」と「採った後に現場が回らない」は隣接課題であり、外国人労働者の日報管理、採用後の定着、顧客紹介で具体的な協業可能性を確認した。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※初回 1to1 実施後の整理メモ。対外利用・紹介文に使う場合は、御手洗さんの正式氏名・役職・カテゴリー・サービス名を本人確認する。\n\n### 御手洗さん\n\n- **所属:** 株式会社風土テック\n- **BNI:** VORTEX メンバー（加門さん紹介。加門さんも VORTEX 所属）\n- **カテゴリー:** 建設業特化の採用支援（ユーザー提供情報）\n- **公式サイト:** `https://fudo-tech.co.jp/`\n- **正式氏名・役職:** 御手洗氏。下の名前・役職は TODO（本人確認）\n- **個人背景:** 1992年生まれ、34歳、大分県出身。福岡の大学で硬式野球部、病院総務、広告営業会社での飛び込み営業経験を経て、風土テックへ参画。詳細は本人確認。\n- **BNI歴:** 約1年3ヶ月。練馬会場で活動との要約あり。ユーザー確認では VORTEX 所属。\n- **プロフィールシート:** ユーザー提供 URL は取得時点で次廣側プロフィールが表示されたため、御手洗さん側 URL は要確認。\n\n### 株式会社風土テック / 建設採用組\n\n- 公式サイトは [株式会社風土テック│建設採用組](https://fudo-tech.co.jp/)。\n- **実績領域:** 建設業許可29業種のうち、サイト上では **20〜22業種の採用支援実績** がある旨が記載されている。\n- **掲げている方向性:** 「建設採用組」として、**建設業を日本一選ばれる業界にする** ことを掲げている。\n- **会社の思想:** 社名の通り、採用活動を通じた **企業の風土形成** により、組織の可能性を広げる会社と説明されている。\n- **採用の捉え方:** 採用は単なる人材確保ではなく、地域の伝統・文化・技術を未来へつなぐ取り組み。安心して暮らせる環境を支える建設業を、採用面から支援するという文脈。\n- **代表メッセージ:** 代表取締役・柴田亮太氏。「風土に勝る戦略なし」「ここにしかない誇りで選ばれる会社を作る」を掲げ、2022年4月創業。建設業を中心に MVV 構築・採用支援を行っている。\n- **御手洗さん本人の担当領域・提供プラン・主な地域・得意な建設業種:** TODO（本人確認）。\n\n### サイトから確認した主な支援内容\n\n- **ショート動画を中心とした SNS 運用:** 画像投稿・ショート動画投稿の企画、撮影、編集、投稿を安定して行う支援。\n- **無料媒体の運用:** 適切な媒体選定、求人原稿の日々改善、応募者に対する動線設計。\n- **MVV構築・浸透支援:** 経営目的・経営ビジョンを明確にし、社内へ浸透させる施策を実行。\n- **採用コンテンツの拡充:** note 設計・執筆、会社説明資料、Googleプロフィール更新、長編動画監修など、「選ばれるための採用コンテンツ」を揃える。\n- **採用コンサル:** 採用に何から取り組むべきか、建設業の採用成功パターンをもとに不足箇所を整理する。\n\n### サイトから見える課題認識\n\n- 採用活動は一発勝負ではなく、継続的な取り組みで **資産化** する必要がある。\n- 企業や目的の数だけアプローチ方法があり、正解はひとつではない。\n- 建設業では SNS なしに採用成功することが難しくなっている、という認識。\n- 今までの媒体や採用手法で効果が下がっている場合、無料媒体など短期施策から中長期の仕組みづくりまで、多方面からのアプローチが必要。\n- 若い世代の採用では「若い世代にとってその会社が No.1 になること」、つまり魅力や想いを伝えることが重要。\n- 早期離職の改善には、条件面だけでなく「想いや目標に共感できていること」が重要で、組織力の強化にもつながる。\n\n### 次廣側（共有する固定情報）\n\n- **屋号:** tugilo（ツギロ）\n- **カテゴリー:** AI業務改善システム構築\n- **拠点:** 静岡県藤枝市。オンラインで全国対応。\n- **強み:** 業務の流れを整理し、Excel・紙・LINE・属人化している作業を、現場に合わせて無理なく仕組み化する。\n- **建設業接点:** 工程管理、職人連絡、日報、請求・支払、見積・問い合わせ管理など、現場運用に近い改善テーマと相性が良い。\n- **公開サイト:** `https://tugilo.com`\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** 加門さんからの紹介により第1回 1to1 実施済み。チャプターは BNI VORTEX。\n- **主な成果:** 次廣の建設業・製造業向け AI 業務改善システム構築と、御手洗さんの建設業採用支援は、顧客層・課題解決アプローチの親和性が高いことを確認。\n- **具体的な協業の芽:** 外国人労働者の日報管理システム、採用後の定着・教育・現場共有、御手洗さんの採用支援先への業務改善提案、次廣側の建設業顧客への採用支援紹介。\n- **三者連携候補:** 西岡優希さん（外国人就労支援）を含む、外国人労働者の採用・受入れ・現場管理の三者連携。\n- **決定事項:** 2〜3ヶ月に1回の情報交換、メンバー表交換、6月リージョンフォーラムでの対面・名刺交換、LINE日報システムの活用事例共有。\n- **注意点:** 要約内に「株式会社次」「フードテック」等の表記があるが、既存運用では次廣側は tugilo、相手側は株式会社風土テックとして記録。正式法人表記は必要に応じて本人確認する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-22\n\n#### 基本情報\n\n- **日時:** 2026-05-22（金）JST 09:00〜TODO（ユーザー提供: 本日9時から）\n- **実施方法:** TODO（Zoom 等、確認）\n- **相手:** 御手洗さん（株式会社風土テック／BNI VORTEX）\n- **紹介者:** 加門さん（BNI VORTEX）\n- **Religo 1to1 レコード:** `one_to_ones.id = 32`（**1セッション＝DB 1行**）\n- **目的:** 初回相互理解。建設業採用支援の具体像、次廣の建設業向け AI 業務改善との接点、相互リファーラル可能性を確認する。\n\n#### 主な成果\n\n- 次廣と御手洗さんが初対面し、相互の事業内容を共有した。\n- 次廣は建設業・製造業向けの AI 業務改善システム構築、御手洗さんは建設業の採用支援を専門としており、顧客層と課題解決アプローチの親和性が高いことを確認した。\n- 特に、外国人労働者の日報管理システムと採用支援の連携、顧客紹介、採用後の定着支援の文脈で具体的な協業可能性が見えた。\n\n#### 話した内容（重要）\n\n##### 1. 次廣側の事業概要\n\n- 次廣は AI業務改善システム構築をカテゴリーとし、建設業・製造業など現場管理が発生する業種を主な支援先としている。\n- システムを単に作るのではなく、業務改善のコーチとして伴走し、入口から業務フローを整理して必要な機能を段階的に追加する。\n- Google Workspace 等を使った簡易的な仕組みから、本格的なシステム開発まで、予算・現場リテラシーに合わせて対応する。\n- 強みは、専門用語を一般の人が理解できる言葉に変換し、現場の負担を増やさずに「誰でも回せる状態」を作ること。\n- AI活用により、従来 600〜800万円規模になりがちなシステムを、120万円から開始し 200万円以内程度で実現できるケースがある。\n- 主に10〜30人規模の企業が効果を実感しやすいという認識を共有した。\n- 表記メモ: 要約では「株式会社次（つぎ）」の記載あり。既存運用上は tugilo として記録しているため、法人表記は必要に応じて確認する。\n\n##### 2. 御手洗さん側の事業概要\n\n- 御手洗さんは大分県出身。病院総務、広告営業での飛び込み営業を経て、大学の先輩が代表を務める風土テックに参画したとの要約。\n- 前職の広告営業では駅の地図広告やデジタルサイネージ広告を扱っていたが、一期一会の営業だけでは顧客の本質的な課題解決につながりにくいと感じ、採用支援の道へ移った。\n- 風土テックは「採用の風土を変えるテクノロジー」という意味合いを持つとの説明があった。\n- 代表はリフォーム会社出身で、新卒採用が得意な会社のノウハウをコンサルティング事業化した。\n- 建設業の採用支援として、週1回の定例ミーティング、毎月の SNS 撮影、無料媒体（Indeed / engage 等）の記事変更、SNS・ホームページ・求人媒体の一貫性づくりを行う。\n- 動画企画、台本作成、撮影まで担当し、TikTok / Instagram など縦型動画でスマホ世代へリーチする。\n- 面接前のリマインド、内定後フォロー、MVV 策定、5年後の組織設計まで採用プロセス全体を設計する。\n\n##### 3. 御手洗さんの採用支援の哲学\n\n- 人材紹介で1人100〜200万円を支払い、辞めたら何も残らない従来型の採用支援ではなく、企業側に採用力を蓄積することを重視している。\n- 週1回のミーティングを通じて、採用について考える時間とノウハウを企業内に残す。\n- SNS で働く人の顔や雰囲気を見せ、求職者が「この人たちと働きたい」と思える情報設計を行う。\n- 採用活動は短期的な応募獲得だけでなく、会社の魅力・想い・働く人を見える化し、採用活動を資産化する取り組み。\n\n##### 4. 次廣側の具体事例\n\n###### 外注ブロック フランチャイズ本部\n\n- DragonFly メンバー・増本さんの会社。全国施工店200社、目標500社規模。\n- Googleフォーム、スプレッドシート、別Excelで注文管理・顧客管理・対応記録が分散し、手作業転記と属人化が発生していた。\n- 受注管理・顧客管理・売上管理を1つのシステムに統合し、情報連携、確認作業削減、担当者に依存しない運用体制づくりを進めた。\n- 増本さんとは DragonFly 立ち上げ時からの知人で、4年間誘われ続けて今期入会した流れも共有。\n\n###### 名古屋の防水工事業・シーリング会社\n\n- 外国人職人が多く、紙の日報では文字が読みにくい、間違いが多いという課題があった。\n- LINE公式アカウントから日報提出できるシステムを構築。\n- 現場での材料使用量、人数、労働時間、経費を記録し、本部で集計できるようにした。\n- 現場負担を減らしながら、請求書作成の元データを自動集計できる点が、御手洗さんの採用支援先とも接続しやすい。\n\n###### 解体業の見積・請求書システム\n\n- リピートが少ない業種で問い合わせが増えにくい課題に対し、LINEで解体現場の写真を送ると仮見積もりを提示し、現地調査後に見積書・請求書を LINE / メールで送信する仕組みを構築。\n- 顧客接点を増やし、問い合わせハードルを下げる改善例として共有。\n\n###### その他事例\n\n- 静岡観光協会の周遊イベント向けスタンプラリー・ビンゴシステム。LINE連携で4年継続中。\n- 動物病院の LINE 予約管理システム。\n\n##### 5. 御手洗さん側の具体事例\n\n###### 神奈川県の水道工事会社\n\n- 週1ミーティング、毎月の SNS 撮影、無料媒体の記事変更を実施。\n- 7ヶ月で32名エントリー、7名入社という大きな成果。\n- 社長や社員の顔出し、会社の雰囲気、水道工事の仕事内容、1日の流れなどを動画で発信。\n- TikTok で興味を持った求職者が engage 等の無料求人媒体で詳細を確認し、メンバー紹介でフルネームを掲載することで安心感を高めた。\n\n###### 埼玉の電気工事会社\n\n- ベトナム人社員が在籍半年未満で、コミュニケーションや報告遅れに課題がある。\n- 紙の日報から LINE やアプリへの移行で改善できる可能性がある。\n- 御手洗さんが、この会社に LINE 日報システムを提案する可能性がある。\n\n#### 協業の可能性\n\n##### 1. 外国人労働者の採用と管理の統合\n\n- 次廣の LINE 日報システムと、御手洗さんの建設業採用支援を組み合わせられる可能性がある。\n- 西岡優希さん（外国人就労支援）との三者連携も候補。西岡さんはベトナム・インドネシアの日本語学校、支援団体ネットワーク、日本語教育、就職斡旋、病院・寮の支援まで関わる文脈がある。\n- 採用、受入れ、現場定着、日報・教育・管理までを一体で提案できる可能性。\n\n##### 2. 顧客紹介\n\n- 御手洗さんの顧客は10〜30人規模の建設業が中心で、次廣の得意領域と一致しやすい。\n- 次廣側の顧客は建設業・製造業の経営者が多く、採用課題を抱えている可能性がある。\n- 士業、税理士、業務改善コンサルとの協業も視野に入る。\n\n##### 3. 補助金・助成金\n\n- IT補助金、AI補助金（今年から新設との要約）を活用し、初期費用の半額〜2/3補助が可能な場合がある。\n- 採用支援とシステム導入を組み合わせた提案パッケージを検討できる。\n\n#### 共通人脈・紹介候補\n\n- **平岡さん:** 次廣・御手洗さん双方とつながりがあり、採用担当者がいる規模の会社を経営している可能性。\n- **増本さん:** 次廣の主要顧客。御手洗さんも建設業交流会で会ったとのこと。\n- **山本杏奈さん:** 業務改善系、DragonFly 入会予定、前回ゲスト参加との要約。\n- **岡本さん:** 大分県出身で御手洗さんと同郷との要約。\n- **佐藤さん（名古屋）:** 高校生専門の建設業界採用支援、教育免許保有との要約。\n- **権堂さん:** 社員教育・定着支援、建設業顧客、MVV策定が得意との要約。表記「強藤氏」は権堂さんの可能性があるため要確認。\n- **山城さん:** 練馬会場トップ、全国大会（北海道）で次廣と意気投合との要約。所属・チャプター表記は要確認。\n- **西岡優希さん:** 外国人就労支援。三者連携候補。\n\n#### 決定事項\n\n- 2〜3ヶ月に1回、定期的に情報交換する。\n- 特に LINE システムの活用事例について、継続的に情報共有する。\n- 御手洗さんは風土テックのメンバー表（38名）を次廣に送付する。\n- 次廣は DragonFly の最新メンバー表を御手洗さんに送付する。\n- 6月のリージョンフォーラム（東京）で対面・名刺交換予定。\n\n#### アクションアイテム\n\n- **次廣:** DragonFly の最新メンバー表を御手洗さんに送付する。\n- **御手洗さん:** 風土テックのメンバー表を次廣に送付する。\n- **両者:** 6月リージョンフォーラムで名刺交換する。\n- **両者:** 西岡優希さんとの三者連携を検討する。2026-05-22 に西岡さんから了承を得たため、次廣から御手洗さんへグループ作成可否を確認する。\n- **御手洗さん:** 埼玉の電気工事会社に LINE 日報システムを提案する可能性を検討する。\n\n#### 紹介進行メモ\n\n##### 西岡優希さんとの三者接続\n\n- **2026-05-22 16:10 JST 前後:** 次廣から西岡さんへ、御手洗さんを紹介したい旨を打診。西岡さんより接続了承を得た。\n- **2026-05-22 16:42 JST 前後:** 次廣から御手洗さんへ、西岡さんの紹介文とともに、御手洗さん・西岡さん・次廣の3名グループを作成してよいか確認する文面を作成。\n- **西岡さん紹介の要点:** DragonFly メンバー。建設業を中心に、外国人技能実習生・育成就労の受け入れ支援を行う。日本語学校や送り出し機関と連携し、企業への人材紹介だけでなく、来日後の生活面・病院対応・寮訪問・定着支援まで手厚くサポートする。\n- **接続理由:** 御手洗さんの建設業採用支援と、西岡さんの外国人材受け入れ・定着支援は、「採用前の入口づくり」と「採用後の受け入れ・生活・定着支援」で前後につながる。\n- **次アクション:** 御手洗さんからグループ作成可否の返答を待つ。了承後、3名グループを作成し、建設業の人材不足・外国人材・定着支援の観点で情報交換へ進める。\n\n#### 確認待ち事項\n\n- 御手洗さんの下の名前、正式役職、プロフィールシートURL。\n- 次廣側の正式法人表記（要約上の「株式会社次」と既存運用の tugilo の関係）。\n- 風土テック / フードテック表記の正式扱い（公式サイトは株式会社風土テック）。\n- 御手洗さんの所属チャプター表記（ユーザー確認では VORTEX。要約内に練馬会場・修声チャプター文脈あり）。\n- 次廣の建設業・製造業クライアントで採用課題を抱える企業の特定。\n- 御手洗さんの顧客で業務効率化・システム化が必要な企業の特定。\n- 西岡さんとの外国人採用・日本語学校ネットワーク・現場管理の連携スキーム。\n- AI補助金の申請要件と対象システム。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 採用支援と業務改善は競合しない。採用前は「人を増やす」、採用後は「増えた人が迷わず動ける仕組みを作る」という前後関係で接続できる。\n- 建設業では、人材不足が表面課題でも、実態は現場連絡・日報・工程・請求・教育の属人化が定着を妨げている可能性がある。\n- 御手洗さんの顧客に対しては、いきなりシステム提案ではなく「採用後に人が辞めない現場づくり」「社長が現場確認に追われない仕組み」という文脈で入ると自然。\n- 風土テックの文脈では、採用は「人を採る」だけでなく、会社の誇り・理念・働く人の想いを可視化して選ばれる状態を作る活動。次廣側は、その後段にある「現場に浸透する仕組み」「教育・日報・共有の運用設計」で接続しやすい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- まずは御手洗さんの「良いリファーラル」の言葉を正確に聞く。建設業特化であっても、対象が元請・下請・専門工事・設備・土木・若手採用・中途採用で大きく変わる。\n- 次廣側の建設業事例は、工程管理・日報・請求支援・LINE連携を中心に、採用後の定着・教育・現場可視化に寄せて話す。特に「MVVや想いを作っても、日々の現場業務に落ちないと定着しない」という接点を探る。\n- 西岡さんの外国人技能実習生支援とも近い領域のため、建設業の人材不足テーマとして、御手洗さん・西岡さん・次廣の三者接点を将来検討する。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 御手洗さんへ紹介できそうな相手\n\n- 若手・職人・現場監督の採用に困っている建設会社\n- 求人広告に費用をかけても応募が少ない会社\n- 採用ページやSNSで会社の魅力が伝わっていない会社\n- 社長が「人がいない」「若い人が来ない」「採っても続かない」と言っている会社\n\n### 御手洗さんから次廣へ紹介してもらえそうな相手\n\n- 採用後の教育・日報・現場連絡・工程管理が整っていない建設会社\n- Excel、紙、LINE、電話で情報が散らばっている会社\n- 採用した人が定着せず、現場の教え方や業務の見える化に課題がある会社\n- 社長・番頭・事務担当の負担が大きく、改善したいが後回しになっている会社\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 御手洗さんは、広告営業での一期一会型の営業経験から、本質的な課題解決に関わりたいという問題意識を持って風土テックへ参画した。\n- 将来的には九州に戻り、東京で学んだことを地元に還元したい思いがあるとの要約。\n- BNI 活動は気分転換にもなっており、1年間で5社顧客獲得・年間1,500〜2,000万円規模の売上増加につながったとの要約。\n- 次廣側は、家族・猫・キャンプ・ジムなどの個人背景と、「頑張らなくても回る仕組み」「時間を生み出すシステム」への関心を共有した。\n- プロフィールシートの表示不整合は、今後の正式記録・DB登録時に確認する。','2026-05-22 16:46:29','2026-06-04 10:53:02'),
(33,1,37,52,NULL,'81436970113','+Q0WkZktQwWta233LUH1jw==','manual','2026-05-25 15:00:00','2026-05-25 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_noguchi_yuko_hair_salon_viv.md】\n\n# 1to1_野口裕子_HAIR SALON ViV\n\n---\n\n**文書の位置づけ:** DragonFly メンバー・野口裕子さんとの 1to1 を **1ファイルで時系列管理**する。  \n**日時:** 第1回 **2026-05-25 JST 15:00〜実施済み**（終了時刻は Zoom メタ等で TODO）。  \n**整理:** 野口さんは **個人経営・スタッフなし** の HAIR SALON ViV オーナー。**BNI 退会決定**（火曜営業の売りと定例会の両立不可）。次廣は **AI業務改善・予約管理システム開発中**。**パソコン相談は無償サポート合意**。軍司さん経由で LINE 予約システム構築（3ヶ月契約）実施中。夏頃の予約システムリリース時に次廣から提案予定。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※BNI プロフィールシート・会員名簿ベース（2026-05-25 ユーザー提供）。\n\n### 野口裕子さん\n\n- **名前:** 野口 裕子（のぐち ゆうこ）\n- **所属:** HAIR SALON ViV（ヘアーサロンヴィヴ）／オーナー\n- **カテゴリー:** 若返り育毛ヘッドスパ（名簿上は美容・健康・生活）\n- **所在地:** 〒286-0221 千葉県富里市七栄463-14\n- **電話:** 0476-85-7101\n- **メール:** yutan.28722@gmail.com\n- **Web:** https://hair-salon-viv.com\n- **Facebook:** https://www.facebook.com/share/1BbrRAut71/?mibextid=wwXIfr\n- **BNI 入会日:** 2026-03-24（宣誓式）\n- **BNI 退会:** **2026年5月で退会決定**（第1回 1to1・2026-05-25 確認）。個人経営サロンと **火曜午前定例会** の両立が困難。定例会中は電話対応不可、実質 **週休が2日に減る** 負担。\n- **BNI 過去:** 約2年前に一度入会予定があったが **体調不良で入院** し延期。その後今回入会。\n- **火曜営業の位置づけ:** 千葉では美容院の **火曜定休が一般的**。ViV は **火曜も営業** しており、それ自体が **差別化・売り**。\n- **事業形態（第1回 1to1 確認）:** **個人経営・スタッフなし**。営業時間は不規則で **夜7時からの予約** もあり、食事時間の確保が困難。\n- **財務（本人共有）:** **自宅兼店舗** のローンを **80歳まで一人で返済** 中。\n- **ITリテラシー:** パソコン操作が不慣れ。専門用語が理解しにくい。平山真由美さんが訪問サポート、倉持さんが Zoom 設定支援など DragonFly 内の支援歴あり。\n- **健康（本人共有）:** 下の血圧が高く **血圧差が狭い**。水素水を推奨している。\n- **美容師歴:** 30年\n- **過去職:** 事務、ガソリンスタンド、エステサロン\n- **出身・居住:** 神奈川県横浜市生まれ。父の転勤で茨城県鹿島市、震災後に千葉県成田市。現在は富里市に6年。\n- **家族:** 配偶者なし。娘2人（1人は学生時代に芸能プロダクションからスカウト）、息子1人\n- **趣味:** 一人旅、ドライブしながら神社仏閣巡り、食べること\n- **関心事:** 数秘術を勉強中\n- **人柄（本人記載）:** 人見知り、天然、人前で喋るのが苦手\n- **強い願望:** 男女問わず、髪に悩むすべての人に希望と自信を届け、イキイキと若々しさと品格を創り続ける\n- **成功の鍵:** アナログ卒業、できないことを克服、いくつになっても挑戦すること\n\n### HAIR SALON ViV / 事業概要\n\n- **専門:** 美容全般、エステ、まつ毛パーマ、ホルミシス商材。中核は **若返り育毛ヘッドスパ**（オゾンヘッドスパ・ケアメニュー）\n- **強み:** ゆっくりリラックスできる空間、肌に優しい商材、オゾンヘッドスパで若々しく整える。全国限定1000店舗のみのサロン専売 **オーガニック無添加** シャンプー・トリートメント・ヘアケア商材。**火曜も営業**（千葉の美容室では定休日が火曜の店が多く、平日調整しやすい来店導線になる）\n- **理想のお客様:** 髪と頭皮のコンディションを整え、清潔感・第一印象を大切にしたい方。**経営者・営業職** が多い。ハリコシ・ボリューム、リラックスしながらケアしたい方\n- **話の切り出し方（本人記載）:** 「髪や頭皮のコンディションを整えながら、その方の印象や自信につながるお手伝いをしている美容室です。最近、髪の変化・ボリューム・ハリツヤが気になる方のお悩みに寄り添いながらケアしています。」\n\n### 予約・集客の現状（第1回 1to1 確認）\n\n- **ホットペッパー:** 最低ランク **月額38,500円** ＋ポイント還元で、月によっては **マイナス収支**。\n- **現在:** 有料プランは **1年で解約**。予約機能のみ無料継続 ＋ ポイント支払い。\n- **予約ミス:** **紙ベースとの併用** で記入漏れ・ダブルブッキングが発生。\n- **失敗例:** 駅店時代、予約通知が届かずトラブル（ホットペッパー依存のリスク）。\n- **顧客傾向:** 男性は固定客、女性は店を転々とする傾向。田舎でも美容室多数。クーポン目当ての新規客が多い。\n- **下階の美容室:** 大病院から独立7年目、固定客で安定経営（対比事例）。\n\n### デジタル・予約システム（関連）\n\n- **軍司さん:** 税理士で集客に強い。**野口さんの LINE 予約システム構築** を **3ヶ月契約** で実施中。\n- **次廣（tugilo）:** **予約管理システム** を開発中。**夏頃リリース** 予定。個人サロン向け低価格・広告機能なし・事業者目線の提案型。リリース時に野口さんへ提案予定。\n\n### G.A.I.N.S.（本人記載）\n\n| 項目 | 内容 |\n|------|------|\n| **Goal** | 老若男女がワクワクしながら通える、夢の世界に迷い込んだような美容室。シンデレラ城のような特別感、お子様向け遊具スペース、ご家族皆様で楽しめる空間。トータルビューティー、家族の思い出が残る写真撮影サービスも提供したい |\n| **Accomplishments** | 美容師歴30年。幅広い年代・お悩みに応じた最適施術の提案実績。来るたびに心が満たされる特別な時間を届ける |\n| **Interests** | 一人旅、ご当地巡り。「宇宙人を探して友達になること（笑）」 |\n| **Networks** | 軍司さん（LINE予約・3ヶ月契約）、平山真由美さん（訪問ITサポート）、倉持さん（Zoom設定）、増本さん（近所・外注ブロック）、主性クラブ静岡（今西さん・千恵さん看護師 等） |\n| **Skills** | 若返りヘッドスパ・30年美容師。アナログ運用からのデジタル移行中（ITは苦手） |\n\n### チャプター内の接点（参照）\n\n- **2026-05-19 定例会:** 牧真一さんが代理出席し、若返り育毛ヘッドスパ（オゾン・水素）について代理プレゼン\n- **ビジター紹介履歴（名簿）:** 西浦雅さん、今西俊明さん、清原佳彩美さん、舩杉牧子さん 等との接点あり\n- **第1回 1to1 で言及:** 平岡さん（BNI全国協会役員・勧誘）、ジンボウさん（次廣経由で 1to1 リファラル予定）\n\n### BNI 退会に関する本人の負担感（第1回 1to1）\n\n- 毎週 **リファーラルまたは物販購入** が必要で負担感\n- **メンター入力** の月曜午前までの催促がストレス\n- 退会後は **メンバーリストから即削除**（代理出席時点で既に消去された体験）\n- 女性メンバーから退会者への **ドライな対応** があるとの認識\n- チャプター内に **静岡派・千葉派** の地域感\n\n### 次廣側（共有する固定情報）\n\n- **屋号:** tugilo（ツギロ）\n- **カテゴリー:** AI業務改善システム構築\n- **拠点:** 静岡県藤枝市。オンラインで全国対応\n- **強み:** 業務の流れを整理し、Excel・紙・LINE・属人化している作業を、現場に合わせて無理なく仕組み化する\n- **公開サイト:** https://tugilo.com\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** 第1回 1to1 **実施済み**（2026-05-25）。野口さんは **BNI DragonFly 退会決定** だが、**次廣とのつながりは継続** 合意。\n- **主な成果:** 事業・BNI退会背景・予約課題（ホットペッパー・紙併用）を相互理解。**次廣のパソコン相談無償サポート** 合意。次廣の **夏頃リリース予定の予約管理システム** をリリース時に提案する流れ。\n- **野口さん側の進行中:** **軍司さん** による LINE 予約システム構築（**3ヶ月契約**）。\n- **次廣のアクション:** 今週中に本 1to1 を **Religo DB 登録済み**（`one_to_ones.id = 33`）。**ジンボウさん** との 1to1 を次廣経由リファラルとして実施。夏頃システムリリース時に野口さんへ営業。美容業界で面白い人と会ったら野口さんへ紹介。\n- **IT・当日:** Zoom カメラ不具合 → ノートPCの **シャッター閉** が原因と判明。BNIアカデミーはログイン不具合で焦燥経験あり。\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n**進行イメージ:** お互い「事業紹介 → 質疑応答」が各30分前後。  \n**野口さん向け配慮:** 堅いビジネス用語より、**空間・お客様の変化・家族** の話から入ると話しやすい。  \n**今日のスタンス:** **事業紹介が主役**。リファーラル・今後の繋がり・退会後の接点は **深追いしない**。後半で **PC・システムの相談窓口** を自然に伝える。\n\n| パート | 内容 | 目安 |\n|--------|------|------|\n| オープニング | あいさつ・今日の進め方の合意 | 約3分 |\n| 前半 | 野口さんの事業紹介 → こちらから質問 | 約30分 |\n| 後半 | こちらの事業紹介 → **困ったら聞いて** の一言 | 約30分 |\n| クロージング | お礼・軽く締める | 約2〜3分 |\n\n### 1. オープニング（信頼の橋）\n\n> 「野口さん、本日はお時間ありがとうございます。DragonFly の次廣です。  \n> プロフィールシート、とても丁寧に書いていただいているのを拝見しました。人見知り・人前でのお話が少し苦手と書かれていたので、今日は堅苦しくなく、ゆっくりお話しできたらと思っています。  \n> 今日は **お互いの事業紹介** がメインで、前半は野口さん、後半は僕、という流れでよろしいですか？」\n\n**退会への共感（任意・一言だけ）**\n\n> 「火曜が休めないお話、よく分かります。千葉だと火曜休みの美容室が多いですし、それが ViV さんの強みでもあるんですよね。」\n\n### 2. 前半：野口さんの事業紹介〜質疑応答\n\n**入口（本人の切り出し文を尊重）**\n\n> 「プロフィールに書いていただいた通り、『髪や頭皮を整えながら印象と自信につなげる』お仕事、という理解で合っていますか？ いま一番、お客様に喜ばれているメニューや来店理由はどんなところですか？」\n\n**深掘り質問（必要なぶんだけ・ビジネス理解用）**\n\n- 「**経営者・営業の方** が多いと書かれていましたが、どんなタイミング・どんな悩みで来られることが多いですか？」\n- 「オゾンヘッドスパや、全国1000店舗限定のオーガニック商材 — 初めての方に一番伝わりやすい **体験の入口** は何ですか？」\n- 「**火曜も営業** されているとのことですが、お客様からはどんな反応がありますか？」\n- 「G.A.I.N.S. に書いていた **シンデレラ城のような空間** や、お子様の遊具、家族写真 — いま進んでいる部分と、これから実現したい部分を教えてください。」\n- 「プロフィールの **『アナログ卒業』** — いまデジタルやパソコンで、困っていること・これからやりたいことはありますか？」（後半の「聞いて」への自然な橋渡し）\n\n**聞かないこと（今日は深追いしない）**\n\n- 良いリファーラルの条件詰め\n- 第三者紹介用の一言の確定\n- 退会後の LINE 交換・個人紹介の約束\n- BNI 継続・今後の繋がりの打診\n\n### 3. 後半：こちらの事業紹介〜「困ったら聞いて」\n\n**事業紹介（短め・美容室オーナー向け）**\n\n> 「僕は tugilo という屋号で、**パソコンや業務のデジタル化** が中心の仕事をしています。  \n> Excel や LINE、紙、担当者の記憶に頼っている部分を、現場に合わせて小さく整理する —— いきなり大きなシステムではなく、**困っているところから** 一緒に考えるタイプです。  \n> 予約の確認、お客様情報、SNS、ホームページ、データのバックアップなど、オーナーさんが一人で抱えがちな部分で相談を受けることが多いです。」\n\n**核心（今日のギフト）**\n\n> 「野口さんのプロフィールで **『アナログ卒業』** と書かれていたのが印象的でした。  \n> 僕の仕事は、いつも **案件を売り込む** というより、**困ったときに相談してもらう** スタンスに近いんです。  \n> パソコンの操作、Excel、予約アプリ、LINE、ホームページ、データが消えた、何から手をつければいいかわからない —— そういうとき **なんでも聞いてください**。  \n> チャプターにいる間だけ、という縛りもないので、退会後でも、気軽にメールや LINE で大丈夫です。」\n\n**野口さんからの質問を促す**\n\n> 「デジタルやパソコンで、いま気になっていること・後で聞きたいことがあれば、遠慮なく教えてください。」\n\n### 4. クロージング（シンプル版）\n\n> 「今日はありがとうございました。ViV さんのお仕事、30年の経験と火曜も営業されている強み、よく分かりました。  \n> 僕のほうは、**パソコンやシステムで困ったら、いつでも声をかけてください**。  \n> 今日は本当にありがとうございました。」\n\n**実施直後に自分メモ:** 事業の要点 / 火曜営業の訴求 / アナログ卒業で困っている具体 / デジタル相談の温度感\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-25 実施済み\n\n#### 基本情報\n\n- **日時:** 2026-05-25（月）JST 15:00–TODO（Zoom 文字起こし要約反映。終了時刻は Zoom メタ等で確認）\n- **実施方法:** Zoom（カメラはノートPCシャッター閉で不具合→解決）\n- **相手:** 野口裕子（HAIR SALON ViV／BNI DragonFly → 退会決定）\n- **Religo 1to1 レコード:** `one_to_ones.id = 33`（**1セッション＝DB 1行**。終了時刻は TODO のため `ended_at = null`）\n- **目的:** お互いの事業紹介。BNI退会背景の理解。パソコン・予約・IT相談。退会後も次廣との接点継続。\n\n#### 主な成果\n\n- 野口さんは **個人経営・火曜営業** と **火曜午前のBNI定例会** が両立できず、**BNI退会を決定**。\n- 次廣は **予約管理システム** を開発中（夏頃リリース）。野口さんへ **リリース時に提案** する流れ。\n- **次廣のパソコン関連相談を無償サポート** で合意。BNI退会後もつながり継続。\n- **軍司さん** による LINE 予約システム（3ヶ月契約）が進行中であることを確認。\n- **ジンボウさん** との 1to1 を次廣経由リファラルとして実施する合意。\n\n#### 話した内容（重要）\n\n※以下はユーザー提供 **Zoom 文字起こし要約**（2026-05-25 反映）。[引用] は省略。\n\n##### 1. 野口さんの事業・退会背景\n\n- **個人経営・スタッフなし** で美容室運営。営業時間不規則（夜7時予約あり）、食事時間確保が困難。\n- **火曜営業** は千葉では差別化だが、DragonFly **火曜午前定例会** で電話対応不可。**週休2日化** が負担。\n- 約2年前にBNI入会予定→ **体調不良入院** で延期。今回入会後、**2026年5月退会決定**。\n- **自宅兼店舗ローン** を80歳まで一人返済。IT・パソコンは不慣れ、専門用語が苦手。\n- BNI負担: 毎週リファーラル/物販、メンター月曜入力催促、退会後リスト即削除、女性メンバーのドライな対応など。\n\n##### 2. 予約・集客の課題\n\n- **ホットペッパー:** 月額38,500円〜、ポイント還元で月によってマイナス。1年で有料解約、予約機能無料＋ポイント支払い継続。\n- **紙とデジタル併用** で記入漏れ・ダブルブッキング。駅店時代は通知不達トラブル。\n- 男性固定客・女性は転店傾向。クーポン新規依存。下階サロンは固定客で安定（対比）。\n\n##### 3. 次廣側の共有\n\n- **予約管理システム** 開発中（2026年夏頃リリース）。事業者目線・開業時間効率提案・個人サロン低価格・広告なし。動物病院・サロン等汎用。\n- 増本さん事例: 従来500〜800万円相当を約200万円規模で提供した文脈も共有。\n- **パソコン相談は無償** — 退会後も継続。脳梗塞後は記録習慣化、降圧剤で血圧安定など健康管理の話も。\n- BNI活用（次廣側メモ）: トレーニング出会いの他メンバー経由リファラル化、スクリーンショット記録、顧客のつながり欲求記録など。\n\n##### 4. 人脈・関連\n\n- **軍司さん:** 税理士・集客強。野口さん LINE 予約 **3ヶ月契約** 構築中。\n- **増本さん:** 近所。外注ブロック展開、新商品スプレー販売予定。\n- **平岡さん:** BNI全国協会役員、積極勧誘。\n- **主性クラブ静岡:** 今西さん、千恵さん（看護師）等、複数 DragonFly メンバー所属。\n- **ジンボウさん:** 次廣経由で野口さんと 1to1 リファラル予定。\n\n##### 5. 当日のITトラブル\n\n- Zoomカメラが開かない → **ノートPCカメラシャッター閉** が原因。\n- BNIアカデミー **ログイン不具合** で焦燥。平山・倉持による支援歴も話題に。\n\n#### 決定事項\n\n- 野口さんは **BNI退会** するが、**次廣とのつながりは継続**。\n- 次廣は **パソコン関連相談を無償サポート**。\n- 次廣は **夏頃の予約システムリリース時** に野口さんへ提案・営業。\n- **ジンボウさん** との 1to1 を次廣経由 **リファラル** として実施。\n- 野口さんは **軍司さんの LINE システム構築（3ヶ月）** を継続。\n\n#### アクションアイテム\n\n- **次廣:** 今週中に野口さんとの 1to1 を **Religo DB 登録済み**（`one_to_ones.id = 33`）。\n- **次廣:** **夏頃** 予約システムリリース時に野口さんへ営業・提案。\n- **次廣:** 美容業界で面白い人とつながったら野口さんへ紹介。\n- **次廣:** **ジンボウさん** との 1to1 をリファラルとして手配・実施。\n- **野口さん:** 軍司さん LINE 予約システム **3ヶ月契約継続**。\n\n#### 確認待ち事項\n\n- 第1回の **終了時刻**（Zoom メタ）\n- Religo **`one_to_ones.id`**\n- **ジンボウさん** の正式氏名・事業（DragonFly 内照合）\n- 予約システム **正式リリース時期・価格帯**（夏頃の具体月）\n- 軍司さん LINE 構築と次廣予約システムの **役割分担・競合/補完** の整理\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **退会理由は「やる気不足」ではない。** 火曜営業（売り）× 火曜定例会 × 個人一人運営 × 毎週RP/物販/メンター入力 — **構造的に無理** に近い。\n- **予約の本丸:** ホットペッパーはコスト・クーポン客問題。紙併用で **ダブルブッキング**。**軍司LINE（短期）** と **次廣予約システム（夏・低価格）** が並行。リリース時は **軍司案件との関係** を整理して提案する。\n- **IT支援:** 専門用語を避け、**無償相談窓口** が信頼の核。平山・倉持と役割分担（訪問/ZOOM設定 vs 業務・システム）。\n- **BNI退会後:** チャプターRPは終わるが **個人関係は継続合意**。リスト即削除体験 — 退会者へのドライさは本人のストレス要因。\n- **紹介の逆方向:** 美容業界の「面白い人」→ 野口さん。次廣の記録・紹介文化と相性あり。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **短期:** 1to1 は **Religo DB 登録済み**（`one_to_ones.id = 33`）。ジンボウさん 1to1 を **リファラルとして実施**（野口さんへのギバー）。\n- **中期:** **夏頃** 予約管理システムリリース → 野口さんへ提案。訴求軸: ホットペッパー脱却・紙併用ミス解消・個人サロン低価格・広告なし。\n- **継続:** **PC相談無償** — 売り込みより信頼。軍司さん LINE 案件と **競合せず補完**（予約統合・紙デジタル二重管理の整理等）を意識。\n- **記録:** Religo 登録・紹介条件メモ（富里・火曜営業・個人サロン・IT苦手）。\n\n---\n\n## ■ リファーラル戦略\n\n**BNI:** 退会前に **本1to1をRP記録**。**ジンボウさん→野口さん** の 1to1 を次廣経由で実施（合意済み）。\n\n### 野口さんへ紹介できそうな相手\n\n- 千葉・富里・成田周辺、**火曜に予約したい** 方\n- 美容業界で **野口さんと話が合いそうな経営者**（次廣アクション: 面白い人と会ったら紹介）\n\n### 次廣へ（野口さん側）\n\n- 予約システム **夏リリース時の早期ユーザー候補**（ただし軍司 LINE 3ヶ月契約中 — タイミング調整）\n\n### 関連メンバー\n\n| 氏名 | 関係 |\n|------|------|\n| 軍司さん | LINE予約3ヶ月構築（進行中） |\n| 平山真由美さん | 訪問ITサポート |\n| 倉持さん | Zoom設定支援 |\n| 増本さん | 近所・外注ブロック |\n| ジンボウさん | 次廣経由1to1リファラル予定 |\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 人見知り・天然・人前が苦手 — 今日は **深い話・健康管理・BNIの本音** まで開いた。\n- **80歳までローン** — 経営プレッシャー大。無償PC支援は **信頼投資** として妥当。\n- 2年前入院でBNI延期 — **体調・無理** への敏感さ。押し売り厳禁。\n- Zoomシャッター・BNIアカデミー不具合 — **ITへの不安・焦り** が具体。専門用語少なめ。\n- 退会後も **次廣とのつながり継続** — BNIリスト削除とは別の個人関係。\n- 文字起こし要約に「8人の子供を持つバーバー（おそらく祖母）」の記載あり — **野口さん本人のプロフィールと不一致。誰の話か要確認**（2026-05-25）。','2026-05-25 20:26:20','2026-06-04 10:53:02'),
(34,1,37,17,NULL,NULL,NULL,'manual','2026-04-03 07:15:00','2026-04-03 07:15:00','2026-04-03 08:15:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_sato_takuto_brightlink.md】\n\n# 1to1_佐藤拓斗_ブライトリンクコンサルティング\n\n---\n\n**文書の位置づけ:** 同一人物との 1to1 を **1ファイルで時系列管理**する。BNIプロフィールをベース情報とし、回ごとに追記してサマリー・累積インサイト・戦略を更新する。  \n**整理:** tugilo（次廣 淳）  \n**チャプター:** BNI DragonFly  \n**事実と仮説:** 「抽出された課題」は**会話で言及された事実**中心。「仮説（tugilo視点）」は**解釈・構造づけ**（根拠を併記）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※BNIプロフィールベース（**変わらない情報**）。Web・名簿の改定があったら本節のみ更新する。\n\n- **名前:** 佐藤拓斗\n- **会社名:** 株式会社BrightLink\n- **役職:** 代表取締役\n- **カテゴリー:** 建設業向け高校生新卒採用コンサル\n- **所在地:** 愛知県名古屋市中区栄2丁目3-1\n- **出身地:** 静岡県藤枝市\n- **経験年数:** 5年\n- **URL:** https://brightlink-consulting.com/\n\n**補足（過去メモとの突合）:** 旧メモに「ブライトリンクコンサルティング」表記あり。**正式社名は上記（株式会社BrightLink）** とする。Zoom要約では氏名が「拓人」表記の箇所あり → **同一人物（拓斗）**。\n\n### ■ 事業概要\n\n- 高校生新卒採用の仕組み構築（**戦略〜学校訪問まで一貫**）\n- 建設・製造業など**中小企業**向け\n\n### ■ 強み\n\n- **一気通貫支援**（戦略〜実行）\n- **高校生採用に特化**\n- **採用ノウハウの内製化**支援\n\n### ■ ターゲット\n\n- 従業員 **20〜30名以下**\n- **若手採用**できていない企業\n\n---\n\n## ■ サマリー（最新状況）\n\n- **現在の関係性:** BNI DragonFly 内で **初回 1to1 実施済み**（**第1回: 2026-04-03（JST）07:15–08:15・Zoom**）。双方の事業共有のうえ **テレアポリスト自動作成** の開発可能性を検討開始。静岡県藤枝市の地元共通点・教育観の共感があり、協力の土台を作った段階。\n- **進行中のテーマ:** ① テレアポリスト（現状 **手作業・約1時間100件**）の自動化 ② リクナビネクスト等から **従業員数30名以下** 等での抽出（**スクレイピング・法的リスク要確認**）③ Google ビジネスプロフィール周りの **二次利用** と個人事業主リスト案 ④ **5月16–17日頃** 静岡帰省時の **対面** ⑤ **名古屋出世クラブ（5月末）** 参加の検討（今西氏が佐藤氏を誘致中）\n- **次アクション:** **次廣** — 求人媒体・公開データの **技術調査**、**利用規約・法的リスク**整理、提案準備。**佐藤** — 帰省日程確定後に連絡、対面調整。**双方** — 出世クラブ参加可否。**調査結果の中間共有:** 対面前推奨（**TODO: 対面の1週間前まで** を目安に設定推奨）\n- **提案書素案用ブリーフ:** [2026-04-14_sato_brightlink_listing_pipeline_proposal_brief.md](../../proposals/2026-04-14_sato_brightlink_listing_pipeline_proposal_brief.md)（目的・手段・効果・リスク・未確認事項の整理）\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-04-03\n\n#### 基本情報\n\n- **日時:** **2026-04-03（金）JST 07:15–08:15**（60分）。**取得元:** ユーザー確認（当日の1to1実績）。※過去の Zoom要約段階では日時未記載だったため、本項で確定。\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 34`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※**削減せず**蓄積。以下は Zoom要約・当時の整理メモからの**記録**。\n\n- **主な流れ:** 次廣淳（AI・業務改善システム構築）と佐藤拓斗（高校生新卒採用コンサル）が BNI ドラゴンフライチャプターで **初回 1on1**。両者の事業内容を共有し、**テレアポリスト自動作成システム**の開発可能性について具体的検討を開始。静岡県藤枝市という地元の共通点から、今後の協力関係構築の基盤を確立した、との整理。\n- **決定・合意:**\n  - **リスト作成システムの検討開始:** 佐藤氏のテレアポリスト作成業務（現在手作業で **1時間100件**）を自動化するシステムについて、次廣氏が **技術的実現可能性を調査**。\n  - **求人媒体からのデータ取得:** リクナビネクスト等の求人サイトから、**従業員数30名以下** などの条件で自動抽出する仕組みを検討。**スクレイピング技術の活用**、ただし **法的リスクの確認が必要**。\n  - **5月中旬の再会:** 佐藤氏の静岡帰省時（**5月16–17日頃**）に **対面ミーティング** を設定する方向。\n- **次廣側で共有された事業内容:**\n  - **業務改善システム構築:** エクセル・スプレッドシートで分散管理されているデータを一元化し、リアルタイムでの進捗確認を実現。\n  - **LINE活用システム:** 問い合わせから見積もり、請求までを LINE 公式アカウントで完結させる仕組み（建設業向け）。\n  - **スタンプラリー・ビンゴシステム:** 静岡観光協会向けに **5年間運用中**。\n  - **施工管理・日報システム:** 名古屋のシーリング会社向けに、外国人労働者でも入力しやすい LINE ベースの業務日報システムを構築。\n  - **事業の特徴:** ゼロから1を作れる／既製ツールの押し付けではなく現場フローに合わせたカスタマイズ。**小さく始めて改善**（大規模を一気に入れず、入力から段階拡張）。**現場負担の最小化**（経営と現場のギャップを埋め、現場にベネフィットを与える設計）。\n  - **経歴・背景:** システム開発歴 **25–26年**（大学中退後一貫、現在 **52–53歳**）。BNI は増本氏・今西氏との静岡出世クラブでの **約10年の付き合い** から **2024年** にドラゴンフライ参加を決意。動機は技術一辺倒からの転換・仕事の幅拡大。**MSP（メンバーサクセスプログラム）** で学んだビジネススキルに感銘、トレーニング注力中。\n- **佐藤側で共有された事業内容（1to1上の詳細・プロフィールと照合可）:**\n  - **高校生新卒採用の仕組み構築:** ホームページ制作、パンフレット・動画制作、学校訪問代行、求人資料郵送代行まで一括。\n  - **4月依頼でも7月解禁に間に合う** 短期対応が可能。**全国対応**（BNI参加により全国展開が加速）。\n  - **ターゲット:** 従業員 **30名以下** が中心（プロフィールは **20〜30名以下** — 会話では30名以下条件でリスト抽出の話あり）。タイプ **3つ**: ①高校生採用のやり方が分からない ②やりたいが時間・人員不足 ③応募が来ない（我流で抜けがある）。業種: 建設業、製造業、自動車整備、ビルメンテナンス、清掃、介護福祉など。\n  - **実績:** **2024年度** 29社サポート、14社で採用成功（成功率 **約48%**）。**過去5年** 毎年40社以上サポート（2023年32社、2024年は50社近く）。\n  - **経歴・背景:** 事業歴 **5年**。新卒で高校生新卒採用コンサル会社に入社、**2024年3月に独立**（当時 会社設立から **1年** と共有）。学歴: 清水東高校→静岡大学→早稲田大学編入→早稲田大学大学院（**教員免許保有**）。**将来ビジョン:** 高校生以下を対象としたキャリア教育事業。**五教科と社会を結びつける授業** で子どもの将来の選択肢を広げたい。\n- **確認待ち（会話上の論点）:**\n  - リクナビネクストからのデータ取得: **技術的実現可能性** と **法的リスク（利用規約上の二次利用制限）** を次廣氏が調査中。\n  - Google マイビジネス API: 個人事業主リスト作成について、**二次利用禁止ルール** があり、公開情報からの取得方法を検討。\n- **共通点・シナジー:**\n  - **地元:** 両者とも静岡県藤枝市出身・在住。佐藤氏は藤枝市古利（西焼津小学校区）、次廣氏は青葉町（青島中学校区）。\n  - **教育への関心:** 次廣氏は娘の受験を控え、佐藤氏のキャリア教育理念（五教科と社会の結びつけ）に強く共感。\n  - **システム×採用:** 次廣氏は静岡県の大卒求人サイト **「三並び」** のアプリ開発を受注中。**大学生がメールを見ない** ため通知機能が必要、という課題を共有。\n- **アクションアイテム（当時の整理）:**\n  - 次廣氏: 求人媒体からのリスト自動作成システムの **技術調査・提案準備**。\n  - 佐藤氏: **5月中旬の静岡帰省日程確定後**、次廣氏に連絡。\n  - 両者: **名古屋出世クラブ（5月末）** への参加可能性を検討（今西氏が佐藤氏を誘致中）。\n- **次回ミーティング:** **5月16–17日頃**、佐藤氏静岡帰省時に **対面** で実施予定。\n- **プライベート文脈（会話に出た事実の記録・紹介判断とは分離）:** 婚活、飯田氏からの占い（**32歳で結婚** 等）、保険担当の高校同級生からの紹介の動きなどが要約に含まれる。**取り扱い注意。本人確認のうえ参照。**\n\n#### 抽出された課題（事実：会話で言及）\n\n- テレアポ用リスト作成の **手作業負荷**（約1時間100件ペース）。\n- 求人媒体からの自動取得は **技術** に加え **利用規約・法的リスク（二次利用）** の確認が必要、との合意。\n- Google マイビジネス／公開情報は **二次利用禁止** の話題があり、個人事業主リストは **取得経路の設計** が課題。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** リスト作成が **コンサル本業とリソース競合** している。**根拠:** 手作業1時間100件の共有。**構造（仮説）:** リード前処理が属人・手作業 → 営業・提案に振る時間が圧迫 → スケールしにくい。\n- **課題②:** データ取得は **「作れるか」より「取ってよいか」** が先に決まる。**根拠:** スクレイピング・API の **法的リスク確認** が合意事項。**構造（仮説）:** 技術要件とコンプライアンスが分離できないと、開発が進んでも運用不能になりうる。\n- **シナジー:** 「採用」周辺に **通知・進捗・フォロー** のデジタル化が横展開しうる。**根拠:** 三並び案件で **メールを見ない大学生** と通知ニーズの共有。**仮説**としての展開可能性。\n\n#### 次アクション\n\n- 次廣: 技術調査・法務・規約リスク整理・提案準備。\n- 佐藤: 帰省日程確定後に連絡 → 5/16–17頃 対面設定。\n- 双方: 名古屋出世クラブ（5月末）参加の検討。\n\n---\n\n### 【第2回】YYYY-MM-DD\n\n※開催後、**同じ見出しレベル**で追記。日時（年月日・時刻）・実施方法・話した内容を必ず残す。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n※回をまたいで見えてきた構造。**追記するたびに更新**。\n\n- **本質的な課題:** 営業前処理（リスト）の **工数** と **コンプライアンス** がセットで、システム化の成否を握る（**事実ベースの論点**に、運用設計が従う）。\n- **ビジネス構造:** 佐藤氏は **採用コンサル（戦略〜実行の一気通貫）** がコア。フロントでは **テレアポ用リスト** が負荷。次廣側は **業務フローに合わせたカスタム開発** と **LINE／通知** の実績がある。\n- **ボトルネック:** **許容されるデータソース** が未確定のうちは、開発スコープが固定できない（求人媒体・Google 周りの **規約・法務**）。\n- **攻めるべきポイント:** ① **データソースの線引き**（求人媒体・公開情報・手入力の役割分担）② **MVP**（取得・整形・更新の最小ループ）③ **対面** でのスコープ合意（藤枝・教育観での信頼を案件設計に接続）\n\n---\n\n## ■ tugiloとしての戦略\n\n- **どこで価値を出すか:** リスト生成〜更新の **業務フロー設計** と、**許容ソースに沿った取得・整形**（法務・規約の整理を含む）。必要に応じ **通知** など採用コミュニケーション周辺へ拡張しうる。\n- **初回案件の切り口:** **「違法・規約違反にならない範囲で、再現性あるリスト作成パイプライン」** を定義するところから（技術だけ先に走らない）。\n- **案件化シナリオ:** 調査結果で **技術＋法務可能範囲** を提示 → **5月中旬対面** で要件・優先順位を固定 → **小さくリリース**（取得経路の安定性優先）。\n- **中長期の関係性:** 地元・教育観の接点に加え、**採用×デジタル**（通知、学生・学校側の行動変化）で継続対話しやすい。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n※**仮説・運用メモ**（紹介時は相手の最新ニーズを確認）。\n\n- **紹介しやすいパターン:**\n  - **建設・製造・整備・ビルメンテ・清掃・介護福祉** など、**中小（従業員〜30名前後）** で **高校生採用** をこれからやりたい／やっているが **応募が来ない・手が回らない** 経営者・人事担当。\n  - **戦略から学校訪問まで一気通貫**で伴走できるニーズ（「採用ノウハウを内製化したい」含む）。\n  - **4月依頼でも7月解禁に間に合わせたい** タイムラインの相談。\n- **NGリファーラル（仮説）:**\n  - **大企業の新卒一括**のみ・**RPOだけ** など、**高校生採用ドメインに合わない**紹介。\n  - **採用ニーズが明確にない**紹介先への送客（双方の信頼を損ねやすい）。\n  - 詳細は **本人に合うか都度確認**。\n- **相性の良い業種（1to1・プロフィールで言及）:** 建設、製造、自動車整備、ビルメンテナンス、清掃、介護福祉（**若手・高校ルート**に課題がある中小）。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **人物印象:** 採用実績、独立後の事業フェーズ、**キャリア教育** への長期ビジョンが会話に出ていた（要約ベース）。**事業と人物が一体**として語られていた印象。\n- **温度感の推移:** **第1回時点: 高** — 初回から具体テーマ（リスト自動化）に入り、対面予定・地元・教育の接点あり。\n- **趣味・関心:** **教育・キャリア**（五教科と社会、高校生以下への展開ビジョン）。地元（藤枝市・学区レベルまで）の話が出た。\n- **関係性構築ポイント:** ① **対面（静岡・5月中旬）** で信頼とスコープを固める ② **出世クラブ** 等の横の接点で継続接触 ③ **採用×システム** の横展開（三並びの通知ニーズなど）は **別案件** だが知見共有の接点になりうる。\n- **その他:** 飯田氏の占い・紹介の話は **要・本人確認**。三並びは **別案件** だが通知・学生コミュニケーションの知見は本テーマに接続可能。\n\n---\n\n## 文書変更ログ\n\n| 日付 | 内容 |\n|------|------|\n| 2026-04-14 | **提案ブリーフ** [2026-04-14_sato_brightlink_listing_pipeline_proposal_brief.md](../../proposals/2026-04-14_sato_brightlink_listing_pipeline_proposal_brief.md) を追加。`docs/proposals/` へ配置（INDEX 連携）。 |\n| 2026-04-15 | 議事要約を `docs/meetings` に整理・保存 |\n| 2026-04-03 | Zoom要約を反映し、tugilo式フォーマット（旧 §1–8）に再構成 |\n| 2026-04-03 | **履歴集約フォーマット**へ再構成: サマリー・第1回・累積・戦略へ移行 |\n| 2026-04-03 | **BNIプロフィール統合**（株式会社BrightLink・所在地・カテゴリー等）、**第1回の日付を誤って 2026-04-15 としていた件を訂正**（実際の初回は **2026-04-03**）、**リファーラル節**追加、累積に **ボトルネック**・戦略に **初回案件の切り口** を追加。既存の話した内容は **削除せず** 第1回に保持 |\n| 2026-04-03 | **配置変更:** `docs/meetings/1to1/1to1_sato_takuto_brightlink.md` に移動。**旧パス:** `docs/meetings/2026-04-15_1to1_sato_tsugihiro.md`。任意 YAML front matter（`1to1_id` 等）を追加 |\n| 2026-04-03 | **第1回の実施時刻を確定:** JST **07:15–08:15**（ユーザー確認）。`.cursorrules` に **日付だけでなく時刻まで取得してからドキュメント反映** を追記 |','2026-05-25 20:26:20','2026-06-04 10:53:02'),
(35,1,37,137,NULL,NULL,NULL,'manual','2026-05-27 10:00:00','2026-05-27 10:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nampo_yuma_waibous.md】\n\n# 1to1_南方優馬_株式会社ワイボウズ\n\n---\n\n**文書の位置づけ:** 望月雅幸さん（DragonFly）紹介の **南方優馬さん（株式会社ワイボウズ）** との 1to1 を **1ファイルで時系列管理**する。  \n**整理:** 第1回 **2026-05-27 実施済み**。南方さん（Tifonet）とは **協業パートナーではない**。**次廣ができるのは受動的紹介のみ** — 「低コストECやWebコンサルを探している人がいたら繋ぐ」程度。**補助金系のグレーな商売には協力しない**（2026-05-27 次廣判断）。  \n**日時:** 第1回 **2026-05-27 JST 10:00〜実施済み**（終了時刻 **TODO** — Zoom／カレンダーで確認後に YAML へ反映）。\n\n---\n\n## 紹介コンテキスト\n\n| 項目 | 内容 |\n|------|------|\n| **紹介者** | 望月　雅幸（DragonFly／社労士・スタートアップ企業向け） |\n| **相手** | 南方　優馬（株式会社ワイボウズ／代表取締役） |\n| **BNI** | **Tifonet チャプター**（**東京NEリージョン** — DragonFly と同一） |\n| **接点** | 望月さんからのお繋ぎ。**リージョン内クロスチャプター** 初回 1to1 |\n| **第1回** | **2026-05-27（水）JST 10:00〜実施済み**（終了時刻 TODO） |\n\n- 望月さんは DragonFly 内で **スタートアップ・社労士** 領域。南方さん（Tifonet）の **EC・補助金・ツール卸** と、次廣（DragonFly）の **業務システム・AI導入** で **相互紹介** を合意。\n- 会社拠点は **愛知県一宮市**（121で確認）。名古屋オフィス表記（プロフィール）と併存 — 詳細は名刺等で要確認。\n- **Tifonet チャプターに士業メンバーは不在**。士業コミュニティは **杉山氏** が運営（Tifonet 内）。南方さんは **倉持氏（クラケン／看護師）** と長く協業。\n- 双方 **愛知の取引先が多い** — 地域接点あり。\n\n---\n\n## ■ 第1回サマリー（2026-05-27 実施後）\n\n### 主な成果\n\n- 次廣（DragonFly）と南方（ワイボウズ）が初回 1to1 を実施。南方の事業（EC・Clavio・補助金エコシステム）を把握。\n- 121表向きは **相互紹介の方向性** 確認。補助金グレー指摘 **後**、南方さん **不機嫌**（次廣所感）。\n- **121後の次廣判断:** **協業ではない**。受動的紹介のみ。**グレー商売には協力しない**（下記確定スタンス）。\n\n### 次廣の関与スタンス（2026-05-27 確定）\n\n> **協業ではない。** 次廣ができるのは、**「そういうコンサル（主に低コストEC・Web）を探している人がいたら繋いであげる」** 程度の **受動的紹介** のみ。  \n> **グレーな商売（補助金エコシステム・営業代理・キャッシュメリット等）には協力しない。**\n\n- 121表向きは「相互紹介合意」だったが、**パートナー化・共同提案・ベンダー連携はしない**。\n- 補助金グレー指摘後の **不機嫌**（次廣所感）もあり、**深い関係づくりの動機は薄い**。\n\n### 温度感（次廣所感）\n\n- 補助金運用の **グレーさ** を次廣が指摘 → 南方さん **あからさまに不機嫌** → 終盤硬化。\n- **判断:** 補助金・営業代理・ツール卸ベンダー連携は **一切しない**。EC需要が **明示された場合のみ** 受動的に紹介検討。\n\n### 決定・合意（121上の記録 — 次廣スタンスで再解釈）\n\n| 項目 | 121上の記録 | 次廣の関与 |\n|------|-------------|------------|\n| **相互紹介** | 方向性確認 | 次廣→南方: **受動的紹介のみ**（EC需要が明確な場合）。南方→次廣: 来れば対応、**期待しない** |\n| **開発コスト** | Clavio約50万は安価 | **情報として記録**。自社導入・ベンダー連携は **しない** |\n| **協業ポイント** | 営業代理30万/社、複製10万/件 | **次廣は不参加** |\n\n### 次アクション\n\n- **南方:** 杉山氏・ジム代行紹介 — **期待しない**（来れば対応）\n- **次廣:** **能動的なフォロー・紹介はしない**。低コストECを **明示的に探している人** がいたらのみ検討\n- **次廣:** 補助金・Clavioベンダー連携 — **見送り（確定）**\n\n### 保留・確認待ち\n\n- 士業コミュニティ・ジム代行紹介 — **次廣は期待しない**（来れば対応）\n- 第1回終了時刻（Religo DB 登録 **完了**: `one_to_ones.id=35`）\n- `one_to_ones.id` Religo 登録 **TODO**\n- 第1回 **終了時刻** **TODO**\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供の Myプロフィール (tifonet)・G.A.I.N.S.・ONE to ONE ミーティングシートベース。初回で名刺・Web で更新する。\n\n### 南方優馬さん\n\n- **名前:** 南方　優馬（なんぽう　ゆうま／Nampo Yuma）\n- **生年月日・性格:** 1994/2/7、ENTJ\n- **所属:** 株式会社ワイボウズ\n- **役職:** 代表取締役\n- **カテゴリー:** ECサイト制作（e-commerce website）\n- **BNI:** **Tifonet チャプター**（**東京NEリージョン** — DragonFly と同一）。**士業メンバーは不在**（士業コミュニティは杉山氏運営）\n- **BNI 入会日（宣誓式）:** 2026-04-21\n- **所在地（会社）:** 愛知県一宮市（121確認）。プロフィール上は名古屋市中村区名駅にも表記 — 要確認\n- **居住地:** 愛知県稲沢市（居住3年）\n- **出身地:** 愛知県一宮市\n- **メール:** info@waibous.co.jp\n- **Web:** https://waibous.co.jp/\n- **Facebook:** https://www.facebook.com/profile.php?id=61552814947430\n- **ビジネス経験年数:** 5年\n- **過去の職業:** 第一種電気工事士（外仕事）→ 室内勤務希望で **IT派遣からSE** へ（高卒）\n- **資格:** 第一種電気工事士\n- **BNI ネットワーク:** **倉持氏（クラケン／看護師）** と長く協業\n- **家族:** 配偶者なし。両親、妹2人\n- **ペット:** 今は亡きワンコ2匹\n- **趣味:** 旅行、ゴルフ、野球、読書、カフェ、中野優作さん\n- **その他関心事:** 筋トレ\n- **私の強い願望:** 誰かの役に立てた人生だったと思いながら死ぬこと、この「誰か」を増やしていく\n- **誰も知らない私:** おばあちゃんにモテます\n- **成功の鍵:** TTP・コミュニケーション回数・声掛け無料・やり切る\n\n### 株式会社ワイボウズ\n\n**Mission**\n\n> お客様の本質的な課題に対して、Webの力で理想の未来をデザインする\n\n**Vision**\n\n> 顧客・社会・仲間と共に、愛の溢れるチームを実現し、三方良しの真に有益な結果をもたらす\n\n**Value**\n\n> 変化を恐れず挑戦し、全員で前進する\n\n**WAIBOUS の意味（社名由来）**\n\n| 文字 | 意味 |\n|------|------|\n| W | ワクワク、With（共に） |\n| AI | 愛 |\n| AIBOU | 相棒 |\n| O | 輪、チーム |\n| S | 複数、みんなで |\n\n**専門分野**\n\n- ECサイト制作\n- ホームページ制作\n- SNS運用\n- AI導入補助金\n\n**他社にない強み**\n\n- **月額9,800円** でECサイトが可能\n- 大規模な制作も対応可\n- AI導入補助金を活用してビジネス拡大のお手伝い\n\n**こんな人や会社がお客様**\n\n- ネットで商品を販売したい人\n- AI（IT）導入補助金ベンダー\n\n**紹介時の切り口（本人記載）**\n\n- 「月額9,800円でECサイトを制作している人がいるけど興味ある？」\n- 「AI導入補助金のツールを格安で卸している人がいるけど興味ある？」\n\n**G.A.I.N.S. 要約**\n\n| 項目 | 内容 |\n|------|------|\n| **Goal** | 利益3億／121回数100本/月／ゴルフスコア100切り |\n| **Accomplishments** | 【サイト制作】200件以上（チロルチョコ、国土交通省、E-girls 等の大手実績あり）／【補助金】月間50件以上の申請／【BNI】バイス時に18名→37名までメンバー拡大、あと1名でダブルゴールドクラブメンバー |\n| **Interests** | 節税、ダブルゴールドクラブメンバー、BNIで新規事業を作る |\n| **Networks** | JC |\n| **Skill** | 第一種電気工事士 |\n\n**コンタクトサークル Top3**\n\n1. AI導入補助金ベンダー\n2. WEB制作会社\n3. 建設会社\n\n**ONE to ONE シート — 未記入項目（初回で聞く）**\n\n- 直近10件の顧客リスト\n- 顧客の流入経路・提供内容・平均顧客像\n- 「質の高い」リファーラル／「不適切な」リファーラルの定義\n- コンタクトサークル 1〜10 の具体名\n\n### 公式サイト確認（2026-05-27）\n\n※ [waibous.co.jp](https://waibous.co.jp/)（Studio.Design / Nuxt SPA）をブラウザ確認。プロフィールだけでは見えなかった **自社SaaS・Shopify体制** を追記。\n\n**サイト上のキャッチ（プロフィールと一致）**\n\n> お客様の相棒として、共にワクワクする未来へ\n\n**事業構成（サイト掲載）**\n\n| 区分 | 内容 |\n|------|------|\n| **メイン** | BtoBの **HP制作・EC制作** |\n| **周辺** | 補助金・助成金サポート、SNS運用、動画制作 |\n| **自社プロダクト** | **Clavio（クラヴィオ）** — 見積・請求・入金管理のクラウドSaaS（AI機能付き） |\n| **姿勢** | 「作って終わり」ではなく **末長く伴走**。仕様未確定でも無料相談可 |\n\n**EC制作（/service-ec）**\n\n- **Shopify公認パートナー**（Shopify歴5年以上のエンジニア在籍と記載）\n- 「売れるEC」をうたい、テンプレではなく **ブランディング込みオリジナル** 志向\n- 制作期間目安 **1.5〜3ヶ月**（特急可）。運用・売上UP支援まで\n- 想定課題: EC知識不足、売上が上がらない、オリジナルデザイン希望\n\n**Clavio（/clavio）— tugilo 接点で最重要**\n\n- **見積・請求・入金・売上管理** をクラウド一元化。AIで勘定科目推定・経営分析\n- 想定課題: Excel崩れ、入金漏れ、属人化、DXの入口がわからない\n- ターゲット: 見積・請求・入金を Excel/手作業で回している企業\n- **IT導入補助金:** サイト上は「**登録申請を進めており、現時点では未対応。今後対象となる可能性あり**」（プロフィールの「AI導入補助金ベンダー・月50件申請」と表現差あり — 初回確認）\n\n**選ばれる理由（サイト要約）**\n\n1. **200サイト以上** の制作実績と高い技術力\n2. Web周り（動画・写真・ライティング等）を **ワンストップ** 対応\n3. お客様の **相棒として末長く** 付き合う\n\n**制作実績（サイト掲載例）**\n\nFree Trial 探偵社、amuhibi、OMI CLINIC、株式会社PEICC、**Re：pro建材**、**フジセイ株式会社** 等 — 医療・探偵・建材・製造など業種は分散。\n\n**プロフィール vs サイト vs 第1回121 — 整理**\n\n| 項目 | プロフィール | サイト | 第1回121 |\n|------|-------------|--------|----------|\n| EC入口 | 月額9,800円 | Shopify本格EC | **月9,800円×24ヶ月**（Shopify）。月 **約5件** 安定受注 |\n| 補助金 | AI導入補助金・月50件 | Clavio IT導入補助金申請中 | **ツール卸・営業代理・申請サポート分離** が本体 |\n| 主力 | ECサイト制作 | EC + Clavio + 補助金 | **補助金（一時）+ Web制作（ストック）** の両輪 |\n| 拠点 | 名古屋・稲沢 | — | **一宮市**（121確認） |\n\n### 第1回121で確認した事業詳細（2026-05-27）\n\n#### Web制作・EC（Shopify）\n\n- **月額9,800円×24ヶ月** でECサイト制作（Shopify）。**24ヶ月チャットサポート・細かい修正** 込み（Shopify利用料は別途）\n- 背景: チロルチョコ・国交省等 **200〜300万円** 案件から、BNI向けに **低価格プラン** を開発\n- **月約5件** の安定受注。自社デザイナー + 一部外注\n\n#### IT導入補助金ツール卸（Clavio 相当）\n\n- **AI会計ツール** — 見積・請求・発注書、売上・入金管理、仕訳・帳簿、AI業務分析\n- **初期開発約50万円**、サーバー **月1万円未満**\n- **ベンダー向け複製:** UI・デザイン・商品名変更で **1件約10万円**\n- **リスク分離:** ベンダーごとに独立ツール（1社の問題が他社に波及しない）\n- **サポート:** 補助金申請は **別の申請サポート会社**。南方は **ID/PW登録等の初期設定のみ**（手離れ良い）\n\n#### 補助金販売・営業代理\n\n- **1社紹介で報酬30万円**（営業代理店）\n- 顧客メリット: **手出しゼロ**（キャッシュメリット **60万円** 等の説明あり）\n- **300社以上** 申請実績、調査でも問題なし（ホワイト運営を強調）\n- **2025年4〜5月:** 補助金事業 **売上2.5億円**。ツール卸 **2社決定・利益4,000万円見込**\n- **戦略:** 補助金は一過性 → **Web制作でストック収益** を積む両輪\n\n#### 補助金コンプライアンス（121で共有された要点）\n\n**違反リスクが高い行為**\n\n- **ツール未納品**（返還対象）\n- **代理申請**（申請は **顧客本人** が行う必要）\n- **明白なキックバック**（行って来い型の金銭還流）\n\n**適法運用のポイント**\n\n- ツール **確実納品**、「これから使う」状態を説明可能に\n- 申請サポート会社が **本人申請形式** をガイド\n- キャッシュバックではなく **別事業（ノウハウ買取・マーケットリサーチ等）** としての対価支払い\n\n※コンプライアンス詳細は **要専門確認**。本節は121要約の記録。\n\n### 次廣側（第1回で共有した内容）\n\n### 次廣側（第1回で共有した内容）\n\n- **屋号:** tugilo（ツギロ）\n- **カテゴリー:** AI業務改善システム構築\n- **拠点:** 静岡県藤枝市。オンラインで全国対応。**愛知の取引先も多い**\n- **経歴:** エンジニア歴 **26年**、提案歴3年。フランス語学科卒→DTM経由でSE。30歳独立\n- **DragonFly:** **2025年3月** 入会（立ち上げメンバーからの誘い）。**2025年4月** 推奨トレーニング13個を1ヶ月で完了\n- **強み:** 現場フロー尊重・小さく始めて拡張・属人化排除・非エンジニア向け言語化\n- **AI:** 自身業務 **約90%削減**（「大袈裟に言うと0割」と表現）。ROIベース見積へ移行\n- **121当日:** **53歳**（誕生日）。妻・娘2人・猫4匹。趣味: アウトドア、AI研究\n- **類似開発:** 見積・請求システム **約200万円**（会計処理は未実装）— 南方ツール50万円と比較\n- **公開サイト:** https://tugilo.com\n- **121用詳細:** [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §8\n\n#### 次廣の主要実績（第1回共有）\n\n**第一ブロック本部・FC管理（増本さん関連）**\n\n- 全国200社→500社目標。Googleフォーム・Spreadsheet・Excel分散 → **Laravel(PHP)+MySQL+React** で統合\n- 初期見積120万→最終 **約200万円**（相場560〜800万より低価格）。**伴走型保守**\n\n**名古屋・防水工事・LINE日報**\n\n- 外国人職人多数、紙日報 → **LINE Messaging API** で日報。現場別コスト・請求根拠を可視化\n\n**静岡観光協会（5年継続）**\n\n- 5市2町周遊イベント。LINEスタンプラリー・抽選のB2C\n\n**解体業・LINE見積〜請求**\n\n- LINEから見積依頼→現調→見積・請求までLINE完結\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係の位置づけ:** **協業パートナーではない**。BNI 121 で知り合った **紹介先候補の一人** — 次廣ができるのは **受動的紹介のみ**。\n- **次廣の線引き:** **グレーな商売（補助金エコシステム）には協力しない**。低コストEC（9,800×24）を **明示的に探している人** がいたら繋ぐ程度。\n- **121の温度:** 補助金グレー指摘後 **不機嫌**（次廣所感）。能動的な関係構築は **しない**。\n- **南方→次廣:** 杉山氏・ジム代行紹介は **期待しない**（来れば対応）。\n- **記録:** Religo `one_to_ones.id` = **35**。\n\n---\n\n## ■ 初回セッション設計（2026-05-27）\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 望月さんへのお礼、今日の進め方（前半南方さん・後半次廣）の合意 |\n| 5〜8分 | **雑談** | 趣味・121 100本/月との両立（**1.5 雑談パート**） |\n| 8〜28分 | **南方さん** | EC・Clavio・補助金・SNSの芯、9,800円 vs Shopify本格の位置づけ |\n| 25〜45分 | **次廣** | AI業務改善・「ECのその先」・Clavio との棲み分け（[Living Document §8](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md)） |\n| 45〜55分 | **接点探索** | 協業パターン5種（下記）から **1つ具体化**、望月さん経由スタートアップ導線 |\n| 55〜60分 | クローズ | 次アクション1〜2件、名刺・LINE、メンバー表、必要なら第2回 |\n\n### 初回で聞くこと（チェックリスト）\n\n- [ ] **望月さんに紹介された経緯・期待**（所属チャプター **Tifonet / 東京NE** は確認済み）\n- [ ] **主力商品の優先順位** … 月9,800円EC / Shopify本格EC / **Clavio** / 補助金 / SNS のどれが本命か\n- [ ] **月額9,800円EC** … 対象顧客・機能・サポート・アップセル導線（BNI紹介用 vs 本業）\n- [ ] **Shopify本格EC** … 単価帯・納期・得意業種。200件超実績の再現条件\n- [ ] **Clavio** … 開発主体・ターゲット・tugilo カスタム開発との **境界線**（見積・請求だけ vs 現場・受発注全体）\n- [ ] **AI/IT導入補助金** … 月50件申請の内訳。申請代行 vs ベンダー vs ツール卸。Clavio 補助金 **申請中（サイト）** との整合\n- [ ] **SNS運用** … EC/Clavio とセットか単体か\n- [ ] **EC/H P後のボトルネック** … 顧客からよく聞く「その先の困りごと」（= tugilo 紹介トリガー）\n- [ ] **「質の高い」リファーラル**／**不適切なリファーラル**（シート未記入分）\n- [ ] **建設会社 Top3** … Re：pro建材等の実績と建設向け提案の中身\n\n### 協業可否を決める3問（必須）\n\n1. **9,800円EC / Shopify本格EC / Clavio** — どれが主力商品か？\n2. 補助金は **申請代行** か **自社ツール（Clavio等）のベンダー** か？\n3. EC/H P後に **「ここが困った」** とよく聞く課題は何か？\n\n### 次廣が伝える要点（短く）\n\n- **カテゴリ:** AI業務改善システム構築（tugilo）\n- **入口:** Excel・紙・LINE・二重入力の限界 → 小さくシステム化（[BNI_Tugilo_Usage_Strategy.md](../../strategy/networking/BNI_Tugilo_Usage_Strategy.md) Track C）\n- **ECとの接点:** 「ECは立ったが、受注・在庫・問い合わせ・請求が手作業」の **その先** を整える\n- **Clavio との棲み分け:** 見積・請求・入金だけ → Clavio。現場・受発注・日報・FC管理含む → tugilo。**既存 Clavio + 現場連携** は共同提案候補\n- **補助金:** 南方＝申請・ベンダー選定、tugilo＝要件整理・PoC・伴走開発の **連携** 可否を確認\n- **紹介依頼:** 売上は伸びているが現場の仕組みが追いついていない経営者（10〜30人規模）\n- **DragonFly:** 3/17 加入・4月末グラデュエート（必要なら一言）\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n**進行イメージ:** お互い「事業紹介 → 質疑応答」がだいたい各30分。\n\n### 1. オープニング（信頼の橋）\n\n> 「南方さん、本日はお時間ありがとうございます。DragonFly の次廣です。  \n> 望月さんからお繋ぎいただき、ありがとうございます。  \n> 今日は、南方さんのECや補助金の仕事を、単なる『サイト制作』ではなく、どんなお客様のどんな課題を解いているのかまで理解したいと思っています。  \n> 後半で僕の業務システム・AI活用支援の仕事もお話ししますので、南方さんから見て『こういう人なら合いそう』という視点で聞いていただけるとうれしいです。  \n> 前半は南方さん、後半は僕、という流れで進めてもよいですか？」\n\n### 1.5 雑談（信頼づくり・3〜5分）\n\n**置き場所:** オープニング直後、または南方さんの事業紹介の **前**。**1〜2問で十分** — 深掘りしすぎない。\n\n**入り（メイン）**\n\n> 「プロフィール拝見して、ゴルフ・野球・読書・旅行・カフェと趣味がすごく豊富だなと思いました。  \n> それで **121 100本/月** みたいな目標もお持ちですよね。**忙しい中で趣味の時間って、どう確保されていますか？** 僕も参考にしたくて。」\n\n**深掘り（必要なぶんだけ・1問ずつ）**\n\n- 「読書は **いつ読む** ことが多いですか？ 移動中、寝る前、カフェ？」\n- 「**中野優作** さん好きとのことですが、最近ハマってる作品とかありますか？」\n- 「ゴルフ100切りも目標に入っていました。**練習の時間** はどう確保してますか？」\n- 「121 100本/月 みたいな目標があると、趣味は **削られやすい** ですか？ それとも **燃料** になってますか？」\n- 「成功の鍵に **TTP・声掛け無料・やり切る** とありましたが、趣味も **やり切るタイプ** ですか？ それとも **意識的に切っていること** がありますか？」\n- 「Web/EC/Clavio/補助金、BNI、趣味—— **全部やるコツ** って、南方さんなりにありますか？」\n\n**次廣との接点（軽く1文）**\n\n> 「僕も1人で全部やると趣味まで削られがちなので、**時間を生み出す仕組み** を仕事にしているんですが、南方さんは **仕事以外** で時間を作る工夫とかありますか？」\n\n**雑談から事業へ戻す**\n\n> 「すみません、脱線しました。では南方さんのお仕事の話、伺ってもよいですか？」\n\n### 2. 前半：南方さんの事業紹介〜質疑応答\n\n**まず聞く姿勢で入る。EC・Clavio・補助金の三つ柱を理解する。**\n\n> 「サイトも拝見して、Shopify 本格ECに加えて **Clavio** という見積・請求の SaaS もお持ちなんですね。  \n> プロフィールの月額9,800円ECと、AI導入補助金の月50件申請も印象的でした。  \n> いま南方さんが一番伸ばしたいのは、EC制作・Clavio・補助金のどれに近いですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n- 「9,800円プランと Shopify 本格ECは、どう使い分けていますか？BNI 紹介用の入口と本業の違いはありますか？」\n- 「**Clavio** は、南方さんにとって主力商品ですか？それとも EC 顧客への追加提案ですか？」\n- 「Clavio で足りる案件と、カスタム開発が必要な案件の **境目** はどこだと思いますか？」\n- 「200件以上の制作実績のうち、『うちの強みが出た』案件はどんなタイプですか？」\n- 「AI/IT導入補助金は、申請代行・ベンダー・ツール卸のどこに立っていますか？Clavio の補助金対応はいつ頃を想定していますか？」\n- 「EC や HP のあと、お客様から **『ここが困った』** とよく聞く課題は何ですか？」\n- 「コンタクトサークル Top3 の建設会社 — Re：pro建材 など、建設向けにどんな提案をされていますか？」\n- 「紹介されても困る案件、事前に確認してほしい条件はありますか？」\n- 「僕が第三者に南方さんを紹介するとしたら、どんな一言が一番ずれが少ないですか？」\n\n**紹介文を作るための確認**\n\n> 「たとえば『月額9,800円からECを立てられ、Shopify 本格案件や Clavio、補助金支援もできる、200件超の実績を持つ名古屋の Web パートナー』という紹介の仕方は、南方さんの感覚に合っていますか？」\n\n### 3. 後半：こちらの事業紹介〜質疑応答\n\n**こちらの説明軸:** tugilo は、業務システム・Web/AI活用・業務改善を、現場に合わせて小さく実装する開発パートナー。\n\n> 「僕は、ExcelやLINE、紙、手作業で回っている業務を整理して、必要なところだけシステム化する仕事をしています。  \n> ECやWebで集客・販売の入口ができても、その先の受注管理・在庫・問い合わせ・請求が手作業のまま、という会社さんとよくお話しします。」\n\n**南方さん向けに刺さりそうな接点**\n\n- EC/H P 後の **受注・在庫・問い合わせ・請求・顧客管理**（Clavio の外側・現場側）。\n- **Clavio + 現場連携** が必要な案件の共同提案。\n- 補助金 × **Track C（診断→PoC→伴走）** の役割分担。\n- 望月さん経由 **スタートアップ導線**（創業→Web/EC→業務基盤）。\n- 建設・建材（Re：pro建材 等）向け **現場日報・見積〜請求** 事例の共有。\n\n**相手に聞いてもらう質問**\n\n> 「南方さんから見て、僕の仕事はどんな人に紹介しやすそうですか？  \n> 逆に、EC・Clavio・補助金のあとに **『ここがボトルネック』** とよく聞く課題はありますか？  \n> Clavio で足りる案件と、僕に回した方がいい案件の **線引き** を一緒に決められますか？」\n\n### 4. クロージング\n\n- 「今日の話を受けて、紹介条件と Clavio / tugilo の **棲み分け** を整理します。」\n- 「望月さんへのお礼も含め、紹介の意図が合っていれば、第2回やメンバー表交換も検討させてください。」\n- 「南方さんを紹介するときの一言は、今日確認した表現で進めてもよいですか？」\n\n---\n\n## ■ 次廣の関与スタンス（協業ではない）\n\n**確定判断（2026-05-27 次廣）:**\n\n> 協業というより、**そういうコンサル（低コストEC・Web）を探している人がいたら繋いであげる** ぐらい。  \n> **グレーな商売にはあまり協力したくない。**\n\n### やること / やらないこと\n\n| | 内容 |\n|---|---|\n| **やる（受動的）** | 低コストEC（9,800×24）を **明示的に探している人** がいたら南方へ紹介 **検討** |\n| **やらない** | 補助金営業代理・ツール卸・ベンダー連携・共同提案 |\n| **やらない** | 能動的なフォロー・第2回121・パワーチーム化 |\n| **やらない** | 士業顧客への補助金セット紹介、業務改善とECの **セット紹介**（南方の補助金と切り離せないため） |\n| **記録のみ** | Clavio約50万のコスト比較 — **自社利用・連携はしない** |\n\n### 121で分かった南方の事業（参考記録）\n\n| 南方 / ワイボウズ | 次廣の関与 |\n|---|---|\n| 月9,800円×24 EC | **受動的紹介のみ**（需要明示時） |\n| AI会計ツール（Clavio） | **関与しない**（コスト情報は記録済） |\n| 補助金営業代理 | **協力しない** |\n| ツール複製・ベンダー | **協力しない** |\n\n### パワーチーム / 紹介パートナー評価\n\n| 項目 | 評価 |\n|---|---|\n| 紹介先として | △（EC需要が **明示** された場合のみ） |\n| 協業・パワーチーム | **×** |\n| グレー商売との距離 | **必須** — 補助金系は **一切協力しない** |\n| 関係温度 | **△**（不機嫌の印象） |\n\n**位置づけ:** **BNI 知り合い・受動的紹介先**。能動的な関係構築は **しない**。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-27 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-05-27（水）JST 10:00–TODO**（Zoom 文字起こし要約を 2026-05-27 10:50 JST に反映。終了時刻はカレンダー／Zoom で要確認）\n- **実施方法:** **Zoom**\n- **参加者:** 次廣 淳、南方 優馬\n- **紹介者:** 望月 雅幸（BNI DragonFly）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **35**（`members.id` = **137**、`workspaces.slug` = `bni_tifonet`）\n\n#### 主な成果\n\n- AI業務改善システム開発（tugilo）と IT導入補助金ツール・Web制作（ワイボウズ）の **協業可能性** を確認。\n- 次廣は **月9,800円×24ヶ月EC** と **AI会計ツール（開発約50万円）** に関心。\n- **相互紹介の方向性** で合意 — 次廣: 業務改善経営者・士業・銀行経由。南方: 杉山氏士業コミュニティ・ジム代行業者。\n\n#### 話した内容（重要）\n\n##### 次廣側\n\n- エンジニア歴26年。文系→DTM→SE→30歳独立。2025年3月 DragonFly 入会。AIで自身業務大幅削減。\n- 強み: 現場フロー尊重、小さく始めて拡張、属人化排除、非エンジニア向け言語化。\n- 事例: FC本部統合（Laravel+React、約200万）、名古屋防水LINE日報、静岡観光LINE（5年）、解体業LINE見積請求。\n- 見積請求カスタム **約200万円**（会計未実装）— 南方ツール50万円と比較し **非常に安価** と評価。\n- 見積は工数ベースから **ROIベース** へ移行。DragonFly参加2ヶ月で **汎用サービス化** の必要性も認識。\n\n##### 南方側\n\n- 電気工事士→IT派遣SE→Web/EC/補助金。拠点 **一宮市**。\n- **月9,800円×24ヶ月EC**（Shopify）、月約5件。200〜300万案件からBNI向け低価格化。\n- **AI会計ツール**（Clavio）— 開発約50万、サーバー月1万未満、ベンダー複製約10万/件。\n- **補助金営業代理** 30万/社、2025/4-5月売上2.5億、ツール卸2社・利益4,000万見込。\n- Tifonet は **士業メンバー不在**。杉山氏が士業コミュニティ運営。倉持氏（クラケン）と長期協業。\n\n##### 補助金・コンプライアンス（温度感の転換点）\n\n- 南方側は補助金の適法運用（納品必須・本人申請・キックバック回避等）を説明。\n- 次廣は **運用のグレーさ**（キャッシュメリット60万、ノウハウ買取・マーケットリサーチ経由の資金注入等）について **懸念・指摘**。\n- **その後（次廣所感）:** 南方さん **あからさまに不機嫌** の印象。以降の雰囲気は硬化。文字起こし要約には出ていない。\n\n##### 技術・開発\n\n- 南方ツール50万 vs 次廣同等見積200万 — コスト差を確認。\n- 次廣からWebデザイナー紹介は **不要**（南方はDragonFly内で接続済み）。\n\n##### 雑談・個人\n\n- 次廣: 121当日53歳、妻・娘2・猫4、趣味アウトドア・AI研究。\n- 双方 **愛知の取引先** が多い。\n\n#### 決定・合意\n\n- **相互紹介** の方向性確認（表向き）。\n- 南方ツール **50万円の妥当性** — 次廣が市場比較で確認。\n- **協業ポイント（文字上）:** 営業代理30万/社、ツール複製10万/件。\n\n※ **温度感（次廣所感）:** 補助金グレー指摘 **後** **不機嫌** → 終盤硬化。**協業ではなく受動的紹介のみ** と次廣判断（後述）。\n\n#### アクションアイテム（121上）\n\n- **南方:** 杉山氏・ジム代行紹介 — 次廣は **期待しない**\n- **次廣:** **能動的フォローなし**。EC需要 **明示時のみ** 受動的紹介検討\n\n#### 次廣の関与スタンス（121後・確定）\n\n- **協業パートナーにしない**\n- **グレーな商売（補助金系）には協力しない**\n- **できること:** 低コストECコンサルを探している人がいたら **繋ぐ程度**\n\n#### 確認待ち\n\n- 士業コミュニティ・ジム代行紹介 — **期待しない**\n- 第1回終了時刻（Religo DB 登録 **完了**: `one_to_ones.id=35`）\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 南方の本丸は **EC入口（9,800×24）** ではなく **補助金エコシステム（ツール卸・営業代理・申請分離）** + **Webストック**。121前仮説より **補助金比重が大きい**。\n- **次廣のスタンス（確定）:** **協業しない**。**受動的紹介のみ** — ECを探している人がいたら繋ぐ程度。**グレー商売には協力しない**。\n- **補助金が本丸** — 南方の収益の芯。ここに次廣は **関与しない**。\n- **Clavio 50万** — コスト比較の記録価値のみ。**導入・連携なし**。\n- **121の温度** — グレー指摘後 **不機嫌**。深い信頼関係は **築かない**。\n- **望月さんへ:** お礼 + **深い協業はしない** 旨を伝えてよい。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **協業パートナーにしない** — BNI 121 の **知り合い・受動的紹介先** としてファイルを維持。\n- **紹介条件:** **低コストEC（9,800×24）を明示的に探している人** のみ。南方から依頼されても **補助金絡みの紹介は断る**。\n- **グレー商売:** 補助金エコシステム・営業代理・キャッシュメリット — **一切協力しない**（次廣の価値観）。\n- **フォロー:** **当たり障りのないお礼 + EC（9,800×24）のみ前向き** で十分（文案は下記）。能動的に第2回121は **しない**。\n- **望月さんへ:** 「121はした。深い協業はしない。グレーな部分には関わらない」と共有してよい。\n- **倉持氏:** 南方↔倉持の関係は **参考情報**。次廣が能動的に繋ぐ **必要なし**。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣 → 南方（受動的・条件付き）\n\n**紹介してよい条件（すべて満たす場合のみ）**\n\n- 相手が **低コストEC・Shopify EC** を **自ら探している**\n- **補助金・営業代理** の話題が **混ざらない**\n- 次廣が **名前を出して繋いでよい** と明示的に依頼された\n\n**紹介文（必要時のみ）**\n\n> 南方さんは、月9,800円×24ヶ月でShopify ECを立てられる愛知のWebパートナーです。\n\n### 次廣 → 南方 **紹介しない（確定）**\n\n- 補助金・IT導入補助金・営業代理（30万/社）関連\n- 士業顧客への **セット紹介**（補助金と切り離せないため）\n- 業務改善ニーズを **南方経由の補助金** とセットにする紹介\n- Clavio・ツールベンダー連携の紹介\n\n### 南方 → 次廣\n\n- **期待しない**。杉山氏・ジム代行紹介が来れば対応。**能動的に求めない**。\n\n---\n\n## ■ フォロー文案（121後）\n\n**方針:** 当たり障りのないお礼 + **月9,800円×24ヶ月EC** だけ前向き。**補助金・Clavio・協業・第2回121は出さない**。\n\n### 南方さん宛（LINE / メール）\n\n> 南方さん、本日はお時間いただきありがとうごうざいました。  \n> 事業の全体像、特に月9,800円×24ヶ月のECプランについて理解できました。  \n> ネット販売を始めたいけど初期コストで止まっている方には、かなり刺さるプランだと思います。  \n> そういう方がDragonFly内や周辺にいましたら、お繋ぎしますね。  \n> 本日はありがとうございました。\n\n**短縮版**\n\n> 南方さん、本日ありがとうございました。月9,800円のECプラン、ニーズある方には刺さりそうなので、該当する方がいればお繋ぎしますね。\n\n### 望月さん宛（紹介者への報告）\n\n> 望月さん、南方さんとの121、本日実施しました。ご紹介ありがとうございました。  \n> ECまわり（月9,800円×24ヶ月プラン）は、中小向けの入口として分かりやすく、紹介しやすいと感じました。該当する方がいればお繋ぎします。  \n> その他の領域については、自分の得意分野と合う部分を切り分けて考えています。改めてありがとうございました。\n\n**避ける表現:** 補助金のグレーさ、不機嫌、協業見送り、ベンダー連携、Clavio導入 — **口に出さない**（望月さん向けも同様。必要なら口頭で軽く）。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **32歳・ENTJ・一宮出身** — 電気工事士→SE→Web/補助金。**行動量・数字** が強い（補助金2.5億/2ヶ月等）。\n- **次廣のスタンス:** **協業しない**。「そういうコンサルを探している人がいたら繋ぐ」**だけ**。**グレー商売には協力したくない**。\n- **温度感:** グレー指摘後 **不機嫌** — 能動的な関係づくり **不要**。\n- **望月さんへ:** 121お礼 + **深い協業はしない** 旨で十分。\n\n---\n\n**更新:** 2026-05-27 17:01 JST — Religo DB 登録（`one_to_ones.id=35`、`members.id=137`、`workspaces.slug=bni_tifonet`）。\n**更新:** 2026-05-27 10:55 JST — **フォロー文案** を追加（お礼 + 9,800円EC紹介のみ）。\n**更新:** 2026-05-27 10:53 JST — **次廣スタンス確定:** 協業ではなく **受動的紹介のみ**。グレー商売（補助金系）には **協力しない**。\n**更新:** 2026-05-27 10:52 JST — 第1回 **温度感** を追記（補助金グレー指摘後の不機嫌）。\n**更新:** 2026-05-27 10:50 JST — 第1回 **Zoom 文字起こし要約** を清書し議事録反映（実施済み）。\n**更新:** 2026-05-27 09:55 JST — 121台本に **1.5 雑談パート** を追加。\n**更新:** 2026-05-27 09:46 JST — 所属 **BNI Tifonet（東京NE）** を反映。','2026-05-27 17:00:47','2026-06-04 10:53:02'),
(36,1,37,138,NULL,'83459427012','i3heZ15HSG6RW1qeTCoPBg==','manual','2026-05-28 15:00:00','2026-05-28 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_jimbo_ryota_snep.md】\n\n# 1to1_神保玲太_SNEP株式会社\n\n---\n\n**文書の位置づけ:** BNI **Diana** チャプターの神保玲太さんとの 1to1 を **1ファイルで時系列管理**する。  \n**紹介:** 同チャプター **鈴木健介** さん（[`1to1_suzuki_kensuke_studio_suzu.md`](1to1_suzuki_kensuke_studio_suzu.md) 第1回済）からのお繋ぎ。  \n**整理:** 神保さんは **世界初の10分ネイル**・**B to B 出張ネイル**（福祉・医療・企業福利厚生）・**フランチャイズ展開** が三本柱。第1回では、神保さんから次廣の **BNI向け予約管理システム** に対して、脱ホットペッパー、MEO等の集客支援、リマインド・周期フォロー機能、基本料金＋オプション制について具体的なフィードバックを得た。  \n**日時:** 第1回は **2026-05-28 実施済み**（開始・終了時刻は TODO。Zoom／カレンダー等で確認後に YAML と【第1回】へ反映）。\n\n---\n\n## 紹介コンテキスト\n\n| 項目 | 内容 |\n|------|------|\n| **紹介者** | 鈴木　健介（合同会社スタジオ鈴／BNI **Diana**） |\n| **相手** | 神保　玲太（SNEP株式会社／代表） |\n| **BNI** | **Diana チャプター**。役職: **エデュケーション、トレーニング** |\n| **接点** | 鈴木さん紹介の **クロスチャプター** 初回 1to1（次廣＝DragonFly） |\n| **切り口（本人）** | 「**10分ネイルって知ってる？**」と聞いて興味を持ってもらえたらお繋ぎください |\n| **第1回** | **2026-05-28 実施済み**（開始・終了時刻 TODO） |\n\n- 鈴木さんとは **2026-04-17** 第1回 1to1 済（撮影・VR×サウナ等）。Diana 内の信頼関係からの紹介。\n- 神保さんは Diana で **17期書記兼会計、18期プレジデント、22期書記兼会計、24期バイスプレジデント** の **3役グランドスラム**。チャプター運営・メンターとしての評価がプロフィール上も高い。\n- 推薦文に「**麻布と言ったら神保、ネイルと言ったら神保**」のフレーズあり（小松陽平氏・2023/10/03）。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供の Myプロフィール (diana)・G.A.I.N.S.・ONE to ONE ミーティングシートベース。\n\n### 神保玲太さん\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 神保　玲太（じんぼ　りょうた／Jimbo Ryota） |\n| **生年月日** | 1983/8/2（亥年・黒豹） |\n| **所属** | SNEP株式会社 |\n| **役職** | 代表 |\n| **カテゴリー** | 10分ネイル（10min Nail） |\n| **BNI** | **Diana チャプター**／エデュケーション、トレーニング |\n| **入会日** | 2021/10/07 |\n| **所在地** | 東京都港区麻布十番３−１２−１−３０２ |\n| **電話** | 03-5445-5065 |\n| **メール** | ryotadesu.jp@gmail.com |\n| **Web** | https://snep.tokyo |\n| **経験** | ネイリスト兼サロン歴 **16年目**（母の MJ.NAIL から30年の家系） |\n| **居住地** | 港区芝浦エリア（居住14年）。出身: 千葉県船橋市 |\n| **家族** | 妻（郁美・1982/6/16・エステ関係）、母（元 MJ.NAIL オーナー）、父（USネイビー） |\n| **趣味** | BBQ、Hiphop/R&B、読書（自己啓発・哲学）、お風呂・サウナ、飲食、最近ゴルフをかじり始めた |\n| **強い願望** | 自分の人生を生きる／地球を満喫／人の笑顔を作りまくる |\n| **成功の鍵** | コツコツが勝つコツ／**基本断らない** |\n\n**資格・肩書（抜粋）**\n\n- 2012年 **全日本ネイリスト選手権** 受賞\n- 日本ネイリスト協会 1級・上級、**SHINYGELインストラクター**\n- 初任者研修、介護美容研究所・ブレア学園サポート講師\n- 一般社団法人印象管理士協会 **ネイルドクター**\n- **MLMオタク歴7年**（80社前後見て回った）\n\n**過去の職業（多様）**\n\nサイゼリア、イトーヨカドー魚屋、解体屋、引越し屋、子供専門英会話営業（所属6名で2大会連続全国1位）、車フロントガラスリペア、クラブDJ（横浜・横須賀・六本木／HIPHOP,R&B） 等\n\n### SNEP株式会社 / 10分ネイル\n\n**専門分野**\n\n- 10分ネイル、医療福祉ネイルケア、美容・爪\n- ネイルサービスを活用したコンサル、コストダウン提案\n\n**他社にない強み**\n\n- **10分**で仕上がるネイル（身だしなみ）— 世界初の10分ネイル導入店舗数 **美容室1000店舗**（FC含む）を目標\n- 全国大会レベルの **極艶（爪磨き）** — 8時間講習で1日習得\n- **[出張ネイル] B to B** … 人的資本を大事にする施設の課題を一括提案\n  - 求人が来やすい／退職率軽減／ほぼノーリスクで売上アップ／社員モチベーションUP\n  - 角質化・巻き爪など家族・看護師が切れない爪の対処\n  - ネイル可能な看護師資格者の準備、**パワーチーム**による固定費削減（家賃・光熱費・通信費・手出し無し）\n- **[ネイル講師]** 全日本選手権受賞者直伝、試験管が教えられる体制\n- BNI経由で **海外から日本ネイル技術** を取り入れたい依頼あり\n\n**こんな人・会社がお客様**\n\n- ネイリスト（福祉ネイリスト）、介護美容研究所卒業生\n- 従業員5名以上の美容室オーナー\n- **健康経営**を掲げる企業、医療従事者、福利厚生に力を入れる企業\n- 離職率を下げたい企業、ウエディングプランナー\n- サロンフランチャイズを展開したい方\n\n**直近10件の顧客（シート記載）**\n\n1. いいねデイサービス  \n2. なのはなデイサービス  \n3. なのはなリハビリセンター  \n4. one or eight株式会社（障害福祉）  \n5. 茨城県デイサービス・有料老人ホーム  \n6. TDK株式会社  \n7. プロ麻雀士イベント  \n8. 三軒茶屋・アパレル30代（ジェルネイル）  \n9. 江東区・OL60代（ジェルネイル）  \n10. 麻布十番・主婦60代（ジェルネイル）  \n\n→ 流入は **紹介中心**。サロン施術・出張爪ケア・10分ネイルで業績アップ。\n\n**G.A.I.N.S. 要約**\n\n| 項目 | 内容 |\n|------|------|\n| **Goal** | 新規事業提携・事業体構築／**BNI紹介で年間3000万売上**／ネイル: 美容室1000店・福祉医療中小企業（30名以上）へネイリスト出張・提携先500施設／**Smile Nail Earth Project** |\n| **Accomplishments** | Diana 3役グランドスラム、船橋選抜サッカー、英会話営業全国1位×2、DJ、全日本ネイリスト選手権、メディア・芸能人・企業協賛、**福祉施設の赤字→黒字** 複数 |\n| **Interests** | 楽しい事、ワクワク、世界遺産、神社仏閣、音楽、飲食、BBQ、スノボ、ネットワークビジネス |\n| **Networks** | ネイル、福祉、エステ・IT・飲食・保険・カメラ・建築・ホワイトニング・ツーリズム・デザイナー・DJ 等 |\n| **Skill** | 笑顔と愛嬌 |\n\n**リファーラル**\n\n| 区分 | 内容 |\n|------|------|\n| **質の高い** | 健康経営を口にする方・企業、ネイルしたい方、福祉施設を複数運営する会社、ケアマネ繋ぎ、病院関係者 |\n| **不適切** | 特になし（シート記載） |\n| **その他提供者** | 病院関係に強い事業者、Web関係の方 |\n\n**コンタクトサークル Top3**\n\n1. 美容に特化した WEB・SNS  \n2. 健康経営を発信している方  \n3. （3位はシート空欄 — 初回確認）\n\n**コンタクトサークル 1〜10**\n\n美容、福祉、医療、税理士、行政書士、医療系に強い保険、福祉系に強い保険、ウエディングプランナー、オーダースーツ、（10空欄）\n\n### 次廣側（共有する固定情報）\n\n- **屋号:** tugilo（ツギロ）\n- **カテゴリー:** AI業務改善システム構築\n- **拠点:** 静岡県藤枝市。オンラインで全国対応\n- **強み:** Excel・紙・LINE・属人化を、現場に合わせて小さく仕組み化。10〜30人規模で効果が出やすい\n- **接点候補:** 多拠点の予約・シフト・出張管理、フランチャイズ本部の見える化、福祉施設の記録・連絡、健康経営×現場オペレーション\n- **公開サイト:** https://tugilo.com\n- **121用詳細:** [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §8\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係の位置づけ:** 鈴木さん紹介の **Diana × DragonFly** 初回 1to1 を **2026-05-28 に実施済み**。\n- **主な成果:** 神保さんから、次廣の **BNI向け予約管理システム** に対して、美容業界の実務目線で具体的なフィードバックを得た。特に、ホットペッパー脱却支援は「予約システム」単体ではなく、**MEO・ポスティング等の集客支援とセット**で提案する必要がある。\n- **方向性:** 月額 **1万円以下**、基本 **4,980円** から始められ、必要な機能をオプションで追加できる予約管理パッケージを検討。ロイヤリティではなく、商材・オプション販売で広げるモデルが合いそう。\n- **10分ネイル理解:** 神保さんは、ネイルを「おしゃれ」ではなく **身だしなみ** として広げ、コンビニコーヒーのように生活習慣へ浸透させる戦略を描いている。\n- **次アクション:** 次廣は野口さんとの接続を急ぎ、予約システムのプロトタイプ完成後は神保さんへ優先共有する。神保さんへ Instagram アカウント情報・コネクト申請も行う。\n- **Religo 1to1 レコード:** `one_to_ones.id = 36`（**1セッション＝DB 1行**。正式時刻は TODO のため `scheduled_at` / `started_at` = null）\n- **保留:** 開始・終了時刻、実施方法は TODO。\n\n---\n\n## ■ 初回セッション設計\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 鈴木さんへのお礼、今日の進め方の合意 |\n| 5〜8分 | **雑談** | BBQ・サウナ・ゴルフ・音楽・「麻布と言ったら神保」 |\n| 8〜28分 | **神保さん** | 10分ネイル／出張B to B／500施設・1000店舗目標の優先順位 |\n| 28〜48分 | **次廣** | AI業務改善・多拠点の仕組み化（Living Document §8） |\n| 48〜55分 | **接点探索** | 紹介の線・1つ具体化 |\n| 55〜60分 | クローズ | 次アクション、名刺・LINE、メンバー表 |\n\n### 初回で聞くこと（チェックリスト）\n\n- [ ] **鈴木さんに紹介された経緯・期待**\n- [ ] いま一番伸ばしているのは **サロンFC / 出張B to B / 講師 / Smile Nail Earth** のどれか\n- [ ] **年間3000万（BNI紹介）** の内訳イメージ（単価・件数・業種）\n- [ ] **500施設・1000店舗** までのボトルネック（人材？予約？教育？本部の見える化？）\n- [ ] 福祉施設で **赤字→黒字** にしたとき、ネイル以外に何をしたか（神保さんの介入範囲）\n- [ ] **パワーチーム固定費削減** の中身（次廣が紹介できる領域との境界）\n- [ ] **質の高いリファーラル** の具体例（直近でうまくいった紹介1件）\n- [ ] Web/SNS Top3 — いま足りない支援は制作か運用か\n- [ ] 僕が第三者に紹介するときの **一言**（「10分ネイル」だけでよいか）\n\n### 協業・紹介を決める3問（必須）\n\n1. **1000美容室** と **500施設出張**、どちらが今期の最優先か？  \n2. 多拠点展開で **いちばん痛い業務** は予約・シフト・教育記録・請求のどれか？  \n3. 次廣から紹介してほしいのは **健康経営企業／美容室オーナー／福祉施設運営者** のどれが第一か？\n\n### 次廣が伝える要点（短く）\n\n- **カテゴリ:** AI業務改善システム構築（入口は業務整理）\n- **刺さりそうな接点:** 出張ネイリストの **スケジュール・施設別実績**、FC本部の **店舗横断データ**、福祉の **記録・連絡の属人化**\n- **押し売りしない:** 初回は神保さんの **スケール戦略の理解** を最優先\n- **紹介依頼:** 売上は伸びているが、多拠点の **予約・日報・連絡がExcel/LINEのまま** の経営者（10〜30人〜）\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n**進行イメージ:** お互い「事業紹介 → 質疑応答」がだいたい各30分。\n\n### 1. オープニング（信頼の橋）\n\n> 「神保さん、本日はお時間ありがとうございます。DragonFly の次廣です。  \n> **鈴木健介さん**からお繋ぎいただき、ありがとうございます。鈴木さんとは4月に1to1をさせていただき、Diana の皆さんのつながりの強さを改めて感じています。  \n> 今日は、神保さんのお仕事を『ネイルサロン』という枠だけでなく、**10分ネイルのB to B** や **福祉・企業向け出張**、**フランチャイズ** まで含めて理解したいと思っています。  \n> 後半で僕の業務システム・AI活用支援の話もしますので、神保さんから見て『こういう人なら合いそう』という視点で聞いていただけるとうれしいです。  \n> 前半は神保さん、後半は僕、という流れで進めてもよいですか？」\n\n**（任意）鈴木さん・Diana への一言**\n\n> 「プロフィールの推薦文で、**『麻布と言ったら神保、ネイルと言ったら神保』** というフレーズを拝見しました。チャプターでのご活躍（プレジデントや教育コーディネーター）も印象的で、楽しみにしていました。」\n\n### 1.5 雑談（信頼づくり・3〜5分）\n\n**置き場所:** オープニング直後。**1〜2問で十分**。\n\n**入り（メイン）**\n\n> 「シートを拝見して、BBQと音楽（Hiphop・R&B）とサウナ、最近はゴルフも始められたんですね。  \n> **基本断らない** と成功の鍵に書いてあって、僕も『まず聞く』タイプなので親近感がありました。  \n> 忙しい中で、**趣味の時間** はどう確保されていますか？」\n\n**深掘り（必要なぶんだけ・1問ずつ）**\n\n- 「お母様の **MJ.NAIL** から30年、ご自身も16年目とのこと。**家業を広げる** 感覚と、今の **SNEP** の関係を、一言でいうとどういうイメージですか？」\n- 「**Smile Nail Earth Project** — 地球上に貢献、という言葉が Goal にありました。**いちばん心が動く瞬間** は、サロン施術のときと、福祉施設のとき、どちらに近いですか？」\n- 「Diana で **3役グランドスラム** と、いま **エデュケーション・トレーニング**。**『みんなを稼がせる』** 巻き込み、僕もBNIで学ばせてもらっています。チャプターでいま熱いテーマは何ですか？」\n- 「MLMを80社見て回った、という経験は珍しいですね。**今の10分ネイルの広げ方** に活きていることはありますか？」\n\n**雑談から事業へ戻す**\n\n> 「すみません、脱線しました。では神保さんのお仕事の話、伺ってもよいですか？」\n\n### 2. 前半：神保さんの事業紹介〜質疑応答\n\n**まず聞く姿勢で入る。**\n\n> 「切り口に **『10分ネイルって知ってる？』** と書いてあったので、まさにそこから教えてください。  \n> 僕の理解では、**10分で身だしなみが整う** 独自手法と、**美容室1000店舗** や **福祉・企業への出張**、**Smile Nail Earth** が並行している印象です。  \n> いま神保さんが **一番力を入れているのはどれ** に近いですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n- 「**B to B 出張ネイル** で、施設側の **求人・退職・売上・モチベ** まで一括で提案されるとのこと。導入までの典型的な流れと、**成果が出た施設** の共通点は何ですか？」\n- 「**赤字→黒字** にされたデイサービスでは、ネイル以外にも手を入れられた部分はありますか？」\n- 「**年間3000万（BNI紹介）** は、どんな単価・どんな業種の紹介が主役になりそうですか？」\n- 「**500施設**・**1000店舗** に向けて、今いちばん **詰まっているのは人材・教育・予約・本部管理** のどこですか？」\n- 「**パワーチーム** の固定費削減は、神保さん側のサービス範囲と、外部パートナー頼みの境界はどう分けていますか？」\n- 「**質の高いリファーラル** に、健康経営・福祉複数施設・ケアマネとありました。**直近でうまくいった紹介** を1件、教えていただけますか？」\n- 「コンタクトサークルで **美容WEB・SNS** がTop3でした。いま **足りないのは制作・運用・広告** のどれに近いですか？」\n- 「**不適切なリファーラルは特になし** とありますが、逆に **事前に確認してほしい条件**（規模・地域・業種）はありますか？」\n- 「海外から日本ネイル技術を取り入れたい、というBNI経由の話もありました。**いま進行中** のものはありますか？」\n\n**紹介文を作るための確認**\n\n> 「第三者に紹介するとき、  \n> **『10分で身だしなみが整う世界初の10分ネイル。美容室のFC展開から、福祉・企業の出張ネイルで施設の人的資本と業績改善まで。全日本選手権受賞・Diana 3役グランドスラムの神保さん』**  \n> という言い方は、ズレ少ないですか？短くするならどの一言がよいですか？」\n\n### 3. 後半：こちらの事業紹介〜質疑応答\n\n**説明軸:** tugilo ＝ 業務の流れを整理し、必要なところだけシステム化（AIはその一部）。\n\n> 「僕は、ExcelやLINE、紙、手作業で回っている業務を整理して、現場に合わせて小さく仕組み化する仕事をしています。  \n> AIも使いますが、**AI単体ではなく**、見積・問い合わせ・予約・日報・多拠点の連絡など、**現場の流れに組み込む** 形が多いです。」\n\n**神保さん向けに刺さりそうな接点（話すときの例）**\n\n- **出張ネイル:** 施設ごとの予約・ネイリストのシフト・施術記録がバラバラ → 本部で見える化\n- **フランチャイズ:** 店舗数が増えたときの **教育・品質・実績データ** の共有\n- **福祉:** 連絡・記録・スタッフ間引き継ぎの属人化（ネイル以外の業務改善とも両立）\n- **健康経営×企業:** 従業員向けサービスは神保さん、**その先の社内オペが手作業** なら tugilo 領域\n- **紹介の線:** 次廣のネットワークの **建設・製造・多拠点10〜30人** ＋ 健康経営を掲げる企業\n\n**相手に聞いてもらう質問**\n\n> 「神保さんから見て、僕の仕事は **どんな業種・どんな困りごと** の人に紹介しやすそうですか？  \n> また、**紹介しない方がよい条件** があれば教えてください。」\n\n**Living Document 参照（読み上げ時）**\n\n- オープニング・実績・紹介依頼のフル版 → [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §8.1\n- 具体例は同ファイル §8.3（FC本部・LINE日報・解体LINE見積 等）\n\n### 4. クロージング\n\n> 「今日の話を受けて、僕から紹介できそうな人（健康経営・多拠点・福祉運営まわり）を整理します。  \n> 逆に、神保さんから見て僕に合いそうな方がいれば、無理のない範囲で教えてください。  \n> 紹介のときの一言は、今日確認した表現で進めてもよいですか？  \n> 名刺・LINE・メンバー表、交換させてください。第2回のタイミングも、よろしければ軽く決められればうれしいです。」\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-28\n\n#### 基本情報\n\n- **日時:** 2026-05-28（木）JST TODO（開始・終了時刻は Zoom／カレンダー等で確認）\n- **実施方法:** TODO\n- **相手:** 神保玲太（SNEP株式会社／BNI Diana）\n- **紹介者:** 鈴木健介（BNI Diana）\n- **Religo 1to1 レコード:** `one_to_ones.id = 36`（**1セッション＝DB 1行**。`members.id = 138`（神保玲太／BNI Diana visitor））\n- **目的:** 初回相互理解。10分ネイル・B to B・FC・Smile Nail Earth の優先順位、相互リファーラル条件、業務仕組み化の接点を確認する。\n\n#### 主な成果\n\n- 次廣は、AI業務改善システム構築、とくに **BNI向け予約管理システム** について、神保さんから美容業界の現場感に基づく具体的なフィードバックを得た。\n- ホットペッパーからの脱却支援は、予約システムだけでは不十分で、**集客不安を埋める施策**（MEO、ポスティング等）とセットで提案する必要があると整理できた。\n- 予約管理パッケージは、月額 **1万円以下**、基本 **4,980円** 程度から始め、リマインドや周期フォローなどをオプション化する方向性が明確になった。\n- 神保さんの **10分ネイル** は、ネイルを「おしゃれ」から「身だしなみ」に移し、コンビニコーヒーのように日常導線へ浸透させる戦略だと理解した。\n\n#### 話した内容（重要）\n\n##### 1. 次廣側の事業概要\n\n- 次廣はシステムエンジニア26年目。静岡県藤枝市を拠点に、**AI業務改善システム構築** を行っている。\n- 文系（フランス語学科）出身だが、1990年代のインターネット黎明期に DTM をきっかけに IT 業界へ入り、コンピューター組み立て、インフラ、Webシステム開発まで幅広く経験してきた。\n- DragonFly には 2025年3月に入会。カテゴリーは **AI業務改善システム構築**。入会後の推奨トレーニングを短期間で完了した。\n- 強みは、専門用語に寄りすぎず、経営者と現場の間に入って **人の言葉で業務を整理する** こと。言われたものをそのまま作るのではなく、現場の流れを理解し、既存システムを押し付けずに必要な仕組みを作る。\n- システム開発だけでなく、ファイル管理の改善、業務フロー整理、AI活用など、必要に応じて **業務効率化全般** を伴走する。\n\n##### 2. 次廣側の実績共有\n\n- **FC本部・外注ブロック管理:** Googleフォーム、Excel、契約店情報が分散していた状態から、販売・顧客・契約店・売上を一元管理できるシステムを構築。店舗数が増えても管理できる土台を作った。\n- **名古屋の防水工事・LINE日報:** 外国人労働者が多く、紙の日報では誤読や集計遅れが出ていた。LINEから人数・時間・材料を現場別に提出できるようにし、人件費・材料費・請求根拠・給与計算に使える状態にした。\n- **静岡中部の観光周遊企画:** LINEから参加できるスタンプラリー／ビンゴの仕組みを構築。\n- **動物病院の予約管理:** LINE予約、前日リマインド、検診後の半年後リマインドなどを実装。神保さんからの予約システム要件と接続する事例として共有した。\n\n##### 3. 神保さんの事業概要\n\n- 神保さんは SNEP株式会社の代表。BNI Diana では現在 **10分ネイル** カテゴリーで活動している。\n- BNI歴は約5年。カテゴリーは、麻布十番のプライベートサロン、医療福祉ネイルケア、現在の10分ネイルへと変遷してきた。\n- 医療福祉ネイルケアは約2年取り組んだが、介護施設ではボランティア色が強く、収益化しにくいと判断。BNI内外のプロフェッショナルを活かす方向として、現在の10分ネイルに転換した。\n- Diana では複数期で三役を経験。プレジデント経験により横のつながりが広がり、その時の仲間とは今も関係が続いている。\n- 趣味・価値観として、HIPHOP/R&B、DJ経験、量子力学など見えないものへの関心、ゴルフ、座右の銘「コツコツが勝つコツ」、基本的に「はい」「喜んで」で受ける姿勢が共有された。\n\n##### 4. 10分ネイルの戦略理解\n\n- 神保さんは、ネイル市場の大半を占める未利用層に対して、ネイルを **おしゃれ** ではなく **身だしなみ** として広げようとしている。\n- 目指しているのは、寝癖を直す、眉毛を整える、ヒゲを剃る、爪を切る／磨く、という日常行動の中にネイルケアを入れること。\n- コンビニコーヒーのように、専門店ではない場所で **ついでにできる導線** を作り、認知と習慣化を先に起こす戦略を取っている。\n- ターゲットは、5人以上のスタッフがいる美容室オーナー、理容室・美容室オーナー、ネイルサロン以外で10分ネイルを提供できる店舗（整体・マッサージ等）。\n- 技術習得後に商材を扱えるようにし、ロイヤリティは取らず、商材販売で収益を積むモデルを想定している。\n\n##### 5. ホットペッパー問題と予約システムの方向性\n\n- 神保さんの見立てでは、美容室・サロンがホットペッパーをやめられない理由は、主に **予約システム依存** と **集客不安** の2つ。\n- ホットペッパーをやめると予約システムが使えなくなり、同時に「お客さんが来なくなるのでは」という不安が残るため、麻薬のようにやめづらい。\n- ポイント負担は店舗側持ち出しで、初回ポイントだけ利用してリピートしない顧客もいる。広告費と実際の増客を比べると、やめた後と大きく変わらないケースもある。\n- 脱ホットペッパー支援は、予約システムだけではなく、**MEO、ポスティング、地域集客** などの専門家と組むパワーチーム型が有効。\n- 美容室とネイルサロンでは顧客行動が異なる。美容室は有名店・表参道・麻布十番などへ行く動機がありやすい一方、ネイルは近場志向が強く、地域密着施策との相性が高い。\n\n##### 6. 予約システムに必要な機能\n\n- リピートしない最大の理由は「気に入らなかった」ではなく **忘れられること**。そのため、自動リマインドが重要。\n- 周期別フォローアップが必要。例: 3週間周期の顧客には3週間前、来店がなければ1ヶ月前、他店に行った可能性がある顧客には1ヶ月半後に再接触する。\n- 一度でも来店した顧客を、3ヶ月〜半年程度、自動で追い続ける仕組みが有効。\n- 次廣の予約システムは、ホットペッパーのように「空き枠から顧客が選ぶ」だけでなく、事業者側が **この時間を提案したい／この時間は開けたくない** という運用をしやすい方向が合いそう。\n- 価格は月額 **1万円以下**、基本 **4,980円** 程度から始め、リマインド・周期フォロー・カスタマイズ等をオプション追加できる構成がよい。\n- 美容室はシャンプー、パーマ、カラー中の手空き、複数スタッフの同時管理があり、ネイル・エステより予約管理が複雑。まずは業種ごとの複雑度を分ける必要がある。\n\n##### 7. 「もしもシリーズ」\n\n- 神保さんから、異業種の視点を活かす **「もしもシリーズ」** の提案があった。\n- 例: 「もしも自分がシステムエンジニアだったらどう広げるか」「もしも次廣が10分ネイルのオーナーだったらどう集客・スケールさせるか」。\n- 業界外の人が外部取締役のように見ることで、業界内では当たり前になっている改善点や新しい打ち手が見えやすくなる。\n- BNIの1to1やパワーチーム単位で実施すると、紹介・協業・商品設計のアイデア出しに使えそう。\n\n##### 8. BNI活動に関する洞察\n\n- 神保さんは、1to1の相手を「目の前の人」ではなく、その後ろに人脈を持つ **ハブ** と捉えている。\n- たまにホームランがあるため、基本的に断らず、異業種と話すことで刺激を受ける姿勢が重要。\n- 美容師など時間の切り売り型ビジネスでは、BNI活動が営業日を削ることになるため、スタッフが2〜3人以上いるかどうかが継続の分かれ目になりやすい。\n- プレジデント経験は横のつながりを作る上で大きく、BNI内の関係資産として残る。\n\n#### 決定・合意\n\n- **予約システム:** BNI向けに、月額1万円以下で始められる予約管理パッケージを検討する。\n- **価格モデル:** 基本4,980円程度から始め、必要な機能を追加できるオプション制を検討する。\n- **ビジネスモデル:** ロイヤリティではなく、商材・機能・オプション販売で広げるモデルを参考にする。\n- **脱ホットペッパー支援:** 予約システム単体ではなく、MEO・ポスティング等の集客支援者と組んだパワーチーム型で考える。\n- **フォロー:** 予約システムのプロトタイプができたら、神保さんに優先して共有し、フィードバックをもらう。\n- **関係継続:** 次廣から積極的に連絡し、定期的にフォローアップする。\n\n#### 次アクション\n\n- **次廣:** 野口さん（美容師・BNI退会予定）との接続を急ぎ実施する。\n- **次廣:** 夏に向けて、予約管理システムの基本機能＋オプション制の形を具体化する。\n- **次廣:** 予約システムのプロトタイプ完成後、神保さんへ最優先で提示する。\n- **次廣:** 増田さんの外注ブロック管理システムのデモを後日共有する。\n- **次廣:** 神保さんへ Instagram アカウント情報を送付し、10分ネイル理解を深める。\n- **次廣:** 神保さんへ BNI／SNS 等のコネクト申請を行う。\n- **神保さん:** 美容室オーナー（スタッフ5人以上）、理容室、美容室、整体・マッサージ等、10分ネイル導入先候補を検討する。\n- **神保さん:** 次廣に合いそうな、システムエンジニア、税理士、コンサルタント、Webデザイナー等との協業可能性がある人材紹介を検討する。\n\n#### 神保さんへのお礼文（送信用）\n\n> 神保さん、本日は1to1のお時間をいただき、ありがとうございました。  \n> 10分ネイルを「おしゃれ」ではなく「身だしなみ」として広げる考え方、コンビニコーヒーのように生活導線に入れていく戦略がとても勉強になりました。  \n> また、僕が考えている予約管理システムについて、ホットペッパーをやめられない本質が「予約システム」と「集客不安」の2つにあること、リマインドや周期フォローが重要であることなど、かなり具体的なヒントをいただきました。  \n> まずは野口さんとの接続と、予約システムのプロトタイプ整理を進めます。形が見えてきたら、ぜひ最優先でご意見を伺わせてください。  \n> 今後ともよろしくお願いいたします。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 神保さんは「ネイリスト」ではなく、**10分ネイルというプロダクトで美容・福祉・企業の人的資本課題を束ねる事業家**として紹介すると伝わりやすい。\n- **福祉の赤字→黒字** 実績は、ネイル単体ではなく **施設経営への介入力** の証拠として強い。\n- BNI Goal の **年間3000万（紹介）** は、紹介の **質・業種・単価** を初回で確認すると動きやすい。\n- 鈴木さん経由のため、**Diana 内の信頼チェーン** を大事にしたフォローがよい。\n- 神保さんの強みは、ネイル技術だけでなく、**紹介・教育・巻き込み・商品化** を組み合わせて広げる力にある。\n- 予約システムは、ホットペッパー代替を名乗るだけでは弱い。**脱ホットペッパー後の集客不安をどう埋めるか** が商品設計の核になる。\n- リピート施策は、予約機能よりも **忘れられない仕組み**（周期リマインド、自動フォロー、再来店導線）が価値になりやすい。\n- 「もしもシリーズ」は、BNI 1to1で相手の事業を深く理解し、異業種視点から紹介・商品改善を出す型として使える。\n- 神保さんは **地頭がよく、会話のテンポが速い**。こちらの立場に入って考え、抽象論ではなく「次廣ならどう売るか／どう組むか」まで具体化してくれるタイプ。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **予約管理パッケージ:** BNI向けに、月額1万円以下・基本4,980円＋オプション制の予約管理システムを検討する。対象はまず美容・ネイル・エステ・整体など、予約とリピートが売上に直結する業種。\n- **脱ホットペッパー支援:** 予約システム単体ではなく、MEO・ポスティング・SNS等の集客支援者と組むパワーチーム型で提案する。\n- **リマインド機能を主役にする:** 「予約できる」より、周期別リマインド・再来店フォロー・失客防止を価値として打ち出す。\n- **紹介候補:** 健康経営を掲げる10〜30人以上の企業、美容室5名以上オーナー、福祉複数施設運営者、ウエディングプランナー（DragonFly・他チャプター）。\n- **Web/SNS:** 神保さん Top3 に合わせ、DragonFly 内の **Web・SNS** メンバーへの **受動的紹介** を検討（協業パートナー化は不要）。\n- **プロトタイプ共有:** 予約システムの形が見えたら、神保さんへ最優先で見せ、業界目線のフィードバックをもらう。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n**次廣 → 神保さんへ紹介しやすい相手**\n\n- 健康経営・福利厚生を掲げる **従業員30名以上** の企業（製造・建設・サービス）\n- **従業員5名以上** の美容室オーナー・フランチャイズ検討者\n- デイサービス・有料老人ホームを **複数運営** する法人\n- ケアマネ・病院・医療従事者のネットワークを持つメンバー\n- ウエディングプランナー（ブライダル顧客満足の差別化）\n\n**神保さん → 次廣へ紹介してほしい相手（シート＋推定）**\n\n- 多拠点で **Excel/LINE/紙** のままの予約・日報・連絡に困っている経営者\n- フランチャイズ本部で **店舗データが見えない** オーナー\n- 「健康経営はやっているが **現場の仕組みが追いついていない**」企業\n- ホットペッパーをやめたいが、**予約システムと集客不安** で動けない美容室・ネイル・エステ・整体\n- 顧問先を持つ税理士・コンサルタント・Webデザイナーで、顧客の業務改善・予約導線改善を相談される人\n\n**紹介時の短い言い方（神保さん向け・案）**\n\n> 「10分で身だしなみが整う **10分ネイル**。美容室の展開から、福祉・企業への出張で **人的資本と業績** まで踏み込める、麻布十番の神保さんです。**10分ネイルって知ってる？** から入ってください。」\n\n**紹介時の短い言い方（次廣向け・神保さんに確認する用）**\n\n> 「ExcelやLINEで回っている業務を、現場に合わせて小さく仕組み化する。AI業務改善を **DragonFly の次廣** がやっています。多店舗・多施設の **見える化** が欲しい人に。」\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 推薦文: **前向き・新しいことにチャレンジ・周りが明るくなる**（小松氏）、**メンターとして早く教えてくれた**（萩原氏）、**巻き込み力・みんなを稼がせる**（八木氏）。\n- **黒豹・束縛が嫌い** — 押し付けより **選択肢とスピード** が合いそう。\n- 第1回所感: **地頭の良さとテンポの良さ** が強く印象に残った。次廣の事業や予約システムについて、単なる感想ではなく **次廣の立場に立った売り方・組み方** まで考えてくれた。\n- **ご飯は自分が担当** — 家庭的な一面。雑談で距離が縮みやすい。\n- 鈴木さん（撮影・サウナ）とは趣味 **サウナ** が近い可能性 — 必要なら軽く共有。\n\n---\n\n**作成:** 2026-05-28 14:38 JST（プロフィールコピペベース・初回実施前）','2026-05-28 17:08:50','2026-06-04 10:53:02'),
(37,1,37,18,NULL,'84716679422','itH7LYidQN2JvdnRcytlHw==','zoom','2026-06-01 14:00:00','2026-06-01 14:00:00','2026-06-01 15:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_harada_saori_ruiled_vision_japan.md】\n\n# 1to1_原田里織_RUILED VISION JAPAN\n\n---\n\n**文書の位置づけ:** DragonFly メンバー・原田里織さんとの 1to1 を **1ファイルで時系列管理**する。プロフィールシート／ONE to ONE シート／G.A.I.N.S.／リファーラル条件に、**第1回 1to1 文字起こし要約（2026-06-01）** を統合。  \n**整理:** tugilo（次廣 淳）× **BNI DragonFly** 同チャプター。  \n**日時:** 第1回 **2026-06-01（月）JST 14:00–15:00** 実施済み。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **37**。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供のプロフィールシート・ONE to ONE シート・G.A.I.N.S. ベース。原資料の「ローマ字」欄は **静岡県島田市** と記載されていたため、要確認メモとして扱う。\n\n### 人物・会社\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 原田　里織（はらだ　さおり） |\n| **ニックネーム** | さおりん♡ |\n| **生年月日** | 1988年7月7日 |\n| **出身・居住** | 出身: 静岡県御前崎市（旧 浜岡町）／居住: 静岡県島田市 |\n| **居住歴** | 旧浜岡町24年、菊川市5年、島田市9年 |\n| **家族** | 夫（原田 亮）、長女（咲来）、次女（紬来）、義両親、義祖母。**4世代7人家族で完全同居** |\n| **ペット** | なし |\n| **趣味** | 娘のバスケの応援、オシャレ |\n| **関心事** | 中国語、英語、経理、簿記、秘書検定 |\n| **座右の銘** | 頼まれ事は、試され事 |\n| **強い願望** | **世の中のお母さんを笑顔に♡** |\n| **誰も知らない私** | 数年前まで黒髪ロング |\n| **成功の鍵** | **す・な・お**（すねない、なめない、おそれない）であること |\n\n### 事業・役職\n\n| 項目 | 内容 |\n|------|------|\n| **主事業** | **RUILED VISION JAPAN株式会社**（2025年5月設立） |\n| **肩書** | 業務執行役員 |\n| **専門分野** | 店舗・施設集客を高めるデジタルサイネージ（LEDビジョン） |\n| **所在地** | 静岡県島田市中河町285-5 |\n| **経験年数** | 現在のビジネス **2年** |\n| **BNI** | DragonFly／ビジターホスト／入会（宣誓式）**2026-04-07** |\n| **連絡先** | 090-2347-5014 ／ white.banbi.2022@gmail.com |\n| **Web** | https://ruiled-vision-japan.site/ |\n| **Facebook** | https://www.facebook.com/share/1GbUKhTtzp/?mibextid=wwXIfr |\n\n### 関連事業・過去経験\n\n- **RUILED VISION JAPAN株式会社**（業務執行役員）\n- **ZeroVillage合同会社**（業務執行社員）\n- **美容サロン White Banbi**（共同経営）\n- **株式会社Tensais.**（取締役）\n- **合同会社Life.Long.Learning**（代表社員）\n- 介護福祉士 **15年**（通所リハビリ2施設）\n- セルフホワイトニングサロン経営\n- 飲食店（創作居酒屋ダイニングZERO、豚丼屋もも吉）\n- Beauty Japan FUJIYAMA/NEO 2024 ファイナリスト\n- SBT 2級（スーパーブレイントレーニング）\n\n### 第1回121で補足されたキャリア・BNI活動\n\n- 高校卒業後に介護福祉士資格を取得し、介護福祉士として **15年** 勤務。原田さんの職歴で最も長い軸。\n- 2022年頃、体力面・金銭面の不安から介護業界を離れる決断をした。\n- 佐野代表の会社に入り、個人事業主としてホワイトニングサロンを約2年運営。現在は脱毛のみ継続。\n- 2年前の幕張メッセ National Conference での登壇後、デジタルサイネージ領域へカテゴリーを転換。\n- BNIではリファラルマーケティング講座を継続受講し、田口氏のトレーニングも大阪でリアル受講。全国のエグゼクティブディレクターや他リージョンメンバーと積極的につながっている。\n- BNI活動歴は、静岡プロスペクトチャプター、OuVrir チャプター立ち上げ、DragonFly 移籍の流れが語られた。文字起こし要約内の年月はプロフィール記載の宣誓日（2026-04-07）と一部揺れがあるため、正確な時系列は要確認。\n\n---\n\n## ■ 事業理解（RUILED VISION JAPAN）\n\n### 何を提供しているか\n\n- 店舗・施設向けの **LEDデジタルサイネージ（デジタル看板）** の販売・設置\n- ミーティングボード（65〜85型）\n- 補助金・助成金の活用サポート\n- デジタルサイネージ販売代理店の開業支援\n\n### 他社にない強み\n\n- 中国深センの LED 工場と、BNI メンバー経由で **日中貿易独占契約** を持つ。\n- 中国工場から直接 LED 供給できるため、**全国最安値**・世界最先端の LED サイネージを提供できる。\n- 介護福祉士15年の経験から、予防アプローチの重要性を実感している。\n- 「デジタルサイネージで認知症予防」という独自ビジョンを持つ。\n- 子どもたちの作った動画・活動報告、企業広告を通じた社会貢献・感謝を発信するサイネージとして全国展開を目指している。\n\n### 切り出しトーク（本人定義）\n\n> 「全国最安値のLED・デジタル看板に興味はありませんか？中国深センの工場と直接取引しているメーカーなので、他社より圧倒的にお安く提供できます」\n\n> 「補助金・助成金を活用してデジタルサイネージを導入できるんですが、ご存知ですか？」\n\n> 「デジタルサイネージの販売代理店に興味はありませんか？仕入れ・在庫なしで始められます」\n\n### 第1回121で補足された事業情報（2026-06-01）\n\n- **事業範囲:** LEDビジョン製造、液晶サイネージ製造、販売・設置、パネル修理、販売店獲得。製造元は **中国深圳（シンセン）**。\n- **深圳BNIとの接点:** 静岡BNIメンバー経由で、深圳のBNIメンバー（劉社長）を紹介された。自社工場を持つサイネージ会社との出会いにより、従来より安価で太いパイプラインを確保。\n- **仕入れ優位:** 他社では最低ロット100台のような条件もある中、**1台から納品可能**。毎回1台ずつ中国側が見積を作成し、一般ユーザーより安い販売代理店価格で提供できる。\n- **サイネージ種類:** 野立て型、壁面型、窓ガラスに貼る**シースルータイプ**、1mm程度のフィルム状で窓ガラスに貼れる**ホログラフィックタイプ**、アイドルコンサート・スポーツスタジアム・360度空間演出などの大型演出。\n- **導入実績:** 大阪万博向けモニター納品、島田市の野立てサイネージ、金谷のBNIメンバー店舗、吉田町のラーメン店シースルータイプ、心斎橋のホログラフィックタイプ、北海道看板屋経由の2台発注など。\n- **市場観察:** 藤枝周辺でもサイネージが増加。銀行・マルシェ等への設置も進む一方、夜間の明るさや近隣住民との関係、設置場所に合わないコンテンツが課題。\n- **コンテンツ提案:** 広告だけでなく、地域の懐かしい祭りの風景など、地域性を活かしたコンテンツを流すことで受け入れられやすくなる可能性がある。\n\n### 販売代理店モデル（第1回121補足）\n\n| 項目 | 内容 |\n|------|------|\n| **加盟金** | **550,000円** |\n| **ノルマ** | なし |\n| **在庫** | 保有不要 |\n| **地域独占** | 都道府県ごとの独占契約なし。複数社加盟可能 |\n| **代理店メリット** | 社内資料・社内研修へのアクセス、販売代理店価格での仕入れ、サイネージ商材追加、問い合わせ対応の受け皿 |\n| **直近成果** | 先月だけで4〜5件、BNI入会後合計約10件の代理店獲得 |\n\n**相性の良い業種**\n\n1. **看板屋**: 看板設置スキル、屋外申請・許可の知識があり、既存の問い合わせにサイネージを追加提案しやすい。\n2. **電気工事士**: 設置時の電気工事に必要な専門知識があり、現地施工・保守との相性が高い。\n3. **不動産業**: 物件・空きスペース・店舗への設置提案がしやすい。\n\n**看板屋との協業モデル**\n\n- 従来は「サイン看板 vs サイネージ」という対立構造になりやすかった。\n- リファラルマーケティング講座で学んだ **「同業者こそ協業者」** の視点から、看板屋の弱み（サイネージ対応不可・電気工事が絡み難しそう・どこに頼めばよいか分からない）を補完する戦略へ転換。\n- 看板屋が販売代理店になることで、既存顧客へのサイネージ提案が可能になり、問い合わせ対応も RUILED VISION JAPAN 経由で可能になる。\n\n---\n\n## ■ G.A.I.N.S.\n\n| 区分 | 内容 |\n|------|------|\n| **Goal** | BNIのDNAになる／CorporateConnectionsで活躍する（まずは入会を目指す）／世の中のお母さんを笑顔に♡／SnowManのコンサートのステージのサイネージ担当／長女をしょっぴーに会わせる |\n| **短期（1年）** | 全国に LED ビジョンの販売店を **20店舗**。中国本社との交流を密にし、最低でも半年に一度は中国へ行く |\n| **中期（3年）** | 月収 **100万円** の女性になる |\n| **長期（5年）** | 予防に特化し、女性の自立をトータルサポート |\n| **Vision** | 子どもや女性の未来を明るくし、日本人の健康寿命を延ばす。予防の観点から、美・健康・学びの意識を高め、子どもたちと関わる介護予防施設を開設する |\n| **Accomplishments** | ホワイトニング・脱毛サロンオーナー、介護福祉士15年、飲食店、SBT2級、Beauty Japan FUJIYAMA/NEO 2024 ファイナリスト |\n| **Interests** | 学ぶこと全般、BNIトレーニング、TSLオンライン10期、朝倉千恵子先生、中国語・英語、娘たちの経験機会 |\n| **Networks** | BNI DragonFly・OuVrir、東京NEリージョン、静岡駿河西リージョン、全国BNI、COMY、浜松守成クラブ、やじるしオンライン交流会、日本OA・通信協会、中国・台湾BNI、島田市商工会、福祉関係、子育てママ、ミニバス関係 |\n| **Skill** | 中国BNIメンバー（LED工場）からのLED供給、サロン・飲食店へのサイネージ提案、ホワイトニング＆脱毛施術、介護福祉士、飲食店接客 |\n\n---\n\n## ■ 顧客・リファーラル条件\n\n### こんな人や会社がお客様\n\n- キャバクラ、ホストなどのナイト業態の店舗（**金のタマゴ1位**）\n- 2人以上の社員がいる企業\n- 飲食店、サロン、宝石屋などの店舗ビジネス\n- 展示会によく出展する業者\n- 看板業者、電気工事士、OA事務機、広告代理店\n- 事業の柱を増やしたい多角経営者、不動産・建設業\n- 店舗オープンや改装を予定しており、補助金・助成金活用に前向きな事業者\n\n### Contact Circle Top3\n\n1. **看板業者**\n2. **電気工事士**\n3. **広告代理店**\n\n### 直近10件の顧客\n\n| No | 内容 |\n|----|------|\n| 1 | 静岡県吉田町のラーメン屋さん（店内にシースルータイプのLEDビジョン） |\n| 2 | 静岡県藤枝市のオフィス家具会社（窓にシースルー、社内壁に細いタイプのLEDビジョン、キューブ） |\n| 3 | 北海道の看板屋さん（販売代理店） |\n| 4 | 愛知県の看板屋さん（販売代理店） |\n| 5 | 愛知県のデザイナー（販売代理店） |\n| 6 | 北海道の保険代理店（販売代理店） |\n| 7 | 愛知県の障がい者施設経営者（販売代理店） |\n| 8 | 大阪のお肉の卸会社（販売代理店） |\n| 9 | 大阪のデザイナー（心斎橋にホログラフィックタイプのLED） |\n| 10 | 長野県の看板屋さん（販売代理店） |\n\n### 流入経路\n\n- BNIメンバーからのリファーラル\n- BNIトレーニング参加での出会い\n- 招待予定のビジター\n- COMYユーザー／COMY Zoom交流会\n- 浜松守成クラブ\n- やじるしオンライン交流会\n- 展示会\n- 島田市商工会\n\n### 質の高いリファーラル\n\n店舗のオープンや改装を検討中で、補助金・助成金の活用に前向きな事業者への紹介。または、新しい収入の柱を探していて、デジタルサイネージの販売代理店に興味がある方への紹介。\n\n### 不適切なリファーラル\n\n本人の意志ではなく強引に紹介されたケース。予算も計画もなく、「とりあえず話だけ」の段階にもない方。\n\n### その他の有力リファーラル提供者\n\n- 展示会イベント主催者（**金のファーマー1位**）\n- 看板協会のトップ\n- OA機器協会のトップ\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係性:** 同じ **BNI DragonFly** メンバー同士。**第1回 1to1 は 2026-06-01 JST 14:00–15:00 実施済み**。時間不足のため、**おかわりワントゥーワン** を改めて設定することで合意。\n- **事業理解:** 原田さんは、LEDデジタルサイネージを **中国深圳の工場直結・1台から納品可能・販売代理店価格・補助金活用** で広げる。製品は野立て、壁面、シースルー、ホログラフィック、空間演出まで幅がある。\n- **代理店戦略:** 看板屋・電気工事士・不動産業が特に相性良い。中でも看板屋は、従来のサイン看板の顧客基盤・設置知識を活かしながら、サイネージ問い合わせに対応できるため有力。\n- **合意・アクション:** 次廣から、公共工事・信号取り付け等に関わる知人の **電気工事士** を原田さんへ紹介できるか確認する。原田さん側は、来月のメインプレゼン準備を進める。\n- **次廣側の共有:** システムエンジニア歴26年、伴走型システム開発、第一ブロックFC本部システム、防水工事LINE日報、観光周遊イベント、動物病院予約管理を共有。夏頃リリースを目指す **ホットペッパー代替の予約管理システム** 構想も共有した。\n- **協業の芽:** サイネージ販売代理店網・看板屋/電気工事士ネットワークと、次廣の予約管理・店舗導線・業務改善を組み合わせた店舗集客パワーチームの可能性がある。\n\n---\n\n## ■ 初回セッション設計（2026-06-01）\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 初回の感謝、DragonFly同士としての安心感、進め方の合意 |\n| 5〜10分 | 雑談 | 娘さんのバスケ、4世代同居、Beauty Japan、SnowMan、中国語・英語 |\n| 10〜30分 | 原田さん | LEDサイネージ事業、工場直契約、価格優位、代理店モデル、補助金活用、良い紹介条件 |\n| 30〜42分 | 次廣 | AI業務改善・システム構築、店舗/多拠点/代理店網の業務整理、紹介してほしい相手 |\n| 42〜55分 | 接点探索 | サイネージ販売後の運用、コンテンツ更新、代理店管理、補助金後の業務フロー、店舗集客パワーチーム |\n| 55〜60分 | クローズ | 次アクション1〜2件、紹介文の確認、会後メモ・Religo登録 |\n\n### 初回で聞くこと（チェックリスト）\n\n- [ ] 「全国最安値」と言うときの **価格差の見せ方**（例: 何割安い、比較対象、導入事例）\n- [ ] LEDビジョンの主要タイプ（シースルー、細いタイプ、キューブ、ホログラフィック等）と、どの業種に合うか\n- [ ] いま一番欲しいリファーラルは **導入先** か **販売代理店** か **業界団体トップ** か\n- [ ] 看板業者・電気工事士・広告代理店のうち、最優先の1カテゴリ\n- [ ] 補助金・助成金サポートの範囲（申請支援者との連携か、自社で案内までか）\n- [ ] 導入後のコンテンツ更新・動画制作・広告枠販売・効果測定は誰が担うか\n- [ ] 代理店20店舗に向けた管理課題（契約、案件共有、見積、発注、施工、サポート）\n- [ ] 中国本社・中国BNIメンバーとのやり取りで困っている運用（言語、発注、納期、品質確認）\n- [ ] 「デジタルサイネージで認知症予防」の構想は、いつ・どの場で語ると紹介につながりやすいか\n- [ ] 次廣を紹介しやすい相手の条件（店舗業務、代理店管理、補助金後の運用、顧客管理など）\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n### 1. オープニング\n\n> 「原田さん、本日はお時間ありがとうございます。DragonFly の次廣です。\n> 今日は初回なので、原田さんのお仕事をしっかり理解して、僕が誰にどう紹介できるかを言葉にしたいです。\n> 後半で私の業務改善・システム化の話も短くしますので、原田さんから見て『こういう人なら合いそう』という視点で聞いていただけるとうれしいです。\n> まず原田さんの事業を中心に、最後に相互紹介の条件を確認する流れでよいですか？」\n\n### 1.5 雑談（信頼づくり）\n\n> 「プロフィールを拝見して、4世代7人家族で完全同居、娘さんのバスケの応援、Beauty Japan ファイナリスト、中国語や英語も学びたいと、行動量がすごいですね。\n> 『世の中のお母さんを笑顔に』という願望も印象に残りました。いま一番エネルギーを使っていることは、事業・ご家族・学びのどれに近いですか？」\n\n### 2. 前半：原田さんの事業紹介〜質疑応答\n\n> 「RUILED VISION JAPANさんは、店舗や施設の集客を高める LED デジタルサイネージのメーカーで、中国深センの工場と直接つながっているのが大きな強みなんですね。\n> 第三者に紹介するとき、まずは **『全国最安値クラスでLEDデジタル看板を導入できる、RUILED VISION JAPANの原田さん』** という言い方でズレは少ないですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n- 「いま一番伸ばしたいのは、**店舗への導入**、**販売代理店**、**看板・電気工事・広告代理店との提携** のどれですか？」\n- 「金のタマゴ1位がナイト業態とのことですが、ナイト業態で刺さる理由は **視認性・集客・単価・演出** のどこが大きいですか？」\n- 「ラーメン屋さん、オフィス家具会社、看板屋さん代理店など、導入後に一番喜ばれた成果は何ですか？」\n- 「補助金・助成金を使う場合、紹介者はどこまで話せるとよいですか？」\n- 「販売代理店に向く人は、看板業者・電気工事士・広告代理店の中でもどんな条件がありますか？」\n\n### 3. 後半：次廣の事業紹介〜接点探索\n\n> 「私は、Excelや紙、LINE、メールでばらばらになっている業務を整理して、現場に合わせて小さくシステム化する仕事をしています。\n> AIも使いますが、AI単体ではなく、問い合わせ・見積・予約・日報・発注・顧客管理など、実際の業務の流れに組み込む形が多いです。」\n\n**原田さん向けに刺さりそうな接点**\n\n- **代理店管理:** 販売店20店舗を目指すと、案件共有・見積・発注・施工状況・紹介元管理が散らばりやすい。\n- **サイネージ導入後の運用:** 表示コンテンツ、広告枠、更新依頼、動画素材、効果測定の管理。\n- **店舗集客パワーチーム:** サイネージ単体ではなく、MEO/SEO/SNS/動画/広告/店舗オペ改善と組み合わせると紹介しやすい。\n- **補助金後の仕組み化:** 補助金で設備導入した後、問い合わせや来店導線を業務として回す仕組みが必要になる。\n\n**相手に聞いてもらう質問**\n\n> 「原田さんから見て、私の仕事はどんな方に紹介しやすそうですか？ 例えば、店舗や代理店で **問い合わせ・見積・案件管理がバラバラ** になっている方は合いそうでしょうか？」\n\n### 4. クロージング\n\n> 「今日の話を受けて、原田さんを紹介するときの一言と、私から当たりやすい紹介候補を整理します。\n> 逆に、原田さんから見て私に合いそうな方がいれば、無理のない範囲で教えてください。\n> まずは1件でも、紹介しやすい条件を具体化できたらうれしいです。」\n\n---\n\n## ■ tugiloとしての戦略\n\n- 原田さんを **「LED看板の人」だけでなく、「店舗・施設の集客導線を、安価なLEDサイネージ＋補助金＋代理店網で広げる人」** と理解する。\n- 価格訴求が強い一方で、本人の深い願望は **母親・女性・子ども・予防・健康寿命** にある。初回はビジネス優先で聞きつつ、長期ビジョンは人物理解として必ず拾う。\n- 次廣側は、サイネージの「販売」ではなく、**販売後の運用・案件管理・代理店管理・店舗導線** に接点を置く。\n- 原田さんの Contact Circle Top3（看板業者・電気工事士・広告代理店）は、次廣単独では直接網羅しない可能性があるため、DragonFly 内外の誰がその接点を持つかを原田さん本人に確認する。\n- サロン・飲食・展示会・店舗改装の文脈は、次廣の予約管理・問い合わせ管理・小規模業務改善と相性がある。すぐ案件化ではなく、**店舗パワーチーム** の素材として管理する。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 原田さんへ紹介しやすい相手\n\n- 店舗オープン・改装を予定している経営者\n- ナイト業態、飲食店、サロン、宝石店など、店頭視認性・演出・集客が売上に直結する店舗\n- 展示会に出展し、ブースで目立つ必要がある事業者\n- 看板業者・電気工事士・広告代理店で、新しい商材や利益の柱を探している人\n- 補助金・助成金を活用して設備導入を検討している事業者\n- 多角経営者、不動産・建設業など、店舗・施設・拠点を持つ経営者\n\n### 次廣から確認したい DragonFly / 周辺候補\n\n| 候補カテゴリ | 接続理由 | 初回での扱い |\n|------|------|------|\n| **店舗ビジネスのメンバー** | サロン・飲食・小売・来店型ビジネスはサイネージ導入候補になりやすい | 具体名は会話後に本人の条件に合わせて絞る |\n| **建設・電気・施工系の接点を持つメンバー** | 電気工事士・施工会社・内装/外装業者との連携が導入実務に近い | Top3 のうち最優先を確認してから探索 |\n| **MEO/SEO/SNS/広告領域の外部接点** | サイネージを「集客施策」の一部として提案できる | 辻亮さん（MainC）など、店舗集客系の既存接点は候補として検討 |\n| **展示会・イベント主催者接点** | 展示会出展業者、イベント会場、企業PRとの相性が高い | 原田さんが欲しい業界を確認 |\n| **補助金・助成金に強い士業/コンサル** | 設備導入の意思決定を進めやすい | 申請支援の範囲確認後に接続 |\n\n### 原田さんから次廣へ紹介してもらいやすい相手\n\n- LEDサイネージや店舗集客の相談で、導入後の **問い合わせ・見積・顧客管理** が散らばっている店舗・施設\n- 販売代理店・看板業者・広告代理店で、案件管理や顧客フォローが手作業になっている会社\n- 補助金で設備投資したが、その後の業務運用が整っていない事業者\n- サロン・飲食・小売で、予約・リピート・LINE・問い合わせ対応を整理したい経営者\n- 中国・台湾BNIや海外取引で、発注・納期・品質確認・情報共有の管理に課題がある事業者\n\n### 第三者紹介の短い言い方（たたき台）\n\n> 原田さんは、RUILED VISION JAPAN株式会社で LEDデジタルサイネージを扱っている DragonFly メンバーです。中国深センの工場と直接つながっていて、店舗や施設に全国最安値クラスでデジタル看板を導入できます。店舗オープン・改装、看板業者・電気工事士・広告代理店、新しい商材を探している方に合いそうです。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-06-01 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-01（月）JST 14:00–15:00**（取得元: ユーザー提供 2026-06-01）\n- **実施方法:** TODO（Zoom / 対面など、会後に確認）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **37**\n- **目的:** 初回相互理解。原田さんの LEDサイネージ事業、販売代理店戦略、看板屋・電気工事士との連携、次廣の業務改善・予約管理システム構想との接点を確認する。\n\n#### ■ 主な成果\n\n- 原田さん（デジタルサイネージ事業）と次廣（システムエンジニア）が、お互いのビジネスを深く理解した。\n- 原田さんの販売代理店戦略では、**看板屋・電気工事士** が特に相性良いことを確認した。\n- 次廣から、知人の **電気工事士** を原田さんへ紹介できる可能性が示された。\n- 次廣の **ホットペッパー代替予約システム** 構想について共有し、店舗集客・予約・MEOパワーチームの接点を確認した。\n- 時間不足のため、改めて **おかわりワントゥーワン** を設定することで合意した。\n\n#### ■ 決定事項・合意内容\n\n| 項目 | 内容 |\n|------|------|\n| **相互紹介** | 次廣が知人の電気工事士への連絡・紹介可否を確認する |\n| **原田さんのターゲット** | 販売代理店獲得では **看板屋・電気工事士** が特に有力。看板屋はサイネージ問い合わせ対応の弱みを補完できる |\n| **次回** | おかわりワントゥーワンを実施予定（日時未定） |\n| **原田さん側** | 来月のメインプレゼン準備 |\n| **次廣側** | 予約管理システム開発を継続（夏頃リリース目標）、6月メインプレゼン準備 |\n\n#### ■ 原田さん側の共有内容（要約）\n\n**デジタルサイネージ事業**\n\n- 事業内容は、LEDビジョン製造、液晶サイネージ製造、販売設置、パネル修理、販売店獲得。\n- 製造元は中国深圳。静岡BNIメンバーから深圳BNIメンバー（劉社長）を紹介され、自社工場を持つサイネージ会社とのパイプラインができた。\n- 1台から納品可能で、毎回1台ずつ見積を作成できる。一般ユーザーより安価な販売代理店価格で提供可能。\n- サイネージは、野立て型、壁面型、シースルータイプ、ホログラフィックタイプ、空間演出用など幅広い。\n\n**導入・販売実績**\n\n- 大阪万博へモニター数十台を納品。\n- 島田市で土地を借りて野立てサイネージを設置。\n- 金谷のBNIメンバー店舗、吉田町のラーメン店、心斎橋のホログラフィックタイプなど導入実績あり。\n- 北海道の看板屋が販売代理店となり、2台の発注を獲得。現地看板屋が設置も担えるため、静岡から現地へ行かずに展開できる。\n\n**販売代理店戦略**\n\n- 加盟金は **550,000円**。ノルマなし、在庫不要、都道府県独占なし。\n- 販売代理店は、社内資料・研修にアクセスでき、販売代理店価格で仕入れできる。\n- BNI入会後、合計約10件の代理店獲得。先月だけで4〜5件の代理店契約が成立。\n- 成功パターンは、BNIトレーニングで同室になった看板制作カテゴリーの方、保険代理店から北海道看板屋への紹介、久米氏経由の浜松大型サイネージ案件など。\n\n**看板屋・電気工事士との連携**\n\n- 看板屋は、看板設置スキル・屋外申請許可の知識があり、サイネージ設置と相性が良い。\n- 電気工事士は、設置工事に必要な電気工事の専門知識がある。\n- 看板屋はサイン看板の仕事で忙しい一方、サイネージ問い合わせに対応できない・どこに頼めばよいか分からない・電気工事が絡み難しそう、という悩みがある。\n- 原田さんは、リファラルマーケティング講座で学んだ **「同業者こそ協業者」** の考え方を、看板屋との協業戦略に活かしている。\n\n#### ■ 次廣側の共有内容（要約）\n\n**キャリア・強み**\n\n- システムエンジニア歴 **26年**。外国語学部フランス語学科出身で、90年代後半のインターネット黎明期に音楽活動を通じてホームページ制作を始めた。\n- コンピューター組み立て、インフラ構築、システム設計開発まで一通り経験。\n- 既存ツールを押し付けず、現場のワークフローに合わせてゼロから設計できる。\n- 専門用語を使わず、相手の立場で説明できることが強み。\n\n**開発スタイル**\n\n- 最初から大きなシステムを作らず、入り口から作り、必要な機能を追加・改善していく **伴走型・育てるシステム開発**。\n- ゴールは、人に頼らない状態、誰でも回せる状態を作ること。\n- 基本的には月額保守料金内で改善要望に対応し、大きな追加コストがかかる場合のみ別途見積。\n\n**主要実績**\n\n| 実績 | 内容 |\n|------|------|\n| **第一ブロック FC本部システム** | 全国約200社のフランチャイズ本部向け。Googleフォーム、メール、スプレッドシート、Excelに分散していた受注・顧客管理を統合。作業効率6〜7割改善 |\n| **防水工事業 LINE日報** | 外国人職人の手書き日報課題に対し、LINEで材料・作業内容・労働時間を提出し、本部で集計・請求・経費管理できる仕組み |\n| **駿河企画観光局 周遊イベント** | 静岡5市2町の周遊イベント。LINEでビンゴ・スタンプラリー参加。10年継続、次回は7月開始予定 |\n| **動物病院予約管理** | B2C向けのLINE連携予約管理 |\n\n**金の卵**\n\n- Excelで限界を感じている会社。\n- 同じ内容を複数ファイルに転記している会社。\n- 特定の人しか分からない業務がある会社。\n- そのような会社を顧問先で見ているコンサルタント、税理士、会計士。\n\n#### ■ 予約管理システム構想（次廣）\n\n- DragonFly入会前から開発を計画しており、**夏頃リリース** を目標。\n- フロントエンド商材として、システム開発への入口を下げる目的がある。\n- サロン事業者が **ホットペッパーをやめたいがやめられない** 状況を課題として捉えている。\n- ホットペッパーは料金が高く、顧客リストを事業者が持てず、クーポン目当ての一見客がリピーターになりにくい。\n- 新システムは、お客様が空き枠を選ぶだけでなく、事業者が開けたくない時間を調整できる **事業者目線の予約管理** を目指す。\n- 月額10,000円以下を目標にし、MEOが得意な人とのパワーチームで **宣伝（新規集客）＋仕組み（予約管理）** をセット提案する構想。\n\n#### ■ 地域・人脈の重なり\n\n- 原田さんの娘さんが青島中学校へバスケの練習試合で訪問予定。次廣の自宅は青島中学校の目の前。\n- 青島中学校近くの寝具店 **眠りのいなべ** を双方が知っている。次廣も利用、原田さんの夫も枕を購入。\n- 島田市は原田さんの居住地で、大井川鐵道のリアルトーマスで有名。\n- 久米氏、増本氏、佐野氏など、BNI人脈の重なりも多い。久米氏経由では浜松メンバーから大型サイネージ案件が成立。\n\n#### ■ 市場観察・今後の展望\n\n- 藤枝周辺でもサイネージが増えているが、好立地に従来型看板が残っている場所も多い。\n- 銀行・マルシェ等で大型サイネージ設置が進んでいる一方、明るさや設置場所・コンテンツの質が地域受容の課題になる。\n- 単に広告を流すだけでなく、地域の懐かしい祭りの風景など、地域性を活かしたコンテンツ提案が重要。\n- 全国の電気工事士・看板屋とのパワーチーム構築により、北海道のように現地パートナーが設置まで対応する展開が可能。\n\n#### ■ アクションアイテム\n\n- [ ] **次廣:** 知人の電気工事士（公共事業・信号取り付け等に関わる方）へ連絡し、原田さんへの紹介可能性を確認する。\n- [ ] **次廣:** 予約管理システムの開発を継続する（夏頃リリース目標）。\n- [ ] **次廣:** 6月のメインプレゼン準備を進める。\n- [ ] **原田さん:** 来月のメインプレゼン準備を進める。\n- [ ] **両者:** おかわりワントゥーワンの日程を調整する。\n\n#### ■ 確認待ち事項\n\n- 次廣の知人の電気工事士を紹介できるか。\n- おかわりワントゥーワンの日程。\n- 原田さんの BNI 活動歴の正確な年月（文字起こし要約とプロフィール記載に一部揺れあり）。\n- Religo `one_to_ones.id`。\n\n---\n\n## ■ 累積インサイト\n\n- 原田さんは、**店舗集客の即効性** と **社会貢献・予防・女性/母親支援** の両方を持つ。紹介時は相手に合わせて、前者（売上・集客）か後者（ビジョン）を出し分ける。\n- 「全国最安値」は強いが、第三者紹介では価格だけに寄せすぎると安売りに見える。**深圳BNIメンバー・自社工場・1台から納品可能・代理店価格・補助金支援** までセットで伝えると信頼が上がる。\n- 原田さんの代理店獲得は、**看板屋・電気工事士** が最優先。看板屋は「サイネージ問い合わせに対応できない」という明確な痛みがあり、協業者として最も説明しやすい。\n- 次廣との直接協業は、サイネージそのものではなく **導入後の運用・代理店管理・店舗導線・業務改善・予約管理** が本筋。\n- 店舗向けには、原田さんのサイネージ（認知・来店導線）と、次廣の予約管理（来店・再来店導線）、MEO専門家（検索・新規集客）を組み合わせるパワーチーム構想が自然。\n- サイネージ設置は、明るさ・設置場所・コンテンツ次第で地域からの受け止めが変わる。広告枠販売だけでなく、地域に受け入れられるコンテンツ設計が紹介時の差別化になる。\n\n---\n\n**更新:** 2026-06-01 13:43 JST — ユーザー提供プロフィールシート／ONE to ONE シート／G.A.I.N.S. をもとに、初回 1to1 事前ドキュメントを作成。  \n**更新:** 2026-06-01 15:55 JST — 第1回 1to1 文字起こし要約を反映。主な成果、決定事項、原田さんのデジタルサイネージ事業・販売代理店戦略、次廣の事業紹介・予約管理システム構想、アクションを追記。','2026-05-30 13:35:23','2026-06-04 10:53:02'),
(38,1,37,34,NULL,'86416812471','QjTZsT51Q/m770eDU1Ql0w==','zoom','2026-06-01 15:00:00','2026-06-01 15:00:00','2026-06-01 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_konaka_takaaki_becheerz.md】\n\n# 1to1_小中貴晃_BeCheerz\n\n---\n\n**文書の位置づけ:** DragonFly メンバー・小中貴晃さんとの 1to1 を **1ファイルで時系列管理**する。プロフィールシート／ONE to ONE シート／G.A.I.N.S.／紹介条件に加え、第1回 Zoom 要約を反映した実施後記録。  \n**整理:** tugilo（次廣 淳）× **BNI DragonFly** 同チャプター。AI活用・業務改善・システム開発領域の近接性が高く、アルシルブ、予約管理システム、BNI用1to1管理システム、医療カルテ生成支援、受託開発案件の相互紹介で協業可能性が確認された。  \n**日時:** 第1回 **2026-06-01（月）JST 15:00–16:00** 実施済み。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **38**。\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供のプロフィールシート・ONE to ONE シート・G.A.I.N.S. ベース。原資料の「ローマ字」欄は **東京都** と記載されていたため、住所/居住地系の誤入力として扱い、ローマ字表記は未確定。\n\n### 人物・会社\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 小中　貴晃（こなか　たかあき） |\n| **通称** | こなっち |\n| **出身・居住** | 出身: 京都／居住: 東京（居住年数2年） |\n| **家族** | 妻、娘2人（5歳・1歳） |\n| **ペット** | 猫（マンチカン2歳） |\n| **趣味** | お酒（ビール）、昭和歌謡、アカペラ（ボイパ担当）、長距離、キャンプ、デスクの魔改造・ガジェット |\n| **関心事** | 子供達に豊かな人生を送ってほしい |\n| **強い願望** | **仕事もプライベートも、一緒にいたい人と一緒にいれること** |\n| **誰も知らない私** | 大学生の頃、ボイスパーカッション担当でハモネプ出演 |\n| **成功の鍵** | **元気でポジティブにいること。物事は捉え方次第** |\n\n### 事業・役職\n\n| 項目 | 内容 |\n|------|------|\n| **会社名** | 株式会社BeCheerz |\n| **肩書** | 代表取締役 |\n| **兼務** | 株式会社pipon COO |\n| **専門分野** | 使って学ぶAIツールの情報発信／AIを使った業務効率化・生産性向上支援 |\n| **経験年数** | 現在のビジネス 2年 |\n| **過去経験** | Webエンジニア、営業、カスタマーサクセス、マーケ、新規事業開発、アライアンス、個人情報保護責任者など |\n| **BNI** | DragonFly／サポート（バイス・ビジホス・メンター・webマス・フォーラム）／入会（宣誓式）**2024-12-24** |\n| **連絡先** | 070-1443-8808 ／ takaaki.konaka@becheerz.com |\n\n---\n\n## ■ 事業理解（BeCheerz / pipon）\n\n### 何を提供しているか\n\n- AI基礎研修\n- 業務効率化・生産性向上を目的としたAI活用支援\n- ClaudeCode研修\n- LINEハーネスとAI連携の研修\n- 月額1,000円でのAIツール最新情報・使い方配信\n- 小粒から大型までのシステム開発\n- AIを活用したカルテ生成支援サービス（ボイスチャート）\n\n### 本人定義の切り出しトーク\n\n> AIの活用情報を、月額1,000円という低価格で、かつ非常にわかりやすく配信してくれている人がいるのですが、ご興味ありませんか？\n\n> AIを活用した業務効率化・生産性向上を、業務目線で支援してくれる人がいるのですが、ご興味ありませんか？\n\n### 他社にない強み\n\n- Webエンジニアと取締役COOの両方を経験しており、**技術と事業の両面**からAI活用を支援できる。\n- AIツールの情報発信だけでなく、研修、業務設計、システム開発、LINE連携、カルテ生成支援まで実装領域を持つ。\n- DragonFly 内では、教育・LT・サポート・バイス経験を通じて「わかりやすく伝える」「裏側で手を動かす」信頼が蓄積されている。\n- 外部COOとして依頼されるタイプで、単なる講師ではなく、事業推進・マネジメント・実装伴走まで担える。\n\n---\n\n## ■ G.A.I.N.S.\n\n| 区分 | 内容 |\n|------|------|\n| **Goal** | ミッション: **相手の人生の物語にバイネームで関わる**。売上目標: クライアントワーク以外の仕組み化された仕事で **MRR150万**。個人: 死ぬときに家族に惜しまれて死ぬ |\n| **Accomplishments** | 情報工学修士、上場メガベンチャーでフルスタックWebエンジニア、新規機能開発・保守運用・アプリ開発、営業・PdM、子会社取締役COO、創業 |\n| **定量実績** | SaaS販売単価をMRR3万円弱から9万円へ、SMB社長アポ月100件・年間1400件、代理店構築支援で売上6億創出、eラーニングのヘルススコア作業を30分から1分へ、新規事業モックを10分で作成 |\n| **Interests** | 人材育成・組織開発、AI最新トレンド、デスクの魔改造・ガジェット |\n| **Networks** | 日本創世勉強会、壁打ち交流会セカオピ、多摩西リージョンKINGDOM、東京NEリージョンRESINA |\n| **Skill** | ボイスパーカッション、ヒューマンビートボックス、スナックでハモって場を盛り上げる、AIを使った業務効率化支援 |\n\n---\n\n## ■ 顧客・紹介条件\n\n### こんな人や会社がお客様\n\n#### ハード面\n\n- 一人社長（個人事業主含む）\n- 従業員規模〜50名くらいまでの経営者\n- 病院・クリニック・診療所\n\n#### ソフト面\n\n- 営業チームを抱えており、営業の案件管理をExcelや日報で管理している企業\n- 生成AIをもっと業務活用したいが、ChatGPT程度しか使っていない人\n- 新規事業をやりたい人\n- プログラミングを学びたい人\n- 今後のキャリアについて悩んでいる人\n- 自社マネージャーのスキルアップをさせたい経営者\n\n### 直近10件の顧客\n\n1. 病院や診療所、クリニック\n2. 動画制作・SNSマーケ代行会社\n3. 人材紹介会社\n4. 大学\n5. ボイスコンテンツのデジタルマーケットプレイス制作会社\n6. 営業代行会社\n7. 人材育成コンサルティング会社\n\n### 小中さんが紹介できる人脈\n\n- オフィスの賃料削減コンサル（平均16％削減）\n- 資金調達コンサル\n- セゾンプラチナビジネス アメリカンエキスプレスカードの発行窓口\n- パートナーマネジメントのインハウス化支援\n- マーケティングのインハウス化支援\n- MEO対策支援コンサル\n- バックグラウンドチェックサービス\n\n---\n\n## ■ 推薦・ありがとうから見える人物像\n\n### DragonFly 内の見られ方\n\n- **教育がわかりやすい:** AI・ツール活用を「なるほど」と思える形で伝えられる。\n- **役割を超えて手を動かす:** バイス、サポートチーム、Webマスター支援など、バックヤード作業も厭わない。\n- **冷静な判断力と素早い行動力:** チャプター運営で安心感を与える存在。\n- **明るく盛り上げる:** 「はーい、こなっちです！」のような場づくり、ポジティブさ、人望。\n- **外部COO型:** 福上さんのコメントから、信頼できるビジネスパートナー・マネジメント補完者として見られている。\n\n### 1to1で深掘りしたい示唆\n\n- 「情報発信」「研修」「開発」「COO支援」「ボイスチャート」のどれを今後の主軸にしたいか。\n- MRR150万の仕組み化に向け、月額1,000円配信・研修・開発・医療向けプロダクトをどう組み合わせるか。\n- 次廣との近接領域が多いため、競合ではなく **役割分担・共同提案・相互紹介条件** を明確にする。\n\n---\n\n## ■ サマリー（最新状況）\n\n- 小中さんは、AIツール情報発信・AI研修・業務効率化支援・システム開発を横断する **事業×技術の両利き型AI活用支援者**。\n- 主要顧客は、小規模事業者、〜50名規模の経営者、医療機関、営業管理・日報・Excel運用に課題を持つ企業。\n- DragonFly 内では教育・LT・バイス・サポートで信頼が厚く、わかりやすい説明と実務遂行力が強み。\n- 第1回 1to1 で、次廣の **予約管理システム**、**社内ファイル管理AIシステム（アルシルブ）**、**BNI用1to1管理システム** と、小中さんのAI研修・医療カルテ生成支援・開発事業の協業可能性が高いことを確認した。\n- 開発案件の相談体制は、小中さん側（pipon等）で受けきれない案件を次廣に相談し、営業フィー **20〜30%** を乗せる方向で合意。\n- 次廣からは、田舎のクリニック院長夫妻へ小中さんの医療カルテ生成支援システムを紹介する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-06-01\n\n#### 基本情報\n\n- 日時: **2026-06-01（月）JST 15:00–16:00**\n- 実施方法: Zoom\n- Religo 1to1 ID: `one_to_ones.id = 38`\n- 情報源: Zoom 文字起こし要約（ユーザー提供 2026-06-01）\n\n#### 主な成果\n\n- 次廣が進めている **予約管理システム** と **社内ファイル管理AIシステム（アルシルブ）** は、小中さんとの協業可能性が高いことを確認した。\n- アルシルブは、補助金活用・自治体展開・小中さんのAI研修/開発事業との連携を含め、具体的に事業化検討する対象になった。\n- 次廣が開発中の **BNI用1to1管理システム** について、小中さんは「絶対売れる」「月何十万も取れる可能性がある」と強い関心を示した。\n- 小中さん側の医療カルテ生成支援システムについて、次廣の紹介先クリニックへつなぐ具体アクションが生まれた。\n\n#### 決定事項・合意\n\n- **アルシルブの協業検討:** 次廣が社内ファイル管理AIシステムの骨組みを固め次第、小中さんが具体的な事業化支援に入る。\n- **医療カルテ生成システムの紹介:** 次廣のクライアントである田舎の個人病院の院長夫妻に、小中さん（pipon側）が開発するカルテ生成支援システムを紹介する。\n- **開発案件の相談体制:** 小中さん側（pipon等）で受けきれない開発案件を次廣に相談する。営業フィーは **20〜30%** を乗せる方向で合意。\n\n#### 次廣のBNI活用戦略への助言\n\n- システム開発はBNIで伝わりにくいため、最初の入口になるフロント商材が必要。\n- BNIメンバーは個人事業主・一人社長が多く、最初のハードルを低くすることが重要。無料/有料、有形/無形を問わず、まず接点を作る。\n- 受注よりも、VCP の **V（Visibility / 認知）** の段階として「面白いですね、やってみます」という反応を作ることを優先する。\n- 初対面の1to1同士では互いのことを覚えていないことが多いため、まずは自チャプターメンバー同士の引き合わせから始める方が現実的。\n- BNI外の裏人脈に届けばラッキーだが、基本はBNIメンバー向けに設計する。\n\n#### 予約管理システムの方向性\n\n- 夏頃のリリースを目標に、事業者側の融通を重視した予約管理システムを開発中。\n- 美容・飲食業界には、ホットペッパーをやめたいが広告不安で踏み切れない事業者が多い。\n- 予約管理単体では新規顧客にリーチできないため、MEO専門家とワンチームで広告面もカバーする戦略が有効。\n- 従来の予約システムは顧客目線が中心だが、次廣側は事業者の「ここは開けたくない」といった融通を効かせられる設計を重視する。\n- AI活用も視野に、メニュー選択後に空いている候補を3つ提案するなど、事業者側の都合を優先できる予約体験を検討する。\n\n#### アルシルブ（社内ファイル管理AIシステム）\n\n##### コンセプト\n\n- 個人レベルでAI利用が広がる中、企業として全社的に使える仕組みを提供し、シャドーAI問題に対応する。\n- クラウドサービスではなく、企業のローカル環境に構築する形式。\n- 主要機能は、社内ファイル管理、社内問い合わせ対応、資料テンプレート管理、営業資料の自動生成支援。\n\n##### ターゲット・市場\n\n- 数人規模では導入メリットが薄く、**50人以上の組織**が主対象。\n- 過去資産が蓄積され、ファイルサーバーが整理されていない長期運営企業が向く。\n- 企業より自治体の方が適している可能性があり、次廣は地方自治体に市議会議員などの人脈を持つ。\n\n##### 事業モデル・価格\n\n- IT導入補助金など、AI名称が追加された補助金の活用を検討する。\n- 補助金は下限を攻めると採択率が悪くなるため、ある程度まとまった金額設定が必要。\n- ローカル構築型のため、月額保守・運用支援モデルをどう設計するかが課題。\n- 価格は、ファイル管理業務に人を雇うコストと比較して妥当性を示す。\n\n##### 小中さんの評価・助言\n\n- 「AIは手段であり目的ではない」という前提に沿った設計で、方向性は良い。\n- 大企業が全従業員にClaude研修を受けさせることは少なく、社長や経営幹部が先行して学ぶケースが多い。\n- 現場には設計済みのスキルだけを使わせるなど、ガードレールが重要。\n- 大企業導入では、AIを前面に出すより、業務に合わせた仕組み・システム・フロントを作り、その裏でAIが動く形が現実的。\n- 商談データや社内情報の資産化という価値は、診察音声のカルテ化とも同じ発想で、世の中の流れに合っている。\n\n##### 市場検証・自治体展開\n\n- 既に複数社へ資料を見せており、「これあったらいいね」「早く作ってくれ」という反応を得ている。\n- 企業側には、個人レベルでAI利用が広がる一方で、会社として取り締まりが必要になるという課題認識がある。\n- 自治体展開では、一度導入して RFI（情報提供依頼）を握れれば、RFP を自社システムが通りやすい仕様に寄せ、半永続的な契約につなげられる可能性がある。\n- 共通コンポーネントを作り、枝葉部分を個別カスタマイズすることで、企業・自治体ともに抜けにくい状態を作る。\n\n#### 小中さんの医療カルテ生成支援システム\n\n- 小中さんが右腕として入っている pipon 社のサービス。\n- 診察音声を録音し、独自開発の音声処理基盤で無音検知・フィラー排除などを最適化したうえで、SOAP形式のカルテとして出力する。\n- 医師のカルテ記入時間を削減し、診察効率を上げ、対応可能患者数の増加とクリニック売上向上につなげる。\n- 小中さんが全案件を仕切っており、受注率は高い。\n- オンライン診療や電話応答の簡易診断にも応用可能性がある。\n- 次廣は、院長夫妻と関係が深い田舎のクリニックへ紹介する。\n\n#### BNI用1to1管理システム\n\n- 1to1を実施しても互いに覚えていないことが多く、1時間の時間投資に対してリファラル1件程度は考えないと割に合わない、という課題から開発。\n- Zoom文字起こしを自動取得し、議事録化する。\n- 過去記録から「この人には誰がおすすめか」を提案できる。\n- チャプターごとにメンバー、ブレイクアウト、会話内容、1to1履歴を記録する。\n- Markdown形式で保存し、ローカルではそのデータをもとに提案内容をまとめている。\n- OpenAI連携でオンライン化を進めており、現状は次廣用に強くカスタマイズされている。\n- 小中さんは商業化の可能性を高く評価。法人向けマッチング会社や営業組織でも、営業マンの肌感・勘所がデータ化されていない課題に転用できる可能性がある。\n\n#### 次廣の技術スキル・受注実績として共有したこと\n\n- システムエンジニア歴26年。\n- BtoBシステムはほぼ全般対応可能。会計システムのみ税法上の問題で未経験。\n- 得意分野は工程管理・現場管理システム。\n- 知らない人たちの大きいプロジェクトに投入され、プロジェクトマネージャーを2年間担当した経験がある。\n- 最近の実績として、松本案件（約200万円＋月額3万円保守）、WebView形式のアプリ開発（約300万円）、WordPressカスタムプラグインの小規模対応などを共有。\n- SES的な人月売りより、委託開発での受注を希望。ピンポイント相談は気軽に受ける姿勢。\n\n#### その他の議論\n\n- BNIのコネクト未入力問題は、期日を守らない行動として信頼低下につながる。\n- ウェブマスター業務の負担が大きく、定例会中にスレッド対応で内容を聞けていない問題がある。\n- スライド送りの自動化は、台本・キーワード検知で可能性はあるが、リアルタイム性や話すスピード差が課題。\n- 次廣も小中さんも、常に効率化を考えるタイプ。AIによって頭の中のアイデアを音声入力だけで形にできる、技術者にとって良い時代になったという認識で一致。\n\n#### アクションアイテム\n\n- 次廣: アルシルブの骨組みを固め、小中さんと具体的な協業検討に入る。\n- 次廣: 田舎のクリニック院長夫妻に、小中さんのカルテ生成支援システムを紹介する。\n- 次廣: BNI用1to1管理システムを、誰でも使える形に改良する。\n- 小中さん: pipon で受けきれない開発案件があれば次廣に相談する。\n- 小中さん: 単発の開発案件があれば次廣に相談する。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 小中さんは、AIを「ツールの知識」だけでなく、業務設計・事業推進・マネジメントの文脈に翻訳できる。\n- DragonFly 内の評価は、わかりやすさ、行動量、裏側での実務力、ポジティブな場づくりに集中している。\n- 月額1,000円の情報配信は入口商品として紹介しやすい。一方で、収益目標のMRR150万には、配信だけでなく研修・顧問・業務改善・プロダクトの接続が重要。\n- 次廣とは領域が近いが、実際には **小中さん: AI研修・業務棚卸し・医療AI/開発事業化支援、次廣: 現場業務のシステム化・プロダクト開発・受託開発** で補完関係を作れる。\n- アルシルブは、AIツール導入ではなく「社内情報の資産化」「シャドーAI対策」「業務フロントの裏でAIが動く仕組み」として説明する方が伝わりやすい。\n- BNI用1to1管理システムは、BNI内だけでなく、法人向けマッチング・営業組織・紹介事業者の「肌感のデータ化」に展開できる可能性がある。\n- 医療カルテ生成支援は、次廣側のクリニック人脈にすぐ紹介できる具体商材。小中さんとの相互リファーラル初手として優先度が高い。\n\n---\n\n## ■ tugiloとしての戦略\n\n### こちらから紹介しやすい相手\n\n- AIに興味はあるが、ChatGPTを触った程度で止まっている経営者\n- Excel・日報・営業管理が属人化しており、まずAI活用や業務棚卸しから入りたい会社\n- 社内マネージャーのAIリテラシー・生産性を上げたい経営者\n- 医療機関で、カルテ・記録・問診・事務作業の効率化に関心がある院長・事務長\n- システム開発前に、AI活用の選択肢や現場教育を整理したい会社\n\n### 小中さんに相談したい相手\n\n- マーケティング・MEO・資金調達・バックグラウンドチェック・賃料削減など、次廣の顧客に補完価値がありそうな専門家\n- AI研修とシステム化を組み合わせた提案に関心がある企業\n- Claude Code / Cursor / AIエージェント活用を、非エンジニア・経営者向けに広げたい案件\n\n### 協業仮説\n\n- **研修→開発:** 小中さんがAI研修・業務棚卸しを担当し、実装が必要になった部分を tugilo がシステム化する。\n- **開発→研修:** tugilo が業務アプリやLINE連携を納品し、社内定着・AI活用研修を小中さんが担当する。\n- **共同提案:** 医療・営業管理・人材育成領域で、AI活用研修＋業務改善システムのパッケージを作る。\n- **補助金連携:** AI業務改善補助金・IT導入補助金・自治体助成金などを使い、研修／業務棚卸し／開発／運用定着を一体化した導入計画として提案できるか確認する。\n- **アルシルブ事業化:** 次廣が骨組みを固めた後、小中さんがAI研修・業務棚卸し・補助金活用・事業化支援の観点で入る。\n- **医療カルテ生成支援の紹介:** 次廣のクリニック人脈に、小中さん/piponのカルテ生成支援システムを紹介する。\n- **受託開発連携:** 小中さん側で受けきれない開発案件を次廣に相談。営業フィーは20〜30%を想定。\n- **BNI内教育連携:** DragonFly の教育・メインプレゼン・ウィークリー改善で、AI活用の具体例を相互に引用し合う。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 小中さんを紹介する一言\n\n> AIを単なる流行りのツールではなく、現場の業務改善や生産性向上に落とし込んでくれる人がいます。技術者出身でCOO経験もあるので、経営と現場の両方の言葉で話せる方です。\n\n### 月額1,000円配信用の一言\n\n> AIの情報が早すぎて追いきれない経営者向けに、月額1,000円で最新ツールや使い方をわかりやすく教えてくれる方がいます。まず情報収集の外注先として紹介できます。\n\n### 業務効率化支援用の一言\n\n> 営業管理や日報、Excel運用が重くなっている会社に、AIを活用した業務効率化を業務目線で支援できる方がいます。いきなり大きな開発ではなく、現場の整理から相談できます。\n\n### 補助金連携用の一言\n\n> AIを使った業務改善をしたいけれど予算がネックになっている会社に、補助金や助成金も視野に入れながら、研修・業務整理・システム化まで段階的に相談できる方がいます。\n\n### 医療向けの一言\n\n> クリニックや診療所向けに、AIを活用したカルテ生成支援や事務作業効率化の相談ができる方がいます。院長や事務長が記録業務に課題を感じていたら、一度話を聞いてみる価値があります。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- DragonFly では、リーダーシップ・教育・明るさ・実務力の信頼が非常に高い。\n- AI領域で近い存在なので、1to1では遠慮せず「どう棲み分けるとお互い紹介しやすいか」を聞く。\n- 家族観・人生観が強く、「誰と一緒にいるか」を大切にするタイプ。案件の条件も単価だけでなく、相手との相性・価値観が重要そう。\n- ハモネプ・ボイパ・昭和歌謡・ガジェットなど、雑談の入口が多い。関係構築はしやすい。','2026-05-30 13:35:23','2026-06-04 10:53:02'),
(39,1,37,51,NULL,'89001802997',NULL,'zoom','2026-06-01 16:00:00',NULL,NULL,'canceled','target_convenience',NULL,'2026-06-04 10:54:33',NULL,'2026-05-30 13:35:23','2026-06-04 10:54:33'),
(40,1,37,140,NULL,'83714290448','i4hQDaQNQeCR0Rc2oz4Yqw==','zoom','2026-06-01 17:00:00','2026-06-01 17:00:00','2026-06-01 18:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_terada_tifonet_engineer_collaboration.md】\n\n# 1to1_寺田直史_Tifonet\n\n---\n\n**文書の位置づけ:** 西浦さんのお繋ぎで実施した、BNI Tifonet（ティフォーネット）チャプター・寺田直史さんとの初回121記録。  \n**整理:** tugilo（次廣 淳）× **BNI Tifonet** クロスチャプター。寺田さんが運営する株式会社ハーベストのSES事業（90%還元＋ボーナス）と、tugilo のAI業務改善・システム開発・開発体制づくりの協業可能性を確認した。  \n**日時:** 第1回 **2026-06-01（月）JST 17:00–18:00** 実施済み。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **40**。\n\n---\n\n## ■ 基本プロフィール（現時点）\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 寺田 直史（読み TODO） |\n| **表記ゆれ** | Zoom要約内に「寺田 直行」表記あり。正式表記は要確認 |\n| **所属チャプター** | BNI Tifonet（ティフォーネット） |\n| **会社名・屋号** | 株式会社ハーベスト |\n| **肩書** | 代表 |\n| **カテゴリー** | リフォームリノベーションから人工芝施工卸へ変更予定（Zoom要約ベース） |\n| **紹介者** | 西浦さん |\n| **主な事業** | SES（フリーランスエンジニアマッチング）、Web広告代理、HP制作、人工芝施工販売、フォトスタジオ、人材紹介、外構工事 |\n| **次廣との接点** | AI業務改善、システム開発、SESエンジニア活用、要件定義・実装の分担、法人フロント協力 |\n\n### 西浦さんからの紹介文\n\n> ティフォーネットチャプターの寺田さんをお繋ぎします✨  \n> エンジニアを集めた事業で協業の可能性もあります☺️是非お話ししてみてください🙌\n\n---\n\n## ■ 初回121の目的\n\n1. 寺田直史さんの事業内容を正確に理解する。\n2. 「エンジニアを集めた事業」が、採用・SES・受託開発・教育・コミュニティ・案件マッチングのどれに近いか確認する。\n3. tugilo のAI業務改善・業務システム構築と、どこで協業できるか見極める。\n4. 相互に紹介しやすい顧客像・案件像・NG条件を確認する。\n\n---\n\n## ■ 協業仮説\n\n### 1. tugilo案件の開発体制補完\n\n- tugilo が要件整理・業務改善設計・顧客折衝を担い、寺田直史さん側のエンジニア体制と組む。\n- 小規模開発、既存システム改修、AI連携、業務自動化などで役割分担できる可能性がある。\n- 確認したい点: 対応可能な技術領域、単価感、契約形態、品質管理、PM/PLの有無。\n\n### 2. 寺田直史さん側案件へのAI・業務改善補完\n\n- 寺田直史さん側で開発人材はいるが、顧客の業務整理・AI活用設計・提案書化が必要な案件にtugiloが入る。\n- 補助金・助成金・業務棚卸し・プロトタイプ作成などの入口を作れる可能性がある。\n- 確認したい点: 現在多い相談、顧客層、提案前に詰まりやすい箇所。\n\n### 3. エンジニア人材・案件の相互紹介\n\n- tugiloに来た「開発リソースが必要な案件」を寺田直史さんへ相談する。\n- 寺田直史さんに来た「業務改善・AI活用・上流整理が必要な案件」をtugiloへ相談してもらう。\n- 確認したい点: 紹介料・営業フィー・再委託・共同提案時の名義。\n\n---\n\n## ■ 60分の会話設計\n\n### 0〜10分: 関係づくり・紹介経緯\n\n- 西浦さんから「エンジニアを集めた事業で協業可能性がありそう」と伺ったことを共有する。\n- Tifonetチャプターでの活動状況、BNIでの紹介の出し方を聞く。\n\n### 10〜30分: 寺田直史さんの事業理解\n\n- どんなエンジニアを、どのように集めているか。\n- 顧客は誰か。企業の開発部門、経営者、SIer、スタートアップ、個人事業主など。\n- 収益モデルは、紹介・SES・受託・教育・コミュニティ・採用支援のどれに近いか。\n- いま一番増やしたい案件・紹介してほしい人は誰か。\n\n### 30〜45分: tugilo側の共有\n\n- tugiloは「現場業務を整理して、小さく使える業務システム・AI活用に落とす」立ち位置であることを説明する。\n- 建設業LINE日報、予約管理、BNI/コミュニティ向け管理、既存業務システム改善などの例を短く共有する。\n- 開発だけではなく、要件整理・プロトタイプ・運用定着まで含めて相談されることを伝える。\n\n### 45〜55分: 協業条件の確認\n\n- 共同提案できる案件の条件。\n- 案件を紹介する際に最低限ほしい情報。\n- 紹介料・営業フィー・契約主体・守秘の考え方。\n- お互いに紹介しないほうがよい案件。\n\n### 55〜60分: 次アクション\n\n- 具体的な紹介候補・相談候補があるか確認する。\n- 必要なら、2回目121または三者面談の候補を決める。\n\n---\n\n## ■ 今日聞きたい質問\n\n### 事業理解\n\n- 「エンジニアを集めた事業」とは、具体的にはどんなモデルですか？\n- 集めているエンジニアは、社員・業務委託・副業・コミュニティのどれに近いですか？\n- 得意な技術領域、苦手な領域はありますか？\n- 今、一番増やしたい案件はどんな案件ですか？\n\n### 協業可能性\n\n- 要件整理や顧客折衝は寺田直史さん側で担いますか、それとも外部と組む形ですか？\n- AI活用・業務改善・既存システム改善の相談はありますか？\n- tugiloが上流整理や提案書を担当し、寺田直史さん側が開発体制を担当する形はあり得ますか？\n- 案件紹介時のフィーや契約形態は、どのように考えるのが自然ですか？\n\n### リファーラル化\n\n- 寺田直史さんを紹介するとき、どんな人に何と言えば伝わりやすいですか？\n- 「こういう案件は紹介しないでほしい」という条件はありますか？\n- 逆に、tugiloへ紹介しやすそうな相談はありますか？\n\n---\n\n## ■ 次廣からの短い自己紹介\n\n> 私は tugilo として、現場の業務を整理して、LINE日報・予約管理・顧客管理・既存システム改善・AI活用など、実際に使える小さなシステムに落とし込む支援をしています。  \n> 最近は、AIで何かしたいという相談を、いきなり開発にせず、まず業務のどこを楽にするか整理して、プロトタイプや運用までつなげる仕事が多いです。  \n> 西浦さんから、寺田直史さんはエンジニアを集めた事業をされていると伺ったので、開発体制や案件の入口で協業できるところがあるか、今日はぜひ知りたいです。\n\n---\n\n## ■ 第1回 Zoom 要約反映（実施後記録）\n\n### 【第1回】2026-06-01\n\n#### 基本情報\n\n- **日時:** 2026-06-01（月）JST 17:00-18:00\n- **実施方法:** Zoom（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id = 40`\n- **紹介者:** 西浦さん\n- **相手:** 寺田直史さん（株式会社ハーベスト／BNI Tifonet）\n\n#### ■ 概要\n\n- 次廣と株式会社ハーベストの寺田さんが初回121を行い、システム開発・SES・AI業務改善領域での協業可能性を確認した。\n- 寺田さんのSES事業は、エンジニアへの **90%還元＋ボーナス** を特徴とし、多重下請けで大きく中抜きされる業界構造への問題意識から立ち上げられている。\n- 次廣は、知人エンジニア紹介、キャパシティ超過時のSES活用、アイビーコミュニケーションズ（要表記確認）藤井氏への紹介、法人格が必要な案件でのフロント企業協力について前向きに合意した。\n\n#### ■ 決定事項・合意内容\n\n- **エンジニア紹介:** 次廣が知人エンジニアを寺田さんのSES事業へ紹介する。紹介者には、稼働開始後1ヶ月分の利益を還元する仕組みがある。\n- **案件の相互協力:** 次廣が受注した案件で自分のキャパシティを超える場合、寺田さんのSESエンジニア活用を検討する。\n- **要件定義と実装の分担:** 寺田さんのチャプター内にいる経験20数年・AI活用エンジニアが要件定義を担い、次廣または寺田さん側エンジニアが実装するパワーチーム構想を検討する。\n- **アイビーコミュニケーションズ紹介:** 次廣が名古屋のアイビーコミュニケーションズ藤井氏（BNI ワンスポンス所属、表記要確認）を寺田さんへ紹介し、一次受け案件の獲得機会を作る。\n- **フロント企業協力:** 大手クライアントとの契約で法人格が必要な場合、寺田さんの会社がフロント企業となり、次廣が実装を担当する形も検討する。\n- **AI関連相談:** 寺田さん側にAI関連案件が来た場合、次廣へ相談する。\n\n#### ■ 寺田さん・株式会社ハーベストの事業理解\n\n- **会社名:** 株式会社ハーベスト\n- **代表:** 寺田さん（正式表記は要確認。ユーザー提供では寺田直史、Zoom要約では寺田直行表記あり）\n- **体制:** 社員11名、アルバイト11名、常用業務委託10〜12名、合計32〜33名規模。\n- **事業内容:** フリーランスエンジニアのマッチング、Web広告代理、ホームページ制作、人工芝施工販売、フォトスタジオ運営、人材紹介、外構工事。\n- **SESモデル:** 還元率90%＋ボーナス。一般的なSES会社が30〜40%抜く構造に対し、ハーベスト側の利益を8%程度に抑え、エンジニアへ還元する。\n- **成長戦略:** 広告費を大きく使わず、エンジニア紹介者へ稼働1ヶ月分の利益を還元して紹介ベースで広げる。\n- **現状課題:** 立ち上げ1年半で稼働中エンジニアは1名。フリーランス中心のため案件終了時に離脱しやすく、継続案件・一次受け案件の確保が課題。\n- **今後:** フリーランスだけでは限界があるため、正社員採用も進める。正社員の場合は還元率80%想定。\n\n#### ■ 次廣側の共有内容\n\n- **事業名:** tugilo / 次廣のAI業務改善システム構築。要約内では「次色」「レギロ」表記があるが、正式なプロダクト名は Religo、屋号・事業名は tugilo として要整理。\n- **強み:** 現場のワークフローを大きく変えず、手間を減らすゼロベース開発。小さく始め、段階的に改善する伴走型。\n- **AI駆動開発:** 3年前からAIと協業し、コーディングの大部分をAIに任せることで開発効率を高めている。\n- **主な実績:** 全国200店舗規模のフランチャイズ本部システム、名古屋の防水工事業向けLINE日報・工程管理、静岡中部観光協会の周遊イベント、動物病院のLINE予約管理など。\n- **価格戦略:** 工数見積もりから、ROIや年間効率化効果を示す価値ベース見積もりへ転換。営業手数料は最終見積もりに対して20%上乗せまでを許容し、それ以上は受けない方針。\n\n#### ■ 共通認識・業界観\n\n- AI駆動開発により、単純な工数見積もりや多重下請け構造は今後厳しくなる。\n- 経験者がAIを使う開発と、未経験者がAIを使う開発では品質に大きな差が出る。\n- クライアント側も、AIでモックや要件を具体化できるようになり、システム会社・SES会社への見方が変わっていく。\n- システム業界の多重下請け構造は建設業に近く、クライアントが中抜き構造の無駄に気づくタイミングが来る。\n\n#### ■ BNI・カテゴリー戦略メモ\n\n- 次廣は「システム構築」だけではBNI内で紹介ハードルが高く、個人事業主に伝わりやすいフロント商材として予約管理システムを準備している。\n- 寺田さんは、リフォームリノベーションから人工芝施工卸へカテゴリー変更予定。BNIでまず成功体験を作るため、慣れている人工芝に寄せる戦略。\n- 寺田さんは「人に物を売るのは得意ではない」と認識しており、協業を軸にした戦略に振り切る意向。\n\n#### ■ 保留事項・要確認事項\n\n- 寺田さんの正式氏名表記: ユーザー提供は「寺田直史」、Zoom要約内は「寺田直行」。名刺・BNIプロフィールで確認する。\n- アイビーコミュニケーションズの正式社名表記と、藤井氏との初回面談日程。\n- 次廣が紹介できるエンジニアの人数・年齢層・稼働条件。\n- 大元クライアントを紹介してもらった場合の紹介料・営業フィー設定。\n- 寺田さんのチャプター内エンジニアとのパワーチーム構想の進捗。\n- 次廣の予約管理システムのリリース時期（夏予定）。\n\n#### アクションアイテム\n\n##### ▼ 寺田直史さん\n\n- パワーチーム構想の提案資料を作成し、営業活動を開始する。\n- AI関連案件が来た場合、次廣に相談する。\n\n##### ▼ 自分（次廣）\n\n- 知人エンジニア数名を寺田さんへ紹介する。\n- 10年前にフリーランスエンジニア事業化の相談を受けた人物に連絡し、寺田さんへ紹介できるか確認する。\n- アイビーコミュニケーションズ藤井氏に寺田さんを紹介し、一次受け案件の獲得機会を作る。\n- 自分のキャパシティを超える開発案件が出た場合、寺田さん側SESエンジニア活用を検討する。\n\n##### ▼ 両者\n\n- 今後の案件で協業機会があれば相互に相談する。','2026-05-30 13:35:23','2026-06-04 10:53:02'),
(41,1,37,27,NULL,'89109217407','9Wcixbz/Tiyj6ubYB4XquA==','zoom','2026-06-03 15:00:00','2026-06-03 15:00:00','2026-06-03 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_yamamoto_yoko_idemitsu_credit.md】\n\n# 1to1_山本葉子_出光クレジット\n\n---\n\n**文書の位置づけ:** DragonFly メンバー・山本葉子さんとの 1to1 を **1ファイルで時系列管理**する。プロフィールシート／ONE to ONE シート／G.A.I.N.S.、第1回 Zoom 要約（校正済み）、**動物病院×予約システムの共同営業**合意を統合。  \n**整理:** tugilo（次廣 淳）× **BNI DragonFly** 同チャプター。  \n**日時:** 第1回 **2026-06-03（火）JST 15:00–16:00** 実施済み（終了時刻 **TODO**）。**おかわり121** を実施予定（葉子さんの事業ヒアリング中心）。  \n**次の対面:** **2026-06-06** リージョンフォーラム（対面）→ その後 **藤枝** でシステムデモ付き詳細打ち合わせ（日程 **TODO**）。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **41**。\n\n**同姓「山本」メンバーとの区別（誤紹介防止）**\n\n| 氏名 | カテゴリー | 備考 |\n|------|------------|------|\n| **山本 葉子**（本件） | ビジネス特化型クレジットカード | 出光クレジット／静岡在住・東京勤務 |\n| 山本 洸太 | デザインに強い WEB 制作 | IT。スリーバイス原稿の「山本さん」はこちらの文脈が多い |\n| 山本 三那子 | 相続・遺言特化型行政書士 | ビジホス・BOD 等（旧メンバー表） |\n| チャプター表記「山本（トレーニング）」 | — | サポート役。葉子さんとは別人の可能性が高い（要確認しない） |\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ユーザー提供のプロフィールシート・ONE to ONE シート・G.A.I.N.S. ベース。原資料の「ローマ字」欄は **静岡県** と記載されていたため、住所/出身系の誤入力として扱い、ローマ字表記は **TODO**。\n\n### 人物・会社\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 山本　葉子（やまもと　ようこ） |\n| **出身・居住** | 出身: 静岡県静岡市／居住: 静岡県静岡市（居住年数 **29年**） |\n| **勤務地** | 東京都中央区新富（出光クレジット本社ビル 7F） |\n| **家族** | ひとつ年下の夫、長女（27歳・嫁ぎ済）、次女（24歳・一人暮らし）、義母 |\n| **ペット** | — |\n| **趣味** | スポーツ観戦。**プロ野球はオリックス推し**、**紅林弘太郎選手推し** |\n| **関心事** | **多肉植物**を育てて増やすこと |\n| **強い願望** | 様々な場で知り合った方たちと公私ともに仲良くし、人生を楽しむ |\n| **誰も知らない私** | テニスの **静岡県大会で優勝** |\n| **成功の鍵** | **仕事が遊びで、遊びが仕事** |\n\n### 事業・役職\n\n| 項目 | 内容 |\n|------|------|\n| **会社名** | 出光クレジット株式会社 |\n| **肩書・部署** | 営業開発部　**PREMIUM CARDグループ** |\n| **専門分野** | ビジネス特化型クレジットカード |\n| **経験年数** | 現在のビジネス **10年**（一貫してクレジットカード業） |\n| **過去経験** | ずっとクレジットカードに携わっている |\n| **BNI** | DragonFly／BNI役職（シート上は空欄）／入会（宣誓式）**2026-04-14** |\n| **連絡先** | 070-4148-1049 ／ yoko.yamamoto.6200@idemitsu.com |\n| **所在地（会社）** | 〒104-0041 東京都中央区新富1-18-8　RBM築地スクエア　7F |\n\n---\n\n## ■ 事業理解（出光クレジット／ビジネスカード）\n\n### 何を提供しているか\n\n- **ビジネス特化型クレジットカード**の提案・入会支援・利用サポート。\n- 事業者がカードを **事業に活用できる方法**（経費管理、支払い効率、特典活用など）を伝え、継続利用まで伴走。\n- 顧客獲得の主経路は **既存顧客からの紹介**（シート記載）。\n- **第1回121で判明:** **アメリカン・エキスプレスブランド**（出光クレジット経由）を軸に、**動物病院市場**へ注力。動物用医薬品の仕入れは多くの製薬会社がアメックスのみ対応しており、獣医師にとってメリットが大きい。\n- **静岡県獣医師会の賛助会員**として登録済み。獣医師会名義で飛び込み訪問でも受付を通過しやすく、**これから本格的に動物病院への訪問を開始**する段階（県内東部・西部もカバー）。\n\n### 定量実績（本人申告・G.A.I.N.S.）\n\n| 指標 | 内容 |\n|------|------|\n| 顧客数 | **800名** |\n| 年間取扱高 | **40億円**（再達成が今年度の仕事目標のひとつ） |\n| 営業実績 | **月間獲得数 全国1位**（時期・定義は会で確認） |\n\n### 今年度のビジネス目標（Goal より）\n\n1. **apollostationcard プラチナビジネスカード** の新規利用者を増やす（今年度まず **1件** から、とシート記載）。\n2. **年間取扱高 40億円** をもう一度達成する。\n\n### ONE to ONE シート（第1回後の状態）\n\n| # | 項目 | 状態 |\n|---|------|------|\n| 4 | 他社にない強み | **おかわり121で聞く**（第1回は次廣の話が中心） |\n| 5 | こんな人・会社がお客様 | **一部判明:** 動物病院（アメックス必須の医薬品仕入れ文脈）。直近10業種の共通像は未整理 |\n| 6 | どう話を切り出すか | **たたき台あり:** 「いつも患者さんがいっぱいで忙しいですよね」→ 予約システムの話（動物病院訪問時・チラシ併配） |\n\n### 直近10件の顧客（業種）\n\n| # | 地域 | 業種 |\n|---|------|------|\n| 1 | 静岡県静岡市 | リフォーム会社 |\n| 2 | 大阪府東成区 | OA機器販売店 |\n| 3 | 静岡県静岡市 | OA機器販売店 |\n| 4 | 愛知県名古屋市 | 自動車販売・修理会社 |\n| 5 | 東京都中央区 | コンサルティング会社 |\n| 6 | 愛知県名古屋市 | ビル管理会社 |\n| 7 | 静岡県浜松市 | 生命保険営業マン |\n| 8 | 愛知県名古屋市 | プロ野球選手 |\n| 9 | 静岡県静岡市 | 放課後デイサービス |\n| 10 | — | （空欄） |\n\n**読み取り:** 静岡・愛知・東京に分散。**多店舗・車両・経費が多い業種**（リフォーム、OA、自動車、ビル管理）と **個人事業・士業系**（コンサル、保険営業）が混在。apollostation（燃料）との相性は **自動車・物流・営業車両** で話しやすい可能性。\n\n### Contact Circle Top3\n\n- シート上は **Top3 未記入** → 初回で「紹介を増やしたい業界・地域・人物像」を具体化する。\n\n---\n\n## ■ G.A.I.N.S.\n\n| 区分 | 内容 |\n|------|------|\n| **Goal** | **人と人をつないで皆のお役に立つ**。静岡の街を歩いたら「葉子さーん」と声をかけられる存在に。つながった人と楽しみながら豊かに。**仕事:** apollostationcard プラチナビジネスカード利用者増、年間取扱高40億の再達成 |\n| **Accomplishments** | 顧客800名・年間取扱高40億、月間獲得数全国1位 |\n| **Interests** | 野球観戦（オリックス・紅林選手）、多肉植物 |\n| **Networks** | 静岡市駿河倫理法人会、ビジネスプラザ静岡、全国500人のお客様 |\n| **Skill** | 営業スキルアップの社内講師（「売らずに売れる…」「葉子の部屋」） |\n\n---\n\n## ■ DragonFly 内での履歴（リポジトリ由来）\n\n### 入会・定例参加\n\n| 項目 | 内容 |\n|------|------|\n| 宣誓式 | **2026-04-14**（第205回 CSV にメンバー登録） |\n| 参加記録 | 第206回（4/21）〜第210回（6/2）の参加者 CSV に継続掲載 |\n| カテゴリー | 金融・保険・資金サポート／ビジネス特化型クレジットカード |\n\n### PALMS（2026年5月集計・2026-06-02 レポート）\n\n| 指標 | 葉子さん |\n|------|----------|\n| 出席（出） | 3 |\n| 欠席・遅刻・医療・代理 | 0 |\n| 内与 / 外与 | 2 / 3 |\n| 内受 / 外受 | 0 / 5 |\n| ビ（ビジター関連） | 1 |\n| 1to1（ポイント） | **21.0** |\n| TYFCB（千円） | 2（= 2,000円） |\n| CEU | **11** |\n| 推薦のことば | 0 |\n\n**読み取り:** 入会約2ヶ月で **1to1・CEUは積極的**。リファーラルは **与え・受けともに動きあり**（外受5は他チャプターからの紹介が多い可能性）。TYFCBは控えめ → 信頼構築フェーズか、商材特性上「すぐ金額に乗りにくい」可能性。\n\n### ビジター・ゲストとの接点（紹介者／アテンド）\n\n| 定例会 | 相手 | 役割 |\n|--------|------|------|\n| 第205回（4/14） | 細田光孝（人生ストーリー動画） | アテンド（原田里織・倉持・**山本洸太**と共同） |\n| 第207回（5/12） | 鶴岡江里子（WEB制作） | アテンド |\n| 第208回（5/19） | 松下真紀子（中古介護ベッド）、南部湧祐（コンサル） | **紹介者（P1）** |\n| 第209回（5/26） | 八田奈緒美（骨盤底筋体操） | ゲストのアテンド |\n| 第210回（6/2） | 寺本勲（経営者コンディショニング） | アテンド |\n\n**読み取り:** ビジター紹介・アテンドをこなしており、**「人をつなぐ」Goal と行動が一致**。静岡・東京以外のビジターも紹介しており、全国500名の顧客基盤と整合。\n\n### チャプター定例会メモ\n\n- **2026-05-12 定例会:** 太田一誠さんより、5/12・5/19・5/26 の3週連続ワントゥーミニー案内。**5/19 13:00 は山本葉子さんが開催予定**と記載（コミュニティ内の1to1推進役として動いていた可能性）。\n\n### 他ドキュメントでの言及\n\n- **礒部昌之（探偵・レブリー）1to1:** 保険営業担当者紹介の **周辺候補** として葉子さんが整理（保険そのものではなく、金融・資金まわり）。\n- **次廣スリーバイス1toMany（4/21）:** 「4/14の山本さん」は **ローテーション接続** の文脈。宣誓日と一致するため **葉子さんの入会週プレゼン** の可能性が高いが、同姓の洸太さんと混同しないこと。\n\n---\n\n## ■ サマリー（最新状況）\n\n- 出光クレジットで **10年・顧客800・年商40億・月間獲得全国1位** のビジネスカード専門営業。**動物病院×アメックス** が当面の主戦場。静岡県獣医師会賛助会員。\n- 第1回121（2026-06-03）は **ほぼ次廣の事業説明** が中心。葉子さんは次廣を **温和・気遣い・つなぐ姿勢** と高評価。**おかわり121** で葉子さん側のヒアリングを行う合意。\n- **具体協業:** 動物病院向け **予約システム（名古屋実績・LINE予約）** と、葉子さんの **カード提案＋チラシ同梱配布**、獣医師会ルートでの会員向け配布検討。\n- **次の接点:** **2026-06-06** リージョンフォーラムで対面 → **藤枝** でデモ付き打ち合わせ。次廣は **動物病院向け1枚チラシ** を早急作成。\n\n---\n\n## ■ 初回セッション設計（2026-06-03）\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 初回の感謝、DragonFly同士、今日のゴール合意 |\n| 5〜12分 | 雑談 | 静岡・オリックス・紅林選手・多肉・テニス県大会・「仕事＝遊び」 |\n| 12〜32分 | 葉子さん | ビジネスカード事業、プラチナビジネス、40億・全国1位の背景、理想顧客、紹介の受け方 |\n| 32〜45分 | 次廣 | AI業務改善・経費/請求/案件管理の仕組み化、紹介してほしい相手 |\n| 45〜55分 | 接点探索 | 経費が増える会社のIT化、燃料・車両・多拠点、倫理法人会・静岡ネットワーク |\n| 55〜60分 | クローズ | 紹介文1文、次アクション1〜2件、Religo・本ファイル更新 |\n\n### 初回で聞くこと（チェックリスト）\n\n- [ ] **apollostationcard プラチナビジネスカード** の一番刺さる業種・経費シーン（燃料、ETC、車両、複数カード等）\n- [ ] 「月間獲得全国1位」の **期間・商品・チーム規模**（信頼の根拠として第三者紹介に使えるか）\n- [ ] 年間取扱高40億を **もう一度** 達成するうえでのボトルネック（新規数か単価か継続率か）\n- [ ] 直近顧客10件の **共通する社長の悩み**（経費、キャッシュフロー、支払い、ポイント等）\n- [ ] 紹介以外の獲得チャネルはあるか（倫理法人会、ビジネスプラザ静岡、BNI以外）\n- [ ] **紹介してほしくない** 業種・規模・地域\n- [ ] Contact Circle Top3 を **名前または業種** で埋める\n- [ ] 社内講師「葉子の部屋」は **社外メンバー向け** に展開可能か\n- [ ] 次廣を紹介しやすい顧客像（Excel日報、請求属人化、複数拠点、従業員カード管理等）\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n### 1. オープニング\n\n> 「山本さん、本日はお時間ありがとうございます。DragonFly の次廣です。\n> 今日は初回なので、葉子さんのお仕事をしっかり理解して、僕が誰にどう紹介できるかを言葉にしたいです。\n> 後半で私の業務改善・システム化の話も短くします。葉子さんから見て『こういう人なら合いそう』という視点で聞いていただけるとうれしいです。\n> まず葉子さんの事業を中心に、最後に相互紹介の条件を確認する流れでよいですか？」\n\n### 1.5 雑談（信頼づくり）\n\n> 「プロフィールを拝見して、静岡で29年、オリックスと紅林選手推し、多肉植物、テニスで静岡県大会優勝、『仕事が遊びで遊びが仕事』というのが、すごく一貫したお人柄だなと感じました。\n> 目標に『街を歩いたら葉子さーん』とあるのも印象的です。いま DragonFly と静岡の活動、どちらにエネルギーを多く使っていますか？」\n\n### 2. 前半：葉子さんの事業紹介〜質疑応答\n\n> 「出光クレジットさんで、ビジネス特化型クレジットカードを専門に10年、顧客800名・年間取扱高40億、月間獲得全国1位と、数字で信頼感がありますね。\n> 第三者に紹介するとき、まず **『事業者の経費と支払いを、ビジネスカードで整理・活用できる出光クレジットの山本さん』** という言い方で大きくズレはないですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n- 「今年度の **プラチナビジネスカード** は、どんな会社に一番『これだ』と言えますか？ 燃料・車両・複数拠点・カード枚数など。」\n- 「顧客の多くが **紹介** とのことですが、紹介が起きやすい **きっかけ**（困りごと・タイミング）は何ですか？」\n- 「直近のお客様に、リフォーム・OA・自動車・ビル管理・デイサービスなど幅がありますが、**共通する社長像** はありますか？」\n- 「全国500名のお客様のうち、DragonFly や静岡のネットワークで **まだつながっていない業種** はどこですか？」\n- 「保険営業の方が顧客に入っていますが、士業・コンサル・店舗経営と **セットで話しやすい** 領域はありますか？」\n\n### 3. 後半：次廣の事業紹介〜接点探索\n\n> 「私は、Excelや紙、LINE、メールでばらばらになっている業務を整理して、現場に合わせて小さくシステム化する仕事をしています。\n> カードや経費が増えるほど、**請求・案件・日報・承認** が属人化している会社に入ることが多いです。」\n\n**葉子さん向けに刺さりそうな接点**\n\n- **経費・支払いが増えた先の業務:** カード導入後に、請求処理・経理連携・拠点別集計が追いつかない中小。\n- **多拠点・車両・営業職:** リフォーム、OA、自動車、ビル管理など、葉子さんの直近顧客と次廣のIT化ターゲットが重なる。\n- **紹介の質:** 葉子さんの「紹介で来た顧客」に、次廣が **業務の仕組み** を足すと、カード継続利用率・満足度向上につながるストーリー。\n- **倫理法人会・静岡:** 次廣の静岡・建設・製造系の案件と、葉子さんの静岡顧客基盤の **情報交換**（即紹介でなくてよい）。\n\n**相手に聞いてもらう質問**\n\n> 「葉子さんから見て、私の仕事はどんな方に紹介しやすそうですか？ 例えば、カードは入れたが **経理・請求・案件管理が Excel のまま** の会社は合いそうでしょうか？」\n\n### 4. クロージング\n\n> 「今日の話を受けて、葉子さんを紹介するときの一言と、私から当たりやすい紹介候補を整理します。\n> 葉子さんの全国500名のお客様のうち、ITや業務整理で困っていそうな方がいれば、無理のない範囲で教えてください。\n> まずは1件でも、紹介しやすい条件を具体化できたらうれしいです。」\n\n---\n\n## ■ 協業設計（動物病院ルート）— 第1回合意\n\n### なぜ今つながるか\n\n| 葉子さん側 | 次廣側 |\n|------------|--------|\n| 動物病院訪問をこれから本格化 | 名古屋の動物病院（獣医3名）で **LINE予約** を5年運用、他院推奨の意向あり |\n| 獣医師会賛助会員で入口が開いている | コロナ期の補助金で導入コストを抑えた実績あり |\n| カード提案が自然な入口商材 | BNI向け **低ハードルの入口**（チラシ＋概要説明）として位置づけ可能 |\n\n### 連携の型\n\n1. **入口:** 葉子さんが動物病院へアメックス／ビジネスカードを提案する訪問時、次廣の **予約システム1枚チラシ** を同時配布。\n2. **会話:** 「いつも患者さんがいっぱいで忙しいですよね」→ 並び・電話負担 → 予約システムの話題。\n3. **拡大:** 静岡県獣医師会事務局の承認が得られれば、**会員向けチラシ配布**。\n4. **クローズ:** 興味のある病院を葉子さんから次廣へ紹介。詳細・デモは次廣が担当。\n\n### 次廣のチラシ要件（合意）\n\n- **1枚**・葉子さんが **概要説明できる** レベル（詳細は次廣へつなぐ）。\n- 名古屋導入病院からの **推奨コメント** 掲載を検討。\n- **早急に作成**（葉子さんの訪問開始前）。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 葉子さんを **「カードを売る人」＋「静岡・動物病院ルートの営業パートナー」** と捉える。獣医師会・県内東西の訪問網は、次廣の静岡案件（藤枝拠点）と地理的に相性が良い。\n- 第1回は **信頼構築と次廣のV（Visibility）** が主成果。おかわり121で **G.A.I.N.S.の事業面・紹介条件** を必ず回収する。\n- BNI向けは **システム開発単体ではなくチラシ＋予約システム** をフロント商材に。バックエンドは従来どおり業務改善・FC管理・日報等。\n- 葉子さんの **倫理法人会・ビジネスプラザ静岡・全国500名** は、動物病院以外の横展開用に温存。税理士・コンサルは **間接リファーラル源**（第1回で次廣が言及）。\n- **6/6 RF → 藤枝デモ** で「つなぐ」屋号の実物（システム）を見せ、葉子さんの紹介精度を上げる。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣 → 葉子さんへ紹介しやすい相手\n\n| 優先 | 像 | 理由 |\n|:---:|-----|------|\n| ★ | **経費・燃料・車両・営業車が多い** 中小（建設、リフォーム、配送、営業代行） | プラチナビジネス・apollostation との相性 |\n| ★ | **複数拠点・従業員カード** を検討中の法人（10〜50名規模） | 取扱高・継続利用につながりやすい |\n| ○ | **キャッシュフロー・支払い条件** を整理したい社長 | カード＋資金効率の話 |\n| ○ | **新規事業・店舗展開** で支出が増える会社 | 導入タイミングが明確 |\n| △ | 個人カードのまま経費混在の **一人社長** | 単価は小さいが件数は多い可能性 |\n\n**第三者紹介の短い言い方（たたき台・会後に確定）**\n\n> 山本さんは、出光クレジットでビジネス特化型クレジットカードを扱っている DragonFly メンバーです。事業者の経費や支払いをカードで整理し、利用方法から継続サポートまで伴走されます。顧客紹介が中心で、静岡を中心に全国500名のお客様基盤があります。リフォーム、OA、自動車、店舗・サービス業など、経費が増えている会社の社長に合いそうです。\n\n### 葉子さん → 次廣へ紹介してもらいやすい相手\n\n| 優先 | 像 | きっかけ |\n|:---:|-----|----------|\n| ★ | **動物病院**（待ち時間・電話予約負担が大きい） | 第1回合意。チラシ反応・獣医師会ルート |\n| ★ | 二重入力・Excel限界・業務フロー散乱の **中小** | 次廣の標準ターゲット（第1回共有） |\n| ○ | 税理士・コンサル・WEBデザイナーの **顧問先** | 間接リファーラル源 |\n\n- 倫理法人会・ビジネスプラザ静岡のつながりで **IT・業務改善** の相談が出そうな経営者（おかわりで深掘り）\n\n### DragonFly 内の接続候補（初回後に精査）\n\n| メンバー | カテゴリー | 接続の文脈 |\n|----------|------------|------------|\n| 海沼功 | 企業型確定拠出年金 | 法人の福利厚生・資金まわり |\n| 紀川和弘 / 竹内駿太 | 損保・生命保険 | 法人リスク・社長の相談導線（礒部さん紹介文脈と別軸） |\n| 藤本勇輝 | 税金アドバイザー | 経費・法人化・カード運用の税務側 |\n| 小中貴晃 | AI・業務効率化 | 営業組織・研修顧客へのIT補完 |\n| 権堂千栄実 | 人材育成・業務改善 | 現場・マネジメント＋経費増加企業 |\n| 原田里織 | LEDサイネージ | 店舗投資・経費増（紹介の文脈確認） |\n| 西岡優希 / 御手洗（風土テック） | 建設・人材 | 静岡・建設系顧客との重なり |\n\n**同姓注意:** 紹介依頼時は必ず **「出光クレジットの山本葉子さん」** とフルネーム＋会社で伝える。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **トーン:** 「葉子さーん」志向＝**親しみ・公私一体化** を大切にする。堅い金融営業トークより、野球・植物・静岡の話で距離が縮まりやすい。\n- **第1回後の葉子さん評価（要約）:** 次廣の **温和さ・細やかな気遣い**（「ご査収ください」、パンケーキの話題等）、**技術の中の人への思い** を評価。心が和む雰囲気。\n- **次廣の信念（第1回共有）:** 「頑張っている人が損する世界は嫌」— 人の頑張りで回している業務を改善したい。外部だから提案しやすいが **関係構築が前提**。\n- **BNI 活動:** 葉子さんは4月入会（次廣の約1ヶ月後）。次廣は **2026年3月** ゲスト経由入会（増本紹介）。BNIに合わせた **入口商材** の必要性を認識。\n- **おかわり121:** 第1回で葉子さんの話が十分に出ていないため、**事業・強み・理想顧客・切り出しトーク** を中心に再設計する。\n\n---\n\n## ■ おかわり121 設計（未実施）\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | 振り返り | 第1回の感謝。「前回は僕の話が多かったので、今日は葉子さん中心で」 |\n| 5〜35分 | 葉子さん | 強み・理想顧客・切り出しトーク・動物病院以外の注力・Contact Circle Top3 |\n| 35〜45分 | 次廣（短く） | チラシドラフト共有・獣医師会配布の進捗 |\n| 45〜55分 | 6/6・藤枝 | RFでの話題、デモで見せる画面の期待値 |\n| 55〜60分 | クローズ | 紹介文確定・次アクション |\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-06-03 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-03（火）JST 15:00–16:00**\n- **実施方法:** Zoom（要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **41**\n- **セッションの性格:** **ほぼ次廣の話を聞いていただく形**。葉子さんの事業深掘りは不足 → **おかわり121** を合意。\n\n#### 主な成果\n\n- 次廣（システムエンジニア・**藤枝在住**）と葉子さんの初回1to1で、**動物病院向け予約システム** に関する具体的な連携機会を特定。\n- 葉子さんが **静岡県獣医師会賛助会員** として動物病院へアプローチを始めるタイミングと、次廣の **名古屋動物病院でのLINE予約実績**（約5年運用・他院推奨意向）が合致。\n- **相互紹介＋チラシ配布** による共同営業の方向で合意。\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| チラシ作成 | 次廣が動物病院向けシステムの **1枚チラシ** を早急に作成（葉子さんが概要説明できるレベル） |\n| 共同営業 | 葉子さんが動物病院へカード提案訪問する際、次廣のチラシを **同時配布** |\n| 獣医師会ルート | 静岡県獣医師会事務局の承認を得て、会員向けチラシ配布を **検討** |\n| 対面・デモ | **2026-06-06** リージョンフォーラムで対面 → その後 **藤枝** でシステムデモ付き詳細打ち合わせ |\n| おかわり121 | 葉子さんの事業・紹介条件を改めてヒアリング |\n\n#### 次廣側の共有（要約・第1回）\n\n**経歴・スタンス**\n\n- SE歴 **26年**、AI活用 **3年目**。文系（フランス語）出身、90年代後半からHP制作経由でIT。30歳で独立し静岡へ、**23年間** 個人事業（屋号 **次廣＝名前＋エスペラント「つなぐ」**）。\n- 強みは **現場に合わせた伴走型**（紙→タブレット、最小機能から段階拡張、属人化解消）。コミュニケーション・要件整理が得意。\n\n**主要実績（話した事例）**\n\n| # | 案件 | 要点 |\n|---|------|------|\n| 1 | 増本氏関連・外壁ブロックFC | 全国200施工店、Googleフォーム+スプレッドシート→一元化、効率60–70%改善、500店舗まで拡大の土台 |\n| 2 | 名古屋・防水工事 | 外国人労働者多め、LINE日報、集計・請求・給与計算連携 |\n| 3 | 駿河企画観光局 | 「どうする家康」周遊スタンプラリー（LINE）、4–5年継続。**新シーズンは2026年7月開始予定**（要約の年表記は2026に校正） |\n| 4 | **名古屋・動物病院** | 獣医3名、午前午後の長い並び・電話負担→ **LINE予約**、補助金で導入コスト抑制、**約5年運用**・他院推奨意向 |\n\n**BNI・紹介の考え方**\n\n- 増本氏から2年前に誘いを受けていたが多忙で見送り。**AIで業務改善し時間ができた**こと、オンライン中心のDragonFlyが働き方と合うことから **2026年3月** に参加（葉子さんは **4月**、約1ヶ月後）。\n- システムは高額でリファーラルが出にくい → **入口商材**（低価格・低ハードル）が必要。受注の中心は依然BNI外。\n\n**個人（雑談・信頼づくり）**\n\n- 家族: 10歳年下の妻、娘2人（中3・小6）。猫4匹（チンチラシルバー系兄弟3＋保護猫1）。\n- 趣味: キャンプ・家族旅行、ジム、娘のダンス→ **Dリーグ** Dr.メッセンジャーズ観戦（2026年5月・お台場アリーナ等）。\n- スポーツ歴: 高校 **水球部**（静岡4校のみ、県大会出場圏）。\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 次廣 | 動物病院向けシステム説明 **チラシ作成**（早急） | 初版 [`materials/animal_hospital_line_reservation_flyer_202606.md`](materials/animal_hospital_line_reservation_flyer_202606.md) |\n| 山本 | 動物病院訪問時にチラシ **配布**、関心ある病院を紹介 | TODO |\n| 山本 | 静岡県獣医師会事務局へチラシ配布 **可否確認** | TODO |\n| 両者 | **2026-06-06** RFで対面 | 予定 |\n| 両者 | RF後 **藤枝** でデモ付き打ち合わせ（日程詳細 **TODO**） | TODO |\n| 両者 | **おかわり121** 実施 | TODO |\n\n#### 保留・確認事項\n\n- チラシの **PDF化・デザイン**（文案初版は `materials/animal_hospital_line_reservation_flyer_202606.md`）\n- 獣医師会事務局の **配布許可**\n- 藤枝デモの **日時**\n- 名古屋導入病院の **推奨コメント** をチラシに載せられるか\n\n---\n\n### 【おかわり121】未実施\n\n- **目的:** 葉子さんの **強み・理想顧客・切り出しトーク・Contact Circle** の言語化。動物病院以外の優先業種の確認。\n- **日時:** TODO\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **最優先協業ラインは「動物病院×カード入口×予約システムチラシ」**。葉子さんの獣医師会・訪問開始タイミングと、次廣の実績・補助金導入ストーリーが重なる。\n- 葉子さんは **聞き手・評価者タイプ** で信頼は取れている。ビジネス情報は **おかわりで必ず回収** しないと紹介精度が上がらない。\n- 次廣の **「つなぐ」** 思想と、葉子さんの Goal「人と人をつなぐ」は言語レベルで一致。関係継続の軸にできる。\n- BNIでは **チラシ＋概要説明可能な入口** が、葉子さんの営業動線にフィット。システム本体は藤枝デモ以降。\n- 6/6 RF → 藤枝デモは、**おかわりの前後どちらでもよいが、チラシ初稿はRF前にあるとよい**。\n\n---\n\n**更新履歴**\n\n| 日時（JST） | 内容 |\n|-------------|------|\n| 2026-06-03 | 動物病院向け配布資料初版 [`materials/animal_hospital_line_reservation_flyer_202606.md`](materials/animal_hospital_line_reservation_flyer_202606.md) |\n| 2026-06-03 16:22 | 第1回 Zoom 要約を校正反映。動物病院連携合意・おかわり121・6/6 RF/藤枝デモ・次廣プロフィール共有・累積インサイト更新 |\n| 2026-06-03 14:48 | 初版。プロフィールシート統合、DragonFly履歴・PALMS・初回セッション設計・台本・リファーラル戦略を作成（初回前） |','2026-05-30 13:35:23','2026-06-04 10:53:02'),
(42,1,37,139,NULL,'85054251043','RdBgZ2BpQF6nq437OGYGDA==','zoom','2026-06-04 09:00:00','2026-06-04 09:00:00','2026-06-04 10:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_fukuda_kohei_anfunini.md】\n\n# 1to1_福田航平_アンフィニ\n\n---\n\n**文書の位置づけ:** DragonFly 定例会ビジター経由で接点を持った福田航平さんとの 1to1 を **1ファイルで時系列管理**する。  \n**整理:** tugilo（次廣 淳）× **非BNIメンバー**（神奈川・教育・教材開発）。紹介は **越賀淑恵** さん。  \n**接点の経緯:** **2026-05-19** 第208回定例会にビジター参加（オンライン家庭教師）。当日、福田さんから「次廣さんの傾聴姿勢が素晴らしい」との声が越賀さん経由で共有された（[`chapter_weekly_20260519.md`](../chapter/chapter_weekly_20260519.md)）。  \n**日時:** 第1回 **2026-06-04（水）JST 09:00–10:00** 実施済み（Zoom 予定60分・ユーザー指定終了10時）。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **42**（Zoom 取り込みトピック: アンフィニ 福田航平さん: 1to1調整用）。\n\n**表記ゆれ（要確認）**\n\n| 出典 | 表記 |\n|------|------|\n| ユーザー・Zoom・DB | **福田 航平** |\n| 第208回議事録・参加者CSV | 福田 **康平**（誤記の可能性） |\n\n---\n\n## ■ 基本プロフィール（現時点）\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 福田 航平（ふくだ こうへい） |\n| **拠点** | 神奈川 |\n| **事業（移行中）** | **オンライン家庭教師** → **小〜中規模塾向けオーダーメイドテキスト開発**（約1ヶ月前から Instagram 発信開始） |\n| **屋号・法人名** | Zoom 表記 **アンフィニ**（正式表記・法人形態は **TODO**） |\n| **BNI** | DragonFly **非メンバー**（2026-05-19 ビジター） |\n| **定例会時の接点** | 紹介・お繋ぎ: **越賀 淑恵**／ビジター同行: **今西 俊明**（印刷協業の文脈で参加） |\n| **ビジョン** | 子どもの自殺率削減。勉強が分かる状態で送り出し、自信を持たせたい（中学生157人・高校生350人超/年の統計を背景に言及） |\n\n### 経歴（第1回要約）\n\n- 大学3年時、バーで隣に座った塾関係者と知り合い、**中退して塾業界**へ（20歳からのバー通いが転機）。\n- 塾で **8年勤務**後に独立。\n- 現在: 家庭教師業から教材開発へシフト。AI 台頭と価格崩壊（時給1600円・移動込み実質900円）により、個人派遣型家庭教師は **3年後にはほぼ消滅**と予測。\n\n### 事業の課題意識\n\n- 塾のテキストは外注が多く、**解説と実際の教え方がずれる**。\n- 各塾のトップ講師の教え方に合わせたテキストで学習効果を高めたい。\n- **Instagram:** 教育系コンテンツが少なくブルーオーシャン。いいねした人に A4 PDF 教材を配布して関係構築。YouTube は飽和のため避けている。\n\n---\n\n## ■ サマリー（最新状況）\n\n- **2026-06-04** 初回121。ビジネス連携の方向性と、教育・子育て・AI活用について深い意見交換。\n- **相互フィードバック:** 次廣の傾聴・BNI参加姿勢／航平の親としてのコミュニケーション（謝罪・妻との連携・成長段階への理解）を高く評価し合った。\n- **教材の方向性:** A4印刷前提から **スマホ・タブレット最適化**・オンライン教材へシフトすることで合意。次廣はインスタ発信のままターゲットを **塾運営者** に最適化することを推奨。\n- **紹介の約束:** 次廣 → Excel限界・社内システム課題・WEBデザイナー協業案件。航平 → 小〜中規模塾でオーダーメイドテキストニーズがある先。DragonFly 内の塾関係者探索は次廣側 Todo。\n- **次回:** 日時未定。航平「ネタができたら呼んで」／次廣「ぜひ遊びに来て」。BNI 再会時に進捗共有。\n\n---\n\n## ■ 次廣側プロフィール（第1回共有・相手への理解用）\n\n| 項目 | 内容 |\n|------|------|\n| 経歴 | フランス語学科の文系 → インターネットで知り合ったシステム会社社長のスカウトで就職（就活なし）。大学6年目中退 |\n| 独立 | 30歳で独立。静岡県藤枝市拠点、全国の経営者と仕事 |\n| 専門 | 25–26年、B2B業務システム（受発注・工程管理）。AI駆動開発 **3年目** |\n| 理念 | 現場ワークフロー尊重。「人の頑張りで回っている業務で、頑張る人が損しない仕組み」 |\n| 開発スタイル | 大きなシステムを最初から作らず、入り口設計＋必要機能の段階追加（伴走型） |\n| BNI | DragonFly 入会2–3ヶ月。立ち上げ当初から誘われていたがタイミングを見て最近参加 |\n\n---\n\n## ■ ビジネス連携の設計\n\n### 次廣が紹介しやすい相手（合意）\n\n| 優先 | 像 |\n|:---:|-----|\n| ★ | **Excel で業務管理に限界**を感じている企業 |\n| ★ | **複数従業員**・社内システムに課題がある企業 |\n| ○ | **WEBデザイナー**との協業案件 |\n\n### 航平が紹介しやすい相手（合意）\n\n| 優先 | 像 |\n|:---:|-----|\n| ★ | **小規模〜中規模の塾**でオーダーメイドテキストのニーズがある先 |\n\n### 協業・補完の芽（議論のみ・未契約）\n\n| テーマ | 内容 |\n|--------|------|\n| デジタル教材 | 次廣のシステム・AI実装力 × 航平の教材設計・塾向けノウハウ |\n| 印刷 | 今西さん（印刷業）との接点は定例会ビジター時に既存。印刷斜陽と小ロットオンライン印刷の話も共有 |\n| 自習スペース | 韓国型「スマホ預かり＋自習専用スペース」の日本需要は航平側で市場調査 **TODO** |\n\n### 保留・確認事項（ビジネス）\n\n- オーダーメイドテキストの **価格設定・提供方法**\n- スマホ専用教材の **技術実装・プラットフォーム選定**\n- 韓国型自習スペースの **日本での需要検証**\n\n---\n\n## ■ AI活用（双方の実践・合意）\n\n| 用途 | 次廣 | 航平 |\n|------|------|------|\n| 初稿 | ChatGPT | ChatGPT（問題・解説・インスタ用・A4 PDF） |\n| 仕上げ | Claude・Gemini で磨き上げ | Claude のブラッシュアップを **試験 TODO** |\n| 教育 | 娘のテスト範囲から AI で問題自動生成 | ショート動画は無料AIで1日3本から（凝りすぎ注意） |\n| 注意 | 集合知の偏り・複数AIで検証 | Gemini 試したが ChatGPT に戻った |\n\n**合意:** ChatGPT で初稿 → Claude / Gemini で磨く流れが効果的。\n\n---\n\n## ■ 教育・子育て（信頼づくり・非ビジネス価値）\n\n### 次廣家（共有・航平からのアドバイス対象）\n\n- 家族: 妻、**中3長女**（受験）、**小6次女**\n- 子育て: 小3頃から試行錯誤。妻からホルモン・体の変化を学び、「たまたま親になっただけで勉強中」と伝えて関係改善。イライラ時は **必ず謝罪**\n- 勉強: 「勉強しろ」と言わない方針。個別指導塾へ変更（集団塾の限界）\n- 長女: コミュニケーション力は高いが本当に勉強しない。音楽・技術系は4–5。静岡は **内申重視**（2年終わり＋3年3学期）。吹奏楽部は **10月まで**活動\n- **保留:** 志望校決定後の学習計画（夏〜秋）を妻と相談。部活引退後はスマホ時間が増えるだけ、との航平助言\n\n### 航平の業界観察\n\n- 8年前から「本当に勉強しない」世代が顕著。YouTube・スマホ・将来目標の欠如\n- 中学校でスマホ所持 **9割**。LINE が部活連絡の中心\n- 部活引退＝勉強開始ではない。**どこかで締めるタイミング**が必要\n- 生き残る塾: 自習室・「場所」・スマホ使えない環境。韓国のスマホ預かり自習スペースは月額数万円で人気\n\n### 社会・学校（雑談の蓄積）\n\n- モンスターペアレント減少、「厳しい部分は学校へ」丸投げ。次廣 PTA会長経験（役職削減・ボランティア制・父親参加促進）\n- コロナ後の運動会: 部外者入場不可、お弁当文化の簡略化。地域の顔見え関係の喪失\n- 印刷斜陽とタブレット教材普及。学校PDFはスマホで見づらい → スマホ専用教材は未開拓領域\n\n---\n\n## ■ フィードバック交換（第1回）\n\n### 次廣 → 航平\n\n- BNIビジター時の **傾聴姿勢**（うなずき・聞き方）が一番良かった（定例会時点の評価の再確認）\n- インスタ教材発信は良いが、**スマホ専用オンライン教材**への展開を提案\n- ターゲットを **塾運営者** に刺さる内容へ最適化\n- 動画制作は **AI無料範囲**から始めるのが効率的\n\n### 航平 → 次廣\n\n- 子どもとのコミュニケーションが素晴らしい（謝罪・妻連携・成長段階への理解）\n- 「娘の結婚式で感謝されて大泣きするタイプ」との評価\n\n---\n\n## ■ tugiloとしての戦略\n\n- **即案件化より関係資産。** 航平は BNI 外だが、教育×AI×デジタル教材の文脈で長期の情報交換相手になりうる。\n- **紹介は双方向だが頻度は低め想定。** 次廣の主戦場（業務システム）と航平の主戦場（塾テキスト）の顧客像は異なる。DragonFly 内の **塾・教育関連メンバー** を意識的にマッピングする価値あり。\n- **製品アイデアのシグナル:** スマホ最適化教材・自習スペースモデルは、別途 Religo / tugilo の教育系案件検討の参考になるが、今回は航平事業の伴走・紹介に留める。\n- **次廣の受験ネタ:** 長女の受験は航平がフォロー提案。過度な営業化せず、121の信頼維持が優先。\n\n---\n\n## ■ リファーラル・紹介（BNI文脈）\n\n| 方向 | アクション |\n|------|------------|\n| 次廣 → 航平 | システム化ニーズのある企業・デザイナー協業案件を探索 |\n| 航平 → 次廣 | 塾関係者・オーダーメイドテキストニーズ |\n| 次廣（DragonFly内） | 塾関係者・教材ニーズがあるメンバーを探す（**TODO**） |\n| 再会 | DragonFly 例会・イベントで進捗共有。次回121は航平から「ネタ」連絡待ち |\n\n**定例会での既知接点:** 今西俊明（印刷）— 航平の印刷協業希望と関連。小ロットはオンライン印刷が安い一方、品質・チェック体制のある昔ながらの印刷屋の信頼性も議論に登場。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **人との巡り合い** を双方が重視（次廣: ネットスカウト／航平: バーで塾関係者）。「人の付き合いって大事」で一致。\n- 航平は **事業転換の切迫感**（家庭教師の3年後消滅予測）と **社会課題（自殺率）** に強い動機。トーンは真面目・教育愛が厚い。\n- 次廣は **傾聴** で信頼を得ている。ビジター評価は越賀さん共有分と第1回で一致。\n- BNI入会は未確認。再会はチャプターイベント経由が自然。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-06-04 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-04（水）JST 09:00–10:00**\n- **実施方法:** Zoom\n- **紹介:** 越賀淑恵さん（5/19定例会ビジター参加後）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **42**\n\n#### 主な成果\n\n- 静岡のシステムエンジニア（次廣）と神奈川の教材開発者（航平）の **初回1on1**。\n- ビジネス紹介の方向性、AI活用（ChatGPT初稿→Claude/Gemini仕上げ）、**スマホ専用教材**へのシフト、子育て・受験・教育業界構造について深い意見交換。\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| 紹介（次廣→） | Excel限界企業、社内システム課題企業、WEBデザイナー協業 |\n| 紹介（航平→） | 小〜中規模塾のオーダーメイドテキストニーズ |\n| 教材方針 | A4印刷中心 → **スマホ・タブレット最適化**・デジタル中心へ検討 |\n| 発信 | インスタ継続、ターゲットは **塾運営者** 向けに最適化 |\n| 次回 | 未定。BNI再会時に進捗共有。航平からネタあり次第連絡 |\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 次廣 | 娘の志望校決定後、学習計画を妻と相談（夏〜秋） | TODO |\n| 次廣 | 航平のインスタをフォローし教材サンプル確認 | TODO |\n| 次廣 | DragonFly内で塾関係者・教材ニーズを探索 | TODO |\n| 航平 | スマホ専用オンライン教材プロトタイプ着手 | TODO |\n| 航平 | Claudeで教材ブラッシュアップ試験 | TODO |\n| 航平 | インスタショートをAIで1日3本目標 | TODO |\n| 航平 | 自習スペース＋スマホ預かりの市場調査（韓国モデル） | TODO |\n| 航平 | 次廣長女の受験状況を定期的フォロー（アドバイス） | TODO |\n| 両者 | BNI DragonFlyで再会時に進捗共有 | — |\n| 両者 | 相互ビジネス紹介を探索 | 継続 |\n\n#### 保留・確認事項\n\n- 価格設定・提供方法（オーダーメイドテキスト）\n- スマホ教材の技術・プラットフォーム\n- 韓国型自習スペースの日本需要\n- 次廣長女: 夏以降の学習計画、10月までの吹奏楽と部活引退後のスマホ時間\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **信頼の軸は「傾聴」と「子育ての誠実さ」**。ビジネスより先に人間関係の質が高く、紹介はその後から育つタイプ。\n- 航平の事業は **家庭教師から教材SaaS/コンテンツへピボット中**。AIとスマホ最適化が生死線。次廣は実装・業務システム側の相談相手になりうるが、第1回は紹介条件の合意まで。\n- **教育業界の構造変化**（価格崩壊・AI・自習室・スマホ9割）の話は、次廣の受験育児・DragonFly教育系メンバーへの雑談ネタとして再利用価値が高い。\n- **Instagram × 塾運営者ターゲット × デジタル教材** は航平独自のGTM。YouTube回避は競合判断として明確。\n- 次回121は **航平のプロトタイプ・ネタ待ち**。次廣からのフォローは軽く（インスタ確認・DragonFly内紹介先探索）。\n\n---\n\n**更新履歴**\n\n| 日時（JST） | 内容 |\n|-------------|------|\n| 2026-06-04 10:52 | 初版。第1回 Zoom 要約反映。越賀紹介・5/19ビジター経緯・Religo id=42・相互紹介・教材デジタル化・子育て/受験・AI活用 |','2026-05-30 13:35:23','2026-06-04 10:55:22'),
(43,1,37,99,NULL,'87970810668','EpAXFCa/QpOjsVdWaEVClw==','zoom','2026-05-29 14:00:00','2026-05-29 14:00:00',NULL,'completed',NULL,NULL,NULL,'【第2回 1to1 — ソース: docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md】\n実施: 2026-05-29（金）JST 14:00–15:00・Zoom\nBPS木村／株式会社国宝社の製本システム業務改善ヒアリング。\n\n決定・合意:\n- 既存 VB+Oracle 基幹は温存。新規 Web 入力画面で PDF 注文書を解析→確認→Oracle 登録。\n- 社内サーバー Hyper-V 上に Linux Web サーバー、社内Wi-Fi/VPN 経由・外部非公開。Google Workspace は主軸にしない。\n- 段階実装: 第一段階=月300〜400件のPDF手入力自動化、第二段階=日報等Excelの Web化。\n\n課題: ヘッダ/フッタ 1:N、出版社ごとに注文書フォーマット差・手書きあり、ODBC 書込権限。\n\n次アクション:\n- 次廣: 数日以内に提案書＋簡易モックを無償作成。\n- 木村: DB定義書・サンプルPDF を共有。','2026-05-30 13:35:23','2026-06-01 13:56:51'),
(44,1,37,113,NULL,'88597252767','MF27uxnKT2aqvRtXjdXckQ==','zoom','2026-05-29 09:00:00','2026-05-29 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_furuya_shuji_telecom_cost.md】\n\n# 1to1_古屋周治_通信・害虫ブロック・不動産\n\n---\n\n## 文書の位置づけ\n\n- **対象関係:** 次廣（tugilo／BNI DragonFly）と **古屋 周治（ふるや しゅうじ）** さん（**合同会社TF 代表社員**／屋号 **スマホドクター静岡葵**）の 1to1 を **1ファイルで時系列管理**する。\n- **接点:** 古屋さんは **DragonFly 第208回（2026-05-19）にゲスト参加**。紹介者は DragonFly メンバー **増本 重孝**（**害虫ブロック**／関係＝**友人**）。**古屋さん自身も害虫ブロック取扱店**であり、増本さんとは事業上のつながりがある。\n- **守成クラブの縁（重要）:** 古屋さんは **守成クラブ静岡会場の代表**（2023年2月入会）。次廣も **静岡守成クラブ会員**（ただし **約3年活動できていない**）。**守成クラブ** が両者の共通基盤。\n- **BNI:** **静岡セントラルリージョン インフィニティ∞チャプター**（**2023年10月〜**）の現役メンバー。カテゴリー＝**携帯回線**。DragonFly へはゲスト（リファーラル貢献＋更なる貢献目的・**メンバー見込み ★★**・NEリージョン体験意向）。\n- **事業の三本柱:** ①**通信サービス（携帯回線・固定費削減）**、②**害虫ブロック**（取扱店・全国200店拡大中）、③**不動産売買仲介**（宅建士保有）。\n- **第1回 1to1:** **2026-05-29（金）実施**（これから／開始・終了時刻は TODO。カレンダー／Zoom で確認後に YAML と【第1回】へ反映）。\n\n---\n\n## 紹介コンテキスト（定例会・ゲストカード）\n\n| 項目 | 内容 |\n|------|------|\n| **定例会** | DragonFly **第208回**（2026-05-19） |\n| **種別** | **ゲスト** |\n| **氏名** | 古屋　周治（ふるや　しゅうじ） |\n| **会社／役職** | **合同会社TF（ティーエフ）／ 代表社員** |\n| **屋号** | **スマホドクター静岡葵** |\n| **HP** | https://www.tf-estate.jp/communicate.php |\n| **カテゴリー（ゲスト票）** | 通信サービス・不動産（詳細は下記） |\n| **カテゴリー詳細** | 通信回線の販売取次／個人向け携帯電話回線の最適化（**docomo格安回線**）／個人・法人（店舗）向け **光回線の最適化**（NTTフレッツ光・コラボ光・独自回線）／**スマホ保険販売** |\n| **メール／連絡先** | tf.llc524@gmail.com ／ 080-3633-4317 |\n| **紹介者** | **増本　重孝**（**害虫ブロック**／関係＝**友人**） |\n| **アテンド** | 山本　洸太、太田　一誠、佐藤　拓斗 |\n| **決済権** | 有 |\n| **オリエン希望** | 無 |\n| **BNI経験** | インフィニティ（静岡）※2023年10月〜の現役メンバー |\n| **メンバーになる見込み** | ★★ |\n| **備考** | 複数のメンバーにリファーラルの貢献があり、更なる貢献目的でのゲスト参加。静岡県 |\n\n- 参加者リスト出典: [第208回 CSV](../../pdf/260518/dragonfly_208_20260519_all_full.csv)（ゲストNo.01）。\n- ナショナルカンファレンス参加でBNIの規模を知り、**NEリージョンの定例会を体験したい**意向（増本さんメモ）。\n\n### ゲスト対応メモ（第208回・原文要約）\n\n| 日時 | 記録者 | 内容 |\n|------|--------|------|\n| 2026-05-09 11:15 | 増本 重孝 | 初めてナショナルカンファレンスに参加し、BNIの規模の大きさを知り、**NEリージョンの定例会を体験したい**。増本にリファーラル有り。 |\n| 2026-05-19 10:09 | 太田 一誠 | 通信事業の販売。**固定費削減をしたい不動産・店舗系**からの相談が多い。**プランを理解せず入っている人が多い**ので、ヒアリングしてプラン変更していく。**全国に販売パートナー**がいる。**不動産を起点とした商品を他にも展開**していく考え。 |\n| 2026-05-19 10:17 | 廣田 誠悟 | 不動産の対応エリアは**静岡市を中心に静岡県**。里見さんの奥さんと知り合い（**スマホドクター**）。スマホドクターは全国対応。 |\n| 2026-05-19 10:17 | 山本 洸太 | 静岡を拠点に**不動産業**を展開する一方、**全国規模で通信事業**も。回線/スマホの切り替え・引き込み手配で通信環境を最適化。「**今のプランをなんとなく使い続けている**」層への見直し提案が得意で、ヒアリングで無駄なコストを削減。**キャッシュバック制度も充実**で経費削減提案が強み。**美容サロンなど店舗経営者の顧客も多い**。訪問営業に頼らず**人との信頼関係を軸**に事業を拡大。 |\n\n---\n\n## ■ 基本プロフィール（GAINSシート／メンバー略歴シート・2026-05-04 更新）\n\n### 古屋周治さん\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 古屋　周治（ふるや　しゅうじ） |\n| **生年月日** | 1983/7/21（蟹座） |\n| **事業名** | 合同会社TF（ティーエフ）／**代表社員** |\n| **屋号** | **スマホドクター静岡葵** |\n| **専門分野** | **通信サービス・害虫ブロック・不動産売買仲介** |\n| **所在地** | 静岡市葵区城東町42番16号 |\n| **BNI** | 静岡セントラルリージョン **インフィニティ∞チャプター**／カテゴリー **携帯回線**／**2023年10月〜** |\n| **守成クラブ** | **静岡会場 代表**（2023年2月入会・在籍） |\n| **経験年数** | 通信サービス **5年** |\n| **職歴** | 【新卒】静岡鉄道（株）不動産部 →（株）佐川急便 → 不動産業個人事業主 → 法人設立 |\n| **資格** | **宅地建物取引士**、古物商（機械工具）、運行管理者、第一種衛生管理者 |\n| **出身地** | 静岡県沼津市新宿町 |\n| **居住履歴** | 沼津市〜愛知県知多郡美浜町（学生）〜沼津市〜富士市〜**静岡市（12年目）** |\n| **家族** | 妻・**光恵**（ピラティスインストラクター・指導歴20年）、長男21・長女20・次女16・次男7。犬2匹（豆柴8歳♂・MIXチワプー8歳♀） |\n| **趣味** | 旅行、子どもと公園、**サーフィン**（復活へ減量中 79→67kg・2026/8まで）、**バイク**（BMW GS Adventure 850）でツーリング |\n| **強い願望** | **時間持ち**になれる稼ぎ方をすること |\n| **誰も知らない私** | 朝起きて珈琲豆を挽いている。初海外がジャマイカ |\n| **成功の鍵** | **妻のご機嫌維持** |\n\n### G.A.I.N.S. 要約\n\n| 項目 | 内容 |\n|------|------|\n| **Goals** | **3年後:** 静岡県内 **1,000回線**（通信契約）・**害虫ブロック400取扱店**／**5年後:** **2,000回線**・**害虫ブロック600取扱店**／**夢:** 携帯ショップに依存しない日本へ。虫に困っている全ての方へサービス提供 |\n| **Accomplishments** | MLM組織構築／**光回線販売 単月50件獲得**／守成クラブ静岡会場 在籍（2023/2入会）／**害虫ブロック取扱店 全国200店**拡大 |\n| **Interests** | サーフィン復活の身体づくり、バイク（BMW GS Adventure 850）ツーリング |\n| **Networks** | MLM組織構築で **全国に事業パートナー**／**守成クラブ静岡会場 代表** |\n| **Skills** | O型・**中立的な目線**で対応（動物占い「人間味あふれるたぬき」）／人と仲良くなる力／資格：宅建士・古物商・運行管理者・第一種衛生管理者 |\n\n### リファーラルシート（携帯回線・Closing）\n\n- **対応エリア：全国**\n- **個人プランが特に強い**\n- 高齢者に喜ばれる\n- **Wi-Fiを一度も乗り換えたことがない人** → キャッシュバックが使える可能性大\n- スマホ5G対応・パフォーマンス高\n- 担当：**古屋のサポート付き**\n\n### 次廣側（共有する固定情報）\n\n- **屋号:** tugilo（ツギロ）\n- **カテゴリー:** AI業務改善システム構築\n- **拠点:** 静岡県藤枝市。オンラインで全国対応\n- **強み:** Excel・紙・LINE・属人化を、現場に合わせて小さく仕組み化。10〜30人規模で効果が出やすい\n- **BNI:** DragonFly（2025年3月加入）\n- **守成:** 静岡守成クラブ会員（約3年ご無沙汰 — 古屋さんが代表という縁で再接続の糸口）\n- **公開サイト:** https://tugilo.com\n- **121用詳細:** [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §8\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係の位置づけ:** **インフィニティ∞（静岡セントラル）× DragonFly** のクロスチャプター初回 1to1（**2026-05-29 実施**）。紹介者は **増本重孝**さん（害虫ブロック）。**守成クラブ** という共通基盤がある。\n- **事業理解:** **通信（携帯回線・固定費削減・全国）／害虫ブロック（取扱店・全国200店）／不動産売買仲介（静岡・宅建士）** の三本柱。「なんとなく今のプラン」層へのヒアリング型見直しが得意で **個人プランに強い**。\n- **増本さんとの線:** 古屋さんは **害虫ブロック取扱店** で、紹介者の増本さん（DragonFly 害虫ブロック）と事業上つながっている。友人関係。\n- **期待する成果:** ①三本柱と「不動産起点の商品展開」構想を理解、②相互の「紹介しやすい相手」を言語化、③守成クラブの縁を活かした継続接点を1つ決める。\n- **次アクション:** 会後に本ファイル【第1回】へ議事録を追記。`one_to_ones.id` は Religo 登録時に追記（**TODO**）。\n\n---\n\n## ■ 初回セッション設計（2026-05-29）\n\n| 時間（目安） | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | 守成クラブの縁・ご無沙汰のお詫び、増本さん（害虫ブロック）へのお礼、進め方の合意 |\n| 5〜8分 | **雑談** | サーフィン復活の減量・BMW GSツーリング・珈琲豆・次男溺愛・「妻のご機嫌維持」 |\n| 8〜28分 | **古屋さん** | 通信／害虫ブロック／不動産の三本柱、固定費削減のモデル、1,000回線・400取扱店の優先順位 |\n| 28〜45分 | **次廣** | AI業務改善・システム構築・紹介しやすい相手（[ライブドキュメント](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §8） |\n| 45〜55分 | **接点探索** | 固定費削減 × 業務DX、全国パートナー網／取扱店の見える化、守成・BNI双方での相互紹介の具体1件 |\n| 55〜60分 | クローズ | 次アクション1〜2件、名刺・LINE、DragonFly／守成での今後、必要なら第2回 |\n\n### 初回で聞くこと（チェックリスト）\n\n- [ ] **三本柱の優先順位** … 通信／害虫ブロック／不動産で、今いちばん伸ばしたいのはどれか\n- [ ] **通信（携帯回線）** … 個人プランが主役か、法人/店舗の固定費削減か。利益モデル・キャッシュバックの仕組み\n- [ ] **害虫ブロック** … 増本さんとの関係、**取扱店400店（3年）／600店（5年）** へのボトルネック（人材？管理？教育？）\n- [ ] **不動産売買仲介** … 静岡県内の得意領域、不動産起点の「商品展開」構想の中身\n- [ ] **全国パートナー網／MLM組織** … どう機能・管理しているか\n- [ ] **静岡守成クラブ** … 代表としての活動、会の雰囲気、次廣が再参加できる入口\n- [ ] **インフィニティ∞／DragonFly** … 入会意向（NEリージョン体験意向あり・押し売りしない）\n- [ ] **紹介してほしい相手** 3条件 ／ **紹介できる相手** 3条件\n\n### 次廣が伝える要点（短く）\n\n- **カテゴリ:** AI業務改善システム構築（tugilo）\n- **入口:** Excel・紙・LINE・二重入力の限界 → 小さくシステム化\n- **紹介依頼:** 売上は伸びているが現場の仕組みが追いついていない経営者、FC本部・複数拠点・取扱店網、建設・工事の現場管理\n- **守成:** 古屋さんが代表という縁で、ご無沙汰している静岡守成に再接続したい意向（押し付けず一言）\n\n---\n\n## ■ 初回121 台本（事前・読み上げ用）\n\n### 1. オープニング（守成の縁から）\n\n> 「古屋さん、本日はお時間ありがとうございます。BNI DragonFly の次廣です。\n> 先日は **第208回の定例会** にゲストでお越しいただき、ありがとうございました。**増本さん** のご紹介ですね。古屋さんも **害虫ブロックの取扱店** をされていると伺いました。\n> 実は私も **静岡守成クラブ** に籍を置いているのですが、ここ **3年ほど顔を出せておらず**…。古屋さんが **静岡会場の代表** をされていると伺い、これも何かのご縁だと思っています。\n> 今日は、古屋さんのお仕事——**携帯回線（固定費削減）**、**害虫ブロック**、**不動産**——をしっかり理解したいです。\n> 後半で私の業務システム・AI活用支援の話もしますので、『こういう人なら合いそう』という視点で聞いていただけるとうれしいです。\n> 前半は古屋さん、後半は私、という流れで進めてもよいですか？」\n\n### 1.5 雑談（信頼づくり・3〜5分／1〜2問で十分）\n\n> 「シートを拝見して、**サーフィン復活** のために減量中（79→67kg）と、**BMW GS Adventure** でツーリング、朝は **珈琲豆を挽く** と。アクティブですね。\n> 成功の鍵が **『妻のご機嫌維持』**、次男くんを溺愛——というのもすごく人柄が出ていて、親近感がわきました。\n> お忙しい中で、サーフィンやツーリングの時間はどう確保されていますか？」\n\n### 2. 前半：古屋さんの事業紹介〜質疑応答\n\n**まず聞く姿勢で入る。**\n\n> 「**携帯回線（スマホドクター静岡葵）** をメインに、**害虫ブロック** の取扱店、**不動産売買仲介** と、三本柱でやられていますね。職歴も静岡鉄道の不動産部からというルーツがあって。\n> いま **一番力を入れているのはどれ** に近いですか？」\n\n**深掘り質問（必要なぶんだけ）**\n\n- 「通信は **個人プランが特に強い** とのこと。『なんとなく今のプランを使っている』方を、どうヒアリングして変えていくのですか？**キャッシュバック** の仕組みも教えてください。」\n- 「**3年後に1,000回線、5年後2,000回線**。この数字に向けて、いま詰まっているのは **集客・人材・管理** のどこですか？」\n- 「**害虫ブロックは全国200店 → 400店 → 600店**。増本さんとはどういう関係で、取扱店を増やすボトルネックは何ですか？」\n- 「**不動産起点の商品展開** とは、具体的にどんな広げ方をイメージされていますか？」\n- 「**全国の事業パートナー（MLM組織）** は、どう機能・管理されていますか？」\n- 「**守成クラブ静岡会場の代表** として、会としていま大事にされていること・課題は何ですか？」\n\n**紹介文を作るための確認**\n\n> 「第三者に紹介するとき、**『スマホ・携帯の固定費を下げる “スマホドクター静岡葵” の古屋さん。害虫ブロックや不動産もされている、合同会社TFの代表』** という言い方でズレは少ないですか？短くするならどの一言がよいですか？」\n\n### 3. 後半：こちらの事業紹介〜質疑応答\n\n> 「私は、ExcelやLINE、紙、手作業で回っている業務を整理して、現場に合わせて小さく仕組み化する仕事をしています。\n> AIも使いますが、AI単体ではなく、見積・問い合わせ・予約・日報・多拠点の連絡など、**現場の流れに組み込む** 形が多いです。」\n\n**古屋さん向けに刺さりそうな接点（話すときの例）**\n\n- **固定費削減 × 業務DX:** 通信費を下げて浮いた原資を、業務システム化の投資に回す提案がセットで効く\n- **取扱店・パートナー網の見える化:** 害虫ブロック取扱店（200→600店）や全国パートナーの実績・契約・精算が分散しがち → 一元管理・見える化\n- **不動産業務の効率化:** 物件・顧客・契約情報の管理、問い合わせ対応の仕組み化\n- **紹介の線:** 次廣のネットワークの **建設・製造・多拠点10〜30人** ＋ 固定費を見直したい経営者・店舗\n\n**相手に聞いてもらう質問**\n\n> 「古屋さんから見て、私の仕事は **どんな業種・どんな困りごと** の人に紹介しやすそうですか？ 逆に **紹介しない方がよい条件** があれば教えてください。」\n\n**Living Document 参照（読み上げ時）**\n\n- オープニング・実績・紹介依頼のフル版 → [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §8.1\n- 具体例は同ファイル §8.3（FC本部・LINE日報・解体LINE見積 等）\n\n### 4. クロージング\n\n> 「今日の話を受けて、私から紹介できそうな人（固定費を見直したい経営者・店舗・多拠点まわり）を整理します。\n> 逆に、古屋さんから見て私に合いそうな方がいれば、無理のない範囲で教えてください。\n> 守成クラブの方も、近いうちにまた顔を出せればと思っています。名刺・LINE、交換させてください。」\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-05-29\n\n#### 基本情報\n\n- **日時:** **2026-05-29（金）JST TODO**（開始・終了は Zoom／カレンダーで要確認）\n- **実施方法:** **Zoom**（文字起こし要約ベース・2026-05-29）\n- **相手:** 古屋周治（合同会社TF 代表社員／スマホドクター静岡葵／守成クラブ静岡会場代表／BNI インフィニティ∞・DragonFly 第208回ゲスト）\n- **紹介者:** 増本重孝（BNI DragonFly・害虫ブロック）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **44**（`members.id` = 113／古屋周治 guest）\n- **目的:** 初回相互理解。通信／害虫ブロック／不動産の三本柱、相互リファーラル条件、守成クラブの縁を活かした継続接点を確認する。\n\n> **固有名詞の注記（音声認識の揺れ）:** 「**外注ブロック**」＝**害虫ブロック**（同音）、「**古谷**」＝**古屋**。FC 名は「昭庵」ではなく **鐘庵（かねあん）**（次廣の長期保守先 FC 本部）。\n\n#### 話した内容（重要）\n\n※ユーザー提供の **Zoom 文字起こし要約**（2026-05-29）ベース。\n\n**事業共有**\n\n- **次廣:** B2B/B2C のシステム開発 約25〜26年。**会社ごとにフィットさせるカスタマイズ開発**が強み（汎用パッケージは持たない）。**鐘庵（かねあん）フランチャイズ本部**のシステムを10年以上保守。**AI連携の事業者提案型予約システム**を開発中。\n- **古屋:** **不動産仲介・通信回線販売（スマホドクターFC）・害虫ブロック代理**の三本柱。ドクターモバイル（個人向け980円〜5,000円台）、光回線の全国対応＋キャッシュバック、**担当者制の迅速・中立対応**が差別化。課題は **B2C 中心で一気に拡大する型が見えない**こと。\n\n**協業の具体化**\n\n- **鐘庵本部直営店（静岡・愛知 10店舗以上）の通信回線見直し**＝月7,000円程度のコスト削減余地。次廣が回線契約書を共有 → 古屋が固定費削減提案。\n- **予約システム:** ホットペッパー代替として、MEO コンサルと組んだ集客動線。**月額5,000円以内**のサロン向けパッケージ化を検討。\n- **害虫ブロック事業の課題:** 都道府県別代表制で全国展開企業（例: ナック）に一括導入できない／ピタカット液剤の単体販売が取扱店の顧客を奪う懸念／**P-Link 統合**は松本氏が検討中（成分を薄めたスプレー版を入口商品にする案）。\n\n**BNI**\n\n- **次廣:** NE リージョン（2024-03 加入・2ヶ月でトレーニング完了・全オンライン）。松本氏・今西氏と定期飲み会。紹介者は水島氏（高校来30年以上）。\n- **静岡リージョン:** 約150名・朝6時半・対面・県内商売中心。古屋が代表（吉野氏との距離感に留意）。\n\n#### 決定・合意\n\n- **鐘庵の通信回線見直し:** 次廣が契約書を共有 → 古屋が固定費削減提案を作成。\n- **予約システム:** 事業者が空き時間を提案できる新方式を **夏までにリリース予定**。\n- **BNI:** 松本氏・今西氏らとの定期飲み会を継続しネットワーク強化。\n\n#### 次アクション\n\n- **次廣:** 鐘庵の現行通信回線契約書を古屋へ送付（即時）／予約システムのパッケージ化（月額5,000円以内）を検討し古屋に相談／来週の飲み会で害虫ブロックの課題を議論。\n- **古屋:** 鐘庵の回線契約を確認し固定費削減提案を作成／MEO・マイビジネス対策を学習。\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- 古屋さんは **「携帯回線（固定費削減）」＋「害虫ブロック（取扱店網）」＋「不動産売買仲介」** の三本柱。「通信の人」とだけ捉えると狭い。**ストック型（回線・取扱店）の積み上げ** を志向。\n- 紹介者の **増本さん（害虫ブロック）とは取扱店として事業上つながっている**。友人関係。害虫ブロックは古屋さんの成長軸（200→600店）でもある。\n- 強みは **ヒアリング型のプラン見直し**・**個人プランに強い**・**訪問営業に頼らない信頼関係ベース**。BNI/守成/MLMの関係資産と相性がよい。\n- **時間持ちになりたい**（願望）・**ストック収益志向** — 次廣の「仕組み化で手離れ」と価値観が合う可能性。\n- **メンバー見込み ★★**・**NEリージョン体験意向あり**。押し売りせず、まずは紹介・貢献の実感を持ってもらう関わりが効く。\n- 宅建士・運行管理者・古物商など **資格が多彩** で、不動産起点の事業展開に説得力がある。\n\n---\n\n## ■ tugiloとしての戦略\n\n- **固定費削減 × 業務DX:** 古屋さんが通信という「出ていくお金」を減らす専門家なら、次廣は「人と業務の効率」を上げる側。**浮いた固定費を業務システム化の投資に回す** ストーリーで補完関係を作れる。\n- **取扱店・パートナー網の見える化:** 害虫ブロック取扱店（200→600店目標）や全国MLMパートナーの実績・契約・精算が分散していれば、次廣の一元管理・見える化が刺さる。初回で運用実態をさりげなく確認する。\n- **守成クラブの再接続:** 古屋さんが静岡会場の代表という縁を活かし、ご無沙汰している静岡守成への再参加の糸口にする（押し付けず、まず関係構築）。BNI・守成・MLMと複数コミュニティで接点を持てる相手として大事にする。\n- **増本さんへの返礼:** 紹介のお礼と、古屋さん向けに次廣が紹介できる相手の有無を第1回後に増本さんへ一言共有する（増本さん＝害虫ブロックの線も意識）。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣が古屋さんに紹介してほしい相手\n\n- 通信費・固定費を見直したいが手が回っていない **中小企業の経営者・店舗オーナー**\n- **個人で携帯/Wi-Fiを長年見直していない人**（古屋さんの個人プランが強い・キャッシュバック）\n- **害虫に困っている施設・店舗・住宅**（害虫ブロック）／取扱店になりたい事業者\n- 静岡県内で **不動産（売買仲介）** のニーズがある人\n- 静岡セントラル・守成クラブ内の、業務がExcel/紙/LINEで限界の経営者\n\n### 古屋さんに紹介できそうな相手（仮説・要確認）\n\n- 法人携帯・通信費の **固定費を下げたい** 経営者（次廣の建設・製造・多拠点ネットワーク）\n- **美容サロン等の店舗経営者**（古屋さんの得意顧客層）\n- 害虫対策ニーズのある **飲食・食品・宿泊・介護施設**\n- 静岡県内で **不動産** を探している／売りたい経営者\n- 守成クラブ・DragonFly 内で固定費の話題が出ている経営者\n\n**紹介文たたき台（次廣向け・会後調整）**\n\n> 古屋さんは、スマホ・携帯の固定費を下げる “スマホドクター静岡葵” の代表です。害虫ブロックや不動産売買仲介もされています。「今のプランをなんとなく使っている」個人・経営者がいればつなげられます。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **守成クラブ静岡会場の代表** という立場 — 会を束ねる人柄・信頼。次廣のご無沙汰を正直に伝えつつ、敬意を持って接する。\n- **O型・中立的・人間味あふれるたぬき（動物占い）**、「人と仲良くなる力」。**温和で信頼関係ベース**。テンポより丁寧さ・共感で合わせるとよさそう。\n- **サーフィン・BMWツーリング・珈琲・次男溺愛・妻のご機嫌維持** — 雑談の入り口が豊富。家族・趣味で距離が縮みやすい。\n- **時間持ちになりたい／ストック収益志向** — 「手離れ・仕組み化」の話に共感しやすい。\n- 紹介者 **増本さん（害虫ブロック）との取扱店つながり** を踏まえ、増本さんへのお礼・共有を忘れない。\n- 別コミュニティ（守成）×別チャプター（インフィニティ∞・静岡セントラル）×全国MLMの多重ネットワーク。長期で大事にしたい相手。\n\n---\n\n**作成:** 2026-05-29 08:49 JST（第1回実施前の事前ドキュメント）。\n**更新:** 2026-05-29 08:52 JST — 第208回（2026-05-19）ゲストカード・対応メモを反映。\n**更新:** 2026-05-29 08:56 JST — 古屋さん提供の **GAINS／メンバー略歴／リファーラルシート（2026-05-04 更新）** を反映。三本柱（通信・害虫ブロック・不動産）、屋号スマホドクター静岡葵、インフィニティ∞（2023/10〜）、守成静岡会場代表、宅建士等資格、家族・趣味、目標（1,000/2,000回線・400/600取扱店）を統合。議事録は会後追記。','2026-05-30 13:35:23','2026-06-04 10:53:02'),
(50,1,37,143,NULL,'89131000556','PXefpCDtQfa6IVkp6a9ohA==','zoom','2026-05-21 11:00:00','2026-05-21 11:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(52,1,37,144,NULL,'87313500925','TXIaXTwPQaiXBiKVTc9pfA==','zoom','2026-05-19 17:00:00','2026-05-19 17:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(53,1,37,145,NULL,'86985144664','j3BnDbqfRRu5kHrKvgax6g==','zoom','2026-05-19 16:00:00','2026-05-19 16:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(59,1,37,53,NULL,'82431536307','4ycbbif/RP29DE6HgPlDoQ==','zoom','2026-05-08 18:00:00','2026-05-08 18:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(60,1,37,13,NULL,'82219483510','kuFarPqvSbyZcnkZhlebpA==','zoom','2026-05-08 17:00:00','2026-05-08 17:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(62,1,37,146,NULL,'82336493242','OKWxBvjsTPyTZfh1Fk7/NA==','zoom','2026-05-07 09:00:00','2026-05-07 09:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(63,1,37,147,NULL,'82098291556','w04V3WLZTqOdBPBRLddqYA==','zoom','2026-05-01 17:00:00','2026-05-01 17:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(64,1,37,17,NULL,'82144696668','hSM5Q+RMS5C8RhTSLcRR8Q==','zoom','2026-05-01 14:00:00','2026-05-01 14:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(65,1,37,148,NULL,'86886689396','HIJgRFSzQeKajNVl/0ci9Q==','zoom','2026-05-01 09:00:00','2026-05-01 09:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(66,1,37,12,NULL,'85842362927',NULL,'zoom','2026-06-04 15:00:00','2026-06-04 15:00:00','2026-06-04 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nishiura_miyabi_draci.md】\n\n# 1to1_西浦雅_Draci\n\n---\n\n**文書の位置づけ:** BNI DragonFly メンバー・西浦雅さんとの 1to1 を **1ファイルで時系列管理**する。  \n**整理:** tugilo（次廣 淳）× **BNI DragonFly** — **クライアント案件（Draci / WordPress 会員サイト改善）** の進捗報告・運用設計の協議を中心に記録。  \n**日時:** 第1回 **2026-06-04（水）JST 15:00–16:00** 実施済み（途中 PC 切替のため再接続あり）。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **66**\n\n**案件の位置づけ**\n\n| 項目 | 内容 |\n|------|------|\n| **プロジェクト名** | **Draci**（WordPress 会員サイト改善） |\n| **主な依頼元** | 西浦雅さん（実運用担当）、平岡国彦さん（チャプター代表・名義上のアカウント保持者） |\n| **次廣の役割** | 掲示板機能実装、プラグイン整理、アカウント体系の再設計 |\n| **関連提案** | [`wordpress_bulletin_client_proposal_skeleton.md`](../../proposals/wordpress_bulletin_client_proposal_skeleton.md) |\n| **追加費用** | 今回合意した作業は **既存プロジェクトに含め、追加費用なし** |\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ BNI DragonFly 会員名簿ベース。\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 西浦 雅（にしうら みやび） |\n| **カテゴリー** | 中小企業サポート |\n| **専門** | 外構工事特化型SNS集客 |\n| **チャプター役職** | ビジターホストCo・エデュケーションCoサポート・OCCサポート |\n| **BNI との接点** | DragonFly 内の実務担当。平岡代表名義の WordPress 運用を西浦さんが実質担当 |\n| **次廣との接点** | Draci（WordPress）改善案件の窓口、寺田直史さん（Tifonet）紹介元 |\n\n---\n\n## ■ サマリー（最新状況）\n\n- **関係性:** 第1回 121 実施済み（2026-06-04）。Draci 掲示板の **基本実装完了・テストサーバー確認段階**、**3層アカウント管理体系** の方針合意。\n- **決定:** 平岡氏アカウントを **通常メンバー相当** に降格、**システム管理用アカウントを1つ新設**（複数人同時ログイン可）。掲示板は **テストサーバーで西浦さん確認** → フォント変更・スマホ表示改善。**支部検索** を来週中実装目標。\n- **次アクション:** **次廣** — テストサーバーリンク送付（当日〜翌日）、アカウント分離設定、支部検索調査・実装、フォント変更。**西浦** — テストサーバーで掲示板確認・FB。**明後日** 西浦さん参加予定（翌日は不在）。\n\n---\n\n## ■ 1to1 履歴\n\n### 【第1回】2026-06-04\n\n#### 基本情報\n\n- **日時:** 2026-06-04（水）JST **15:00–16:00**\n- **実施方法:** Zoom（西浦さんがレコーディング。次廣が画面共有。途中 PC 切替のため一度切断・再接続）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **66**\n- **主題:** ① Draci 掲示板機能の進捗報告 ② WordPress **3層アカウント管理** の説明・合意\n\n---\n\n#### ■ パートA — 3層アカウント管理体系\n\n##### 背景・現状の課題\n\n| 論点 | 内容 |\n|------|------|\n| **平岡氏のアカウント** | 現状、WordPress **管理画面全体** にアクセス可能 |\n| **平岡氏の意向** | 管理作業は **一切したくない・触りたくない** |\n| **実運用** | ログイン情報は **西浦さん** に渡され、西浦さんが実質的な管理を担当 |\n| **次廣の懸念** | 以前から「平岡氏がこの権限状態で運用できるのか」と疑問を持っていた |\n\n##### 合意した3層構成\n\n| 層 | アカウント種別 | 権限・用途 |\n|----|----------------|------------|\n| **1** | **ドレスシー管理者アカウント**（平岡氏用） | 会員の **承認管理など限定的な機能のみ**。通常メンバーと同様の **ログイン専用** に変更 |\n| **2** | **WordPress システム管理アカウント** | テーマ・設定など **技術的管理機能**。システムを動かす人専用。**1アカウントで十分**（複数人が同時ログインして作業可能） |\n| **3** | **通常メンバーアカウント** | 一般ユーザー向けの標準アクセス。プロフィール自己編集・掲示板利用等 |\n\n##### 決定事項\n\n- **アカウント体系の分離:** 平岡氏のアカウントを通常メンバーと同様の **ログイン専用** にし、別途 **システム管理用アカウント** を作成する\n- **管理画面へのアクセス制限:** 平岡氏は WordPress 管理画面を **一切触らない**。システム運用者向けログインを **別途用意**\n- **管理者アカウント数:** システム管理用は **1つで十分**（複数人同時ログイン可）\n- **作業の無償提供:** 提案書に基づく作業は **既存プロジェクトに含め、追加費用なし**\n- **権限設計の考え方:** 管理画面は普段使わない想定。誤操作防止のため不要機能へのアクセスを制限\n\n##### 会員登録フロー（現状）\n\n1. 新規メンバーが **LINE** で登録申請\n2. **Myria-mu** 側でオリエンテーション\n3. ユーザー枠を作成し **パスワードを発行**\n4. メンバーに情報を渡し、**自分でプロフィールを作成**（Nキャスト方式）\n5. **西浦さん** がユーザー作成〜パスワード発行まで担当。**平岡氏は登録プロセスに直接関与していない**\n\n##### 確認待ち・技術検討\n\n| 項目 | 状態 |\n|------|------|\n| **同一アカウントでの同時ログイン時のバッティング** | 次廣が確認中（「大丈夫だと思う」が **未検証**） |\n| **具体的な権限設定の詳細仕様** | 今後詰める |\n\n##### アクション（アカウント）\n\n| 担当 | 内容 |\n|------|------|\n| **次廣** | WordPress アカウント管理体系を **3種類に分離** して設定 |\n| **次廣** | 平岡氏用権限を **通常メンバーレベル** に変更 |\n| **次廣** | **システム管理用アカウントを1つ** 新規作成（複数作成も可） |\n| **次廣** | **西浦さんと一緒に** アカウント整理作業を実施 |\n\n---\n\n#### ■ パートB — Draci 掲示板・支部検索の進捗（再接続後）\n\n##### 主な成果\n\n- **掲示板機能の基本実装が完了** し、**テストサーバーでの確認段階** に到達\n- 西浦さんから **当初想定より早い完了** について高評価\n- **プラグインなし** で基本機能を実装できたことが成功要因として共有された\n- **支部検索機能** が新規要件として浮上。**来週中の実装** を目指す\n\n##### 完了した機能（掲示板）\n\n| 機能 | 状態 |\n|------|------|\n| **カテゴリー選択・投稿・添付ファイル** | 実装済み |\n| **カテゴリー検索** | 別画面で実装。検索結果を下部表示 |\n| **スマートフォン対応** | 表示最適化が必要な箇所を特定 |\n| **基本仕組み** | 見た目調整は残るが **機能要件は充足** |\n\n##### 決定事項（掲示板・支部）\n\n| 決定 | 内容 |\n|------|------|\n| **テスト公開** | 次廣がテストサーバーを構築し、西浦さんからアクセス可能にして要件確認 |\n| **フォント変更** | 現状の明朝体から **別フォントへ**（西浦さん要望） |\n| **支部検索** | ユーザー管理画面に **支部選択項目** を追加。会員紹介ページで **支部による絞り込み** |\n| **検索仕様** | **単一選択**（チェックボックス式ではない）。1支部選択で該当メンバーのみ表示。未選択時は **全国表示** |\n| **支部と地域の関係** | 掲示板の **地域選択** と会員管理の **支部** は **別概念** と確認 |\n\n##### 新規要件: 支部検索機能\n\n**背景:** 支部が今後設立されていく予定。メンバーに支部情報をタグ付けしておくと将来の管理が容易。\n\n**ユーザー管理側**\n\n- ユーザー編集画面に **支部選択項目**（プルダウン想定）\n- **カスタムフィールド** で支部情報を拡張する可能性\n\n**会員紹介ページ側**\n\n- 各メンバー表示に **支部情報** を追加（アイコン・名前・HP に加えて）\n- 左側に **支部検索**（掲示板カテゴリー検索と同様の UI）\n- 支部未選択時は全国メンバー表示\n\n**未確定**\n\n- 支部名称（東京支部等）は **今後決定**\n- WordPress ユーザー管理の拡張・カスタムフィールド／プラグインの選定は調査中\n\n##### 確認待ち\n\n| 項目 | 内容 |\n|------|------|\n| **掲示板の要件充足** | テストサーバー公開後、西浦さん側で実要件を満たしているか確認 |\n| **支部名称** | 具体名は未確定 |\n\n##### アクション（掲示板・支部）\n\n| 担当 | 期限目安 | 内容 |\n|------|----------|------|\n| **次廣** | **当日〜翌日** | 掲示板 **テストサーバーリンク** を西浦さんへ送付 |\n| **西浦** | リンク受領後 | テストサーバーで掲示板確認し **修正点を FB** |\n| **次廣** | **来週中** | 支部検索の実装方法を調査・実装 |\n| **次廣** | — | 掲示板 **フォント変更** |\n| **次廣** | — | **スマートフォン表示** の見やすさ改善 |\n| **次廣** | — | 掲示板追加に伴う **レイアウトずれ** の修正 |\n\n##### 次回確認\n\n- **明後日:** 西浦さん参加予定（**翌日は不在**）\n- テストサーバー確認後の **詳細 FB**\n- **来週中:** 支部検索の実装状況確認\n\n---\n\n#### ■ その他の議論（文脈メモ）\n\n##### WordPress 構成・開発体制の課題（西浦さんからの継続要望）\n\n| 論点 | 内容 |\n|------|------|\n| **プラグイン過多** | 動作が重い。基本機能は **余計なプラグインなし** で実装可能 |\n| **セキュリティプラグイン** | 過去にメール配信等のトラブルを引き起こした |\n| **倉本氏の実装** | 高度すぎて他メンバーが運用困難。ユーザー目線の設計になっていない |\n| **データ混在** | 独自コードにより朝礼スライド等で新旧データ混在のトラブル |\n| **簡素化要望** | 倉本氏以外が **トラブル時も自己解決できる** 程度の簡素化を西浦さんは継続要望（未実現） |\n| **ウェブマス** | 松本氏・今井氏も早期体制変更を望む。西浦・太田氏等はウェブマス参加を断り続けている |\n\n##### 次廣のウェブマス参画\n\n- 次廣が **ウェブマスチームに参加** し、**2026-06-03 から** 徐々に業務引き継ぎ開始（朝礼スライド作成等）\n- 関連: [`webmaster_handover_20260603.md`](../webmaster/webmaster_handover_20260603.md)\n\n##### 雑談・環境メモ\n\n- 次廣は Zoom で豪華ホテル風背景。西浦さんは「圧を強めたい日」に使うと発言\n- 西浦さんの iPad が息子のゲーム用になり仕事で使えない。打合せメモは iPad で殴り書き\n- 打合せ中 Wi-Fi 問題あり、西浦さんが切替対応\n\n---\n\n## ■ 累積インサイト\n\n- **西浦さん = 実務のハブ:** 平岡代表名義でも、WordPress・会員登録の **実運用は西浦さん**。アカウント整理も **西浦さんとペア** で進めるのが自然。\n- **平岡氏の権限最小化は合意済み:** 「触らせない」が正式な運用方針。提案書作業は **追加費用なし** でプロジェクト内対応。\n- **掲示板は評価良好:** 早い進捗・プラグイン最小化が刺さっている。次の品質ゲートは **テストサーバー上の西浦さん FB**。\n- **支部検索は将来拡張の布石:** 名称未確定だが、ユーザー属性＋紹介ページ UI の両方に載せる方針で来週実装。\n- **LTST／旧 WordPress 資産:** 簡素化・引き継ぎ可能な設計への不満は継続テーマ。Draci 改善が **対照的な成功例** として位置づけられている。\n\n---\n\n## ■ 関連リンク・参照\n\n| 種別 | パス |\n|------|------|\n| 提案骨子 | [`docs/proposals/wordpress_bulletin_client_proposal_skeleton.md`](../../proposals/wordpress_bulletin_client_proposal_skeleton.md) |\n| 要件定義 | [`docs/requirements/wordpress_bulletin_and_plugin_reorganization_requirements.md`](../../requirements/wordpress_bulletin_and_plugin_reorganization_requirements.md) |\n| Webマス引き継ぎ | [`docs/meetings/webmaster/webmaster_handover_20260603.md`](../webmaster/webmaster_handover_20260603.md) |\n| 西浦さん紹介 121 | [`1to1_terada_tifonet_engineer_collaboration.md`](1to1_terada_tifonet_engineer_collaboration.md) |\n\n---\n\n## ■ 変更履歴\n\n| 日付 | 内容 |\n|------|------|\n| 2026-06-04 20:11 JST | 初版作成。Zoom 要約（アカウント管理＋掲示板進捗・再接続後）を反映。 |','2026-06-04 01:43:27','2026-06-04 21:12:40'),
(67,1,37,51,NULL,'81031997027',NULL,'zoom','2026-06-10 15:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-04 01:43:27','2026-06-04 01:43:27'),
(68,1,37,117,NULL,'85299085926',NULL,'zoom','2026-06-11 14:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-04 01:43:27','2026-06-04 01:43:27'),
(69,1,37,50,NULL,'82538110131',NULL,'zoom','2026-06-12 09:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-04 01:43:27','2026-06-04 01:43:27'),
(70,1,37,48,NULL,'82306905507',NULL,'zoom','2026-06-12 10:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-04 01:44:30','2026-06-04 01:44:30'),
(71,1,37,163,NULL,NULL,NULL,'manual','2026-06-04 11:00:00','2026-06-04 11:00:00','2026-06-04 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kakiya_naoto_dock.md】\n\n# 1to1_垣谷直人_dock.\n\n---\n\n**文書の位置づけ:** BNI カーネル（KerNel）チャプター・垣谷直人さんとの 1to1 を **1ファイルで時系列管理**する。  \n**整理:** tugilo（次廣 淳）× **BNI カーネル** クロスチャプター。SEOコンサルタント（コンバージョン・CRO重視）× tugilo の AI業務改善・予約管理システムの協業・相互紹介を確認した。  \n**接点の経緯:** [**田村広大**](1to1_tamura_kodai_money_cooking.md) さん（カーネル）第1回 1to1（2026-05-07）で「SEOコンサルタント紹介」を約束 → 本セッション。  \n**日時:** 第1回 **2026-06-04（水）JST 11:00–12:00** 実施済み（Zoom 予定60分）。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **71**（相手 member `id=163`・BNI カーネル）  \n**NCAS:** [Myプロフィール (kernel)](https://ne001.ncas.jp/bni_meibo/viewsheets.php?id=cTdrQWl2aUhmbDhKdDQyeFZlS3ltdz09&chapter=ZHZIdEZYMUpuYk1jWjMyZXBmTUdtUT09)\n\n**表記ゆれ（解消済み）**\n\n| 出典 | 表記 |\n|------|------|\n| NCAS・正式 | **垣谷 直人**（かきや なおと） |\n| Zoom 文字起こし要約 | **柿谷**（誤変換） |\n\n---\n\n## ■ 基本プロフィール（NCAS ＋ 第1回要約）\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 垣谷 直人（かきや なおと / Kakiya Naoto） |\n| **所属チャプター** | BNI **KerNel**（カーネル） |\n| **会社** | **合同会社 dock.**（代表） |\n| **社名の由来** | 舞鶴の港町出身・ボート競技経験。「dock」＝船を修理する施設。社会の荒波に立ち向かう企業（船）を全力サポート |\n| **カテゴリー** | SEOコンサルタント（SEOconsultant） |\n| **BNI 役職** | メンバーシップ委員会（**チャプターデベロップメント**） |\n| **BNI 入会** | **2025-01-14**（宣誓式）。2019年頃から BNI 認知。個人事業主時代の知り合いライターが BNI 入会後に多くのリファラルをくれ、BNI 未入会なのに売上500万円を達成したため、独立後に満を持して入会 |\n| **経験年数** | 現ビジネス **10年目**（NCAS）。法人設立は第1回要約ベースで約1年 |\n| **紹介者** | [**田村広大**](1to1_tamura_kodai_money_cooking.md)（お金の料理教室／BNI カーネル） |\n| **拠点** | **京都府京都市下京区**（〒600-8824）。出身: **京都府舞鶴市** |\n| **連絡先** | Tel **080-2456-2420**／`kakiya@dock.boats`／[Facebook](https://www.facebook.com/naoto.kakiya) |\n| **ホームページ** | NCAS 上は未登録 |\n\n### コンセプト・専門（NCAS）\n\n> **【名刺代わりのサイトを売上が上がる Web サイトに】**  \n> SEO を中心に Web マーケ。特に **コンテンツ領域** と **集客後の導線設計（CRO）** が得意。順位より **売上につながる指標** を重視。\n\n**スキル（NCAS）:** 順位にとらわれない SEO／CRO（サイト内導線設計）／EFO（問い合わせフォーム最適化）\n\n**他社にない強み（NCAS）**\n\n1. スタッフ全員が自身で Web サイト運用経験あり → 知識だけでなく実体験ベースのコンサル\n2. 施策提示だけでなく、制作会社へのディレクション・実務も一部巻き取り → クライアントリソース最小化\n\n### 事業概要\n\n| サービス | 内容 |\n|----------|------|\n| **SEOコンサルティング** | B2B 無形商材中心。順位・アクセスより **問い合わせ・購入（コンバージョン）** を重視 |\n| **HP制作会社向け SEO顧問** | 制作会社が他社と差別化し、顧客から選ばれやすくするための黒子支援（第1回要約） |\n| **その他** | MEO・Web サイト制作も提供実績あり（NCAS 顧客リスト） |\n\n**実績（NCAS G.A.I.N.S. ＋ 第1回要約）**\n\n| 案件 | 成果 |\n|------|------|\n| 24時間365日卓球マシン専用無人卓球場 | 会員登録 **411%増**（1年6ヶ月） |\n| 広告代理店オウンドメディア | 月間問合せ **400%増**（1年6ヶ月） |\n| OEM（オリジナルグッズ制作） | 月間アクセス **296%アップ**（1年） |\n| システム開発会社 | 月間問合せ **1件→10件**（1年） |\n| 卓球場FC（タクトル等・要約） | 2年半で新規会員大幅増 |\n| 支援企業数 | **60社超**（要約） |\n\n**対応業界:** BtoB／BtoC／FC本部／オウンドメディア／EC／HR／専門学校／食品／スポーツ／M&A／美容 等\n\n**メディア・登壇:** プレジデント舞鶴（2025-02）／北近畿経済新聞（2025-06）／ランサーズオンラインセミナー（2025-12）／舞鶴ドリームピッチ審査員（2026-03）\n\n### HP制作会社向け SEO顧問（第1回要約・詳細）\n\n| 項目 | 内容 |\n|------|------|\n| **提供価値** | 制作会社の単価アップ・成約率向上・保守管理獲得 |\n| **内容** | 月1定例＋チャット。GA・GSC レポートを制作会社がクライアントへ納品。提案・営業方法も共同設計。補助金会社連携 |\n| **料金** | 垣谷氏 → 制作会社: 月額 **5万〜10万円**（3プラン） |\n| **独自性** | 全国でも制作会社向け SEO 顧問はほぼ存在しない |\n\n### 直近顧客例（NCAS・業種のみ）\n\n印刷（関東・500名以上）／AI活用税理士法人（大阪）／SNS広告代理店（京都）／AI×DXシステム開発（東京）／OEMメーカー（関西）／卓球FC本部（東北）／文房具卸（関西）／BtoB観葉植物EC（関西）／物販スクール（群馬）／専門学校（全国）\n\n**顧客の入り方:** 基本 **紹介**（交流会・コワーキング・友人の会社）\n\n### 個人・家族（NCAS ＋ 第1回）\n\n| 項目 | 内容 |\n|------|------|\n| **高校** | ボート競技・**全国大会3回**。パラリンピック選手にボート指導。香取慎吾・小池百合子・浅田真央にも指導経験 |\n| **大学** | 体育系。体育教師 or スポーツトレーナー志望 |\n| **SEOとの出会い** | 大学時代グルメブログ → 検索流入分析 |\n| **職歴（NCAS）** | 焼肉・居酒屋・バー・マッサージ・花屋・精肉・ラーメン・おでん／Webライター／オウンドメディア責任者／MEO・SEOコンサル |\n| **職歴（要約）** | わかさ生活（3ヶ月）→ フリーランスライター2年 → 広告代理店 → 渋谷SEO代理店（ソフトバンク・楽天・リナックス等）→ 滋賀アウトドア（カフェ店長・残業1000h・**弁護士相談中**）→ 独立 |\n| **家族** | 配偶者なし。還暦前に退職金でセカンドライフの母・おばんざい屋勤務の弟 |\n| **趣味** | 外食・料理・銭湯・サウナ・釣り・筋トレ。毎朝6:30起床・7時ジム（要約） |\n| **その他** | 脱毛開始。Claude Code 触っている。**KerNel メンバー中心の大阪野球チーム** |\n| **強い願望** | やりたいことを、やりたいときに、やりたい人とできる人生 |\n| **成功の鍵** | できるまでやる。向いていない・やりたくないと思ったら即辞める（※やるべきことはやる） |\n\n---\n\n## ■ G.A.I.N.S.（NCAS 要約）\n\n| 項目 | 要点 |\n|------|------|\n| **Goal** | 成果に繋がる SEO の普及（順位イメージの払拭）／Webマーケスクール事業／東京会社員向けスナック／舞鶴に海で遊べる施設 |\n| **Accomplishments** | 上記実績・メディア登壇 |\n| **Interests** | 経営者の独立きっかけ・仕事を選んだ背景 |\n| **Networks** | ブランディング・SNS・税理士・サロン支援・求人制作・工務店ライター等（NCAS に具体名記載） |\n| **Skills** | SEO／CRO／EFO |\n\n---\n\n## ■ リファーラル設計（NCAS Contact Circle）\n\n### コンタクトサークル Top3\n\n1. **広告代理店**（Web系 or 総合）\n2. **HP制作会社**\n3. **Web に参入したい印刷会社**（紙以外も提案したい）\n\n### コンタクトサークル（10）\n\n広告代理店／Web制作／Web参入印刷／**システム開発会社**／Webディレクター／Web広告運用／ブランディング／FCコンサル／経営コンサル／営業コンサル\n\n### 質の高いリファーラル\n\n- 大手・上場サイト制作経験の Web 制作会社代表\n- 10店舗以上 FC 本部コンサル\n- Web 参入したい印刷会社\n- 商品企画・開発に携わる方\n- 電通／博報堂／リクルート出身\n\n### 不適切なリファーラル（NCAS 明記）\n\n- 駆け出し Web 制作者・デザイナー・ライター（**実務3年未満**）\n- **MEO の方**\n- **コーチングの方**\n\n※第1回要約では MEO 業者を次廣へ紹介する旨の合意あり → **121内の相互紹介** と **BNI プロフィール上の不適切リファーラル** は文脈が異なる。紹介時は垣谷さんに確認。\n\n### 紹介の切り口（NCAS）\n\n- 「Web 全般に詳しい SEO の人がいますよ」\n- 「大手・上場企業も対応した SEO の人がいますよ」\n\n### 理想顧客（NCAS）\n\n商圏制限なし・全国展開・無形商材・EC／Web 問合せ増・Web 担当退職で回らない／高角度リストで営業効率化\n\n---\n\n## ■ サマリー（最新状況）\n\n- **2026-06-04** 初回121（田村広大さん紹介）。DragonFly × カーネルのクロスチャプター接点。\n- **相互理解:** 次廣の AI業務改善・伴走型システム開発と、垣谷氏のコンバージョン重視 SEO・HP制作会社向け顧問モデルを共有。\n- **協業の芽:** **予約管理システム × SEO/MEO** でホットペッパー代替。HP制作会社向け **システム開発＋SEO顧問** セット。\n- **相互紹介合意:** 垣谷氏 → 業務改善コンサル、建設・製造、MEO業者。次廣 → HP制作会社、**システム開発会社**（垣谷氏 Contact Circle #4 と一致）、静岡協業先。\n- **共通人脈:** 静岡県内に山田・原田・福沢・小永・深澤等。\n- **次回:** 日時未定。資料共有・紹介先リスト・協業パッケージ詳細。\n\n---\n\n## ■ 協業仮説（第1回時点）\n\n### 1. ホットペッパー代替パッケージ\n\n| 要素 | 役割 |\n|------|------|\n| 次廣 | LINE連携予約管理（事業者目線・AI提案型・夏頃リリース） |\n| 垣谷氏 | SEO / MEO・GBP 連携マーケ |\n| 価値 | 自社システムで獲得した顧客へのサービス提供（一見さん依存からの脱却） |\n\n### 2. HP制作会社向けセット提案\n\n| 要素 | 役割 |\n|------|------|\n| 次廣 | システム開発（予約・業務改善等） |\n| 垣谷氏 | SEO顧問（黒子）＋CRO／EFO |\n| 顧客 | HP制作会社（垣谷氏 Top3 ＋ 次廣のデザイナー協業） |\n\n### 3. システム開発会社チャネル\n\n- NCAS 直近顧客に **AI×DXシステム開発（東京）** あり。問合せ 1→10件/年の実績。\n- 次廣の **伴走型業務改善** と垣谷氏の **SEO/CRO** は、システム開発会社のクライアント向け **セット提案** に相性良い。\n\n---\n\n## ■ 次廣側プロフィール（第1回共有・相手への理解用）\n\n| 項目 | 内容 |\n|------|------|\n| **屋号** | ヤノツギロ |\n| **カテゴリー** | AI業務改善システム構築 |\n| **経験** | SE 26年目、独立23年 |\n| **拠点** | 静岡県藤枝市 |\n| **予約管理** | 夏頃リリース。ホットペッパー代替。事業者目線・AI提案型 |\n\n**金のガチョウ:** ウェブデザイナー、**SEO/MEO業者**、業務改善コンサル、建設・製造 等\n\n---\n\n## ■ 共通の知見（第1回）\n\n| テーマ | 内容 |\n|--------|------|\n| **SEOとCV** | 順位より反応（コンバージョン）が本質 |\n| **効果期間** | 半年〜1年（業界による） |\n| **デザインとCV** | デザイン変更も積極提案。制作会社と必ず協働 |\n| **法人化** | 売上・依頼しやすさ vs 固定費・手元資金 |\n\n### 静岡県内の共通人脈\n\n山田（元サンダーボルト・休会中）／原田（DragonFly・協業中）／福沢・小永（協業中）／深澤\n\n---\n\n## ■ tugiloとしての戦略\n\n- **田村さん紹介 SEO が着地。** Contact Circle **#2 HP制作・#4 システム開発** と次廣の紹介軸が **NCAS 上も一致**。\n- **予約管理 GTM:** 神保・辻・原田・山本ルートと並行。垣谷氏は **CRO/EFO** まで踏み込むため「集客→CV→予約」一気通貫のストーリーが作れる。\n- **紹介文:** 「順位 SEO」ではなく **問い合わせ・売上・予約が増える Web マーケ**（NCAS コンセプトと一致）。\n- **AI 共通言語:** Claude Code 利用・直近顧客に AI 税理士・AI×DX 開発会社 → 次廣の AI 業務改善と紹介文が作りやすい。\n- **注意:** NCAS では MEO 紹介を「不適切」と明記。121 合意の MEO 紹介は **個別関係・協業文脈** として確認してから進める。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣 → 垣谷氏\n\n| 優先 | 像 |\n|:---:|-----|\n| ★ | **HP制作会社**（DragonFly 新規ウェブデザイナー含む） |\n| ★ | **システム開発会社**（HP も作れる・AI×DX） |\n| ○ | 静岡県内協業先 |\n\n### 垣谷氏 → 次廣\n\n| 優先 | 像 |\n|:---:|-----|\n| ★ | 業務改善コンサル、建設・製造（システム化） |\n| ○ | MEO 業者（121 合意・要確認） |\n\n**紹介文たたき台（次廣 → 垣谷氏）**\n\n> 垣谷さんは、順位や PV ではなく **問い合わせ・成約・売上** を上げる SEO コンサルです。合同会社 dock. の代表で、大手・上場も経験。HP 制作会社向け SEO 顧問（黒子）もやっており、CRO・フォーム最適化まで踏み込みます。「名刺代わりのサイトを売上が上がる Web サイトに」がコンセプトです。\n\n**紹介文たたき台（垣谷氏 → 次廣）**\n\n> 次廣さんは、現場のやり方を大きく変えず Excel や LINE のバラバラ管理を一つの流れにまとめるシステムを作る人です。予約管理（ホットペッパー代替）も夏頃出ます。SEO で集客した先の予約・問合せ・現場オペまでつなげたい制作会社・システム開発会社に相性が良いです。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **成果一筋。** NCAS も Zoom 要約も「順位 SEO のイメージ払拭」が Goal。\n- **ボート・筋トレ・野球・サウナ** — アクティブ。Claude Code も触っている。\n- **率直な法人化トーク**（手元資金）で信頼良好。\n- **dock. の社名ストーリー**（港・ボート）は紹介時の記憶フックになる。\n- カーネル **CD MS** — チャプター横断の紹介力あり。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-06-04 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-04（水）JST 11:00–12:00**\n- **実施方法:** Zoom\n- **紹介:** [**田村広大**](1to1_tamura_kodai_money_cooking.md) さん\n- **Religo 1to1 レコード:** `one_to_ones.id` = **71**（相手 member `id=163`・BNI カーネル）\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| 紹介（垣谷→） | 業務改善コンサル、建設・製造、MEO業者 |\n| 紹介（次廣→） | HP制作会社、システム開発会社、静岡協業先 |\n| 協業 | 予約管理＋SEO/MEO、HP制作会社向けシステム＋SEO顧問 |\n| 次回121 | 日程未定 |\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 垣谷氏 | MEO・業務改善・建設・製造の紹介先確認・連絡 | TODO |\n| 次廣 | HP制作・システム開発の紹介先確認・連絡 | TODO |\n| 両者 | 資料共有・協業パッケージ具体化 | TODO |\n| 次廣 | Religo 登録・`one_to_ones.id` 反映 | TODO |\n| 次廣 | 田村さんへ SEO 紹介完了の一声 | TODO |\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **正式名は垣谷直人・合同会社 dock.** Zoom「柿谷」は誤変換。\n- **Contact Circle #2 HP制作・#4 システム開発** が次廣の紹介軸と直結。NCAS 直近顧客の AI×DX 開発会社は **橋渡し候補**。\n- **CRO/EFO** までカバー → 予約管理システムの「CV 改善」パートナーとして最優先クラス。\n- **MEO:** NCAS 不適切リファーラルと 121 合意の両立 → 紹介前に垣谷さん確認。\n- **田村さん紹介3名:** SE（下辻）✓／SEO（本件）✓／FC **TODO**。\n\n---\n\n**更新履歴**\n\n| 日時（JST） | 内容 |\n|-------------|------|\n| 2026-06-04 12:24 | 初版（Zoom要約）。ファイル名 `1to1_kakiya_seo_consultant.md` |\n| 2026-06-04 12:35 | NCAS プロフィール反映。正式表記 **垣谷直人**・**合同会社 dock.**。G.A.I.N.S.・Contact Circle・顧客例・連絡先。リネーム `1to1_kakiya_naoto_dock.md` |','2026-06-04 12:34:16','2026-06-04 12:34:19'),
(72,1,37,164,NULL,NULL,NULL,'manual','2026-06-04 14:00:00','2026-06-04 14:00:00','2026-06-04 15:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_endo_satomi_mirai_realestate.md】\n\n# 1to1_遠藤聡美_みらい不動産\n\n---\n\n**文書の位置づけ:** **BNI SILVIS** メンバー・遠藤聡美さんとの 1to1 を **1ファイルで時系列管理**する。NCAS（Myプロフィール **silvis**）に、**トレーニングでの既知関係**と初回セッション内容を統合（2026-06-04）。  \n**整理:** tugilo（次廣 淳／**BNI DragonFly**）× **BNI SILVIS** — **クロスチャプター**。  \n**既知の関係:** **BNI トレーニングで何度も同組** — 初対面感は薄い。本日は **本格的なビジネス1to1** として相互理解・紹介条件を言語化する。  \n**日時:** 第1回 **2026-06-04（水）JST 14:00–15:00**（予定。終了時刻・実施方法は会後に確定）。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **72**（相手 member `id=164`・**BNI SILVIS** `workspaces.id=11`）\n\n**同姓「遠藤」との区別（誤紹介防止）**\n\n| 氏名 | カテゴリー | 備考 |\n|------|------------|------|\n| **遠藤 聡美**（本件） | シングルマザー専門住宅購入アドバイザー | **BNI SILVIS**・みらい不動産・水戸／ひたちなか・11期 |\n| 遠藤 哲也 | 経営者マッチング | **DragonFly ビジター**（第210回 2026-06-02）。ユニオンプラス。**別人・別チャプター** |\n\n---\n\n## ■ 基本プロフィール（固定情報）\n\n※ [NCAS プロフィール](https://ne001.ncas.jp/bni_meibo/viewsheets.php?id=NUN4RWw3aGl5SFNJQWlqeHBHVFUvUT09&chapter=bzlaQzRNTEExZ2x1dk1vUjUvVFdOUT09) ベース。\n\n### 人物・会社\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 遠藤　聡美（えんどう　さとみ）／旧姓 高子／1987年7月18日生まれ・A型 |\n| **ローマ字** | Endo Satomi |\n| **会社** | **株式会社みらい不動産**（不動産部） |\n| **専門（BNI表記）** | シングルマザー専門住宅購入アドバイザー（英: Housing Advisor for Single Mothers） |\n| **専門（詳細）** | 空き家転貸・不動産売買・シングルマザーの住宅相談 |\n| **経験年数** | 現在のビジネス **3年** |\n| **BNI** | **SILVIS**（NCAS 表記: silvis）／**【11期】1to1**／入会（宣誓式）**2025-11-12** |\n| **連絡先** | 029-239-3109 ／ mirai.realestate7678@gmail.com ／ https://mamabuyhome.com/ |\n\n### 家族・ライフ\n\n| 項目 | 内容 |\n|------|------|\n| **配偶者** | なし |\n| **家族** | ペット専門学校に通う娘（19歳）、商業高校に通う息子（16歳） |\n| **出身・居住** | 出身: 茨城県ひたちなか市／居住: ひたちなか（33年。婚姻中は日立市） |\n| **趣味** | 占い（宿曜・数秘）、カラオケ（宇多田・安室・浜崎・MISIA） |\n| **関心事** | ネイル、スタミナラーメン、着物、開運アクション、都市伝説 |\n| **強い願望** | 占いバーの開業、家系図作成 |\n| **誰も知らない私** | レイテ沖戦・駆逐艦早霜の生存者の子孫 |\n| **成功の鍵** | 何事もとりあえずやってみる。失敗はチャレンジした証 |\n\n### 経歴（略歴シートより）\n\nコンビニ（セイコーマート）→ 魚屋 → スナック → バス添乗員 → 専業主婦 → バリスタ（タリーズ・**2ヶ月でリーダー**）→ 火加工作業員 → 民泊清掃員 → カフェバー → **不動産（現職）**\n\n### メンバーからのありがとう（温度感）\n\n| 日付 | 投稿者 | 要点 |\n|------|--------|------|\n| 2026-02-15 | 山口幸夫 | 入会3ヶ月で **チームリーダー** として責任感。明るさ・ハキハキ・影響力あるリーダー。ビジョン・目標がしっかり |\n\n---\n\n## ■ 事業理解（みらい不動産）\n\n### 何を提供しているか\n\n- **シングルマザー向け住宅購入**の専門アドバイス（ローン難易度の高い案件でも実績あり）。\n- **空き家転貸モデル:** 使われない空き家を借り入れ、蘇らせて貸し出し、借り家賃と貸し家賃の差額を収益化する「新しい空き家活用」。\n- **不動産売買仲介**に加え、**中古住宅の購入〜リフォーム**までワンストップ。\n- **複数収益経路:** 売買だけでなく空き家転貸・アイサロン経営など（ONE to ONE シート）。\n\n### 理想顧客・切り出し（ONE to ONE より）\n\n| 像 | 内容 |\n|----|------|\n| 空き家オーナー | 転貸収益に興味がある／維持管理に困っている |\n| シングルマザー | 住宅購入を検討している |\n| 話の切り口 | 「資産にせず安定収入を増やす空き家活用」— 借り入れ→蘇生→貸し出しの差額ビジネス |\n\n### 定量実績（G.A.I.N.S. Accomplishments より）\n\n| 項目 | 内容 |\n|------|------|\n| 新築建売 | **2ヶ月で11契約** |\n| ローン | 他社で難しいとされたお客様でもローン付け成功 |\n| 中古 | 購入〜リフォームワンストップ |\n| その他 | PTA役員通算6年、バリスタ2ヶ月でリーダー、添乗員時代の勤務耐性 |\n\n### 目標（G.A.I.N.S. Goal）\n\n| 時期 | 内容 |\n|------|------|\n| 2030 | シングルマザー住宅購入サポート **全国47都道府県制覇** |\n| 2027 | **シンママコミュニティ**立ち上げ |\n| 中長期 | シングルマザー専用アパートメントの管理・運営 |\n| 2028 | ウズベキスタンへ行く |\n\n### ネットワーク・スキル（紹介設計の材料）\n\n| 区分 | 内容 |\n|------|------|\n| 施工・不動産周辺 | 現場監督、畳屋、設備屋、電気屋、ハウスクリーニング、損害保険、外壁塗装、住宅ローン金融機関、司法書士、弁護士 |\n| ウェルネス・占い | 占い師、リンパ療法士、フェムケアニスト、オーラ鑑定、心理カウンセラー、ラジオパーソナリティ、セラピスト |\n| スキル | 初対面で距離を縮める、1年以上悩む購入者の最後のひと押し、安心感。宿曜ハイグレード講師、数秘術師、オラクルカード |\n| Contact Circle Top3 | ①カーマッチ（中古車）②不動産仲介③FP |\n\n### ONE to ONE シート（未記入・初回で聞く）\n\n| 項目 | 初回の聞き方（たたき台） |\n|------|--------------------------|\n| 直近10件顧客・リファーラル欄 | 「いま一番うれしい紹介の型」と「断りたい紹介」を具体例で |\n| 質の高い／不適切なリファーラル | 遠藤さんの言葉で定義してもらう（紹介文の核になる） |\n| コンタクトサークル 1〜10 | Top3以外で **DragonFly 内に既にある接点** を確認 |\n\n---\n\n## ■ サマリー（最新状況）\n\n- **2026-06-04** 第1回121 **実施済み**（JST 14:00–15:00）。**BNI SILVIS** × DragonFly（次廣）クロスチャプター。トレーニング同組のため信頼ベースで深掘り。\n- **核心:** **「住宅を買うのがゴールじゃない」** — シンママの住まいへの寄り添いの本質。シンママ向け実績・空き家転貸・2027シンママコミュの想いを共有。\n- **次廣側:** 業務改善・仕組み化の話に **食いつきあり**（2027コミュ・案件見える化の芽）。**遠藤さんへ繋ぎたい方を数名** 口頭で提示（氏名リストは **TODO**・下記接点候補と照合）。\n- **相互:** 次廣 → シンママの住まい・空き家困りごと紹介／遠藤 → 業務整理の相談は歓迎。お礼送付済み（LINE想定）。\n- **Religo 1to1 レコード:** `one_to_ones.id` = **72**（相手 member `id=164`・**BNI SILVIS** `workspaces.id=11`）\n\n---\n\n## ■ 初回121 設計（2026-06-04）\n\n### ゴール（60分）\n\n1. トレーニング仲間としての信頼を活かし、**空き家転貸＋シンママ購入**を第三者が説明できるレベルまで理解する。  \n2. **2027シンママコミュニティ**と DragonFly 内の接点（平山・伊藤・住宅ローン・リフォーム系）を軽く棚卸し。  \n3. 次廣の **業務改善・小規模システム化** を、不動産・顧客管理・コミュニティ運営の文脈で短く共有し、**相互紹介の条件**を1文ずつ言語化。\n\n### タイムテーブル（目安）\n\n| 時間 | パート | 内容 |\n|:---:|:---|:---|\n| 0〜5分 | オープニング | トレーニングでの感謝、今日のゴール合意 |\n| 5〜10分 | 雑談 | 11期・1to1役、チームリーダー（山口さんのありがとう）、占い・茨城ネタ |\n| 10〜35分 | 遠藤さん | シンママ購入／空き家転貸／11契約の再現性・2027コミュニティの設計 |\n| 35〜48分 | 次廣 | 紙・Excel・LINE散在の整理、予約・顧客フォロー、小規模EC・紹介管理 |\n| 48〜57分 | 接点探索 | 平山・司法書士・塗装・清掃・FP・カーマッチ（Contact Circle） |\n| 57〜60分 | クローズ | 紹介文1文、次アクション、Religo・本ファイル更新 |\n\n### 初回で聞くこと（チェックリスト）\n\n- [ ] **他社にない強み** — 空き家転貸＋アイサロン等の複数収益を、他仲介とどう切り分けるか\n- [ ] **シンママ購入**で他社が断った案件を通したときの **決め手**（審査・伴走・リフォーム）\n- [ ] **2027シンママコミュニティ** — 会員像・収益モデル・みらい不動産との関係（イベント？紹介？）\n- [ ] **47都道府県制覇**までの **パートナー戦略**（各地の司法書士・工務店・金融機関）\n- [ ] **質の高い／不適切なリファーラル** の定義（NCAS未記入欄）\n- [ ] **紹介してほしくない** 地域・属性・案件タイプ\n- [ ] 1to1役としてチャプターに **具体的に何をしたいか**\n- [ ] 次廣を紹介しやすい顧客像（空き家オーナー以外も含む）\n\n### トレーニング仲間向けオープニング（たたき台）\n\n> 「遠藤さん、本日はお時間ありがとうございます。DragonFly の次廣です。（SILVIS の聡美さんと、トレで何度も同組でしたね、と軽く触れてもよい）\n> トレーニングでは何度も同じ組になって、もう顔見知りなので今日はいつもよりビジネスの話を深くできればと思っています。\n> 聡美さんの『シンママの住宅購入』と『空き家転貸』の両方を、僕が第三者に紹介できる言葉にしたいです。後半で私の業務整理の話も短くします。まず聡美さんの事業から、よいですか？」\n\n### 雑談フック\n\n- **1to1役** × 入会約7ヶ月で **チームリーダー** — チャプターへの貢献スタイル  \n- **占い**（宿曜・数秘）と **占いバー開業** の夢 — 無理に深掘りしない  \n- **茨城**（水戸オフィス・ひたちなか居住）と次廣 **静岡** — 遠方参加のコストへの敬意  \n\n### 深掘り質問（必要なぶんだけ）\n\n- 「**2ヶ月11契約**のとき、紹介・SNS・既存客のどれが効きましたか？ いま再現したいのはどこですか？」\n- 「**空き家転貸**は、オーナー向けの説明を **60秒** で言うと何ですか？」（ONE to ONE #6 の実戦版）\n- 「**2027シンママコミュニティ**は、不動産の前段の集客ですか、購入後のサポートですか？」\n- 「**他社でローンが難しい**と言われた方で、聡美さんが通したときの **一番の違い** は何ですか？」\n\n### 次廣側（短く）\n\n> 「私は、Excel・紙・LINE・メールに散らばった業務を、現場のやり方を尊重しながら小さくシステム化する仕事です。店舗やサロンでは予約・再来店、不動産やコミュニティ運営では **顧客・案件・紹介の見える化** に入ることが多いです。」\n\n**刺さりそうな接点（売り込み禁止・情報交換）**\n\n- **2027コミュニティ:** 会員管理・イベント申込・紹介ログの **属人化** が出る前に設計の話を聞く程度  \n- **空き家オーナー向け資料:** Web（mamabuyhome.com）と **LINE** の導線整理  \n- **全国展開:** パートナー先の **紹介管理**（47都道府県は紹介ネットワーク設計そのもの）\n\n---\n\n## ■ 次廣側（DragonFly）→ 遠藤さんへ繋ぎたい接点候補\n\n| メンバー | カテゴリー | 接点の理由 |\n|----------|------------|------------|\n| **平山真由美** | シングルマザー専門事業コンシェルジュ | シンママ支援・コミュニティ。 [`1to1_hirayama_mayumi_lifesupport.md`](1to1_hirayama_mayumi_lifesupport.md) |\n| **伊藤隆雄** | （ひとり親支援協会） | ひとり親支援コミュニティ接続の文脈。 [`1to1_ito_takao_phoenix_jsp.md`](1to1_ito_takao_phoenix_jsp.md) |\n| **飯田香** | スタイルアドバイザー | シンママ・女性起業家ネットワーク（紹介はフルネーム必須） |\n| **藤井恵理子** | 平天 | シングルマザー（本人が話した範囲でのみ接続） |\n| 住宅ローン・司法書士・塗装・清掃・FP | — | G.A.I.N.S. Networks／Contact Circle Top3 と照合 |\n\n**注意:** プレジデント千葉氏のシンママ支援は伊藤1to1で **要ファクトチェック** とある。遠藤さん経由で話題に出たら **氏名・団体名を本人確認してから** 紹介する。\n\n---\n\n## ■ 1to1履歴\n\n### 【第1回】2026-06-04\n\n#### 基本情報\n\n- 日時：**2026-06-04（水）JST 14:00–15:00**（実施済み）\n- 実施方法：**TODO**（対面／Zoom 等）\n- 既知関係：**BNI トレーニングで何度も同組**（SILVIS × DragonFly クロスチャプター）\n\n#### 話した内容（重要）\n\n- **「住宅を買うのがゴールじゃない」** — 次廣が本質的と評価。シンママへの寄り添い・他社で難しいローン・長期迷いの背中押し等の文脈。\n- 空き家転貸・**2027シンママコミュニティ**・2030全国展開のビジョン。\n- 次廣の **業務改善・小さな仕組み化** に関心（食いつきあり）。2027コミュの会員・案件・紹介の見える化は将来の接点。\n- 次廣から **遠藤さんへ繋ぎたい方を数名** 提示（**具体名 TODO** — 下記「接点候補」と121内の実名を照合して追記）。\n\n#### 決定・アクション\n\n- [ ] 次廣: 121で挙げた **紹介候補** を順次お繋ぎ（氏名・紹介文を確定）\n- [ ] 次廣: シンママの住まい・空き家の紹介用 **一言メモ** を整備\n- [ ] 遠藤: 業務整理・仕組み化の具体が出たら次廣へ相談（任意）\n- [x] Religo 1to1 登録（`one_to_ones.id=72`・`members.id=164`）\n\n---\n\n## ■ 累積インサイト（超重要）\n\n- **チャプター:** 遠藤さんは **SILVIS**（DragonFly ではない）。紹介文・NCAS では **SILVIS / BNI** を明記。DragonFly の **遠藤哲也**（ビジター）と混同しない。\n- **差別化の一文:** 「住宅を買うのがゴールではない」＝仲介ではなく **人生の住まい方** に寄り添う。\n- **次廣との接点:** 不動産紹介ではなく **業務・コミュニティの仕組み化**。2027前に設計の話を聞くタイミングがありうる。\n\n---\n\n## ■ tugiloとしての戦略\n\n- 遠藤さんは **「不動産仲介」ではなく「シンママの人生の最後の一押し＋空き家で安定収益」** の二軸で記憶する。トレーニングで培った **信頼** を初回の短縮パスに使う。\n- 次廣の接点は **物件紹介ではなく**、(1) **コミュニティ・会員・イベントの運営基盤**、(2) **案件・紹介・パートナー先の見える化**、(3) **Web/LINE 導線**。2027コミュニティは **早すぎる売り込み禁止** — 聞く・紹介条件を固める優先。\n- **平山・伊藤** への橋渡しは、遠藤さんの **2027ゴール** と合意が取れた場合のみ。初回で全員紹介はしない。\n\n---\n\n## ■ リファーラル戦略（BNI特化）\n\n### 次廣 → 遠藤さんへ紹介しやすい相手（会前たたき台）\n\n| 優先 | 像 | 理由 |\n|:---:|-----|------|\n| ★ | **シングルマザー**で住宅購入・賃貸・リフォームを検討中 | 専門領域の中心 |\n| ★ | **空き家**を保有し収益化・管理に困るオーナー（茨城近郊〜要確認） | 空き家転貸モデル |\n| ○ | **住宅ローンが難しい**と他社で断られた相談者 | 実績ストーリーと一致 |\n| ○ | **リフォーム込み**の中古購入検討者 | ワンストップ |\n| △ | **占い・ウェルネス**コミュニティ運営者 | 趣味・Networks 側（本業と混同しない） |\n\n### 遠藤さん → 次廣へ（会後確定）\n\n- **会後に追記**\n\n### 第三者紹介の短い言い方（たたき台・会後に確定）\n\n> 遠藤聡美さんは、**BNI SILVIS** のメンバーで、株式会社みらい不動産として **シングルマザー専門の住宅購入アドバイザー** をしています。他社で難しいローン案件の実績があり、中古の購入からリフォームまで伴走します。あわせて、空き家を借りて蘇生・転貸し、安定収入を得る **空き家活用** の仕組みも提案しています。シンママの住まいや空き家オーナーさんの相談に合いそうです。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- **トレーニング:** 何度も一緒 — 形式的な自己紹介は省略し、**ゴール合意から入ってよい**。\n- **リーダー性:** 入会早期からチームリーダー・1to1役 — **ハキハキ・明るさ・影響力**（山口さんコメント）。\n- **占い・都市伝説:** 関心は厚いが、初回は **ビジネス主軸**。本人が振ったら短く乗る。\n- **家族:** 19歳・16歳の子 — シンママ支援の **当事者感・説得力** の源泉として尊重（プライベートは深掘りしない）。\n\n---\n\n**更新:** 2026-06-04 16:21 JST — **チャプター修正: SILVIS**（誤: DragonFly）。第1回実施メモ・お礼文案の要点を反映。  \n**更新:** 2026-06-04 13:59 JST — 初回事前準備作成（ユーザー: 14:00–15:00・トレーニング同組・NCAS URL）。','2026-06-04 07:33:36','2026-06-04 16:33:40');
/*!40000 ALTER TABLE `one_to_ones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participant_breakout`
--

DROP TABLE IF EXISTS `participant_breakout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participant_breakout` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `participant_id` bigint(20) unsigned NOT NULL,
  `breakout_room_id` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `participant_breakout_participant_id_breakout_room_id_unique` (`participant_id`,`breakout_room_id`),
  KEY `participant_breakout_participant_id_index` (`participant_id`),
  KEY `participant_breakout_breakout_room_id_index` (`breakout_room_id`),
  CONSTRAINT `participant_breakout_breakout_room_id_foreign` FOREIGN KEY (`breakout_room_id`) REFERENCES `breakout_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `participant_breakout_participant_id_foreign` FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participant_breakout`
--

LOCK TABLES `participant_breakout` WRITE;
/*!40000 ALTER TABLE `participant_breakout` DISABLE KEYS */;
INSERT INTO `participant_breakout` VALUES
(229,535,32,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(230,572,32,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(231,544,32,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(232,583,32,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(233,594,32,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(234,568,32,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(235,535,33,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(236,572,33,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(237,544,33,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(238,583,33,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(239,589,33,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(240,568,33,'2026-05-18 09:01:06','2026-05-18 09:01:06'),
(241,483,30,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(242,510,30,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(243,498,30,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(244,508,30,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(245,483,31,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(246,510,31,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(247,498,31,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(248,529,31,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(249,508,31,'2026-05-18 09:01:27','2026-05-18 09:01:27'),
(250,440,28,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(251,411,28,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(252,457,28,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(253,436,28,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(254,440,29,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(255,411,29,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(256,436,29,'2026-05-18 09:01:58','2026-05-18 09:01:58'),
(257,335,26,'2026-05-18 09:02:15','2026-05-18 09:02:15'),
(258,389,26,'2026-05-18 09:02:15','2026-05-18 09:02:15'),
(259,360,26,'2026-05-18 09:02:15','2026-05-18 09:02:15'),
(260,335,27,'2026-05-18 09:02:15','2026-05-18 09:02:15'),
(261,379,27,'2026-05-18 09:02:15','2026-05-18 09:02:15'),
(262,360,27,'2026-05-18 09:02:15','2026-05-18 09:02:15'),
(263,289,24,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(264,299,24,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(265,287,24,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(266,294,24,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(267,289,25,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(268,299,25,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(269,287,25,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(270,319,25,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(271,294,25,'2026-05-18 09:02:45','2026-05-18 09:02:45'),
(272,249,22,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(273,223,22,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(274,199,22,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(275,211,22,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(276,216,22,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(277,234,22,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(278,249,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(279,223,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(280,199,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(281,211,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(282,216,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(283,253,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(284,234,23,'2026-05-18 09:03:07','2026-05-18 09:03:07'),
(285,163,20,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(286,171,20,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(287,191,20,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(288,159,20,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(289,163,21,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(290,171,21,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(291,190,21,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(292,159,21,'2026-05-18 09:03:26','2026-05-18 09:03:26'),
(293,68,18,'2026-05-18 09:03:41','2026-05-18 09:03:41'),
(294,71,18,'2026-05-18 09:03:41','2026-05-18 09:03:41'),
(295,100,18,'2026-05-18 09:03:41','2026-05-18 09:03:41'),
(296,68,19,'2026-05-18 09:03:41','2026-05-18 09:03:41'),
(297,71,19,'2026-05-18 09:03:41','2026-05-18 09:03:41'),
(298,100,19,'2026-05-18 09:03:41','2026-05-18 09:03:41'),
(299,12,6,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(300,31,6,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(301,10,6,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(302,17,6,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(303,37,6,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(304,37,7,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(305,29,7,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(306,9,7,'2026-05-18 09:03:53','2026-05-18 09:03:53'),
(313,597,34,'2026-05-19 10:22:35','2026-05-19 10:22:35'),
(314,629,34,'2026-05-19 10:22:35','2026-05-19 10:22:35'),
(315,664,34,'2026-05-19 10:22:35','2026-05-19 10:22:35'),
(316,597,35,'2026-05-19 10:22:35','2026-05-19 10:22:35'),
(317,629,35,'2026-05-19 10:22:35','2026-05-19 10:22:35'),
(318,655,35,'2026-05-19 10:22:35','2026-05-19 10:22:35'),
(325,746,36,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(326,757,36,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(327,765,36,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(328,736,36,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(329,743,36,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(330,788,36,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(331,746,37,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(332,757,37,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(333,765,37,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(334,736,37,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(335,743,37,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(336,793,37,'2026-05-26 10:43:19','2026-05-26 10:43:19'),
(367,818,38,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(368,834,38,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(369,830,38,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(370,816,38,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(371,858,38,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(372,818,39,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(373,834,39,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(374,830,39,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(375,816,39,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(376,852,39,'2026-06-02 10:15:08','2026-06-02 10:15:08');
/*!40000 ALTER TABLE `participant_breakout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participants`
--

DROP TABLE IF EXISTS `participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `member_id` bigint(20) unsigned NOT NULL,
  `type` varchar(20) NOT NULL,
  `introducer_member_id` bigint(20) unsigned DEFAULT NULL,
  `attendant_member_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `participants_meeting_id_member_id_unique` (`meeting_id`,`member_id`),
  KEY `participants_introducer_member_id_foreign` (`introducer_member_id`),
  KEY `participants_attendant_member_id_foreign` (`attendant_member_id`),
  KEY `participants_meeting_id_index` (`meeting_id`),
  KEY `participants_member_id_index` (`member_id`),
  KEY `participants_type_index` (`type`),
  CONSTRAINT `participants_attendant_member_id_foreign` FOREIGN KEY (`attendant_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `participants_introducer_member_id_foreign` FOREIGN KEY (`introducer_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `participants_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `participants_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=863 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participants`
--

LOCK TABLES `participants` WRITE;
/*!40000 ALTER TABLE `participants` DISABLE KEYS */;
INSERT INTO `participants` VALUES
(1,1,1,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(2,1,2,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(3,1,3,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(4,1,4,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(5,1,5,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(6,1,6,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(7,1,7,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(8,1,8,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(9,1,9,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(10,1,10,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(11,1,11,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(12,1,12,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(13,1,13,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(14,1,14,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(15,1,15,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(16,1,16,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(17,1,17,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(18,1,18,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(19,1,19,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(20,1,20,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(21,1,21,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(22,1,22,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(23,1,23,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(24,1,24,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(25,1,25,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(26,1,26,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(27,1,27,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(28,1,28,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(29,1,29,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(30,1,30,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(31,1,31,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(32,1,32,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(33,1,33,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(34,1,34,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(35,1,35,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(36,1,36,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(37,1,37,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(38,1,38,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(39,1,39,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(40,1,40,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(41,1,41,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(42,1,42,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(43,1,43,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(44,1,44,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(45,1,45,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(46,1,46,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(47,1,47,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(48,1,48,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(49,1,49,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(50,1,50,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(51,1,51,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(52,1,52,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(53,1,53,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(54,1,54,'member',NULL,NULL,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(55,1,55,'visitor',2,32,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(56,1,56,'visitor',6,39,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(57,1,57,'visitor',2,12,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(58,1,58,'visitor',1,1,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(59,1,59,'visitor',7,21,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(60,1,60,'guest',25,51,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(61,1,61,'guest',18,50,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(62,1,62,'guest',17,30,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(64,2,1,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(65,2,2,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(66,2,3,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(67,2,4,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(68,2,5,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(69,2,6,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(70,2,7,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(71,2,8,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(72,2,9,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(73,2,10,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(74,2,11,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(75,2,12,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(76,2,13,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(77,2,14,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(78,2,15,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(79,2,16,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(80,2,17,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(81,2,18,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(82,2,19,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(83,2,20,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(84,2,21,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(85,2,22,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(86,2,23,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(87,2,24,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(88,2,25,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(89,2,26,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(90,2,27,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(91,2,28,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(92,2,29,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(93,2,30,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(94,2,31,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(95,2,32,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(96,2,33,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(97,2,34,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(98,2,35,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(99,2,36,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(100,2,37,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(101,2,38,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(102,2,39,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(103,2,40,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(104,2,41,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(105,2,42,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(106,2,43,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(107,2,44,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(108,2,45,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(109,2,46,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(110,2,47,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(111,2,48,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(112,2,49,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(113,2,50,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(114,2,51,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(115,2,52,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(116,2,53,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(117,2,54,'regular',NULL,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(118,2,55,'visitor',2,35,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(119,2,56,'visitor',2,2,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(120,2,57,'visitor',13,13,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(121,2,64,'proxy',26,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(122,2,60,'guest',2,NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(123,3,1,'regular',NULL,NULL,'2026-03-16 23:42:36','2026-03-16 23:42:36'),
(124,3,2,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(125,3,3,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(126,3,4,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(127,3,5,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(128,3,6,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(129,3,7,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(130,3,8,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(131,3,9,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(132,3,10,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(133,3,11,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(134,3,12,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(135,3,13,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(136,3,14,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(137,3,15,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(138,3,16,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(139,3,17,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(140,3,18,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(141,3,19,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(142,3,20,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(143,3,21,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(144,3,22,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(145,3,23,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(146,3,24,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(147,3,25,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(148,3,26,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(149,3,27,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(150,3,28,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(151,3,29,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(152,3,30,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(153,3,31,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(154,3,32,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(155,3,33,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(156,3,34,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(157,3,35,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(158,3,36,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(159,3,37,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(160,3,38,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(161,3,39,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(162,3,40,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(163,3,41,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(164,3,42,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(165,3,43,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(166,3,44,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(167,3,45,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(168,3,46,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(169,3,47,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(170,3,48,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(171,3,49,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(172,3,50,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(173,3,51,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(174,3,52,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(175,3,53,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(176,3,54,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(177,3,65,'regular',NULL,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(178,3,55,'visitor',13,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(179,3,56,'visitor',39,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(180,3,57,'visitor',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(181,3,58,'visitor',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(182,3,59,'visitor',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(183,3,135,'visitor',21,NULL,'2026-03-16 23:42:37','2026-06-01 13:52:09'),
(184,3,67,'visitor',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(185,3,68,'visitor',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(186,3,69,'visitor',51,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(187,3,70,'visitor',2,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(188,3,71,'visitor',40,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(189,3,72,'visitor',27,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(190,3,73,'visitor',10,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(191,3,74,'visitor',49,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(192,3,75,'visitor',27,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(193,3,64,'proxy',18,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(194,3,76,'proxy',4,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(195,3,77,'proxy',6,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(196,3,60,'guest',20,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(197,3,61,'guest',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
(198,4,1,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(199,4,2,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(200,4,3,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(201,4,4,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(202,4,5,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(203,4,6,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(204,4,7,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(205,4,8,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(206,4,9,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(207,4,10,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(208,4,11,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(209,4,12,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(210,4,13,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(211,4,14,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(212,4,15,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(213,4,16,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(214,4,17,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(215,4,18,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(216,4,19,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(217,4,20,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(218,4,21,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(219,4,22,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(220,4,23,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(221,4,24,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(222,4,25,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(223,4,26,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(224,4,27,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(225,4,28,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(226,4,29,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(227,4,30,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(228,4,31,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(229,4,32,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(230,4,33,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(231,4,34,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(232,4,35,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(233,4,36,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(234,4,37,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(235,4,38,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(236,4,39,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(237,4,40,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(238,4,41,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(239,4,42,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(240,4,43,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(241,4,44,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(242,4,45,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(243,4,46,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(244,4,47,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(245,4,48,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(246,4,49,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(247,4,50,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(248,4,51,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(249,4,52,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(250,4,53,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(251,4,54,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(252,4,65,'regular',NULL,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(253,4,55,'visitor',50,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(254,4,56,'visitor',17,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(255,4,57,'visitor',29,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(256,4,64,'proxy',46,39,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(257,4,60,'guest',18,NULL,'2026-03-23 12:34:34','2026-03-23 12:34:34'),
(258,6,1,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(259,6,2,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(260,6,3,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(261,6,4,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(262,6,5,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(263,6,6,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(264,6,7,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(265,6,8,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(266,6,9,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(267,6,10,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(268,6,11,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(269,6,12,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(270,6,13,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(271,6,14,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(272,6,15,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(273,6,16,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(274,6,17,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(275,6,18,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(276,6,19,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(277,6,20,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(278,6,21,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(279,6,22,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(280,6,23,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(281,6,24,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(282,6,25,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(283,6,26,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(284,6,27,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(285,6,28,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(286,6,29,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(287,6,30,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(288,6,31,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(289,6,32,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(290,6,33,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(291,6,34,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(292,6,35,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(293,6,36,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(294,6,37,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(295,6,38,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(296,6,39,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(297,6,40,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(298,6,41,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(299,6,42,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(300,6,43,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(301,6,44,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(302,6,45,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(303,6,46,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(304,6,47,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(305,6,48,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(306,6,49,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(307,6,50,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(308,6,51,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(309,6,52,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(310,6,53,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(311,6,54,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(312,6,65,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(313,6,78,'regular',NULL,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(314,6,55,'visitor',11,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(315,6,56,'visitor',11,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(316,6,57,'visitor',1,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(317,6,58,'visitor',46,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(318,6,59,'visitor',5,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(319,6,135,'visitor',5,NULL,'2026-03-31 00:09:20','2026-06-01 13:52:09'),
(320,6,64,'proxy',17,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(321,6,76,'proxy',27,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(322,6,60,'guest',2,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(323,6,61,'guest',34,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
(324,7,1,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(325,7,2,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(326,7,3,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(327,7,4,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(328,7,5,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(329,7,6,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(330,7,7,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(331,7,8,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(332,7,9,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(333,7,10,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(334,7,11,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(335,7,12,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(336,7,13,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(337,7,14,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(338,7,15,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(339,7,16,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(340,7,17,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(341,7,18,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(342,7,19,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(343,7,20,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(344,7,21,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(345,7,22,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(346,7,23,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(347,7,24,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(348,7,25,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(349,7,26,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(350,7,27,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(351,7,28,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(352,7,29,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(353,7,30,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(354,7,31,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(355,7,32,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(356,7,33,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(357,7,34,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(358,7,35,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(359,7,36,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(360,7,37,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(361,7,38,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(362,7,39,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(363,7,40,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(364,7,41,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(365,7,42,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(366,7,43,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(367,7,44,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(368,7,45,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(369,7,46,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(370,7,47,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(371,7,48,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(372,7,49,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(373,7,50,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(374,7,51,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(375,7,52,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(376,7,53,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(377,7,54,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(378,7,65,'regular',NULL,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(379,7,55,'visitor',6,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(380,7,56,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(381,7,57,'visitor',12,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(382,7,58,'visitor',48,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(383,7,59,'visitor',12,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(384,7,135,'visitor',14,NULL,'2026-04-07 00:04:59','2026-06-01 13:52:09'),
(385,7,67,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(386,7,68,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(387,7,69,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(388,7,70,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(389,7,71,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(390,7,72,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(391,7,73,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(392,7,74,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(393,7,75,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(395,7,80,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(396,7,60,'guest',46,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(397,7,61,'guest',20,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(398,7,62,'guest',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(400,8,1,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(401,8,2,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(402,8,3,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(403,8,4,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(404,8,5,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(405,8,6,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(406,8,7,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(407,8,8,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(408,8,9,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(409,8,10,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(410,8,11,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(411,8,12,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(412,8,13,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(413,8,14,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(414,8,15,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(415,8,16,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(416,8,17,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(417,8,18,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(418,8,19,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(419,8,20,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(420,8,21,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(421,8,22,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(422,8,23,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(423,8,24,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(424,8,25,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(425,8,26,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(426,8,27,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(427,8,28,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(428,8,29,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(429,8,30,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(430,8,31,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(431,8,32,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(432,8,33,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(433,8,34,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(434,8,35,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(435,8,36,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(436,8,37,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(437,8,38,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(438,8,39,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(439,8,40,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(440,8,41,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(441,8,42,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(442,8,43,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(443,8,44,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(444,8,45,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(445,8,46,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(446,8,47,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(447,8,48,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(448,8,49,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(449,8,50,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(450,8,51,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(451,8,52,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(452,8,53,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(453,8,54,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(454,8,65,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(455,8,78,'regular',NULL,NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(456,8,55,'visitor',11,11,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(457,8,56,'visitor',41,12,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(458,8,57,'visitor',11,39,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(459,8,58,'visitor',20,20,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(460,8,59,'visitor',35,46,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(461,8,135,'visitor',1,5,'2026-04-13 12:13:25','2026-06-01 13:52:09'),
(462,8,67,'visitor',6,28,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(463,8,68,'visitor',13,26,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(464,8,69,'visitor',36,30,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(465,8,70,'visitor',26,24,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(466,8,71,'visitor',53,13,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(467,8,72,'visitor',18,10,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(468,8,73,'visitor',49,32,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(469,8,74,'visitor',6,21,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(470,8,75,'visitor',20,15,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(471,8,64,'proxy',51,4,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(472,8,60,'guest',20,41,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(473,8,61,'guest',29,34,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
(474,9,1,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(475,9,2,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(476,9,3,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(477,9,4,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(478,9,5,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(479,9,6,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(480,9,8,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(481,9,9,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(482,9,10,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(483,9,11,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(484,9,12,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(485,9,13,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(486,9,14,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(487,9,15,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(488,9,17,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(489,9,18,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(490,9,19,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(491,9,20,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(492,9,21,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(493,9,22,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(494,9,23,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(495,9,24,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(496,9,25,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(497,9,26,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(498,9,27,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(499,9,28,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(500,9,29,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(501,9,30,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(502,9,31,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(503,9,32,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(504,9,33,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(505,9,34,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(506,9,35,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(507,9,36,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(508,9,37,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(509,9,38,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(510,9,39,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(511,9,40,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(512,9,41,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(513,9,42,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(514,9,43,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(515,9,44,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(516,9,46,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(517,9,47,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(518,9,48,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(519,9,49,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(520,9,50,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(521,9,51,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(522,9,52,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(523,9,53,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(524,9,54,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(525,9,65,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(526,9,78,'regular',NULL,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(527,9,70,'visitor',26,20,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(528,9,82,'visitor',30,12,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(529,9,83,'visitor',19,2,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(530,9,84,'visitor',13,24,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(531,9,85,'visitor',17,1,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(532,9,86,'proxy',5,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(533,9,87,'proxy',36,NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(534,10,1,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(535,10,2,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(536,10,3,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(537,10,4,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(538,10,5,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(539,10,6,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(540,10,8,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(541,10,9,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(542,10,10,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(543,10,11,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(544,10,12,'regular',NULL,NULL,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(545,10,13,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(546,10,14,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(547,10,15,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(548,10,17,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(549,10,18,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(550,10,19,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(551,10,20,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(552,10,21,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(553,10,22,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(554,10,23,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(555,10,24,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(556,10,25,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(557,10,26,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(558,10,27,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(559,10,28,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(560,10,29,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(561,10,30,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(562,10,31,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(563,10,32,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(564,10,33,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(565,10,34,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(566,10,35,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(567,10,36,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(568,10,37,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(569,10,38,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(570,10,39,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(571,10,40,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(572,10,41,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(573,10,42,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(574,10,43,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(575,10,44,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(576,10,46,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(577,10,47,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(578,10,48,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(579,10,49,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(580,10,50,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(581,10,51,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(582,10,52,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(583,10,53,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(584,10,54,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(585,10,65,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(586,10,78,'regular',NULL,NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(587,10,82,'visitor',30,17,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(588,10,88,'visitor',48,24,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(589,10,89,'visitor',17,5,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(590,10,90,'visitor',22,9,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(591,10,91,'visitor',19,20,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(592,10,92,'visitor',39,4,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(593,10,93,'proxy',10,48,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(594,10,94,'guest',49,2,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(595,10,95,'guest',18,1,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(596,11,1,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(597,11,2,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(598,11,3,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(599,11,4,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(600,11,5,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(601,11,6,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(602,11,8,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(603,11,9,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(604,11,10,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(605,11,11,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(606,11,12,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(607,11,13,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(608,11,14,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(609,11,15,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(610,11,17,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(611,11,18,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(612,11,19,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(613,11,20,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(614,11,21,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(615,11,22,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(616,11,23,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(617,11,24,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(618,11,25,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(619,11,26,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(620,11,27,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(621,11,28,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(622,11,30,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(623,11,31,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(624,11,32,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(625,11,33,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(626,11,34,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(627,11,35,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(628,11,36,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(629,11,37,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(630,11,38,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(631,11,39,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(632,11,40,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(633,11,29,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(634,11,41,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(635,11,42,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(636,11,43,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(637,11,44,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(638,11,46,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(639,11,47,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(640,11,48,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(641,11,49,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(642,11,50,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(643,11,51,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(644,11,52,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(645,11,53,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(646,11,54,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(647,11,65,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(648,11,78,'regular',NULL,NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(649,11,102,'visitor',40,40,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(650,11,103,'visitor',46,12,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(651,11,104,'visitor',18,18,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(652,11,105,'visitor',19,26,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(653,11,106,'visitor',26,24,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(654,11,107,'visitor',20,51,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(655,11,108,'visitor',30,30,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(656,11,109,'visitor',41,9,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(657,11,110,'visitor',27,5,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(658,11,111,'visitor',18,4,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(659,11,112,'proxy',10,21,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(660,11,113,'guest',2,35,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(661,11,114,'guest',2,47,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(662,11,115,'guest',2,25,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(663,11,116,'guest',2,32,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(664,11,117,'guest',13,2,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(665,11,118,'guest',13,20,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(731,12,1,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(732,12,2,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(733,12,3,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(734,12,8,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(735,12,4,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(736,12,5,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(737,12,6,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(738,12,9,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(739,12,10,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(740,12,11,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(741,12,12,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(742,12,13,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(743,12,14,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(744,12,15,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(745,12,17,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(746,12,18,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(747,12,135,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(748,12,19,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(749,12,20,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(750,12,21,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(751,12,22,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(752,12,23,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(753,12,24,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(754,12,25,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(755,12,26,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(756,12,27,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(757,12,28,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(758,12,30,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(759,12,31,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(760,12,32,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(761,12,33,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(762,12,34,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(763,12,35,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(764,12,36,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(765,12,37,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(766,12,136,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(767,12,39,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(768,12,40,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(769,12,29,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(770,12,41,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(771,12,42,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(772,12,43,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(773,12,44,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(774,12,46,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(775,12,47,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(776,12,48,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(777,12,49,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(778,12,50,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(779,12,51,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(780,12,52,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(781,12,53,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(782,12,54,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(783,12,65,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(784,12,78,'regular',NULL,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(785,12,125,'visitor',19,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(786,12,126,'visitor',19,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(787,12,127,'visitor',1,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(788,12,128,'visitor',37,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(789,12,129,'visitor',20,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(790,12,130,'visitor',13,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(791,12,131,'visitor',9,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(792,12,132,'visitor',34,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(793,12,133,'guest',31,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(794,12,134,'guest',20,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23'),
(795,13,1,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(796,13,2,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(797,13,3,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(798,13,8,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(799,13,4,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(800,13,5,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(801,13,6,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(802,13,9,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(803,13,10,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(804,13,11,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(805,13,12,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(806,13,13,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(807,13,14,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(808,13,15,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(809,13,17,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(810,13,18,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(811,13,135,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(812,13,149,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(813,13,19,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(814,13,20,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(815,13,21,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(816,13,22,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(817,13,23,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(818,13,24,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(819,13,25,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(820,13,26,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(821,13,27,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(822,13,28,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(823,13,30,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(824,13,31,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(825,13,32,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(826,13,33,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(827,13,34,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(828,13,35,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(829,13,36,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(830,13,37,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(831,13,136,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(832,13,39,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(833,13,40,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(834,13,29,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(835,13,41,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(836,13,42,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(837,13,43,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(838,13,44,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(839,13,46,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(840,13,47,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(841,13,48,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(842,13,49,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(843,13,50,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(844,13,51,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(845,13,53,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(846,13,54,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(847,13,65,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(848,13,78,'regular',NULL,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(849,13,150,'visitor',11,11,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(850,13,151,'visitor',17,20,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(851,13,152,'visitor',11,34,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(852,13,153,'visitor',30,2,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(853,13,154,'visitor',42,42,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(854,13,155,'visitor',48,41,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(855,13,156,'visitor',43,9,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(856,13,157,'visitor',43,43,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(857,13,158,'visitor',2,12,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(858,13,159,'visitor',43,24,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(859,13,160,'visitor',18,18,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(860,13,161,'visitor',1,1,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(861,13,95,'proxy',21,NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(862,13,162,'guest',13,5,'2026-06-02 08:49:44','2026-06-02 08:49:44');
/*!40000 ALTER TABLE `participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES
(1,'App\\Models\\User',2,'religo-admin','fc4ea95195a45cca5d253758c75a777ab10a1eaea63435f2fb5a577fddc2e1a0','[\"*\"]','2026-06-04 01:09:07',NULL,'2026-05-28 22:27:00','2026-06-04 01:09:07'),
(2,'App\\Models\\User',2,'religo-admin','461a044d5c3c6fe7af4276d62bc24a78e2b3229a30d0a977b6d4dc06777225e9','[\"*\"]','2026-06-04 01:44:30',NULL,'2026-05-29 05:37:44','2026-06-04 01:44:30'),
(3,'App\\Models\\User',2,'religo-admin','5a013168a09435757d78cd53bebe302298b93c5dbecdee1a67b4956a9ed44b81','[\"*\"]','2026-06-02 17:06:02',NULL,'2026-05-31 10:39:42','2026-06-02 17:06:02'),
(4,'App\\Models\\User',2,'religo-admin','004bea0cf450f71345d60499007a1b3a2ab93131aacf27e98dcfe67e344ef4d7','[\"*\"]','2026-06-04 12:08:33',NULL,'2026-06-04 10:46:26','2026-06-04 12:08:33'),
(5,'App\\Models\\User',2,'religo-admin','a04df85751ca37c955412e0b49891ccb6232707516c57cfd78a50d649e9b866c','[\"*\"]','2026-06-04 12:40:26',NULL,'2026-06-04 10:46:55','2026-06-04 12:40:26'),
(6,'App\\Models\\User',2,'religo-admin','30fd7c4ed4e1d227707022ebc48db08506f09f134cfe4d4260a3b30f3e6ca4de','[\"*\"]','2026-06-04 13:57:00',NULL,'2026-06-04 13:57:00','2026-06-04 13:57:00');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `country_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `regions_country_id_name_unique` (`country_id`,`name`),
  CONSTRAINT `regions_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'BODコーディネーター/メンターサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(2,'BCP担当、対面イベントサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(3,'ビジターホストコーディネーター',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(4,'プレジデント',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(5,'トレーニングサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(6,'対面イベントサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(7,'WEBマスター',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(8,'1to1担当・書記兼会計補佐',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(9,'エデュケーションコーディネーター・OCCサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(10,'イベント担当（フォーラム）',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(11,'メンターコーディネイター',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(12,'ビジターホストサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(13,'書記兼会計',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(14,'メンバーシップ委員',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(15,'イベント担当サポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(16,'グローバルビジネスサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(17,'ビジターホストサポート、BODサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(18,'BOD担当',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(19,'WEBマスターサポート・OCCサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(20,'バイスプレジデント',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(21,'1to1サポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(22,'BCP担当',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(23,'メンターサポート/対面イベントサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(24,'ビジターホストサポート・書記兼会計補佐',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(25,'トレーニング担当',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(26,'対面イベント担当',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(27,'グローバルビジネスコーディネーター',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(28,'ビジターホストサポート、エデュケーションサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(29,'OCCコーディネーター、WEBマスターサポート、エデュケーションサポート',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(30,'ディレクターコンサルタント',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(31,'グロースエリアディレクター',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(32,'エグゼクティブディレクター',NULL,'2026-03-05 01:49:21','2026-03-05 01:49:21'),
(33,'BODコーディネーター',NULL,'2026-03-10 00:40:14','2026-03-10 00:40:14'),
(34,'1to1担当',NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(35,'BODサポート,ビジホスサポート',NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(36,'書記兼会計補佐・1to1サポート',NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(37,'グローバルビジネス担当',NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(38,'メンターコーディネーター',NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(39,'ビジターホスト',NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(40,'BCPサポート',NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(41,'トレーニングサポート/グローバルビジネスサポート',NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(42,'対面イベント・ビジターホストサポート',NULL,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(43,'ビジターホストCo・エデュケーションCoサポート・OCCサポート',NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(44,'メンバーシップ',NULL,'2026-04-20 21:05:14','2026-04-20 21:05:14'),
(45,'サポート（バイス・ビジホス・メンター・webマス・フォーラム）',NULL,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
(46,'エデュケーションコーディネーター',NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(47,'メンバーシップ委員会',NULL,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(48,'ビジホスサポート',NULL,'2026-05-25 17:33:03','2026-05-25 17:33:03'),
(49,'BCP・ビジターホストサポート',NULL,'2026-05-25 17:33:03','2026-05-25 17:33:03');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
('0rwcgOyvPmZxDHLeZIGTS7sABfhPtaIuIjaydCe1',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRVY3UjlrTXJYT2xhcWs2QXZHSzJKcU5QRHdSMWEyY29uVllRaWNKZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1779756273),
('2hAyNHhhIWQh9V9cXNhW8BYYTC8aAwVCwe7kRBRX',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiS3JjM0lYZ1k1akRnS05NQmpGQ212VjF0SktkOGdkVXdqMjdObGNDZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1780387562),
('2kJDuICn1B9jcPZ8JrruKfNICjhBn3ATwRXoftXw',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUUxVHp0VE4yMnFKY0FrMjNXSmRCMXVwZGZIQ2x1Y3lQdUxZR3ZZSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1780191569),
('B30RzX1J45hjoVivXwxXM3oYIr9gIVrUWrQ3UHpG',NULL,'192.168.65.1','curl/8.7.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZjNiWG1NdVlRcHRFZTNvWkppZmxzampGM2xzdmN6TkhyeDRoYnc0UyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MTY6Imh0dHA6Ly9sb2NhbGhvc3QiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1779756264),
('lM6CKS3r2USMorBNmlNfAOigiQSAxH7w4AuCrlCv',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Cursor/3.6.31 Chrome/142.0.7444.265 Electron/39.8.1 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVjkxS29RM2VwY2o5UURrV3JqSFE3NEFsZ1FTMzNhRTczWFlNU3g5SiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1780537571),
('Meqyew7J78nPd6pajenpDoa65UnkvVh5LZ6abs8o',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUg0dDFPTnlDbkh4elJmYVc0eWd4a01BT2VoZDRweDJuMDVMamNTSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1780294130),
('nMdzjVAqtQnKWrZY3SEHZmY3YoXXiVZna3Dodqdj',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0hOc3ZRUUREZ0IzQU1SRDA4VlZXbHJUMDk0N3htY215NmtscGpPZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1780544425),
('Y1oy1eynIkgLaXS5m7Ezr52zaJF3s9E7CylrsDTg',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoieUVQMUVOcGlQMTB4c3hFS1padmgxNjZXa2NxNUpBbzNqaVRkUVZkYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1779688657),
('YsBTRl5Z1bOpkv3QbNw12zf2772zotFpeD5G7EAL',NULL,'192.168.65.1','curl/8.7.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiSXJrZjJwVTlDTU03UU80bXlRaXNZbm55b1hNeWxvSGFXdzJVZ3hkRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1780537576);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_ai_credentials`
--

DROP TABLE IF EXISTS `user_ai_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_ai_credentials` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `ai_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `provider` varchar(30) DEFAULT NULL,
  `api_key` text DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_ai_credentials_user_id_unique` (`user_id`),
  CONSTRAINT `user_ai_credentials_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_ai_credentials`
--

LOCK TABLES `user_ai_credentials` WRITE;
/*!40000 ALTER TABLE `user_ai_credentials` DISABLE KEYS */;
INSERT INTO `user_ai_credentials` VALUES
(1,2,1,'openai','eyJpdiI6IjhJQ1owVTR0SXNCMlBLWGJpTjczN2c9PSIsInZhbHVlIjoiZFFmdzJvTS9uRFhhK1Z1UEtIWlJhN3U3ZmxZMEJTd1pVWXBkSVAweldxTlBOMlUzOHhVbEYxalNRaWtkdFhJaUdoSjV0dUQyMHcyR1JDTjhSalZZbFZpSDF1dS8yTmdvUk5pVHRiekduUUtBN1M1dEhjam9icm1uRjZtemZ1RkdXTFZFclVubzA5MWNpeEUvOHdlUXdtM1NNYnZ6emlXYU1WNDN1RDZIRVJ6S1NyN3NNQndVWlZacUNXWmpPSm5vRkFuWWZFZEJkUlZGT2lvdEVTU3NCSUxoODIxUGo3S2VqbWpyQThBRzBQZz0iLCJtYWMiOiJmNjMwMWFiZWRlMDhhNTQ5ZmNlZTkxYTA3MjE1MDNjNGEyNWI5NDVmMDU5ZDUxNTYyODQzZjBlMDRkZTI1YTg4IiwidGFnIjoiIn0=',NULL,1,'2026-05-30 08:46:35','2026-05-30 08:46:35');
/*!40000 ALTER TABLE `user_ai_credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_zoom_credentials`
--

DROP TABLE IF EXISTS `user_zoom_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_zoom_credentials` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `client_id` varchar(255) DEFAULT NULL,
  `client_secret` text DEFAULT NULL,
  `webhook_secret_token` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_zoom_credentials_user_id_unique` (`user_id`),
  CONSTRAINT `user_zoom_credentials_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_zoom_credentials`
--

LOCK TABLES `user_zoom_credentials` WRITE;
/*!40000 ALTER TABLE `user_zoom_credentials` DISABLE KEYS */;
INSERT INTO `user_zoom_credentials` VALUES
(1,2,'8m7vPK5vRoOkEfuZX7XOOA','eyJpdiI6IjNpcERua3hPK2N3MHY1andzbHhuQUE9PSIsInZhbHVlIjoiU2VoWFdvVGNmZWdHL3ZFKzR1WDRKRFo2WVh1Zm56bmU5UWx5R3V1VzBzUU93ZGtWb2tuU0hhOFlhMHBtQjZiZSIsIm1hYyI6ImU4MzFkOTJmN2NjYTg2MjQ5MWU3YTNlN2ViMThkNDE3MTgyMzIxZDAzMGUyY2UyNmJhYThhMzViMTA4ZmE1ZTUiLCJ0YWciOiIifQ==','eyJpdiI6IjNpUTNYSVE0UmtpNXFvR3dBWFo0VkE9PSIsInZhbHVlIjoieUlOUGQ1bXc3UjR2QTU1SFQ4a3VPNmYxOGZXeU13UkZRMEpmd2VDd3oxdz0iLCJtYWMiOiJjOTJjMjI0YmFjMjkxMWY2NjQ1ZWI0NWFhMTI5NzEyOTNmYjdiZDlhZTFiZTVjY2VkMTU4NjI0YTQ2YWU2NzMxIiwidGFnIjoiIn0=',1,'2026-06-04 01:41:31','2026-06-04 01:41:31');
/*!40000 ALTER TABLE `user_zoom_credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `owner_member_id` bigint(20) unsigned DEFAULT NULL,
  `default_workspace_id` bigint(20) unsigned DEFAULT NULL,
  `religo_role` varchar(32) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_default_workspace_id_foreign` (`default_workspace_id`),
  CONSTRAINT `users_default_workspace_id_foreign` FOREIGN KEY (`default_workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Default','default@religo.local',NULL,'$2y$12$dUrt0H0qQktz46pbKZu7cexZzI5MU8PpmDa3wyR2y4aiZTnWpBJRC',NULL,37,NULL,NULL,'2026-03-05 13:03:53','2026-04-07 03:08:58'),
(2,'次廣　淳','tugi@tugilo.com',NULL,'$2y$12$cPZeWQOsMuNaMwfHepwmzObgsMQ.UE9cVgzQIz5qjhMtDIetj9ypK',NULL,37,1,'chapter_admin','2026-05-28 22:27:00','2026-05-30 01:57:34');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workspaces`
--

DROP TABLE IF EXISTS `workspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workspaces` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `region_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workspaces_slug_index` (`slug`),
  KEY `workspaces_region_id_foreign` (`region_id`),
  CONSTRAINT `workspaces_region_id_foreign` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workspaces`
--

LOCK TABLES `workspaces` WRITE;
/*!40000 ALTER TABLE `workspaces` DISABLE KEYS */;
INSERT INTO `workspaces` VALUES
(1,'DragonFly','bni_dragonfly',NULL,'2026-03-04 13:07:41','2026-06-04 12:38:47'),
(2,'BNI Diana','bni_diana',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(3,'BNI 大人なじみ','bni_otona_najimi',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(4,'BNI カーネル','bni_kernel',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(5,'BNI レブリー','bni_reverie',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(6,'BNI パッシオーネ','bni_passione',NULL,'2026-05-21 16:13:21','2026-05-21 16:13:21'),
(7,'BNI SPREAD','bni_spread',NULL,'2026-05-21 16:18:58','2026-05-21 16:18:58'),
(8,'BNI トレスステラ','bni_trestella',NULL,'2026-05-21 16:18:58','2026-05-21 16:18:58'),
(9,'BNI VORTEX','bni_vortex',NULL,'2026-05-22 16:46:29','2026-05-22 16:46:29'),
(10,'BNI Tifonet','bni_tifonet',NULL,'2026-05-27 17:00:47','2026-05-27 17:00:47'),
(11,'BNI SILVIS','bni_silvis',NULL,'2026-06-04 07:33:36','2026-06-04 07:33:36');
/*!40000 ALTER TABLE `workspaces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zoom_accounts`
--

DROP TABLE IF EXISTS `zoom_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zoom_accounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `zoom_user_id` varchar(255) DEFAULT NULL,
  `zoom_account_id` varchar(255) DEFAULT NULL,
  `zoom_email` varchar(255) DEFAULT NULL,
  `access_token` text DEFAULT NULL,
  `refresh_token` text DEFAULT NULL,
  `token_expires_at` datetime DEFAULT NULL,
  `scopes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zoom_accounts_user_id_unique` (`user_id`),
  CONSTRAINT `zoom_accounts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zoom_accounts`
--

LOCK TABLES `zoom_accounts` WRITE;
/*!40000 ALTER TABLE `zoom_accounts` DISABLE KEYS */;
INSERT INTO `zoom_accounts` VALUES
(1,2,'NHCBopvRQtCYXFKPsKfc-g','4AVorcStRP2KzYIRra6cpA','tugi@tugilo.com','eyJpdiI6InNubmpxMXdSMUtRT3NOVEs4aW5Xbmc9PSIsInZhbHVlIjoiNDVQRUVJME4yeFg3ZGFDaVZFTjFobERGbkVySEpRK2RGY0kzTXEwUkt0U0FSdGVCeHRwSGozeVVyUkNJSitaRi9xbTlVVlNnZVUwZjN3Y2lpOUM3R2dTdXhoZWRoL0xidFJ4Uzk5enVCRnVadFAvV0dCdlZoTFJIVytvNktoL1dZbXJyR1pkbDNlcUNiQkYvRXdiZWZOS0F5WWVNem9tYjdXTGJzUXYvN1JvLzQ0RUxvTzhHTlRQOTNOaDQyM0JCTlcrR25uR3g1aXQvRWN0YWxpbmxHVVdQakpBNmlyT2NVQ3R1UG8rdzQyK21Xb0hjVjFjYk56c3gyWUQ4em4zZUpZUFYzN3poZGw1N2Q5c3ZGMkRqKytvNGk5YXd5WkJja2tiQzE1SEdiK0I2L0JtcHdOVDZ1T0JKc2tud0V5YWNzUXVKSXRsbkVLSWJMSmlsSFplRGtocitjb2JaOStCcGdXUFhnR0NnMzlrMjhiNWRaMlVIRE9nUEk4N1AwRlRCSlllT3h1UkxuQ0xKOFlRc0lRM3l3VmQzVmhlYThGNGw2QmN6MWtPSkVQcnc3N1RFbEc0d0oxU09GUnJUMFZ2eERTNnFUTzVNblR5aWZUTmVxZmtNTWkyT0JERDhNUUk0WDJuVGtkR21HM1ozdWx1Nzc4aG9SUmhMSWk2NzhST0JWdFMxVUxRVHZ1eEJrN3pkSFBDUU1Ea25IRjlxb0t4amF3Q2FGRlE3UEx2Y1V3QUVJcGVTaWtOUmxPYWFRZUJUTk95a0VCMUM3SjZYZS9aTlpWb1MxODVNelowWldJRDU1ZEpUWUx6VVliQnYyYXhUWG1STElXVzZQMVp6YVhJKzBYeFdidDFuaXVic0Qvd0JINDdjV2hTSW5IWWo1NHNWbzFTREVXcEFrcWtvaDRlZmdMbnU0bGpYRDV1WVFIbTNqVjQ4aThCMHJJUW9rT0dPU0pRekUzSFN4ZWkza1pvano5R0E4cXBnZUM3bEVhVkpaYXowLzBRNEhBbFBiQmNVSGd3bTdwN3hIMVRMdjB5TlYyYlJoOG5ESngvSUxuUHpQTktPTUVUNVVTaFlqL1VrMWpsWm5CNm91RWFhN2hMK1Q5dFY3NU1wRkYxVEZDcDlUZTY5NHc9PSIsIm1hYyI6IjgzNzAwMDJjMDFlZGZkZTU0MzM2Y2VmNWI5MjA5MDQwOGYxNmE3ZGIwMWRkNGNjMDI5MmIyMDFiMTMyZTM3NzciLCJ0YWciOiIifQ==','eyJpdiI6Im03UlJ4QitDVmszOXZxMWZzU29lK0E9PSIsInZhbHVlIjoicGF1V0E2ViswbGxxS2ZEOWJqdG90QUhZTlE0eFBEeFhxcUJkUllSM0ZBVnBGaW5hUk1KU3o2cXlqRGNiRFhPSElDMVFzM0Q5ekdSa3ZNZG9HckN2R0dyc2gwV1RpMlpOeHhEN0hueHh2a0hPazJQSDJYSGVYUUpJZHp3VXg2K0R2MVRucnBSc1R3N1MyN0ZPc0RPOENUMStRbkgvU25obzFzbVd4RnNMYmtiVGl6U21Ec0s0blJWU1I0MTB5Z1FlOW4xVVFFOFBVanlyWFdkcXlUMTdpZmh5NUhpRjlFVU1vVWtpclY0YjV2a0RoWXljNkxpbFR5TFlMWDR5WE5NbjNERGg5YS9TOHNBM3h2Z1ZDTno1OWxjNzlhdVNkT2hTVWd5NkJCZGg1MldnbXdXQVZlVkd5b0NycHkvby9QblNGNi9uTFV4Q3lTbFFpaFprVHg3djVpQzVQR3U3N1FwVXlGclFpS0RxanF3RzdIcHpkZlMwUFYrT2k2ZWwvaGtZUGtRaHJmUytWb2xsV0FhRFhyZ2ZYbUtiV1B4WFZSM2NFY2tnS3ZiTTAyVEhLbytjVU9BbWpFV0RtWGl1b01TT1dpWFVvOXU2cnZtRGVqdVlvVVdqVG9QNU1JcFpYV2d5aUZjSnFGTEtnMjJJS1VZY21XcWo0VDJwV0pJWGJIOXJGS0pjZGRyVXYrbDVUVWZ5MUpvdVI2VWhMLzkwcEl0aGF0YUx2TnhnSGF5RmFSajJoRk5oa2p5U1pwOG8xTm9QMXVGUTNTYkxWaDlCT0hYTW1kd01NYlNjZGRqMUpnUHB0eFRQVTQ4ZHVYbWkwVEVjTzFkMWRuNjdGWkpMK0lDTVE4VDJCTno0NHg5LzdWMEkyM0F4UUd2UDllMFg0WVNMN3FNUkxKWHRHQmRsaVRqT0Nmc3UxVTBoc25LdTh2bE9UV2ZPczNrVG01bWE5Q2pqQ0x2b0t4cU5oZldtQURZbno0a25QckQxVnM5UzYwY2JYZi9pMlZIdHdpZkl4Z0crSGNpQmVuOU04bFpWcjlYaWlPV2RaT1pCYTlyYk9pd2pXdXQ2clZoRGN5VmZSNTJ0TVcwK3NNQTVYNkZyMmo5cnRXV2l5VlR1R1ZPSTc2RFRkck84ZGc9PSIsIm1hYyI6IjQxODllYzdkMzViZjQxODRlN2ViMThhNzhlYTM1NGM3MzA3N2I3ZTEzOWFmYjA0ZmU5NjYyMTdjMDRlYmVhZjQiLCJ0YWciOiIifQ==','2026-06-04 11:42:20','user:read:user meeting:read:list_meetings meeting:read:summary meeting:read:past_meeting meeting:read:list_past_instances meeting:read:list_past_participants cloud_recording:read:list_recording_files','2026-05-30 01:06:32','2026-06-04 01:42:21');
/*!40000 ALTER TABLE `zoom_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zoom_import_apply_logs`
--

DROP TABLE IF EXISTS `zoom_import_apply_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zoom_import_apply_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `executed_at` datetime NOT NULL,
  `action` varchar(30) NOT NULL,
  `imported_count` int(11) NOT NULL DEFAULT 0,
  `held_count` int(11) NOT NULL DEFAULT 0,
  `skipped_count` int(11) NOT NULL DEFAULT 0,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `zoom_import_apply_logs_user_id_executed_at_index` (`user_id`,`executed_at`),
  CONSTRAINT `zoom_import_apply_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zoom_import_apply_logs`
--

LOCK TABLES `zoom_import_apply_logs` WRITE;
/*!40000 ALTER TABLE `zoom_import_apply_logs` DISABLE KEYS */;
INSERT INTO `zoom_import_apply_logs` VALUES
(1,2,'2026-05-30 17:59:33','apply',0,37,0,'{\"import_ids\":[6,5,4,3,2,1,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,30,29,31,32,33,34,35,36,37,38],\"details\":[{\"import_id\":1,\"result\":\"held\"},{\"import_id\":2,\"result\":\"held\"},{\"import_id\":3,\"result\":\"held\"},{\"import_id\":4,\"result\":\"held\"},{\"import_id\":5,\"result\":\"held\"},{\"import_id\":6,\"result\":\"held\"},{\"import_id\":8,\"result\":\"held\"},{\"import_id\":9,\"result\":\"held\"},{\"import_id\":10,\"result\":\"held\"},{\"import_id\":11,\"result\":\"held\"},{\"import_id\":12,\"result\":\"held\"},{\"import_id\":13,\"result\":\"held\"},{\"import_id\":14,\"result\":\"held\"},{\"import_id\":15,\"result\":\"held\"},{\"import_id\":16,\"result\":\"held\"},{\"import_id\":17,\"result\":\"held\"},{\"import_id\":18,\"result\":\"held\"},{\"import_id\":19,\"result\":\"held\"},{\"import_id\":20,\"result\":\"held\"},{\"import_id\":21,\"result\":\"held\"},{\"import_id\":22,\"result\":\"held\"},{\"import_id\":23,\"result\":\"held\"},{\"import_id\":24,\"result\":\"held\"},{\"import_id\":25,\"result\":\"held\"},{\"import_id\":26,\"result\":\"held\"},{\"import_id\":27,\"result\":\"held\"},{\"import_id\":28,\"result\":\"held\"},{\"import_id\":29,\"result\":\"held\"},{\"import_id\":30,\"result\":\"held\"},{\"import_id\":31,\"result\":\"held\"},{\"import_id\":32,\"result\":\"held\"},{\"import_id\":33,\"result\":\"held\"},{\"import_id\":34,\"result\":\"held\"},{\"import_id\":35,\"result\":\"held\"},{\"import_id\":36,\"result\":\"held\"},{\"import_id\":37,\"result\":\"held\"},{\"import_id\":38,\"result\":\"held\"}]}','2026-05-30 08:59:33','2026-05-30 08:59:33'),
(2,2,'2026-05-30 22:35:23','apply',29,0,0,'{\"import_ids\":[6,5,4,3,2,1,8,10,11,12,13,14,15,16,17,18,19,20,21,22,25,26,28,29,33,34,35,36,37],\"details\":[{\"import_id\":1,\"result\":\"imported\"},{\"import_id\":2,\"result\":\"imported\"},{\"import_id\":3,\"result\":\"imported\"},{\"import_id\":4,\"result\":\"imported\"},{\"import_id\":5,\"result\":\"imported\"},{\"import_id\":6,\"result\":\"imported\"},{\"import_id\":8,\"result\":\"imported\"},{\"import_id\":10,\"result\":\"imported\"},{\"import_id\":11,\"result\":\"imported\"},{\"import_id\":12,\"result\":\"imported\"},{\"import_id\":13,\"result\":\"imported\"},{\"import_id\":14,\"result\":\"imported\"},{\"import_id\":15,\"result\":\"imported\"},{\"import_id\":16,\"result\":\"imported\"},{\"import_id\":17,\"result\":\"imported\"},{\"import_id\":18,\"result\":\"imported\"},{\"import_id\":19,\"result\":\"imported\"},{\"import_id\":20,\"result\":\"imported\"},{\"import_id\":21,\"result\":\"imported\"},{\"import_id\":22,\"result\":\"imported\"},{\"import_id\":25,\"result\":\"imported\"},{\"import_id\":26,\"result\":\"imported\"},{\"import_id\":28,\"result\":\"imported\"},{\"import_id\":29,\"result\":\"imported\"},{\"import_id\":33,\"result\":\"imported\"},{\"import_id\":34,\"result\":\"imported\"},{\"import_id\":35,\"result\":\"imported\"},{\"import_id\":36,\"result\":\"imported\"},{\"import_id\":37,\"result\":\"imported\"}]}','2026-05-30 13:35:23','2026-05-30 13:35:23'),
(3,2,'2026-06-04 10:43:27','apply',4,6,2,'{\"import_ids\":[45,44,43,42,41,40,39,46,47,48,49,50],\"details\":[{\"import_id\":39,\"result\":\"imported\"},{\"import_id\":40,\"result\":\"imported\"},{\"import_id\":41,\"result\":\"held\"},{\"import_id\":42,\"result\":\"imported\"},{\"import_id\":43,\"result\":\"imported\"},{\"import_id\":44,\"result\":\"held\"},{\"import_id\":45,\"result\":\"held\"},{\"import_id\":46,\"result\":\"skipped\"},{\"import_id\":47,\"result\":\"held\"},{\"import_id\":48,\"result\":\"skipped\"},{\"import_id\":49,\"result\":\"held\"},{\"import_id\":50,\"result\":\"held\"}]}','2026-06-04 01:43:27','2026-06-04 01:43:27'),
(4,2,'2026-06-04 10:43:41','apply',0,5,1,'{\"import_ids\":[45,44,41,47,49,50],\"details\":[{\"import_id\":41,\"result\":\"held\"},{\"import_id\":44,\"result\":\"held\"},{\"import_id\":45,\"result\":\"held\"},{\"import_id\":47,\"result\":\"skipped\"},{\"import_id\":49,\"result\":\"held\"},{\"import_id\":50,\"result\":\"held\"}]}','2026-06-04 01:43:41','2026-06-04 01:43:41'),
(5,2,'2026-06-04 10:44:30','apply',1,1,2,'{\"import_ids\":[45,44,49,50],\"details\":[{\"import_id\":44,\"result\":\"imported\"},{\"import_id\":45,\"result\":\"held\"},{\"import_id\":49,\"result\":\"skipped\"},{\"import_id\":50,\"result\":\"skipped\"}]}','2026-06-04 01:44:30','2026-06-04 01:44:30');
/*!40000 ALTER TABLE `zoom_import_apply_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zoom_meeting_imports`
--

DROP TABLE IF EXISTS `zoom_meeting_imports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zoom_meeting_imports` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `owner_member_id` bigint(20) unsigned DEFAULT NULL,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `zoom_meeting_id` varchar(255) DEFAULT NULL,
  `zoom_meeting_uuid` varchar(255) DEFAULT NULL,
  `kind` varchar(20) NOT NULL,
  `topic` varchar(255) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT NULL,
  `participants_count` int(11) DEFAULT NULL,
  `is_one_to_one_candidate` tinyint(1) NOT NULL DEFAULT 0,
  `confidence` varchar(10) DEFAULT NULL,
  `matched_member_id` bigint(20) unsigned DEFAULT NULL,
  `match_status` varchar(20) NOT NULL DEFAULT 'unmatched',
  `counterpart_name` varchar(255) DEFAULT NULL,
  `counterpart_email` varchar(255) DEFAULT NULL,
  `selected` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `one_to_one_id` bigint(20) unsigned DEFAULT NULL,
  `raw` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`raw`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zoom_imports_user_uuid_unique` (`user_id`,`zoom_meeting_uuid`),
  KEY `zoom_meeting_imports_owner_member_id_foreign` (`owner_member_id`),
  KEY `zoom_meeting_imports_workspace_id_foreign` (`workspace_id`),
  KEY `zoom_meeting_imports_matched_member_id_foreign` (`matched_member_id`),
  KEY `zoom_meeting_imports_one_to_one_id_foreign` (`one_to_one_id`),
  KEY `zoom_meeting_imports_user_id_kind_index` (`user_id`,`kind`),
  KEY `zoom_meeting_imports_zoom_meeting_id_index` (`zoom_meeting_id`),
  KEY `zoom_meeting_imports_status_index` (`status`),
  CONSTRAINT `zoom_meeting_imports_matched_member_id_foreign` FOREIGN KEY (`matched_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `zoom_meeting_imports_one_to_one_id_foreign` FOREIGN KEY (`one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE SET NULL,
  CONSTRAINT `zoom_meeting_imports_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `zoom_meeting_imports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `zoom_meeting_imports_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zoom_meeting_imports`
--

LOCK TABLES `zoom_meeting_imports` WRITE;
/*!40000 ALTER TABLE `zoom_meeting_imports` DISABLE KEYS */;
INSERT INTO `zoom_meeting_imports` VALUES
(1,2,37,1,'84716679422',NULL,'scheduled','RUILED VISION JAPAN株式会社 原田里織さん: 1to1調整用','2026-06-01 14:00:00',NULL,60,NULL,1,'medium',18,'matched','原田里織',NULL,1,'imported',37,'{\"uuid\":\"9Xm2RkugT1C6v+MhZTKn2A==\",\"id\":84716679422,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"RUILED VISION JAPAN\\u682a\\u5f0f\\u4f1a\\u793e \\u539f\\u7530\\u91cc\\u7e54\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T08:09:09Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84716679422?pwd=QHTRp3oMGIJGI7J5abG5aTPxj6kaZe.1\"}','2026-05-30 01:06:38','2026-05-30 13:35:23'),
(2,2,37,1,'86416812471',NULL,'scheduled','株式会社pipon 小中貴晃さん: 1to1調整用','2026-06-01 15:00:00',NULL,60,NULL,1,'medium',34,'matched','小中貴晃',NULL,1,'imported',38,'{\"uuid\":\"BP33805NT+mZirELc55HCg==\",\"id\":86416812471,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793epipon \\u5c0f\\u4e2d\\u8cb4\\u6643\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T04:36:44Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86416812471?pwd=mkiUsHGZLwkqcIjab9KYAAUUNNZmpO.1\"}','2026-05-30 01:06:38','2026-05-30 13:35:23'),
(3,2,37,1,'89001802997',NULL,'scheduled','飯田香さん: 1to1調整用','2026-06-01 16:00:00',NULL,60,NULL,1,'medium',51,'matched','飯田香',NULL,1,'imported',39,'{\"uuid\":\"1A8CMyGwQXGdfYWnWvbiqw==\",\"id\":89001802997,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u9999\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T12:48:33Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89001802997?pwd=0NvbP5g8h9ipTIZOu5Va0g9q0etPwc.1\"}','2026-05-30 01:06:38','2026-05-30 13:35:23'),
(4,2,37,1,'83714290448',NULL,'scheduled','株式会社ハーベスト 寺田直史さん: 1to1調整用','2026-06-01 17:00:00',NULL,60,NULL,1,'medium',140,'matched','寺田直史',NULL,1,'imported',40,'{\"uuid\":\"pievFBHKSFWvn+ShypMlhw==\",\"id\":83714290448,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30cf\\u30fc\\u30d9\\u30b9\\u30c8 \\u5bfa\\u7530\\u76f4\\u53f2\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-28T07:49:41Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83714290448?pwd=D6hxZbvXx8cb4wOi4az1dqdMRWx02d.1\"}','2026-05-30 01:06:38','2026-05-30 13:35:23'),
(5,2,37,1,'89109217407',NULL,'scheduled','山本葉子さん: 1to1調整用','2026-06-03 15:00:00',NULL,60,NULL,1,'medium',27,'matched','山本葉子',NULL,1,'imported',41,'{\"uuid\":\"TtrpVfe9RQiM7YHY7WMPFg==\",\"id\":89109217407,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5c71\\u672c\\u8449\\u5b50\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-03T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-29T11:59:21Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89109217407?pwd=bDE5WtzsZjjMfJc2Nvoobf5qMRV2sx.1\"}','2026-05-30 01:06:38','2026-05-30 13:35:23'),
(6,2,37,1,'85054251043',NULL,'scheduled','アンフィニ 福田航平さん: 1to1調整用','2026-06-04 09:00:00',NULL,60,NULL,1,'medium',139,'matched','福田航平',NULL,1,'imported',42,'{\"uuid\":\"RdBgZ2BpQF6nq437OGYGDA==\",\"id\":85054251043,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30a2\\u30f3\\u30d5\\u30a3\\u30cb \\u798f\\u7530\\u822a\\u5e73\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-04T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-21T22:45:22Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85054251043?pwd=ba1o9a2mhaw3a9H6ROtS1C4BeaHt3z.1\"}','2026-05-30 01:06:38','2026-05-30 13:35:23'),
(7,2,37,1,'88571905941',NULL,'scheduled','吉田　匠真さん: 1to1調整用','2026-06-11 10:00:00',NULL,60,NULL,1,'medium',NULL,'new','匠真',NULL,0,'pending',NULL,'{\"uuid\":\"IRH48RKLSjOaHXea28qIWA==\",\"id\":88571905941,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5409\\u7530\\u3000\\u5320\\u771f\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-30T00:25:51Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88571905941?pwd=hKb7w2zzlj5hQRRX556X0HtpWYYbMz.1\"}','2026-05-30 01:06:38','2026-05-30 01:53:19'),
(8,2,37,1,'87970810668','EpAXFCa/QpOjsVdWaEVClw==','past','木村様121 木村様121さん: 1to1調整用','2026-05-29 14:00:00',NULL,60,NULL,1,'medium',99,'matched','木村',NULL,1,'imported',43,'{\"uuid\":\"EpAXFCa\\/QpOjsVdWaEVClw==\",\"id\":87970810668,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6728\\u6751\\u69d8121 \\u6728\\u6751\\u69d8121\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-05-29T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-08T07:48:33Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/87970810668?pwd=boa8aGxq66FoWZwkyxtk4bxWlGLf7l.1\"}','2026-05-30 01:06:39','2026-05-30 13:35:23'),
(9,2,37,1,'88616244598','dM/iLCDUTRCmtX0irBqfNQ==','past','するが観光局田形様打ち合わせ','2026-05-29 11:00:00',NULL,60,NULL,1,'medium',NULL,'new','するが観光局田形',NULL,0,'held',NULL,'{\"uuid\":\"dM\\/iLCDUTRCmtX0irBqfNQ==\",\"id\":88616244598,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u3059\\u308b\\u304c\\u89b3\\u5149\\u5c40\\u7530\\u5f62\\u69d8\\u6253\\u3061\\u5408\\u308f\\u305b\",\"type\":2,\"start_time\":\"2026-05-29T02:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-28T08:22:54Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88616244598?pwd=okUNQR8mUElbbtm4GBpBHm3FP1SukM.1\"}','2026-05-30 01:06:39','2026-05-30 09:27:43'),
(10,2,37,1,'88597252767','MF27uxnKT2aqvRtXjdXckQ==','past','合同会社TF 古屋周治さん: 1to1調整用','2026-05-29 09:00:00',NULL,60,NULL,1,'medium',113,'matched','古屋周治',NULL,1,'imported',44,'{\"uuid\":\"MF27uxnKT2aqvRtXjdXckQ==\",\"id\":88597252767,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5408\\u540c\\u4f1a\\u793eTF \\u53e4\\u5c4b\\u5468\\u6cbb\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-29T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-19T03:35:29Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88597252767?pwd=FUTaPMSYLArWq4Y7PUiVhkFINY8xt9.1\"}','2026-05-30 01:06:40','2026-05-30 13:35:23'),
(11,2,37,1,'83459427012','i3heZ15HSG6RW1qeTCoPBg==','past','SNEP株式会社 神保玲太さん: 1to1調整用','2026-05-28 15:00:00',NULL,60,NULL,1,'medium',138,'matched','神保玲太',NULL,1,'imported',NULL,'{\"uuid\":\"i3heZ15HSG6RW1qeTCoPBg==\",\"id\":83459427012,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"SNEP\\u682a\\u5f0f\\u4f1a\\u793e \\u795e\\u4fdd\\u73b2\\u592a\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-28T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-25T21:19:48Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83459427012?pwd=MBVOLSKRfdBbLiA7yfkirQd7bjErbM.1\"}','2026-05-30 01:06:41','2026-05-30 13:35:23'),
(12,2,37,1,'81436970113','+Q0WkZktQwWta233LUH1jw==','past','野口さん121','2026-05-25 15:00:00',NULL,60,NULL,1,'medium',52,'matched','野口',NULL,1,'imported',NULL,'{\"uuid\":\"+Q0WkZktQwWta233LUH1jw==\",\"id\":81436970113,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u91ce\\u53e3\\u3055\\u3093121\",\"type\":2,\"start_time\":\"2026-05-25T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-22T11:12:59Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81436970113?pwd=iouf9jFiTfH7NDHADNKR6BbbHMyfj4.1\"}','2026-05-30 01:06:41','2026-05-30 13:35:23'),
(13,2,37,1,'85129485087','DGnP1OtXRv+Ud8UIRCc6TA==','past','株式会社風土テック 御手洗宏樹さん: 1to1調整用','2026-05-22 09:00:00',NULL,60,NULL,1,'medium',NULL,'matched','御手洗宏樹',NULL,1,'imported',NULL,'{\"uuid\":\"DGnP1OtXRv+Ud8UIRCc6TA==\",\"id\":85129485087,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u98a8\\u571f\\u30c6\\u30c3\\u30af \\u5fa1\\u624b\\u6d17\\u5b8f\\u6a39\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-22T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-20T09:04:26Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85129485087?pwd=3qMSTRZM5zVkC8bK6MxN149KdRrFEi.1\"}','2026-05-30 01:06:42','2026-05-30 13:35:23'),
(14,2,37,1,'84060508444','5WhkV5vUSc2lhAf6Lbg/SQ==','past','西岡さん121','2026-05-21 14:45:00',NULL,60,NULL,1,'medium',14,'matched','西岡',NULL,1,'imported',NULL,'{\"uuid\":\"5WhkV5vUSc2lhAf6Lbg\\/SQ==\",\"id\":84060508444,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u897f\\u5ca1\\u3055\\u3093121\",\"type\":2,\"start_time\":\"2026-05-21T05:45:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-20T04:11:11Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84060508444?pwd=2rNgCcQ2J4kah7z339fApuIsqDmN7t.1\"}','2026-05-30 01:06:42','2026-05-30 13:35:23'),
(15,2,37,1,'85349117783','4X2npZV5QGasXKVx+eKqEA==','past','株式会社Campanula 権堂千栄実さん: 1to1調整用','2026-05-21 13:00:00',NULL,60,NULL,1,'medium',NULL,'matched','権堂千栄実',NULL,1,'imported',NULL,'{\"uuid\":\"4X2npZV5QGasXKVx+eKqEA==\",\"id\":85349117783,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eCampanula \\u6a29\\u5802\\u5343\\u6804\\u5b9f\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-21T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-12T09:41:23Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85349117783?pwd=od20EeGDFu3ebuqp17DaPaFrafurPm.1\"}','2026-05-30 01:06:43','2026-05-30 13:35:23'),
(16,2,37,1,'89131000556','PXefpCDtQfa6IVkp6a9ohA==','past','藤本勇輝さん: 1to1調整用','2026-05-21 11:00:00',NULL,60,NULL,1,'medium',143,'matched','藤本勇輝',NULL,1,'imported',50,'{\"uuid\":\"PXefpCDtQfa6IVkp6a9ohA==\",\"id\":89131000556,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u85e4\\u672c\\u52c7\\u8f1d\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-21T02:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-11T10:56:22Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89131000556?pwd=bnel7VbuTckH8DFKEJTqiD0dsvXel9.1\"}','2026-05-30 01:06:44','2026-05-30 13:35:23'),
(17,2,37,1,'83444991178','05lRf6XqSNu4hCFaDrAgGQ==','past','株式会社笏本縫製 中村啓吾さん: 1to1調整用','2026-05-21 09:00:00',NULL,60,NULL,1,'medium',9,'matched','中村啓吾',NULL,1,'imported',NULL,'{\"uuid\":\"05lRf6XqSNu4hCFaDrAgGQ==\",\"id\":83444991178,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u7b0f\\u672c\\u7e2b\\u88fd \\u4e2d\\u6751\\u5553\\u543e\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-21T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-08T03:41:16Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83444991178?pwd=52CN5ad6sivv4bNR12hh2j0GiuLsBj.1\"}','2026-05-30 01:06:44','2026-05-30 13:35:23'),
(18,2,37,1,'87313500925','TXIaXTwPQaiXBiKVTc9pfA==','past','イノセント株式会社 山梨麗さん: 1to1調整用','2026-05-19 17:00:00',NULL,60,NULL,1,'medium',144,'matched','山梨麗',NULL,1,'imported',52,'{\"uuid\":\"TXIaXTwPQaiXBiKVTc9pfA==\",\"id\":87313500925,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30a4\\u30ce\\u30bb\\u30f3\\u30c8\\u682a\\u5f0f\\u4f1a\\u793e \\u5c71\\u68a8\\u9e97\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-19T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-12T10:53:48Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/87313500925?pwd=C1Ay1AlxL9NLFOsJHlbgTrlS5Q84xa.1\"}','2026-05-30 01:06:45','2026-05-30 13:35:23'),
(19,2,37,1,'86985144664','j3BnDbqfRRu5kHrKvgax6g==','past','株式会社リーセンス たなべひかるさん: 1to1調整用','2026-05-19 16:00:00',NULL,60,NULL,1,'medium',145,'matched','たなべひかる',NULL,1,'imported',53,'{\"uuid\":\"j3BnDbqfRRu5kHrKvgax6g==\",\"id\":86985144664,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30ea\\u30fc\\u30bb\\u30f3\\u30b9 \\u305f\\u306a\\u3079\\u3072\\u304b\\u308b\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-19T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-16T09:27:33Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86985144664?pwd=sBA4sPpyS6Q2GKGYyKfcksj6OE3svL.1\"}','2026-05-30 01:06:46','2026-05-30 13:35:23'),
(20,2,37,1,'89357445297','/kmKTakIRh+J3YUhtah6dQ==','past','株式会社HS-neo-project 下辻　宏明さん: 1to1調整用','2026-05-19 14:00:00',NULL,60,NULL,1,'medium',121,'matched','宏明',NULL,1,'imported',NULL,'{\"uuid\":\"\\/kmKTakIRh+J3YUhtah6dQ==\",\"id\":89357445297,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eHS-neo-project \\u4e0b\\u8fbb\\u3000\\u5b8f\\u660e\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-19T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-07T09:52:59Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89357445297?pwd=1asxuiguMHu36fkKgtgivee0yYadpb.1\"}','2026-05-30 01:06:47','2026-05-30 13:35:23'),
(21,2,37,1,'82792118979','xG0mAVPKS1Gn4YNQBvNlxA==','past','株式会社MainC 辻亮さん: 1to1調整用','2026-05-18 16:00:00',NULL,60,NULL,1,'medium',120,'matched','辻亮',NULL,1,'imported',NULL,'{\"uuid\":\"xG0mAVPKS1Gn4YNQBvNlxA==\",\"id\":82792118979,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eMainC \\u8fbb\\u4eae\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-18T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-15T01:27:19Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82792118979?pwd=2eznMzeoCxbSO0dWVgEpUYU0XWBXJa.1\"}','2026-05-30 01:06:47','2026-05-30 13:35:23'),
(22,2,37,1,'89314073650','Xswm1pOmRfezElNCaBsjPg==','past','合同会社アブレイズ 前田和良さん: 1to1調整用','2026-05-18 15:00:00',NULL,60,NULL,1,'medium',119,'matched','前田和良',NULL,1,'imported',NULL,'{\"uuid\":\"Xswm1pOmRfezElNCaBsjPg==\",\"id\":89314073650,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5408\\u540c\\u4f1a\\u793e\\u30a2\\u30d6\\u30ec\\u30a4\\u30ba \\u524d\\u7530\\u548c\\u826f\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-18T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-14T04:24:27Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89314073650?pwd=JbYbPyBi7NaFyr5TEOSGpujUdf3hA6.1\"}','2026-05-30 01:06:49','2026-05-30 13:35:23'),
(23,2,37,1,'87841774146','39CvTMH/TlWiOBJAgfl84Q==','past','tugilo 予定ありさん: 1to1調整用','2026-05-18 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','予定あり',NULL,0,'held',NULL,'{\"uuid\":\"39CvTMH\\/TlWiOBJAgfl84Q==\",\"id\":87841774146,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"tugilo \\u4e88\\u5b9a\\u3042\\u308a\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-18T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-15T00:34:33Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/87841774146?pwd=1QQl30ASZmuxUjaasBaRKhb0RHqV73.1\"}','2026-05-30 01:06:49','2026-05-30 13:29:04'),
(24,2,37,1,'87093216381','c0pWkNeUTyGybjA8YSJaBA==','past','tugilo 予定ありさん: 1to1調整用','2026-05-18 13:00:00',NULL,60,NULL,1,'medium',NULL,'new','予定あり',NULL,0,'held',NULL,'{\"uuid\":\"c0pWkNeUTyGybjA8YSJaBA==\",\"id\":87093216381,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"tugilo \\u4e88\\u5b9a\\u3042\\u308a\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-18T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-15T00:34:23Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/87093216381?pwd=eyimsXldNTMRmO4gt0LNxf4obYwc3s.1\"}','2026-05-30 01:06:50','2026-05-30 13:29:05'),
(25,2,37,1,'82280318209','qCJSEwAqQLCYSQDmSPCceQ==','past','ネスレ探偵事務所 礒部 昌之さん: 1to1調整用','2026-05-14 10:00:00',NULL,60,NULL,1,'medium',101,'matched','昌之',NULL,1,'imported',NULL,'{\"uuid\":\"qCJSEwAqQLCYSQDmSPCceQ==\",\"id\":82280318209,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30cd\\u30b9\\u30ec\\u63a2\\u5075\\u4e8b\\u52d9\\u6240 \\u7912\\u90e8 \\u660c\\u4e4b\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-14T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-08T07:51:29Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82280318209?pwd=hgiMsBVOKtWFFbQs6QWjLrncPqGnzy.1\"}','2026-05-30 01:06:51','2026-05-30 13:35:23'),
(26,2,37,1,'85344850132','jYUX4zxRQLS/2d24XbPJHg==','past','フェニックス人事労務サポートオフィス イトウタカオさん: 1to1調整用','2026-05-13 15:00:00',NULL,60,NULL,1,'medium',100,'matched','イトウタカオ',NULL,1,'imported',NULL,'{\"uuid\":\"jYUX4zxRQLS\\/2d24XbPJHg==\",\"id\":85344850132,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30d5\\u30a7\\u30cb\\u30c3\\u30af\\u30b9\\u4eba\\u4e8b\\u52b4\\u52d9\\u30b5\\u30dd\\u30fc\\u30c8\\u30aa\\u30d5\\u30a3\\u30b9 \\u30a4\\u30c8\\u30a6\\u30bf\\u30ab\\u30aa\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-13T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-27T23:55:40Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85344850132?pwd=ancAYxsasb1bZHrC7KqBCUVjmboVsR.1\"}','2026-05-30 01:06:51','2026-05-30 13:35:23'),
(27,2,37,1,'84841334208','skSq8W+UQZ2UWOaTdECfgw==','past','田形様打合せ','2026-05-13 09:00:00',NULL,60,NULL,1,'medium',NULL,'new','田形',NULL,0,'held',NULL,'{\"uuid\":\"skSq8W+UQZ2UWOaTdECfgw==\",\"id\":84841334208,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u7530\\u5f62\\u69d8\\u6253\\u5408\\u305b\",\"type\":2,\"start_time\":\"2026-05-13T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-10T22:29:48Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84841334208?pwd=wd0giCYip8aaaZIiwBM8bNiqgafXau.1\"}','2026-05-30 01:06:52','2026-05-30 13:31:34'),
(28,2,37,1,'82431536307','4ycbbif/RP29DE6HgPlDoQ==','past','久米加代子さん: 1to1調整用','2026-05-08 18:00:00',NULL,60,NULL,1,'medium',53,'matched','久米加代子',NULL,1,'imported',59,'{\"uuid\":\"4ycbbif\\/RP29DE6HgPlDoQ==\",\"id\":82431536307,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u4e45\\u7c73\\u52a0\\u4ee3\\u5b50\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-05-08T09:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-23T12:38:00Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82431536307?pwd=WE2uZusbXQiymUXMFuoJApIhmCEHYv.1\"}','2026-05-30 01:06:52','2026-05-30 13:35:23'),
(29,2,37,1,'82219483510','kuFarPqvSbyZcnkZhlebpA==','past','芳賀さん121','2026-05-08 17:00:00',NULL,60,NULL,1,'medium',13,'matched','芳賀',NULL,1,'imported',60,'{\"uuid\":\"kuFarPqvSbyZcnkZhlebpA==\",\"id\":82219483510,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u82b3\\u8cc0\\u3055\\u3093121\",\"type\":2,\"start_time\":\"2026-05-08T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-08T07:47:19Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82219483510?pwd=mxH2h73ekAbJOdRJlj5DdfbrWHDNbW.1\"}','2026-05-30 01:06:53','2026-05-30 13:35:23'),
(30,2,37,1,'88102181033','SoN2Cg+PReGFNbRYwLyfbA==','past','次廣淳さん: 1to1調整用','2026-05-08 17:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'held',NULL,'{\"uuid\":\"SoN2Cg+PReGFNbRYwLyfbA==\",\"id\":88102181033,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-05-08T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-07T09:28:03Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88102181033?pwd=HNU0G65ildzb6ECV3TauUg5n0JDZiA.1\"}','2026-05-30 01:06:54','2026-05-30 13:31:46'),
(31,2,37,1,'87948505956','Kbs0oTtZSyixKVngYT5vuw==','past','次廣淳さん: 1to1調整用','2026-05-08 16:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'held',NULL,'{\"uuid\":\"Kbs0oTtZSyixKVngYT5vuw==\",\"id\":87948505956,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-05-08T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-07T09:28:33Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/87948505956?pwd=hgqobFia0dNBCgNiCVueyaDRxdDS1m.1\"}','2026-05-30 01:06:55','2026-05-30 13:31:51'),
(32,2,37,1,'81378792914','xTiXcsJuSsm9fu83MZAwKQ==','past','坪井様打合せ','2026-05-08 15:30:00',NULL,60,NULL,1,'medium',NULL,'new','坪井',NULL,0,'held',NULL,'{\"uuid\":\"xTiXcsJuSsm9fu83MZAwKQ==\",\"id\":81378792914,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u576a\\u4e95\\u69d8\\u6253\\u5408\\u305b\",\"type\":2,\"start_time\":\"2026-05-08T06:30:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-08T04:25:23Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81378792914?pwd=5srTah4SsbLe56bT2xlKIqQ4Ta3T4a.1\"}','2026-05-30 01:06:56','2026-05-30 13:31:53'),
(33,2,37,1,'89157467602','IwdcYnOrRzeXiyNsb0v2pA==','past','田村様1to1','2026-05-07 16:00:00',NULL,60,NULL,1,'medium',98,'matched','田村',NULL,1,'imported',NULL,'{\"uuid\":\"IwdcYnOrRzeXiyNsb0v2pA==\",\"id\":89157467602,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u7530\\u6751\\u69d81to1\",\"type\":2,\"start_time\":\"2026-05-07T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-23T12:24:07Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89157467602?pwd=hk5sB5FWzQ5DIlaCgn68aZyayaSqzY.1\"}','2026-05-30 01:06:57','2026-05-30 13:35:23'),
(34,2,37,1,'82336493242','OKWxBvjsTPyTZfh1Fk7/NA==','past','深澤様1to1','2026-05-07 09:00:00',NULL,60,NULL,1,'medium',146,'matched','深澤',NULL,1,'imported',62,'{\"uuid\":\"OKWxBvjsTPyTZfh1Fk7\\/NA==\",\"id\":82336493242,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6df1\\u6fa4\\u69d81to1\",\"type\":2,\"start_time\":\"2026-05-07T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-23T12:21:27Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82336493242?pwd=IbakLHZti4WTot0N1bBiCVP0bavNLx.1\"}','2026-05-30 01:06:57','2026-05-30 13:35:23'),
(35,2,37,1,'82098291556','w04V3WLZTqOdBPBRLddqYA==','past','岩原様1to1','2026-05-01 17:00:00',NULL,60,NULL,1,'medium',147,'matched','岩原',NULL,1,'imported',63,'{\"uuid\":\"w04V3WLZTqOdBPBRLddqYA==\",\"id\":82098291556,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5ca9\\u539f\\u69d81to1\",\"type\":2,\"start_time\":\"2026-05-01T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-23T12:20:20Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82098291556?pwd=LDUyUcG7eraF3SM3Fh5O4Lvdb7RdgF.1\"}','2026-05-30 01:06:58','2026-05-30 13:35:23'),
(36,2,37,1,'82144696668','hSM5Q+RMS5C8RhTSLcRR8Q==','past','佐藤様1to1','2026-05-01 14:00:00',NULL,60,NULL,1,'medium',17,'matched','佐藤',NULL,1,'imported',64,'{\"uuid\":\"hSM5Q+RMS5C8RhTSLcRR8Q==\",\"id\":82144696668,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u4f50\\u85e4\\u69d81to1\",\"type\":2,\"start_time\":\"2026-05-01T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-23T12:18:20Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82144696668?pwd=TutKNp3HgcRMHwy4datMXDs5aOzna1.1\"}','2026-05-30 01:06:59','2026-05-30 13:35:23'),
(37,2,37,1,'86886689396','HIJgRFSzQeKajNVl/0ci9Q==','past','加門様1to1','2026-05-01 09:00:00',NULL,60,NULL,1,'medium',148,'matched','加門',NULL,1,'imported',65,'{\"uuid\":\"HIJgRFSzQeKajNVl\\/0ci9Q==\",\"id\":86886689396,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u52a0\\u9580\\u69d81to1\",\"type\":2,\"start_time\":\"2026-05-01T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-23T12:16:35Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86886689396?pwd=DcndGD3q2rW9CTpYWLPSELtSRBgxML.1\"}','2026-05-30 01:06:59','2026-05-30 13:35:23'),
(38,2,37,1,'81132808708','7G6BOlPZSDCbtXjv27EsYQ==','past','次廣淳さん: 1to1調整用','2026-04-30 16:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'held',NULL,'{\"uuid\":\"7G6BOlPZSDCbtXjv27EsYQ==\",\"id\":81132808708,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-04-30T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-04-27T12:55:22Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81132808708?pwd=ia8fwqAyD6WXYjLkgt9lqpgAiwL3Zs.1\"}','2026-05-30 01:07:00','2026-05-30 13:35:14'),
(39,2,37,1,'85842362927',NULL,'scheduled','西浦さん打合せ','2026-06-04 15:00:00',NULL,60,NULL,1,'medium',12,'matched','西浦',NULL,1,'imported',66,'{\"uuid\":\"D\\/XRfMY8Q+eCrwx53TgrXg==\",\"id\":85842362927,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u897f\\u6d66\\u3055\\u3093\\u6253\\u5408\\u305b\",\"type\":2,\"start_time\":\"2026-06-04T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-03T14:08:54Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85842362927?pwd=hK6VWE1KJSXtC1gU5gbznMHsezWxqe.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(40,2,37,1,'81031997027',NULL,'scheduled','飯田香さん: 1to1調整用','2026-06-10 15:00:00',NULL,60,NULL,1,'medium',51,'matched','飯田香',NULL,1,'imported',67,'{\"uuid\":\"s6ZX0wLeRHSsFDGrd7pbyw==\",\"id\":81031997027,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u9999\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-10T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-31T10:41:42Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81031997027?pwd=bIshNvaguBxcAjkKEHADoTqyWZj2jI.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(41,2,37,1,'86846787039',NULL,'scheduled','株式会社J.NOVA 打田康平さん: 1to1調整用','2026-06-11 11:00:00',NULL,60,NULL,1,'medium',NULL,'new','打田康平',NULL,0,'held',NULL,'{\"uuid\":\"8bTLQJbWRVSOhzISlVyROA==\",\"id\":86846787039,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eJ.NOVA \\u6253\\u7530\\u5eb7\\u5e73\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T02:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-03T08:43:50Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86846787039?pwd=zosZOT4EBSsdLW7ffqmsSYnphQjbnn.1\"}','2026-06-04 01:41:40','2026-06-04 01:44:28'),
(42,2,37,1,'85299085926',NULL,'scheduled','株式会社Andirich 木村杏那さん: 1to1調整用','2026-06-11 14:00:00',NULL,60,NULL,1,'medium',117,'matched','木村杏那',NULL,1,'imported',68,'{\"uuid\":\"79SMQbboStWlDku\\/1dZ2Ag==\",\"id\":85299085926,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eAndirich \\u6728\\u6751\\u674f\\u90a3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T13:06:19Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85299085926?pwd=GWD2NBUlONxJaQ4pueEujRHrgVm3b4.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(43,2,37,1,'82538110131',NULL,'scheduled','飯田千帆さん: 1to1調整用','2026-06-12 09:00:00',NULL,60,NULL,1,'medium',50,'matched','飯田千帆',NULL,1,'imported',69,'{\"uuid\":\"X7hpvFTiQL65x\\/cQDhqlcg==\",\"id\":82538110131,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u5343\\u5e06\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-12T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T04:02:12Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82538110131?pwd=5vBZNOQVq0PVNaURpaH7MgEBbDVD1T.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(44,2,37,1,'82306905507',NULL,'scheduled','株式会社u\'i 清原佳彩美さん: 1to1調整用','2026-06-12 10:00:00',NULL,60,NULL,1,'medium',48,'matched','清原佳彩美',NULL,1,'imported',70,'{\"uuid\":\"6bwZ7SwkQBaFe0Q4lmq1aQ==\",\"id\":82306905507,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eu\'i \\u6e05\\u539f\\u4f73\\u5f69\\u7f8e\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-12T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T08:19:01Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82306905507?pwd=cqrPA4vKEy90wTYjOh4t2SnaN2YuOz.1\"}','2026-06-04 01:41:40','2026-06-04 01:44:30'),
(45,2,37,1,'82063966389',NULL,'scheduled','熊谷龍笙さん: 1to1調整用','2026-06-17 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','熊谷龍笙',NULL,1,'held',NULL,'{\"uuid\":\"EoCycEd6TZqStx3VpF5jmA==\",\"id\":82063966389,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u718a\\u8c37\\u9f8d\\u7b19\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-17T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T23:39:52Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82063966389?pwd=pmrLZXu1NVyDmr0tagaz5BE6fdhqGw.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(46,2,37,1,'85054251043','RdBgZ2BpQF6nq437OGYGDA==','past','アンフィニ 福田航平さん: 1to1調整用','2026-06-04 09:00:00',NULL,60,NULL,1,'medium',139,'matched','福田航平',NULL,1,'imported',42,'{\"uuid\":\"RdBgZ2BpQF6nq437OGYGDA==\",\"id\":85054251043,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30a2\\u30f3\\u30d5\\u30a3\\u30cb \\u798f\\u7530\\u822a\\u5e73\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-04T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-21T22:45:22Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85054251043?pwd=ba1o9a2mhaw3a9H6ROtS1C4BeaHt3z.1\"}','2026-06-04 01:41:43','2026-06-04 01:43:27'),
(47,2,37,1,'89109217407','9Wcixbz/Tiyj6ubYB4XquA==','past','山本葉子さん: 1to1調整用','2026-06-03 15:00:00',NULL,60,NULL,1,'medium',27,'matched','山本葉子',NULL,1,'imported',41,'{\"uuid\":\"9Wcixbz\\/Tiyj6ubYB4XquA==\",\"id\":89109217407,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5c71\\u672c\\u8449\\u5b50\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-03T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-29T11:59:21Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89109217407?pwd=bDE5WtzsZjjMfJc2Nvoobf5qMRV2sx.1\"}','2026-06-04 01:41:44','2026-06-04 01:43:41'),
(48,2,37,1,'83714290448','i4hQDaQNQeCR0Rc2oz4Yqw==','past','株式会社ハーベスト 寺田直史さん: 1to1調整用','2026-06-01 17:00:00',NULL,60,NULL,1,'medium',140,'matched','寺田直史',NULL,1,'imported',40,'{\"uuid\":\"i4hQDaQNQeCR0Rc2oz4Yqw==\",\"id\":83714290448,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30cf\\u30fc\\u30d9\\u30b9\\u30c8 \\u5bfa\\u7530\\u76f4\\u53f2\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-28T07:49:41Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83714290448?pwd=D6hxZbvXx8cb4wOi4az1dqdMRWx02d.1\"}','2026-06-04 01:41:45','2026-06-04 01:43:27'),
(49,2,37,1,'86416812471','QjTZsT51Q/m770eDU1Ql0w==','past','株式会社pipon 小中貴晃さん: 1to1調整用','2026-06-01 15:00:00',NULL,60,NULL,1,'medium',34,'matched','小中貴晃',NULL,1,'imported',38,'{\"uuid\":\"QjTZsT51Q\\/m770eDU1Ql0w==\",\"id\":86416812471,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793epipon \\u5c0f\\u4e2d\\u8cb4\\u6643\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T04:36:44Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86416812471?pwd=mkiUsHGZLwkqcIjab9KYAAUUNNZmpO.1\"}','2026-06-04 01:41:47','2026-06-04 01:44:30'),
(50,2,37,1,'84716679422','itH7LYidQN2JvdnRcytlHw==','past','RUILED VISION JAPAN株式会社 原田里織さん: 1to1調整用','2026-06-01 14:00:00',NULL,60,NULL,1,'medium',18,'matched','原田里織',NULL,1,'imported',37,'{\"uuid\":\"itH7LYidQN2JvdnRcytlHw==\",\"id\":84716679422,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"RUILED VISION JAPAN\\u682a\\u5f0f\\u4f1a\\u793e \\u539f\\u7530\\u91cc\\u7e54\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T08:09:09Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84716679422?pwd=QHTRp3oMGIJGI7J5abG5aTPxj6kaZe.1\"}','2026-06-04 01:41:48','2026-06-04 01:44:30');
/*!40000 ALTER TABLE `zoom_meeting_imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'dragonfly'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-04 12:12:43
