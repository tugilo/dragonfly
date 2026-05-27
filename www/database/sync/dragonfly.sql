-- dragonfly dev DB sync dump
-- generated: 2026-05-27 17:01:09 JST
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(30,12,1,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[18,28,37,5,14,128],\"notes\":\"\\u77f3\\u539f\\u6c0f\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\"},{\"room_label\":\"BO2\",\"member_ids\":[18,28,37,5,14,133],\"notes\":\"\\u4f50\\u85e4\\u6c0f\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\"}]}','2026-05-26 10:43:19','2026-05-26 10:43:19','2026-05-26 10:43:19');
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(37,12,'BO2',1,'佐藤氏の事業紹介','2026-05-26 10:42:31','2026-05-26 10:43:19');
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
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(244,'骨盤底筋体操','骨盤底筋体操','2026-05-25 17:33:03','2026-05-25 17:33:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(7,9,'meeting_csv_imports/9/20260420221902_dragonfly_206_20260421_all_full.csv','dragonfly_206_20260421_all_full.csv','2026-04-20 22:19:02',NULL,NULL,'2026-04-20 22:19:02','2026-04-20 22:19:02');
/*!40000 ALTER TABLE `meeting_csv_imports` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(5,9,'meeting_participant_imports/9/ad1a72e0-b3c5-4c19-ade8-891c2fbe05c2.pdf','定例会参加者リスト2026_04_21.pdf','uploaded','2026-04-20 22:18:57','failed',NULL,NULL,NULL,NULL,'2026-04-20 22:18:54','2026-04-20 22:18:57');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(12,209,'2026-05-26','第209回定例会',2,'2026-05-25 17:33:03','2026-05-25 17:33:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=485 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(484,53,12,'2026-05-25','2026-05-26','2026-05-25 17:33:03','2026-05-26 09:02:55');
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
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES
(1,'平岡　国彦',NULL,NULL,NULL,1,'member','1',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(2,'増本　重孝',NULL,NULL,NULL,1,'member','2',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(3,'長谷川　貴志',NULL,NULL,NULL,1,'member','3',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(4,'松倉　健治',NULL,NULL,NULL,1,'member','5',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(5,'福上　大輝',NULL,NULL,NULL,1,'member','6',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(6,'太田　一誠',NULL,NULL,NULL,1,'member','7',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(7,'高野　和義','たかの　かずよし',NULL,82,1,'member','7',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-03-16 23:42:37'),
(8,'福士　利明',NULL,NULL,NULL,1,'member','4',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(9,'中村　啓吾',NULL,NULL,NULL,1,'member','8',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(10,'倉持　賢一',NULL,NULL,NULL,1,'member','9',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(11,'岡元　智美',NULL,NULL,NULL,1,'member','10',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(12,'西浦　雅',NULL,NULL,NULL,1,'member','11',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(13,'芳賀　崇利',NULL,NULL,NULL,1,'member','12',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(14,'西岡　優希',NULL,NULL,NULL,1,'member','13',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(15,'横山　尚武',NULL,NULL,NULL,1,'member','14',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(16,'Rii','りー',NULL,91,1,'member','16',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-04-13 12:13:25'),
(17,'佐藤　拓斗',NULL,NULL,NULL,1,'member','15',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(18,'原田　里織',NULL,NULL,NULL,1,'member','16',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(19,'平山　真由美',NULL,NULL,NULL,1,'member','18',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(20,'舩杉　牧子',NULL,NULL,NULL,1,'member','19',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(21,'渡邊　真大',NULL,NULL,NULL,1,'member','20',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(22,'大竹　絵理香',NULL,NULL,NULL,1,'member','21',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(23,'山口　薫',NULL,NULL,NULL,1,'member','22',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(24,'海沼　功',NULL,NULL,NULL,1,'member','23',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(25,'紀川　和弘',NULL,NULL,NULL,1,'member','24',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(26,'竹内　駿太',NULL,NULL,NULL,1,'member','25',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(27,'山本　葉子',NULL,NULL,NULL,1,'member','26',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(28,'梅澤　朗広',NULL,NULL,NULL,1,'member','27',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(29,'加藤　隆太',NULL,NULL,NULL,1,'member','39',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(30,'越賀　淑恵',NULL,NULL,NULL,1,'member','28',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(31,'望月　雅幸',NULL,NULL,NULL,1,'member','29',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(32,'佐久間　康丞',NULL,NULL,NULL,1,'member','30',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(33,'斎藤　和貴',NULL,NULL,NULL,1,'member','31',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(34,'小中　貴晃',NULL,NULL,NULL,1,'member','32',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(35,'山本　洸太',NULL,NULL,NULL,1,'member','33',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(36,'軍司　敦哉',NULL,NULL,NULL,1,'member','34',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(37,'次廣　淳',NULL,NULL,NULL,1,'member','35',NULL,'AI業務改善システム構築の次廣です。\n時間を生み出すSEです。\n\n建設業や製造業で、Excel・手作業の見積、現場、請求を、\n1回の入力で回る仕組みにします。\n\n担当者しか分からない状態を、誰でも追える形に変えます。\n\nそんな会社様や、顧問先に持つ士業・コンサルの方とお繋ぎください。\n\nAI業務改善システム構築の次廣でした。','AI業務改善システム構築の次廣です。\n時間を生み出すSEです。\n\n私は、建設業や製造業、現場仕事の多い会社で、\nExcelや手作業で行っている見積、現場管理、請求業務を、\n1回の入力で回る仕組みに変えるお手伝いをしています。\n\n担当者しか分からない状態を、\n誰でも追えて、ミスなく回る形に整えます。\n\n実際に、DragonFlyメンバーの増本さんの害虫ブロック事業でも、\n業務の流れに合わせたシステムを構築し、\nかなり成果が出始めています。\n\n私が作っているのは、単なるシステムではなく、\n社長や現場の方が、本来やるべき仕事に集中するための時間です。\n\nご紹介いただきたいのは、\n建設業・製造業・現場仕事の多い会社で、\nExcel管理や手入力が多く、そろそろ仕組み化したい会社様です。\n\nまた、そういった会社を顧問先に持つ、\n士業・コンサルの方ともぜひお繋ぎください。\n\nAI業務改善システム構築の次廣でした。',NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(38,'吉田　俊之','よしだとしゆき',NULL,111,1,'member','35',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-18 22:56:51'),
(39,'里見　允二',NULL,NULL,NULL,1,'member','37',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(40,'畠山　憲之',NULL,NULL,NULL,1,'member','38',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(41,'今西　俊明',NULL,NULL,NULL,1,'member','40',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(42,'廣田　誠悟',NULL,NULL,NULL,1,'member','41',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(43,'田渕　恭平',NULL,NULL,NULL,1,'member','42',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(44,'木村　健悟',NULL,NULL,NULL,1,'member','43',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(45,'立岡　海人','たつおか　かいと',NULL,118,1,'member','45',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-03-16 23:42:37'),
(46,'藤井　恵理子',NULL,NULL,NULL,1,'member','44',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(47,'今村　千絵',NULL,NULL,NULL,1,'member','45',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(48,'清原　佳彩美',NULL,NULL,NULL,1,'member','46',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(49,'船津　麻理子',NULL,NULL,NULL,1,'member','47',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(50,'飯田　千帆',NULL,NULL,NULL,1,'member','48',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(51,'飯田　香',NULL,NULL,NULL,1,'member','49',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(52,'野口　裕子',NULL,NULL,NULL,1,'member','50',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(53,'久米　加代子',NULL,NULL,NULL,1,'member','51',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(54,'藤田　磨紀',NULL,NULL,NULL,1,'member','52',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(55,'上田　友顕','うえだ　ともあき',NULL,187,1,'visitor','V1',NULL,NULL,NULL,11,11,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(56,'渡井　みづき','わたい　みづき',NULL,188,1,'visitor','V2',NULL,NULL,NULL,41,12,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(57,'河北　竜也','かわきた　たつや',NULL,189,1,'visitor','V3',NULL,NULL,NULL,11,39,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(58,'天野　未央','あまの　みお',NULL,190,1,'visitor','V4',NULL,NULL,NULL,20,20,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(59,'渡邉　飛鳥','わたなべ　あすか',NULL,180,1,'visitor','V5',NULL,NULL,NULL,35,46,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(60,'林　敏史','はやし　としふみ',NULL,201,1,'guest','G1',NULL,NULL,NULL,20,41,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(61,'伊藤　剛','いとう　ごう',NULL,202,1,'guest','G2',NULL,NULL,NULL,29,34,'2026-03-03 00:34:23','2026-04-13 12:58:33'),
(62,'京極　祥平','きょうごく　しょうへい',NULL,184,1,'guest','G3',NULL,NULL,NULL,13,NULL,'2026-03-03 00:34:23','2026-04-07 00:04:59'),
(63,'久米　加代子','くめ　かよこ',NULL,163,1,'guest','G4',NULL,NULL,NULL,40,NULL,'2026-03-03 00:34:23','2026-04-07 00:04:59'),
(64,'小林　美香','こばやし　みか',NULL,200,1,'guest','P1',NULL,NULL,NULL,51,4,'2026-03-10 00:40:14','2026-04-13 12:58:33'),
(65,'山崎　勇一',NULL,NULL,NULL,1,'member','53',NULL,NULL,NULL,NULL,NULL,'2026-03-16 23:42:37','2026-05-26 09:02:55'),
(66,'森園　友喜','もりぞの　ゆうき',NULL,14,1,'visitor','V6',NULL,NULL,NULL,1,5,'2026-03-16 23:42:37','2026-04-13 12:58:33'),
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
(78,'木下　馨',NULL,NULL,NULL,1,'member','54',NULL,NULL,NULL,NULL,NULL,'2026-03-31 00:09:20','2026-05-26 09:02:55'),
(79,'渡邉　飛鳥','わたなべ　あすか',NULL,180,NULL,'visitor','V16',NULL,NULL,NULL,35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(80,'山下　一樹','やました　かずき',NULL,181,NULL,'visitor','V17',NULL,NULL,NULL,13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(81,'米澤　侑桂','よねざわ　ゆうけい',NULL,NULL,NULL,'visitor','V-Yonezawa',NULL,NULL,NULL,NULL,NULL,'2026-04-13 14:11:46','2026-04-13 14:11:46'),
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
(95,'髙橋　豊','たかはし　ゆたか',NULL,216,NULL,'guest','G2',NULL,NULL,NULL,18,1,'2026-05-12 08:00:44','2026-05-12 08:00:44'),
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
(123,'権堂　千栄実',NULL,NULL,NULL,6,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-21 16:13:21','2026-05-21 16:13:21'),
(124,'御手洗氏（名 TODO）',NULL,NULL,NULL,9,'visitor',NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-22 16:46:29','2026-05-22 16:46:29'),
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
(135,'森園　友喜',NULL,NULL,NULL,NULL,'member','17',NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:02:55','2026-05-26 09:02:55'),
(136,'米澤　侑桂',NULL,NULL,NULL,NULL,'member','36',NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:02:55','2026-05-26 09:02:55'),
(137,'南方　優馬','なんぽ　ゆうま',NULL,NULL,10,'visitor',NULL,NULL,NULL,NULL,31,NULL,'2026-05-27 17:00:47','2026-05-27 17:00:47');
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(52,'2026_05_18_121111_add_religo_role_to_users_table',28);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
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
  `scheduled_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `ended_at` datetime DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `one_to_ones_workspace_id_foreign` (`workspace_id`),
  KEY `one_to_ones_target_member_id_foreign` (`target_member_id`),
  KEY `one_to_ones_owner_member_id_target_member_id_index` (`owner_member_id`,`target_member_id`),
  KEY `one_to_ones_scheduled_at_index` (`scheduled_at`),
  KEY `one_to_ones_meeting_id_index` (`meeting_id`),
  CONSTRAINT `one_to_ones_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_ones_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `one_to_ones_target_member_id_foreign` FOREIGN KEY (`target_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `one_to_ones_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `one_to_ones`
--

LOCK TABLES `one_to_ones` WRITE;
/*!40000 ALTER TABLE `one_to_ones` DISABLE KEYS */;
INSERT INTO `one_to_ones` VALUES
(6,1,37,31,NULL,'2026-03-06 05:00:00',NULL,'2026-03-06 06:00:00','completed','お互いのビジネスの紹介\nシステムと助成金で協業できそう。見積もりが作成できればOK','2026-03-23 12:47:04','2026-03-23 12:47:04'),
(7,1,37,42,NULL,'2026-03-11 04:00:00',NULL,'2026-03-11 05:00:00','completed','お互いのビジネス紹介','2026-03-23 12:48:50','2026-03-23 12:48:50'),
(8,1,37,44,NULL,'2026-03-12 05:00:00',NULL,'2026-03-12 06:00:00','completed','アナログな生産管理をシステム化に前向き\n提案書を提出済み','2026-03-23 12:49:51','2026-03-23 12:49:51'),
(9,1,1,11,NULL,'2026-03-16 02:00:00',NULL,'2026-03-16 03:00:00','completed','お互いのビジネスの紹介','2026-03-23 12:51:50','2026-03-23 12:51:50'),
(10,1,37,10,NULL,'2026-04-02 06:00:00',NULL,'2026-04-02 07:00:00','completed','エアコン本舗案件メモ（保存用）\n\n■ 概要\n	•	倉持氏との打ち合わせにて以下2点が前進\n	•	ウェブマスター役割の打診 → 前向きに検討\n	•	エアコン本舗案件 → 開発チーム参画の可能性あり\n	•	次回アクション：4月13日 1to1（11:00〜12:00）\n\n⸻\n\n■ 決定事項\n\n① ウェブマスター\n	•	次廣が担当する方向で調整\n	•	BNI内の運営・情報管理ポジション\n\n② 1to1ミーティング\n	•	日時：4月13日 11:00〜12:00\n	•	倉持氏よりZoom URL共有予定\n\n③ エアコン本舗案件\n	•	チーム参画の方向で検討開始\n	•	本格開発は秋頃予定\n\n⸻\n\n■ ウェブマスター業務（理解整理）\n\n● 主業務\n	•	BNIサイト管理（メンバー情報・公開設定）\n	•	定例会サポート（Zoom・スライド・録画）\n	•	動画編集・アップロード（週次）\n	•	SNS運用（Facebook / LINEの使い分け）\n	•	ビジター情報管理（Nキャス）\n\n● 使用ツール\n	•	BNIコネクト\n	•	Nキャス\n	•	Zoom\n	•	Facebook / LINE\n\n⸻\n\n■ エアコン本舗案件（重要）\n\n● 課題\n	•	業務フローが非効率（受注〜施工）\n	•	売上・利益の可視化が遅い（約1ヶ月遅延）\n\n● 提案内容（予定）\n	•	受注管理システム\n	•	在庫・発注の自動化\n	•	アサイン最適化\n	•	AI電話による日程調整\n\n● 開発タイミング\n	•	夏：計測・準備フェーズ\n	•	秋：本格開発\n\n● 体制\n	•	PM：倉持氏\n	•	PMコーチ：佐野氏（元アクセンチュア）\n	•	技術：伊藤氏（GPS最適化）\n	•	開発候補：次廣（tugilo）\n\n⸻\n\n■ 自分の強み（再認識）\n	•	工程管理・アサイン系システムの構築経験あり\n	•	LINE連携システム実績あり\n	•	フルスタック対応（BE/FE/インフラ）\n	•	業務理解＋エンジニア橋渡しができる\n\n⸻\n\n■ 4/13 1to1の目的\n\n● ゴール\n	•	エアコン本舗案件の関わり方を具体化\n	•	自分の役割ポジションを明確にする\n\n⸻\n\n■ 1to1で確認すること\n\n● ウェブマスター\n	•	期待されている役割範囲\n	•	工数・優先度\n\n⸻\n\n● エアコン本舗（最重要）\n\n現状把握\n	•	一番のボトルネックはどこか\n	•	現場 or 管理どちらが詰まっているか\n	•	現在の業務フロー\n\n深掘り質問（tugilo視点）\n	•	人依存になっている部分は？\n	•	同じ入力を何回しているか？\n	•	数字はいつ確定しているか？\n\n⸻\n\n■ 提案方針（tugilo式）\n\n❌ いきなり開発しない\n\n⭕ 小さく始める\n\n⸻\n\n● フェーズ設計\n\nPhase1：見える化\n	•	データ収集・現状把握\n\nPhase2：整理\n	•	フロー整理・無駄削減\n\nPhase3：システム化\n	•	必要部分のみ実装\n\n⸻\n\n■ キーメッセージ\n\n👉\n「現場は変えない。でも、気づいたら楽になっている状態を作る」\n\n⸻\n\n■ 次アクション\n\n事前\n	•	1to1質問整理\n	•	エアコン業界の流れ軽く把握\n\n事後\n	•	業務フローの構造図作成\n	•	フェーズ提案資料作成\n\n⸻\n\n■ メモ（気づき）\n	•	ウェブマスターは信頼獲得ポジション\n	•	エアコン本舗はtugiloの勝ちパターン案件\n	•	「いきなり作らない」が今回のキー','2026-04-02 21:05:22','2026-04-02 21:05:22'),
(11,1,37,17,NULL,'2026-04-02 22:15:00',NULL,'2026-04-02 23:15:00','completed','#### 基本情報\n\n- **日時:** **2026-04-03（金）JST 07:15–08:15**（60分）。**取得元:** ユーザー確認（当日の1to1実績）。※過去の Zoom要約段階では日時未記載だったため、本項で確定。\n- **実施方法:** Zoom\n\n#### 話した内容（重要）\n\n※**削減せず**蓄積。以下は Zoom要約・当時の整理メモからの**記録**。\n\n- **主な流れ:** 次廣淳（AI・業務改善システム構築）と佐藤拓斗（高校生新卒採用コンサル）が BNI ドラゴンフライチャプターで **初回 1on1**。両者の事業内容を共有し、**テレアポリスト自動作成システム**の開発可能性について具体的検討を開始。静岡県藤枝市という地元の共通点から、今後の協力関係構築の基盤を確立した、との整理。\n- **決定・合意:**\n  - **リスト作成システムの検討開始:** 佐藤氏のテレアポリスト作成業務（現在手作業で **1時間100件**）を自動化するシステムについて、次廣氏が **技術的実現可能性を調査**。\n  - **求人媒体からのデータ取得:** リクナビネクスト等の求人サイトから、**従業員数30名以下** などの条件で自動抽出する仕組みを検討。**スクレイピング技術の活用**、ただし **法的リスクの確認が必要**。\n  - **5月中旬の再会:** 佐藤氏の静岡帰省時（**5月16–17日頃**）に **対面ミーティング** を設定する方向。\n- **次廣側で共有された事業内容:**\n  - **業務改善システム構築:** エクセル・スプレッドシートで分散管理されているデータを一元化し、リアルタイムでの進捗確認を実現。\n  - **LINE活用システム:** 問い合わせから見積もり、請求までを LINE 公式アカウントで完結させる仕組み（建設業向け）。\n  - **スタンプラリー・ビンゴシステム:** 静岡観光協会向けに **5年間運用中**。\n  - **施工管理・日報システム:** 名古屋のシーリング会社向けに、外国人労働者でも入力しやすい LINE ベースの業務日報システムを構築。\n  - **事業の特徴:** ゼロから1を作れる／既製ツールの押し付けではなく現場フローに合わせたカスタマイズ。**小さく始めて改善**（大規模を一気に入れず、入力から段階拡張）。**現場負担の最小化**（経営と現場のギャップを埋め、現場にベネフィットを与える設計）。\n  - **経歴・背景:** システム開発歴 **25–26年**（大学中退後一貫、現在 **52–53歳**）。BNI は増本氏・今西氏との静岡出世クラブでの **約10年の付き合い** から **2024年** にドラゴンフライ参加を決意。動機は技術一辺倒からの転換・仕事の幅拡大。**MSP（メンバーサクセスプログラム）** で学んだビジネススキルに感銘、トレーニング注力中。\n- **佐藤側で共有された事業内容（1to1上の詳細・プロフィールと照合可）:**\n  - **高校生新卒採用の仕組み構築:** ホームページ制作、パンフレット・動画制作、学校訪問代行、求人資料郵送代行まで一括。\n  - **4月依頼でも7月解禁に間に合う** 短期対応が可能。**全国対応**（BNI参加により全国展開が加速）。\n  - **ターゲット:** 従業員 **30名以下** が中心（プロフィールは **20〜30名以下** — 会話では30名以下条件でリスト抽出の話あり）。タイプ **3つ**: ①高校生採用のやり方が分からない ②やりたいが時間・人員不足 ③応募が来ない（我流で抜けがある）。業種: 建設業、製造業、自動車整備、ビルメンテナンス、清掃、介護福祉など。\n  - **実績:** **2024年度** 29社サポート、14社で採用成功（成功率 **約48%**）。**過去5年** 毎年40社以上サポート（2023年32社、2024年は50社近く）。\n  - **経歴・背景:** 事業歴 **5年**。新卒で高校生新卒採用コンサル会社に入社、**2024年3月に独立**（当時 会社設立から **1年** と共有）。学歴: 清水東高校→静岡大学→早稲田大学編入→早稲田大学大学院（**教員免許保有**）。**将来ビジョン:** 高校生以下を対象としたキャリア教育事業。**五教科と社会を結びつける授業** で子どもの将来の選択肢を広げたい。\n- **確認待ち（会話上の論点）:**\n  - リクナビネクストからのデータ取得: **技術的実現可能性** と **法的リスク（利用規約上の二次利用制限）** を次廣氏が調査中。\n  - Google マイビジネス API: 個人事業主リスト作成について、**二次利用禁止ルール** があり、公開情報からの取得方法を検討。\n- **共通点・シナジー:**\n  - **地元:** 両者とも静岡県藤枝市出身・在住。佐藤氏は藤枝市古利（西焼津小学校区）、次廣氏は青葉町（青島中学校区）。\n  - **教育への関心:** 次廣氏は娘の受験を控え、佐藤氏のキャリア教育理念（五教科と社会の結びつけ）に強く共感。\n  - **システム×採用:** 次廣氏は静岡県の大卒求人サイト **「三並び」** のアプリ開発を受注中。**大学生がメールを見ない** ため通知機能が必要、という課題を共有。\n- **アクションアイテム（当時の整理）:**\n  - 次廣氏: 求人媒体からのリスト自動作成システムの **技術調査・提案準備**。\n  - 佐藤氏: **5月中旬の静岡帰省日程確定後**、次廣氏に連絡。\n  - 両者: **名古屋出世クラブ（5月末）** への参加可能性を検討（今西氏が佐藤氏を誘致中）。\n- **次回ミーティング:** **5月16–17日頃**、佐藤氏静岡帰省時に **対面** で実施予定。\n- **プライベート文脈（会話に出た事実の記録・紹介判断とは分離）:** 婚活、飯田氏からの占い（**32歳で結婚** 等）、保険担当の高校同級生からの紹介の動きなどが要約に含まれる。**取り扱い注意。本人確認のうえ参照。**\n\n#### 抽出された課題（事実：会話で言及）\n\n- テレアポ用リスト作成の **手作業負荷**（約1時間100件ペース）。\n- 求人媒体からの自動取得は **技術** に加え **利用規約・法的リスク（二次利用）** の確認が必要、との合意。\n- Google マイビジネス／公開情報は **二次利用禁止** の話題があり、個人事業主リストは **取得経路の設計** が課題。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** リスト作成が **コンサル本業とリソース競合** している。**根拠:** 手作業1時間100件の共有。**構造（仮説）:** リード前処理が属人・手作業 → 営業・提案に振る時間が圧迫 → スケールしにくい。\n- **課題②:** データ取得は **「作れるか」より「取ってよいか」** が先に決まる。**根拠:** スクレイピング・API の **法的リスク確認** が合意事項。**構造（仮説）:** 技術要件とコンプライアンスが分離できないと、開発が進んでも運用不能になりうる。\n- **シナジー:** 「採用」周辺に **通知・進捗・フォロー** のデジタル化が横展開しうる。**根拠:** 三並び案件で **メールを見ない大学生** と通知ニーズの共有。**仮説**としての展開可能性。\n\n#### 次アクション\n\n- 次廣: 技術調査・法務・規約リスク整理・提案準備。\n- 佐藤: 帰省日程確定後に連絡 → 5/16–17頃 対面設定。\n- 双方: 名古屋出世クラブ（5月末）参加の検討。','2026-04-07 03:35:52','2026-04-13 14:11:46'),
(12,1,37,81,NULL,'2026-04-08 09:00:00','2026-04-08 09:00:00','2026-04-08 10:00:00','completed','【第1回 1to1 実施メモ — ソース: docs/meetings/1to1/1to1_yonezawa_yuka_comechan_design.md】\n実施: 2026-04-08（水）JST 09:00–10:00（1時間）／オーナー: 次廣 淳 → 対象: 米澤 侑桂（Comechan Design）\n\n■ サマリ\n・米澤: デザイン〜コーディング・実装まで一貫対応可能（Webデザイナー兼エンジニア）を確認。\n・学生向け求人サイトアプリ化（来週契約予定）: フロントのデザイン・コーディングを米澤へ依頼する方向で合意。\n・古紙回収 LINE: リッチメニュー2件（法人用・個人用）を米澤へ依頼決定。\n・価格: リッチメニュー 4,000〜5,000円/枚、LPは規模に応じ工数ベース見積もり（合意）。\n\n■ 確定協業（体制）\n次廣のシステム開発案件に、米澤がデザイン・コーディング・実装（フロント中心）で協業開始に合意。\n求人サイト: 次廣はアプリ基盤・契約・バックエンド/通知、米澤はフロントのデザイン・コーディング。\nリッチメニュー: 米澤が制作、次廣が要件（腰回収LINEの運用コンテキスト）。\n\n■ 求人サイトアプリ化（概要）\n既存PHP WebをWebViewでアプリ化、メール開封率の課題にプッシュ通知。技術: WebView、Flutter検討中（RNとの選定は保留）。オープン予定は要確認（ドキュメントは2026年4月目安）。下部リッチメニュー風ナビ＋Web表示など。詳細仕様は契約・打ち合わせ後。\n\n■ スキル確認（抜粋）\nTailwind、JSフレームワーク（RN含む）、レスポンシブ、アプリデザイン経験。AI: Claude Code / ChatGPT / Gemini。業務委託2社・クラウドワークス経由2年以上。講師卒業後は余裕、個人案件で共創を増やしたい意向。\n\n■ 次アクション（次廣）\n契約後に求人サイトの具体仕様を再打ち合わせ。至急: リッチメニュー2件の要件共有。次回MTG: 契約完了後の詳細打ち合わせ。\n\n■ 次アクション（米澤）\nリッチメニュー制作・納品。詳細打ち合わせ後に求人フロントの見積・スケジュール提示。\n\n■ BNI\nビジター。オリエン2026-04-07（太田氏）。チャプター参加は例会201（2026-03-17）・204（2026-04-07）で2回。','2026-04-08 01:09:53','2026-04-13 14:11:46'),
(13,1,37,19,NULL,'2026-04-08 11:00:00',NULL,'2026-04-08 12:00:00','completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_hirayama_mayumi_lifesupport.md】\n実施: 2026-04-08（水）JST 11:00〜（終了時刻は未確定のため DB 上は暫定で +1h）／オーナー: 次廣 淳 → 対象: 平山 真由美（ライフサポート）\n\nサマリ: パスポートほぼ完了（メンバーシップ残）。倉本氏ウェブマスターを次廣がシステム面支援で合意。40人リストテンプレ・神山氏（中小企業診断士）紹介・静岡車屋2名／カーマッチ検討。リージョンフォーラム 2026-11-09 対面予定。','2026-04-13 14:14:45','2026-04-13 23:17:33'),
(14,1,37,10,NULL,'2026-04-13 11:00:00',NULL,'2026-04-13 12:00:00','completed','【第2回 1to1 — ソース: docs/meetings/1to1/1to1_kuramoto_kenichi_webmaster.md】\n実施: 2026-04-13（月）JST 11:00–12:00／オーナー: 次廣 淳 → 対象: 倉持 賢一（WEBマスター）\n\n合意: ITウェブパワーチーム招待、坂木氏（ジオロケ）紹介、双葉企画連携検討、佐藤正夫氏ロジカルシンキング講座の案内。\n保留: エアコン案件（来週提案・5月頃要件定義の可能性）、Excel顧客管理DB化、LP等コーディング、都内対面。\n次廣: N-CAS資料・法人化・ポジショニング。','2026-04-13 23:18:48','2026-04-13 23:18:48'),
(15,1,37,49,NULL,'2026-04-13 14:30:00',NULL,'2026-04-13 15:30:00','completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_funatsu_mariko_aicare_lab.md】\n実施: 2026-04-13（月）JST 14:30–15:30／オーナー: 次廣 淳 → 対象: 船津 麻理子（アイケアラボ・眼の整体）\n\n合意: 藤本税理士・秋田財務コンサル紹介（船津）、眼科医紹介検討（次廣・関東）、FC本部へのシステム提案（次廣）。\n協業: FCシステム化・軽量顧客管理・医療連携。\n次: 翌日 DragonFly イベント再会。','2026-04-13 23:22:13','2026-04-13 23:22:13'),
(16,1,37,40,NULL,'2026-04-13 18:00:00',NULL,'2026-04-13 19:00:00','completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_hatakeyama_noriyuki_wagashi_oem.md】\n実施: 2026-04-13（月）JST 18:00–19:00／オーナー: 次廣 淳 → 対象: 畠山 憲之（和スイーツOEM）\n\n成果: メンバーシップ完了共有、業務課題（Excel・属人化・OEM増）とシステム化方向性の確認。\n合意: 採用後に優先順位整理・段階検討、詳細ヒアリングのため再1on1。\n次廣: 再1on1設定・改善提案準備。畠山: 採用優先・業務整理。','2026-04-13 23:27:04','2026-04-13 23:27:04'),
(17,1,37,96,NULL,'2026-04-17 09:55:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_suzuki_kensuke_studio_suzu.md】\n実施: 2026-04-17 JST 09:55〜\n\nスタートアッププレゼン改善、オンライン発表時のPDF化、藤原氏（VR推進協会）紹介、VR×サウナコンテンツ、北欧サウナ体験、飲食店向けAIコールセンターの芽を整理。','2026-05-17 22:26:13','2026-05-17 22:26:13'),
(18,1,37,26,NULL,'2026-04-20 15:53:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md】\n実施: 2026-04-20 JST 15:53〜\n\nアスリート専門保険・キッズマネー教育と、次廣のAI業務改善システム構築の相互紹介可能性を確認。静岡PTA・サッカー人脈、法人営業先のDXニーズ紹介をTodo化。','2026-05-17 22:26:13','2026-05-17 22:26:13'),
(19,1,37,4,NULL,'2026-04-24 11:30:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_matsukura_kenji_glassfilm_coating.md】\n実施: 2026-04-24 JST 11:30〜\n\nガラスフィルム・コーティング事業、エアロゲル透明断熱フィルム、高級リゾートホテル営業、静岡インテリア資材卸売会社への紹介検討、リファーラルプレゼン改善を整理。','2026-05-17 22:26:13','2026-05-17 22:26:13'),
(20,1,37,97,NULL,'2026-04-27 10:58:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_iizuka_graphic_design.md】\n実施: 2026-04-27 JST 10:58〜\n\nグラフィックデザイン事業と次廣のB2B業務改善・システム構築を相互共有。社労士・雨漏り調査・竹本氏紹介、田渕氏・行政書士メンバー紹介、システム×デザイン協業、月次1on1合意を整理。','2026-05-17 22:26:13','2026-05-17 22:26:13'),
(21,1,37,98,NULL,'2026-05-07 15:57:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_tamura_kodai_money_cooking.md】\n実施: 2026-05-07 JST 15:57〜\n\n金融・保険・投資助言モデルと次廣のAI業務改善システム開発を共有。建設業向け損保削減＋DX協業、SE・SEO・FC専門家紹介、次廣の保険・投資相談をTodo化。','2026-05-17 22:26:13','2026-05-17 22:26:13'),
(22,1,37,99,NULL,'2026-05-08 14:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md】\n実施: 2026-05-08 JST 14:00〜\n\n創業160年の製本会社・家系図/ルーツ調査事業と、次廣のAI業務改善システム開発を共有。既存VB+Oracleシステム改善・クラウド移行について別途ヒアリングと提案を行う合意を整理。','2026-05-17 22:26:13','2026-05-17 22:26:13'),
(23,1,37,100,NULL,NULL,'2026-05-13 15:00:00',NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_ito_takao_phoenix_jsp.md】\n実施: 正式日時 TODO（2026-05-13 反映のZoom要約）\n\n飯塚さん経由のクロスチャプター1to1。補助金・助成金申請に絡むシステム導入支援、業務改善助成金、自社業務効率化、ローカルLLM提案書、ひとり親支援接点を整理。','2026-05-17 22:26:13','2026-05-21 17:10:50'),
(24,1,37,101,NULL,'2026-05-14 10:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_isobe_masayuki_nestle_detective.md】\n実施: 2026-05-14 実施済み（時刻 TODO）\n\n探偵業プロフィール・G.A.I.N.S.と次廣のシステム開発事業を共有。保険営業担当者紹介、メンバー表相互共有、BNI/倫理法人会ゲスト管理システム化の芽、屋号表記ゆれ確認を整理。','2026-05-17 22:26:13','2026-05-21 17:11:21'),
(25,1,37,119,NULL,'2026-05-18 17:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_maeda_referral_imaishi.md】\n実施: 正式時刻 TODO JST\n\n今西様紹介・非BNI。マーケティング／AI活用の情報交換、思考R診断システム、見積レンジ、静岡対面・今西様同席の可能性を整理。','2026-05-21 16:13:21','2026-05-21 17:11:50'),
(26,1,37,120,NULL,'2026-05-18 16:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_tsuji_ryo_mainc_meo.md】\n実施: 2026-05-18 16:00 JST\n\n株式会社MainC。MEO／SEO／HP／SNS運用、Muスコープ、ローコミ、協業可能性、6/5リージョンフォーラムでの接点を整理。\n','2026-05-21 16:13:21','2026-05-21 16:13:21'),
(27,1,37,121,NULL,'2026-05-19 14:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_shimotsuji_hs_neo_project.md】\n実施: 2026-05-19 14:00 JST\n\n株式会社hsネオプロジェクト。田村広大さん紹介、同業SE・業務改善、受託開発、AI活用、協力体制、友達申請を整理。\n','2026-05-21 16:13:21','2026-05-21 16:13:21'),
(28,1,37,9,NULL,'2026-05-21 09:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_nakamura_keigo_shakumoto.md】\n実施: 正式時刻 TODO JST\n\n株式会社笏本縫製／SHAKUNONE。次廣事業、新カテゴリー、日本製ものづくりチーム形成、予約管理、料金パッケージ化、宮城氏紹介合意を整理。','2026-05-21 16:13:21','2026-05-21 17:12:49'),
(29,1,37,122,NULL,'2026-05-21 11:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_fujimoto_yuki_tax_advisor.md】\n実施: 2026-05-21 11:00 JST\n\n船津麻理子さん紹介。医療クリニック特化税理士、税務セカンドオピニオン、未来会計、法人化・顧問税理士活用、AI/IT課題を整理。\n','2026-05-21 16:13:21','2026-05-21 16:13:21'),
(30,1,37,123,NULL,'2026-05-21 13:00:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_gondo_chiemi_campanula.md】\n実施: 正式時刻 TODO JST\n\n株式会社Campanula。企業研修・人材育成・業務改善、建設業／製造業の現場密着支援、教育設計とシステム化の協業可能性を整理。','2026-05-21 16:13:21','2026-05-21 17:12:22'),
(31,1,37,14,NULL,'2026-05-21 14:50:00',NULL,NULL,'completed','【第1回 1to1 — ソース: docs/meetings/1to1/1to1_nishioka_foreign_trainee.md】\n実施: 2026-05-21 14:50 JST\n\n外国人技能実習生受入れ支援。24時間対応、病院付き添い、月1回寮訪問、建設業の人材不足、次廣の建設業向け業務改善モック作成アクションを整理。\n','2026-05-21 16:13:21','2026-05-21 16:13:21'),
(32,1,37,124,NULL,'2026-05-22 09:00:00','2026-05-22 09:00:00',NULL,'completed','【第1回 1to1 実施メモ — ソース: docs/meetings/1to1/1to1_mitarai_fudotech.md】\n実施: 2026-05-22（金）JST 09:00〜終了時刻TODO／オーナー: 次廣 淳 → 対象: 御手洗氏（株式会社風土テック／BNI VORTEX）\n\n■ 主な成果\n・次廣の建設業・製造業向けAI業務改善システム構築と、御手洗氏の建設業採用支援は顧客層・課題解決アプローチの親和性が高いことを確認。\n・外国人労働者の日報管理システム、採用後の定着・教育・現場共有、採用支援先への業務改善提案で協業可能性を確認。\n・西岡優希氏（外国人就労支援）との三者連携候補が具体化。\n\n■ 御手洗氏 / 風土テック\n・建設業の採用支援。週1回の定例MTG、SNS撮影、Indeed / engage等の無料媒体改善、SNS・HP・求人媒体の一貫性づくり、MVV策定、採用後フォローまで伴走。\n・採用活動を一発勝負ではなく企業内に採用力を蓄積する「資産化」として捉える。\n\n■ 次廣側共有事例\n・外注ブロックFC本部の受注/顧客/売上管理統合。\n・名古屋の防水工事業向けLINE日報。外国人職人の紙日報課題をLINE提出・本部集計で改善。\n・解体業のLINE見積/請求、観光協会スタンプラリー、動物病院予約管理。\n\n■ 決定・アクション\n・2〜3ヶ月に1回の情報交換。\n・御手洗氏は風土テックのメンバー表を送付、次廣はDragonFly最新メンバー表を送付。\n・6月リージョンフォーラムで対面・名刺交換予定。\n・西岡優希氏との三者連携を検討。2026-05-22、次廣が西岡氏から接続了承を得て、御手洗氏へグループ作成可否を確認。\n\n■ 確認待ち\n・御手洗氏の下の名前、正式役職、プロフィールURL、終了時刻。\n・風土テック / フードテック表記、練馬会場・修声チャプター文脈は本人確認。','2026-05-22 16:46:29','2026-05-22 16:46:29'),
(33,1,37,52,NULL,'2026-05-25 15:00:00','2026-05-25 15:00:00',NULL,'completed','【第1回 1to1 実施メモ — ソース: docs/meetings/1to1/1to1_noguchi_yuko_hair_salon_viv.md】\n実施: 2026-05-25（月）JST 15:00〜終了時刻TODO／Zoom／オーナー: 次廣 淳 → 対象: 野口裕子（HAIR SALON ViV／BNI DragonFly）\n\n■ 主な成果\n・個人経営・火曜営業と火曜午前定例会の両立困難により BNI 退会決定。次廣とのつながりは継続合意。\n・ホットペッパー有料解約・紙予約併用によるダブルブッキング課題を共有。\n・次廣のパソコン相談無償サポート合意。夏頃リリース予定の予約管理システムを提案予定。\n・軍司さんによる LINE 予約システム構築（3ヶ月契約）が進行中。\n・ジンボウさんとの 1to1 を次廣経由リファラルとして実施する合意。\n\n■ 確認待ち\n・終了時刻（Zoom メタ）','2026-05-25 20:26:20','2026-05-25 20:26:20'),
(34,1,37,17,NULL,'2026-04-03 07:15:00','2026-04-03 07:15:00','2026-04-03 08:15:00','completed','【第1回 1to1 実施メモ — ソース: docs/meetings/1to1/1to1_sato_takuto_brightlink.md】\n実施: 2026-04-03（金）JST 07:15–08:15／Zoom／オーナー: 次廣 淳 → 対象: 佐藤拓斗（株式会社BrightLink／BNI DragonFly）\n\n■ 主な成果\n・双方の事業共有。テレアポリスト自動作成（手作業1時間100件）の開発可能性を検討開始。\n・リクナビネクスト等から従業員数30名以下等で抽出する仕組みを検討（法的リスク要確認）。\n・5月16–17日頃の静岡帰省時に対面ミーティング予定。出世クラブ参加も検討。\n・静岡県藤枝市の地元共通点・教育観の共感。','2026-05-25 20:26:20','2026-05-25 20:26:20'),
(35,1,37,137,NULL,'2026-05-27 10:00:00','2026-05-27 10:00:00',NULL,'completed','【第1回 1to1 実施メモ — ソース: docs/meetings/1to1/1to1_nampo_yuma_waibous.md】\n実施: 2026-05-27（水）JST 10:00〜終了時刻TODO／Zoom／オーナー: 次廣 淳 → 対象: 南方優馬（株式会社ワイボウズ／BNI Tifonet）／紹介: 望月雅幸\n\n■ 主な成果\n・ワイボウズの事業（月9,800円×24 EC、Clavio、IT導入補助金ツール卸・営業代理）を把握。\n・121表向きは相互紹介の方向性確認。\n\n■ 次廣の関与スタンス（121後）\n・協業パートナーではない。受動的紹介のみ（低コストEC需要が明示された場合）。\n・補助金系には協力しない。\n\n■ 南方側\n・月9,800円×24 EC（Shopify）、Clavio約50万、補助金営業代理30万/社。\n・杉山氏士業コミュニティ・ジム代行紹介は確認中（次廣は期待しない）。\n\n■ 確認待ち\n・終了時刻','2026-05-27 17:00:47','2026-05-27 17:00:47');
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
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(336,793,37,'2026-05-26 10:43:19','2026-05-26 10:43:19');
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
) ENGINE=InnoDB AUTO_INCREMENT=795 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(63,1,63,'guest',46,35,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
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
(183,3,66,'visitor',21,NULL,'2026-03-16 23:42:37','2026-03-16 23:42:37'),
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
(319,6,66,'visitor',5,NULL,'2026-03-31 00:09:20','2026-03-31 00:09:20'),
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
(384,7,66,'visitor',14,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(385,7,67,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(386,7,68,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(387,7,69,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(388,7,70,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(389,7,71,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(390,7,72,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(391,7,73,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(392,7,74,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(393,7,75,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(394,7,79,'visitor',35,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(395,7,80,'visitor',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(396,7,60,'guest',46,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(397,7,61,'guest',20,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(398,7,62,'guest',13,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
(399,7,63,'guest',40,NULL,'2026-04-07 00:04:59','2026-04-07 00:04:59'),
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
(461,8,66,'visitor',1,5,'2026-04-13 12:13:25','2026-04-13 12:58:33'),
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
(794,12,134,'guest',20,NULL,'2026-05-26 09:03:23','2026-05-26 09:03:23');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
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
('B30RzX1J45hjoVivXwxXM3oYIr9gIVrUWrQ3UHpG',NULL,'192.168.65.1','curl/8.7.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZjNiWG1NdVlRcHRFZTNvWkppZmxzampGM2xzdmN6TkhyeDRoYnc0UyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MTY6Imh0dHA6Ly9sb2NhbGhvc3QiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1779756264),
('Y1oy1eynIkgLaXS5m7Ezr52zaJF3s9E7CylrsDTg',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoieUVQMUVOcGlQMTB4c3hFS1padmgxNjZXa2NxNUpBbzNqaVRkUVZkYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1779688657);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Default','default@religo.local',NULL,'$2y$12$dUrt0H0qQktz46pbKZu7cexZzI5MU8PpmDa3wyR2y4aiZTnWpBJRC',NULL,37,NULL,NULL,'2026-03-05 13:03:53','2026-04-07 03:08:58');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workspaces`
--

LOCK TABLES `workspaces` WRITE;
/*!40000 ALTER TABLE `workspaces` DISABLE KEYS */;
INSERT INTO `workspaces` VALUES
(1,'Default Workspace','default',NULL,'2026-03-04 13:07:41','2026-03-04 13:07:41'),
(2,'BNI Diana','bni_diana',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(3,'BNI 大人なじみ','bni_otona_najimi',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(4,'BNI カーネル','bni_kernel',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(5,'BNI レブリー','bni_reverie',NULL,'2026-05-17 22:29:31','2026-05-17 22:29:31'),
(6,'BNI パッシオーネ','bni_passione',NULL,'2026-05-21 16:13:21','2026-05-21 16:13:21'),
(7,'BNI SPREAD','bni_spread',NULL,'2026-05-21 16:18:58','2026-05-21 16:18:58'),
(8,'BNI トレスステラ','bni_trestella',NULL,'2026-05-21 16:18:58','2026-05-21 16:18:58'),
(9,'BNI VORTEX','bni_vortex',NULL,'2026-05-22 16:46:29','2026-05-22 16:46:29'),
(10,'BNI Tifonet','bni_tifonet',NULL,'2026-05-27 17:00:47','2026-05-27 17:00:47');
/*!40000 ALTER TABLE `workspaces` ENABLE KEYS */;
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

-- Dump completed on 2026-05-27  8:01:10
