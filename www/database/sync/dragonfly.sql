-- dragonfly dev DB sync dump
-- generated: 2026-06-24 16:32:57 JST
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
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(34,13,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[24,29,37,22,159],\"notes\":\"\\u6e9d\\u6e15\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30d5\\u30a3\\u30b8\\u30fc\\u30af\\u3082\\u3084\\u3089\\u308c\\u3066\\u3044\\u308b\"},{\"room_label\":\"BO2\",\"member_ids\":[24,29,37,22,153],\"notes\":\"\\u6797\\u7530\\u3055\\u3093\\u306e\\u4e8b\\u696d\\u7d39\\u4ecb\\n\\u30af\\u30fc\\u30dd\\u30f3\\u7cfb\\u306e\\u798f\\u5229\\u539a\\u751f\\n\\u65e5\\u5e38\\u4f7f\\u3044\\u306e\\u30af\\u30fc\\u30dd\\u30f3\\u63b2\\u8f09(10%\\u30aa\\u30d5\\uff09\\n\\u6c34\\u9053\\u4ee3\\u306e\\uff11\\uff15\\u5e74\\u306e\\u524a\\u6e1b\\u304c\\u53ef\\u80fd\\uff08\\u4e95\\u6238\\u3092\\u6398\\u308b\\uff09\"}]}','2026-06-02 10:15:08','2026-06-02 10:15:08','2026-06-02 10:15:08'),
(38,16,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null}]}','2026-06-16 10:13:43','2026-06-16 10:13:43','2026-06-16 10:13:43'),
(39,16,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null}]}','2026-06-16 10:13:48','2026-06-16 10:13:48','2026-06-16 10:13:48'),
(40,16,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO3\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null}]}','2026-06-16 10:13:54','2026-06-16 10:13:54','2026-06-16 10:13:54'),
(41,16,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO3\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO4\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null}]}','2026-06-16 10:14:01','2026-06-16 10:14:01','2026-06-16 10:14:01'),
(42,16,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO3\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO4\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO5\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null}]}','2026-06-16 10:14:07','2026-06-16 10:14:07','2026-06-16 10:14:07'),
(43,16,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO3\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO4\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO5\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null},{\"room_label\":\"BO6\",\"member_ids\":[34,13,35,37,36,15,136],\"notes\":null}]}','2026-06-16 10:14:13','2026-06-16 10:14:13','2026-06-16 10:14:13'),
(44,18,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[30,13,37,188],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[30,13,37,188],\"notes\":null}]}','2026-06-23 08:07:53','2026-06-23 08:07:53','2026-06-23 08:07:53'),
(45,18,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[30,13,37,188,176],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[30,13,37,188],\"notes\":null}]}','2026-06-23 08:08:15','2026-06-23 08:08:15','2026-06-23 08:08:15'),
(46,18,2,37,1,'connections_breakouts','{\"rooms\":[{\"room_label\":\"BO1\",\"member_ids\":[30,13,37,188,176],\"notes\":null},{\"room_label\":\"BO2\",\"member_ids\":[30,13,37,188,182],\"notes\":null}]}','2026-06-23 08:08:42','2026-06-23 08:08:42','2026-06-23 08:08:42');
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
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(39,13,'BO2',1,'林田さんの事業紹介\nクーポン系の福利厚生\n日常使いのクーポン掲載(10%オフ）\n水道代の１５年の削減が可能（井戸を掘る）','2026-06-02 09:09:43','2026-06-02 10:15:07'),
(46,16,'BO1',1,NULL,'2026-06-16 10:13:43','2026-06-16 10:13:43'),
(47,16,'BO2',2,NULL,'2026-06-16 10:13:48','2026-06-16 10:13:48'),
(48,16,'BO3',3,NULL,'2026-06-16 10:13:54','2026-06-16 10:13:54'),
(49,16,'BO4',4,NULL,'2026-06-16 10:14:01','2026-06-16 10:14:01'),
(50,16,'BO5',5,NULL,'2026-06-16 10:14:07','2026-06-16 10:14:07'),
(51,16,'BO6',6,NULL,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(52,18,'BO1',1,NULL,'2026-06-23 08:07:53','2026-06-23 08:07:53'),
(53,18,'BO2',2,NULL,'2026-06-23 08:07:53','2026-06-23 08:07:53');
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
) ENGINE=InnoDB AUTO_INCREMENT=282 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(260,'Webマーケティング','Webマーケティング','2026-06-02 08:49:44','2026-06-02 08:49:44'),
(261,'美容・健康・生活','骨盤底筋体操導入サポート','2026-06-09 08:47:11','2026-06-09 08:47:11'),
(262,'資金調達支援（補助金・融資）','資金調達支援（補助金・融資）','2026-06-09 08:47:11','2026-06-09 08:47:11'),
(263,'個人、企業向け金融コンサルティング','個人、企業向け金融コンサルティング','2026-06-09 08:47:11','2026-06-09 08:47:11'),
(264,'通信系営業代行','通信系営業代行','2026-06-09 08:47:11','2026-06-09 08:47:11'),
(265,'プロモーション動画制作','プロモーション動画制作','2026-06-09 08:47:11','2026-06-09 08:47:11'),
(266,'やまと式かずたま術鑑定士','やまと式かずたま術鑑定士','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(267,'集中力を高めるオーダー眼鏡事業','集中力を高めるオーダー眼鏡事業','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(268,'補正下着販売（営業）','補正下着販売（営業）','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(269,'運気の不動産','運気の不動産','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(270,'美容サロン特化型インスタ広告代行','美容サロン特化型インスタ広告代行','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(271,'SNS運用コンサル','SNS運用コンサル','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(272,'通信機器販売','通信機器販売','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(273,'カクテルバー経営','カクテルバー経営','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(274,'経営者の意思決定力を高めるAI活用コンサルティング','経営者の意思決定力を高めるAI活用コンサルティング','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(275,'動画編集クリエイター','動画編集クリエイター','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(276,'グラフィック＆WEBデザイナー','グラフィック＆WEBデザイナー','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(277,'目の整体屋','目の整体屋','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(278,'Webサービスエキスパート','Webサービスエキスパート','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(279,'骨盤底筋導入サポート','骨盤底筋導入サポート','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(280,'子育てコーチング講師','子育てコーチング講師','2026-06-23 08:04:04','2026-06-23 08:04:04'),
(281,'補助金助成金で業績アップ','補助金助成金で業績アップ','2026-06-23 08:04:04','2026-06-23 08:04:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(8,13,'meeting_csv_imports/13/20260602164646_dragonfly_210_20260602_all_full.csv','dragonfly_210_20260602_all_full.csv','2026-06-02 16:46:47',NULL,NULL,'2026-06-02 16:46:47','2026-06-02 16:46:47'),
(9,18,'meeting_csv_imports/18/20260623221340_dragonfly_212_20260623_all_full.csv','dragonfly_212_20260623_all_full.csv','2026-06-23 22:13:40',NULL,NULL,'2026-06-23 22:13:40','2026-06-23 22:13:40');
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_minutes`
--

LOCK TABLES `meeting_minutes` WRITE;
/*!40000 ALTER TABLE `meeting_minutes` DISABLE KEYS */;
INSERT INTO `meeting_minutes` VALUES
(1,10,'# DragonFly 定例会 — 第207回（2026-05-12）\n\n**日時:** 2026-05-12（火）JST **10:00–11:45頃**（参加者PDF記載・Zoom録画メタ要確認）  \n**形式:** Zoom  \n**参加者:** 文字起こし要約ではメンバー 46・ビジター 6・代理出席 2・ゲスト 2 — **計 56 名**。参加者PDF/CSV上で確認できる代理出席者は 1 名のため、代理出席人数は要確認。  \n**関連:** [定例会参加者リスト PDF](../../pdf/260512/定例会参加者リスト2026-05-12.pdf) · [参加者 CSV](../../pdf/260512/dragonfly_207_20260512_all_full.csv)\n\n---\n\n## サマリー\n\n3週間ぶりの開催となった第207回定例会。メンバー更新、カテゴリー変更、一時退会の報告に加え、教育コーナーでは竹内駿太さんが「エレベーターピッチ」を扱った。\n\nメインプレゼンは **大竹絵理香さん**（家族も使える福利厚生）と **清原佳彩美さん**（サロン向け育毛機器・商材販売）。ビジター6名・ゲスト2名を迎え、ビジターの事業紹介、リファーラル事例、推薦の言葉、今後のイベント案内まで実施された。\n\n---\n\n## 校正メモ\n\n| 項目 | 校正後の扱い |\n|------|--------------|\n| 開催年 | 提供要約は「2025年5月12日」だが、参加者PDF/CSVと前後の議事録から **2026年5月12日** に補正 |\n| 用語 | 「産給金額」「請求金額」ではなく、BNI用語として **サンキュー金額** に統一 |\n| 藤井氏表記 | 既存名簿に合わせ **藤井恵理子** と表記 |\n| 岡元氏表記 | 既存名簿に合わせ **岡元智美** と表記 |\n| 舩杉氏表記 | 既存名簿に合わせ **舩杉牧子** と表記 |\n| 浜名氏表記 | 参加者PDF/CSVに合わせ **浜名靖博** と表記 |\n| 4月度サンキュー金額 | 提供要約は `19,507,000円` だが、後続の第209回議事録と整合する **19,057,000円** として記録 |\n| 今週リファーラル内訳 | 提供要約は「内部34・外部300・合計244」と算術不整合があるため、本文では **合計244件（内訳要確認）** として扱う |\n| 代理出席人数 | 提供要約は2名、参加者PDF/CSVでは1名確認。本文では差異を要確認として残す |\n\n---\n\n## 決定事項・重要事項\n\n### メンバーシップ関連\n\n| 区分 | 氏名 | カテゴリー / 内容 | 補足 |\n|------|------|-------------------|------|\n| **更新承認** | **藤井恵理子** | 播州織の日傘製造 | メンバーシップ委員会の審査を経て更新承認 |\n| **一時退会** | **吉田俊之** | 抗菌効果の強い漆塗りの食器販売 | 配偶者の出産に伴い 2026-05-12 付で一時退会。8月頃復帰予定 |\n| **カテゴリー変更** | **清原佳彩美** | サロン向け育毛機器・商材販売 | DragonFlyでの出会いから、薄毛に悩む経営者・美容業界向けの新領域へ変更 |\n\n藤井さんは、BNIを通じて「自分のできること・やりたいこと」をブラッシュアップできたこと、次の1年で得た学びを目標達成に活かしたいことを更新理由として共有した。\n\n---\n\n## 今週の実績\n\n### 参加\n\n| 区分 | 人数 |\n|------|------|\n| メンバー | 46名（文字起こし要約ベース） |\n| ビジター | 6名 |\n| ゲスト | 2名 |\n| 代理出席 | 2名（PDF/CSV上は1名確認のため要確認） |\n| 合計 | 56名（文字起こし要約ベース） |\n\n### チャプター実績（4月度・累計）\n\n| 指標 | 4月度 | 発足以来累計 |\n|------|------|--------------|\n| リファーラル | 338件（内部57・外部281） | 26,771件 |\n| サンキュー金額 | **19,057,000円** | **1,080,388,000円** |\n\n### 4月度 ネットワーキングリーダー\n\n| 部門 | 受賞者 | 実績 |\n|------|--------|------|\n| リファーラル部門 | 平岡国彦 | 22件 |\n| ビジター招待部門 | 西浦雅 | 6件 |\n| ワントゥーワン部門 | 増本重孝 | 33件 |\n| サンキュー金額部門 | 原田里織 | 6,000,000円 |\n| エデュケーション部門 | 西岡優希 | 170ポイント |\n\n### 今週のリファーラル\n\n提供要約では合計 **244件**。内訳は「内部34・外部300」とされているが、合計と一致しないため要確認。\n\n| 順位 | メンバー | カテゴリー | 件数 |\n|------|----------|------------|------|\n| 1 | 平岡国彦 | 大型物件対応解体工事 | 25件 |\n| 2 | 増本重孝 | 虫が建物に近寄らない害虫ブロック | 15件 |\n| 3 | 舩杉牧子 | 結婚相談所 | 12件 |\n\n### 主要リファーラル事例\n\n| 紹介元 | 紹介先 | 内容 |\n|--------|--------|------|\n| 平岡国彦 | 岡元智美 | 中小企業診断士の方を、勝てるプレゼン資料作成の岡元さんへ紹介 |\n| 増本重孝 | 里見允二 | 新商品の箱を探していた経営者を、パッケージ制作の里見さんへ紹介 |\n| 西浦雅 | 次廣淳 | AI業務改善システム構築の次廣へ、協業可能性のあるWeb制作会社社長を紹介 |\n| 舩杉牧子 | 岡元智美 | 強みを引き出すコーチングをされている小松さんを、岡元さんへ紹介 |\n\n---\n\n## 教育コーナー：エレベーターピッチ\n\n**担当:** 竹内駿太（エデュケーションコーディネーター）  \n**テーマ:** エレベーターピッチ\n\n商品スペックではなく、**顧客の問題と解決後の未来**を短く伝えることが重要だと共有された。\n\n### 要点\n\n| 観点 | 内容 |\n|------|------|\n| 主役 | 自社商品ではなく、顧客が抱えている問題 |\n| 悪い例 | 「私は最新のAIツールを販売しています」では、聞き手は紹介先を思い浮かべにくい |\n| 良い例 | 「残業に悩む経営者の時間を1日2時間作り出す仕事をしています」なら、相手が前のめりになりやすい |\n| 信頼の裏付け | 「成約率30%改善」「500世帯の家計改善」など、具体的な数字で実績を伝える |\n| 行動依頼 | 「誰かいい人」ではなく、地域・規模・立場・悩みまで絞って依頼する |\n\n### 今週のワーク\n\nワントゥーワンや名刺交換の場で、自分のビジネスを **「誰の悩みを解決し、どんな実績があるのか」** という形で30秒以内に話す練習をする。\n\n### 次廣への落とし込み\n\n「AI業務改善システム構築」ではなく、以下のように話す方が紹介されやすい。\n\n> 人を増やしたくないけれど、日報・見積・問い合わせ対応・毎月の集計に時間を取られている中小企業の社長に、LINE・Web・AIを使って、確認だけで回る仕組みを作っています。\n\n---\n\n## メインプレゼンテーション\n\n### 大竹絵理香 — 家族も使える福利厚生\n\n#### 背景\n\n日本企業の99.7%を占める中小企業では、大企業のような福利厚生を提供しづらい。大竹さん自身も、以前勤務していたネイルサロンで福利厚生が整っておらず、それを理由にスタッフが辞めていく場面を見てきた。\n\n#### サービス内容\n\n| 項目 | 内容 |\n|------|------|\n| 提携先 | 全国600社、10,000種類以上のサービス |\n| お祝い金 | 出産・結婚・入学など人生の節目に最大30,000円 |\n| 保険 | 個人賠償責任保険 500,000,000円まで付帯、示談交渉サービス付き |\n| 対象領域 | 電気・ガス、日用品、レジャー、慶弔など |\n\n#### ビジネスモデル\n\n- 会員数が増えるほどサービス内容が良くなる仕組み。\n- 利用するだけでなく、会社の事業として収益化・雇用創出につなげられる。\n\n#### 紹介希望先\n\n- 保険代理店\n- 財務コンサル\n- コミュニティ運営者\n- 新しい収入の柱を探している方\n\n---\n\n### 清原佳彩美 — サロン向け育毛機器・商材販売\n\n#### プロフィール\n\n仙台で美容サロンを経営しながら、シングルマザーとして2人の子どもと2匹のダックスを育てている。20代でまつげパーマに出会い、美容が人の人生を変える力を持つと実感。副作用や肌トラブルが少なく結果の出る商材「ノベルラッシュ」を開発し、1年半で全国600店舗以上へ導入した。\n\n#### N2プラスの特徴\n\n| 観点 | 内容 |\n|------|------|\n| 施術 | 針を刺さない、触れない、ダウンタイムなし |\n| 技術 | 高圧高速で美容成分を頭皮の奥へ届ける |\n| 時間 | 月1回、10分程度の施術 |\n| 用途 | 育毛、フェイシャルリフトアップ、スカルプ、ボディまで対応 |\n\n#### 実績・症例\n\n- 1回の施術で変化が見られた症例。\n- 4回・4ヶ月後に大幅な改善が見られた症例。\n- 若い女性の円形脱毛症が3回の施術後、半年で回復した症例。\n- 病院で改善困難だった抜け毛が、1回・1ヶ月で産毛が生えた症例。\n\n#### ビジネスメリット\n\n- 技術不要で導入しやすい。\n- 10分以内の施術で高単価メニュー化しやすい。\n- 美容業界の長時間労働・低単価問題を解決し、利益が残る美容を目指せる。\n\n#### 今後の予定・紹介希望先\n\n2026-05-18 からクラウドファンディング開始予定。\n\n- 美容室オーナー\n- 美容系サロンコンサル\n- 新しい高単価メニューを探しているサロン経営者\n\n---\n\n## コアバリューシェア・シェアストーリー\n\n### コアバリューシェア：佐藤拓斗\n\n**テーマ:** 関係構築\n\n採用も営業も、最終的には信頼関係が重要。BNI入会当初は「仕事につなげなければ」と自分語りが多かったが、最近は相手の事業・人・考えを知ろうとする姿勢に変わり、自然と紹介や良いご縁が増えたと共有した。\n\n### シェアストーリー：望月雅幸\n\n社労士の仕事は地元で広げるものだと考えていたが、BNIで全国のメンバーとつながる中で、オンライン商品を全国へ届けられる発想に変わった。\n\n#### 新サービス\n\n| 項目 | 内容 |\n|------|------|\n| サービス | セミオーダー就業規則オンライン |\n| 初期費用 | 50,000円 |\n| 月額メンテナンス | 9,800円 |\n| 対象 | 初めて就業規則を作る中小企業・小規模事業主 |\n| 提供方法 | オンライン相談・ヒアリングで全国対応 |\n\n望月さんは、BNIの5つのベネフィットに加え、特に **生涯学習** が大きな学びだったと共有した。\n\n---\n\n## リファーラル真正度確認\n\n**対象:** 越賀淑恵さん → 舩杉牧子さん  \n**内容:** 以前の会社の先輩で、婚活がうまくいっておらず、年齢面から結婚相談所に対応してもらえるか不安を持っていた方を紹介。\n\n舩杉さんからは、その後交流会へ参加してもらい、話を重ねる中でサポートすることになり、順調に進んでいるとの報告があった。\n\n---\n\n## 推薦の言葉：松倉健治 → 飯田千帆\n\n松倉健治さんが、経営者向け開運占い師の飯田千帆さんへの推薦の言葉を述べた。\n\n最初は「見える・聞こえる」リーディングに半信半疑だったが、仙台で鑑定を受けた際、本当に見えていると感じた。数日後に父の七回忌で帰省予定だったことを言っていないにもかかわらず、お墓参りに関する具体的な助言を受け、心を開いたというエピソードを共有した。\n\n仕事面でも相談に乗ってもらい、当時より売上が伸びていること、相手の立場に立って方向性を導いてくれる方だと推薦した。\n\n飯田さんは「迷いが確信に変わった」という言葉が占い師として嬉しかったと述べ、今後もご縁をいただいた方が安心して前に進めるよう丁寧に向き合いたいと話した。\n\n---\n\n## ビジター・代理・ゲスト\n\n### ビジター（6名）\n\n| 氏名 | 事業・カテゴリー | 要点 |\n|------|------------------|------|\n| 花崎勇佑 | SNS運用 / 動画編集スクール | Instagram・TikTokなどショート動画を活用した集客・問い合わせ導線づくり |\n| 丹羽さくら | 業務改善コンサルタント | 一人社長・中小企業向けに業務整備、IT/AI活用、バックオフィス自動化を支援 |\n| 鶴岡江里子 | Web制作 | LPコーディング、WordPress制作、写真撮影まで対応 |\n| 石原悠雅 | 保険業 | 生命保険を通じたライフプランニング・資産形成支援 |\n| 津澤正人 | 体の再生業（断食・ファスティング） | 断食指導を通じて体を整え、不調改善と健康寿命を支援 |\n| 小原裕美 | 若者キャリアコンサル | 延べ10,000人の若年者支援実績。岡山拠点・オンライン全国対応 |\n\n### ビジター感想\n\n- **丹羽さくら:** 初めてのBNI参加で緊張していたが、雰囲気が良く落ち着いて参加できた。多業種の参加者の多さに圧倒された。\n- **津澤正人:** 初参加で、様々な方が力を合わせて前に進む素晴らしいチームだと感じた。\n\n### ゲスト（2名）\n\n| 氏名 | 事業・カテゴリー | 補足 |\n|------|------------------|------|\n| 田辺光 | 通信関係（法人携帯、インターネット、新電力）、SNS運用代行 | 船津麻理子さん紹介 |\n| 髙橋豊 | ポスティング特化 広告代理店 | 75名規模のチャプターは初めて。テンポが良く、ビジネス拡大の可能性があるチャプターと感想 |\n\n### 代理出席\n\n| 氏名 | 代理元 | 事業 |\n|------|--------|------|\n| 浜名靖博 | 倉持賢一 | 中国向け物販支援 |\n\n提供要約には片山あつしさん（スマホ・PC修理）も代理出席として記載があるが、参加者PDF/CSV上では確認できなかったため要確認。\n\n---\n\n## BNI・チャプター情報（例会内共有）\n\n### 基本用語\n\nリファーラル、チャプター、サンキュー金額、1to1 について説明あり。リファーラルマーケティングは費用対効果の高い手法であり、BNIでは1専門カテゴリー1名に限定することで、メンバー同士が互いの営業部隊として機能する。\n\n### BNI規模\n\n| 項目 | 内容 |\n|------|------|\n| 世界 | 77カ国、11,642チャプター、約350,000人 |\n| 日本 | 383チャプター、12,566名 |\n| 日本の年間リファーラル | 1,700,000回超 |\n| 日本の年間サンキュー金額 | 124,400,000,000円以上 |\n| 東京NEリージョン | 24チャプター、1,158名 |\n\n### DragonFly\n\n| 項目 | 内容 |\n|------|------|\n| ビジョン | Flying Sky — 繋がりを世界の果てまで |\n| コアバリュー | Quality（上質を目指し） / Pride（誇りを持ち） / Challenge（挑戦し続ける） |\n| 第10期スローガン | 百華繚凛 |\n| 重点募集カテゴリー | 広告代理業、経営コンサル、税理士、Webマーケティング、美容商材販売 |\n\n### 役員・サポート\n\n- **プレジデント:** 平山真由美\n- **バイスプレジデント:** 芳賀崇利\n- **書記兼会計:** 岡元智美\n- **サポート:** 舩杉（メンター）、竹内（エデュケーション）、西浦（ビジターホスト）、山本（トレーニング）、渡辺（フォーラム）、中村（対面）、太田（1to1）、倉持（Webマスター）、飯田香（BCP）、飯田千帆（オンラインコミュニケーション）、藤井（グローバルビジネス）、福上（BOD）\n- **チャプターサポート:** 藤田磨紀（ディレクターコンサルタント）、山崎勇一（グロースエリアディレクター）、木下馨（東京NEリージョン エグゼクティブディレクター）\n\n---\n\n## 今後の予定・イベント\n\n### ワントゥーミニー\n\n太田一誠さんより、2026-05-12、2026-05-19、2026-05-26 の3週連続でワントゥーミニーを開催する案内があった。特に 2026-05-19 13:00 は山本葉子さんが開催予定。DragonFlyが大きくなるためには個々のつながりが重要であり、ワントゥーミニー活用が呼びかけられた。\n\n### リージョンフォーラム\n\nNキャス登録時、対面参加・オンライン参加のどちらかをコメント欄へ入力するよう案内があった。\n\n### ナショナルカンファレンス\n\n藤田ディレクターコンサルタントより、翌年5月に大阪で開催されるナショナルカンファレンスについて案内。全国約12,000人のメンバーから3,000人規模の積極的なメンバーが集まる予定で、DragonFlyメンバーからも参加表明が出ている。\n\n### ビジネス交流会\n\n2026-05-20 に加藤さんのステーキハウスで、BNIと倫理法人会のビジネス交流会が予定されている。文字起こし要約は末尾が途切れているため、詳細は要確認。\n\n---\n\n## 次廣視点メモ\n\n### 重要な接点\n\n- **西浦雅さん → 次廣淳:** Web制作会社社長との協業可能性。AI業務改善単独ではなく、Web制作・SNS・業務導線改善とのパワーチーム化の入口。\n- **丹羽さくらさん:** 業務改善コンサルタント。IT/AI活用・バックオフィス自動化の領域が近く、協業または棲み分け確認の1to1候補。\n- **鶴岡江里子さん:** Web制作・写真撮影。LP/WordPressと業務改善導線の接続候補。\n- **田辺光さん:** 通信・新電力・SNS運用代行。船津さん紹介のゲストで、後続の1to1候補として管理済み。\n\n### 学び\n\n今回の教育コーナーは、次廣のプレゼン改善に直結する。今後は「AI」「システム」から入らず、**誰が、どんな手作業・属人化・時間不足に困っているか** を先に伝える。紹介依頼は「中小企業の社長」ではなく、業種・規模・発していそうな言葉まで絞る。\n\n---\n\n## 要確認事項\n\n- 今週リファーラルの正確な内訳（提供要約の「内部34・外部300・合計244」が不整合）。\n- 代理出席者の人数と片山あつしさんの出席有無（PDF/CSVでは浜名靖博さんのみ確認）。\n- 開始・終了時刻のZoom録画メタ確認（PDF上は 10:00–11:45頃）。\n- ビジネス交流会（2026-05-20）の正式名称・時間・参加条件。','docs/meetings/chapter/chapter_weekly_20260512.md','chapter_weekly','2026-05-12','10:00-11:45','参加者PDFのタイムスケジュールでは開場 09:45、定例会開始 10:00、閉会 11:45頃。Zoom録画メタの正確な開始・終了は要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-12）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":207,\"session_date\":\"2026-05-12\",\"session_time_jst\":\"10:00-11:45\",\"session_time_note\":\"\\u53c2\\u52a0\\u8005PDF\\u306e\\u30bf\\u30a4\\u30e0\\u30b9\\u30b1\\u30b8\\u30e5\\u30fc\\u30eb\\u3067\\u306f\\u958b\\u5834 09:45\\u3001\\u5b9a\\u4f8b\\u4f1a\\u958b\\u59cb 10:00\\u3001\\u9589\\u4f1a 11:45\\u9803\\u3002Zoom\\u9332\\u753b\\u30e1\\u30bf\\u306e\\u6b63\\u78ba\\u306a\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306f\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-12\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260512\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026-05-12.pdf\",\"..\\/..\\/pdf\\/260512\\/dragonfly_207_20260512_all_full.csv\"]}','2026-06-19 12:59:58','2026-06-02 15:39:21','2026-06-19 12:59:58'),
(2,11,'# DragonFly 定例会 — 第208回（2026-05-19）\n\n**日時:** 2026-05-19（火）JST **08:00–10:00**（定例枠・要確認）  \n**形式:** Zoom  \n**参加者:** メンバー 47・ビジター 10・代理出席 2・ゲスト 6 — **計 65 名**  \n**関連:** [定例会参加者リスト PDF](../../pdf/260518/定例会参加者リスト2026-05-19.pdf) · [参加者 CSV](../../pdf/260518/dragonfly_208_20260519_all_full.csv) · [スリーバイス チームMTG（同日朝）](../team/team_threebiz_20260519.md)\n\n---\n\n## サマリー\n\n今週のリファーラル **118 件**（内部 14・外部 104）。メインプレゼンは **西岡裕樹** 氏（外国人技能実習生派遣・建設業向け監理団体）。教育コーナーは「紹介しやすい人の条件」。シェアストーリーは **増本重孝** 氏。\n\n**決定:** 8/21 グローバルビジネスイベント参加費 4,000 円を予備費から全額補助／6月フォーラムのエヌキャス締切を **今週金曜 2026-05-22**／対面ミーティングのランチ・二次会を実施し参加表明は **来週定例会 2026-05-26** まで。\n\n4月度累計: リファーラル 698 件・サンキュー 32,625,000 円。発足以来累計サンキュー **1,061,311,000 円**。\n\n---\n\n## 決定事項\n\n| 項目 | 内容 |\n|------|------|\n| **グローバルビジネスイベント補助** | **2026-08-21 18:00 JST** 開催のグロビジイベント参加費 **4,000 円**を、予算の予備費から **全額補助** |\n| **6月フォーラム（エヌキャス）** | 締切を **2026-05-22（金）** に設定（未入力者あり） |\n| **対面ミーティング** | 当日 **ランチ会・二次会** を実施。参加表明の回答期限は **2026-05-26** 定例会まで（LINE 案内予定） |\n\n---\n\n## 今週の実績\n\n### 参加・リファーラル\n\n| 指標 | 数値 |\n|------|------|\n| 参加 | メンバー 47 / ビジター 10 / 代理 2 / ゲスト 6 — **計 65** |\n| 今週リファーラル | **118**（内部 14 / 外部 104） |\n\n### リファーラル Top 3\n\n| 順位 | メンバー | カテゴリー | 件数 |\n|------|----------|------------|------|\n| 1 | 山本功太 | デザインに強いウェブ制作 | 15 |\n| 2 | 増本重孝 | 虫が建物に近寄らない害虫ブロック | 7 |\n| 3 | 松倉健治 | エアロゲル透明断熱フィルム | 6 |\n\n### 主要リファーラル事例\n\n| 紹介元 | 紹介先 | 内容 |\n|--------|--------|------|\n| 西浦みやび | 福上大輝 | 愛知の工務店紹介 → 工事契約 2 件・売上 **10,000,000 円** |\n| 中村啓吾 | 里見允二 | ネクタイのギフトボックス **200 個** 発注 |\n| 山本功太 | 木村健悟 | ナショナルカンファレンス用 T シャツプリント依頼 |\n\n---\n\n## メインプレゼンテーション：外国人技能実習生派遣\n\n**プレゼンター:** 西岡裕樹（29歳）\n\n### プロフィール要点\n\n- 中学卒後 **13 年** 型枠解体の職人。オーストラリア・フィリピンで計 **3 年** 海外経験\n- 現場の厳しさ・怪我・言葉の壁を経験したからこそ、実習生に寄り添う姿勢\n\n### 差別化\n\n| 柱 | 内容 |\n|----|------|\n| **同行サポート** | 通院・技能試験への付き添いを **追加費用なし**。社長・事務の時間を奪わない |\n| **日本語力** | 配属前の定期ウェブ面談。専門用語・道具名・安全合図を元職人視点で事前レクチャー。専属通訳と現場の言葉 |\n| **直接対応** | オンライン完結にせず現場の声を聞く。配属後も不安・不明点に直接対応 |\n\n### ターゲット\n\n- 人手不足の建設業\n- 既に実習生を雇うが組合サポートに不満がある企業\n- 付き添いの追加費用に疑問を持つ企業\n\n### プレゼント抽選\n\n西岡氏提供の **防水スマホケース**（4色）→ **福上大輝** 氏当選。福上氏コメント: シャワー派だが湯船に浸かる予定。「人手不足はチャンス」が刺さった。中卒・現場経験に基づく伴走の質が腑に落ちた、等。\n\n---\n\n## 教育コーナー：紹介しやすい人の条件\n\n### 紹介しにくい人\n\n1. **ターゲットが広すぎる** — 思考がフリーズし、誰の顔も浮かばない\n2. **レスポンスが遅い** — 紹介者の信頼を削り、「紹介を出せない」レッテルに\n\n### 紹介しやすい人\n\n1. **圧倒的な具体性** — 規模・業種・困りごとまで具体化し、声のかけ方までセットで渡す\n2. **絶対的な安心感** — 「顔はつぶさない。期待以上の対応を約束する」\n\n### 今週のタスク（チャプター）\n\nワントゥーワンや定例会後に、**「私がもっと紹介しやすい人になるために、私に足りない情報は何ですか？」** とメンバー同士で聞き合う。\n\n---\n\n## シェアストーリー：増本重孝\n\n| 項目 | 内容 |\n|------|------|\n| BNI 歴 | 4 年半 |\n| 累計サンキュー | **230,000,000 円** |\n\n**ビジネス改革 2 点:** (1) 出張商談をすべてリモート化 → 商談回数増 (2) 出張費削減 → 浮いた予算を地域システム構築へ。メンバー・リファーラル経由で具体的コメントを依頼。\n\n**BNI の 3 ベネフィット:** 接触頻度の高さ／生涯学習（東京 NE 年間 280 回超）／進化し続けるビジネスチーム。\n\n---\n\n## ビジター・代理・ゲスト\n\n### ビジター（10名）\n\n| # | 氏名 | 事業・エリア |\n|---|------|----------------|\n| 1 | 神麻のり子 | イタリアンジェラート製造卸（静岡市） |\n| 2 | 宮地義和 | インテリアリフォーム・家具デザイン（大阪中心・全国） |\n| 3 | 佐藤圭佑 | 産業機器メンテナンス（北海道） |\n| 4 | 神山英樹 | 中小企業診断士（千葉・市川市行徳） |\n| 5 | 中村まどか | 組織改革コーチング・社外 CHRO（つくば・**6月会社設立予定**） |\n| 6 | 山田桃子 | マルシェ運営（大阪・全国31箇所・1回700名） |\n| 7 | 福田康平 | オンライン家庭教師（公立小中学生・オーダーメイド塾テキスト） |\n| 8 | 池田正 | 電気代削減（高圧・全国、特に北海道・東北・北陸） |\n| 9 | 松下真紀子 | 中古介護ベッド（静岡・定価1/10・10年保証・全国） |\n| 10 | 南部ユースケ | コンサル（福井・神戸・大阪・LP/バナー等） |\n\n### 代理出席（2名）\n\n| 氏名 | 代理 | 事業 |\n|------|------|------|\n| 堺けんじ | 倉持 | 中国向け物販（中国 SNS インフルエンサー） |\n| 牧真一 | 野口裕子 | 若返り育毛ヘッドスパ（オゾン・水素） |\n\n### ゲスト（6名）\n\n古谷修二（通信・不動産）、海明子（化粧品）、村野秀二（非破壊検査 AI・ロボット／元キリンチャプター）、人形宗一郎（総合防災）、山本杏那（事務効率化）、佐野林（損害保険）。\n\n### ビジター・ゲストの声（抜粋）\n\n- **中村まどか:** 温かさ・繋がりを共有する場だと実感\n- **神山英樹:** プレゼンのピンポイントさを学びたい\n- **池田正:** 全国・多業種で勉強になった\n- **村野秀二:** キリンとの違いとして良い緊張感・本気度。含有率に感動\n- **山本杏那:** 朝から洗練・クオリティ・プロフェッショナル感\n\n**越賀さんの気づき:** 福田氏（オンライン家庭教師）から「次廣さんの聞き方が素晴らしい」とのコメント → ビジターはメンバーの参加姿勢を見ている。\n\n---\n\n## BNI・チャプター情報（例会内共有）\n\n### 基本用語\n\nリファーラル／チャプター／サンキュー金額の説明あり。\n\n### ドラゴンフライ\n\n| 項目 | 内容 |\n|------|------|\n| ビジョン | フライングスカイ — つながりを世界の果てまで |\n| コアバリュー | クオリティ・プライド・チャレンジ |\n| 今期スローガン | 百華繚凛 |\n\n### 統計（4月度・累計）\n\n**4月度:** リファーラル 698（内124/外574）・ビジター 31・1to1 915・サンキュー 32,625,000 円  \n\n**発足以来:** リファーラル 26,433（内5,742/外20,656）・ビジター 1,420・サンキュー **1,061,311,000 円**\n\n### メンバーシップ委員会 — 募集中カテゴリー\n\n広告代理店 / SNSマーケティング / 経営コンサル / 中小企業診断士\n\n### 推薦の言葉\n\n**越賀 → 梅澤:** 脱炭素経営をゲームで学ぶ TGX。中小企業のペナルティ時代に有用。梅澤氏は全国展開・地球温暖化への企業取り組みを表明。\n\n### 役員・サポート（紹介のみ）\n\n- **プレジデント:** 平山真由美\n- **VP:** 芳賀崇利\n- **書記兼会計:** 岡本智美\n- サポート: 船杉（メンター）、竹内（EC）、西浦（ビジホス）、山本（トレーニング）、渡辺（フォーラム）、中村（対面）、太田（1to1）、倉松（ウェブマスター）、飯田かおり（BCP）、飯田千穂（オンラインコミュ）、藤井（グローバルビジネス）、福上（EOD）\n- チャプターサポート: 藤田真希（DC）、山崎ゆういち（GAD）、木下薫（東京 NE ED）\n\n---\n\n## 今後のメインプレゼン\n\n| 日付 | スピーカー | メモ |\n|------|------------|------|\n| **2026-05-26** | 木村健悟（Tシャツプリント）、中村啓吾（日本製ものづくり再興） | ものづくり関連ビジター招待推奨 |\n\n---\n\n## 入会案内（共有内容）\n\n1. 登録費・プログラム利用料の入金  \n2. 申込書をメンバーシップ委員会へ  \n3. 面談・振込明細・信用紹介先を VP へ  \n\n**費用:** 登録費 50,000 円（税別）／プログラム 190,000 円/年（2年 -80,000 / 5年 -150,000）／チャプター運営費 5,000 円/月  \n\n審査承認後、競合は当チャプターに入会不可。\n\n---\n\n## アクションアイテム\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| 各チームリーダー | エヌキャス **役職名更新** | — |\n| メンバー | **6月フォーラム** エヌキャス入力 | **2026-05-22（金）** |\n| メンバー | **対面 MTG** ランチ・二次会の参加表明（LINE 案内） | **2026-05-26** 定例会まで |\n| メインプレ担当 | 本日 **14:00 JST** リハーサル | 2026-05-19 |\n| メンタリング | 初めの一歩（原田・山本・久米）、何でも相談室（次廣） | 定例後 |\n\n---\n\n## 次回予告\n\n- **次回定例会:** 2026-05-26（火）— メインプレ 木村・中村（上表）\n- **2026-06-05 フォーラム:** 4月ナショナルカンファレンスのシェア。35名以上登壇。DragonFly から **原田**（ブース出展）、**田口**、**太田**\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-05-19 12:39 | 初版。Zoom 文字起こし要約を議事録化。 |','docs/meetings/chapter/chapter_weekly_20260519.md','chapter_weekly','2026-05-19','08:00-10:00','DragonFly 定例枠（火曜）。開始・終了の正確な時刻は Zoom 録画メタで要確認。同日 08:00–08:45 にスリーバイスチーム MTGあり。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-19）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":208,\"session_date\":\"2026-05-19\",\"session_time_jst\":\"08:00-10:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306e\\u6b63\\u78ba\\u306a\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\\u540c\\u65e5 08:00\\u201308:45 \\u306b\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\\u30c1\\u30fc\\u30e0 MTG\\u3042\\u308a\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-19\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260518\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026-05-19.pdf\",\"..\\/..\\/pdf\\/260518\\/dragonfly_208_20260519_all_full.csv\"]}','2026-06-19 12:59:58','2026-06-02 15:39:21','2026-06-19 12:59:58'),
(3,12,'# BNI DragonFly 定例会議事録（2026/05/26）\n\n**日時:** 2026-05-26（火）JST **08:00–10:00**（定例枠・要確認）  \n**形式:** Zoom  \n**参加者:** ビジター 7・ゲスト 2 — **計 56 名**  \n**関連:** [定例会参加者リスト PDF](../../pdf/260526/定例会参加者リスト2026_05_26.pdf) · [参加者 CSV](../../pdf/260526/dragonfly_209_20260526_corrected_full.csv)\n\n---\n\n## 1. 定例会概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年5月26日（火） |\n| **参加人数** | 総勢 **56名** |\n| **ビジター** | **7名** |\n| **ゲスト** | **2名** |\n| **リファーラル** | **110件**（内部18・外部92） |\n\n新メンバー2名（米沢由佳氏・森園祐樹氏）の入会承認、メインプレ2件（Tシャツプリント・日本製ものづくり）、リファーラル110件の交換が実施された。教育コーナーは「紹介の解像度を上げる」、シェアストーリーは小中氏（AIツール情報発信）。ビジター7名・ゲスト2名を迎え、チャプターの成長と活性化が確認された。\n\n---\n\n## 2. 決定事項・重要事項\n\n### 新メンバー承認\n\n| 氏名 | カテゴリー | 紹介者 |\n|------|------------|--------|\n| **米沢由佳** | 反応率にこだわるウェブデザイン | 福上大樹 |\n| **森園祐樹** | AI×事務代行 | 平岡国彦 |\n\n- 両名とも倫理規定の宣誓を完了し、正式メンバーとして承認\n\n### メインプレゼンテーション実施\n\n| 登壇者 | カテゴリー | 内容 |\n|--------|------------|------|\n| **木村健吾** | Tシャツプリント | オリジナルTシャツ製作事業の詳細 |\n| **中村啓吾** | 日本製ものづくり再興事業プロデューサー | 日本製アパレルの現状と「日本製の覚悟展」（2026年7月3–4日・有楽町） |\n\n### リファーラル実績（今週）\n\n- **合計 110件**（内部18・外部92）\n- **Top 3:** 平岡国彦 12件 / 舩杉真紀子 9件 / 増本重孝 5件\n\n### リファーラル品質確認\n\n- **平岡国彦** → **清原かさみ**（サロン向け育毛機器・美容商材）\n- 美容室19店舗展開の取締役を紹介 → Zoom実施 → 数店舗でまつ毛美容液導入決定、育毛マシン検討機会も獲得。**売上につながるリファーラルとして確認完了**\n\n### 推薦の言葉\n\n- **原田沙織** → **木村健吾**（ナショナルカンファレンス用ロゴTシャツ・トートバッグ制作。丁寧なヒアリング・迅速対応・提案力・高品質・追加注文時の提案力を評価）\n\n### プレゼント抽選\n\n| 提供者 | 商品 | 当選者 |\n|--------|------|--------|\n| 木村健吾 | デニム雑貨（ペンケースまたはポーチ） | 倉持賢一 |\n| 中村啓吾 | 動物ハンカチ2柄 | 畠山憲之 |\n\n### チャプター実績\n\n**4月度**\n\n| 指標 | 数値 |\n|------|------|\n| リファーラル | 338件（内部57・外部281） |\n| ビジター | 32名 |\n| 1to1 | 514回 |\n| 請求金額 | 19,057,000円 |\n\n**発足以来累計**\n\n| 指標 | 数値 |\n|------|------|\n| リファーラル | 26,771件（内部5,799・外部20,937） |\n| ビジター | 1,452名 |\n| 請求金額 | 1,080,388,000円（約10.8億円） |\n\n**チャプター規模:** メンバー47名（プラチナチャプター基準50名以上を目指す75人体制では紹介ルート2,775ライン・約2.2倍）\n\n### 募集中カテゴリー\n\n保険代理店 / コンサル業 / ウェルネスサービス / 中小企業診断士 / コスト削減\n\n### コアバリュー共有\n\n**舩杉真紀子** — 「前向きな姿勢と態度」  \nうまくいかない時こそ姿勢が現れる。「まずやってみる」を大切にし、挑戦しないことの方がもったいない。周囲への連鎖がご縁とチャンスを広げる。\n\n---\n\n## 3. エデュケーション要点\n\n### テーマ\n\n**「紹介の解像度を上げる」**（担当：竹内俊太 — アスリート専門生命保険）\n\n### 学び — 属性の三段階絞り込み\n\n| 段階 | 例 | 評価 |\n|------|-----|------|\n| 第一段階 | 「経営者を紹介してください」 | ❌ 漠然としすぎて効果薄 |\n| 第二段階 | 「都内で従業員10–30名規模のIT企業の経営者を紹介してください」 | △ 輪郭が見えてくる |\n| 第三段階 | 「都内・従業員10–30名・IT企業の経営者で、最近オフィス移転または採用活動を始めた社長を紹介してください」 | ⭕ ピンポイントでヒット |\n\n**なぜ重要か:** 75人体制（2,775ライン）の強力なインフラに、**具体的で高精度なデータ**を流し込むことで、最強のビジネスインフラになる。\n\n### 顧客の悩み言語\n\n顧客はサービス名ではなく、**日常会話の症状**で語る。\n\n| ❌ サービス名で伝える | ⭕ 日常会話で出る言葉 |\n|----------------------|----------------------|\n| 「〇〇というサービスを探している」 | 「最近肩が痛くて眠れない」 |\n| 「AI業務改善システムをしています」 | 「今年の税金が高すぎて頭が痛い」 |\n| 「システム開発をしています」 | 「人を増やしたくないけど仕事が回らない」 |\n\n**プレゼンの言い換え:** 商品説明ではなく —  \n「今週あなたの周りで〇〇とぼやいている人がいたら、私につないでください」\n\n---\n\n## 4. メインプレゼン要点\n\n### 木村健吾（Tシャツプリント）\n\n#### 会社概要\n\n- **株式会社ハートプランニング**（創業36年・岡山県倉敷市）\n- 父の失明をきっかけに入社。47都道府県取引、最高一案件40,000枚\n\n#### 強み\n\n1. **何度でもデザインサポート** — 配色変更など修正対応\n2. **追加注文も初回同額** — 少量追加でも単価維持\n3. **1枚から作成可能** — シルク・転写・インクジェット・刺繍・レーザー加工を自社工場で一貫対応\n\n#### 求めている紹介先\n\n- スポーツチーム・クラブの監督・顧問\n- 展示会・イベントを開く企業\n- **特に:** 企業イベント企画担当（広告代理店業など）\n- **夢:** BNI内最大規模「24時間テレビのチャリティーTシャツ」級の紹介\n\n#### 印象に残ったポイント\n\n- 1枚1,000–2,000円程度。衣服ではなく「人をつなぎ、気持ちを高め、メッセージを伝えるツール」\n- Tシャツ以外にパーカー・エプロン・トート・作業着・ボトル・マグ・作業ヘルメット等も対応\n\n---\n\n### 中村啓吾（日本製ものづくり再興事業プロデューサー）\n\n#### 会社概要\n\n- **株式会社作物法制**（1968年創業・岡山県津山市）\n- 年間ネクタイ20,000本・ハンカチ25,000枚。SNSフォロワー180,000人超（倒産寸前から立て直し）\n\n#### 強み\n\n- 「作る」だけでなく **「作って伝えて売る」** まで現場で実践\n- 晩秋織りハンカチがXでバズ → 6ヶ月で25,000枚販売（最高インプレッション2,000万超）\n- 地方の小さな縫製工場でも、発信と届け方を変えれば全国に届くことを実証\n\n#### 求めている紹介先\n\n- 日本製の自社商品でものづくりをしている **町工場・職人・跡継ぎ**\n- 提供価値：同じ思いの仲間との出会い / 見せ方・伝え方・ブランドの見直し / SNS発信をともに学ぶ機会\n\n#### 印象に残ったポイント\n\n- 国内生産率：1990年50.1% → 2025年1.4%。必要なのは「作る力」＋「伝える力」＋「選ばれる力」\n- **日本製の覚悟展**（2026/7/3–4・有楽町東京交通会館12階・全国16社）— テーマ「守られる日本製ではなく、選ばれに行く日本製」\n- **将来の夢:** 両国国技館で同展を主催。BNIで仲間探しを加速\n\n---\n\n## 5. シェアストーリー・学び\n\n**登壇者:** 小中氏（使って学ぶAIツールの情報発信）\n\n### 売りたいもの（当初）\n\n- AI研修・コンサルティング\n- **課題:** 教える人が多い / 初対面で選ばれる動機がない / 高額で即決できない\n\n### 入り口戦略\n\n- フロントサービスを **月1,000円の情報発信** に変更\n- 導入しやすい価格帯で日々の情報発信 → 「AIに詳しい人」「教え方がうまい人」の認知獲得\n\n### 信頼構築方法\n\n- リファーラルマーケティングの設計要素を分解して実践：\n  - 誰がお客か / 何に困っているか / どう解決するか\n  - 誰とつながっていて、どう紹介してもらうか（入り口設計）\n  - つないでもらった後のカスタマージャーニー設計\n- 「誰でもいいです」という曖昧なリクエストでは仕組みにならない\n\n### BNIとの相性\n\n- トレーニングコンテンツが豊富\n- DragonFlyは50人の経営者が在籍、年間140件以上の紹介を受けられる\n- インプット（学び）とアウトプット（実践）の両方が同じ場で回る → **PDCAを早く回せる**\n\n---\n\n## 6. ビジター・新しいつながり\n\n### 石原孝之氏（次廣淳招待ビジター）\n\n| 項目 | 内容 |\n|------|------|\n| **現在** | 保険代理店 |\n| **経歴** | 元市議会議員 |\n| **関連領域** | 介護施設・保育園経営経験 |\n| **活動** | 地域イベント主催 |\n| **特徴** | 経営経験あり |\n\n→ **自分が招待したビジターとして今後フォロー対象。** BO後の個別面談・アンケートフォローを優先。\n\n### 印象に残ったビジター（つながり候補）\n\n| 氏名 | 事業 | ポイント |\n|------|------|----------|\n| **吉崎淳** | 肌着・布製品縫製工場（京都府綾部市・60年超） | 中村氏の「両国国技館での覚悟展」に参加したいと発言。小ロット100枚から対応 |\n| **山田智子** | 女性客に強いウェブ制作（千葉成田） | 営業ゼロで200社以上 |\n| **増田義久** | キャッサバスイーツ（栃木・農園運営） | 地域特産×ものづくり |\n\n### その他ビジター（7名）\n\n| 氏名 | 事業 |\n|------|------|\n| 青木博美 | 婚活サロン運営 |\n| 岡崎由香 | 赤州瓦原の焼き物制作（島根県西部） |\n| 熊谷隆章 | 通信費削減（ソフトバンク担当8年目） |\n\n### ゲスト（2名）\n\n佐藤氏（リラクゼーション専門店FC）/ 服田氏（骨盤底筋体操）\n\n### ビジター感想（抜粋）\n\n**吉崎淳:** 経営や業界の会話にまだ若く知らない言葉も多かったが、詳しい説明が勉強になった。中村氏の両国国技館での覚悟展に参加したい。\n\n---\n\n## 7. tugilo視点での気づき\n\n### 気づき\n\n今回の教育と小中氏のシェアストーリーは、**同じ構造**を指している。\n\n- 竹内氏：紹介リクエストを三段階で具体化する\n- 小中氏：高額サービスの前に、月1,000円の入り口で信頼を積む\n- 共通点：**「何を売っているか」ではなく「どんな状況の人か」を言語化する**\n\n75人体制の2,775ラインは「配線」。精度の低いリクエストを流すと配線は活きない。**悩み言語 × 具体属性**が、tugiloの紹介精度を決める。\n\n→ 詳細は [Living Document §10](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md#10-bni活用とビジネス設計2026-05-26-定例会からの学び) に整理済み。\n\n### 自社（tugilo）へ応用できそうなこと\n\n1. **ウィークリープレゼン（25秒）** — カテゴリー名ではなく「困りごと」を先に言う\n2. **1to1の入り口設計** — 相手に「私の紹介先、もっと具体化するなら何が足りない？」と聞く\n3. **フロント商品の再確認** — 小中氏モデルのように、高額伴走の前段に「触れやすい接点」を置く\n4. **石原氏フォロー** — 保険×介護福祉×地域イベント。経営者ネットワークと業務改善の接点を1to1で探索\n\n### AI業務改善への置き換え例\n\n| 今まで | 今後 |\n|--------|------|\n| 「AI業務改善システムをしています」 | 「最近、人を増やしたくないのに仕事が回らないと言っている社長いませんか？」 |\n| 「Excelの二重入力を解決します」 | 「同じ内容を何度も入力しているとぼやいている担当者、周りにいませんか？」 |\n| 「システム開発をしています」 | 「売上は伸びているのに、現場の仕組みが追いついていない会社の社長を紹介してください」 |\n| 「経営者を紹介してください」 | 「従業員10–30名・IT以外の製造・小売で、採用または事務負担を最近増やした社長を紹介してください」 |\n\n---\n\n## 8. 次回までのアクション\n\n- [ ] **ウィークリープレゼン改善** — 悩み言語版に書き換え（25秒原稿を更新）\n- [ ] **紹介テンプレ作成** — 三段階絞り込み形式（属性＋状況＋タイミング）を1枚に\n- [ ] **石原孝之氏フォロー** — BO後の面談振り返り・1to1日程調整・紹介可能性の整理\n- [ ] **気になった方との1to1** — 吉崎淳氏（縫製×ものづくり）、必要に応じて中村氏との三角接続\n- [ ] **学びを自社提案へ反映** — 提案書・BO原稿・Living Document §2 ウィークリープレゼンに悩み言語を反映\n- [ ] **メンバーへ逆質問** — 「私をもっと紹介しやすくするために足りない情報は何ですか？」を1to1で実施\n\n---\n\n## 9. 一言まとめ\n\n**「誰を紹介してほしいか」ではなく、「どんな悩みを口にする人か」を共有することで、紹介精度は大きく変わる。**  \nチャプターの拡大は配線を増やすだけ。tugiloが次にやるべきは、75人体制に流し込む **高精度の悩み言語** を自分の言葉で定義し、毎週25秒で繰り返すこと。\n\n---\n\n## 付録：BNI・チャプター情報（例会内共有）\n\n### ドラゴンフライ\n\n| 項目 | 内容 |\n|------|------|\n| ビジョン | フライングスカイ — つながりを世界の果てまで |\n| コアバリュー | クオリティ・プライド・チャレンジ |\n| 今期スローガン | 百華繚凛 |\n\n### 世界のBNI\n\n77カ国・11,642チャプター・約350,000人。東京リージョン24チャプター・1,148名（日本一）。\n\n### 役員・サポート（紹介のみ）\n\n- **プレジデント:** 平山真由美\n- **VP:** 芳賀貴俊\n- **書記兼会計:** 岡本智美\n- サポート: 舩杉（メンター）、竹内（EC）、西浦（ビジホス）、山本（トレーニング）、渡辺（フォーラム）、中村（対面）、太田（1to1）、倉松（ウェブマスター）、飯田（BCP）、飯田千穂（オンラインコミュ）、藤井（グローバルビジネス）、福上（BOD）\n- チャプターサポート: 藤田真紀（DC）、山崎唯一（GAD）、木下かおる（東京 NE ED）\n\n### 入会案内（共有内容）\n\n1. 登録費・プログラム利用料の入金  \n2. 申込書をメンバーシップ委員会へ  \n3. 面談・振込明細・信用紹介先を VP へ  \n\n**費用:** 登録費 50,000円（税別）／プログラム 190,000円/年（2年 -80,000 / 5年 -150,000）／チャプター運営費 5,000円/月  \n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-05-26 17:53 | 初版。Zoom 文字起こし要約を議事録化。 |','docs/meetings/chapter/chapter_weekly_20260526.md','chapter_weekly','2026-05-26','08:00-10:00','DragonFly 定例枠（火曜）。開始・終了の正確な時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-26）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":209,\"session_date\":\"2026-05-26\",\"session_time_jst\":\"08:00-10:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306e\\u6b63\\u78ba\\u306a\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-26\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260526\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026_05_26.pdf\",\"..\\/..\\/pdf\\/260526\\/dragonfly_209_20260526_corrected_full.csv\"]}','2026-06-19 12:59:58','2026-06-02 15:39:21','2026-06-19 12:59:58'),
(4,13,'# BNI DragonFly 定例会議事録（2026/06/02）\n\n**日時:** 2026-06-02（火）JST **08:00–10:00**（定例枠・要確認）  \n**形式:** Zoom  \n**参加者:** ビジター 12名・ゲスト 1名・代理出席 1名  \n**関連:** [参加者 CSV](../../pdf/260601/dragonfly_210_20260602_all_full.csv)\n\n---\n\n## 1. 定例会概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年6月2日（火） |\n| **ビジター** | **12名** |\n| **ゲスト** | **1名** |\n| **代理出席** | **1名** |\n| **リファーラル** | **146件**（内部16・外部130） |\n| **メインプレゼン** | 田渕恭平（高級石材・庵治石） / 松倉健治（エアロゲル透明断熱フィルム） |\n\n新メンバー1名（**木村杏那**さん・旧姓山田杏奈）の入会承認と、既存メンバー2名（畑山紀之さん・今西俊明さん）の更新承認が行われた。今週のリファーラルは146件（内部16・外部130）。メインプレゼンでは、田渕恭平さんが高級石材・庵治石の事業と「石と人の関係を構築する」ビジョンを紹介し、松倉健治さんがエアロゲル透明断熱フィルムの省エネ・防災価値を紹介した。\n\n---\n\n## 2. 決定事項・重要事項\n\n### メンバーシップ関連\n\n| 区分 | 氏名 | カテゴリー / 内容 | 補足 |\n|------|------|-------------------|------|\n| **新規入会承認** | **木村杏那**（旧姓山田杏奈） | 建設業の業務改善パートナー | 講演者: 平岡邦彦 |\n| **更新承認** | **畑山紀之** | スイーツのOEM製造 | |\n| **更新承認** | **今西俊明** | 飲食店向け集客アプリ | |\n\n### 運営関連\n\n- 倉持賢一さんのパソコントラブルにより、小中さんが朝礼スライド共有のバックアップ対応を担当。\n- 朝礼資料は **バージョン2.02**、定例会ゼロは **バージョン1.01** が最新版として確認された。\n- 倉持さんは新しい MacBook の購入を検討（M5 の価格確認済み）。\n\n---\n\n## 3. 会議前の技術トラブル対応\n\n倉持さんのメインパソコンが熱による不具合で、30分程度しか稼働できない状態となった。エアコン・冷却ファンで対策したが、新しいパソコンへの切り替えが必要と判断され、当日はプログラミング教室用のパソコンで参加した。\n\n小中さんがスライド共有のバックアップ体制を整え、メッセンジャーでの連絡体制を確認した。\n\n---\n\n## 4. ビジター・ゲスト紹介\n\n横山尚武さん（ビジターホスト）より、ビジター12名・ゲスト1名・代理出席者1名が紹介された。\n\n| 氏名 | 事業・カテゴリー | 要点 |\n|------|------------------|------|\n| **門脇唯** | SNSマーケティング | 45日で1万フォロワー、広告ゼロで月300万円売上のノウハウ。400フォロワーから1万フォロワーへの成長実績 |\n| **岩本悠太** | 医療専門FP | 静岡県内で医療特化型FP。企業・医療機関向けセミナー、福利厚生導入支援 |\n| **寺本勲** | 経営者コンディショニングサロン | 声優・ナレーター23年の経験を活かした声・話し方のコンサルティング |\n| **林田直也** | 販管費削減コンサル | 電気代・水道代などインフラコスト見直しによる利益改善支援 |\n| **遠藤哲也** | 経営者マッチング | 経営者プラットフォーム「ユニオンプラス」。1,000人以上登録、3ヶ月無料キャンペーン中 |\n| **中西優斗** | YouTubeマーケティング | 成果報酬型SNS運用。10万人超チャンネル複数作成、問い合わせ・集客導線まで設計 |\n| **和合純也** | アパレルデザイナー | 自社ブランドとOEM/ODM。10枚から量産対応 |\n| **Hikaru** | シンガーソングライター | 6月20日に東京で5周年ライブ。SNS中心にライブ活動・PR業務 |\n| **溝渕剛彦** | 中小企業診断士 | 地方銀行34年。経営改善・資金調達・事業承継を銀行目線と経営者目線で支援 |\n| **竹葉ノア** | 統計学・量子力学コーチング | 周波数分析・調整と統計学による願望実現支援。40代以上の経営者向け |\n| **島田徹也** | 住宅設備 | 千葉県成田市。プロパンガス製造、給湯機器・住宅設備の交換工事 |\n\n---\n\n## 5. BNI概要説明・コアバリュー\n\n平山真由美プレジデントより、BNIの目的・コアバリュー・重要用語の説明が行われた。\n\n| 項目 | 内容 |\n|------|------|\n| **BNI規模** | 世界77カ国、11,654チャプター、約35万人のメンバー |\n| **重要用語** | リファラル、チャプター、サンキュー金額 |\n| **本日のコアバリュー** | **伝統と革新** |\n\n「伝統と革新」では、基盤としての伝統を大切にしながらイノベーションを生み出すことの重要性が共有された。\n\n---\n\n## 6. ネットワーキング学習コーナー\n\n**担当:** 竹内駿太（エデュケーションコーディネーター）  \n**テーマ:** 野球の配球の組み立て\n\n30秒プレゼンを、単発の自己紹介や商品説明ではなく **3週間の戦略的配球** として組み立てる考え方が共有された。\n\n野球のピッチャーが、1球ごとにただ全力で投げるのではなく、打者の反応を見ながらストレート・変化球・コースを組み合わせるように、BNIのウィークリープレゼンも **毎週の25秒・30秒を連続した流れとして設計する** という学び。1回で全部を伝えようとすると情報量が多くなり、聞き手は「結局、誰を紹介すればよいのか」を持ち帰りにくい。そこで、3週間を1セットにして、聞き手の理解を段階的に深める。\n\n| 週 | 役割 | 内容 |\n|----|------|------|\n| **1週目** | 課題提示 | 業界や顧客が抱える課題を提示する。「こういう困りごとがある人がいる」と、聞き手の周囲を思い浮かべてもらう |\n| **2週目** | 解決策提示 | 自分独自の解決策・価値を示す。課題に対して、なぜ自分が役に立てるのかを短く伝える |\n| **3週目** | ターゲット要求 | 紹介してほしい相手を明確にする。業種・立場・状況・発していそうな言葉まで絞り込む |\n\n75人体制のチャプターになった場合、2,775通りのパスコースが生まれるという説明があり、チャプターの紹介インフラを活かすには、プレゼン側の設計力が必要だと整理された。\n\n### 3週間配球の狙い\n\n| 観点 | 意味 |\n|------|------|\n| **聞き手の記憶に残す** | 毎週違う話題に飛ぶのではなく、同じテーマを角度を変えて伝えることで「この人はこの課題の人」と覚えてもらう |\n| **紹介者の負担を下げる** | いきなり「この人を紹介して」と言う前に、課題と解決策を共有しておくことで、紹介者が説明しやすくなる |\n| **紹介の精度を上げる** | 3週目でターゲットを絞るため、単なる見込み客ではなく、今まさに困っている人につながりやすくなる |\n| **反応を見て修正する** | 1週目・2週目のあと、BOや121で出た反応をもとに、3週目の紹介依頼を調整できる |\n\n### プレゼン設計の型\n\n1週目は「自分のサービス名」ではなく「相手が日常で言っていそうな困りごと」から入る。たとえば「AI業務改善をしています」よりも、「人を増やしたくないけど、事務作業が増えて現場が回らない会社が増えています」の方が、聞き手は周囲の人を思い出しやすい。\n\n2週目は、その課題に対して自分が何をしているかを伝える。ただし機能の羅列ではなく、Before / After で短く話す。「紙やLINEに散らばった報告を、あとから集計できる形に整える」「毎月の手作業を、確認だけで済む形にする」のように、聞き手が第三者へ説明しやすい言葉にする。\n\n3週目は、紹介してほしい相手を絞る。業種だけでなく、規模・役職・今起きている出来事・口にしていそうな悩みまで具体化する。紹介依頼は「経営者なら誰でも」ではなく、「最近、人を増やさずに事務作業を減らしたいと言っている、10〜30名規模の建設業・製造業の社長」のようにする。\n\n### 次廣のプレゼンへの落とし込み例\n\n| 週 | 方向性 | 25秒・30秒の骨子 |\n|----|--------|------------------|\n| **1週目** | 課題 | 「現場では、日報・見積・集計・問い合わせ対応など、売上に直結しない作業に時間を取られている会社が多いです。特に、社長やベテランだけが分かる作業が増えると、人を増やしても楽になりません。」 |\n| **2週目** | 解決 | 「私は、そうした手作業や属人化している流れを整理し、LINE・Web・AIを使って、確認だけで回る仕組みに変える仕事をしています。いきなり大きなシステムではなく、現場の1つの困りごとから始めます。」 |\n| **3週目** | 紹介依頼 | 「今週は、建設業・製造業・店舗運営で、毎月の集計や現場報告を誰かが手でまとめていて、『人を増やす前に何とかしたい』と言っている社長・店長・事務責任者をご紹介ください。」 |\n\n### 今後の実践メモ\n\n- 1テーマを3週間で使い切る前提で、毎週違う商品説明をしすぎない。\n- 1週目は「悩みの言葉」、2週目は「変化の言葉」、3週目は「紹介先の条件」に集中する。\n- BOや121で「それなら誰々が困っていそう」と言われた表現は、翌週のプレゼンに反映する。\n- 6月23日の次廣メインプレゼン前は、この3週間配球を使って、聞き手に「紹介してほしい相手」を先に温めておく。\n\n---\n\n## 7. 5月度 ネットワーキングリーダー\n\n| 部門 | 受賞者 | 実績 |\n|------|--------|------|\n| **リファラル部門** | 平岡邦彦 | 44件 |\n| **ビジター招待部門** | 平山真由美 | 4名 |\n| **ワントゥーワン部門** | 増本重孝 | 67件 |\n| **サンキュー金額部門** | 久米佳代子 | 600万円 |\n| **教育ポイント部門** | 太田一誠 | 31ポイント |\n\n---\n\n## 8. ウィークリープレゼンテーション\n\n全メンバーが25秒以内で自己紹介と紹介希望先を発表した。カテゴリー順は、建設・不動産、中小企業サポート、ライフサポート、金融・保険、士業コンサル、IT、飲食・製造、ファッション・デザイン、美容・健康。\n\n新メンバーの原田沙織さんは、デジタルサイネージの販売代理店募集について1分間のスタートダッシュプレゼンを実施。看板屋さんや電気工事士との相性の良さを強調した。\n\n---\n\n## 9. メインプレゼン要点\n\n### 田渕恭平 — 高級石材・庵治石\n\n#### 会社・背景\n\n- 1883年創業、143年の歴史を持つ田渕石材株式会社の六代目後継者。\n- 元消防士としての経験から、「守りたい」という気持ちで家業を承継する決意を語った。\n- 日本最高級の花崗岩 **庵治石** を扱う。\n\n#### 事業の特徴\n\n| 観点 | 内容 |\n|------|------|\n| **素材** | 庵治石は「花崗岩のダイヤモンド」と呼ばれる日本最高級石材 |\n| **実績** | 首相官邸の玄関・中庭、ZOZOタウン前澤社長の自宅など |\n| **提供体制** | 採石から加工・販売まで一貫した垂直統合型。中間業者を介さず高品質な石材をフルオーダーで提供 |\n\n#### ビジョン\n\n「令和の時代に新たな石器時代を作る」という夢を掲げ、石と人の関係を構築することを目指している。墓石だけでなく、内装デザイン、インテリア、建築材として石の新しい使い方を体現し、展示会やSNSで発信を続けている。\n\n#### 紹介希望先\n\n- 一泊20万円以上の高級宿・ホテルの設計会社\n- 5億円以上の超高級住宅建設会社\n- 富裕層向けコミュニティ運営者\n- デザイナー\n\n---\n\n### 松倉健治 — エアロゲル透明断熱フィルム\n\n#### 会社・背景\n\n- 営業歴28年、ガラスフィルム職人歴15年。\n- 世界初のNASA認定断熱素材 **エアロゲル** を使用した窓ガラスフィルムを紹介。\n\n#### 製品の特徴\n\n| 観点 | 内容 |\n|------|------|\n| **省エネ** | 夏のエアコン電気代 約23%カット、冬のエアコン電気代 約21%カット |\n| **通年効果** | 従来の遮熱フィルムと異なり、夏・冬の両方で省エネ効果 |\n| **太陽角度への適応** | 夏場（90度）は約3割遮熱、冬場（30度）は約8%のみ遮熱して太陽熱を取り込む |\n| **透明性** | 施工箇所が視覚的にほとんど判別できない |\n| **UV対策** | UV99%以上カット |\n| **結露対策** | 冬場の結露を約10分の1に抑制 |\n| **受賞歴** | 建築材料協会の特別賞を受賞 |\n\n#### 災害対策機能\n\n台風・地震による窓ガラス飛散を防ぐ効果があり、コーティングにはない安全性能を提供する。千葉県の台風被害事例を挙げ、小石による窓ガラス破損から家全体を守る重要性を説明した。\n\n#### 施工実績・紹介希望先\n\n- 事務所施工で約12万円。窓際からの冷気がなくなったという顧客の声を紹介。\n- 紹介希望先は、窓が大きく電気代が高い施設、設計士、リゾートホテルなど。\n\n---\n\n## 10. リファラル発表\n\n| 項目 | 数値 |\n|------|------|\n| **リファラル合計** | **146件** |\n| **内部リファラル** | 16件 |\n| **外部リファラル** | 130件 |\n| **サンキュー金額** | 後日報告予定 |\n\n### 今週のベスト3\n\n| 順位 | 氏名 | 件数 |\n|------|------|------|\n| **1位** | 次廣淳 | 9件 |\n| **2位** | 増本重孝 / 平岡邦彦 | 各7件 |\n| **3位** | 越賀俊江 | 6件 |\n\n主なリファラル内容は、建設業者の紹介、コンサルティングサービスの紹介、商材購入、ワントゥーワン実施など。\n\n---\n\n## 11. 5月度 統計報告\n\n**報告:** 芳賀崇利バイスプレジデント\n\n| 指標 | 5月度 |\n|------|------|\n| **リファラル合計** | 338件（内部66・外部272） |\n| **ビジター総数** | 23名 |\n| **ワントゥーワン回数** | 741回 |\n| **サンキュー金額** | 2,181万3千円 |\n\n### 発足以来累計\n\n| 指標 | 累計 |\n|------|------|\n| **リファラル** | 27,190件 |\n| **ビジター** | 1,475名 |\n| **サンキュー金額** | 11億221万円 |\n| **1定例会あたりサンキュー金額** | 530万円 |\n\n---\n\n## 12. シェアストーリー\n\n**登壇者:** 中村圭吾（日本製ものづくり最高事業プロデューサー）  \n**BNI歴:** 3年10ヶ月\n\n全国のオーダースーツ業者とつながるために入会し、100社以上とのつながりを構築。BNIのビジョン「世界のビジネスのやり方を変える」を「自社のビジネスのやり方を変える」と置き換え、全国の日本製ものづくり会社と手を取り合う新たなスタートを切ったと共有した。\n\n将来の夢は、両国国技館で **「日本製の覚悟展」** を開催すること。\n\n---\n\n## 13. 推薦の言葉\n\n**推薦者:** 岡本智美  \n**対象:** 山本洸太\n\nデザインのコンサルティングを受けた結果、「ゴールに対しての方程式」を定めることでクオリティが向上し、単価が5倍に上がり、リピート率も増加したと報告された。\n\n山本さんは「デザインは正解を探すものではなく、自分なりの方程式を見つけていくのが楽しいところ」とコメントした。\n\n---\n\n## 14. リファラル真性度確認\n\n**対象:** 太田一誠 → 船津麻理子\n\n太田さんは、リージョンカンファレンスでつながった高気密高断熱住宅を手掛ける高橋さんを、医療系やサロンへの人脈を求めていた船津さんへ紹介した。\n\n船津さんからは、太田さんが事業内容をしっかり理解した上でつないでくれたため、ワントゥーワン中にご来店予約までいただけたと報告された。\n\n---\n\n## 15. プレゼント抽選\n\n| 提供者 | 商品 | 当選者 |\n|--------|------|--------|\n| **田渕恭平** | 庵治石にドラゴンフライのロゴを彫ったペン立て | 平岡さん |\n| **松倉健治** | ナイレのペン | 福士さん |\n\n---\n\n## 16. 入会案内\n\n**説明:** 岡本智美（書記兼会計）\n\n| 項目 | 内容 |\n|------|------|\n| **登録費** | 5万円 |\n| **プログラム利用料** | 19万円（税別） |\n| **申込手順** | 入金 → 申込書をメンバーシップ委員会へ提出 → 面談審査 |\n| **複数年契約割引** | 2年で8万円割引、5年で15万円割引 |\n| **チャプター運営費** | 毎月5,000円 |\n\n---\n\n## 17. 確認待ち事項・アクション\n\n### 確認待ち事項\n\n- 募集カテゴリー: コンサル業、ウェブマーケティング、中小企業診断士、コスト削減\n- 今後4週間のメインプレゼンテーション担当者スケジュール\n\n### アクションアイテム\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **倉持さん** | 新しい MacBook の購入検討 | 未定 |\n| **各メンバー** | ビジターへのフォローアップとワントゥーワン実施 | 早め |\n| **平岡さん・福士さん** | プレゼンターへ配送先情報を提供 | 早め |\n| **ビジター** | 入会検討時はアテンドメンバーへ質問・相談 | 随時 |\n\n---\n\n## 18. 次回以降の予定\n\n| 日付 | 内容 |\n|------|------|\n| **2026-06-20** | Hikaru様 5周年ライブ（東京） |\n| **2026-07-03〜07-04** | 日本製ものづくり事業者向け通信販売イベント（東京・有楽町） |\n| **次週以降** | メインプレゼンテーション担当者は決定済み（詳細確認待ち） |\n\n---\n\n## 19. 閉会\n\n平山真由美プレジデントより、ビジターへの感謝とBNIの価値について総括が行われた。\n\n「誰かの成功を願い、誰かのために行動し、仲間と共に成長していく」というチャプター文化が強調され、新しい場所へ足を運ぶ勇気と、仲間として共にビジョンを叶えていくことの重要性が語られた。\n\nビジターは個別の部屋でアテンドメンバーとの質疑応答へ移動し、アンケートへの協力が依頼された。\n\n---\n\n## 20. 次廣視点の振り返りメモ\n\n### 自分の成果\n\n- 今週のリファラル **9件** で第1位。\n- 6月23日の自分のメインプレゼンに向けて、田渕さん・松倉さんの紹介希望先の具体性、ビジョンの出し方、製品価値の見せ方を参考にできる。\n\n### フォロー・1to1候補\n\n| 候補 | 接点 |\n|------|------|\n| **門脇唯さん / 中西優斗さん** | SNS・YouTubeマーケティング。tugilo の予約・LINE・業務改善導線との連携余地 |\n| **林田直也さん** | 販管費削減。固定費削減後の業務効率化・DX導線で相性あり |\n| **溝渕剛彦さん** | 中小企業診断士。補助金・経営改善・資金調達文脈で協業余地 |\n| **松倉健治さん** | エアロゲルフィルム。過去1to1済み。高級リゾートホテル・設計士紹介導線を再確認 |\n| **田渕恭平さん** | 高級石材。富裕層・設計・ホテル・デザイン系紹介先の整理対象 |\n\n### 学び\n\n- 30秒プレゼンは単発ではなく、3週間で「課題 → 解決策 → 紹介希望先」を組み立てる。\n- メインプレゼンでは、商品説明だけでなく、承継背景・ビジョン・紹介してほしい相手の条件をセットで伝えると記憶に残りやすい。\n- 「伝統と革新」は、自分の AI 業務改善の説明でも、既存の仕事・現場文化を壊すのではなく、良い部分を残して更新する文脈として使える。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-02 14:21 | Zoom 文字起こし要約をもとに初版作成 |','docs/meetings/chapter/chapter_weekly_20260602.md','chapter_weekly','2026-06-02','08:00-10:00','DragonFly 定例枠（火曜）。開始・終了の正確な時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-02）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":210,\"session_date\":\"2026-06-02\",\"session_time_jst\":\"08:00-10:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u958b\\u59cb\\u30fb\\u7d42\\u4e86\\u306e\\u6b63\\u78ba\\u306a\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-02\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260601\\/dragonfly_210_20260602_all_full.csv\"]}','2026-06-19 12:59:58','2026-06-02 15:39:21','2026-06-19 12:59:58'),
(5,14,'# BNI DragonFly 定例会議事録（2026/06/09）\n\n**日時:** 2026-06-09（火）JST **09:00–**（文字起こし要約・要確認）  \n**形式:** Zoom  \n**回数:** 第 **211** 回  \n**参加者:** ビジター **3名**・ゲスト **1名**（メンバー 54名＋リージョンサポート等・CSV ベース）  \n**関連:** [参加者リスト PDF](../../pdf/260609/定例会参加者リスト2026_06_09.pdf) · [参加者 CSV](../../pdf/260609/dragonfly_211_20260609_all_full.csv) · [BOR 部屋割り](../../pdf/260609/712943120_1046122934614907_1440127954496282131_n.jpg) · [スリーバイス チームMTG（同日朝）](../team/team_threebiz_20260609.md)\n\n---\n\n## 1. 定例会概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年6月9日（火） |\n| **ビジター** | **3名** |\n| **ゲスト** | **1名**（竹村裕司） |\n| **リファーラル** | **134件**（内部19・外部115） |\n| **メインプレゼン** | 倉持賢一（中国向け物販支援） / 佐藤拓斗（建設業向け高校生新卒採用コンサル） |\n\n新規入会1名（八田奈緒美さん）の承認と、竹内駿太さん（3年目）の更新承認が行われた。今週のリファーラルは134件で、清原佳彩美さんが15件で第1位。教育コーナーは竹内駿太さんによる「バレーボールのローテーション制とBNI」、シェアストーリーは渡邊真大さん。増本重孝さんから次廣淳さんへの推薦の言葉、久米加代子さん→原田里織さんへのリファーラル真性度確認（約900万円のサイネージ契約）が実施された。ビジター3名はチャプターの活気とリファーラル文化を高く評価した。\n\n---\n\n## 2. 決定事項・重要事項\n\n### メンバーシップ関連\n\n| 区分 | 氏名 | カテゴリー / 内容 | 補足 |\n|------|------|-------------------|------|\n| **新規入会承認** | **八田奈緒美** | 骨盤底筋体操導入サポート | 講演者: 舩杉牧子。入会理由: 活気とスピード感の中での温かさを評価 |\n| **更新承認** | **竹内駿太** | アスリート専門生命保険 | 3年目。2年間で転職を実現し多くの機会を得たと報告 |\n\n### 運営関連\n\n- **ビジターホスト:** 福上大輝さんがビジターホストコーディネーターとして案内・プレゼン進行を担当。\n- **Webマスター:** 次廣が朝礼スライド統合（月曜）・定例会のレコーディング／スポットライトを初回担当（[引き継ぎ議事録](../webmaster/webmaster_handover_20260603.md)）。\n- **部屋9 デモBOR:** ビジター少数のため、オープンBOR 2回を部屋9で実施。**温活機器導入サポートの久米さん**が自己紹介→事業紹介、次廣がファシリ（詳細は §3）。\n\n### 入会・更新式\n\n平山真由美プレジデントが BNI 倫理規定7項目を読み上げ、八田さん・竹内さんが復唱・承諾。\n\n---\n\n## 3. ビジター・ゲスト\n\n| 区分 | 氏名 | 事業・カテゴリー | 紹介者 | 要点 |\n|------|------|------------------|--------|------|\n| **ビジター** | **横山太樹** | 資金調達支援（補助金・融資） | 渡邊真大 | 元銀行員。融資・補助金活用、決算書・事業計画づくり（全国対応） |\n| **ビジター** | **吉川真徳** | 個人・企業向け金融コンサルティング | 佐藤拓斗 | 個人はゴール志向のポートフォリオ、法人はスケール活用の物価高・法人税対策（全国対応） |\n| **ビジター** | **高野晋** | 通信系営業代行 | 佐藤拓斗 | 東海中心に関東・関西。若い学生多数で法人営業代行 |\n| **ゲスト** | **竹村裕司** | プロモーション動画制作 | 芳賀崇利 | — |\n\n### ビジター感想\n\n| 氏名 | 感想 |\n|------|------|\n| **横山太樹** | リファーラルが活発で活気がある。1to1希望者が多数いた |\n| **吉川真徳** | リファーラル数が多く活気を感じた |\n| **高野晋** | 全国規模で紹介の数が多く、純粋にすごいと思った |\n\n---\n\n## 4. ブレイクアウトルーム（BOR）\n\n出典: [BOR 部屋割り画像](../../pdf/260609/712943120_1046122934614907_1440127954496282131_n.jpg)\n\n| 部屋 | メンバー | ビジター / ゲスト | ファシリ | 書記 |\n|------|----------|-------------------|----------|------|\n| **1** | 舩杉・竹内・紀川・海沼・望月 | V01 横山太樹 | 舩杉 | 竹内 |\n| **2** | 太田・佐藤・梅澤・木村健悟・原田 | V02 吉川真徳 | 太田 | 佐藤 |\n| **3** | 中村・福士・松倉・里見・森園 | V03 高野晋 | 中村 | 福士 |\n| **4** | 増本・飯田千帆・福上・山本洸太・芳賀 | G01 竹村裕司 | 増本 | 飯田千帆 |\n| **5–8, 10** | （画像どおり） | — | — | — |\n| **9** | 次廣・越賀・久米・清原・米澤 | **デモ**（久米） | **次廣** | 越賀 |\n\n### 部屋9デモBOR（実施内容）\n\nビジターが少ない日のため、**オープンBOR 1・2回目**を部屋9でデモ実施。進行は **①軽い自己紹介 → ②事業紹介（温活機器導入サポート） → ③質問タイム**。Nキャス備考欄への「聞いてほしい質問」入力で質問が苦手な人も準備しやすくなる運用がチャプター全体でも共有された。\n\n---\n\n## 5. ネットワーキング学習コーナー\n\n**担当:** 竹内駿太（エデュケーションコーディネーター）  \n**テーマ:** バレーボールのローテーション制から学ぶビジネス加速\n\n| 観点 | 内容 |\n|------|------|\n| **ローテーション** | 全員が攻撃・守備・サーブを担当。他ポジションの痛みを知るとチームの信頼が強固になる |\n| **BNIへの応用** | レシーバー（見込み客探索）・セッター（顧客をつなぐ）・アタッカー（成約）を全員が経験し、紹介の重みを理解する |\n| **運営役職** | プレジデント・エデュケーション等をローテーションで回し、組織俯瞰の視点でビジネスの器が拡大 |\n| **75人体制** | 51人→75人で紹介ルートは約2.2倍（2,775ライン）。全員が泥臭いレシーブと丁寧なトスでアタックを打ち抜く体制を目指す |\n| **今週のワーク** | 普段やっていないポジションを意識。紹介を受けがちな人はレシーブ、役員未経験者は運営サポート |\n\n---\n\n## 6. ウィークリープレゼンテーション\n\nメンバー51名が25秒プレゼン。**山本葉子**さん（ビジネス特化型クレジットカード）がスタートダッシュプレゼンから開始。請求書払い・カード決済による資金繰り改善事例（Amex プラチナビジネス等）を紹介し、「資金繰りの会話が聞こえたら紹介してほしい」と依頼。\n\n文字起こし要約では建設・不動産・中小企業サポート各カテゴリーの要点まで記載（中村啓吾さんのプレゼン途中で要約が途切れているため、全カテゴリー網羅は **要確認**）。\n\n---\n\n## 7. メインプレゼン要点\n\n### 倉持賢一 — 中国向け物販支援\n\n#### 事業の位置づけ\n\n「ものづくり企業の海外進出を丸ごと支えるエキスパート集団」（合同会社ティーボックス）。日本製品の中国向け販売支援、WeChat・小紅書（ションシュート）を活用した SNS 物販。\n\n#### 課題と解決\n\n| 観点 | 内容 |\n|------|------|\n| **市場現状** | アリババ等で22万社中わずか約400社が日本企業。海外進出が進んでいない |\n| **6つの壁** | 英語・貿易人材不足、着金遅延による財務悪化、模倣品、パッケージ対応、生産設備増強、在庫・生産調整 |\n| **実績** | アリババ代理店化、Temu へのメーカー出店支援、オンライン・オフライン事業者交流 |\n\n#### 紹介希望先\n\n消臭スプレー・臭くならないタオル等の清潔系、加工食品、文房具・日用品、中古車メーカー。人材・財務・知財・物流・プロダクトデザイン・在庫生産管理・新規プロダクト開発の各プロフェッショナル。\n\n**紹介の切り口:** 「ものづくり企業の海外進出を支えるチームがいるんだけど、お話してみませんか？」\n\n---\n\n### 佐藤拓斗 — 建設業向け高校生新卒採用コンサル\n\n#### 理念\n\n高校生採用は会社の**未来への投資**。中途採用（今の人手不足補充）とは位置づけが異なる。\n\n#### サービス\n\n| 項目 | 内容 |\n|------|------|\n| **求人票** | 300字をフル活用し、入社から未来までのキャリアを伝える |\n| **制作物** | 見開き2ページパンフ、ショート動画 |\n| **体験設計** | 採用につながるプログラムを会社ごとに提案 |\n| **学校訪問** | 社長の代わりに外部採用担当として学校へアプローチ |\n\n#### 紹介希望先\n\n従業員50名以下で人事専門部署がなく、自身も現場に出ている建設業の社長。「会社の未来のための若手採用、うまくいってますか？」が入口。\n\n---\n\n## 8. リファーラル発表\n\n| 項目 | 数値 |\n|------|------|\n| **リファーラル合計** | **134件** |\n| **内部リファーラル** | 19件 |\n| **外部リファーラル** | 115件 |\n\n### 今週のベスト3\n\n| 順位 | 氏名 | 件数 |\n|------|------|------|\n| **1位** | 清原佳彩美（サロン向け育毛機器・商材販売） | 15件 |\n| **2位** | 増本重孝（害虫ブロック） | 9件 |\n| **3位** | 太田一誠・平岡国彦・舩杉牧子・船津麻理子・中村啓吾 | 各5件 |\n\n---\n\n## 9. 5月度 統計報告\n\n**報告:** 芳賀崇利バイスプレジデント（文字起こし要約）\n\n| 指標 | 5月度 |\n|------|------|\n| **リファーラル合計** | 338件（内部66・外部272）※要約の「外部398」は誤記と判断し、第210回議事録と整合 |\n| **ビジター総数** | 23名 |\n| **ワントゥーワン回数** | 741回 |\n| **サンキュー金額** | 2,181万3千円 ※要約の「産休金額」はサンキュー金額の誤変換 |\n\n### 発足以来累計\n\n| 指標 | 累計 |\n|------|------|\n| **リファーラル** | （要約に個別件数なし） |\n| **サンキュー金額** | 11億2,201万円 |\n| **1定例会あたりサンキュー金額** | 530万円 |\n\n---\n\n## 10. シェアストーリー\n\n**登壇者:** 渡邊真大（着物に強い出張買取）\n\n| 観点 | 内容 |\n|------|------|\n| **入会前** | 相見積もりサイトのみ。毎回ゼロから信頼構築で消耗 |\n| **入会後** | 紹介経由で「お願いしたい現場がある」と初対面前に信頼が届く状態 |\n| **売上** | 1年目2,500万円 → 2年目5,000万円 |\n| **本質** | 選ばれる理由が「価格」から「信頼」へ。信頼を循環させる仕組みが最大の武器 |\n\n---\n\n## 11. 推薦の言葉\n\n| 項目 | 内容 |\n|------|------|\n| **推薦者** | 増本重孝（害虫ブロック） |\n| **対象** | 次廣淳（AI業務改善システム構築） |\n| **内容** | 取扱店200社超の管理不安を解消する受発注・マニュアル閲覧・一斉お知らせシステムを依頼。事務員1人雇用の年収の半分以下で実現し他社より安価なため推薦 |\n| **次廣コメント** | 害虫ブロック事業の成長を見据え一緒に仕組みを形にできたことを光栄に思う。今後も取扱店増加に伴奏していく |\n\n---\n\n## 12. リファーラル真性度確認\n\n| 項目 | 内容 |\n|------|------|\n| **紹介元** | 久米加代子（温活機器導入サポート） |\n| **紹介先** | 原田里織（店舗・施設集客を高めるデジタルサイネージ） |\n| **内容** | 浜松で100社以上のHPを作る広告会社・松下社長を紹介。デジタルサイネージに興味ありと確認 |\n| **成果** | 他社高額見積もりで流れた案件を受注。**10.5㎡・約900万円**（本体600万円＋設置工事）の契約成立 |\n\n---\n\n## 13. 今後のイベント・お知らせ\n\n| イベント | 日程・内容 |\n|----------|------------|\n| **7月東京リージョンフォーラム** | 日程 **要確認**（要約「1月6日」は誤記の可能性）。百点メンバー: 西浦雅・平岡国彦・増本重孝 |\n| **BOD** | **2026-07-28**（約50日後）。ビジネス拡大を具体的にイメージする日。入会義務なし。過去ビジターへの再声掛け推奨 |\n| **GBM** | **2026-08-21**。ピッチコンテストに久米加代子さん登壇。Zoom参加可 |\n\n### 運用・フォロー\n\n- **対面イベントアンケート:** 未回答15名へ即日回答依頼（タイムイベントグループ LINE 送付済み）\n- **推薦の言葉:** トラフィックライト対象外だが貢献度は大きい。Nキャス「運営」→「感謝のメッセージ推薦の言葉」から入力\n- **ウィークリースライド:** 同上メニューから画像・PPT を格納すると翌週反映\n- **ビジター招待の質:** ファシリ練習実施。Nキャス備考に「聞いてほしい質問」を書くと質問準備がしやすい\n\n---\n\n## 14. 確認待ち事項・アクション\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **未回答15名** | 対面イベントアンケート回答 | 即日 |\n| **各メンバー** | 推薦の言葉の執筆検討 | 随時 |\n| **各アテンド** | ビジター3名・ゲスト1名へのフォロー・1to1 | 早め |\n| **次廣** | Webマスター初回の振り返り | 本日 |\n\n---\n\n## 15. 次回以降の予定\n\n| 日付 | 内容 |\n|------|------|\n| **次週火曜** | オンライン定例会 **9:30開始**（要約より） |\n| **2026-06-16** | モメンタムトレーニング（定例会回数外・9回目扱い） |\n| **2026-06-23** | 第212回定例会（火） |\n| **2026-06-23** | **次廣 メインプレゼン**（キースキルズ 5分） |\n| **2026-07-28** | **BOD**（定例会回数外・月曜） |\n| **2026-08-21** | GBM（久米さんピッチ） |\n\n---\n\n## 16. 閉会\n\n平山真由美プレジデントより総括（要約に詳細なし）。ビジターはアテンドとの個別質疑へ。\n\n---\n\n## 17. 次廣視点の振り返りメモ\n\n### 本日の役割\n\n- **BOR 部屋9 ファシリ**（デモ2回・温活機器導入サポートの久米さん）\n- **Webマスター** レコーディング／スポットライト初回\n- **推薦の言葉** を増本さんからいただいた（害虫ブロックFCシステム）\n\n### フォロー・1to1候補\n\n| 候補 | 接点 |\n|------|------|\n| **横山太樹** | 補助金・融資・決算書。IT導入補助金との接続 |\n| **吉川真徳** | 法人・個人金融コンサル |\n| **高野晋** | 通信系営業代行・B2B |\n| **竹村裕司** | プロモーション動画 |\n| **倉持賢一** | 中国向け物販・製造業海外進出。Webマスター引き継ぎ先でもあり |\n| **佐藤拓斗** | 建設業高校生採用。ビジター2名を紹介しており接点深い |\n\n### 学び\n\n- 教育「ローテーション」は、レシーバー／セッター／アタッカーと運営役職の経験が紹介の質に効くという整理。\n- デモBORで「自己紹介→事業→全員質問」の型をチャプターに共有できた。\n- 増本さん推薦・久米→原田の900万円案件は、議事録・システム化の価値の具体例として共有に使える。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-09 08:56 | Nキャス CSV・BOR 画像をもとに事前準備版作成 |\n| 2026-06-09 09:06 | 部屋9デモBOR・久米さん表記・3ステップ進行を追記 |\n| 2026-06-09 14:31 | Zoom 文字起こし要約を反映し **完成版** 化。氏名・サンキュー金額・5月度外部RF等を CSV／第210回と整合 |\n| 2026-06-09 14:35 | 次廣コメント等の誤記 **外注ブロック** → **害虫ブロック** に修正（docs 全体も同期） |','docs/meetings/chapter/chapter_weekly_20260609.md','chapter_weekly','2026-06-09','09:00-11:00','文字起こし要約では次回「火曜9:30」開始を示唆。同日 08:00–08:45 にスリーバイス チーム MTG あり。終了時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-09 14:31 JST）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":211,\"session_date\":\"2026-06-09\",\"session_time_jst\":\"09:00-11:00\",\"session_time_note\":\"\\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\u3067\\u306f\\u6b21\\u56de\\u300c\\u706b\\u66dc9:30\\u300d\\u958b\\u59cb\\u3092\\u793a\\u5506\\u3002\\u540c\\u65e5 08:00\\u201308:45 \\u306b\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9 \\u30c1\\u30fc\\u30e0 MTG \\u3042\\u308a\\u3002\\u7d42\\u4e86\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-09 14:31 JST\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260609\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026_06_09.pdf\",\"..\\/..\\/pdf\\/260609\\/dragonfly_211_20260609_all_full.csv\",\"..\\/..\\/pdf\\/260609\\/712943120_1046122934614907_1440127954496282131_n.jpg\"]}','2026-06-19 12:59:58','2026-06-13 08:10:42','2026-06-19 12:59:58'),
(7,16,'# モメンタムトレーニング — 進行原稿（2026/06/16）\n\n**日時:** 2026-06-16（火）JST  \n**種別:** **モメンタムトレーニング**（BOD に向けた学びの日）— **定例会回数には含めない**（定例会 **9回目** 扱い）  \n**定例会の位置:** 前回 **第211回**（2026-06-09）／次回定例会 **第212回**（2026-06-23 予定）  \n**参加者:** メンバー 53名（**八田奈緒美** 欠席）・ビジター/ゲストなし  \n**関連:** [議事録骨子](chapter_weekly_20260616.md) · [参加者 CSV](../../pdf/260616/dragonfly_momentum_20260616_members_only.csv) · [**次廣 個人発言原稿（BOR 6テーマ）**](chapter_weekly_20260616_momentum_bor_tsugihiro.md)\n\n**想定読み上げ:** エデュケーションコーディネーター（竹内駿太）またはプレジデント（平山真由美）。BOR ファシリは各室リーダー（チームリーダー／役職者）。\n\n---\n\n## 0. 本日の進め方（スタッフ向けメモ）\n\n| 通常の定例会 | 本日のモメンタムトレーニング |\n|--------------|------------------------------|\n| 朝礼 → MP → ウィークリー → 教育 → BOR（交流）→ RF 報告 など **一方向の進行** | **メインルームでテーマ提示 → BOR で話し合い → 全員で戻って共有** を **6テーマ分** 繰り返す |\n| ビジター・ゲストあり | **メンバーのみ**（本日 53名） |\n| リファーラル報告が中心の一週 | **BOD（2026-07-28）** に向けた **40人リスト・紹介力・チーム運用** を **対話で体得** |\n\n> **ポイント:** 「聞く日」ではなく **「話して整理する日」**。各 BOR では全員が発言できる量の時間配分を意識する。\n\n---\n\n## 1. 冒頭アナウンス（メインルーム・読み上げ原稿）\n\n---\n\n皆さん、おはようございます。本日は **モメンタムトレーニング** で、**いつもの定例会とは形式が違います**（定例会の回数は進みません。前回 **第211回**、次回定例会は **第212回** です）。\n\n今日は **モメンタムトレーニング** — **BOD（ビジネスオープンデー）** に向けた **学びの日** です。\n\n通常の定例会は、メインプレゼンやウィークリープレゼン、リファーラル報告など、**チャプター全体で一緒に進む** 時間が多いですよね。\n\n**今日は違います。**\n\n**ブレイクアウトルーム（BOR）に分かれて、チームの仲間と「話し合いながら」進めます。**\n\nテーマが提示されたら、一旦 BOR に移動。**自分の言葉で整理し、隣の席のメンバーと共有する** — そういう日です。\n\n事前に、**各 BOR で何を話すか** をチラッとお伝えします。\n**本日は最高な状態で、いつもの定例会とは違った学びを、全員で掴みましょう。**\n\n---\n\n### BOR で話し合う6つのテーマ（予告）\n\n1. **あなたはどんなニーズに対応できる？**\n2. **あなたは何故 BNI を？ 近い未来の目標は？**\n3. **どんなリファーラル・専門家が必要？**\n4. **その「専門家」に、あなたのことをどう伝える？**\n5. **40名リスト — 始めよう！ または、それでいいか？ 見直し＆活用**\n6. **チームミーティングはいつ？ 何分？ 何をする？**\n\n---\n\nそれでは、**1つ目のテーマ** から始めます。\nBOR に移動したら、**全員が一言ずつでも** 話せるように、時間を大切に使ってください。\n\n---\n\n## 2. BOR テーマ別 — 提示文＋話し合いガイド\n\n各テーマは **メインルームで短く提示（30秒〜1分）→ BOR（目安 5〜8分）→ メインルームに全員集合（任意・1分）** の流れを想定。\n\n---\n\n### BOR ① あなたはどんなニーズに対応できる？\n\n**メインルーム提示（読み上げ）**\n\n> 1つ目のテーマです。**「あなたは、どんなニーズに対応できる？」**\n>\n> カテゴリー名だけでなく、**誰の、どんな困りごと** に答えられるか — それを BOR で話し合いましょう。\n\n**BOR 内の話し合い例**\n\n| 順 | 話す人 | 内容の目安 |\n|----|--------|------------|\n| 1 | 全員 | **30秒** — 自分のカテゴリー＋「こういう人の、こういう困りに効く」 |\n| 2 | 隣同士 | 相手の説明を **一言で言い換え**（紹介の練習） |\n| 3 | 全員 | 「DragonFly の中で、自分のニーズに一番近い人は誰？」を **1人ずつ** |\n\n**メモ:** 初参加の **次廣・横山・軍司** さんも、**「まだ探している」** で OK。聞く側のニーズ整理も価値あり。\n\n---\n\n### BOR ② あなたは何故 BNI を？ 近い未来の目標は？\n\n**メインルーム提示（読み上げ）**\n\n> 2つ目です。**「あなたは、なぜ BNI にいるのか？ 近い未来の目標は？」**\n>\n> 入会理由や、**3ヶ月・6ヶ月後** にチャプターで実現したいことを、率直に共有してください。\n\n**BOR 内の話し合い例**\n\n- **Why BNI** — 紹介・信頼・学び・仲間 — 自分にとって **いちばん大きい理由** は？\n- **近い未来の目標** — 例: BOD でビジター1名、1to1 月4本、特定業種への紹介3件 など **数字または行動** で\n- **相互フィードバック** — 「その目標、DragonFly なら誰が助けられる？」\n\n**DragonFly 文脈:** BOD **2026-07-28（月）** まで **約6週間**。今日話した目標は **チーム MTG で再確認** する。\n\n---\n\n### BOR ③ どんなリファーラル・専門家が必要？\n\n**メインルーム提示（読み上げ）**\n\n> 3つ目です。**「今、どんなリファーラル・専門家が必要？」**\n>\n> **欲しい紹介** と **探している専門家** を、具体的に出し合いましょう。\n\n**BOR 内の話し合い例**\n\n| 項目 | 書き出す内容 |\n|------|--------------|\n| **外部リファーラル** | 業種・地域・規模・タイミング |\n| **社内の専門家** | 法務・税務・IT・集客・採用… **誰に会いたいか** |\n| **優先度** | 今週中 / BOD まで / 3ヶ月以内 |\n\n**メモ:** 「まだわからない」人は **過去に助かった紹介** を1件話すと、必要な専門家像が見えやすい。\n\n---\n\n### BOR ④ その「専門家」に、あなたのことをどう伝える？\n\n**メインルーム提示（読み上げ）**\n\n> 4つ目です。**「その専門家に、あなたのことをどう伝える？」**\n>\n> ③で出た **相手像** を想定し、**30秒の自己紹介** または **推薦の言葉1文** を練習します。\n\n**BOR 内の話し合い例**\n\n1. ③で挙がった **「会いたい相手」** を1つ選ぶ  \n2. **相手の立場** から聞いて納得する言い方 — 機能説明より **ベネフィット**  \n3. BOR メンバーに **30秒** 話してもらい、**「紹介したくなる？」** をフィードバック  \n\n**例文の型（参考）**\n\n> 「〇〇でお困りの △△ さんに、□□ さんを紹介したいです。□□ さんは ___ で、特に ___ が強みです。」\n\n---\n\n### BOR ⑤ 40名リスト — 始めよう！ または、それでいいか？ 見直し＆活用\n\n**メインルーム提示（読み上げ）**\n\n> 5つ目です。**「40名リスト — 始めよう！ または、それでいいか？ 見直し＆活用」**\n>\n> BOD に向けた **40人リスト（応援したい人リスト）** について、BOR で話し合いましょう。\n>\n> **まだ書いていない方** — 今日から **3名でも** 書き始めて OK。  \n> **書いた方** — 角度・事業オーナー度・BOD 招待の優先順位を **見直し** ましょう。\n\n**BOR 内の話し合い例**\n\n| チェック項目 | 問い |\n|--------------|------|\n| **人数** | 40名に近いか？ 足りなければ **誰から埋める？** |\n| **質** | **意思決定できる事業オーナー** が何人いるか？ |\n| **BOD 招待** | 7/28 に **誰を第一候補** にするか — **名前を1〜2人** 口に出す |\n| **チーム** | 同じ BOR の誰と **相互チェック** するか決める |\n\n**DragonFly 文脈:** スリーバイス等のチームでは **BOD ビジター3〜4名・入会率10%** を目標に議論済み（[チーム MTG 2026-06-09](../team/team_threebiz_20260609.md)）。リストは **リファーラルの種** でもある。\n\n---\n\n### BOR ⑥ チームミーティングはいつ？ 何分？ 何をする？\n\n**メインルーム提示（読み上げ）**\n\n> 最後のテーマです。**「チームミーティングはいつ？ 何分？ 何をする？」**\n>\n> モメンタムで学んだことを **チームに持ち帰る** ため、**次のチーム MTG** を **今日中に** 具体化しましょう。\n\n**BOR 内の話し合い例（決めること）**\n\n| 項目 | 決定内容 |\n|------|----------|\n| **いつ** | 日付・曜日・時刻（例: 毎週火 8:00–8:45） |\n| **何分** | 30 / 45 / 60 分 |\n| **何をする** | 40人リストレビュー / BOD 役割分担 / 推薦の言葉 / 1to1 進捗 など **1〜2テーマ** |\n| **誰が** | ファシリ・書記・次回アジェンダ担当 |\n\n**アクション:** BOR 終了時に **「次回チーム MTG ○月○日 ○時」** をチャットまたは Nキャス メモに残す。\n\n---\n\n## 3. 締めの原稿（メインルーム・全6テーマ終了後）\n\n---\n\n6つの BOR、お疲れさまでした。\n\n今日は **座って聞くだけ** ではなく、**話して整理する** 定例会でした。\n\n- 自分の **ニーズ** と **Why BNI**\n- 欲しい **リファーラル・専門家**\n- **伝え方** の練習\n- **40人リスト** の見直し\n- **チーム MTG** の具体化\n\nこの5つ（＋チーム運用）が、**7月28日の BOD**（定例会回数外）につながります。\n\n**本日の学びを、必ずチームに持ち帰ってください。**\n次の定例会で、**40人リスト** や **BOD 招待** の進捗を互いに確認できると、チャプター全体が前に進みます。\n\nDragonFly の皆さん、今日もありがとうございました。\n**最高な状態で BOD に臨みましょう。**\n\n---\n\n## 4. 付録 — 1行サマリ（スライド・チャット用）\n\n```\n本日はモメンタムトレーニング。通常定例会と違い、BORで話し合いながら6テーマを進めます。\n\n① どんなニーズに対応できる？\n② 何故BNIを？ 近い未来の目標は？\n③ どんなリファーラル・専門家が必要？\n④ その専門家に、自分をどう伝える？\n⑤ 40名リスト — 始める／見直す／活用\n⑥ チームMTG — いつ・何分・何をする？\n\nBOD 2026-07-28（定例会回数外）に向け、本日学びをチームへ。\n```\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-16 07:50 | 初版。BOR 6テーマ原稿・冒頭/締め・スタッフ向け進行メモ |\n| 2026-06-16 09:34 | **第212回表記を削除。** モメンタムは定例会回数外。前回211・次回定例会212（6/23） |','docs/meetings/chapter/chapter_weekly_20260616_momentum_script.md','chapter_meeting_script','2026-06-16',NULL,NULL,'zoom','ユーザー提供 BOR テーマ一覧（2026-06-16）＋ DragonFly 文脈','{\"doc_type\":\"chapter_meeting_script\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-06-16\",\"session_type\":\"momentum_training\",\"momentum_week_index\":9,\"last_chapter_meeting_number\":211,\"next_chapter_meeting_number\":212,\"script_type\":\"momentum_training\",\"format\":\"zoom\",\"source\":\"\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b BOR \\u30c6\\u30fc\\u30de\\u4e00\\u89a7\\uff082026-06-16\\uff09\\uff0b DragonFly \\u6587\\u8108\",\"related_chapter_weekly\":\"chapter_weekly_20260616.md\"}','2026-06-19 12:59:58','2026-06-16 09:57:54','2026-06-19 12:59:58'),
(8,17,'# BNI DragonFly ビジネスオープンデイ（BOD）議事録（2026/07/28）\n\n**日時:** 2026-07-28（月）JST **TODO**  \n**形式:** Zoom（要確認）  \n**種別:** **ビジネスオープンデイ（BOD）** — **定例会回数には含めない**  \n**定例会との関係:** 通常の週次定例会（第 N 回）の **代替ではない** 半期イベント。`meetings.number` は **付与しない**。\n\n> **メモ:** 前後の定例会は火曜開催が基本。7/28（月）は BOD のため **その週の定例会スケジュールと重ならない** 想定。直前・直後の **第何回** かは、6月以降の定例会カレンダー確定後に `last_chapter_meeting_number` / `next_chapter_meeting_number` を追記する。\n\n**関連:** [スリーバイス BOD 戦略 MTG 2026-06-09](../team/team_threebiz_20260609.md) · [モメンタムトレーニング 2026-06-16](chapter_weekly_20260616.md)\n\n---\n\n## 1. 概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年7月28日（月） |\n| **種別** | **BOD（ビジネスオープンデイ）** |\n| **定例会回数** | **該当なし**（第 N 回定例会ではない） |\n| **ビジター** | TODO |\n| **ゲスト** | TODO |\n| **リファーラル** | TODO（BOD 後） |\n\nBOD は半期に一度の **「文化祭のような」** チャプターイベント。定例会より BNI のメリットがビジターに伝わりやすく、**40人リスト** から招待した角度の高い事業オーナーが中心。DragonFly 前期実績: ビジター50名・入会1名（入会率2%）。今期は **入会率10%** 向上を目標に各チームが動いている（[スリーバイス MTG](../team/team_threebiz_20260609.md)）。\n\n> **TODO:** BOD 終了後、文字起こし・参加者リスト・決定事項を追記。\n\n---\n\n## 2. 決定事項・重要事項\n\nTODO（BOD 後）\n\n---\n\n## 3. ビジター・ゲスト\n\nTODO（BOD 後）\n\n---\n\n## 4. 次回定例会との接続\n\nTODO — BOD 後、**次回火曜定例会** が **第何回** かを記録し、front matter の `next_chapter_meeting_number` を更新。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-16 09:53 | 初版プレースホルダー。定例会回数外である旨を明記。 |','docs/meetings/chapter/chapter_bod_20260728.md','chapter_bod','2026-07-28','TODO','ビジネスオープンデイ（BOD）。定例会回数には含めない。開催日は月曜（2026-07-28）。前後の定例会回数は開催時点のカレンダーで確定。時刻は公式案内・Zoom メタで要確認。','zoom','開催前プレースホルダー（2026-06-16 09:53 JST）— 本文は BOD 後に追記','{\"doc_type\":\"chapter_bod\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-07-28\",\"session_type\":\"business_open_day\",\"last_chapter_meeting_number\":null,\"last_chapter_meeting_date\":null,\"next_chapter_meeting_number\":null,\"next_chapter_meeting_date\":null,\"session_time_jst\":\"TODO\",\"session_time_note\":\"\\u30d3\\u30b8\\u30cd\\u30b9\\u30aa\\u30fc\\u30d7\\u30f3\\u30c7\\u30a4\\uff08BOD\\uff09\\u3002\\u5b9a\\u4f8b\\u4f1a\\u56de\\u6570\\u306b\\u306f\\u542b\\u3081\\u306a\\u3044\\u3002\\u958b\\u50ac\\u65e5\\u306f\\u6708\\u66dc\\uff082026-07-28\\uff09\\u3002\\u524d\\u5f8c\\u306e\\u5b9a\\u4f8b\\u4f1a\\u56de\\u6570\\u306f\\u958b\\u50ac\\u6642\\u70b9\\u306e\\u30ab\\u30ec\\u30f3\\u30c0\\u30fc\\u3067\\u78ba\\u5b9a\\u3002\\u6642\\u523b\\u306f\\u516c\\u5f0f\\u6848\\u5185\\u30fbZoom \\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"\\u958b\\u50ac\\u524d\\u30d7\\u30ec\\u30fc\\u30b9\\u30db\\u30eb\\u30c0\\u30fc\\uff082026-06-16 09:53 JST\\uff09\\u2014 \\u672c\\u6587\\u306f BOD \\u5f8c\\u306b\\u8ffd\\u8a18\",\"related_files\":[]}','2026-06-19 12:59:58','2026-06-16 17:14:24','2026-06-19 12:59:58'),
(9,18,'# BNI DragonFly 定例会議事録（2026/06/23）\n\n**日時:** 2026-06-23（火）JST **09:00–11:00**（定例枠・終了時刻要確認）  \n**形式:** Zoom  \n**回数:** 第 **212** 回  \n**参加者:** Zoom 要約値: メンバー48名・ビジター12名・代理出席2名・ゲスト3名、合計65名。CSV登録値: メンバー54名（リージョン含む）・ビジター13名・代理出席2名・ゲスト3名。  \n**関連:** [参加者リスト PDF](../../pdf/260623/定例会参加者リスト2026_06_23.pdf) · [参加者 CSV](../../pdf/260623/dragonfly_212_20260623_all_full.csv) · [BOR 部屋割り](../../pdf/260623/728162322_28119126191007384_3754338031899008407_n.png)\n\n---\n\n## 1. 定例会概要\n\n| 項目 | 内容 |\n|------|------|\n| **開催日** | 2026年6月23日（火） |\n| **参加者** | Zoom 要約値: 合計 **65名**（メンバー48・ビジター12・代理2・ゲスト3） |\n| **CSV登録** | メンバー54名（リージョン含む）・ビジター13名・代理2名・ゲスト3名 |\n| **リファーラル** | **160件**（内部31・外部129） |\n| **メインプレゼン** | 船津麻理子（眼の整体院） / 次廣淳（AI業務改善システム構築） |\n| **メンバー更新** | 岡元智美（勝てるプレゼン資料作成）3年目更新承認 |\n| **シェアストーリー** | 清原佳彩美（サロン向け育毛機器・商材販売） |\n\n本日は第212回 DragonFly 定例会として開催された。メインプレゼンテーションは、船津麻理子さん（眼の整体院）と次廣淳（AI業務改善システム構築）の2名が担当。今週のリファーラルは160件（内部31・外部129）で、チャプターの累計サンキュー金額は約11億円超として報告された。\n\n岡元智美さんの3年目更新が承認され、清原佳彩美さんのシェアストーリーでは、BNIで得た最大の財産は売上やリファーラルだけではなく「人とのつながり」であることが共有された。\n\n---\n\n## 2. 役員・運営担当\n\n| 役割 | 氏名 | カテゴリー |\n|------|------|------------|\n| **プレジデント** | 平山真由美 | シングルマザー専門事業コンシェルジュ |\n| **バイスプレジデント** | 芳賀崇利 | 地域情報サイト運営 |\n| **書記兼会計** | 岡元智美 | 勝てるプレゼン資料作成 |\n| **エデュケーションコーディネーター** | 竹内駿太 | アスリート専門生命保険 |\n| **ビジターホストコーディネーター** | 横山尚武 | 事業のオンライン展開サポート |\n\n---\n\n## 3. ビジター・ゲスト・代理出席\n\n### ゲスト\n\n| 氏名 | 事業・カテゴリー | 紹介者 |\n|------|------------------|--------|\n| **伊藤裕一郎** | 税理士 | 次廣淳 |\n| **中村さやか** | 子育てコーチング講師 | 平山真由美 |\n| **砂田浩史** | 補助金助成金で業績アップ | 平山真由美 |\n\n### 代理出席\n\n| 氏名 | 代理元 | 事業・カテゴリー |\n|------|--------|------------------|\n| **林希世視** | 八田奈緒美 | 骨盤底筋導入サポート |\n| **實島賢** | 太田一誠 | 動画制作全般 |\n\n### ビジター（CSV登録）\n\n| No | 氏名 | 事業・カテゴリー | 紹介者 |\n|----|------|------------------|--------|\n| V01 | 千田麻美 | やまと式かずたま術鑑定士 | 船津麻理子 |\n| V02 | 朽木奈津美 | 集中力を高めるオーダー眼鏡事業 | 船津麻理子 |\n| V03 | 横山絢香 | 補正下着販売（営業） | 太田一誠 |\n| V04 | 中島大地 | 運気の不動産 | 木村杏那 |\n| V05 | 吉野光祐 | 美容サロン特化型インスタ広告代行 | 清原佳彩美 |\n| V06 | 吉田匠真 | SNS運用コンサル | 次廣淳 |\n| V07 | 山野佑一郎 | 通信機器販売 | 次廣淳 |\n| V08 | 渡仲大輔 | カクテルバー経営 | 次廣淳 |\n| V09 | 森田悦章 | 経営者の意思決定力を高めるAI活用コンサルティング | 舩杉牧子 |\n| V10 | 田村鈴夏 | 動画編集クリエイター | 小中貴晃 |\n| V11 | 八田玄治 | グラフィック＆WEBデザイナー | 今西俊明 |\n| V12 | 松元亜紀 | 目の整体屋 | 船津麻理子 |\n| V13 | 櫻井克洋 | Webサービスエキスパート | 米澤侑桂 |\n\n---\n\n## 4. BNI概要・コアバリュー\n\n平山真由美プレジデントより、ビジター・ゲスト向けに BNI の基本用語と DragonFly のビジョンが共有された。\n\n| 項目 | 内容 |\n|------|------|\n| **リファーラル** | メンバー間で交わされるビジネスの紹介 |\n| **チャプター** | BNI におけるグループ。本日は DragonFly チャプター |\n| **サンキュー金額** | リファーラルから発生したビジネスの売上金額 |\n| **基本理念** | Givers Gain（与えるものは与えられる） |\n| **世界規模** | 77か国、約11,800チャプター、約35万人が活動中 |\n| **DragonFly ビジョン** | Dragonfly\'s Flight 〜流れを世界の果てまで〜 |\n| **今期スローガン** | 百華繚凛 |\n\n---\n\n## 5. ブレイクアウトルーム（BOR）\n\n出典: [BOR 部屋割り画像](../../pdf/260623/728162322_28119126191007384_3754338031899008407_n.png)\n\n| 部屋 | ビジター | 主なメンバー / オリエン | 備考 |\n|------|----------|--------------------------|------|\n| 1 | V01 千田麻美 / V08 渡仲大輔 | 海沼・飯田千帆・福士・望月 | V01 は海沼担当、V08 はビジター移動対象 |\n| 2 | V02 朽木奈津美 / V09 森田悦章 | 船津・軍司・加藤・久米 | V02 は船津担当 |\n| 3 | V10 田村鈴夏 | 西浦・飯田香・森園 | V10 はビジター移動対象 |\n| 4 | V04 中島大地 | 平岡・木村杏那・長谷川・佐久間 | V04 は平岡担当 |\n| 5 | V09 森田悦章 / V05 吉野光祐 / V13 櫻井克洋 | 清原・福上・大竹・横山尚武 | V09 / V05 / V13 は移動対象 |\n| 6 | V06 吉田匠真 | 越賀・芳賀・次廣 | 次廣が吉田さんのフォロー対象 |\n| 7 | V07 山野佑一郎 | 今村・梅澤・松倉 | V07 は今村担当 |\n| 8 | V08 渡仲大輔 | 原田・廣田・畠山・山本葉子 | V08 は移動対象 |\n| 9 | V09 森田悦章 | 舩杉・竹内・木村健悟 | V09 は移動対象 |\n| 10 | V10 田村鈴夏 | 小中・増本・山口 | V10 は移動対象 |\n| 11 | V11 八田玄治 | 岡元・今西・山本洸太・里見 | V11 は岡元担当 |\n| 12 | V12 松元亜紀 | 紀川・藤井・佐藤・田渕 | V12 は紀川担当 |\n| 13 | V13 櫻井克洋 / V07 山野佑一郎 | 中村・渡邊・横山尚武・米澤 | V13 / V07 は移動対象 |\n\nオープンブレイクアウト2回目は、ビジターを指定の部屋へ移動する運用。ファシリはビジターの事業可能性を引き出し、書記は Nキャスの「ビジター参加者リスト」から該当者の欄へメモを入力する。\n\n---\n\n## 6. ネットワーキング学習コーナー\n\n**担当:** 竹内駿太（エデュケーションコーディネーター）  \n**テーマ:** 野球の「送りバント」と Givers Gain\n\n| 観点 | 内容 |\n|------|------|\n| **送りバントの精神** | バッターが自らアウトになることを承知でランナーを進めるプレイ。強いチームほど確実に決める |\n| **BNIへの応用** | 自分の売上に直結しない行動（ワントゥーワンの時間確保、相手のビジネス理解など）が長期的な信頼資産を生む |\n| **論理的投資** | 自分が1回アウトになることで、将来74回のチャンスが回ってくる仕組みとして説明 |\n| **75人体制** | 75人になると紹介ルートは2,775ラインとなり、約2.2倍に拡大 |\n| **今週の宿題** | メンバーの誰か1人のために、自分の利益にはならないが相手のビジネスが前進する「送りバント」を1つ実行する |\n\n自分の売上にすぐつながらない行動を、損ではなく「チーム全体の得点確率を上げる投資」と捉える学びとして共有された。\n\n---\n\n## 7. メンバー更新式\n\n| 項目 | 内容 |\n|------|------|\n| **更新者** | 岡元智美 |\n| **カテゴリー** | 勝てるプレゼン資料作成 |\n| **更新年数** | BNI 3年目 |\n\n岡元さんは、2年前に掲げた「専属契約の獲得」という目標を、メンバーからのリファーラルによって複数社との契約として実現できたと報告。3年目は、いただいたご縁をクライアントの結果に変えることに全力を注ぎ、リファーラルマーケティングをさらに活用・貢献していくと表明した。\n\n---\n\n## 8. ウィークリープレゼンテーション\n\n### 建設・不動産\n\n| 氏名 | カテゴリー | 要点 |\n|------|------------|------|\n| 平岡国彦 | 大型物件対応解体工事 | 30年の経験を持ち、大型物件解体の相談を受付。建設業特化ビジネスコミュニティも運営 |\n| 増本重孝 | 虫が建物に近寄らない害虫ブロック | 人畜無害の液体を吹きかけるだけで虫が近寄らない製品。塗装業・リフォーム業・外構業の施工店を全国募集 |\n| 長谷川貴志 | 空き家問題を解決する不動産屋 | 空き家・空き地の活用・管理・処分に対応。相続案件を多く抱える弁護士・司法書士を紹介希望 |\n| 福士利明 | コンクリート内部防水テクノロジー | CTP2000 がコンクリート内部に浸透し劣化を抑える。橋梁・建物・食品工場の床面長寿命化に貢献 |\n| 松倉健治 | エアロゲル透明断熱フィルム | 無色透明フィルムで年間20%以上の省エネ。室内でペットを飼い年中エアコンを使う建設業社長を紹介希望 |\n| 福上大輝 | 自宅で開業にちょうどいい小屋 | 全国対応できる建築資材販売会社を探している |\n\n### 中小企業サポート・IT・コンサル\n\n| 氏名 | カテゴリー | 要点 |\n|------|------------|------|\n| 中村啓吾 | 日本製ものづくり再興事業プロデューサー | 7月3〜4日に有楽町東京交通会館で「日本製の覚悟展」B2C販売会を開催。16社参加予定 |\n| 倉持賢一 | 中国向け物販支援 | 中国14億人市場への進出を支援。TikTokライブコマースで初月1億円の売上実績。製造業・メーカー社長を紹介希望 |\n| 岡元智美 | 勝てるプレゼン資料作成 | AI導入企業からの商談が増加。AI資料と人が作る資料の両方の価値が求められている |\n| 横山尚武 | 事業のオンライン展開サポート | 講師業・コンサル・サロン・店舗ビジネス向けにオンライン講座・AI業務効率化の収益化を支援 |\n| 佐藤拓斗 | 建設業向け高校生新卒採用コンサル | 学校との関係構築から施策制作まで対応。従業員50名以下の工務店社長を紹介希望 |\n| 原田里織 | デジタルサイネージ | 中国深圳直結メーカーとして全国の看板屋と協業 |\n| 森園友喜 | AI×事務代行 | 建設・医療業界特化。5時間20,000円から利用可能。事業者数10名以下で事務員が足りない企業を紹介希望 |\n| 木村杏那 | 建設業の業務改善パートナー | Googleで現場・事務の仕組みを構築。3日かかっていた事務作業を5分で完結した実績 |\n| 望月雅幸 | 社労士 | 最低賃金引き上げに対し、業務改善助成金の活用を推奨。無料診断も実施 |\n| 佐久間康丞 | 建設業専門行政書士 | 都内の税理士・社労士・司法書士を紹介希望 |\n| 小中貴晃 | 使って学ぶAIツール情報発信 | 月1,000円でほぼ毎日AI最新情報を発信。従業員5名以上のWeb制作会社を紹介希望 |\n| 軍司敦哉 | LINE公式アカウント運用代行 | LINE構築運用がAI導入補助金対象に。最大2年分の構築・運用ツール代込みで3分の2補助可能。今年度締切は8月25日 |\n| 次廣淳 | AI業務改善システム構築 | 建築業・製造業で Excel 手作業の見積・現場・請求管理を、一度の入力で回る仕組みに変換。担当者しか分からない状態を解消 |\n| 米澤侑桂 | 反応率にこだわるWEBデザイン | 人間心理に基づいた構成・デザインでLP・サイトの反応率を向上 |\n\n### ライフサポート・健康・ファッション\n\n| 氏名 | カテゴリー | 要点 |\n|------|------------|------|\n| 平山真由美 | シングルマザー専門事業コンシェルジュ | 新ママメンバー全国400名。大阪のシングルマザーでスクール事業をしている方を紹介希望 |\n| 舩杉牧子 | 結婚相談所 | フラワーフォトセラピーを活用した結婚・人生丸ごとサポート。全国で活動する結婚相談所業者を紹介希望 |\n| 大竹絵理香 | 家族も使える福利厚生 | 中小企業・個人でも利用できる大企業向け福利厚生サービスを提供 |\n| 今村千絵 | 身体と心を整えるダイエットコーチング | 無料で体の測定キットを送り分析する「100人チャレンジ」を実施中 |\n| 清原佳彩美 | サロン向け育毛機器・商材販売 | N2プラス（針を刺さない育毛ケア）。男性が多く来る美容室オーナーを紹介希望 |\n| 船津麻理子 | 眼の整体院 | 本日メインプレゼン担当。予防眼科の普及を目指す |\n| 飯田千帆 | 経営者向け開運占い師 | ご祈祷提案後、わずか2週間で2,300万円の売上達成事例あり |\n| 飯田香 | 30代からのスタイルアドバイザー | 生活習慣を変えずに、着るもの・睡眠・水を変えることで健康と体形改善を支援。エステサロンへの物販売上アップにも貢献 |\n| 久米加代子 | 温活機器導入サポート | スタッフの健康を守りたい社長に温活機器を紹介 |\n| 木村健悟 | Tシャツプリント | 全て自社工場でプリント。小ロット・デザイン相談可能 |\n| 藤井恵理子 | 播州織の日傘製造 | 日本で数人しかいない傘職人と連携。国内外に販路拡大中 |\n\n---\n\n## 9. メインプレゼンテーション\n\n### 船津麻理子 — 眼の整体院\n\n| 観点 | 内容 |\n|------|------|\n| **問題提起** | 日本人の約74%（4人に3人）がメガネ・コンタクトに依存。視力低下は目からの SOS であり、放置すると病気や失明リスクにもつながると説明 |\n| **目と脳の関係** | 目は脳から飛び出たセンサー。目の機能低下は脳機能低下・認知症・物忘れの加速につながる可能性がある |\n| **サービス内容** | 施術者の手から直接低周波を流す特殊施術と、ホームケアトレーニングを組み合わせ、目のケアを習慣化まで導く |\n| **状態づくり** | 副交感神経優位の状態を作り、強制的に休息状態へ導く |\n| **実績** | 船津さん自身もコンタクト依存から、視力0.2→1.0に改善した経験を共有 |\n| **次の展開** | 8月を目標に静岡県に2店舗目をオープン予定。静岡県民へのPR協力を依頼 |\n\n### 次廣淳 — AI業務改善システム構築\n\n| 観点 | 内容 |\n|------|------|\n| **自己紹介** | 1973年5月27日生まれ、静岡県藤枝市在住。文系（フランス語学科）出身のSEで26年目。大学中退後、東京のシステム会社に入社し、30歳で独立 |\n| **強み** | 「一を聞いて十を整理する」感覚で、言葉になっていない困りごとを汲み取り、専門用語に逃げず現場の言葉へ置き換える |\n| **課題の本質** | 売上・案件が増えるほど、注文・顧客・作業管理がバラバラのまま現場が苦しくなる。人を増やして耐えるのではなく、人を増やさずに伸ばせる流れに変えることが使命 |\n| **具体事例** | 増本さんの害虫ブロック事業で、取扱店200社超→500社を目指す際、事務員1名追加（月25万円・年間300万円・5年で1,500万円の固定費）の代わりに、約150万円前後のシステム導入で1年以内に回収可能と整理 |\n| **効果** | 確認の手間が体感で大幅に削減。担当者しか分からない状態を、誰でも確認できる流れへ変更 |\n| **紹介希望先1** | Excel が限界、同じ内容を何度も入力している、あの人がいないと分からないという経営者・責任者 |\n| **紹介希望先2** | そうした会社を顧問先で見ている税務コンサル・士業・支援者 |\n\n---\n\n## 10. 5月度 統計報告\n\n**報告:** 芳賀崇利バイスプレジデント（Zoom 要約）\n\n| 指標 | 今月 | 累計 |\n|------|------|------|\n| **リファーラル合計** | 338件 | 27,190件 |\n| **内部リファーラル** | 66件 | 5,865件 |\n| **外部リファーラル** | 272件（要約では398件だが合計338件と不整合のため既存議事録に合わせて補正） | 21,335件 |\n| **ビジター総数** | 23名 | 1,475名 |\n| **ワントゥーワン回数** | 741回 | — |\n| **サンキュー金額** | 2,181万3千円 | 約11億円超（要約値に表記ゆれあり、要確認） |\n| **1定例会あたりサンキュー金額** | 約530万円 | — |\n\n累計サンキュー金額は約11億円を突破していることが共有された。Zoom 要約上は累計金額表記にゆれがあるため、正式値は Nキャスまたは統計資料で確認する。\n\n---\n\n## 11. 今週のリファーラル発表\n\n| 項目 | 数値 |\n|------|------|\n| **リファーラル合計** | **160件** |\n| **内部リファーラル** | 31件 |\n| **外部リファーラル** | 129件 |\n\n### リファラルケース ベスト3\n\n| 順位 | 氏名 | 件数 |\n|------|------|------|\n| **1位** | 佐藤拓斗（建設業向け高校生新卒採用コンサル） | 11件 |\n| **2位** | 増本重孝（害虫ブロック） | 9件 |\n| **3位** | 平岡国彦（大型物件対応解体工事） | 7件 |\n\n### 代表的なリファーラル事例\n\n| 紹介元 | 紹介先 | 内容 |\n|--------|--------|------|\n| 平岡国彦 | 福上大輝 | 年間150棟を新築している会社の会長を紹介 |\n| 増本重孝 | 西浦雅 | 外構業の小島社長を紹介 |\n| 中村啓吾 | 渡邊真大 | 売上規模30億円程度の着物関連企業のCTOを紹介 |\n| 軍司敦哉 | 佐藤拓斗 | Googleマップ口コミ削除業者を紹介 |\n| 船津麻理子 | 次廣淳 | 税理士の藤本さんを紹介 |\n| 今村千絵 | 久米加代子 | 久米さんの商材をサロン客に体験提供 |\n\n---\n\n## 12. リファーラル新制度確認\n\n| 項目 | 内容 |\n|------|------|\n| **確認対象** | 海沼功（企業型確定拠出年金導入サポート）→ 飯田千帆（経営者向け開運占い師） |\n| **紹介内容** | 海沼さんが主催する金融リテラシー・ライフランセミナーの受講生 |\n| **進捗** | リピーターとして定期利用中 |\n| **サンキュー金額** | 60分22,000円の鑑定を3回利用。合計66,000円 |\n\n新制度における外部リファーラルとして、実際の利用・継続・サンキュー金額が確認された。\n\n---\n\n## 13. シェアストーリー\n\n**登壇者:** 清原佳彩美（サロン向け育毛機器・商材販売）\n\n| 観点 | 内容 |\n|------|------|\n| **入会理由** | 「ノリと勢い」でビジター参加当日に入会手続きをした |\n| **入会前** | ほぼサロンの横のつながりのみで、人脈が限られ視野が狭かった |\n| **入会後1年の変化** | 多数の経営者とのつながりが生まれ、BNIをきっかけに新しいビジネスもスタート |\n| **転機** | プライベートも仕事も限界で辞めようと思った際、メンバーから「みんなが清原さんを助ける番です」と電話をもらい、涙が止まらなかった |\n| **現在** | BNIに向き合うと決めてからビジネスが加速中。「BNIで得た一番の財産は売上でもリファーラルでもなく人とのつながり」と共有 |\n\n---\n\n## 14. 推薦の言葉\n\n| 項目 | 内容 |\n|------|------|\n| **推薦者** | 横山尚武（事業のオンライン展開サポート） |\n| **対象** | 小中貴晃（使って学ぶAIツール情報発信） |\n| **内容** | 横山さんが BNI 入会前からやりたかった事業を小中さんに相談したところ、二つ返事で「やりましょう」と即答。スピード感を持って対応し、30人近い参加者を集める企画が実現した |\n| **小中コメント** | 「誰とやるかが大事」という軸で活動していることを評価してもらえたことが嬉しい。今後も一緒に事業活動を続けたい |\n\n---\n\n## 15. ビジタープレゼンテーション\n\n| 氏名 | 事業・カテゴリー | 要点 |\n|------|------------------|------|\n| 千田麻美 | やまと式かずたま術鑑定士 | 生年月日・名前から個性や役割を読み解き、自分らしい生き方・働き方をサポート |\n| 朽木奈津美 | 集中力を高めるオーダー眼鏡事業 | 東京都新宿区で集中できるメガネを販売。フランチャイズ事業にも対応 |\n| 中島大地 | 運気の不動産 | 運気の上がる物件専門の賃貸仲介。引越し後に売上が倍になった、不登校の子が学校に行くようになった事例あり |\n| 吉野光祐 | 美容サロン特化型インスタ広告代行 | 美容室・エステ・ヘッドスパなど多様なサロンをサポート |\n| 田村鈴夏 | 動画編集クリエイター | 「判断疲れ」を解消する丸投げ型動画編集サービス。想いを翻訳してワクワクに変換 |\n| 八田玄治 | グラフィック＆WEBデザイナー | AIで作ったとすぐ分かる時代だからこそ、人の手による見やすく効果的な資料作成が強み |\n| 松元亜紀 | 目の整体屋 | 大阪で船津さんと同じ目の整体院を運営。視覚訓練士として不可能を可能にし続ける |\n| 櫻井克洋 | Webサービスエキスパート | 成果につながるHP制作・AI開発。AI活用勉強会も開催 |\n\n---\n\n## 16. 入会案内・費用\n\n| 項目 | 内容 |\n|------|------|\n| **登録費** | 50,000円（別途消費税） |\n| **プログラム利用料** | 190,000円 / 年（別途消費税） |\n| **割引** | 2年申込で80,000円割引、5年申込で150,000円割引 |\n| **毎月のチャプター費** | 5,000円 |\n| **審査** | メンバーシップ委員会による審査あり。承認後は同カテゴリーの競合はチャプターに入会不可 |\n\n---\n\n## 17. プレゼント抽選\n\n| 提供者 | 商品 | 当選者 |\n|--------|------|--------|\n| 船津麻理子 | パソコンに取り付ける MOFT 商品（目線を上げるためのスタンド） | 竹内駿太（26番） |\n| 次廣淳 | ストレートネック改善グッズ | 加藤隆太（39番） |\n\n加藤さんからは、AIとシステムで増本さんのところで成果が出ているので、飲食会社でも導入したいというコメントがあった。\n\n---\n\n## 18. 決定事項・アクションアイテム\n\n| 担当 | アクション | 期限 / 補足 |\n|------|------------|-------------|\n| **次廣** | ビジターの吉田匠真さんのオリエンテーション内容を Nキャスへ記入し、ステータスを「オリエン・短期追跡」として管理 | 早め |\n| **船津麻理子** | プレゼントの発送手配 | 早め |\n| **次廣** | プレゼントの発送手配 | 早め |\n| **軍司敦哉** | AI導入補助金の今年度締切（8月25日）に向け、興味のある方への連絡を促進 | 8月25日まで |\n| **船津麻理子** | 静岡2店舗目のオープン（8月目標）に向け、静岡県民への紹介依頼を継続 | 8月目標 |\n| **中村啓吾** | 7月3〜4日「日本製の覚悟展」販売会の参加企業を継続募集 | 7月3〜4日 |\n| **メンバー全員** | 今週中に「送りバント」（自分の利益にならないが相手のビジネスが前進する行動）を1つ実行 | 今週中 |\n\n---\n\n## 19. 未解決・保留事項\n\n| 項目 | 状態 |\n|------|------|\n| **小野田さんへの朝礼依頼** | 小野田さんがリージョンフォーラムに参加することになったため、朝礼担当者の調整が必要。Zoom 要約末尾が途切れているため、詳細は TODO |\n| **参加人数差分** | Zoom 要約値（65名）と CSV登録値（メンバー54・ビジター13・代理2・ゲスト3）に差分あり。実出席値は Zoom / Nキャスで要確認 |\n| **5月度統計の外部リファーラル・累計サンキュー金額** | Zoom 要約内に数値不整合・表記ゆれあり。正式値は Nキャスまたは統計資料で要確認 |\n\n---\n\n## 20. 次回以降の予定\n\n| 日付 | 内容 |\n|------|------|\n| **2026-07-03〜04** | 中村啓吾さん「日本製の覚悟展」販売会（有楽町東京交通会館） |\n| **2026-07-28** | BOD（ビジネスオープンデイ・定例会回数外） |\n| **2026-08-25** | AI導入補助金の今年度締切 |\n| **2026-08 目標** | 船津麻理子さん 眼の整体院 静岡2店舗目オープン |\n\n---\n\n## 21. 次廣視点の振り返りメモ\n\n### 本日の役割\n\n- メインプレゼン登壇（AI業務改善システム構築）\n- ビジター3名（吉田匠真さん、山野佑一郎さん、渡仲大輔さん）を紹介\n- プレゼント提供（ストレートネック改善グッズ）\n\n### フォロー対象\n\n| 候補 | 接点 / 次アクション |\n|------|---------------------|\n| **吉田匠真** | SNS運用コンサル。オリエン内容を Nキャスへ記入し「オリエン・短期追跡」で管理 |\n| **山野佑一郎** | 通信機器販売。IT / 通信 / 業務改善の接点を確認 |\n| **渡仲大輔** | カクテルバー経営。飲食業務改善・予約/顧客管理・AI活用の接点を確認 |\n| **伊藤裕一郎** | 税理士。次廣紹介ゲスト。税務コンサル経由の業務改善案件紹介可能性を確認 |\n| **船津麻理子** | メインプレ同日登壇。静岡2店舗目とシステム/紹介支援の接点を確認 |\n| **加藤隆太** | プレゼント当選時に飲食会社での導入意向コメント。飲食業務改善のヒアリング候補 |\n\n### 学び・活用\n\n- 教育「送りバント」は、今週の具体行動として、紹介や事業前進のために自分の短期利益にならない一手を実行する指針になる。\n- メインプレゼンでは、増本さんの害虫ブロック事業を事例に、事務員増員ではなく仕組み化で伸ばす話が伝わった。今後の1to1では「Excel限界」「二重入力」「あの人しか分からない」を紹介依頼のキーワードとして使う。\n- 税理士・コンサル・士業経由の紹介導線を強化する余地がある。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-23 12:46 | Zoom 文字起こし要約を校正・構造化し、第212回定例会議事録として新規作成。CSV/PDF/BOR画像へのリンクを追加 |','docs/meetings/chapter/chapter_weekly_20260623.md','chapter_weekly','2026-06-23','09:00-11:00','DragonFly 定例枠（火曜）。終了時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-23 12:46 JST）','{\"doc_type\":\"chapter_weekly\",\"chapter\":\"bni_dragonfly\",\"meeting_number\":212,\"session_date\":\"2026-06-23\",\"session_time_jst\":\"09:00-11:00\",\"session_time_note\":\"DragonFly \\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc\\uff09\\u3002\\u7d42\\u4e86\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-23 12:46 JST\\uff09\",\"related_files\":[\"..\\/..\\/pdf\\/260623\\/\\u5b9a\\u4f8b\\u4f1a\\u53c2\\u52a0\\u8005\\u30ea\\u30b9\\u30c82026_06_23.pdf\",\"..\\/..\\/pdf\\/260623\\/dragonfly_212_20260623_all_full.csv\",\"..\\/..\\/pdf\\/260623\\/728162322_28119126191007384_3754338031899008407_n.png\"]}','2026-06-23 19:16:28','2026-06-23 19:16:28','2026-06-23 19:16:28'),
(10,19,'# スリーバイス チームMTG — 2026-05-19\n\n**日時:** 2026-05-19（火）JST **08:00–08:45**（定例枠・終了時刻は録画メタで要確認）  \n**形式:** Zoom  \n**主な内容:** 小中氏による AI 活用最新動向・Claude Code 実践共有、BOD ビジター選抜の依頼、パワーチーム連携の議論  \n**関連:** [Dragonfly_team_1toMany_Tsugihiro_202604.md](../Dragonfly_team_1toMany_Tsugihiro_202604.md)（チーム前提・メンバー構成）\n\n---\n\n## サマリー\n\n小中氏がチームメンバーに対して **AI 活用の最新動向** と **Claude Code の実践的な使い方** を共有した。BNI 業務の自動化事例（定例会スライド生成等）や、各メンバーの専門性と AI を組み合わせた **パワーチーム連携の可能性** について議論した。\n\n**BOD（ビジネスオープンデー）** に向け、各チームは **40人リストから経営者・決済権者を4名** 選抜する依頼があった。**期限は 2026-06-16 まで**（モメンタム期間）。\n\n次廣氏から **社内ドキュメント管理・情報資産活用** の相談があり、**ローカル LM** を活用したセキュアな AI モデル構築について、小中氏と **1to1 で今後議論** することになった。\n\n---\n\n## 決定事項\n\n| 項目 | 内容 |\n|------|------|\n| **BOD ビジター選抜** | 各チーム **4名** を目標。40人リストから **経営者・決済権者のみ** を選抜 |\n| **選抜期限** | **2026-05末〜2026-06-16**（モメンタム期間） |\n| **招待ルール** | 経営者・決済権者に限定。**DragonFly チャプターへの入会意欲** がある人を優先 |\n| **次回 MTG** | **来週:** 芳賀氏が通常の四手目形式でプレゼン |\n| **次々回以降** | 横山氏作成中の **SaaS 型システム** を題材に、パワーチーム形成に向けたブレストを実施予定 |\n\n---\n\n## 小中氏の自己紹介・経歴（共有内容）\n\n| 区分 | 内容 |\n|------|------|\n| **学歴** | 京都工芸繊維大学で情報工学を専攻。機械学習（AI）の研究に従事 |\n| **キャリア** | ガイアックスにエンジニアとして就職後、営業へキャリアチェンジ。新卒4年目で子会社取締役に就任 |\n| **現在** | 自社経営と株式会社ピポンのナンバーツーを兼任。AI 活用支援・情報発信・システム開発・医療系カルテ自動生成プロダクトを展開 |\n\n---\n\n## AI 活用の最新動向\n\n### Claude Code の実践事例\n\n- **BNI スライド自動生成:** CSV ファイルとテンプレートから定例会スライドを自動作成。手順書（スキル図）で作業手順を記憶させ、再現性を確保\n- **記憶機能の優位性:** Claude は一度教えた手順やデザインのトンマナを忘れず、優秀な新入社員のように学習・実行する\n\n### 動画・デザイン生成の自動化\n\n- **Higgsfield 活用:** ワンプロンプトで Meta 広告用動画を生成。Canva で文字起こし・テロップ追加まで自動化\n- **制作コスト削減:** 従来 5〜10 万円かかっていた広告動画が **1 時間以内** で制作可能に\n\n### エージェント化の進展\n\n- **外部ツール連携:** Claude が Canva、PayPal、HubSpot、DocuSign 等と連携し、人間の代わりにツール操作を実行\n- **業務管理の自動化:** 営業案件の状況確認、ステータス更新、契約書締結対応などを Claude に依頼可能\n\n---\n\n## パワーチーム連携の可能性\n\n小中氏は、各メンバーの専門性と AI を組み合わせることで独自の価値提供が可能と提案した。\n\n| メンバー | 連携イメージ |\n|----------|--------------|\n| **軍司氏** | LINE × AI（LINE ハーネスと Claude の連携でステップ配信自動化） |\n| **ナオム氏** | 業務 × AI（業務効率化の切り口） |\n| **コータ氏** | デザイン × AI |\n| **次廣氏** | FD 的アプローチでの課題解決 × AI |\n| **芳賀氏** | マーケティング × AI |\n\n---\n\n## セキュリティと AI 導入の課題\n\n### 企業導入における障壁\n\n次廣氏が指摘したセキュリティ懸念に対し、小中氏は以下の見解を示した。\n\n- **個人レベルの先行利用:** 個人が既に AI を使い始めており、企業のガード機能が追いついていない\n- **大企業の導入遅延:** 大企業ほどセキュリティ策定・アカウント予算・社員研修に時間がかかり、導入が遅れる傾向\n- **中小企業の優位性:** 小規模企業や個人レベルでは柔軟に活用可能\n\n### 推奨される導入ステップ\n\n- **ステップ2レベル:** 目的ごとにツールを使い分け（スライド作成＝Canva、リサーチ＝Gemini、ナレッジ化＝NotebookLM）\n- **セキュリティ研修:** 個人情報保護研修の重要性が増加。個人を特定できる情報の取り扱いルールを明確化\n- **ガイドライン策定:** 職種ごとに開放するツールを定め、何が入力可能かを明示\n\n---\n\n## AI と人間の役割分担\n\n### デザイナー・エンジニアの生き残り戦略\n\n山本氏の質問に対し、以下の議論が展開された。\n\n- **淘汰されないデザイン:** 構造化されていない独自性の高いデザイン（例：DragonFly のバーチャル背景）は AI では再現困難\n- **人間の優位性:** AI は「聞いてくれない」が、人間は能動的にヒアリングし、会話の主導権を持てる\n- **ディレクション能力:** 何を作るべきかを引き出し、構成を考える能力が差別化ポイント\n\n### 横山氏の実践事例\n\n- **LP 制作の内製化提案:** 外注 250,000 円 → Claude Code 活用で社内制作 + セキュリティチェック 100,000 円の提案で、**150,000 円** の案件獲得見込み\n- **地頭の重要性:** 外発的動機だけで動く人は AI に代替されやすいが、発想力のある人は淘汰されない\n\n### 次廣氏との連携提案\n\n次廣氏から **社内ドキュメント管理・情報資産活用** の相談があり、**ローカル LM** を活用したセキュアな AI モデル構築について、小中氏と **今後 1to1 で議論** することに。\n\n---\n\n## チーム運営に関する議論\n\n| 時期 | 内容 |\n|------|------|\n| **来週** | 芳賀氏が通常の四手目形式でプレゼン |\n| **再来週以降** | 横山氏が作成中の SaaS 型システムを題材に、パワーチーム形成に向けたブレストを実施予定 |\n| **課題** | パワーチーム形成の **構造化・再現性確保** は難易度が高い |\n\n---\n\n## アクションアイテム\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **全チームメンバー** | 40人リストを更新し、**BOD ビジター候補 4 名** を選抜 | **2026-06-16** まで |\n| **次廣氏・小中氏** | ローカル LM を活用した社内ドキュメント管理システムについて **1to1 で議論** | 日程調整 **TODO** |\n| **横山氏** | SaaS 型システムの提案資料を準備し、**次々回** のチーム MTG で共有 | 次々回 MTG まで |\n\n---\n\n## その他の話題\n\n- **小中氏のウェブマス負担:** 定例会スライド作成が直前まで未完成で、定例会中もスライド修正に追われていた\n- **外部委託の検討:** 定例会運営を外部委託する案も議論されたが、**1 回 500 円/人（月 2,000 円）** のコスト負担が課題\n- **プロンプト販売の実態:** 新しいプロンプトが出るたびに「樹液」として販売され、Brain で **月 600 万円** 稼ぐ事例も存在\n\n---\n\n## メモ（次廣・振り返り用）\n\n- BOD ビジター 4 名選抜は **6/16 期限**。40人リストの更新と経営者・決済権者・入会意欲のフィルタを忘れずに。\n- 小中氏との **ローカル LM / 社内ドキュメント管理** の 1to1 は、前田氏 1to1 や伊藤氏 1to1 で触れた論点と接続する。**1to1 ファイル新規 or 既存 gunji/kuramoto 系とは別系列** で整理を検討。\n- 横山氏の SaaS 型システムブレストは **パワーチーム形成の具体化** の次の一手。次々回までに自分側の貢献ポジション（業務裏側 × AI）を言語化しておく。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-05-19 08:53 | Zoom 文字起こし要約をもとに初版作成 |','docs/meetings/team/team_threebiz_20260519.md','team_meeting','2026-05-19','08:00-08:45','定例枠（火曜 8:00–8:45）に基づく。Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-05-19）','{\"doc_type\":\"team_meeting\",\"team_id\":\"threebiz\",\"team_name_ja\":\"\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-05-19\",\"session_time_jst\":\"08:00-08:45\",\"session_time_note\":\"\\u5b9a\\u4f8b\\u67a0\\uff08\\u706b\\u66dc 8:00\\u20138:45\\uff09\\u306b\\u57fa\\u3065\\u304f\\u3002Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"presenter_ja\":\"\\u5c0f\\u4e2d \\u8cb4\\u6643\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-05-19\\uff09\"}','2026-06-23 22:03:06','2026-06-23 22:03:06','2026-06-23 22:03:06'),
(11,20,'# スリーバイス チームMTG — 2026-06-02\n\n**日時:** 2026-06-02（火）JST **08:00–08:45**（定例会前・毎週火曜定例枠）  \n**形式:** Zoom  \n**主な内容:** **新メンバー 米澤 侑桂さん** のチーム加入。**自己紹介・ビジネス紹介** から開始予定  \n**関連:** [Dragonfly_team_1toMany_Tsugihiro_202604.md](../Dragonfly_team_1toMany_Tsugihiro_202604.md)（チーム前提）／[1to1_yonezawa_yuka_comechan_design.md](../1to1/1to1_yonezawa_yuka_comechan_design.md)（次廣×米澤 121・**2026-04-08 実施済み**）\n\n---\n\n## サマリー（予定）\n\n本日から **米澤 侑桂さん（Comechan Design）** がチーム **スリーバイス** に加わる。定例会（火曜）前の **8:00–8:45** 枠で、**米澤さんの自己紹介・ビジネス紹介** から始める予定。\n\n次廣とは **2026-04-08 JST 09:00–10:00** に **1to1 実施済み**（Religo `one_to_ones.id = 12`）。デザイン〜コーディング一貫・協業合意済みの文脈あり（詳細は下記「121からの共有ポイント」）。\n\n**MTG 後:** Zoom 文字起こし要約があれば **【本日の議事】** 節を追記する。\n\n---\n\n## 決定事項（事前）\n\n| 項目 | 内容 |\n|------|------|\n| **新メンバー加入** | **米澤 侑桂** さんが **2026-06-02 から** スリーバイスに参加 |\n| **本日のアジェンダ先頭** | 米澤さん **自己紹介 → ビジネス紹介** |\n| **121 実施状況** | 次廣×米澤：**2026-04-08 実施済み**（議事録あり） |\n\n---\n\n## アジェンダ（予定）\n\n| 時間（目安） | 内容 | 担当 |\n|:---:|:---|:---|\n| 0〜25分 | **自己紹介・ビジネス紹介** | **米澤 侑桂** |\n| 25〜40分 | チームメンバーからの質問・相互理解 | 全員 |\n| 40〜45分 | 次回以降のローテーション・ネクスト | 小中（リーダー） |\n\n※ 上記は事前想定。**実際の進行は【本日の議事】に追記。**\n\n---\n\n## 新メンバー：米澤 侑桂（Comechan Design）\n\n### 基本情報\n\n| 項目 | 内容 |\n|------|------|\n| **名前** | 米澤 侑桂（よねざわ ゆか） |\n| **屋号・組織** | **Comechan Design（こめちゃんデザイン）** |\n| **BNI カテゴリ（想定）** | Web デザイン〜コーディング・実装 |\n| **121（次廣）** | **2026-04-08 JST 09:00–10:00** 実施済み（[1to1 議事録](../1to1/1to1_yonezawa_yuka_comechan_design.md)） |\n| **BNI ステータス（1to1 時点）** | **ビジター**（オリエン 2026-04-07・太田氏）。**本日時点の会員ステータスは MTG 後に確認・更新** |\n\n### ビジネス概要（121・公開情報ベース）\n\n- **提供:** LP 制作、サイト制作、画像・バナー、印刷物デザイン。**デザインからコーディング・実装・ディレクションまで一貫**対応\n- **強み:** 「かっこいい・可愛い」だけでなく **反応率・成果** にフォーカスしたデザイン。Tailwind CSS、JS フレームワーク（React Native 含む）、レスポンシブ、アプリデザイン経験\n- **AI 活用:** Claude Code、ChatGPT、Gemini でコーディングの統一化・効率化\n- **稼働:** 業務委託先 2 社と継続契約（クラウドワークス経由・2 年以上）。Web 講師業務は卒業し **余裕が出ている**。**定常委託より個人案件で共創したい**意向\n- **参考:** [サービスの流れ・料金](https://comechan-design.com/flow-services-fees/)\n\n### スリーバイスでの位置づけ（仮説・MTG 後に確定）\n\n| 観点 | メモ |\n|------|------|\n| **チーム内ギャップ** | Web マーケ・Web 制作・LINE・AI・オンライン展開が揃う中、**デザイン×実装一貫**の強みを追加 |\n| **5/19 MTG との接続** | 小中氏が示した **「デザイン × AI」** 連携案（当時「コータ氏」枠）と親和性が高い |\n| **次廣との関係** | **案件パートナーとして協業合意済み**（下記）。チーム MTG では **BNI 内の紹介・パワーチーム** の文脈を分けて話す |\n\n---\n\n## 121 からの共有ポイント（次廣×米澤・2026-04-08）\n\n> 詳細 SSOT: [1to1_yonezawa_yuka_comechan_design.md](../1to1/1to1_yonezawa_yuka_comechan_design.md)\n\n### 協業合意（tugilo × 米澤）\n\n| 案件 | 内容 | 状態（1to1 時点） |\n|------|------|-------------------|\n| **① 学生向け求人サイトアプリ化** | 次廣：アプリ基盤・WebView・プッシュ通知／米澤：**フロントのデザイン・コーディング** | 合意済み。**Flutter / RN 選定は保留** |\n| **② 古紙回収 LINE リッチメニュー** | 法人用・個人用 **2 枚**。単価 **4,000〜5,000 円／枚** | 依頼決定。要件共有待ち |\n\n### チーム MTG で共有してよい範囲（目安）\n\n- **OK:** デザイン〜実装一貫、Tailwind／RN 経験、AI 活用、**「デザインは米澤さん、仕組みは次廣」** の分担型協業の存在\n- **慎重:** クライアント固有の金額・未公開案件の詳細。**紹介時は成果の型**（LP 短納期例・反応率重視）程度に留める\n\n### 次廣がチーム向けに一言つなげる例（任意）\n\n「米澤さんとは 4 月に 1to1 をして、**フロントのデザインと実装まで一気通貫**できる方だと確認しています。僕の **業務システム・AI 組み込み** と組むと、**見た目と裏側の仕組み** をセットで渡せるので、Web 系の紹介では特に相性がいいと思っています。」\n\n---\n\n## チーム構成（2026-06-02 更新）\n\n| メンバー | 領域（DragonFly） | 備考 |\n|----------|-------------------|------|\n| **小中 貴晃** | AI ツール情報発信・IT／**リーダー** | |\n| **芳賀** | 地域情報サイト運営・中小 | |\n| **山本 洸太** | デザインに強い WEB 制作・IT | |\n| **斎藤** | 売上を伸ばす Web マーケ・IT | |\n| **次廣 淳** | AI 業務改善システム構築・IT | 米澤さんと 121・協業済み |\n| **軍司** | LINE 公式運用代行・IT | |\n| **横山** | 事業のオンライン展開サポート・中小 | |\n| **米澤 侑桂** ★ | Web デザイン〜コーディング・実装 | **2026-06-02 加入** |\n\n---\n\n## 【本日の議事】\n\n**※ MTG 実施後に追記**\n\n### 米澤さん 自己紹介・ビジネス紹介\n\n- （Zoom 要約・メモ待ち）\n\n### 質疑・ディスカッション\n\n- （追記）\n\n### 決定事項（MTG 後）\n\n- （追記）\n\n---\n\n## アクションアイテム\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **米澤 侑桂** | 自己紹介・ビジネス紹介 | **本日 MTG** |\n| **次廣** | MTG 後、Zoom 要約があれば **【本日の議事】** を追記 | MTG 後 |\n| **全員** | BOD ビジター 4 名選抜（[5/19 MTG](team_threebiz_20260519.md) 決定・**6/16 まで**） | 継続 |\n\n---\n\n## メモ（次廣・振り返り用）\n\n- 121 済みなので **初対面感は薄い**。**チーム向けには「他メンバーへの紹介」** に焦点を当てる。\n- 5/19 の **芳賀氏プレゼン・横山氏 SaaS ブレスト** の予定以降、ローテーション状況は **本日 MTG で確認**。\n- 米澤さんの **BNI 会員化の進捗**（ビジター→メンバー等）が分かれば 1to1 ファイル・本議事録を更新。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-02 07:56 | 本日 MTG 予定・新メンバー米澤さん加入・121 議事録要約を反映して初版作成 |','docs/meetings/team/team_threebiz_20260602.md','team_meeting','2026-06-02','08:00-08:45',NULL,'zoom','事前共有（2026-06-02 JST）。MTG 後に Zoom 要約で追記予定。','{\"doc_type\":\"team_meeting\",\"team_id\":\"threebiz\",\"team_name_ja\":\"\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-06-02\",\"session_time_jst\":\"08:00-08:45\",\"format\":\"zoom\",\"presenter_ja\":\"\\u7c73\\u6fa4 \\u4f91\\u6842\\uff08\\u65b0\\u30e1\\u30f3\\u30d0\\u30fc\\u30fb\\u81ea\\u5df1\\u7d39\\u4ecb\\uff09\",\"source\":\"\\u4e8b\\u524d\\u5171\\u6709\\uff082026-06-02 JST\\uff09\\u3002MTG \\u5f8c\\u306b Zoom \\u8981\\u7d04\\u3067\\u8ffd\\u8a18\\u4e88\\u5b9a\\u3002\",\"new_member_ja\":\"\\u7c73\\u6fa4 \\u4f91\\u6842\",\"related_1to1\":\"meetings\\/1to1\\/1to1_yonezawa_yuka_comechan_design.md\",\"related_1to1_record_id\":12}','2026-06-23 22:03:06','2026-06-23 22:03:06','2026-06-23 22:03:06'),
(12,21,'# スリーバイス チームMTG — 2026-06-09\n\n**日時:** 2026-06-09（火）JST **08:00–08:45**（定例会前・毎週火曜定例枠）  \n**形式:** Zoom  \n**主な内容:** **7月28日 BOD** に向けた **40人リスト** の戦略的活用、チーム目標 **3〜4名** のビジター招待計画、入会率 **10%** コンセプト、メンバー別リストレビュー、推薦の言葉キャンペーン、大名イベント優勝特典の共有  \n**関連:** [Dragonfly_team_1toMany_Tsugihiro_202604.md](../Dragonfly_team_1toMany_Tsugihiro_202604.md)（チーム前提）／[定例会 第211回（同日）](../chapter/chapter_weekly_20260609.md)／[前回 MTG 2026-05-19](team_threebiz_20260519.md)／[前回 MTG 2026-06-02](team_threebiz_20260602.md)\n\n---\n\n## サマリー\n\nスリーバイスチームは **2026-07-28（月）のビジネスオープンデイ（BOD）** に向け、**40人リスト（応援したい人リスト）** を活用した戦略的なビジター招待計画を策定した。チーム目標は **ビジター 3〜4名**（メンバー2人に1人の割合）で、前期 BOD の入会率 **2%** から **10%** への向上を目指すコンセプトで動く。\n\n次廣は入会確度の高い **石原氏** を BOD に招待予定で、チーム目標の **約半分** を単独で達成できる見込みがある。来週は **モメンタムトレーニング**（定例会9回目扱い）が実施され、次廣・横山・軍司の3名は初参加となる。\n\nミーティング冒頭では大名イベントの思い出話で盛り上がり、終了時は全員で写真撮影。米澤は初参加で、小中が40人リストの趣旨や BOD の目的を丁寧に説明した。\n\n---\n\n## 決定事項\n\n| 項目 | 内容 |\n|------|------|\n| **BOD ビジター目標** | スリーバイスチームから **3〜4名** を招待（メンバー2人に1人の割合） |\n| **入会率重視** | 前期の入会率 **2%** から **10%** への向上を目指す。**角度の高い事業オーナー** を優先的に招待 |\n| **推薦の言葉キャンペーン** | メンバーは積極的に推薦の言葉を書き、定例会での発表機会を増やす |\n| **大名イベント優勝特典** | 優勝で獲得した **3,000円分** のチャプター内商品購買権クーポンは **第10期中に使用**（期限付き・未使用は失効） |\n| **チャプターサイズ目標** | **75名** を目指し、**メンバー1人が1人の紹介者** になる取り組みを継続 |\n\n---\n\n## BOD 戦略と準備状況\n\n### 40人リストの活用法\n\n40人リスト（応援したい人リスト）は、BNI の BOD イベントに向けた **戦略的なビジター招待ツール** として活用する。小中は、このリストを使って「この人、うちのチームに欲しくない？」「パワーチームが組めるんじゃない？」といった視点でメンバー間の議論を促進した。\n\nリストには各人の **事業内容** を記載し、**リファラルの機会創出** と **入会候補者の特定** に使用する。\n\n### 入会率向上のコンセプト\n\n前期の BOD では **ビジター50名・入会1名（入会率2%）** という結果だったため、今期は **入会率10%** を目指す戦略に転換した。具体的には、次のような人物を優先的に招待する。\n\n- **角度の高い人**（入会見込みが高い）\n- **興味を持ってくれそうな人**\n- **自分で意思決定ができる事業オーナー**\n\n小中は「定例会よりも BOD の方が BNI のメリットがダイレクトに伝わり、入会率が高く出る」と説明した。\n\n### BOD の位置づけ（補足）\n\nBOD は半期に一度開催される **「文化祭のようなイベント」** で、通常の定例会とは異なり、自分の事業を見つめ直す機会となる。ビジターにとっては「BNI がどうワークするか」が直接的にイメージしやすく、入会率が通常の定例会よりも高く出るイベントである。\n\n### モメンタムトレーニング\n\n| 項目 | 内容 |\n|------|------|\n| **実施時期** | **来週**（定例会の **9回目** 扱い） |\n| **内容** | BOD に向けたトレーニングコンテンツをディレクターが提供 |\n| **初参加** | **次廣・横山・軍司** の3名 |\n\n---\n\n## メンバー別 40人リストレビュー\n\n### 次廣\n\n最も確度の高い候補者を複数確保している。\n\n| 候補者 | 状況・評価 |\n|--------|------------|\n| **石原氏** | 既にビジターとして参加済み。BOD への参加意欲あり。性格的に DragonFly に合っていると評価。**12人と 1to1 実施中**で、入会確度はほぼ確定的 |\n| **石原氏のパートナー** | BOD 参加の可能性あり。子供食堂も運営。石原氏同様ボディービルダーで最近優勝した特徴的な人物。**2人以上** を招待できる見込み |\n| **伊藤氏** | 次廣と増本の **顧問税理士**。2月の BOD 参加経験あり。現在スタッフが1人退職して多忙なため、本人ではなく **スタッフの入会** も提案している |\n| **吉田拓磨氏** | 次廣がお世話になっている方の婿。**来週または再来週のメインプレゼン時** にビジターとして招待予定 |\n| **田中氏（バーテンダー）** | 元 BNI メンバー。**6月23日** にビジターとして参加予定。静岡で会員制の指紋認証バーを運営していた経歴 |\n| **村松氏** | 保険業とマヤ暦を扱う。PTA 役員時代の知人 |\n\n### 芳賀\n\nリストの大半が **山形の人脈** で、全国展開を目指す事業者が少ないという課題がある。\n\n| 候補者 | 状況・評価 |\n|--------|------------|\n| **宮島氏** | 現在入会を検討中 |\n| **16番・動画制作者** | 大阪で同じチャプターだったメンバー。**本日の定例会** にゲスト参加予定。動画制作カテゴリーは DragonFly に不在のため、入会すると多くのメンバーにメリット |\n| **大阪の元チャプターメンバー** | リストの約 **1割** |\n| **農家の知人** | 複数いるが、朝の時間確保が難しいため **営業担当者の参加** を検討 |\n| **藤原氏** | 次廣が神奈川の知人として認識している |\n| **秋田のカーボンクレジット事業者** | 元ウェブデザイナー。現在 **梅沢** とつながっている |\n| **中国貿易関係者** | **倉持** とつながっている。本日誕生日のため参加できなかった |\n\n### 軍司\n\nリストの半分以上が **ニーズマッチ** という別コミュニティのメンバー。\n\n| 候補者 | 状況・評価 |\n|--------|------------|\n| **当社氏** | 軍司が代理出席の際に同席した、地方に強いウェブマーケティング専門家。一緒に仕事もしている |\n| **太田氏** | インスタグラムだけで自宅お菓子屋を成功させ、コンサルも実施。**今月末の軍司メインプレ** に招待予定 |\n| **藤井氏** | Kindle 出版の専門家で認知獲得支援。**今月末の軍司メインプレ** に招待予定 |\n| **千葉氏** | ウイスキーを活用した建設業向けチームビルディングコンサルタント。元建設業経験者。建設関連メンバーが多い DragonFly では相性が良く、ゲスト招待の話が進行中 |\n| **リザスト構築の専門家** | 「宴」の40〜50代向けバージョンのようなシステムを扱う |\n| **LINE 会員証の専門家** | LINE ミニアプリで会員証を作成するサービスを提供 |\n\n**運営メモ:** 軍司の40人リストで下の名前が間違っており、修正したら最初のページがエラーになったというトラブルも共有された。\n\n### 山本\n\nリストは **「アクション待ち」** として、一度ビジターに招待した人が中心。JC の仲間や後輩が多い。店舗系事業者（鍼灸師、ウェディング等）が多く、静岡を主要販路とする人が含まれる。\n\n| 候補者 | 状況・評価 |\n|--------|------------|\n| **小柳氏** | 静岡でシステム開発。以前 BNI ビジターに招待して興味を示していたため、BOD にも声をかける予定 |\n| **一度来訪して「中」ステータスの人** | 再度ビジター招待を検討 |\n| **カメラマン** | 充電展募集カテゴリーだが、招待を検討している人物はアーティスト系で「異業種会が好きではない」と述べており、自分を持っているため適合性に疑問 |\n| **他チャプターの現役メンバー（移籍希望 2〜3名）** | BOD への招待は **規則上不可能**。小中は「裏技として一度退会してダマで来る」方法を冗談交じりに提案したが、**通常の定例会にゲスト参加** してもらう方が安全だと結論 |\n\n### 横山\n\n補助金関係の仕事で一緒に事業を行っている人が多い。**全体的に BNI 入会角度は低い** と横山自身が評価している。\n\n| 候補者 | 状況・評価 |\n|--------|------------|\n| **堀口氏** | ウェブ関係で道の駅など行政絡みの事業を全国展開。「今まで散々振り回されてきたので今度は振り回したい」という動機で招待を検討 |\n| **清水氏** | IT 導入補助金関係で申請数国内トップシェアの実績。補助金事業とのシナジーを探るため声をかける予定。エスコートではなく **T1** という会社の社長・副社長（社長は **土屋氏**）。横山の補助金申請にも関与している「死ぬほど豊楽に出している会社」と表現された |\n| **岩下氏** | デザイナーで「動く名刺」を開発。X（旧 Twitter）で名前を入れると相手のアドレスがこちらに届く電子名刺のようなサービスを匿名アカウントで展開。一度話して面白いと感じたため招待を検討 |\n\n横山は入会して間もないため、今後のプレゼンを通じてどのような形でシナジーが生まれるか確認したいと述べた。**7月の横山メインプレ** ではリストの人たちをゲストとして招待予定。\n\n### 小中\n\n27人しかリストアップしていないが、**質の高い候補者** を揃えている。\n\n| 区分 | 候補・状況 |\n|------|------------|\n| **顧問税理士** | 小中が最初に入っていたチャプターで一緒だった人物で、現在の会社の顧問税理士でもある。ぜひ入会してほしいが「今は時期じゃない」と断られ続けている |\n| **DragonFly 二品** | 人材紹介（警備・運送などブルーワーク系）、企業向け福利厚生、LMO 対策（流行りの）、ベンチャーキャピタル |\n| **外国人インフルエンサーマッチング** | 小中と仲が良く、山本にもつないでいる |\n| **その他** | 睡眠モニタリングデバイス（久保タマン氏）、資産形成のプロ（土肥氏）、警備会社社長2名、AI 系、研修、ホームページ制作、コミュニティ、現状回復など |\n\n**久保タマン氏:** 腰にベルトを巻いて寝ると、無呼吸や寝返りを精緻に集計できる睡眠改善デバイスを開発。  \n**土肥氏:** 「わしももうまるっと全部資産管理をこの人にお願いしている」と小中が述べ、興味ある人にはつなぐと提案。\n\n---\n\n## チャプター運営とビジビリティ向上\n\n### 推薦の言葉キャンペーン\n\n小中は「推薦の言葉を書きましょう」と何度も呼びかけており、定例会で発表できるネタのストックがないという課題を指摘した。**今週の定例会** では増本が次廣について書いた推薦の言葉を取り上げる予定。\n\n**推薦の言葉を書いてもらうコツ（小中提案）**\n\n- こちらから「推薦の言葉を書いてくれませんか」と **お願いする** テクニックが有効\n- 例：次廣が増本のシステムを作ったなら、本来は増本が次廣の貢献のために書くべきだが、次廣から「僕、もらったことないんで書いてもらっていいですか？」と依頼するのも有効\n- 推薦の言葉をもらえば定例会で即取り上げられ、**ビジビリティアップ** につながる\n- **「もらったら返さなあかん」** というギバーズゲインの原則も働くため、メンバー間の貢献を書いてもらうよう積極的に働きかけることが推奨される\n\n### 定例会参加者リストのメモ機能\n\n小中が定例会参加者リストの **メモ機能** を紹介した。\n\n| セクション | 用途 |\n|------------|------|\n| **ビフォーコミュニケーション** | 事前の接点メモ |\n| **オリエンテーション** | オリエン時のメモ |\n| **アフターコミュニケーション** | 会後のフォローメモ |\n\n即申し込みする人は少なく、様子を見て入会する人が多いため、飯田の例のように「終わってからバーバブル参加します」「1to1 で誰々とこんな話しました」といった情報をメモに残すことで追いかけがしやすくなる。人数が多いと誰がどこでどんな話をしたか分からなくなるため、**接点を持ったらメモに入れる** ことが推奨された。\n\n### 対面イベント優勝特典\n\n対面イベントでチームが優勝し、**1人あたり 3,000円分** の DragonFly 内商品購買権を獲得した。\n\n| 項目 | 内容 |\n|------|------|\n| **使い方** | 例：岡本に資料作成を50,000円で依頼した場合、3,000円を差し引いた47,000円を支払えばよく、3,000円は DragonFly が補助 |\n| **有効期限** | **第10期中限定**。期間内に使わなければ **失効** |\n| **優勝の決め手** | チームクイズで2位が3チーム並んだ中、アイス早食い選手権で **ナーム** が3位になり1ポイントを獲得。さらに松倉がずるをしていたことがビデオ判定で判明し失格となり、チームが繰り上がって優勝 |\n\n---\n\n## ツールとシステム\n\n### Genspark（ジェンスパーク）の活用\n\n次廣は Genspark を使ってスライドを作成しており、色の違いに気づけたと **米澤** に感謝を述べた。米澤は「Genspark であれだけわかりやすく、めっちゃ綺麗に」作れることに驚いた。\n\n次廣は、プロンプトを工夫して **現行資料用** と **スライド作成用** を別で用意すると、ほぼ手直しがゼロになるレベルに最近なったと説明した。昔は「ちょっといちいち手直ししなきゃいけない」状況だったが、今は「スッと出てくる」ようになった。\n\n---\n\n## アクションアイテム\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **全員** | 40人リストの充実と定期的な見直し。BOD 候補の角度を上げる | 継続 |\n| **全員** | 推薦の言葉の積極的な執筆と依頼 | 継続 |\n| **全員** | 定例会参加者リストへのメモ記入（ビフォー・オリエン・アフター） | 継続 |\n| **全員** | ビジターとの接点から BOD 招待への流れを構築 | **2026-07-28** BOD まで |\n| **次廣** | 石原氏（＋パートナー）を BOD に招待。吉田拓磨氏を MP 時にビジター招待。田中氏（6/23）フォロー | 各日程 |\n| **芳賀** | 宮島氏の入会検討フォロー。動画制作者（竹村）のゲスト参加後フォロー | 継続 |\n| **軍司** | 今月末 MP で太田氏・藤井氏を招待。千葉氏ゲスト招待を推進 | **6月末** |\n| **山本** | 小柳氏への BOD 声かけ。「中」ステータス候補の再招待検討 | 継続 |\n| **横山** | 7月 MP でリストの人をゲスト招待。堀口氏・清水氏・岩下氏への声かけ | **7月** |\n| **小中** | 推薦の言葉キャンペーンの継続呼びかけ。メモ機能の定着支援 | 継続 |\n| **次廣・横山・軍司** | モメンタムトレーニングに参加（初参加） | **来週** |\n| **全員** | 大名イベント優勝特典（3,000円クーポン）の第10期内使用 | 第10期終了前 |\n\n### スケジュール一覧\n\n| 日付 | 内容 |\n|------|------|\n| **来週** | モメンタムトレーニング（次廣・横山・軍司は初参加） |\n| **2026-06-23** | 田中氏（バーテンダー）がビジター参加／**次廣メインプレゼン** |\n| **今月末** | 軍司のメインプレゼン（太田氏・藤井氏を招待予定） |\n| **2026-07（MP 枠）** | 横山のメインプレゼン（リストの人たちをゲスト招待） |\n| **2026-07-28** | **ビジネスオープンデイ（BOD）** 開催 — **定例会回数外** |\n\n---\n\n## その他・チームの雰囲気\n\n- ミーティング冒頭で大名イベントの思い出話が盛り上がり、「ナームのカテゴリーは来週から早食い合いそう」というジョークも飛び出した\n- 米澤は今回が初参加。小中が40人リストの趣旨や BOD の目的を丁寧に説明する場面があった\n- 終了時に全員で写真撮影。芳賀に「笑顔が足りてない」と指摘する和やかな雰囲気で締めくくられた\n\n---\n\n## メモ（次廣・振り返り用）\n\n- **BOD 目標 3〜4名** のうち、石原氏（＋パートナー）で **約半分** を担える見込み。**12人 1to1 継続** と BOD 招待のタイミング調整が最優先\n- **6/23 MP** に吉田拓磨氏ビジター招待を検討。同日に田中氏（バーテンダー）もビジター参加予定で、MP 日のフォロー密度が高い\n- **推薦の言葉:** 増本さん分が今週定例会で発表予定。自分から「書いてもらっていいですか？」と依頼する小中式テクニックを実践する\n- **Genspark:** 米澤さんへの色のフィードバックが効いた。プロンプト分離で手直しほぼゼロ — MP スライド制作にそのまま活かせる\n- **モメンタムトレーニング** は来週初参加。BOD 向けコンテンツを事前に確認しておく\n- **大名クーポン 3,000円** は第10期内に使う（岡本さん資料作成等で活用検討）\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-09 14:22 | Zoom 文字起こし要約を校正し、BOD 戦略・メンバー別リスト・決定事項・アクションを反映して初版作成 |','docs/meetings/team/team_threebiz_20260609.md','team_meeting','2026-06-09','08:00-08:45','定例会前枠（火曜 8:00–8:45）。終了時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-09）','{\"doc_type\":\"team_meeting\",\"team_id\":\"threebiz\",\"team_name_ja\":\"\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-06-09\",\"session_time_jst\":\"08:00-08:45\",\"session_time_note\":\"\\u5b9a\\u4f8b\\u4f1a\\u524d\\u67a0\\uff08\\u706b\\u66dc 8:00\\u20138:45\\uff09\\u3002\\u7d42\\u4e86\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"presenter_ja\":\"\\u5c0f\\u4e2d \\u8cb4\\u6643\\uff0840\\u4eba\\u30ea\\u30b9\\u30c8\\u30fbBOD \\u6226\\u7565\\u306e\\u30d5\\u30a1\\u30b7\\u30ea\\uff09\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-09\\uff09\",\"related_chapter_weekly\":\"meetings\\/chapter\\/chapter_weekly_20260609.md\"}','2026-06-23 22:03:06','2026-06-23 22:03:06','2026-06-23 22:03:06'),
(13,22,'# スリーバイス チームMTG — 2026-06-16\n\n**日時:** 2026-06-16（火）JST **08:00–**（定例会前・**早期解散**）  \n**形式:** Zoom  \n**主な内容:** モメンタム週に伴う短縮運営、**カテゴリー設定** のガイドライン確認、**来週以降パーソナル軸** の相互理解セッション決定、横山氏カテゴリー変更の提出方針  \n**関連:** [Dragonfly_team_1toMany_Tsugihiro_202604.md](../Dragonfly_team_1toMany_Tsugihiro_202604.md)（チーム前提）／[モメンタムトレーニング（2026-06-16・定例会回数外）](../chapter/chapter_weekly_20260616.md)／[前回 MTG 2026-06-09](team_threebiz_20260609.md)\n\n---\n\n## サマリー\n\n本日は定例会 **9回目** の扱いで **モメンタム週** のため、チーム MTG は **短めに終了** した（定例会も休会扱い）。\n\n**カテゴリー設定** のガイドラインについて議論し、職種軸・ファンクション軸の表現原則を整理。最終的には **ディレクター（藤田氏・山崎氏など）の判断** に依存することを確認した。\n\n**来週以降** は仕事軸ではなく **パーソナル軸**（趣味、部活歴など）での相互理解セッションを実施する方針を決定。発表順序は前回と同じ **横山 → 次廣 → 軍司 → 小中 → 芳賀 → 米澤** とする。\n\n---\n\n## 決定事項\n\n| 項目 | 内容 |\n|------|------|\n| **来週からの進行方針** | 仕事軸ではなく **パーソナル軸**（趣味、部活歴など）での相互理解セッションを実施 |\n| **発表順序** | 前回と同じ順番：**横山 → 次廣 → 軍司 → 小中 → 芳賀 → 米澤** |\n| **横山氏のカテゴリー変更** | 現在の案で一度 **メンバーシップ承認** を得たうえで、**藤田氏** に提出する |\n\n---\n\n## カテゴリー設定に関する共通認識\n\n### 基本原則\n\n| 原則 | 内容 |\n|------|------|\n| **職種軸での表現** | 「使って学ぶ」などの **修飾語は不要**。「AI ツールの情報発信」「ウェブ制作」など **シンプルな職種表現** が望ましい |\n| **ファンクション軸** | 職種だけでなく、専門領域での **差別化** も可能（例：助成金に強い社労士、給与計算が得意な社労士） |\n| **最終判断** | **ディレクター**（藤田氏、山崎氏など）の好みに依存。**運営マニュアルには明記されていない** |\n\n### 具体例\n\n| 対象 | 内容 |\n|------|------|\n| **軍司氏** | 「**LINE 公式アカウント運用代行**」はカテゴリーとして成立。「顧客に寄り添う」「継続率」などの **修飾語を入れるとリスクが上がる** |\n| **小中氏** | カテゴリーは当時 **ねじ込みで通した** 経緯があり、**グレーゾーン** である |\n\n---\n\n## 確認待ち事項\n\n| 項目 | 状況 |\n|------|------|\n| **リーダーズスプレッドシート** | **6月9日** で更新が止まっている。先週の **LTST 定例会** で共有済みのため、**新規伝達事項なし** |\n| **横山氏のカテゴリー** | **藤田氏の判断待ち**。NG の場合は **明確な理由を添えて** 返答予定 |\n\n---\n\n## 今後の予定（パーソナル軸セッション）\n\n| 日付 | 発表者 | 備考 |\n|------|--------|------|\n| **2026-06-23（火）** | **横山** | パーソナル軸で発表。同日 **次廣メインプレゼン**（定例会） |\n| **2026-06-30（火）** | **次廣** | |\n| **2026-07-07（火）** | **軍司** | |\n| **2026-07-14（火）** | **小中** | |\n| **2026-07-21（火）** | **芳賀** | |\n| **2026-07-28（月）** | — | **BOD（ビジネスオープンデイ）** 開催 — **定例会回数外** |\n| **2026-08-04（火）** | **米澤** | 発表予定 |\n\n※ 7/28 は BOD のため定例会スケジュールと重なる可能性あり。公式カレンダーで要確認。\n\n---\n\n## その他の話題\n\n- **軍司氏** が6月に **28歳の誕生日** を迎えた\n- **山本氏** が **12時間** かけて絵を完成させた\n- **チーム写真** を実施（芳賀氏は **背景変更が必要** だった）\n\n---\n\n## アクションアイテム\n\n| 担当 | アクション | 期限 |\n|------|------------|------|\n| **横山** | パーソナル軸セッションの準備（趣味・部活歴など） | **2026-06-23** |\n| **横山** | カテゴリー変更案をメンバーシップ承認後、藤田氏へ提出 | 承認後 |\n| **次廣** | 6/30 パーソナル軸発表の準備 | **2026-06-30** |\n| **軍司・小中・芳賀・米澤** | 各自の発表週に向けたパーソナル軸準備 | 各日程 |\n| **全員** | BOD（7/28）向け40人リスト・ビジター招待の継続 | [前回 MTG](team_threebiz_20260609.md) 参照 |\n\n---\n\n## メモ（次廣・振り返り用）\n\n- **6/23** は横山さんパーソナル軸 **＋ 自分のメインプレ本番**。朝 MTG と定例会の両方で登壇要素あり\n- **6/30** に自分のパーソナル軸枠 — 趣味・部活歴など、仕事以外の接点を事前に整理しておく\n- カテゴリーは **修飾語を足すほどディレクター判断リスクが上がる** — 自分の「AI 業務改善システム構築」表現もシンプルさを意識\n- 横山さんカテゴリー変更は **メンバーシップ承認 → 藤田氏** の順。結果待ち\n- BOD 7/28 まであと約6週。石原氏ほか前回 MTG の候補フォローを並行\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-16 08:43 | Zoom 文字起こし要約を校正し、短縮 MTG・カテゴリー認識・パーソナル軸ローテ・横山カテゴリー提出方針を反映して初版作成 |','docs/meetings/team/team_threebiz_20260616.md','team_meeting','2026-06-16','08:00-08:45','定例会前枠。同日は定例会9回目扱いのモメンタム週のため早期解散。終了時刻は Zoom 録画メタで要確認。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-16）','{\"doc_type\":\"team_meeting\",\"team_id\":\"threebiz\",\"team_name_ja\":\"\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-06-16\",\"session_time_jst\":\"08:00-08:45\",\"session_time_note\":\"\\u5b9a\\u4f8b\\u4f1a\\u524d\\u67a0\\u3002\\u540c\\u65e5\\u306f\\u5b9a\\u4f8b\\u4f1a9\\u56de\\u76ee\\u6271\\u3044\\u306e\\u30e2\\u30e1\\u30f3\\u30bf\\u30e0\\u9031\\u306e\\u305f\\u3081\\u65e9\\u671f\\u89e3\\u6563\\u3002\\u7d42\\u4e86\\u6642\\u523b\\u306f Zoom \\u9332\\u753b\\u30e1\\u30bf\\u3067\\u8981\\u78ba\\u8a8d\\u3002\",\"format\":\"zoom\",\"presenter_ja\":\"\\u5c0f\\u4e2d \\u8cb4\\u6643\\uff08\\u9032\\u884c\\u30fb\\u30ab\\u30c6\\u30b4\\u30ea\\u30fc\\u8b70\\u8ad6\\u306e\\u30d5\\u30a1\\u30b7\\u30ea\\uff09\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-16\\uff09\",\"related_chapter_weekly\":\"meetings\\/chapter\\/chapter_weekly_20260616.md\"}','2026-06-23 22:03:06','2026-06-23 22:03:06','2026-06-23 22:03:06'),
(14,23,'# スリーバイス チームMTG — 2026-06-23\n\n**日時:** 2026-06-23（火）JST **08:00–08:45**（定例会前・毎週火曜枠）  \n**形式:** Zoom  \n**主な内容:** **横山尚武さんのパーソナル軸共有**。幼少期の海外経験、キャリア変遷、不動産営業・ベンチャー・Uber Eats 展開、現在の AI 教育事業、家族・価値観、BNI との親和性を共有  \n**関連:** [前回 MTG 2026-06-16](team_threebiz_20260616.md)／[定例会 第212回（同日）](../chapter/chapter_weekly_20260623.md)\n\n---\n\n## サマリー\n\n本日は前回決定した **パーソナル軸セッション** の初回として、横山尚武さんが約40分にわたり、幼少期から現在までの経歴・価値観・仕事観を共有した。\n\n横山さんは、神奈川県辻堂で生まれ、小学2年から卒業まで父親の駐在でバンコクに居住。海外生活で培われたチャレンジ精神と「結果を出す」意識が、現在の仕事観の土台になっていると自己分析した。\n\nキャリア面では、不動産営業、最年少支店長、売買部門、ベンチャー企業、Uber Eats のエリア拡大、飲食店向けマーケティング支援を経て、現在の AI 教育事業・ダッシュキャンプへ至った流れが共有された。プライベートでは既婚・二児の父であることも明かされ、参加者から驚きの反応があった。\n\n---\n\n## 決定事項・共有事項\n\n| 項目 | 内容 |\n|------|------|\n| **本日の主題** | 横山尚武さんのパーソナル軸共有 |\n| **共有の焦点** | 生い立ち、海外経験、キャリア、AI教育事業、価値観、家族、BNIとの親和性 |\n| **次回予定** | 2026-06-30 は **次廣** のパーソナル軸共有回 |\n| **横山さんの直近アクション** | 来週のパスポートプログラム・ワークショップを受講し、DragonFly 推奨コースのコンプリートを目指す |\n\n---\n\n## 人物背景・生い立ち\n\n### 幼少期・海外生活\n\n| 項目 | 内容 |\n|------|------|\n| **出身** | 神奈川県辻堂（湘南エリア）。小学1年生まで在住 |\n| **海外生活** | 小学2年から卒業まで、父親の駐在でバンコクへ移住 |\n| **生活環境** | 6LDK、プール、ビリヤード付きの邸宅に住み、本人いわく「富豪のような生活」を経験 |\n| **マインド形成** | 海外の人々との交流を通じ、チャレンジ精神や「結果を出さなければならない」という意識が幼少期に培われた |\n| **サッカー経験** | 小学6年時、バンコク代表として ISB（国際学校）のナショナルチームで世界大会に出場 |\n\n横山さんは、海外で先に情報を得て、それを日本人チームメイトへ共有する行動を幼少期から自然に行っていた。現在の「情報を先に仕入れ、噛み砕いて共有する」スタイルの原型として語られた。\n\n### 学生時代・家庭環境\n\n| 項目 | 内容 |\n|------|------|\n| **高校時代** | 普通科進学校に通学。父親の厳格な門限により行動が大きく制限された |\n| **大学時代** | 父親の厳しさへの反動もあり、無気力気味に過ごした。教員免許は取得したが、教員にはならなかった |\n| **バー勤務** | 芸能人も訪れるバーで勤務。EXILE メンバーとテキーラを飲むような経験もあり、芸能界就職を考えた時期もあった |\n| **方向転換** | 現在の奥さんとの出会いをきっかけに、生活と仕事の方向性が変わった |\n\n---\n\n## キャリア経歴\n\n### 不動産業（社会人スタート）\n\n| 項目 | 内容 |\n|------|------|\n| **入社経緯** | 現在の奥さんと出会い同棲を決め、物件探しで訪れた不動産会社に入社式3日前に滑り込み入社 |\n| **最年少支店長** | 2年目・23歳で最年少支店長に就任 |\n| **学び** | 支店長として個人数字がつかない立場に苛立ち、部下への厳しい接し方で1名を退職させてしまった経験から、「できる人・できない人がいる」現実を学んだ |\n| **売買部門へ異動** | 支店長を解かれ、売買部門へ異動 |\n| **自信回復の経験** | 5年間売れなかった中古物件を初回案内で売却し、営業としての自信を取り戻した |\n\n本人は、当時の未熟さを振り返りながら、人の成長速度や得意不得意に向き合う重要性を学んだと共有した。\n\n### ベンチャー企業・Uber Eats 展開\n\n| 項目 | 内容 |\n|------|------|\n| **転職後の環境** | 不動産を退職後、ベンチャー企業へ転職。さまざまなプロダクトを売る現場で、コンサルティング的なスキルを習得 |\n| **Uber Eats エリア拡大** | 約9ヶ月間、鹿児島・宮崎・熊本・北九州の一部エリアの店舗開拓を担当 |\n| **成果** | 宮崎エリアでは2ヶ月で200店舗まで拡大 |\n| **並行支援** | 飲食店向けに LINE・LP 活用などのマーケティング支援も実施 |\n| **危機的状況での学び** | 300万円のデポジットを消化できない状況の中で、「人を納得させる」「首を縦に振らせる」実践的なコンサルティング力を磨いた |\n| **役職経験** | 前職では25歳で事業部長に就任 |\n\n### 現在：AI教育事業\n\n| 項目 | 内容 |\n|------|------|\n| **メインプロダクト** | ダッシュキャンプ。BNI の中でも「とにかく大きくしたい」と強調 |\n| **SNS開始** | 3年前から自身の SNS を開始。フリーランスや法人設立初期の人に向けた「大人の学校」のようなコンセプトで発信 |\n| **教育への回帰** | 大学で教員免許を取得するほど「人に教えたい」欲求が強く、それが現在の AI 教育事業のルーツになっている |\n| **小中さんとの連携** | 価値提供の幅を広げ、スケールさせるために小中さんへ協力を依頼。他者と組む必要性を認識した結果 |\n\n---\n\n## 価値観・性格・思想\n\n### 強み・特徴\n\n| 観点 | 内容 |\n|------|------|\n| **現場主義** | 「めちゃくちゃ現場主義でやってきた」と自己評価。現場課題の可視化・言語化に強い自信がある |\n| **情報共有** | バンコク時代のサッカーでも、英語で得た情報を日本人チームメイトへ共有していた。先に情報を仕入れて下ろす行動が習慣化 |\n| **AI習熟** | 1日10時間以上 AI を触り、体感したことを噛み砕いて伝えるスタイル |\n| **他者へのコミット** | お金をもらう前に動いてしまうほど、人の役に立ちたい気持ちが強い |\n| **関係構築の速さ** | 1to1 後、翌々日には対面でお茶をする関係になるなど、仲良くなる速度が速い |\n\n横山さんは、BNI のリファラル文化と、自身の「他人にコミットメントする」姿勢が合っていると感じている。\n\n### 課題・弱点\n\n| 観点 | 内容 |\n|------|------|\n| **ストレートな物言い** | 気に入らないことをそのまま言ってしまい、敵を作りやすいと自覚。30歳になり、より柔らかく生きることを課題として認識 |\n| **プライベートの会話** | 仕事以外の会話を広げるのが苦手で、「仕事の話しかできない」と自己分析 |\n| **オンオフの差** | 仕事モードでは別人格のように動ける一方、プライベートでは店員も呼べないほど静かになる |\n| **昭和的メンタリティ** | AIプロンプトだけを売るような若いフリーランスに対して、強い違和感を覚えることがある |\n\n### 思想・哲学\n\n| 観点 | 内容 |\n|------|------|\n| **ルフィの思想・ゾロの行動** | 人をワクワクさせる思想を掲げつつ、自分一人では完結しないことを理解し、チームで動く姿勢 |\n| **金と信頼の葛藤** | 収益だけに振り切ればもっと稼げると理解しつつ、人の心や信頼を切り捨てる生き方はできないという葛藤 |\n| **年上との相性** | 年上の諸先輩方とは話が合う一方、年下とは価値観が合わないと感じることが多い |\n\n---\n\n## プライベート・家族\n\n| 項目 | 内容 |\n|------|------|\n| **奥さん** | 働いていたバーの下のアパレル店員。年越しカウントダウンイベントで話し、一目惚れした |\n| **子ども** | 上の子が小3・8歳、下の子が小1・7歳。22歳で第一子が誕生 |\n| **家族の重要性** | 「家族がいないと人間でいられないんじゃないか」と語るほど、家族が精神的支柱 |\n| **居住地** | 鹿児島。桜島が見える海沿いの物件に居住 |\n| **鹿児島生活の課題** | 火山灰が雨と混じって泥状になり、洗濯物に黒い砂が付くため浴室乾燥機が必須 |\n\n---\n\n## 趣味・日常\n\n| 項目 | 内容 |\n|------|------|\n| **好きな食べ物** | ラーメン |\n| **運動** | 土曜日に子どもと市民プールで25mプールを本気で泳ぐ。肩こり解消に水泳が効くと感じ、月4,500円でプール通いを検討中 |\n| **サッカー** | 熱狂的なサッカーファン。ワールドカップを一人で盛り上がるほど好きで、決勝トーナメント進出時のオンライン観戦イベントを提案 |\n| **子どもとの遊び** | Roblox を子どもたちと一緒にプレイ |\n| **血液型** | O型。父がA型のため「OA型」と自己分析し、大雑把な面が強いと語った |\n| **物をなくしやすい** | AirPods が行方不明のまま、有線イヤホンを使用中 |\n\n---\n\n## BNI・コミュニティへの関与\n\n| 項目 | 内容 |\n|------|------|\n| **トレーニング受講状況** | ビジターホストを2回受講済み。来週のパスポートプログラム・ワークショップ完了で DragonFly 推奨コースコンプリート（5,000円バック）を達成予定 |\n| **BNI参加の動機** | リファラル文化が「他人にコミットメントする」という自身のポリシーと合致したため |\n| **リファラルへの姿勢** | 紹介先に損を与えることは絶対にないという自信があり、紹介を通じた人間関係構築に積極的 |\n| **ダッシュキャンプ拡大** | BNI の中でもダッシュキャンプを大きくしていきたい意向 |\n\n---\n\n## アクションアイテム\n\n| 担当 | アクション | 期限 / 補足 |\n|------|------------|-------------|\n| **横山尚武** | 来週のパスポートプログラム・ワークショップを受講し、DragonFly 推奨コースをコンプリートする | 来週 |\n| **横山尚武** | ダッシュキャンプのプロダクト拡大に向けたリファラル・紹介活動を継続する | 継続 |\n| **次廣 → 横山尚武** | 東北一の鑑定士（占い師）とのセッションを検討・推薦する | 未定 |\n| **参加者全員** | 横山さんの AI 授業・ダッシュキャンプに関連する紹介候補者がいれば横山さんへつなぐ | 随時 |\n| **コミュニティ全体** | 対面イベントの鹿児島開催案を任意検討する | 未定 |\n\n---\n\n## 未確認・保留事項\n\n| 項目 | 状態 |\n|------|------|\n| **参加者一覧** | Zoom 要約に明記なし。TODO |\n| **鑑定士セッション** | 実施可否・日程は未確定 |\n| **ワールドカップ観戦イベント** | 具体的な日程・形式は未決定 |\n| **ダッシュキャンプ紹介条件** | 具体的なリファラル条件・紹介フロー詳細は本セッションでは未共有 |\n\n---\n\n## 次回予定\n\n| 日付 | 内容 |\n|------|------|\n| **2026-06-30（火）** | 次廣のパーソナル軸共有回 |\n| **2026-07-07（火）** | 軍司のパーソナル軸共有回 |\n| **2026-07-14（火）** | 小中のパーソナル軸共有回 |\n| **2026-07-21（火）** | 芳賀のパーソナル軸共有回 |\n| **2026-07-28（月）** | BOD（ビジネスオープンデイ・定例会回数外） |\n\n---\n\n## メモ（次廣・振り返り用）\n\n- 横山さんの強みは、AIそのものよりも「現場で体感したものを、相手が動ける言葉に変換する教育力」にある。\n- ダッシュキャンプの紹介条件を具体化できると、BNI内で紹介しやすくなる。対象者、課題、導入後の変化を次回以降確認したい。\n- 横山さんは信頼や人へのコミットメントを重視しており、BNI の Givers Gain と相性が良い。\n- 次廣の 6/30 パーソナル軸共有では、仕事だけでなく、家族・学生時代・価値観・趣味を含めた自己開示を準備する。\n\n---\n\n## 変更履歴\n\n| 日時 (JST) | 内容 |\n|------------|------|\n| 2026-06-23 19:10 | Zoom 文字起こし要約を校正し、横山尚武さんのパーソナル軸共有回として初版作成 |','docs/meetings/team/team_threebiz_20260623.md','team_meeting','2026-06-23','08:00-08:45','定例会前枠（火曜 8:00–8:45）。横山尚武さんのパーソナル軸共有回。終了時刻は Zoom 要約ベース。','zoom','Zoom 文字起こし要約（ユーザー提供・2026-06-23 19:09 JST）','{\"doc_type\":\"team_meeting\",\"team_id\":\"threebiz\",\"team_name_ja\":\"\\u30b9\\u30ea\\u30fc\\u30d0\\u30a4\\u30b9\",\"chapter\":\"bni_dragonfly\",\"session_date\":\"2026-06-23\",\"session_time_jst\":\"08:00-08:45\",\"session_time_note\":\"\\u5b9a\\u4f8b\\u4f1a\\u524d\\u67a0\\uff08\\u706b\\u66dc 8:00\\u20138:45\\uff09\\u3002\\u6a2a\\u5c71\\u5c1a\\u6b66\\u3055\\u3093\\u306e\\u30d1\\u30fc\\u30bd\\u30ca\\u30eb\\u8ef8\\u5171\\u6709\\u56de\\u3002\\u7d42\\u4e86\\u6642\\u523b\\u306f Zoom \\u8981\\u7d04\\u30d9\\u30fc\\u30b9\\u3002\",\"format\":\"zoom\",\"presenter_ja\":\"\\u6a2a\\u5c71 \\u5c1a\\u6b66\\uff08\\u30d1\\u30fc\\u30bd\\u30ca\\u30eb\\u8ef8\\u5171\\u6709\\uff09\",\"source\":\"Zoom \\u6587\\u5b57\\u8d77\\u3053\\u3057\\u8981\\u7d04\\uff08\\u30e6\\u30fc\\u30b6\\u30fc\\u63d0\\u4f9b\\u30fb2026-06-23 19:09 JST\\uff09\",\"related_chapter_weekly\":\"meetings\\/chapter\\/chapter_weekly_20260623.md\"}','2026-06-23 22:03:06','2026-06-23 22:03:06','2026-06-23 22:03:06');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(6,13,'meeting_participant_imports/13/f1752750-2920-4ed1-a254-6d0936f0db25.pdf','定例会参加者リスト2026_06_02.pdf','uploaded',NULL,'pending',NULL,NULL,NULL,NULL,'2026-06-02 17:05:53','2026-06-02 17:05:53'),
(7,18,'meeting_participant_imports/18/13541343-7594-40ae-8f04-e0250f272886.pdf','定例会参加者リスト2026_06_23.pdf','uploaded',NULL,'pending',NULL,NULL,NULL,NULL,'2026-06-23 22:13:31','2026-06-23 22:13:31');
/*!40000 ALTER TABLE `meeting_participant_imports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_referral_suggestion_runs`
--

DROP TABLE IF EXISTS `meeting_referral_suggestion_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_referral_suggestion_runs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `meeting_minute_id` bigint(20) unsigned NOT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `body_digest` varchar(64) NOT NULL,
  `body_char_count` int(10) unsigned NOT NULL,
  `context_mode` varchar(16) NOT NULL DEFAULT 'document',
  `context_digest` varchar(64) DEFAULT NULL,
  `generator` varchar(32) NOT NULL,
  `model` varchar(255) DEFAULT NULL,
  `raw_response` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `subject_member_id` bigint(20) unsigned DEFAULT NULL,
  `corpus_meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`corpus_meta`)),
  PRIMARY KEY (`id`),
  KEY `meeting_referral_suggestion_runs_meeting_minute_id_foreign` (`meeting_minute_id`),
  KEY `meeting_referral_suggestion_runs_owner_member_id_foreign` (`owner_member_id`),
  KEY `meeting_referral_suggestion_runs_workspace_id_foreign` (`workspace_id`),
  KEY `mtg_ref_run_mtg_created_idx` (`meeting_id`,`created_at`),
  KEY `mtg_ref_run_digest_idx` (`body_digest`),
  KEY `meeting_referral_suggestion_runs_subject_member_id_foreign` (`subject_member_id`),
  CONSTRAINT `meeting_referral_suggestion_runs_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `meeting_referral_suggestion_runs_meeting_minute_id_foreign` FOREIGN KEY (`meeting_minute_id`) REFERENCES `meeting_minutes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `meeting_referral_suggestion_runs_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `meeting_referral_suggestion_runs_subject_member_id_foreign` FOREIGN KEY (`subject_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `meeting_referral_suggestion_runs_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_referral_suggestion_runs`
--

LOCK TABLES `meeting_referral_suggestion_runs` WRITE;
/*!40000 ALTER TABLE `meeting_referral_suggestion_runs` DISABLE KEYS */;
/*!40000 ALTER TABLE `meeting_referral_suggestion_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_referral_suggestions`
--

DROP TABLE IF EXISTS `meeting_referral_suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_referral_suggestions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `run_id` bigint(20) unsigned NOT NULL,
  `meeting_id` bigint(20) unsigned NOT NULL,
  `source_section` varchar(32) NOT NULL DEFAULT 'other',
  `subject_member_id` bigint(20) unsigned DEFAULT NULL,
  `direction` varchar(32) NOT NULL,
  `corpus_source` varchar(24) NOT NULL DEFAULT 'self',
  `summary` text NOT NULL,
  `rationale` text DEFAULT NULL,
  `quality_notes` text DEFAULT NULL,
  `suggested_from_member_id` bigint(20) unsigned DEFAULT NULL,
  `suggested_to_member_id` bigint(20) unsigned DEFAULT NULL,
  `suggested_to_label` varchar(255) DEFAULT NULL,
  `suggested_contact_label` varchar(255) DEFAULT NULL,
  `confidence` varchar(16) NOT NULL DEFAULT 'medium',
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `introduction_id` bigint(20) unsigned DEFAULT NULL,
  `accepted_at` timestamp NULL DEFAULT NULL,
  `dismissed_at` timestamp NULL DEFAULT NULL,
  `edited_snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`edited_snapshot`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `source_one_to_one_id` bigint(20) unsigned DEFAULT NULL,
  `source_meeting_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meeting_referral_suggestions_suggested_from_member_id_foreign` (`suggested_from_member_id`),
  KEY `meeting_referral_suggestions_suggested_to_member_id_foreign` (`suggested_to_member_id`),
  KEY `mtg_ref_sugg_mtg_created_idx` (`meeting_id`,`created_at`),
  KEY `mtg_ref_sugg_run_idx` (`run_id`),
  KEY `mtg_ref_sugg_subject_idx` (`subject_member_id`),
  KEY `mtg_ref_sugg_intro_idx` (`introduction_id`),
  KEY `mtg_ref_sugg_status_idx` (`status`),
  KEY `meeting_referral_suggestions_source_one_to_one_id_foreign` (`source_one_to_one_id`),
  KEY `meeting_referral_suggestions_source_meeting_id_foreign` (`source_meeting_id`),
  CONSTRAINT `meeting_referral_suggestions_introduction_id_foreign` FOREIGN KEY (`introduction_id`) REFERENCES `introductions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `meeting_referral_suggestions_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `meeting_referral_suggestions_run_id_foreign` FOREIGN KEY (`run_id`) REFERENCES `meeting_referral_suggestion_runs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `meeting_referral_suggestions_source_meeting_id_foreign` FOREIGN KEY (`source_meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `meeting_referral_suggestions_source_one_to_one_id_foreign` FOREIGN KEY (`source_one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE SET NULL,
  CONSTRAINT `meeting_referral_suggestions_subject_member_id_foreign` FOREIGN KEY (`subject_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `meeting_referral_suggestions_suggested_from_member_id_foreign` FOREIGN KEY (`suggested_from_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `meeting_referral_suggestions_suggested_to_member_id_foreign` FOREIGN KEY (`suggested_to_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_referral_suggestions`
--

LOCK TABLES `meeting_referral_suggestions` WRITE;
/*!40000 ALTER TABLE `meeting_referral_suggestions` DISABLE KEYS */;
/*!40000 ALTER TABLE `meeting_referral_suggestions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meeting_types`
--

DROP TABLE IF EXISTS `meeting_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name_ja` varchar(255) NOT NULL,
  `is_numbered` tinyint(1) NOT NULL DEFAULT 0,
  `requires_team_id` tinyint(1) NOT NULL DEFAULT 0,
  `supports_participants` tinyint(1) NOT NULL DEFAULT 0,
  `supports_breakouts` tinyint(1) NOT NULL DEFAULT 0,
  `supports_referral_suggestions` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meeting_types_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meeting_types`
--

LOCK TABLES `meeting_types` WRITE;
/*!40000 ALTER TABLE `meeting_types` DISABLE KEYS */;
INSERT INTO `meeting_types` VALUES
(1,'chapter_weekly','定例会',1,0,1,1,1,10,1,'2026-06-23 21:56:21','2026-06-23 21:56:21'),
(2,'momentum_training','モメンタム',0,0,1,1,1,20,1,'2026-06-23 21:56:21','2026-06-23 21:56:21'),
(3,'business_open_day','BOD',0,0,1,1,1,30,1,'2026-06-23 21:56:21','2026-06-23 21:56:21'),
(4,'team_meeting','チームMTG',0,1,0,0,0,40,1,'2026-06-23 21:56:21','2026-06-23 21:56:21'),
(5,'webmaster_meeting','WebマスターMTG',0,0,0,0,0,50,1,'2026-06-23 21:56:21','2026-06-23 21:56:21');
/*!40000 ALTER TABLE `meeting_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meetings`
--

DROP TABLE IF EXISTS `meetings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meetings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `number` int(10) unsigned DEFAULT NULL,
  `meeting_type_id` bigint(20) unsigned NOT NULL,
  `session_type` varchar(64) NOT NULL DEFAULT 'chapter_weekly',
  `team_id` varchar(64) NOT NULL DEFAULT '',
  `held_on` date NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `bo_count` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `meetings_type_team_held_unique` (`meeting_type_id`,`team_id`,`held_on`),
  UNIQUE KEY `meetings_number_unique` (`number`),
  KEY `meetings_held_on_index` (`held_on`),
  KEY `meetings_session_type_held_on_index` (`session_type`,`held_on`),
  KEY `meetings_type_held_index` (`meeting_type_id`,`held_on`),
  CONSTRAINT `meetings_meeting_type_id_foreign` FOREIGN KEY (`meeting_type_id`) REFERENCES `meeting_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meetings`
--

LOCK TABLES `meetings` WRITE;
/*!40000 ALTER TABLE `meetings` DISABLE KEYS */;
INSERT INTO `meetings` VALUES
(1,199,1,'chapter_weekly','','2026-03-03','第199回定例会',2,'2026-03-03 00:34:23','2026-03-03 00:34:23'),
(2,200,1,'chapter_weekly','','2026-03-10','第200回定例会',2,'2026-03-10 00:40:13','2026-03-10 00:40:13'),
(3,201,1,'chapter_weekly','','2026-03-17','第201回定例会',2,'2026-03-16 23:42:36','2026-03-16 23:42:36'),
(4,202,1,'chapter_weekly','','2026-03-24','第202回定例会',2,'2026-03-20 09:47:41','2026-03-20 09:47:41'),
(6,203,1,'chapter_weekly','','2026-03-31','第203回定例会',2,'2026-03-30 23:59:39','2026-03-30 23:59:39'),
(7,204,1,'chapter_weekly','','2026-04-07','第204回定例会',2,'2026-04-07 00:04:24','2026-04-07 00:04:24'),
(8,205,1,'chapter_weekly','','2026-04-14','第205回定例会',2,'2026-04-13 12:13:25','2026-04-13 12:13:25'),
(9,206,1,'chapter_weekly','','2026-04-21','第206回定例会',2,'2026-04-20 20:36:09','2026-04-20 20:36:09'),
(10,207,1,'chapter_weekly','','2026-05-12','第207回定例会',2,'2026-05-12 08:00:43','2026-05-12 08:00:43'),
(11,208,1,'chapter_weekly','','2026-05-19','第208回定例会',2,'2026-05-18 22:56:51','2026-05-18 22:56:51'),
(12,209,1,'chapter_weekly','','2026-05-26','第209回定例会',2,'2026-05-25 17:33:03','2026-05-25 17:33:03'),
(13,210,1,'chapter_weekly','','2026-06-02','第210回定例会',2,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(14,211,1,'chapter_weekly','','2026-06-09','第211回定例会',2,'2026-06-09 08:47:10','2026-06-09 08:47:10'),
(16,NULL,2,'momentum_training','','2026-06-16','モメンタムトレーニング',2,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(17,NULL,3,'business_open_day','','2026-07-28','ビジネスオープンデイ（BOD）',2,'2026-06-16 17:14:24','2026-06-16 17:14:24'),
(18,212,1,'chapter_weekly','','2026-06-23','第212回定例会',2,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(19,NULL,4,'team_meeting','threebiz','2026-05-19','スリーバイス チームMTG',2,'2026-06-23 22:03:06','2026-06-23 22:03:06'),
(20,NULL,4,'team_meeting','threebiz','2026-06-02','スリーバイス チームMTG',2,'2026-06-23 22:03:06','2026-06-23 22:03:06'),
(21,NULL,4,'team_meeting','threebiz','2026-06-09','スリーバイス チームMTG',2,'2026-06-23 22:03:06','2026-06-23 22:03:06'),
(22,NULL,4,'team_meeting','threebiz','2026-06-16','スリーバイス チームMTG',2,'2026-06-23 22:03:06','2026-06-23 22:03:06'),
(23,NULL,4,'team_meeting','threebiz','2026-06-23','スリーバイス チームMTG',2,'2026-06-23 22:03:06','2026-06-23 22:03:06');
/*!40000 ALTER TABLE `meetings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_referral_corpus_settings`
--

DROP TABLE IF EXISTS `member_referral_corpus_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_referral_corpus_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `member_id` bigint(20) unsigned NOT NULL,
  `allow_cross_corpus_contribution` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `member_ref_corpus_settings_member_uq` (`member_id`),
  KEY `member_referral_corpus_settings_workspace_id_foreign` (`workspace_id`),
  CONSTRAINT `member_referral_corpus_settings_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `member_referral_corpus_settings_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_referral_corpus_settings`
--

LOCK TABLES `member_referral_corpus_settings` WRITE;
/*!40000 ALTER TABLE `member_referral_corpus_settings` DISABLE KEYS */;
INSERT INTO `member_referral_corpus_settings` VALUES
(1,1,37,0,'2026-06-04 22:26:50','2026-06-04 22:26:50');
/*!40000 ALTER TABLE `member_referral_corpus_settings` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=677 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(485,2,39,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(486,3,2,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(487,8,41,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(488,4,40,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(489,5,33,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(490,6,34,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(491,9,42,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(492,10,7,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(493,11,13,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(494,12,43,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(495,13,20,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(496,17,35,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(497,18,39,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(498,19,4,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(499,20,36,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(500,21,10,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(501,22,12,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(502,24,12,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(503,25,14,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(504,26,46,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(505,28,16,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(506,30,14,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(507,32,18,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(508,33,19,'2026-06-02',NULL,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(509,34,45,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(510,36,7,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(511,39,21,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(512,40,47,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(513,29,12,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(514,41,44,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(515,42,14,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(516,43,48,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(517,44,23,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(518,46,37,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(519,47,16,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(520,48,39,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(521,49,38,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(522,50,29,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(523,51,49,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(524,53,12,'2026-06-02','2026-06-09','2026-06-02 08:49:44','2026-06-09 08:47:11'),
(525,2,39,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(526,3,2,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(527,8,41,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(528,4,40,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(529,5,33,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(530,6,34,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(531,9,42,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(532,10,7,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(533,11,13,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(534,12,43,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(535,13,20,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(536,17,35,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(537,18,39,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(538,19,4,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(539,20,36,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(540,21,10,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(541,22,12,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(542,24,12,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(543,25,14,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(544,26,46,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(545,28,16,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(546,30,14,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(547,32,18,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(548,36,7,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(549,39,21,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(550,40,47,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(551,29,12,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(552,41,44,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(553,42,14,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(554,43,48,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(555,44,23,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(556,46,37,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(557,47,16,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(558,48,39,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:57'),
(559,49,38,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:58'),
(560,50,29,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:58'),
(561,51,49,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:58'),
(562,53,12,'2026-06-09','2026-06-16','2026-06-09 08:47:11','2026-06-16 07:48:58'),
(563,2,39,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(564,3,2,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(565,8,41,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(566,4,40,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(567,5,33,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(568,6,34,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(569,9,42,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(570,10,7,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(571,11,13,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(572,12,43,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(573,13,20,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(574,17,35,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(575,18,39,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(576,19,4,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(577,20,36,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(578,21,10,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(579,22,12,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(580,24,12,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(581,25,14,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(582,26,46,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(583,28,16,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(584,30,14,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(585,32,18,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(586,36,7,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(587,39,21,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(588,40,47,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(589,29,12,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(590,41,44,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(591,42,14,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(592,43,48,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(593,44,23,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(594,46,37,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(595,47,16,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(596,48,39,'2026-06-16','2026-06-16','2026-06-16 07:48:57','2026-06-16 09:57:54'),
(597,49,38,'2026-06-16','2026-06-16','2026-06-16 07:48:58','2026-06-16 09:57:54'),
(598,50,29,'2026-06-16','2026-06-16','2026-06-16 07:48:58','2026-06-16 09:57:54'),
(599,51,49,'2026-06-16','2026-06-16','2026-06-16 07:48:58','2026-06-16 09:57:54'),
(600,53,12,'2026-06-16','2026-06-16','2026-06-16 07:48:58','2026-06-16 09:57:54'),
(601,2,39,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(602,3,2,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(603,8,41,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(604,4,40,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(605,5,33,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(606,6,34,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(607,9,42,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(608,10,7,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(609,11,13,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(610,12,43,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(611,13,20,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(612,17,35,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(613,18,39,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(614,19,4,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(615,20,36,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(616,21,10,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(617,22,12,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(618,24,12,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(619,25,14,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(620,26,46,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(621,28,16,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(622,30,14,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(623,32,18,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(624,36,7,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(625,39,21,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(626,40,47,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(627,29,12,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(628,41,44,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(629,42,14,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(630,43,48,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(631,44,23,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(632,46,37,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(633,47,16,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(634,48,39,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(635,49,38,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(636,50,29,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(637,51,49,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(638,53,12,'2026-06-16','2026-06-23','2026-06-16 09:57:54','2026-06-23 08:04:04'),
(639,2,39,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(640,3,2,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(641,8,41,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(642,4,40,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(643,5,33,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(644,6,34,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(645,9,42,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(646,10,7,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(647,11,13,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(648,12,43,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(649,13,20,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(650,17,35,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(651,18,39,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(652,19,4,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(653,20,36,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(654,21,10,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(655,22,12,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(656,24,12,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(657,25,14,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(658,26,46,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(659,28,16,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(660,30,14,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(661,32,18,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(662,36,7,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(663,39,21,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(664,40,47,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(665,29,12,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(666,41,44,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(667,42,14,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(668,43,48,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(669,44,23,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(670,46,37,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(671,47,16,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(672,48,39,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(673,49,38,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(674,50,29,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(675,51,49,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(676,53,12,'2026-06-23',NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(29,'加藤　隆太','かとう　りゅうた',NULL,217,1,'member','39',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(30,'越賀　淑恵','こしが　としえ',NULL,103,1,'member','29',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(31,'望月　雅幸','もちづき　まさゆき',NULL,105,1,'member','30',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(32,'佐久間　康丞','さくま　こうすけ',NULL,106,1,'member','31',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(33,'斎藤　和貴','さいとうかずき',NULL,107,1,'member','32',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-02 08:49:44'),
(34,'小中　貴晃','こなか　たかあき',NULL,108,1,'member','32',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(35,'山本　洸太','やまもと　こうた',NULL,109,1,'member','33',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(36,'軍司　敦哉','ぐんじ　あつや',NULL,110,1,'member','34',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(37,'次廣　淳','つぎひろ　あつし','tugi@tugilo.com',149,1,'member','35',NULL,'AI業務改善システム構築の次廣です。\n時間を生み出すSEです。\n\n建設業や製造業で、Excel・手作業の見積、現場、請求を、\n1回の入力で回る仕組みにします。\n\n担当者しか分からない状態を、誰でも追える形に変えます。\n\nそんな会社様や、顧問先に持つ士業・コンサルの方とお繋ぎください。\n\nAI業務改善システム構築の次廣でした。','AI業務改善システム構築の次廣です。\n時間を生み出すSEです。\n\n私は、建設業や製造業、現場仕事の多い会社で、\nExcelや手作業で行っている見積、現場管理、請求業務を、\n1回の入力で回る仕組みに変えるお手伝いをしています。\n\n担当者しか分からない状態を、\n誰でも追えて、ミスなく回る形に整えます。\n\n実際に、DragonFlyメンバーの増本さんの害虫ブロック事業でも、\n業務の流れに合わせたシステムを構築し、\nかなり成果が出始めています。\n\n私が作っているのは、単なるシステムではなく、\n社長や現場の方が、本来やるべき仕事に集中するための時間です。\n\nご紹介いただきたいのは、\n建設業・製造業・現場仕事の多い会社で、\nExcel管理や手入力が多く、そろそろ仕組み化したい会社様です。\n\nまた、そういった会社を顧問先に持つ、\n士業・コンサルの方ともぜひお繋ぎください。\n\nAI業務改善システム構築の次廣でした。',NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(38,'吉田　俊之','よしだとしゆき',NULL,111,1,'member','35',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-18 22:56:51'),
(39,'里見　允二','さとみ　まさつぐ',NULL,112,1,'member','37',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(40,'畠山　憲之','はたけやま　のりゆき',NULL,113,1,'member','38',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(41,'今西　俊明','いまにし　としあき',NULL,114,1,'member','40',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(42,'廣田　誠悟','ひろた　せいご',NULL,115,1,'member','41',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(43,'田渕　恭平','たぶち　きょうへい',NULL,116,1,'member','42',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(44,'木村　健悟','きむら　けんご',NULL,117,1,'member','43',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(45,'立岡　海人','たつおか　かいと',NULL,118,1,'member','45',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-03-16 23:42:37'),
(46,'藤井　恵理子','ふじい　えりこ',NULL,120,1,'member','44',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(47,'今村　千絵','いまむら　ちえ',NULL,121,1,'member','45',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(48,'清原　佳彩美','きよはら　かさみ',NULL,218,1,'member','46',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(49,'船津　麻理子','ふなつ　まりこ',NULL,123,1,'member','47',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(50,'飯田　千帆','いいだ　ちほ',NULL,124,1,'member','48',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(51,'飯田　香','いいだ　かおり',NULL,125,1,'member','49',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
(52,'野口　裕子',NULL,NULL,NULL,1,'member','50',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-05-26 09:02:55'),
(53,'久米　加代子','くめ　かよこ',NULL,186,1,'member','50',NULL,NULL,NULL,NULL,NULL,'2026-03-03 00:34:23','2026-06-09 08:47:11'),
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
(136,'米澤　侑桂','よねざわ　ゆか',NULL,248,NULL,'member','36',NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:02:55','2026-06-09 08:47:11'),
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
(149,'木村　杏那','きむら　あんな',NULL,247,NULL,'member','18',NULL,NULL,NULL,NULL,NULL,'2026-06-02 08:49:44','2026-06-05 09:27:03'),
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
(164,'遠藤　聡美','えんどう　さとみ','mirai.realestate7678@gmail.com',150,11,'visitor',NULL,'https://ne001.ncas.jp/bni_meibo/viewsheets.php?id=NUN4RWw3aGl5SFNJQWlqeHBHVFUvUT09&chapter=bzlaQzRNTEExZ2x1dk1vUjUvVFdOUT09',NULL,NULL,NULL,NULL,'2026-06-04 07:33:36','2026-06-04 07:33:36'),
(165,'八田　奈緒美','はった　なおみ',NULL,261,NULL,'member','51',NULL,NULL,NULL,NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(166,'横山　太樹','よこやま　たいき',NULL,262,NULL,'visitor','V1',NULL,NULL,NULL,21,20,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(167,'吉川　真徳','きっかわ　まさのり',NULL,263,NULL,'visitor','V2',NULL,NULL,NULL,17,6,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(168,'高野　晋','たかの　しん',NULL,264,NULL,'visitor','V3',NULL,NULL,NULL,17,9,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(169,'竹村　裕司','たけむら　ゆうじ',NULL,265,NULL,'guest','G1',NULL,NULL,NULL,13,2,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(170,'吉田　拓磨','よしだ　たくま',NULL,NULL,NULL,'visitor','V2',NULL,NULL,NULL,NULL,NULL,'2026-06-13 08:11:28','2026-06-13 08:11:28'),
(171,'千田　麻美','せんだ　あさみ',NULL,266,NULL,'visitor','V1',NULL,NULL,NULL,49,24,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(172,'朽木　奈津美','くちき　なつみ',NULL,267,NULL,'visitor','V2',NULL,NULL,NULL,49,49,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(173,'横山　絢香','よこやま　あやか',NULL,268,NULL,'visitor','V3',NULL,NULL,NULL,6,12,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(174,'中島　大地','なかじま　だいち',NULL,269,NULL,'visitor','V4',NULL,NULL,NULL,149,1,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(175,'吉野　光祐','よしの　こうすけ',NULL,270,NULL,'visitor','V5',NULL,NULL,NULL,48,48,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(176,'吉田　匠真','よしだ　たくま',NULL,271,NULL,'visitor','V6',NULL,NULL,NULL,37,30,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(177,'山野　佑一郎','やまの　ゆういちろう',NULL,272,NULL,'visitor','V7',NULL,NULL,NULL,37,4,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(178,'渡仲　大輔','となか　だいすけ',NULL,273,NULL,'visitor','V8',NULL,NULL,NULL,37,18,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(179,'森田　悦章','もりた　よしあき',NULL,274,NULL,'visitor','V9',NULL,NULL,NULL,20,20,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(180,'田村　鈴夏','たむら　すずか',NULL,275,NULL,'visitor','V10',NULL,NULL,NULL,34,34,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(181,'八田　玄治','はった　げんじ',NULL,276,NULL,'visitor','V11',NULL,NULL,NULL,41,11,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(182,'松元　亜紀','まつもと　あき',NULL,277,NULL,'visitor','V12',NULL,NULL,NULL,49,25,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(183,'櫻井　克洋','さくらい　かつひろ',NULL,278,NULL,'visitor','V13',NULL,NULL,NULL,136,9,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(184,'林　希世視','はやし　きみよ',NULL,279,NULL,'guest','P1',NULL,NULL,NULL,165,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(185,'實島　賢','さねしま　けん',NULL,198,NULL,'guest','P2',NULL,NULL,NULL,6,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(186,'伊藤　裕一郎','いとう　ゆういちろう',NULL,173,NULL,'guest','G1',NULL,NULL,NULL,37,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(187,'中村　さやか','なかむら　さやか',NULL,280,NULL,'guest','G2',NULL,NULL,NULL,19,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(188,'砂田　浩史','すなだ　ひろし',NULL,281,NULL,'guest','G3',NULL,NULL,NULL,19,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(189,'平野　眞邦',NULL,NULL,11,12,'member',NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 08:10:45','2026-06-23 08:10:45'),
(190,'西原海成','にしはら',NULL,NULL,NULL,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 14:16:12','2026-06-23 14:16:12'),
(191,'門松直幸',NULL,NULL,NULL,NULL,'guest',NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 14:17:04','2026-06-23 14:17:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(62,'2026_06_04_100000_rename_default_workspace_to_dragonfly',34),
(63,'2026_06_04_140000_create_referral_suggestion_tables',35),
(64,'2026_06_04_220000_referral_suggestion_cross_match',36),
(65,'2026_06_16_120000_add_session_type_to_meetings_table',37),
(66,'2026_06_16_130000_meetings_session_type_held_on_index_only',38),
(67,'2026_06_23_215500_create_meeting_types_table',39),
(68,'2026_06_23_215600_add_meeting_type_id_and_team_id_to_meetings_table',40);
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
-- Table structure for table `one_to_one_referral_suggestion_runs`
--

DROP TABLE IF EXISTS `one_to_one_referral_suggestion_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `one_to_one_referral_suggestion_runs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `one_to_one_id` bigint(20) unsigned NOT NULL,
  `owner_member_id` bigint(20) unsigned NOT NULL,
  `workspace_id` bigint(20) unsigned DEFAULT NULL,
  `notes_digest` varchar(64) NOT NULL,
  `notes_char_count` int(10) unsigned NOT NULL,
  `context_mode` varchar(16) NOT NULL DEFAULT 'document',
  `context_digest` varchar(64) DEFAULT NULL,
  `generator` varchar(32) NOT NULL,
  `model` varchar(255) DEFAULT NULL,
  `raw_response` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `subject_member_id` bigint(20) unsigned DEFAULT NULL,
  `corpus_meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`corpus_meta`)),
  PRIMARY KEY (`id`),
  KEY `one_to_one_referral_suggestion_runs_owner_member_id_foreign` (`owner_member_id`),
  KEY `one_to_one_referral_suggestion_runs_workspace_id_foreign` (`workspace_id`),
  KEY `o2o_ref_run_o2o_created_idx` (`one_to_one_id`,`created_at`),
  KEY `o2o_ref_run_digest_idx` (`notes_digest`),
  KEY `one_to_one_referral_suggestion_runs_subject_member_id_foreign` (`subject_member_id`),
  CONSTRAINT `one_to_one_referral_suggestion_runs_one_to_one_id_foreign` FOREIGN KEY (`one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `one_to_one_referral_suggestion_runs_owner_member_id_foreign` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `one_to_one_referral_suggestion_runs_subject_member_id_foreign` FOREIGN KEY (`subject_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_one_referral_suggestion_runs_workspace_id_foreign` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `one_to_one_referral_suggestion_runs`
--

LOCK TABLES `one_to_one_referral_suggestion_runs` WRITE;
/*!40000 ALTER TABLE `one_to_one_referral_suggestion_runs` DISABLE KEYS */;
INSERT INTO `one_to_one_referral_suggestion_runs` VALUES
(1,72,37,1,'69bcde22a2eabd7602f0139f5fed432a853037f3ce5a62afc15cb2e978deb894',8742,'relationship','f6ac326f575bad2e4c98755ecc07aa30f16d51bbbb716c57dd3446524baaefd1','ai_openai',NULL,'```json\n{\n  \"suggestions\": [\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"遠藤聡美さんはシングルマザー専門の住宅購入アドバイザーであり、特にシングルマザー向けの住宅相談に特化しています。彼女のネットワークには、シングルマザーや子育て中の女性が多く含まれている可能性があります。\",\n      \"rationale\": \"第210回定例会議事録において、シングルマザー向けの住宅相談に関するニーズが示されています。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 164,\n      \"suggested_contact_label\": \"シングルマザーや子育て中の女性\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": 13,\n      \"confidence\": \"high\"\n    },\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"遠藤聡美さんの専門性を活かし、シングルマザー向けの住宅購入に関心を持つ人々を紹介することができます。\",\n      \"rationale\": \"定例会でのリファーラルの中で、シングルマザー向けのサービスに関連したニーズが確認されています。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 164,\n      \"suggested_contact_label\": \"シングルマザー向けの住宅購入を考えている方\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": 13,\n      \"confidence\": \"high\"\n    }\n  ]\n}\n```','2026-06-04 22:42:31',164,'{\"consented_owner_count\":0,\"o2o_excerpt_count\":0,\"meeting_count\":6}'),
(2,66,37,1,'c0362868eb907042a1532ec9dcb97f2f2747eedbdb7df81929624f0389b7c53c',6608,'relationship','5d2707145e070cd2e5e50259ddbd75bf8aabb0014d4ea1380df071d3fbbec604','ai_openai',NULL,'```json\n{\n  \"suggestions\": [\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"西浦さんが紹介したいと思うSNSマーケティングの専門家とつなぐ。\",\n      \"rationale\": \"第210回定例会でのビジター紹介から、SNSマーケティングの専門家が紹介されているため。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 12,\n      \"suggested_contact_label\": \"門脇唯\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": 13,\n      \"confidence\": \"high\"\n    },\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"医療専門FPの岩本悠太さんとつなぐことで、医療機関向けのサービスを拡大できる可能性がある。\",\n      \"rationale\": \"第210回定例会でのビジター紹介から、医療専門FPが紹介されているため。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 12,\n      \"suggested_contact_label\": \"岩本悠太\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": 13,\n      \"confidence\": \"medium\"\n    },\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"経営者向けのマッチングプラットフォームを提供する遠藤哲也さんとつなぐ。\",\n      \"rationale\": \"第210回定例会でのビジター紹介から、経営者マッチングの専門家が紹介されているため。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 12,\n      \"suggested_contact_label\": \"遠藤哲也\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": 13,\n      \"confidence\": \"medium\"\n    }\n  ]\n}\n```','2026-06-04 22:43:47',12,'{\"consented_owner_count\":0,\"o2o_excerpt_count\":0,\"meeting_count\":6}'),
(3,37,37,1,'502a35f50c30a8798f5d24e5c9781ca05500f28a60bad8e34c8ef10be5495353',15083,'relationship','76a0cb0d6cd38d80406df88987f4e392f338e4dbd597a186a8a31209ed02d4e0','ai_openai',NULL,'```json\n{\n  \"suggestions\": [\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"原田里織さんは店舗・施設集客を高めるデジタルサイネージの専門家です。\",\n      \"rationale\": \"定例会議事録において、リファーラルの交換が行われており、原田さんのビジネスに関連する紹介が期待されるため。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 18,\n      \"suggested_contact_label\": \"店舗・施設集客を高めるデジタルサイネージの専門家\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": null,\n      \"confidence\": \"high\"\n    },\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"原田里織さんは経理や簿記に関心があり、関連するビジネスの紹介が有効です。\",\n      \"rationale\": \"定例会議事録において、経理や簿記に関心を持つ原田さんに対して、これらの分野の専門家を紹介することで相互に利益が得られるため。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 1,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 18,\n      \"suggested_contact_label\": \"経理や簿記の専門家\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": null,\n      \"confidence\": \"medium\"\n    }\n  ]\n}\n```','2026-06-04 22:44:21',18,'{\"consented_owner_count\":0,\"o2o_excerpt_count\":0,\"meeting_count\":6}'),
(4,36,37,1,'2ae3c51cf67e707a14bd18a909f6590bf109e878c1f2356ed2d946f1cd56066c',16164,'relationship','f065b4d020cd85821aa131bf543e47643d9c6abdfd0ab2beb63bc490d8ef2af1','ai_openai',NULL,'```json\n{\n  \"suggestions\": [\n    {\n      \"direction\": \"subject_should_meet\",\n      \"corpus_source\": \"self\",\n      \"summary\": \"神保さんは、ビジネス特化型クレジットカードを提供する山本葉子さんと会うべきです。彼女のサービスは、神保さんのビジネスにおける顧客管理や決済の効率化に寄与する可能性があります。\",\n      \"rationale\": \"引用: 121#38 の一文\",\n      \"match_member_id\": 27,\n      \"connector_member_id\": null,\n      \"suggested_from_member_id\": 138,\n      \"suggested_to_member_id\": 27,\n      \"suggested_contact_label\": null,\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": null,\n      \"confidence\": \"high\"\n    },\n    {\n      \"direction\": \"subject_should_meet\",\n      \"corpus_source\": \"self\",\n      \"summary\": \"神保さんは、飲食店向け集客アプリを提供する今西俊明さんと会うべきです。アプリを通じて、神保さんのサービスを飲食業界に広める手助けが期待できます。\",\n      \"rationale\": \"引用: 121#38 の一文\",\n      \"match_member_id\": 41,\n      \"connector_member_id\": null,\n      \"suggested_from_member_id\": 138,\n      \"suggested_to_member_id\": 41,\n      \"suggested_contact_label\": null,\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": null,\n      \"confidence\": \"high\"\n    }\n  ]\n}\n```','2026-06-04 22:51:26',138,'{\"consented_owner_count\":0,\"o2o_excerpt_count\":0,\"meeting_count\":0,\"introduction_count\":0}'),
(5,84,37,1,'52a0a01b10a1b839a14507f64575e3a48807cfa88257edc5f020f985e61e7362',7330,'relationship','aac42c55188652ba5cc7b2d5fbfa53d5fc99e2ae38931722135b82603109a89c','ai_openai',NULL,'```json\n{\n  \"suggestions\": [\n    {\n      \"direction\": \"owner_to_target\",\n      \"corpus_source\": \"self\",\n      \"summary\": \"千帆さんは、経営者向けの開運占いを提供しており、特に仕事や人間関係に関するアドバイスが得意です。\",\n      \"rationale\": \"千帆さんの占いが経営者にとって有益であることを考慮し、経営者向けの開運占いを受けることを提案します。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": null,\n      \"suggested_from_member_id\": null,\n      \"suggested_to_member_id\": null,\n      \"suggested_contact_label\": null,\n      \"suggested_to_label\": \"経営者向け開運占い\",\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": null,\n      \"confidence\": \"high\"\n    },\n    {\n      \"direction\": \"via_connector\",\n      \"corpus_source\": \"member_network\",\n      \"summary\": \"千帆さんの占いを受けた経営者からの紹介を通じて、他の経営者ともつながる機会があります。\",\n      \"rationale\": \"千帆さんの顧客の中には、他の経営者が多くいるため、彼らを通じて新たなビジネスチャンスが生まれる可能性があります。\",\n      \"quality_notes\": [],\n      \"connector_member_id\": 55,\n      \"suggested_from_member_id\": 37,\n      \"suggested_to_member_id\": 37,\n      \"suggested_contact_label\": \"経営者向け開運占いの顧客\",\n      \"suggested_to_label\": null,\n      \"source_one_to_one_id\": null,\n      \"source_meeting_id\": null,\n      \"confidence\": \"medium\"\n    }\n  ]\n}\n```','2026-06-24 13:52:58',50,'{\"consented_owner_count\":0,\"o2o_excerpt_count\":1,\"meeting_count\":6,\"introduction_count\":0}');
/*!40000 ALTER TABLE `one_to_one_referral_suggestion_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `one_to_one_referral_suggestions`
--

DROP TABLE IF EXISTS `one_to_one_referral_suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `one_to_one_referral_suggestions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `run_id` bigint(20) unsigned NOT NULL,
  `one_to_one_id` bigint(20) unsigned NOT NULL,
  `direction` varchar(32) NOT NULL,
  `corpus_source` varchar(24) NOT NULL DEFAULT 'self',
  `summary` text NOT NULL,
  `rationale` text DEFAULT NULL,
  `quality_notes` text DEFAULT NULL,
  `suggested_from_member_id` bigint(20) unsigned DEFAULT NULL,
  `suggested_to_member_id` bigint(20) unsigned DEFAULT NULL,
  `suggested_to_label` varchar(255) DEFAULT NULL,
  `suggested_contact_label` varchar(255) DEFAULT NULL,
  `confidence` varchar(16) NOT NULL DEFAULT 'medium',
  `status` varchar(16) NOT NULL DEFAULT 'pending',
  `introduction_id` bigint(20) unsigned DEFAULT NULL,
  `accepted_at` timestamp NULL DEFAULT NULL,
  `dismissed_at` timestamp NULL DEFAULT NULL,
  `edited_snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`edited_snapshot`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `source_one_to_one_id` bigint(20) unsigned DEFAULT NULL,
  `source_meeting_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `one_to_one_referral_suggestions_suggested_from_member_id_foreign` (`suggested_from_member_id`),
  KEY `one_to_one_referral_suggestions_suggested_to_member_id_foreign` (`suggested_to_member_id`),
  KEY `o2o_ref_sugg_o2o_created_idx` (`one_to_one_id`,`created_at`),
  KEY `o2o_ref_sugg_run_idx` (`run_id`),
  KEY `o2o_ref_sugg_intro_idx` (`introduction_id`),
  KEY `o2o_ref_sugg_status_idx` (`status`),
  KEY `one_to_one_referral_suggestions_source_one_to_one_id_foreign` (`source_one_to_one_id`),
  KEY `one_to_one_referral_suggestions_source_meeting_id_foreign` (`source_meeting_id`),
  CONSTRAINT `one_to_one_referral_suggestions_introduction_id_foreign` FOREIGN KEY (`introduction_id`) REFERENCES `introductions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_one_referral_suggestions_one_to_one_id_foreign` FOREIGN KEY (`one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE CASCADE,
  CONSTRAINT `one_to_one_referral_suggestions_run_id_foreign` FOREIGN KEY (`run_id`) REFERENCES `one_to_one_referral_suggestion_runs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `one_to_one_referral_suggestions_source_meeting_id_foreign` FOREIGN KEY (`source_meeting_id`) REFERENCES `meetings` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_one_referral_suggestions_source_one_to_one_id_foreign` FOREIGN KEY (`source_one_to_one_id`) REFERENCES `one_to_ones` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_one_referral_suggestions_suggested_from_member_id_foreign` FOREIGN KEY (`suggested_from_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL,
  CONSTRAINT `one_to_one_referral_suggestions_suggested_to_member_id_foreign` FOREIGN KEY (`suggested_to_member_id`) REFERENCES `members` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `one_to_one_referral_suggestions`
--

LOCK TABLES `one_to_one_referral_suggestions` WRITE;
/*!40000 ALTER TABLE `one_to_one_referral_suggestions` DISABLE KEYS */;
INSERT INTO `one_to_one_referral_suggestions` VALUES
(1,1,72,'via_connector','member_network','遠藤聡美さんはシングルマザー専門の住宅購入アドバイザーであり、特にシングルマザー向けの住宅相談に特化しています。彼女のネットワークには、シングルマザーや子育て中の女性が多く含まれている可能性があります。','第210回定例会議事録において、シングルマザー向けの住宅相談に関するニーズが示されています。','[]',1,37,NULL,'シングルマザーや子育て中の女性','high','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:42:31','2026-06-04 22:42:31',NULL,13),
(2,1,72,'via_connector','member_network','遠藤聡美さんの専門性を活かし、シングルマザー向けの住宅購入に関心を持つ人々を紹介することができます。','定例会でのリファーラルの中で、シングルマザー向けのサービスに関連したニーズが確認されています。','[]',1,37,NULL,'シングルマザー向けの住宅購入を考えている方','high','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:42:31','2026-06-04 22:42:31',NULL,13),
(3,2,66,'via_connector','member_network','西浦さんが紹介したいと思うSNSマーケティングの専門家とつなぐ。','第210回定例会でのビジター紹介から、SNSマーケティングの専門家が紹介されているため。','[]',1,12,NULL,'門脇唯','high','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:43:47','2026-06-04 22:43:47',NULL,13),
(4,2,66,'via_connector','member_network','医療専門FPの岩本悠太さんとつなぐことで、医療機関向けのサービスを拡大できる可能性がある。','第210回定例会でのビジター紹介から、医療専門FPが紹介されているため。','[]',1,12,NULL,'岩本悠太','medium','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:43:47','2026-06-04 22:43:47',NULL,13),
(5,2,66,'via_connector','member_network','経営者向けのマッチングプラットフォームを提供する遠藤哲也さんとつなぐ。','第210回定例会でのビジター紹介から、経営者マッチングの専門家が紹介されているため。','[]',1,12,NULL,'遠藤哲也','medium','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:43:47','2026-06-04 22:43:47',NULL,13),
(6,3,37,'via_connector','member_network','原田里織さんは店舗・施設集客を高めるデジタルサイネージの専門家です。','定例会議事録において、リファーラルの交換が行われており、原田さんのビジネスに関連する紹介が期待されるため。','[]',1,18,NULL,'店舗・施設集客を高めるデジタルサイネージの専門家','high','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:44:21','2026-06-04 22:44:21',NULL,NULL),
(7,3,37,'via_connector','member_network','原田里織さんは経理や簿記に関心があり、関連するビジネスの紹介が有効です。','定例会議事録において、経理や簿記に関心を持つ原田さんに対して、これらの分野の専門家を紹介することで相互に利益が得られるため。','[]',1,18,NULL,'経理や簿記の専門家','medium','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:44:21','2026-06-04 22:44:21',NULL,NULL),
(8,4,36,'subject_should_meet','self','神保さんは、ビジネス特化型クレジットカードを提供する山本葉子さんと会うべきです。彼女のサービスは、神保さんのビジネスにおける顧客管理や決済の効率化に寄与する可能性があります。','引用: 121#38 の一文',NULL,37,27,NULL,NULL,'high','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:51:26','2026-06-04 22:51:26',NULL,NULL),
(9,4,36,'subject_should_meet','self','神保さんは、飲食店向け集客アプリを提供する今西俊明さんと会うべきです。アプリを通じて、神保さんのサービスを飲食業界に広める手助けが期待できます。','引用: 121#38 の一文',NULL,37,41,NULL,NULL,'high','pending',NULL,NULL,NULL,NULL,'2026-06-04 22:51:26','2026-06-04 22:51:26',NULL,NULL),
(10,5,84,'owner_to_target','self','千帆さんは、経営者向けの開運占いを提供しており、特に仕事や人間関係に関するアドバイスが得意です。','千帆さんの占いが経営者にとって有益であることを考慮し、経営者向けの開運占いを受けることを提案します。','[]',NULL,NULL,'経営者向け開運占い',NULL,'high','pending',NULL,NULL,NULL,NULL,'2026-06-24 13:52:58','2026-06-24 13:52:58',NULL,NULL),
(11,5,84,'via_connector','member_network','千帆さんの占いを受けた経営者からの紹介を通じて、他の経営者ともつながる機会があります。','千帆さんの顧客の中には、他の経営者が多くいるため、彼らを通じて新たなビジネスチャンスが生まれる可能性があります。','[]',55,37,NULL,'経営者向け開運占いの顧客','medium','pending',NULL,NULL,NULL,NULL,'2026-06-24 13:52:58','2026-06-24 13:52:58',NULL,NULL);
/*!40000 ALTER TABLE `one_to_one_referral_suggestions` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `one_to_ones`
--

LOCK TABLES `one_to_ones` WRITE;
/*!40000 ALTER TABLE `one_to_ones` DISABLE KEYS */;
INSERT INTO `one_to_ones` VALUES
(6,1,37,31,NULL,NULL,NULL,'manual','2026-03-06 05:00:00',NULL,'2026-03-06 06:00:00','completed',NULL,NULL,NULL,'お互いのビジネスの紹介\nシステムと助成金で協業できそう。見積もりが作成できればOK','2026-03-23 12:47:04','2026-03-23 12:47:04'),
(7,1,37,42,NULL,NULL,NULL,'manual','2026-03-11 04:00:00',NULL,'2026-03-11 05:00:00','completed',NULL,NULL,NULL,'お互いのビジネス紹介','2026-03-23 12:48:50','2026-03-23 12:48:50'),
(8,1,37,44,NULL,NULL,NULL,'manual','2026-03-12 05:00:00',NULL,'2026-03-12 06:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kimura_kengo_mfg_retail.md#第1回】\n\n### 【第1回】2025-03-12\n\n#### 基本情報\n\n- **日時:** **2025-03-12** **JST 開始–終了 TODO**（旧メモに時刻未記載）\n- **実施方法:** **TODO**（対面 / オンライン）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **8**\n\n#### 話した内容（重要）\n\n- **要約（事実）:** 木村様会社はデニム雑貨・Tシャツプリントの **製造・販売**。受注〜顧客管理まで **紙ベース中心**。工場・店舗に分かれる体制。出荷には **クライアント納品** と **店舗補充** の二流れがある、という整理が付録に記載されている。\n- **詳細:** 以下 **付録** に旧ファイルの構成どおり **全文保存**（目次・各章）。\n\n#### プロフィールとの連動（補足）\n\n- **構造化・段階導入**という第1回の論点は、詳細プロフィールの **強み（現場が回っている／整理から入る）** と **矛盾なく接続**できる（**仮説**: 提案スタンスが「システム押し売りでない」ことを好む層と一致）。\n- BNI名簿の **メンターサポート** は、**現場と人のバランス**を取る題材として今後の1to1で聞ける（**会話の糸**）。\n- **シート連動:** 原氏の感謝文にある **「新しいツールを活用」** は、第1回の **業務デジタル化・見える化** 議論と **接続可能**（**仮説**: 社内オペレーションでもツール前向き）。\n- **シートの強み「プリント自社・小ロット」** と付録の **「出荷二系統・工場店舗」** は **同一会社の異なる切り口** — 紹介トークは **OEM観光ノベルティ** と **社内オペ効率** の両方を持てる。\n\n#### 抽出された課題（事実／付録より）\n\n- 情報共有・仕様変更履歴・製造進捗・在庫状況が **担当者の経験・記憶に依存しやすい** 可能性。\n- 紙運用からの脱却は **単純デジタル化ではなく業務構造化** が前提（付録 §2–§3）。\n\n#### 仮説（tugilo視点）\n\n- **仮説:** Phase1 から **受注・顧客・商品の一元化** が最優先になりやすい。**根拠:** 付録 §9 のフェーズ構想。\n- **仮説:** 店舗連携（Airレジ）は **後続** が妥当。**根拠:** 付録 §7・§9 Phase4。\n\n#### 次アクション\n\n- 現場見学・業務フロー整理・要件整理（付録 §13）。進んだら **第2回** に記録。\n\n---','2026-03-23 12:49:51','2026-06-24 15:48:12'),
(9,1,1,11,NULL,NULL,NULL,'manual','2026-03-16 02:00:00',NULL,'2026-03-16 03:00:00','completed',NULL,NULL,NULL,'お互いのビジネスの紹介','2026-03-23 12:51:50','2026-03-23 12:51:50'),
(10,1,37,10,NULL,NULL,NULL,'manual','2026-04-02 06:00:00',NULL,'2026-04-02 07:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kuramoto_kenichi_webmaster.md#第1回】\n\n### 【第1回】2026-04-02\n\n#### 基本情報\n\n- **日時:** **2026-04-02（水）**（開始・終了の時刻は **`one_to_ones` 登録** を正とする。未取得の場合は TODO）\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 10`\n\n**要点（保存用メモとの整合）:** ウェブマスター役割・エアコン本舗案件・開発チーム参画の可能性、4/13 の 1to1 打ち合わせ予定など。詳細は当該時点の DB メモ・過去整理稿を参照。\n\n---','2026-04-02 21:05:22','2026-06-23 22:46:24'),
(11,1,37,17,NULL,NULL,NULL,'manual','2026-04-02 22:15:00',NULL,'2026-04-02 23:15:00','completed',NULL,NULL,NULL,'#### 基本情報\n\n- **日時:** **2026-04-03（金）JST 07:15–08:15**（60分）。**取得元:** ユーザー確認（当日の1to1実績）。※過去の Zoom要約段階では日時未記載だったため、本項で確定。\n- **実施方法:** Zoom\n\n#### 話した内容（重要）\n\n※**削減せず**蓄積。以下は Zoom要約・当時の整理メモからの**記録**。\n\n- **主な流れ:** 次廣淳（AI・業務改善システム構築）と佐藤拓斗（高校生新卒採用コンサル）が BNI ドラゴンフライチャプターで **初回 1on1**。両者の事業内容を共有し、**テレアポリスト自動作成システム**の開発可能性について具体的検討を開始。静岡県藤枝市という地元の共通点から、今後の協力関係構築の基盤を確立した、との整理。\n- **決定・合意:**\n  - **リスト作成システムの検討開始:** 佐藤氏のテレアポリスト作成業務（現在手作業で **1時間100件**）を自動化するシステムについて、次廣氏が **技術的実現可能性を調査**。\n  - **求人媒体からのデータ取得:** リクナビネクスト等の求人サイトから、**従業員数30名以下** などの条件で自動抽出する仕組みを検討。**スクレイピング技術の活用**、ただし **法的リスクの確認が必要**。\n  - **5月中旬の再会:** 佐藤氏の静岡帰省時（**5月16–17日頃**）に **対面ミーティング** を設定する方向。\n- **次廣側で共有された事業内容:**\n  - **業務改善システム構築:** エクセル・スプレッドシートで分散管理されているデータを一元化し、リアルタイムでの進捗確認を実現。\n  - **LINE活用システム:** 問い合わせから見積もり、請求までを LINE 公式アカウントで完結させる仕組み（建設業向け）。\n  - **スタンプラリー・ビンゴシステム:** 静岡観光協会向けに **5年間運用中**。\n  - **施工管理・日報システム:** 名古屋のシーリング会社向けに、外国人労働者でも入力しやすい LINE ベースの業務日報システムを構築。\n  - **事業の特徴:** ゼロから1を作れる／既製ツールの押し付けではなく現場フローに合わせたカスタマイズ。**小さく始めて改善**（大規模を一気に入れず、入力から段階拡張）。**現場負担の最小化**（経営と現場のギャップを埋め、現場にベネフィットを与える設計）。\n  - **経歴・背景:** システム開発歴 **25–26年**（大学中退後一貫、現在 **52–53歳**）。BNI は増本氏・今西氏との静岡出世クラブでの **約10年の付き合い** から **2024年** にドラゴンフライ参加を決意。動機は技術一辺倒からの転換・仕事の幅拡大。**MSP（メンバーサクセスプログラム）** で学んだビジネススキルに感銘、トレーニング注力中。\n- **佐藤側で共有された事業内容（1to1上の詳細・プロフィールと照合可）:**\n  - **高校生新卒採用の仕組み構築:** ホームページ制作、パンフレット・動画制作、学校訪問代行、求人資料郵送代行まで一括。\n  - **4月依頼でも7月解禁に間に合う** 短期対応が可能。**全国対応**（BNI参加により全国展開が加速）。\n  - **ターゲット:** 従業員 **30名以下** が中心（プロフィールは **20〜30名以下** — 会話では30名以下条件でリスト抽出の話あり）。タイプ **3つ**: ①高校生採用のやり方が分からない ②やりたいが時間・人員不足 ③応募が来ない（我流で抜けがある）。業種: 建設業、製造業、自動車整備、ビルメンテナンス、清掃、介護福祉など。\n  - **実績:** **2024年度** 29社サポート、14社で採用成功（成功率 **約48%**）。**過去5年** 毎年40社以上サポート（2023年32社、2024年は50社近く）。\n  - **経歴・背景:** 事業歴 **5年**。新卒で高校生新卒採用コンサル会社に入社、**2024年3月に独立**（当時 会社設立から **1年** と共有）。学歴: 清水東高校→静岡大学→早稲田大学編入→早稲田大学大学院（**教員免許保有**）。**将来ビジョン:** 高校生以下を対象としたキャリア教育事業。**五教科と社会を結びつける授業** で子どもの将来の選択肢を広げたい。\n- **確認待ち（会話上の論点）:**\n  - リクナビネクストからのデータ取得: **技術的実現可能性** と **法的リスク（利用規約上の二次利用制限）** を次廣氏が調査中。\n  - Google マイビジネス API: 個人事業主リスト作成について、**二次利用禁止ルール** があり、公開情報からの取得方法を検討。\n- **共通点・シナジー:**\n  - **地元:** 両者とも静岡県藤枝市出身・在住。佐藤氏は藤枝市古利（西焼津小学校区）、次廣氏は青葉町（青島中学校区）。\n  - **教育への関心:** 次廣氏は娘の受験を控え、佐藤氏のキャリア教育理念（五教科と社会の結びつけ）に強く共感。\n  - **システム×採用:** 次廣氏は静岡県の大卒求人サイト **「三並び」** のアプリ開発を受注中。**大学生がメールを見ない** ため通知機能が必要、という課題を共有。\n- **アクションアイテム（当時の整理）:**\n  - 次廣氏: 求人媒体からのリスト自動作成システムの **技術調査・提案準備**。\n  - 佐藤氏: **5月中旬の静岡帰省日程確定後**、次廣氏に連絡。\n  - 両者: **名古屋出世クラブ（5月末）** への参加可能性を検討（今西氏が佐藤氏を誘致中）。\n- **次回ミーティング:** **5月16–17日頃**、佐藤氏静岡帰省時に **対面** で実施予定。\n- **プライベート文脈（会話に出た事実の記録・紹介判断とは分離）:** 婚活、飯田氏からの占い（**32歳で結婚** 等）、保険担当の高校同級生からの紹介の動きなどが要約に含まれる。**取り扱い注意。本人確認のうえ参照。**\n\n#### 抽出された課題（事実：会話で言及）\n\n- テレアポ用リスト作成の **手作業負荷**（約1時間100件ペース）。\n- 求人媒体からの自動取得は **技術** に加え **利用規約・法的リスク（二次利用）** の確認が必要、との合意。\n- Google マイビジネス／公開情報は **二次利用禁止** の話題があり、個人事業主リストは **取得経路の設計** が課題。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** リスト作成が **コンサル本業とリソース競合** している。**根拠:** 手作業1時間100件の共有。**構造（仮説）:** リード前処理が属人・手作業 → 営業・提案に振る時間が圧迫 → スケールしにくい。\n- **課題②:** データ取得は **「作れるか」より「取ってよいか」** が先に決まる。**根拠:** スクレイピング・API の **法的リスク確認** が合意事項。**構造（仮説）:** 技術要件とコンプライアンスが分離できないと、開発が進んでも運用不能になりうる。\n- **シナジー:** 「採用」周辺に **通知・進捗・フォロー** のデジタル化が横展開しうる。**根拠:** 三並び案件で **メールを見ない大学生** と通知ニーズの共有。**仮説**としての展開可能性。\n\n#### 次アクション\n\n- 次廣: 技術調査・法務・規約リスク整理・提案準備。\n- 佐藤: 帰省日程確定後に連絡 → 5/16–17頃 対面設定。\n- 双方: 名古屋出世クラブ（5月末）参加の検討。','2026-04-07 03:35:52','2026-04-13 14:11:46'),
(12,1,37,136,NULL,NULL,NULL,'manual','2026-04-08 09:00:00','2026-04-08 09:00:00','2026-04-08 10:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_yonezawa_yuka_comechan_design.md】\n\n# 1to1整理：米澤 侑桂（Comechan Design）\n\n---\n\n**文書の位置づけ:** BNI DragonFly の **ビジター／見込み** に対し、「協業可能性の検討」と「次アクション明確化」を目的とした整理。**単なる議事録ではなく**、tugilo 視点（課題発見・価値提供・仕組み化）でまとめた。**§10〜14** は **2026-04-08 時点で確定した協業内容・案件・スキル・稼働・成功要因**（要約入力ベース）。**§15〜18** は **それ以前に作成した再現用ナレッジ**（ヒアリング構成・台本・改善・施策）；**§15〜16 のドラフト**は、今回の合意後も **別種の1to1用テンプレ** として残す。**更新箇所**は見出し付近の **【2026-04-08 更新】**、または本文での **「当初仮説／実際の会話で判明」** の対比で明示。\n\n---\n\n## 1. 基本情報\n\n**【2026-04-08 更新】**\n\n- **日付（ドキュメント・協業要約反映）:** **2026-04-08**\n- **第1回 1to1 実施日時（JST）:** **2026-04-08（水）09:00–10:00**（**1時間**）\n- **Religo 1to1 レコード:** `one_to_ones.id = 12`（**1セッション＝DB 1行**）\n- **相手名:** 米澤 侑桂（よねざわ ゆか）\n- **事業内容:** Web デザイン〜**コーディング・実装まで一貫**（**2026-04-08 1to1 で確認**）\n- **現在のステータス（BNI）:** **ビジター**（シート上の経緯は以下も参照）。**オリエン:** 2026-04-07 実施（太田氏）。**協業（tugilo×米澤）:** **合意済み**（別レイヤーで管理）\n\n---\n\n## 2. 1to1の要約（サマリ）\n\n**【2026-04-08 更新】**\n\n- **主な成果:** 米澤は **デザインからコーディング・実装まで一貫対応可能** な Web デザイナー兼エンジニアであることを **確認**。次廣は **来週契約予定の「学生向け求人サイト」アプリ化案件**において、**フロント部分のデザインとコーディングを米澤に依頼する方向で合意**した。\n- **協業の位置づけ:** 「検討」ではなく **協業開始の合意**（範囲・単価帯・次工程は **来週以降の契約・打ち合わせで確定**）。\n- **並行案件:** **古紙回収** の LINE アプリ用 **リッチメニュー 2 件**（法人用・個人用）を米澤に依頼することを **決定**。\n- **価格:** リッチメニュー **4,000〜5,000 円／枚**、LP は **規模に応じた工数ベース見積もり**（**2026-04-08 合意**）。\n- **補足（過去の第三者メモ等）:** 福上氏・廣田氏・倉持氏メモにあった「コスパ・反応率・コーディング可」等は **引き続き有効な背景情報**。BNI 入会は別論点（§7 参照）。\n\n---\n\n## 3. 相手のビジネス理解（As-Is）\n\n### 3.1 提供サービス\n\n- **Web:** LP 制作、サイト制作、画像・バナー、印刷物デザイン（ポートフォリオ・過去情報）\n- **プロセス:** お問い合わせ後の返信 SL（2営業日）、ヒアリング、制作、確認／修正、納品・公開（[サービスの流れ・料金](https://comechan-design.com/flow-services-fees/)）\n- **【2026-04-08 更新】1to1で確認:** デザインに加え **コーディング・実装・ディレクション**まで対応可能。**資料・ロゴ等も依頼に応じて対応**（「基本何でも対応」方針）\n\n### 3.2 強み\n\n- **実績・評価:** 協業パートナーとして「コストと品質のバランス」「デザイン連携に推薦」という紹介メモあり\n- **他との違い:** 「かっこいい・可愛い」だけでなく **反応率・成果** にフォーカスするデザイン、とのメモあり\n- **【2026-04-08 更新】1to1で確認:** **Tailwind CSS**、**JavaScript フレームワーク（React Native 含む）** の実装経験、**レスポンシブ**、**アプリデザイン経験**（例：マッチングアプリでデザイン・ディレクター）。**AI 活用:** Claude Code、ChatGPT、Gemini でコーディングの統一化・効率化\n\n### 3.3 案件の特徴\n\n- **クライアント層:** 中小〜法人向け Web／LP 需要\n- **単価・ボリューム:** **2026-04-08 合意:** リッチメニュー **4,000〜5,000 円／枚**、LP は **工数ベース**。**短納期例:** 1 週間で Studio 上 LP（デザイン＋コーディング同時進行・約 20 時間）。**通常:** デザイン＋コーディングで **約 3 週間** 程度\n\n---\n\n## 4. 課題・ボトルネック（Fit & Gap視点）\n\n### 4.1 現在の課題（As-Is）\n\n- **当初仮説（CRM・オリエン前）:** クライアント案件中心で **4〜5月は時間が取りにくい**、属人的オペレーション\n- **【2026-04-08 更新】実際の会話で判明:** 昨年は **Web 講師業務**で多忙だったが、**現在は卒業し余裕が出ている**。**業務委託先 2 社と継続契約**（クラウドワークス経由で獲得、**2 年以上継続**）。**定常の業務委託より、個人案件で一緒に作り上げる仕事を増やしたい**意向\n- **詰まっている業務・非効率:** 求人サイト案件では **メール開封率の低さ** → **プッシュ通知**で解消する設計が論点（§11）。詳細仕様は **来週以降の契約・打ち合わせ後** に詰める\n\n### 4.2 理想状態（To-Be）\n\n- **望む働き方:** **長期的なクライアント関係**・**量より質**（当初メモの要旨）\n- **【2026-04-08 更新】** **個人案件として共同で作る仕事**を増やしたい（tugilo 案件との協業と方向性が一致）\n\n### 4.3 ギャップ\n\n- **当初:** マーケ仕組みまで一気通貫はリソース不足しがち、と整理\n- **【2026-04-08 更新】** ギャップは **案件単位で解消に動いている**（フロントは米澤、基盤・通知・アプリは次廣側で分担予定）。**残る論点:** **Flutter / React Native**、**WebView 実装**の最終選定（保留）\n\n---\n\n## 5. tugilo視点での価値提供可能性\n\n**【2026-04-08 更新】**\n\n- **確定案件ベース:** **学生向け求人サイト** — 既存 **PHP ベース Web** を **WebView でアプリ化**、**プッシュ通知**で **メール未到達**を補う。**次廣:** アプリ基盤・契約・バックエンド／通知周り。**米澤:** **フロントのデザイン・コーディング**（合意済み）。\n- **LINE:** **古紙回収** LINE アプリの **リッチメニュー 2 枚** — 次廣が要件提示、米澤が制作（単価レンジ合意済み）。\n- **抽象からの落とし込み:** 「計測・フォーム連携」一般論に加え、上記 **2 案件** を **そのまま SOW に落とす**ことが次ステップ（§8・§11）。\n\n---\n\n## 6. 協業パターン整理（具体案）\n\n### 確定協業パターン（2026-04-08 時点）\n\n| 項目 | 内容 |\n|------|------|\n| **体制** | 次廣の **システム開発案件**に、米澤が **デザイン・コーディング・実装（フロント）** を担当する形で **協業開始に合意** |\n| **案件①** | **学生向け求人サイトアプリ化** — フロントのデザイン＆コーディングを **米澤へ依頼する方向で合意**（**来週契約**予定のプロジェクト） |\n| **案件②** | **古紙回収 LINE** — リッチメニュー **2 件**（**法人用・個人用**）を米澤へ **依頼決定** |\n| **価格** | リッチメニュー **4,000〜5,000 円／枚**、**LP** は **規模に応じ工数ベース見積もり** |\n\n### パターンA：案件分担型（当初案・参考）\n\n- **内容:** 米澤 **デザイン＋コーディング**／tugilo **フォーム・DB・通知・集計** — **→ 実案件ではこの型で進行する見込み**（§10 参照）\n\n### パターンB：共同提案型（当初案・参考）\n\n- **内容:** 「LP＋改善プラン」等 — **並行して**中長期で使えるテンプレ。**今回の合意案件とは別枠**で検討可\n\n### パターンC：紹介連携型（当初案・参考）\n\n- **内容:** 福上氏・西浦氏経由のパートナー固定 — **関係継続用**。**確定協業**（上表）が最優先の実行単位\n\n---\n\n## 7. 相性評価（重要）\n\n| 観点 | 評価 | メモ |\n|------|------|------|\n| **スキル相性** | **◎** | **2026-04-08:** デザイン〜実装一貫・Tailwind／RN 経験等を **会話で確認**。フロント分担が明確 |\n| **価値観相性** | **◎〜○** | **個人案件で共創**を増やしたい意向と、tugilo 側の案件が接続 |\n| **コミュニケーション** | **○** | **合意に至った**。**保留**は仕様・技術選定のみ（§11） |\n| **パートナー適性** | **◎（案件上）** | **協業が具体案件に落ちた**。BNI 入会は別 KPI |\n\n---\n\n## 8. 次アクション（必ず明確化）\n\n**【2026-04-08 更新】**\n\n### 次廣（tugilo）がやること\n\n| 期限目安 | 内容 |\n|----------|------|\n| **来週（契約締結後）** | **学生向け求人サイトアプリ化**の **具体仕様**を米澤と **再度打ち合わせ**（契約・社内手続き後の最初の工程として実施） |\n| **至急** | **古紙回収 LINE リッチメニュー 2 件**について、**要件（文言・導線・ブランドトーン・サイズ制約）** を米澤に **共有** |\n| **運用** | Religo の **1to1 レコード**に **第1回: 2026-04-08 09:00–10:00（JST）** を **`started_at` / `ended_at`** で登録。**`notes`** に本要約の要点を転記 |\n\n### 米澤がやること\n\n| 期限目安 | 内容 |\n|----------|------|\n| **要件受領後** | リッチメニュー **2 件**の **制作・納品**（単価は **4,000〜5,000 円／枚** で合意済み — **最終見積は枚数・修正回の条件で確定**） |\n| **詳細打ち合わせ後** | 求人サイトアプリ化の **フロント見積・スケジュール**を提示 |\n\n### 次回ミーティング\n\n- **来週以降:** **学生向け求人サイトアプリ化**の **詳細打ち合わせ**（**契約打ち合わせ完了後**が前提）\n\n---\n\n## 9. メモ・気づき\n\n- **【2026-04-08 更新】** **協業が「具体案件＋単価レンジ」まで到達** — 当初の「メンバー化より先に協業実績」の方針と整合\n- **印象的な点:** **短納期 LP（1 週間・約 20h）**、**太田氏案件でコーディング専任 2 件** — BNI 内連携の実績あり\n- **BNI視点:** ビジター枠と **案件パートナー枠** は分けて管理（混同しない）\n\n---\n\n## 10. 実績ベースの協業内容\n\n**【2026-04-08 新規】**\n\n| 項目 | 確定内容 |\n|------|----------|\n| **協業体制** | 次廣の **システム開発案件**において、米澤が **デザイン・コーディング・実装（フロント中心）** を担当する形で **協業開始に合意** |\n| **担当分担** | **次廣:** プロジェクト全体・契約・アプリ／通知／WebView 側の実装方針。**米澤:** **フロントのデザインとコーディング**（求人サイトアプリ化）。**リッチメニュー:** 米澤が **制作**、次廣が **要件提示・運用コンテキスト（古紙回収 LINE）** |\n| **案件内容（合意済み）** | ① **学生向け求人サイトアプリ化**（フロント依頼）② **古紙回収 LINE リッチメニュー** 法人・個人の **2 件** |\n| **価格感** | **リッチメニュー:** **4,000〜5,000 円／枚**。**LP:** **規模に応じ工数ベース**（案件ごと見積もり） |\n\n---\n\n## 11. プロジェクト詳細\n\n**【2026-04-08 新規】**\n\n### 11.1 学生向け求人サイトアプリ化\n\n| 項目 | 内容 |\n|------|------|\n| **背景** | 既存 **PHP ベース Web サイト**を **WebView 形式でアプリ化**。**メール開封率の低さ**を補うため **プッシュ通知**を実装 |\n| **技術スタック** | **WebView ベース**で iOS／Android。**Flutter 採用を検討中**（**React Native** との **最終選定は保留**） |\n| **納期・公開** | **オープン予定: 2026年4月**（入力メモに「2025年4月」の表記あり — **年度誤記の可能性大**。**カレンダー上は 2026-04 を正として要確認**）。**段階的リリース**で機能追加 |\n| **デザイン要件（合意・方向性）** | 画面下部に **リッチメニュー風ナビ**（ホーム、マイページ等）＋ **Web 画面表示** |\n| **保留** | **具体仕様**は **来週以降の契約打ち合わせ後**に詰める。**Flutter / RN**、**WebView の実装方法**は **技術選定として別途協議** |\n\n### 11.2 古紙回収 LINE — リッチメニュー 2 件\n\n| 項目 | 内容 |\n|------|------|\n| **概要** | 次廣が運営する **古紙回収** の **LINE アプリ**用リッチメニュー **法人用・個人用** の **2 件** |\n| **決定事項** | 米澤への **依頼を決定**。単価 **4,000〜5,000 円／枚** |\n| **次アクション** | 次廣が **具体要件を共有** → 米澤が **制作** |\n\n---\n\n## 12. スキル・評価（実証ベース）\n\n**【2026-04-08 新規】**（1to1で確認した内容のみ）\n\n- **技術範囲:** **デザイン、コーディング、実装、ディレクション**まで **一貫対応可能**（本人確認）\n- **スタック・経験:** **Tailwind CSS**、**JavaScript フレームワーク（React Native 含む）**、**レスポンシブ**、**アプリデザイン経験**（例：**マッチングアプリ**でデザイン・ディレクター）\n- **対応スタイル:** **「基本何でも対応する」** — 資料作成・ロゴ等も **依頼に応じて対応**\n- **AI 活用:** **Claude Code、ChatGPT、Gemini** でコーディングの **統一化・効率化**\n- **案件実績（会話ベース）:** **1 週間**で Studio 上 **LP**（デザイン＋コーディング同時進行・**約 20 時間**）。**通常** デザイン＋コーディング **約 3 週間**。**太田氏**から **デザインデータのみ**受領し **コーディングのみ**した案件 **2 件**\n\n---\n\n## 13. 稼働状況\n\n**【2026-04-08 新規】**\n\n- **業務委託:** **2 社**と **継続契約中**（**クラウドワークス**経由で獲得、**2 年以上**）\n- **稼働:** **昨年**は **Web 講師**で多忙 → **現在は卒業し余裕**が出ている\n- **方向性:** **業務委託の定常業務より**、**個人案件で一緒に作り上げる仕事**を増やしたい\n\n---\n\n## 14. 成功要因分析（重要）\n\n**【2026-04-08 新規】**\n\n1. **スキル境界の明確化:** 「デザインだけでなく **実装まで**」を **会話で実証**でき、次廣側の **フロント外注** にそのまま載せられた。\n2. **案件の具体度:** 「いつか協業」ではなく、**来週契約予定の求人サイト案件**と **単価決定済みのリッチメニュー**があり、**SOW に落としやすい**。\n3. **単価レンジの合意:** リッチメニュー **4,000〜5,000 円／枚**、LP **工数ベース**で **認識齟齬を先に潰した**。\n4. **志向の一致:** 米澤の **個人案件で共創したい**と、tugilo 側の **外注パートナー需要**が一致。\n5. **保留の切り分け:** 仕様・**Flutter/RN** は **保留にしたまま**、**フロント依頼とリッチメニュー**は **決められた** — 決められるところから進める形。\n\n---\n\n## 15. 1時間ヒアリング構成（実施ベース・再現用ドラフト）\n\n### 15.0 実施状況（事実／未実施の切り分け）\n\n| 区分 | 内容 |\n|------|------|\n| **事実** | **第1回 1to1:** **2026-04-08 JST 09:00–10:00**。協業合意・要約を本文に反映済み |\n| **参照できた事実** | **第三者** の対応履歴メモ（倉持氏 等）は、**背景理解**に有用 |\n| **§15.1 の扱い** | **次回** 別相手／別回で **同品質のヒアリング**をするための **推奨タイムライン（ドラフト）** |\n| **§15.2 の扱い** | (A) 第三者メモからの型 (B) **次回**用の質問表。**今回の合意後**、(B) の一部は **§12 で事実化済み** |\n\n---\n\n### 15.1 タイムライン\n\n**【ドラフト・次回1to1用】協業仮説の検証に最適化した 60 分**\n\n- **0〜10分：** アイスブレイク、**今日の目的の合意**。BNI はプレッシャーをかけない。\n- **10〜30分：** **仕事の型** — 案件の流れ、得意ジャンル、デザインとコーディングの **役割分担**。\n- **30〜45分：** **ボトルネックと理想** — 成果の見せ方、tugilo の価値を **1例** で提示。\n- **45〜60分：** **協業の切り口**を **1つに絞る**、次の一手・次回接触日。\n\n※ **実1to1の文字起こしがある場合**、各帯を **事実** で上書きし、**§2・§10** と整合させる。\n\n---\n\n### 15.2 実際に効果的だった質問\n\n#### (A) 第三者対応履歴から見える「深掘りの型」（事実：メモに結果が残っている）\n\n（変更なし — 倉持氏メモ等の分析）\n\n#### (B) 次回 tugilo が使う推奨質問（未確認／ヒアリングで埋める）\n\n※ **2026-04-08 時点で §12・§11 に一部回答済み**。残りは案件進行中に更新。\n\n| 質問内容（例） | 相手の反応（記入予定） | 得られた気づき（記入予定） |\n|----------------|------------------------|----------------------------|\n| 納品後の効果の見せ方 | **§12 参照** — 必要なら案件ごとに追記 | |\n| 協業時の窓口 | **次回打ち合わせで確定** | |\n| Flutter/RN・WebView | **保留**（§11.1） | |\n\n---\n\n## 16. 1to1台本（再現用）\n\n**【ドラフト】** 同種の相手（デザイン事業・ビジター・多忙・協業検討）に転用可。**丸暗記ではなく「抜けたら戻る目印」** として使う。実施後、**実際の言い回し** で差し替え。\n\n### 16.1 導入\n\n**台本（例）：**\n\n「今日は時間を取っていただきありがとうございます。僕は **業務改善とシステム** をやっていて、デザイン会社さんとは **フロントの外側—計測やフォーム連携** でよく組んでいます。今日は **米澤さんの仕事の流れと、一緒に案件が作れるか** を知りたくてきました。BNI の入会とかは今日決めなくて大丈夫です。」\n\n### 16.2 深掘りパート（テーマ別）\n\n#### ■ 仕事理解\n\n| | 内容 |\n|---|------|\n| **質問** | 「よくある案件の流れを、お客さんが来てから納品まで **15分で** 教えてもらえますか？」 |\n| **想定される回答** | 問い合わせ → 返信 → ヒアリング → 制作 → 修正 → 納品（サイトの [サービスの流れ](https://comechan-design.com/flow-services-fees/) と整合） |\n| **深掘り質問** | 「その中で **米澤さんの手が一番止まる** のはどこですか？」「**パートナーに出す／全部やる** の線引きは？」 |\n\n#### ■ 強み\n\n| | 内容 |\n|---|------|\n| **質問** | 「紹介で選ばれるとき、**何と言われますか？**（コスパ、反応率、トーンなど）」 |\n| **深掘り** | 「**デザインだけ** の案件と **実装まで** の案件の比率は？」「逆に **やらない** 仕事は？」 |\n\n#### ■ ボトルネック\n\n| | 内容 |\n|---|------|\n| **質問** | 「今いちばん **忙しいのは案件のどのフェーズ** ですか？ お客さんの **成果の説明** で困ることはありますか？」 |\n| **深掘り** | 「**計測** は誰が見ますか？ **フォームの問い合わせ** はどこに溜まっていますか？」 |\n| **→ tugiloの関与余地** | 「納品後の **数字の見える化** と、**問い合わせ〜社内の一元化** はこちらでよく組みます。**デザインは米澤さん、仕組みは僕** でパッケージにすると、お客さんに **セットで説明しやすい** です。」 |\n\n#### ■ 将来\n\n| | 内容 |\n|---|------|\n| **質問** | 「**1年後**、お客さんとの関係で **増やしたいもの／減らしたいもの** はありますか？」 |\n| **深掘り** | 「BNI は **紹介の幅** 目的ですか、それとも **学び** 目的ですか？ **無理のない頻度** はどのくらいですか？」 |\n\n#### ■ 協業導線\n\n| | 内容 |\n|---|------|\n| **自然な切り出し** | 「もしよければ **LP1本を想定** に、**納品後3ヶ月だけ** 計測と改善の枠を付けたとき、**米澤さんの見積もりの置き方** はどうなりますか？ 僕側は **◯万から** のイメージで…（※実数値は別紙）」 |\n| **相手の反応** | **2026-04-08 以降:** 合意の事実は **§8・§10** を正とする |\n\n### 16.3 クロージング\n\n| | 内容 |\n|---|------|\n| **次に繋げる一言（例）** | 「今日の話を踏まえて **A4一枚の分担図** を作ります。**◯日まで** に共有して、**15分だけ** フィードバックもらえますか？ 忙しければ **6月** でも大丈夫です。」 |\n| **実際の反応** | **2026-04-08 以降:** 合意内容は **§8・§10** を正とする |\n\n---\n\n## 17. 会話改善ポイント\n\n### 17.1 良かった点\n\n- **第三者メモから見える「話しやすさ」の要因（推定）:** 仕事の話に **具体名（協業先・関係者）** が出ると、**シーンが浮かぶ**（倉持氏メモのパターン）。tugilo も **紹介者名・案件タイプ** を1つ聞くと同効果が狙える。\n- **深掘りできた理由（参考）:** 「デザインだけでなく **どこまでやるか**」「**件数と関係性**」の **二軸** がメモに残っている → tugilo も同じ二軸で **聞き漏れ** を防ぐ。\n\n### 17.2 改善点\n\n- **詰まりやすい箇所（想定）:** **入会・BNI** の話が前に出すぎると、協業の時間が削られる → **冒頭で目的を言い切る**（§16.1）。\n- **聞ききれていない内容（案件で埋める）:** **§11 保留**（仕様・Flutter/RN）— **契約後の打ち合わせで確定**。**§15.2 (B)** の表と突合。\n\n---\n\n## 18. 協業確度アップ施策\n\n今回の **§10〜14** で **協業は具体化済み**。以下は **継続的な関係強化**用。\n\n### 案件化のための一手\n\n- **求人サイト:** 契約後 **SOW・画面遷移・納品物定義** を共有し、**見積・マイルストーン**を固定\n- **リッチメニュー:** **要件書 1 枚**（サイズ、文言、画像、リンク先）を先に渡す\n\n### 関係構築の次ステップ\n\n- **紹介者ルート:** 西浦氏・福上氏への **進捗共有**（一文）\n- **BNI内:** ビジター／名刺希望は **§1・シート** に従い **本人ペース**\n\n### タイミング戦略\n\n- **技術選定:** **Flutter vs RN** — **次回技術打ち合わせ**で決定表を残す\n- **Religo運用:** **`one_to_ones.notes`** に **その回の事実** を記録。本ファイルの **§2・§8・§10** と **二重管理しない**（SSOT は本ファイルまたは Religo のどちらかを決める）\n\n---\n\n## 文書変更ログ\n\n| 日付 | 内容 |\n|------|------|\n| 2026-04-08 | 初版。参加者シート・対応履歴・[サービスの流れ・料金](https://comechan-design.com/flow-services-fees/) に基づき協業整理テンプレで作成。tugilo 直接1to1の日時は未記録 |\n| 2026-04-08 | §10〜13 追加：1時間構成（※実1to1未入手のためドラフト）、第三者メモからの質問の型、再現用台本、改善ポイント、協業確度アップ施策。YAML に `interview_script_status` |\n| 2026-04-08 | 要約入力に基づき **協業合意を反映**。**新 §10〜14**（実績協業・プロジェクト詳細・スキル・稼働・成功要因）。旧 §10〜13 を **§15〜18** に繰り下げ。**§2・4・5・6・7・8・9** 更新。YAML `collaboration_status`・`collaboration_agreement_recorded_at`・`sources_note` 更新 |\n| 2026-04-08 | **第1回 1to1 実施日時を確定:** **JST 09:00–10:00**。YAML `first_session_date` / `first_session_time_jst`、§1・§15.0・§8 運用行を更新 |','2026-04-08 01:09:53','2026-06-04 10:53:02'),
(13,1,37,19,NULL,NULL,NULL,'manual','2026-04-08 11:00:00',NULL,'2026-04-08 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_hirayama_mayumi_lifesupport.md#第1回】\n\n### 【第1回】2026-04-08\n\n#### 基本情報\n\n- **日時:** **2026-04-08（水）JST 11:00〜**（終了時刻・取得元は **TODO**：カレンダー／Zoom で確定後に本項を更新）\n- **実施方法:** Zoom（要約ベースの記録）\n- **Religo 1to1 レコード:** `one_to_ones.id = 13`（**1セッション＝DB 1行**）\n\n以下、**クライアント共有用**の議事録体裁（tugilo式）。\n\n#### ■ 概要\n\n- **日時:** 2026年4月8日（水）11:00〜（JST）\n- **参加者:** 次廣 淳、平山 真由美 様\n\n#### ■ 主な成果\n\n- 次廣はパスポートプログラムをほぼ完了し（メンバーシップ分を除く）、今後の活動の土台を整えた。\n- 倉本氏の業務負荷軽減を目的に、ウェブマスター業務をシステム面から支援する方針で合意した。\n- 平山様のシングルマザー支援事業とカーマッチとの提携構想を共有し、協業の可能性を複数確認した。\n\n#### ■ 決定事項・合意内容\n\n- **ウェブマスター支援:** 次廣がシステム面を中心にサポートし、業務負荷を分散する。\n- **40人リスト:** 平山様よりテンプレートを提供し、リファラル創出を強化する。\n- **車屋の紹介:** 次廣より静岡の車屋2名を紹介し、カーマッチとの連携可能性を検討する。\n- **中小企業診断士の紹介:** 平山様より神山氏を紹介する（ビジター招待も検討する）。\n\n#### ■ フィードバック・示唆\n\n- メンターはタスク説明にとどまらず、BNIの価値を伝えながら伴走することが重要である。\n- 新入会員に限らず、全会員への支援意識が求められる。\n- プロフィールシートでは「不適切なリファラル」は削除し、「金の卵」には将来的にツール導入意欲のある見込み顧客を記載する。\n- システム導入は大規模開発一括ではなく、最も困っている部分から小さく始め、段階的に改善するのが現実的である。\n- トレーニングは1日2件以上を避け、理解と定着を優先したペースがよい。\n\n#### ■ 確認事項（保留）\n\n- プロフィールシートの「コンタクトサークル」記入（上位3業種）の扱い。\n- 静岡の車屋2名について: 在庫保有状況、ホームページの有無、平山様顧客への販売適合性。\n\n#### ■ アクションアイテム\n\n##### ▼ 平山 真由美 様\n\n- 40人リスト用テンプレートの送付（期限: 来週月曜日）\n- 神山氏（中小企業診断士）の紹介およびビジター招待の検討（期限: 協議のうえ設定）\n\n##### ▼ 自分（次廣）\n\n- 静岡の車屋2名へ連絡し、在庫・ホームページ・顧客適合性を確認する（期限: 速やかに）\n- カーマッチとの提携可否を検討する（期限: 協議のうえ設定）\n- パスポートプログラムのメンバーシップを完了する（畑氏と対応／期限: 来週月曜日）\n- 倉本氏とウェブマスター業務の具体的内容をすり合わせる（期限: 協議のうえ設定）\n\n#### ■ 協業機会（あれば）\n\n- 美容業界向け: 予約・問い合わせの自動化をサブスク型で提供する構想。\n- LステップとAI連携による問い合わせ対応の自動化（チャットボット等）。\n- カーマッチとシングルマザー支援の連携（車両販売とスポット業務提供の仕組み）。\n- 福利厚生システムとドラゴンフライ連携を想定した、美容業界向けの共同開発。\n\n#### ■ 次回予定\n\n- リージョンフォーラム（**2026年11月9日**）にて対面で連絡予定。\n\n---','2026-04-13 14:14:45','2026-06-23 22:46:24'),
(14,1,37,10,NULL,NULL,NULL,'manual','2026-04-13 11:00:00',NULL,'2026-04-13 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kuramoto_kenichi_webmaster.md#第2回】\n\n### 【第2回】2026-04-13\n\n#### 基本情報\n\n- **日時:** **2026-04-13（月）JST 11:00–12:00**\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 14`（**1セッション＝DB 1行**。第1回は id 10）\n\n以下、**クライアント共有用**の議事録体裁（tugilo式）。\n\n#### ■ 概要\n\n- **日時:** 2026年4月13日（月）11:00〜12:00（JST）\n- **参加者:** 次廣 淳、倉持 賢一 様\n\n#### ■ 主な成果\n\n- 次廣のシステムエンジニアとしての経験および AI 活用スキルが、DragonFly における事業展開に有効であることを確認した。\n- 倉持様より、業務システム構築・顧客管理のシステム化・コーディング案件など、複数の具体的な協業機会が提示され、連携の方向性が明確になった。\n- 次廣の強み（現場に寄り添った設計・小さく始めるアプローチ・属人化解消）が評価され、今後の案件参画の可能性が高まった。\n\n#### ■ 決定事項・合意内容\n\n- **ITウェブパワーチームへの参加:** 倉持様より Facebook グループへ招待する（約500名規模）。\n- **ジオロケーションテクノロジー社の紹介:** 坂木氏（IPデータ・アクセス解析サービス提供）を紹介予定。\n- **双葉企画との連携検討:** デザイナー約100名規模の体制を活用し、システム案件のフロントとして協業を検討する。\n- **ロジカルシンキング講座の紹介:** 佐藤正夫氏の講座（10月開始予定）を、タイミングを見て案内する。\n\n#### ■ フィードバック・示唆\n\n- **次廣の強み:** 業務フローに沿った現場負担の少ない設計、小さく始めて段階的に改善するアプローチ、属人化を解消する仕組み化の実績。\n- **今後の成長ポイント:** 提案内容の解像度をさらに高めること、法人化やポジショニングの明確化、フロントに立つパートナーの選定。\n- **AI 活用の価値:** 提案スピード・単価向上と顧客負担軽減の両立が実現できている点が強み。\n\n#### ■ 確認事項（保留）\n\n- **エアコン会社案件:** 来週提案予定。受注後は5月頃から要件定義フェーズに参画する可能性あり。\n- **Excel 顧客管理のシステム化:** 代理店管理（500人超）の限界改善のため、DB 化提案を検討中。\n- **コーディング業務:** LP 制作等の軽案件での協力依頼の可能性。\n- **都内対面イベント:** 双葉企画など関係者との対面紹介を検討。\n\n#### ■ アクションアイテム\n\n##### ▼ 倉持 賢一 様\n\n- ITウェブパワーチームへ招待する（期限: 速やかに）\n- 坂木氏（ジオロケーションテクノロジー社）を紹介する（期限: 協議のうえ設定）\n- エアコン会社への提案を実施する（期限: 来週）\n\n##### ▼ 自分（次廣）\n\n- N-CAS 用の自己紹介資料をブラッシュアップする（提案解像度の向上）（期限: 協議のうえ設定）\n- 法人化およびポジショニングを検討する（期限: 協議のうえ設定）\n\n#### ■ 協業機会（あれば）\n\n- **業務システム構築（エアコン会社）:** 要件定義からの参画の可能性あり。\n- **顧客管理システムの再設計:** Excel 運用からの脱却（データベース化）。\n- **制作×システムの分業体制:** 双葉企画との連携によるフロント・制作分離。\n- **スポット開発案件（LP 等）:** 小規模案件から関係構築。\n\n#### ■ 次回予定\n\n- 未定（エアコン会社案件の進捗に応じ、**5月頃**に連携開始予定）。\n\n---','2026-04-13 23:18:48','2026-06-23 22:46:24'),
(15,1,37,49,NULL,NULL,NULL,'manual','2026-04-13 14:30:00',NULL,'2026-04-13 15:30:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_funatsu_mariko_aicare_lab.md#第1回】\n\n### 【第1回】2026-04-13 実施済み（正式時刻は TODO 確認）\n\n#### 基本情報\n\n- **日時:** **2026-04-13（月）JST 14:30–15:30**（既存記録）。ただし、今回提供のZoom要約タイトルは **2026-04-13 15:37(GMT+9:00)** のため、正式時刻は要確認。\n- **実施方法:** Zoom\n- **参加者:** 次廣 淳、船津 麻理子\n- **Religo 1to1 レコード:** `one_to_ones.id = 15`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 船津さんは、アイケアラボとして予防眼科・視力回復トレーニングを提供している。単なる目のマッサージではなく、低周波施術によるリハビリ、ホームケア指導、パーソナルトレーニングを組み合わせる点が特徴。\n- 次廣は、AI活用・業務改善・システム構築を専門とする個人事業主SEとして、Excel・スプレッドシート運用が限界に近い中小企業やフランチャイズ事業者向けに、現場に合わせた小規模スタートのシステム構築を行っている。\n- 両者は同じ BNI DragonFly メンバーとして、紹介できる相手、紹介してほしい相手、DragonFly 内での協業可能性、フランチャイズ本部へのシステム化提案の可能性を確認した。\n\n**主な成果**\n\n- 船津さんのアイケアラボ事業と、次廣のシステム構築事業について相互理解が深まった。\n- 具体的な紹介先候補として、藤本氏（税理士）、秋田の財務コンサル、関東圏の眼科医を確認した。\n- 次廣は、船津さんのフランチャイズ本部に対するシステム化提案に強い関心を示した。\n- 船津さんは、次廣の顧客管理システム、特に1on1記録・ブレイクアウトルーム管理・PDF自動取込の仕組みに興味を持ち、エヌキャスでの販売可能性にも言及した。\n\n**決定事項・合意内容**\n\n- **紹介先の相互確認:** 船津さんは藤本氏（税理士）と秋田の財務コンサルタントを、次廣に紹介できるか確認する。\n- **眼科医の紹介検討:** 次廣は、脳神経外科医経由で関東圏の眼科医を船津さんに紹介できるか確認する。\n- **システム化の方向性:** 船津さんのフランチャイズ本部に対し、次廣がシステム化提案を行う可能性を確認した。\n- **顧客管理の軽量版:** 船津さん自身の1on1記録整理にも、次廣の顧客管理システムの簡易版が役立つ可能性がある。\n\n**交換されたフィードバック**\n\n次廣から船津さんへ:\n\n- アイケアラボの予防眼科コンセプトと、視力回復の仕組みに強い関心を示した。\n- 施術が単なるマッサージではなく、リハビリとトレーニングを組み合わせた仕組みである点を高く評価した。\n- 名刺デザインで「視力0.1の見え方」を表現している工夫を称賛した。\n\n船津さんから次廣へ:\n\n- プロフィールシートの充実度と、ワークショップでの高評価を称賛した。\n- 次廣の顧客管理システム、特に1on1記録・ブレイクアウトルーム管理の完成度に驚き、エヌキャスでの販売可能性を提案した。\n- 増本氏のフランチャイズ管理システム構築実績を評価した。\n\n**次廣側の事業概要**\n\n- **専門分野:** AI活用、業務改善、システム構築。個人事業主SEとして20年以上の経験。\n- **強み:** 現場に合わせて小さく始めるシステム構築。既存ツールを押し付けず、業務に合わせて伴走しながら育てる。\n- **実績:** 増本氏のフランチャイズ管理システム（200店舗から500店舗への拡大対応）、LINE公式アカウント連携、スタンプラリーシステムなど。\n- **顧客管理:** 脳梗塞経験後、外部記憶として独自システムを構築。1on1記録、ブレイクアウトルーム管理、PDF自動取込などを備える。\n\n**船津さん側の事業概要**\n\n- **事業内容:** アイケアラボ。予防眼科・視力回復トレーニング。\n- **背景:** 保育士6年経験後、子どもに関わる事業として起業を決意。\n- **メソッド:** 低周波施術によるリハビリ、ホームケア指導、パーソナルトレーニング。\n- **実績:** 自身の視力が 0.2 から 0.7〜1.0 へ改善。運転恐怖症があった40代顧客の視力回復事例あり。\n- **提携状況:** 福岡アビスパ、航空会社から提携打診あり。\n- **課題:** 柏エリアで提携可能な眼科医を探している。都内の提携先は遠方で、顧客が通いづらい。\n\n**相互理解のポイント**\n\n- 次廣は、船津さんのフランチャイズ本部にシステム化ニーズがある点に強く反応した。カルテ手書き、スプレッドシート管理、現場運用の限界が具体的な入口になり得る。\n- 船津さんは、次廣の顧客管理システムの簡易版に関心を示した。現状、1on1記録がピージーズ上に羅列されており、整理・検索・振り返りに課題がある。\n- 増本氏がITスキルを向上させたこと、DragonFly メンバーの温かさについて共通認識があった。\n\n#### 確認待ち事項\n\n- 船津さんが、藤本氏（税理士）と秋田の財務コンサルに、次廣との接続可能性を確認する。\n- 次廣が、脳神経外科医を通じて関東圏の眼科医を船津さんに紹介できるか調整する。\n- 船津さんのアイケアラボ本部に対するシステム化提案の実現可能性、提案先、提案タイミングを確認する。\n- 第1回 1to1 の正式な開始・終了時刻を確認する。\n\n#### アクションアイテム\n\n- **船津さん:** 藤本税理士と秋田の財務コンサルに、次廣との1on1を打診する。\n- **船津さん:** 1on1記録の整理方法を改善する。現状のピージーズ上の羅列管理から、後で検索・活用しやすい形へ見直す。\n- **次廣:** 脳神経外科医に、関東圏の眼科医紹介を相談する。\n- **次廣:** 船津さん向けのリファラル提案を作成し、紹介先候補を整理する。\n- **次廣:** フランチャイズ本部向けのシステム化提案の入口を、カルテ管理・顧客管理・スプレッドシート限界のどこに置くか整理する。\n\n#### 協業機会\n\n- **フランチャイズ本部のシステム化:** 手書きカルテ、顧客管理、店舗運営管理、スプレッドシート管理の限界を起点に提案できる。\n- **顧客管理システムの簡易版:** 1on1記録・顧客情報・紹介候補を整理する軽量版として、船津さん自身の課題解決に使える可能性がある。\n- **医療・ヘルスケア領域での連携:** 柏・関東圏の眼科医との接続により、アイケアラボの信頼性と顧客導線を強化できる。\n- **BNI内での横展開:** 1on1記録整理や紹介候補管理は、DragonFly メンバーにも共通する課題になりやすい。\n\n#### ■ 次回予定\n\n- **翌日の DragonFly イベント**にて再会予定。\n\n---','2026-04-13 23:22:13','2026-06-23 22:46:24'),
(16,1,37,40,NULL,NULL,NULL,'manual','2026-04-13 18:00:00',NULL,'2026-04-13 19:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_hatakeyama_noriyuki_wagashi_oem.md#第1回】\n\n### 【第1回】2026-04-13\n\n#### 基本情報\n\n- **日時:** **2026-04-13（月）JST 18:00–19:00**\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 16`（**1セッション＝DB 1行**）\n\n以下、**クライアント共有用**の議事録体裁（tugilo式）。\n\n#### ■ 概要\n\n- **日時:** 2026年4月13日（月）18:00〜19:00（JST）\n- **参加者:** 次廣 淳、畠山 憲之 様\n\n#### ■ 主な成果\n\n- 次廣のメンバーシップ・パスポートプログラムが完了したことを共有した。\n- 次廣の AI 活用・業務改善システム構築の実績と開発スタイルについて理解を共有した。\n- 畠山様の和菓子製造における業務課題（Excel 管理・属人化・業務過多）を整理し、システム化による改善の方向性を確認した。\n\n#### ■ 決定事項・合意内容\n\n- **業務効率化に向けた検討の継続:** 採用活動後、システム化の優先順位を整理し、段階的に検討する。\n- **再度の 1on1 の実施:** 詳細ヒアリングを目的に、改めて面談を実施する。\n\n#### ■ フィードバック・示唆\n\n- **次廣の開発スタイル:** 小さく作って育てる「伴走型開発」が現場に適している。ワークフローを変えずにシステムを馴染ませる設計が強み。\n- **畠山様の業務状況:** Excel ベースの複数管理による非効率が顕在化。属人化により休暇が取れない状態。OEM 受注増加により業務負荷が限界に近い。\n- **システム化の本質的価値:** 入力の一元化による作業削減、属人化解消による経営リスク低減、「不在でも回る仕組み」の構築。\n\n#### ■ 確認事項（保留）\n\n- システム化の対象範囲（どの業務から着手するか）。\n- 採用活動後の体制を踏まえた優先順位の整理。\n- 木村氏（岡山・T シャツ事業）の属人化課題への対応可能性。\n\n#### ■ アクションアイテム\n\n##### ▼ 畠山 憲之 様\n\n- 採用活動を優先し、業務整理を実施する（期限: 協議のうえ設定）。\n- 落ち着いた段階でシステム化の優先順位を検討する（期限: 協議のうえ設定）。\n\n##### ▼ 自分（次廣）\n\n- 畠山様との再度の 1on1 を設定し、詳細ヒアリングを実施する（期限: 協議のうえ設定）。\n- 現状業務の整理を踏まえた改善提案を準備する（期限: 協議のうえ設定）。\n\n#### ■ 協業機会（あれば）\n\n- **製造業向け業務管理システム:** 原価計算・成分管理・原材料管理の一元化。\n- **入力一元化システム:** 1 回の入力で複数帳票へ自動反映。\n- **シフト・労務管理の可視化:** 労働時間・負荷の見える化（アラート機能）。\n- **属人化解消の仕組み構築:** 誰でも業務が回る体制づくり。\n\n#### ■ 次回予定\n\n- 定例会で継続フォロー。\n- 別途 1on1 を設定し、詳細ヒアリングを実施する。\n\n---','2026-04-13 23:27:04','2026-06-23 22:46:24'),
(17,1,37,96,NULL,NULL,NULL,'manual','2026-04-17 09:55:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_suzuki_kensuke_studio_suzu.md#第1回】\n\n### 【第1回】2026-04-17 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-17（金）JST 09:55–TODO**（開始時刻: ユーザー提供「合同会社スタジオ鈴 鈴木健介さん：1to1調整用 2026-04-17 09:55(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、鈴木健介\n- **Religo 1to1 レコード:** `one_to_ones.id = 17`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 鈴木さんは、来週実施予定のスタートアッププレゼン（2分20秒・7枚構成）を次廣に向けて練習した。\n- 写真を活用したビジュアル表現は効果的で、ファッション・雑誌・フード撮影の経歴が明確に伝わった。\n- 一方で、オンライン環境ではアニメーションのコマ落ちが発生し、スライドの伝わり方に課題があることを確認した。\n- 次廣は、AIを活用したホームページ作成、記事生成、プログラミング支援、B2B業務改善システム構築の実例を共有した。\n- 両者は、VR撮影、サウナ、飲食店向け AI 問い合わせ対応を中心に、具体的な協業・紹介の芽を確認した。\n\n**主な成果**\n\n- 鈴木さんのスタートアッププレゼンの改善ポイントが明確になった。\n- オンライン発表時は、アニメーションが重い場合に PDF 形式で共有する方針を確認した。\n- 次廣が、藤原氏（VR推進協会）と鈴木さんをつなぎ、サウナ施設の360度VRコンテンツ制作の可能性を探ることになった。\n- 次廣の次回東京訪問時に、北欧サウナで初心者向けサウナ体験を実施する方向で合意した。\n\n**決定事項・合意内容**\n\n- **スタートアッププレゼン改善:** 写真を追加してビジュアル要素を強化し、仕事内容と人となりのバランスを調整する。\n- **オンライン発表時の対応:** アニメーションが重い場合は PDF 形式で共有し、表示崩れ・コマ落ちのリスクを下げる。\n- **VR事業での協業検討:** 次廣が藤原氏（VR推進協会）と鈴木さんを紹介し、サウナ施設の360度VRコンテンツ制作を検討する。\n- **サウナツアー企画:** 次廣の次回東京訪問時に、北欧サウナ（上野）で初心者向けサウナ体験を実施する。\n\n**鈴木さんのプレゼンフィードバック**\n\n- **強み:** 写真を活用したビジュアル表現が効果的で、撮影者としての実績・世界観が伝わりやすい。\n- **強み:** ファッション、雑誌、フード撮影の経歴が明確で、飲食・フランチャイズ領域への紹介につなげやすい。\n- **改善提案:** オンライン環境ではアニメーションのコマ落ちが発生するため、PDF版も用意しておく。\n- **改善提案:** 仕事内容だけでなく人となりも伝わるよう、写真要素とストーリーのバランスを調整する。\n\n**次廣側の事業共有**\n\n- 次廣は、ホームページ作成、記事生成（150件以上）、プログラミング支援などを AI で自動化している。\n- AI活用は単なる自動生成ではなく、顧客要望の言語化、ヒアリング、業務フロー理解と組み合わせて価値が出ると説明した。\n- 25年のシステム開発経験により、顧客の言語化されていない要望を整理し、現場負荷を下げる設計ができる点を差別化要素として共有した。\n- ターゲットは、Excel 管理で困っている中小企業、士業・コンサルタント、B2B 業務改善案件。\n- 音声入力・タッチパネル活用により、手書き業務や二重入力を減らす提案が可能。\n\n**鈴木さん側の紹介ニーズ**\n\n- **ターゲット:** 飲食フランチャイズオーナー、飲食コンサルタント。\n- **提供価値:** フード撮影全般、動画制作（撮影〜納品一貫）、ドローン撮影。\n- **紹介時の切り口:** 飲食店・フランチャイズのメニュー写真、店舗紹介動画、SNS/採用/販促向けコンテンツ制作。\n\n**具体的な協業可能性**\n\n- **VR×サウナコンテンツ:** 全国のサウナ施設を360度撮影し、音響付きVRツアーとして制作する。\n- **サウナ施設向け販促:** サウナ未経験者にも雰囲気・導線・楽しみ方が伝わる体験コンテンツとして展開できる可能性がある。\n- **AI×問い合わせ対応:** 飲食店向け24時間 AI コールセンターシステムの開発可能性。\n- **飲食フランチャイズ支援:** 鈴木さんの撮影・動画制作と、次廣の業務効率化・AI対応を組み合わせた提案余地がある。\n\n**BNI活動状況**\n\n- 次廣は、トレーニング強化月間として13個のワークショップを1ヶ月で受講予定。全額返金制度を活用している。\n- 次廣は、メンバーアクセラレーター、ネットワークスキルトレーニング、メインプレゼントレーニング等を受講済み。\n- 次廣の所属は DragonFly チャプター（NEDリージョン、53名規模）。\n- 次廣は、ワークショップ参加者に即座にリファラルを提出するなど、BNI活動を強化している。\n- 鈴木さんは Diana チャプター所属。月1回の対面ミーティングがある。\n- 鈴木さんは、朝7時開始・2時間半のチャプターディベロップメントに参加している。\n\n#### 確認待ち事項\n\n- VR撮影の具体案件は、鈴木さんが藤原氏との打ち合わせ後に詳細を検討する。\n- サウナツアーの日程は、次廣の次回東京訪問予定が確定次第調整する。\n- AIコールセンターシステムについて、24時間自動応答の引き合いがある企業情報を鈴木さんから共有予定。\n- 第1回 1to1 の終了時刻を確認する。\n- 合同会社スタジオ鈴の正式な読み、Webサイト、BNIプロフィール URL を確認する。\n\n#### アクションアイテム\n\n- **次廣:** 藤原氏（VR推進協会）のコンタクト情報を鈴木さんに共有する。\n- **次廣:** 東京訪問時に北欧サウナ（上野）を予約し、鈴木さんに連絡する。\n- **鈴木さん:** スタートアッププレゼンを PDF 版に変換し、写真要素をブラッシュアップする。\n- **鈴木さん:** サウナ初心者向けツアープランを作成する（低温サウナ室＋外気浴重視）。\n- **鈴木さん:** AIコールセンターシステムのニーズがある企業情報を次廣に提供する。\n\n#### 次回1on1\n\n- **未定。** 次廣の次回東京訪問時に調整予定（サウナ体験込み）。\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(18,1,37,26,NULL,NULL,NULL,'manual','2026-04-20 15:53:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md#第1回】\n\n### 【第1回】2026-04-20 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-20（月）JST 15:53–TODO**（開始時刻: ユーザー提供「2026-04-20 15:53(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、竹内駿太\n- **Religo 1to1 レコード:** `one_to_ones.id = 18`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣は、静岡県藤枝市でシステムエンジニアとして活動し、業務改善システム・AI活用・プロジェクトマネジメントを提供している。\n- 竹内さんは、保険代理店としてアスリート専門保険を展開し、顧客の多くがサッカー関連。今後は個人保険中心から法人営業へシフトする方向性を検討している。\n- 両者は、次廣の静岡 PTA・サッカーパパコーチ人脈と、竹内さんのキッズマネー教育が接続しやすいことを確認した。\n- 竹内さんが法人経営者にヒアリングする場面では、業務効率化・システム化ニーズを次廣へ紹介できる可能性がある。\n\n**決定事項・合意内容**\n\n- **静岡エリアでの協業検討:** 次廣が、静岡のサッカーパパコーチや小学校 PTA ネットワークに、竹内さんのキッズマネーセミナーを紹介できるか検討する。\n- **システム開発での連携:** 竹内さんが法人営業を強化する中で、経営者へのヒアリング時に業務効率化ニーズがあれば次廣へ紹介する。\n- **相互補完関係:** 次廣はシステム構築が専門で、助成金・補助金の対応はできないため、行政書士や経営コンサルとの連携を模索している。\n- **同業・周辺メンバーとの協業:** 竹内さんから、システムエンジニア系メンバーとのカテゴリー重複・協業可能性が話題に上がり、次廣は協業可能と前向きに整理した。\n\n**次廣側の事業概要**\n\n- **経歴:** システムエンジニア歴25年、AI活用歴3年。\n- **事業形態:** 個人事業主として、営業から開発・運用まで一人で対応。\n- **専門領域:** B2B/B2C の業務改善システム、プロジェクトマネジメント、AI活用。\n- **AI活用:** プログラミング作業の多くを AI に委託し、開発効率を高めている。\n- **主な実績:** フランチャイズ管理システム、解体業向け LINE 連携システム、観光協会向けデジタルスタンプラリー、インテリア商社の受発注管理、防水工事業の工程管理・日報、動物病院予約管理、飲食フランチャイズ業務システム。\n- **開発姿勢:** 大規模導入を避け、現場負担の軽減から小さく始め、既存ワークフローを大きく変えずに段階的に拡張する。\n\n**竹内さん側の事業概要**\n\n- **所属:** エグゼクティブランス（保険代理店、正式表記 TODO）。\n- **経歴:** ソニー生命、ジブラルタ生命を経て、2024年9月から現職。保険業界7年目。\n- **専門:** アスリート専門保険。顧客の約8割がサッカー関連。\n- **実績:** 2024年度 MDRT 達成。\n- **キッズマネー教育:** お店屋さんごっこ形式で、子どもが塗り絵を販売し、親への感謝やお金の大切さを学ぶ。15分のマネーセミナーを通じて、親御さんの個別相談につなげる。\n- **連携先:** スポーツクラブ、PTA、住宅展示場、カーディーラーなど。夏休み・冬休みの集客ツールとして展開しやすい。\n- **アスリートセカンドキャリア支援:** パパアスリートのビジネス活用事例をインタビューし、Web記事として無料掲載。経営者との接点から、財務ヒアリング・アドバイス・保険提案へ展開する。\n- **現在の方向性:** BNI 入会から2年が経過し、個人保険から法人営業へシフトすることを検討中。ゴールデンウィーク頃にウィークリープレゼン内容を法人向けへ変更予定。\n\n**連携の具体案**\n\n- **次廣から竹内さんへ:** 静岡のサッカーパパコーチに、竹内さんのキッズマネーセミナーを提案する。\n- **次廣から竹内さんへ:** 元 PTA 会長としての人脈を活用し、小学校イベントでのセミナー開催可能性を探る。\n- **竹内さんから次廣へ:** 法人経営者へのインタビュー時に、業務効率化・DX・システム化ニーズがあれば次廣へ紹介する。\n- **周辺連携:** 助成金・補助金、行政書士、経営コンサル、同業 SE メンバーとの役割分担を整理し、案件に応じたチーム提案を検討する。\n\n**BNI・人物面の共有**\n\n- 次廣は、増本さんのプロテクトラボシステム開発をきっかけに BNI との接点ができ、今西さんの誘いで DragonFly に入会した。\n- 次廣は、先週 BarBubble に初参加し、ビジター向けクロージングの場として機能していることを体感した。\n- 福上さん（デザイナー、GW頃入会予定）とは、UI/UX 領域での協業可能性がある。\n- 竹内さんは、杉並区選抜キャプテン経験があり、18チームに助っ人登録している。\n- 竹内さんの家族構成は、妻、0歳の娘、父母、弟2人。\n- 次廣の家族構成は、妻、娘2人（中3・小6）、猫4匹。趣味はキャンプ、ジム、家族との時間。高校時代は水球部。\n\n#### 確認待ち事項\n\n- 竹内さんが東京から静岡へ移動してリアル開催のキッズマネーセミナーを実施できるか。新幹線で1時間半〜2時間程度の移動が想定される。\n- 次廣が、現 PTA 会長へ竹内さんを紹介する具体的なタイミングと方法。\n- 次廣が、静岡のサッカーパパコーチへ竹内さんを紹介する具体的な相手・導入文。\n- 倉持さんへのシステムテスト協力依頼について、具体案件が出た際の相談方法。\n- 第1回 1to1 の終了時刻を確認する。\n- 竹内さんの所属会社名の正式表記、Webサイト、BNIプロフィール URL を確認する。\n\n#### アクションアイテム\n\n- **次廣:** 静岡のサッカーパパコーチに、竹内さんのキッズマネーセミナーを紹介する。\n- **次廣:** 現 PTA 会長へ竹内さんを紹介できるか確認する。\n- **竹内さん:** 法人経営者へのインタビュー時に、業務効率化ニーズをヒアリングし、該当があれば次廣へ紹介する。\n- **竹内さん:** Dリーグ（ダンスプロリーグ）について調査する。次廣の娘が所属チームのスクールに通っている接点がある。\n- **次廣:** 助成金・補助金が絡む案件で連携できる行政書士・経営コンサル候補を整理する。\n\n#### 次回1on1\n\n- **未定**\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(19,1,37,4,NULL,NULL,NULL,'manual','2026-04-24 11:30:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_matsukura_kenji_glassfilm_coating.md#第1回】\n\n### 【第1回】2026-04-24 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-24（金）JST 11:30–TODO**（開始時刻: ユーザー提供「次廣さん⇔松倉 Zoom ミーティング 2026-04-24 11:30(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、松倉 Kenji\n- **Religo 1to1 レコード:** `one_to_ones.id = 19`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣は、静岡でシステムエンジニアとして活動しており、Excel 管理の限界を感じている中小企業向けに業務改善システムを構築している。\n- 松倉さんは、松戸を拠点にガラスフィルム施工とコーティング事業を展開しており、エアロゲル透明断熱フィルムを扱う全国5社のうちの1社として、高級リゾートホテルを中心に営業している。\n- 両者は同じ BNI DragonFly メンバーとして、事業内容、紹介しやすい相手、DragonFly 内での協業可能性を確認した。\n\n**決定事項・合意内容**\n\n- **静岡の紹介可能性:** 次廣は、静岡のインテリア資材卸売会社の社長を通じて、松倉さんのガラスフィルム事業を紹介できるか検討する。\n- **ITチーム内の役割分担:** コナカさんはシステム開発を担当しない AI 活用コンサル、次廣はシステム開発担当として役割を分け、大規模案件では協業する方向性を確認した。\n- **次廣の顧客ターゲット:** Excel・スプレッドシート運用が限界に近い中小企業の経営者を中心に、士業・コンサル経由の紹介を重視する。\n\n**交換されたフィードバック**\n\n松倉さんから次廣へ:\n\n- ウィークリープレゼンでの表現力を高く評価。\n- リファーラルプレゼンでは、内部取引であっても企業名や肩書を強調し、「誰に紹介したか」「どれだけすごい取引か」が伝わるようにするとよい。\n- DragonFly 内のウェブマスター業務は倉持さんに負荷が集中しており、サポート体制が必要ではないかと指摘。\n\n次廣から松倉さんへ:\n\n- BNI の学びが仕事に活かせており、会費以上の価値を感じている。\n- 初月はトレーニングと 1to1 の多さに苦労したが、脳梗塞の経験から記憶だけに頼らず、全ミーティングを AI で記録・データベース化している。\n\n**次廣側の事業概要**\n\n- **屋号:** tugilo（つぎろ）\n- **経歴:** システムエンジニア歴25〜26年。\n- **事業内容:** Excel・スプレッドシートで管理している業務を一元化し、一回の入力で回る仕組みを構築する。\n- **主な実績:** 増本さんのフランチャイズ管理システム（70%効率化、120万円で構築）、解体業の問い合わせ〜請求管理、観光局のスタンプラリー管理、防水工事会社の工程管理など。\n- **強み:** 既存ツールを押し付けず、現場の業務フローに合わせてゼロベースで開発する。小さく作って確実に育てる伴走型アプローチ。\n- **AI活用:** AI 活用で開発効率を8割改善し、その時間を BNI 活動に充てている。\n\n**松倉さん側の事業概要**\n\n- **事業内容:** ガラスフィルム施工、コーティング、エアロゲル透明断熱フィルムの提案・施工。\n- **体制:** ガラスフィルム施工職人15人を抱え、自身も営業と施工を兼務。\n- **商材:** エアロゲル透明断熱フィルムは世界初の技術。夏冬両対応、透明性、結露防止、飛散防止を実現する。\n- **防災効果:** 建築基準法の台風圧をクリアし、窓ガラスを守ることで屋根の飛散も防ぐ可能性がある。\n- **主要顧客:** 高級リゾートホテル、星野リゾートなど。15年来の付き合いがある顧客も多い。\n- **営業姿勢:** 営業中の施工依頼も多く、自身が対応することで顧客との信頼関係を構築している。\n- **DragonFly 内実績:** 貝沼さん・畑山さんの事務所や自宅に施工実績あり。新築案件は少なく、住んでからの困りごと解決が中心。\n\n**BNI活動について**\n\n- 次廣は、増本さんの紹介で約10年前から環境衛生協議会に参加していた。DragonFly 立ち上げ時にも誘われたが、時間的制約で見送り、約1ヶ月前に正式加入した。\n- 増本さんが静岡に来た際は10人以上が集まり、朝2時まで飲み会が続く文化がある。\n- 松倉さんは、害虫ブロックの施工店として平岡さんの下で活動しており、増本さんが作ったフランチャイズ管理システムを利用している。\n- 松倉さんは、入会後すぐにウェブマスター、1to1、ビジターホストコーディネーターを歴任し、走りすぎたと振り返った。\n- リファーラルプレゼンは「ビジターへの例会プレゼン」として外向けに発表すべきで、内部取引でも企業名・肩書を強調することが重要だと確認した。\n\n#### 確認待ち事項\n\n- 次廣が、静岡のインテリア資材卸売会社の社長に松倉さんのガラスフィルム事業を紹介できるか確認する。\n- 次廣の BNI 役職アサインは、全トレーニング終了後に決定される見込み。\n- 松倉さんの正式社名・Webサイト・BNIプロフィール URL を確認する。\n- 第1回 1to1 の終了時刻を確認する。\n\n#### アクションアイテム\n\n- **次廣:** 静岡のインテリア資材卸売会社の社長に、松倉さんのガラスフィルム事業を紹介できるか確認する。\n- **次廣:** 6月23日のメインプレゼンに向けて、ビジター招待を強化する。\n- **松倉さん:** DragonFly メンバーへの内部リファーラル発表時に、企業名・肩書を強調した表現へ改善する。\n\n#### 次回1on1\n\n- **未定**\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(20,1,37,97,NULL,NULL,NULL,'manual','2026-04-27 10:58:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_iizuka_graphic_design.md#第1回】\n\n### 【第1回】2026-04-27 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-04-27（月）JST 10:58–TODO**（開始時刻: ユーザー提供「飯塚様1to1 2026-04-27 10:58(GMT+9:00)」。終了時刻はカレンダー／Zoom録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、飯塚氏\n- **Religo 1to1 レコード:** `one_to_ones.id = 20`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣は、静岡で活動するシステムエンジニアとして、B2B 向けの業務改善・システム構築を提供している。\n- 飯塚さんは、ロゴ・名刺・チラシ・パンフレット・パッケージ・キャラクター・Webデザインを扱うグラフィックデザイナーとして活動している。\n- 両者は初回 1on1 で、お互いのビジネスモデル、紹介してほしい相手、紹介できそうな相手、システムとデザインの協業可能性を確認した。\n\n**主な成果**\n\n- 次廣の業務改善・システム構築サービスと、飯塚さんのデザインサービスについて相互理解が深まった。\n- 次廣側・飯塚さん側の双方で、具体的な紹介候補が複数明確になった。\n- システム開発における UI/UX、B2C アプリ、マニュアルの漫画化、Webデザイン協業など、将来的な協業領域を確認した。\n- 継続的な月次 1on1 の実施と LINE 連絡先交換に合意した。\n\n**決定事項・合意内容**\n\n- **相互紹介の実施:** 飯塚さんは、社労士の渋谷氏、雨漏り調査専門家（水漏れレコーデ）、システム開発デザイナーの竹本氏を次廣へ紹介する。\n- **香川の石材業者との連携:** 次廣は、田渕恭平氏（庵治石を扱う石材業者）を飯塚さんへ紹介し、ブランディング・商品開発の可能性を探る。\n- **DragonFly メンバーへの展開:** 次廣は、行政書士の佐久間氏・望月氏を、飯塚さんのスタートアップ向けサービスに接続できるか検討する。\n- **継続的な関係構築:** 月次での定期的な 1on1 実施に合意し、LINE 連絡先を交換した。\n- **メンバーリスト共有:** 次廣は DragonFly チャプターの写真付きメンバーリストを飯塚さんへ送付し、飯塚さんも大人なじみチャプターのメンバーリストを次廣へ送付する。\n\n**次廣側の事業概要**\n\n- **専門領域:** B2B 向け業務改善とシステム構築。システムエンジニア歴25〜26年、独立23年目。\n- **対象業種:** 建設業、製造業、複数拠点のサービス業、フランチャイズ。\n- **アプローチ:** 属人化の解消、一回入力で完結する仕組み、現場フローを変えない伴走型の構築。\n- **成果事例:** フランチャイズ200店舗の管理システム統合、複数拠点の予約・実績管理の一元化による作業時間50%以上削減。\n- **AI活用:** 25〜26年は手書きでプログラミングしてきたが、現在は AI を積極活用している。\n- **紹介してほしい相手:** 売上は伸びているが現場が追いつかない経営者、複数拠点のサービス業、フランチャイズ、顧客を持つ士業・コンサルタント。\n\n**飯塚さん側の事業概要**\n\n- **専門領域:** ロゴ、名刺、チラシ、パンフレット、パッケージ、キャラクター、Webデザイン。\n- **実績:** Jリーグ、ファミリーマートなど大手企業のデザイン実績多数。\n- **強みの説明:** デザインは単なる見た目ではなく、売上成長、採用・従業員エンゲージメント、企業価値に影響する経営資産として説明している。\n- **ロゴ価値の事例:** NTT、ペプシ、楽天、ナイキなどの事例を用いて、ロゴ・ブランドへの投資価値を伝えている。\n- **スタートアップ向け:** ロゴ + ホームページを 11万円で提供（条件付き：2案提案、修正制限あり）。\n- **紹介してほしい相手:** スタートアップ経営者、2代目・3代目経営者、リブランディング需要のある企業、経営コンサル、広告代理店、行政書士・司法書士など起業支援に関わる士業。\n\n**BNI活動状況**\n\n- **次廣:** DragonFly チャプター入会1ヶ月。4月に13のトレーニング受講を完了し、10人紹介を完了。\n- **飯塚さん:** BNI歴4年超。夏更新で5年目。大人なじみチャプターは32人規模。\n- **DragonFly:** 約50人規模。オンライン専門で全国から参加し、NE地域リージョンに所属。\n\n**協業可能性**\n\n- **UI/UXデザイン:** 次廣の B2C アプリ開発では、ボタン配置や視覚的なわかりやすさが重要になるため、飯塚さんのデザイン力を活用できる可能性がある。\n- **マニュアルの漫画化:** 文字を読まない現場向けに、飯塚さんの知人である漫画家と連携して、マニュアルを視覚化する案がある。\n- **フロントエンド協業:** 次廣はバックエンドを得意とし、Webデザイナーと組むことが多いため、飯塚さんとの協業余地がある。\n- **石材ブランディング:** 田渕氏の庵治石・石材事業に対し、飯塚さんがブランディングや商品開発面で提案できる可能性がある。\n\n#### 確認待ち事項\n\n- 次廣が、DragonFly チャプターの写真付きメンバーリストを飯塚さんへ送付する。\n- 飯塚さんが、大人なじみチャプターのメンバーリストを次廣へ送付する。\n- 飯塚さんが、次廣のプレゼン資料を関係者に展開する。\n- 飯塚さんが、田渕氏向けに石材ブランディング・商品開発の提案を準備する。\n- 飯塚さんの正式氏名、屋号、Webサイト、BNIプロフィール URL を確認する。\n- 第1回 1to1 の終了時刻を確認する。\n\n#### アクションアイテム\n\n- **飯塚さん:** 社労士の渋谷氏に、次廣の業務改善・システム構築サービスを提案する。\n- **飯塚さん:** 雨漏り調査専門家（水漏れレコーデ）に、次廣を紹介する。\n- **飯塚さん:** 竹本氏（BNIトレーニング一覧作成者）に、次廣の資料を送付する。\n- **次廣:** 田渕恭平氏（庵治石）を飯塚さんに紹介する。\n- **次廣:** 佐久間氏・望月氏（行政書士）を飯塚さんに紹介する。\n- **次廣:** DragonFly メンバーリスト（写真付き）を飯塚さんに送付する。\n- **飯塚さん:** 自チャプターのメンバーリストを次廣に送付する。\n\n#### 次回1on1\n\n- **5月に再度実施予定**（ゴールデンウィーク後）。\n- 継続的な月次 1on1 で信頼関係を構築する方針。\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(21,1,37,98,NULL,'89157467602','IwdcYnOrRzeXiyNsb0v2pA==','manual','2026-05-07 15:57:00','2026-05-07 16:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_tamura_kodai_money_cooking.md#第1回】\n\n### 【第1回】2026-05-07 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-07（木）JST 15:57–TODO**（開始時刻: ユーザー提供「田村様1to1 2026-05-07 15:57(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 21`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 田村さんの「お金の料理教室」と、次廣の「AI業務改善システム構築」について、ビジネスモデル・強み・紹介しやすい相手を相互に確認した。\n- 田村さん側からは、建設業者向けの損保削減・投資設計、金融業界の手数料構造、顧客利益を優先する営業姿勢が共有された。\n- 次廣側からは、現場に合わせたウェブベースの業務システム開発、小さく始めて育てる開発方針、AI活用による業務改善実践が共有された。\n- 具体的な協業可能性として、建設業向けサービス、SEO・FC専門家との連携、SE同士の協業が話題になった。\n\n**決定事項・合意内容**\n\n- **相互紹介:** 田村さんが次廣に、岡山のSEメンバー（下辻氏）、SEOコンサルタント、FCコンサルタントの3名を紹介する。\n- **個別相談:** 次廣が田村さんに、自身の保険・投資商品について個別相談を依頼する。\n- **建設業ネットワーク活用:** 次廣の DragonFly チャプター内の建設業メンバーを、田村さんに紹介できる可能性を検討する。\n- **チャプター内紹介:** 田村さんのチャプター内にいる組織開発・販促コンサル系メンバーへ、次廣を紹介する可能性を検討する。\n\n**交換されたフィードバック**\n\n田村さんから次廣へ:\n\n- システム開発の「小さく始めて育てる」段階的アプローチは、紹介時に提案しやすい。\n- 既存顧客からの紹介実績が、信頼性の証明になっている。\n- 直接取引によって中間コストを削減できる点が、顧客にとって魅力的。\n\n次廣から田村さんへ:\n\n- 金融商品の説明が非常にわかりやすく、初めて納得できる内容だった。\n- 手数料構造の透明性が、他の金融業者と一線を画している。\n- 顧客利益を優先する姿勢に共感した。会話内では「南の帝王」的な、相手の実利に踏み込むアプローチとして印象に残った。\n\n**田村さん側の事業概要**\n\n- **職歴:** 三井住友銀行2年、消防士3年、保険代理店13年目。\n- **提供範囲:** 49社の保険、SBI証券・楽天証券を扱える独立系アドバイザー。\n- **収益モデル:** 手数料ゼロの積立NISAも推奨し、長期的な資産増加に伴う年0.1%程度の継続手数料を重視。\n- **ターゲット:** 建設業者、損保200万円以上支払い企業、財務コンサル経由の紹介先。\n- **実績例:** 損保1,500万円を800万円に削減し、浮いた70万円/月を投資に回すことで、15年後2,500万円の退職金に転換する提案。\n- **課題:** BNI カーネルチャプターでは紹介が一部メンバーに集中しており、紹介経路の拡大がテーマ。\n\n**次廣側の事業概要**\n\n- **経歴:** SE歴25年、30歳で独立し、独立23年目。\n- **事業内容:** 現場に合わせたウェブベースの業務システム開発、保守サポート型の伴走。\n- **強み:** 既存ワークフローを大きく変えず、現場が楽になる仕組みを小さく始めて育てる。\n- **ターゲット:** Excel管理が限界の企業、二重入力に苦しむ中小企業、属人化・ファイル分散で困っている企業。\n- **実績:** FC本部200店舗管理システム、解体業LINE連携システム、防水工事業工程管理など。\n- **AI活用:** 2年前から自身の業務にAIを取り入れ、業務効率を9割改善。プログラム作成もAIと協業している。\n- **BNI:** DragonFly チャプターに3月17日加入、4月末にグラデュエート取得。最速記録として共有。\n\n**協業可能性の検討**\n\n- **建設業向けパッケージ:** 田村さんの損保削減・投資プランと、次廣のDXシステム導入を組み合わせる。浮いた保険料の一部をシステム導入費用に充てられる可能性がある。\n- **DragonFly 建設業ネットワーク:** DragonFly チャプター内には建設業メンバーが複数おり、田村さんのターゲットと接続しやすい。\n- **IT業界向けサービス:** 田村さんは、ウェブ制作会社に特化した社保削減提案（国の制度活用）を検討中。ウェブ制作会社経由で多業種へリーチできる可能性がある。\n- **SEO専門家との連携:** 次廣のシステム開発と、田村さんが紹介可能なSEO専門家の協業余地がある。\n- **システム会社間連携:** SE同士の協業で苦手分野を補完し、直接取引による中間マージン削減を顧客メリットとして出せる。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 田村さんは、BNI 内で紹介が一部メンバーに集中しており、紹介経路を広げたい。\n- 次廣は、自身の保険・投資商品について、田村さん視点で見直し提案を受ける余地がある。\n- 田村さんのチャプター内メンバー（SEO、FC、SE専門家）との連携方法は、具体的な紹介後に詰める必要がある。\n- DragonFly チャプター内の建設業メンバーと田村さんの面談設定は、相手候補の選定が未確定。\n\n#### 仮説（tugilo視点）\n\n- **最初の協業テーマ:** 建設業者向けに「保険料削減で原資を作る → 業務システム化で現場改善する」という流れを作ると、双方の価値が伝わりやすい。\n- **紹介の切り口:** 田村さんは金融商品の売り込みではなく、手数料構造と長期資産形成の透明性で信頼を取れる。建設業経営者・財務相談に近い相手と相性が良い。\n- **次廣側の商談化:** SEO・FC・SE専門家の紹介は、すぐ案件化よりも協業パートナー開拓として捉え、相手の顧客層・得意領域・紹介し合える課題を確認する。\n- **個別相談の価値:** 次廣自身の保険・投資相談を先に行うことで、田村さんの説明品質を実体験として語れるようになり、紹介時の説得力が増す。\n\n#### アクションアイテム\n\n- **田村さん:** 岡山のSE（下辻氏）、SEOコンサルタント、FCコンサルタントの連絡先を次廣に共有する（期限未定）。\n- **田村さん:** チャプター内の組織開発・販促コンサルメンバーに次廣を紹介する（期限未定）。\n- **次廣:** DragonFly チャプター内の建設業メンバーを田村さんに紹介する候補として検討する（期限未定）。\n- **次廣:** 田村さんに対し、保険・投資の個別相談を依頼する（期限未定）。\n- **次回:** 田村さんの紹介予定者（SE・SEO・FC）との具体的な接点、DragonFly 建設業メンバーとの面談設定、次廣自身の保険見直し相談を確認する。\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(22,1,37,99,NULL,NULL,NULL,'manual','2026-05-08 14:00:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md#第1回】\n\n### 【第1回】2026-05-08 実施済み（終了時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-08（金）JST 14:00–TODO**（開始時刻: ユーザー提供「木村秀継ミーティング 2026-05-08 14:00(GMT+9:00)」。終了時刻はカレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 22`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 木村さんの家系図・ルーツ調査事業と、次廣の AI 業務改善システム開発について相互理解を深めた。\n- 次廣が、木村さんの既存システム（VB + Oracle）のクラウド移行・Web化支援を提案。\n- 既存システム改善について、別途ヒアリングと提案の場を設けることで合意した。\n\n**決定事項・合意内容**\n\n- **既存システム改善のヒアリング:** 木村さんの既存システム改善について、次廣が別途ヒアリングと提案を実施する。\n- **日程調整:** 次廣が Messenger 経由で日程調整用リンクを送付する。\n- **事前整理:** 木村さんが、既存システムの課題と理想像を箇条書きレベルで整理する。手書きラフでも可。\n- **情報共有:** 次廣がホームページ URL を Messenger で送付する。\n\n**木村さん側の事業概要**\n\n- **株式会社国宝社:** 創業160年の製本会社。ジャンプ・マガジン等の製本を手掛ける。\n- **組織・実績:** 社員数68名。25年で89.2%が廃業する業界で、V字回復を達成。\n- **新規事業:** 家系図・ルーツ調査を展開中。\n- **調査内容:** 戸籍情報から家系図を作成し、国会図書館の文献調査で先祖のルーツを解明する。\n- **独自性:** 日本で3社しか持たない調査技術とスキルを保有。\n- **成果物イメージ:** NHK「ファミリーヒストリー」のスライド版。\n- **顧客価値:** 経営者や事業承継者が、自分の原点・強み・頑張る理由を発見するツールになりうる。\n- **YouTube:** 2024年4月開始、登録者7,830人。目標は30,000人で、家系図チャンネルとして圧倒的1位を目指す。\n\n**次廣側の事業概要**\n\n- **経歴:** システムエンジニア歴25〜26年。30歳で独立し、個人事業として22年運営。\n- **AI活用:** AI による業務効率化で BNI 参加の時間を確保。AI にコーディングを任せることで、開発スピードとコストを大幅に削減。\n- **BNI:** 2024年3月17日に DragonFly チャプター入会。4月にトレーニング強化月間として全トレーニングを受講。\n- **対応範囲:** インフラ構築、営業、サポート、B2B 業務システム、B2C システム、要件定義・設計支援、ネットワークトラブル対応まで幅広く対応。\n- **開発方針:** 現場のワークフローを無理に変えずに改善する。小規模に始め、必要な機能を段階的に追加する伴走型開発。\n\n**次廣の実績事例**\n\n- **フランチャイズ管理システム:** 全国200店舗（目標500店舗）の FC 向け。Googleフォーム・スプレッドシート・Excelで分散していた注文・顧客管理を統合。注文管理、契約店管理、請求管理、マニュアルコンテンツ配信を一元化。開発費は初期120万円から最終180万円程度、保守費は月額2〜3万円。\n- **在庫管理システム移行:** VB + PostgreSQL から Web化への移行。日報と在庫管理で約200万円の開発費。\n- **LINE連携:** 動物病院の予約管理システム、観光協会との周遊イベント用スタンプラリー・ビンゴシステム。\n\n**木村さんの既存システム改善テーマ**\n\n- **現状:** VB + Oracle のスタンドアローンシステム。Excel で ODBC 接続してデータ加工している。\n- **課題:** Google スプレッドシートとの連携、GAS（Google Apps Script）による自動化を希望。\n- **次廣の提案:** Oracle を維持しながら、Web化・クラウド移行が可能。サポート期間の問題解決とメンテナンス性向上につなげられる。\n- **次回ヒアリングの前提:** 木村さんが「困っていること」「理想の状態」を箇条書きで整理し、次廣が現状把握と提案を行う。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 既存システムが **VB + Oracle のスタンドアローン**で、今後の保守・サポート・拡張に不安がある。\n- Excel の ODBC 接続でデータ加工しており、Google スプレッドシートや GAS との連携に課題がある。\n- 現場運用を崩さずに、クラウド化・Web化・自動化できるかを確認したい。\n- 木村さん側で、課題と理想像がまだ詳細要件としては整理されていない。\n\n#### 仮説（tugilo視点）\n\n- **最初の提案テーマ:** 既存 Oracle をすぐ捨てるのではなく、現行 DB を活かした Web フロント／連携基盤から入ると、移行リスクを抑えやすい。\n- **価値の出しどころ:** サポート切れ・属人化・Excel加工の手間・Google連携の不安をまとめて「止まらない業務基盤」へ置き換える提案が刺さりやすい。\n- **進め方:** いきなり全刷新ではなく、課題一覧 → 現行構成確認 → 小さな改善案 → 段階移行案、の順が安全。\n\n#### アクションアイテム\n\n- **次廣:** Messenger で日程調整リンクを送付する。\n- **次廣:** ホームページ URL を Messenger で送付する。\n- **次廣:** 困っていること・相談したいことがあれば Messenger で共有する。\n- **木村さん:** システム改善の課題と要望を箇条書きで整理する（手書きラフ可）。\n- **次回:** 既存システムの構成、Oracle の利用範囲、Excel／ODBC の具体処理、Google スプレッドシート・GAS 連携の理想像を確認する。\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(23,1,37,100,NULL,'85344850132','jYUX4zxRQLS/2d24XbPJHg==','manual',NULL,'2026-05-13 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_ito_takao_phoenix_jsp.md#第1回】\n\n### 【第1回】実施済み（日時は要約未記載 → TODO）\n\n#### 基本情報\n\n- **日時:** **TODO（曜）JST TODO–TODO**（開始・終了まで。**取得元:** カレンダー／Zoom 録画。文字起こし要約には **日時なし**・2026-05-13 に文書反映）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 23`（**1セッション＝DB 1行**。正式日時は TODO のため `scheduled_at = null`）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣（**静岡**・システムエンジニア／独立 **3年目**、**SE 歴 25〜26年**、**AI 活用 約3年**［ChatGPT 登場前後から］）と、伊藤（**東京**・社労士）が、**大人なじみ・飯塚氏の紹介**を通じて **初めて対面**（※チャプターは次廣＝DragonFly、伊藤＝大人なじみ、飯塚氏＝大人なじみ）。\n- お互いの事業を共有。**補助金・助成金申請時のシステム導入支援**での協業可能性を次廣から提案。伊藤氏は **業務改善助成金（9月受付開始）** を使った **自社の業務効率化** に関心。\n\n**次廣側（要約）**\n\n- **専門:** B2B 業務システム・現状は **Web 案件中心**。\n- **AI:** 開発工程の効率 **約9割改善**、「ほぼコーディング不要」に近い運用などと説明。\n- **姿勢:** 既製ツール押し付けではなく **現場フローに合わせゼロから設計**、**伴走・保守改善**。\n- **実績例（要約）:** FC 本部（Googleフォーム・Excel→統合 Web、**120万→最終180万**）、解体業 **LINE 問い合わせ〜請求**、静岡中部 **スタンプラリー4年連続**、防水工事 **外国人向け LINE 日報・材料費・進捗見える化**。\n- **協業イメージ:** **IT導入補助金・業務改善助成金**を絡める案件で、申請はコンサル、開発は次廣 — **過去に同型の協業実績あり**（要約どおり）。\n\n**伊藤側（要約・プロフィールと整合する点）**\n\n- **食品会社 27年** → **2016 社労士独立**（**47歳**、人事総務経験なしから、という文脈）。\n- **シングルファーザー**として育児と並行し **約4年で社労士**、その後 **約2年半で資格10個以上**。\n- **強み:** **東洋哲学（陽明学）ベースの就業規則**、**出張旅費規定を活用した社保コスト対策**、**一人法人向け** 等。\n- **助成金:** **開業5年で約1億円規模を扱う**（要約表現）。\n\n**課題・ツール検討（伊藤側）**\n\n- **Excel** 中心で **進捗確認が煩雑**、**入力が分散**。\n- **Notion**（kintone の安価代案として）、**Lark**（自由度・コスパ）を **複数回ヒアリング済み** と言及。\n\n**次廣アプローチの評価（伊藤側・要約）**\n\n- Notion／Larkは **利用者が業務をツールに合わせる** 側面があるのに対し、次廣は **業務整理からヒアリングし、必要な部分だけ提供**、**既存ワークフローを無理に変えず現場負担を増やさない** 点を **評価**。\n\n**技術トピック（要約）**\n\n- **開発支援:** ChatGPT、**Cursor**（複数モデル）でコード生成効率化。\n- **システム組込みAI:** 受注票（Excel/PDF）の **AI解析・データ化**（フォーマット固定なら AI 不要になりうる）。\n- **課金:** AI 組込み時 **トークン従量**。**数百人規模**ではコスト爆増しうる → **利用範囲の設計**が重要。\n- **セキュリティ:** 外部 AI への **個人情報送信リスク**。**マイナンバー** オンライン管理の規制緩和動向に注意。\n- **対策案:** **Mac mini 等の自前サーバー + ローカル LLM** で外部送信を抑える。\n- **Claude Code:** ローカル PC 上のファイル探索・PDF 解析に触れた、という要約。\n\n**応用アイデア（会話上）**\n\n- 伊藤氏の **過去データを資産化**し、**条件入力で就業規則ドラフトを出す**仕組みは **構築可能**という方向の話。\n- **前提:** **個人情報の取り扱いルール**を事前に決める必要。\n\n**制度・補助金（要約）**\n\n- **IT導入補助金:** 現状 **審査厳しめ**。\n- **業務改善助成金:** **9月受付開始** に向け伊藤氏が準備 — **次廣のカスタム開発はパッケージではない**ため **IT導入補助の対象になりにくい**、という **課題認識**（要約）。\n\n**労務・AI 一般論**\n\n- **AI で作業短縮**しても **時間ベース評価**だと **給与が下がる懸念**。**定型はAI、創造的業務へシフト** 等の議論。\n\n**次のステップ（合意・要約）**\n\n- 次廣: **ローカル LLM 方式の提案書**を作成 → **再調整して再ミーティング**。\n- 伊藤: **多摩でスキー・スノボする人**がいれば紹介（**80歳で兵庫の斜面**という目標、要約）。\n- **探索:** ひとり親支援まわりで、**DragonFly プレジデント（千葉・シングルマザー支援）** と伊藤氏側コミュニティの **接点確認**（要約。**協会名は「一人親営業協会」と要約されているが、伊藤氏の固定情報では一般社団法人ひとり親支援協会** — 要本人確認）。\n\n#### 抽出された課題（事実：会話で言及）\n\n- 伊藤事務所の **Excel 分散・進捗管理の負荷**。\n- **業務改善助成金**で **自社業務の効率化** を進めたい（9月受付）。\n- **IT導入補助金**は審査厳しさ、**カスタム開発の「パッケージでない」ゆえの枠取りの難しさ**（要約）。\n- **AI・個人情報**（外部API vs ローカルLLM、マイナンバー動向）。\n- **人事評価制度とAI効率化**のすり合わせ（理念レベルの話題）。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** Notion/Lark 調査済みでも **「事務所オペの全体最適」まで到達していない**。**根拠:** Excel分散・進捗煩雑の本人発言。**仮説:** ツール比較フェーズから **業務設計＋軽量カスタム** に移るタイミング。\n- **課題②:** **助成金の枠**と **ソリューションの型**（パッケージ vs 開発）の **ミスマッチ**。**根拠:** IT導入補助の対象になりにくいという会話。**仮説:** 業務改善助成金の **ストーリー設計**を第2回で具体化しないと提案書が空振りしうる。\n- **シナジー:** **社労士のレギュレーション知見 × データ資産化（就業規則テンプレ＋条件分岐）**は差別化になりうる。**根拠:** 会話上の「条件入力で規程作成」案。**リスク:** **個人情報ガバナンス**が先。\n- **紹介:** **スキー共同体**（多摩）と **ひとり親ネットワーク** は関係維持の **非営業的接点**。**根拠:** 要約の次ステップ。\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(24,1,37,101,NULL,'82280318209','qCJSEwAqQLCYSQDmSPCceQ==','manual','2026-05-14 10:00:00','2026-05-14 10:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_isobe_masayuki_nestle_detective.md#第1回】\n\n### 【第1回】2026-05-16 実施済み（10:00〜11:00 JST）\n\n#### 基本情報\n\n- **日時:** **2026-05-16（土）JST 10:00〜11:00**\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 24`（正式時刻反映後 `scheduled_at` 更新要）\n\n#### 全体像\n\n- 礒部昌之（探偵業・BNI レブリー）と次廣淳（システムエンジニア・BNI DragonFly）が初回 1to1 を実施。互いのビジネス内容と **連携可能性** を確認。\n- 礒部さんは **保険営業との連携** を重視。次廣は **税理士・社労士・補助金コンサル** との協業を希望。\n- 次廣の実績として **害虫ブロック FC 管理システム**（約180万円、200社→500社対応）を紹介。AI 活用による短納期・低コスト開発を強みとして提示。\n\n#### 礒部さん側 — 探偵業\n\n**事業概要**\n\n| 項目 | 内容 |\n|------|------|\n| 屋号 | **レムリ**（フランス語で「夢」） |\n| 形態 | 個人事業主、15年間トラブルなし |\n| 所在地 | 埼玉県大宮 |\n| 対応範囲 | 関東圏全域、交通費込みタイムチャージ制 |\n\n**主要業務**\n\n- **浮気調査:** 売上の **75%**\n- **企業調査:** 営業横領、従業員不正、休職中のアルバイト調査など\n- **素行調査、人探し**\n- **離婚訴訟:** 証拠収集支援\n\n**料金・顧客対応**\n\n- タイムチャージ制（調査時間に応じた請求）\n- **納得できない結果には料金請求しない** 方針\n- 調査期間は顧客の情報量で変動（スマホ情報で日時特定済みなら短期・低額、情報不足なら長期化）\n\n**運営体制**\n\n- 従業員を雇わず、フリーランス協力調査員と連携\n- 就業規則の問題・交通ルール違反リスク回避のため業務委託形式\n\n**参入経緯**\n\n- サラリーマン時代: 日系金融機関子会社で経理・営業\n- 探偵歴20年超の学生時代の知人から話を聞き興味\n- 探偵学校（少人数制）→ フランチャイズ本部の誘いで埼玉・多摩エリア開業\n\n**BNI 活動方針**\n\n- **保険営業との連携を最優先:** 深い相談を受ける保険営業に「いい探偵を知らないか」と聞かれたとき応えられる存在\n- **保険営業の人脈カードの一枚** として活用してもらう提案\n- つながり希望: 弁護士、社労士、ライフカウンセラー\n\n#### 次廣側 — システムエンジニア（tugilo）\n\n**経歴・家族**\n\n| 項目 | 内容 |\n|------|------|\n| 年齢 | 53歳、SE 歴26年 |\n| 出身 | 静岡県藤枝市 |\n| 学歴 | 獨協大学フランス語学科（1998年 WC 時期入学、6年在籍後中退） |\n| 拠点 | 静岡県藤枝市在住（30歳まで東京勤務） |\n| 家族 | 妻、中3・小6の娘2人、猫4匹（チンチラシルバー3匹＋保護猫白黒1匹） |\n\n**事業内容**\n\n- 専門: **AI 業務改善システム構築**（AI 活用歴3年超、ChatGPT 登場時から）\n- 顧客: B2B 中心、一部 B2C\n- 得意業種: 建設、製造、サービス\n- 方針: 既存ツール導入ではなく **ゼロから現場に合わせた開発**、小さく始める伴奏型\n- AI コーディング自動化で従来 400〜800万円規模を **約180万円**・短納期に\n\n**ターゲット顧客**\n\n- Excel・ファイル管理が限界の会社\n- 同内容を複数箇所に転記・入力している会社\n- 特定の人がいないと業務が回らない会社\n- 忙しくて改善の手がつけられない会社\n\n**主要実績（121で紹介）**\n\n1. **害虫ブロック FC 管理システム** — 大中ブロック本部の加盟店管理・受発注。Google フォーム・スプレッドシート・Excel 分散管理を統合。200社→500社拡大対応。本部・県代表・取扱店の3層構造。活動状況可視化、マニュアル・動画配信。\n2. **インテリア取材卸業務システム** — 10年来の顧客、新人営業でも対応できる標準化。\n3. **防水工事業工程管理** — 外国人職人向け LINE 日報（文字が読めない問題を解決）、資材・活動集計→請求・給与計算。\n4. **静岡中部5市2町 観光スタンプラリー** — 鶴ヶ観光協会、LINE デジタルスタンプラリー・ビンゴ（毎年開催）。\n5. **LINE 活用** — 問い合わせ〜見積〜請求書完結、サロン・動物病院予約管理。\n\n**BNI 活動**\n\n- DragonFly 所属（入会約2ヶ月前）、全トレーニング 4月末完了予定、**ブラジルエイト取得済み**\n- チャプター 52〜53名、目標75名\n- 主催クラブ静岡所属（約140名、2年不参加だが復帰予定）\n- 学び: 「何でもできます」→ **「できることを明確に」** へ転換。Excel 限界企業に特化\n\n**事業理念**\n\n- 人の頑張りで回っている業務を仕組みで自然に回る状態へ\n- 頑張る人が損しない世界、現場に負担をかけない開発、属人化解消\n\n#### 決定事項・合意内容\n\n**相互紹介**\n\n| 方向 | 内容 |\n|------|------|\n| 礒部 → 次廣 | DragonFly 保険業メンバー **2〜3名** を紹介。レブリー側 **メンバー表** を次廣へ送付 |\n| 次廣 → 礒部 | DragonFly **メンバー表** を入手次第送付 |\n\n**連携ターゲット**\n\n| 礒部が求める紹介先 | 次廣が求める紹介先 |\n|---------------------|---------------------|\n| 保険営業（最優先） | 業務改善が必要な中小企業 |\n| 弁護士 | 税理士・社労士 |\n| 社労士 | 業務改善コンサルタント |\n| ライフカウンセラー | 補助金・助成金専門家 |\n\n#### 保留・確認事項\n\n**BNI 倫理会のシステム化**\n\n- ゲスト管理・フォローアップが完全にシステム化されていない（名刺をもらっても放置されることがある）\n- 入会促進（普及活動）の管理が不十分\n- 各チャプターがバラバラに管理。Nキャスト は機能するがゲスト管理は別\n- 次廣所感: 本部で統一システム構築を検討すべきでは\n- **予算制約:** 無償または低予算提案が必要。次廣がメンバー表改善可能性を検討\n\n**税理士メンバー不在**\n\n- DragonFly に税理士不在（重点カテゴリー指定）\n- 礒部所感: 税理士で BNI を活かせる人は少ない。既存顧客多数で新規紹介必要性低。立ち上げ当初チャプターなら参加意義あり\n\n#### アクションアイテム\n\n| 担当 | アクション |\n|------|------------|\n| 礒部 | DragonFly 保険業メンバー 2〜3名に次廣を紹介 |\n| 礒部 | メンバー表を次廣へ送付 |\n| 次廣 | DragonFly メンバー表入手後、礒部へ送付 |\n| 次廣 | メンバー表の改善可能性を確認 |\n\n#### 地域・個人的なつながり\n\n- **藤枝市共通:** 礒部義父（妻の父）が藤枝市出身・藤枝東高校卒。日系金融機関子会社で経理→根菜類。サッカー好き（藤枝・清水は静岡サッカー名門）。\n- **埼玉集中:** 礒部両親（工場移転）、兄（浦和）、本人（大宮開業）— 全員埼玉。\n- **その他:** 次廣妻から「浮気がわかるコツ」を質問 → 礒部「女性の方が勘が良い」。フランス語 × レムリの発音議論。次廣は休日外出・ジムで健康維持。\n\n#### 抽出された課題（事実）\n\n- 礒部さんは **保険営業との接点** を最優先で増やしたい\n- DragonFly メンバー表の相互共有が未完了\n- 両チャプター **税理士不在**\n- BNI 倫理会 **ゲスト管理・入会促進** の非効率（予算不足）\n\n#### 仮説（tugilo 視点）\n\n- **紹介導線:** 保険営業 2〜3名への接続が最短。竹内駿太さん（1to1 済・了承済み）を優先。\n- **保険営業が紹介チャンネルになる理由:** 家庭・相続・事故・法人リスク・従業員トラブル等の深い相談の周辺で「事実確認が必要だが誰に相談すべきかわからない」ケース。\n- **協業接点:** 税理士・社労士・補助金コンサル — 礒部の紹介希望と次廣の開拓方向が重なる。\n- **システム化候補:** 倫理会ゲスト管理は予算制約が前提。即案件化より **課題メモ化・小規模プロトタイプ** が現実的。\n- **信頼形成:** 15年トラブルなし、納得できない結果には請求しない、藤枝・フランス語・家族の自己開示で人間関係の接点あり。\n\n---','2026-05-17 22:26:13','2026-06-23 22:46:24'),
(25,1,37,119,NULL,'89314073650','Xswm1pOmRfezElNCaBsjPg==','manual','2026-05-18 17:00:00','2026-05-18 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_maeda_referral_imaishi.md#第1回】\n\n### 【第1回】実施済み（正式日時 **TODO**）\n\n#### 基本情報\n\n- **日時:** **TODO（開始・終了・曜日・JST はカレンダー／Zoom 録画メタで確定）**\n- **実施方法:** Zoom（オンライン面談・文字起こし要約より）\n- **参加者:** 次廣 淳、前田 和良（かずよし／読みは本人確認 **TODO**）\n- **紹介・接続:** 今西様からの紹介。**ドラゴンフライ・平山氏**経由で今西様と前田さんが繋がっている旨の共有あり（要約）。\n- **ソース:** ユーザー提供 **Zoom 文字起こし要約**（`[引用]` 省略）。\n- **Religo 1to1 レコード:** `one_to_ones.id = 25`（**1セッション＝DB 1行**。正式日時は TODO のため `scheduled_at = null`）\n\n#### 主な成果（エグゼクティブサマリー）\n\n- 初対面オンライン面談。**AI 活用とシステム開発の実践事例**を共有。\n- **思考 R 診断システム:** 現状フロー・課題を整理。**最小構成で開発費おおよそ50〜80万円**の見積レンジ提示、機能追加で段階拡張可能。**詳細要件確定後に要件共有→協力可否判断**の流れ。\n- **協業可能性:** 前向きに確認。**対面面談**（静岡・今西様同席）は別途日程調整。\n\n#### 話した内容（重要）\n\n**参加者・背景**\n\n- **前田 和良:** 群馬在住。マーケティング・コンサルティング。**教会関連の思考 R 診断**システムの開発ニーズ（表現・公開範囲は当事者合意前提）。\n- **次廣 淳:** 静岡在住。SE 歴 **約25〜26年**、**53歳**。B2B 中心のシステム開発。\n\n**ビジネスモデル・サービス**\n\n- **前田さん:** SNS に限定しない。**コンサルから実装ベースへ**シフトし、宿題が進まない問題に対し **動線まで含めて手を動かす**。過去にコンサル案件で相手が離脱し **約300〜400万円の赤字**経験（要約。**外部への詳細共有は慎重に**）。\n- **次廣さん:** **プロトタイプから開始し伴走で育てる**。価格の一例として、従来 **600〜800万円規模**とされる類いを **約180万円**（初期120万＋追加）で実現した事例（**プロテクトラボ社・フランチャイズ管理**）を説明。\n\n**AI 活用の実践（情報交換）**\n\n- **前田さん:** SNS 画像、ライティング整形、LP（**Genspark**）。山形県最上町の商工会から **AI 活用セミナー**依頼、**移動6時間超**で訪問予定とのこと。\n- **次廣さん:** **Cursor（Claude Code 利用）**で実装を AI に依頼、**約2〜3年**。今年から修正も AI に依頼する運用とのこと。**ブログ:** 約 **200記事**ストックから重複なく **5日分タイトル**を選び **約3,500〜4,000字**の記事を自動生成、**Facebook・X にランダム配信**、SEO・アクセス解析。\n\n**システム開発（相談案件：思考 R 診断）**\n\n- **現状:** Google Form で回答 → スプレッドシートに数値 → **手動で別システム入力** → PDF 結果。\n- **課題:** Vibe Coding 等で試作したが **修正で他が崩れる**、UX・デザインが微妙。\n- **見積:** **最小構成 約50〜80万円**、段階的拡張。\n\n**事例詳細（プロテクトラボ社）**\n\n- 全国約 **200社**取扱店の外壁ブロックメーカー。**Google Form・スプレッドシート・Excel**に分散していた業務を統合。\n- **機能:** 注文・ステータス・店別売上分析・マニュアル／動画・権限管理等。**人数を増やさず規模拡大に対応**したとの共有。\n\n**技術・業界の話題**\n\n- Access／VB 等から **Web・スマホ対応**への移行が進む。\n- **工数目安見積の限界:** AI で短期完成する案件もあり **価値ベース見積**の必要性。\n- **職業観:** ホームページビルダー時と同様、プロ領域は残り **本質的価値**がより重要。**デザイン知識あり／なしで AI 活用の質が異なる**。エンジニアも「簡単に作れる時代だからこそ」経験が効く、との議論。\n\n**次廣側・構想メモ（ローカル LM 文書管理）**\n\n- 社内の「資料探索」「重複作成」「最新版不明」へのニーズ。**ローカルネット内**で解析・要約・検索し **外部に出さない**設計。**AI に任せる領域と人の領域の分離**、上書き・削除ルールの事前定義。**実証実験継続・サービス化検討中**とのこと。\n\n#### 確認待ち（要件・論点）\n\n- 診断システム:**PDF ダウンロード vs Web 表示**、**履歴管理の範囲**。\n- ローカル LM サービス:**実証の進捗・サービス化タイミング**。\n- **コンテンツ自動生成:** 次廣手法の **他者への再現性**（再現手法・プロダクト化の検討）。\n\n#### オープンクエスチョン（未決）\n\n- Vibe Coding 系でつくったシステムの **長期安定性・保守性**。\n- Claude Code 等の **データ消失リスク**への対応。\n- コンサル一般:**成果が出ない場合の責任分界**。\n\n#### 決定事項・合意内容\n\n- **思考 R 診断:** 詳細要件が固まり次第、前田さんから次廣へ共有 → **見積・開発可否を具体化**する方向で一致（要約ベース）。\n- **対面面談:** 前田さんの **静岡訪問時**に **今西様も含め**リアルで面談・懇親の意向（日程未定）。\n\n#### アクション一覧\n\n| 担当 | 期限 | 内容 |\n|------|------|------|\n| 前田 和良 | TODO | **思考 R 診断システム**の詳細要件整理（PDF/Web、履歴範囲等）→ 次廣へ共有 |\n| 次廣 淳 | TODO | **ローカル LM 文書管理**の実証継続・サービス化の検討 |\n| 両名 | TODO | **コンテンツ自動生成・再現性**の論点は継続検討 |\n| 両名＋今西様 | TODO | **静岡でのリアル面談・懇親**（前田さん訪問時・日程調整） |\n\n#### 次回\n\n- **日程未定。** 静岡での対面を予定（今西様同席の旨、要約）。\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(26,1,37,120,NULL,'82792118979','xG0mAVPKS1Gn4YNQBvNlxA==','manual','2026-05-18 16:00:00','2026-05-18 16:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_tsuji_ryo_mainc_meo.md#第1回】\n\n### 【第1回】2026-05-18 実施済み（終了時刻 **TODO**）\n\n#### 基本情報\n\n- **日時:** **2026-05-18（月）JST 16:00–TODO**（**開始:** ユーザー確認「16:00からでOK」。調整用表示 **15:59 (GMT+9)** あり。**終了:** カレンダー／Zoom 録画で確認）\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **参加者:** 次廣 淳、辻亮（株式会社MainC）\n- **Religo 1to1 レコード:** `one_to_ones.id = 26`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※`[引用]` は省略。\n\n**共通コンテキスト**\n\n- 両者 **NEリージョン**。フォーラム等での**対面機会**（要約）。\n- 次廣: DragonFly 入会・トレーニング完了の経緯。辻: 赤坂チャプターと他ネットワーク。\n\n**辻氏の事業・強み**\n\n- 店舗**7割**、**MEO〜SEO〜HP**の一貫。**5,000店舗超**MEO実績、**飲食・医療・美容**。\n- 自社SNSフォロワー規模をクライアントに展開（YouTube / Instagram / TikTok の数値は要約参照）。\n- **ローコミ**（口コミマッチング、登録者数は要約参照）。\n- **Muスコープ**（出店分析、リリース時期・開発規模・費用・Googleライセンスは要約参照）。\n\n**次廣側の事業・スタンス**\n\n- 26年SE、3年AI活用、文系からIT。**FC案件の価格帯事例**（600〜800万相当感と120万スタート・180万以下完了の対比）を共有（要約）。\n- **AIコーディング**で見積前提を変えている（要約）。\n\n**協業・紹介のすり合わせ**\n\n- 辻: **業務改善コンサル・補助金・建設士業**希望 → 次廣ネットと合致（要約）。\n- DragonFly: **SEO/MEO枠は重点だが専門家不在**（要約）。\n- 辻: **同業協業・下請け可**。**FC本部**接点希望 ↔ 次廣側 **第一ブロックFC本部**（要約）。\n\n**ディスカッション（品質・業界動向）**\n\n- **SNS再現性:** 次廣が「バズ偶然 vs 体系化」を質問。辻: **仕組み・言語化は一定あり**、トレンド分析・強み深掘り・テクニックの検証の組み合わせ（要約）。\n- **SEOの将来:** **AIO/LLM最適化**にも言及。**しっかりSEOすればAIにも拾われやすい**との見立て（辻、要約）。\n- **SEO単体公司的な厳しさ:** 両者**同意**（要約）。次廣: **「狙ったキーワード」より生の言葉**での検索の重要性（例として「システム開発 静岡」ではなく**「エクセルが限界」**等）（要約）。次廣自身のサイトでは**AI記事自動投稿を半年〜1年**継続し**想定外KWからの流入**が増えたとの分析（要約）。辻: **業種によってはまだクリックされている**、完全AIシフトではない（要約）。\n\n**Muスコープ・データ・規約**\n\n- **ライセンス制約**により並行導入に上限（**10社まで**等、要約）。方針を**小規模民間→エンタープライズ／開業コンサル**寄りに再整理（要約）。\n- **ライセンスなし**ルートとして**レポート作成代行（1件約3万円）**も検討余地（要約）。**不動産探しとの座組**志向（要約）。\n- 次廣: **Googleマイビジネスデータを全系統合**すれば他データと組み合わせ可能、との視点（要約）。辻: **政府オープンデータとの掛け合わせ**検討、ただ **データは約2年前**などの課題（要約）。開業コンサルからのデータニーズに応えうる（要約）。\n\n**SNSオペレーション（リスク・手法）**\n\n- **顔出しNG**時は**キャスティング（撮影のみ出演者）**提案（要約）。従業員前面アカウントの**退職リスク**にも言及（要約）。**飲食以外（JRグループ会社等）**でも再生・フォロワー実績（要約）。\n\n**Googleデータ・コンプライアンス**\n\n- 次廣: 過去 **GBP起点のスクレイピング案件は断った**経緯（要約）。**規約上スクレイピングは厳しく、ライセンスが現実解**との共通認識（要約）。\n\n**DragonFly 展開の現実**\n\n- SEO/MEOは需要あるが**飲食オーナーは時間をかけられない**、**金額折り合い**が課題（要約）。辻のような**紹介先を複数**持てるとよい（次廣側コメント、要約）。\n\n#### アクションアイテム（要約どおり）\n\n| 誰 | 内容 |\n|----|------|\n| 辻 | 業務改善コンサル・補助金・建設業士業 → **次廣へ紹介** |\n| 次廣 | 飲食店コンサルの知人 → **辻へ紹介** |\n| 次廣 | DragonFly で **SEO/MEO需要のあるメンバー** → **辻へ紹介** |\n| 両者 | **2026-06-05 NEリージョンフォーラム**で**名刺交換**（辻はコンペ兼務で**オンラインの可能性**） |\n\n#### 確認待ち事項\n\n- [ ] 第1回 Zoom の**終了時刻**（JST）を YAML・本節へ反映\n- [x] `one_to_ones.id`（Religo 登録済み: `one_to_ones.id = 26`）\n- [ ] **新生会／ニック／トピック**の正式名称確認（表記ゆれ）\n- [ ] **6/5 フォーラム**の参加形式（辻氏オンライン可否の確定）\n- [ ] 紹介先の**具体名**・許諾（飲食コンサル、DragonFly メンバー、士業等）\n- [ ] **Muスコープ**の対外説明可能範囲・ライセンス条件の再確認\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(27,1,37,121,NULL,'89357445297','/kmKTakIRh+J3YUhtah6dQ==','manual','2026-05-19 14:00:00','2026-05-19 14:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_shimotsuji_hs_neo_project.md#第1回】\n\n### 【第1回】2026-05-19 実施済み（終了時刻 TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-19（火）JST 14:00–TODO**\n- **実施方法:** **Zoom**（文字起こし要約）\n- **Religo 1to1 レコード:** `one_to_ones.id = 27`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n**全体像**\n\n- 同業（受託開発・業務改善）として会社概要・AI活用・見積戦略・顧客獲得・BNI・協業可能性を相互共有。\n- **AI:** 両者とも Claude Code / Cursor 中心。工数・見積 **約3割**削減。設計・モック・提案資料で受注率向上。「秒でできる」ことで案件数増のメリット。ドキュメントはAI＋人間の読みやすさ調整。初心者のバイブコーディング破綻リスクは共有。\n- **AI持続性:** 下辻さんは Anthropic 赤字・インフラ・Claude性能低下・電力コスト等に懸念。次廣も運用リスクは認識。\n- **人材・仕事:** デザイナー・ライターはAI後も**仕事減らず増加**。「誰に頼むか」の信頼はAI代替不可。\n- **組織:** 下辻さんは法人・約10名・外注ルール化・社長は手を動かさない。次廣は個人・反射神経対応の再現困難・法人化は検討中。\n- **案件規模:** 次廣は一人で **500〜600万×複数**理想だが難しい案件も。下辻さん助言 — 一人なら **200〜300万×複数**が現実的、**600万以上は厳しい**。\n- **協業:** 設計済みの**部分コーディング**、**API連携**等の単発。見積・納期は**案件ごと相談**。\n\n**下辻さん側（会社・事業）**\n\n- 株式会社hsネオプロジェクト。独立3年半、法人化1年1ヶ月。受託 **7〜7.5割**。大規模（クラウド移行・需要予測等）。\n- 約10名、全員 Claude Code 必須。バイブコーディングで工数・見積各3割削減。\n- コールセンターDX出身。赤字→2年で黒字、売上+200万の改善実績。\n- 士業紹介は少ない。補助金提案型。見積多めだが複数通過でリソース逼迫。ウェブ・LPは収益性高く増やしたい。\n\n**次廣側（共有した要点）**\n\n- 藤枝・士業・信金紹介、補助金からの関係構築。小さな改善から入る伴走型。\n- **FC本部システム**（全国200店→500店予定）: Excel/スプレッドシートからReact Web化。通常600〜800万相当を **AIコーディングで約200万**（要約。**対外は許諾要**）。今後は価値ベース見積へ。\n- **防水工事:** 外国人多い現場、手書き日報→**LINE**入力、材料費・人件費集計。\n- **観光:** 山岳サイトはオープンWeather不十分→ジャパンWeather API（月3万）カスタムプラグイン。中部五市町**LINEビンゴ・スタンプラリー**。\n- 建設・製造など**リテラシー低い業界**向け「誰でも使える」仕組みが多い。\n\n**BNI・その他エピソード**\n\n- DragonFly 50→75目標。カーネル20名B2B。木村氏・中村氏等「買い物系」メンバー、立て岡氏（靴）は他チャプターへ移籍（要約）。\n- リファラル・トレーニングの**旅行**話で次廣が紹介約束したが未実現 — 本日想起。\n\n#### 決定事項・アクション\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| **下辻** | 提案書が複数通った場合のリソース不足に備え、次廣との**協力体制を検討** | **案件確定時** |\n| **次廣** | 下辻からの協力依頼に**予算・タイミング**に応じて提案準備 | **依頼時** |\n| **両者** | **友達申請**、継続的な情報交換・案件ベース協力 | **近日中** |\n\n#### 未解決・フォローアップ\n\n- 協力の**具体的見積基準・納期テンプレ**（案件ごと相談で合意済み、次回案件で実証）\n- 紹介してほしい相手の言語化（双方 **TODO**）\n- 田村さん経由 **SEO・FC** 紹介の進捗（**TODO**）\n- BO／RT 下辻さんとの**同一人物か**（**TODO**）\n- 初回**終了時刻**・Religo **id**\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(28,1,37,9,NULL,'83444991178','05lRf6XqSNu4hCFaDrAgGQ==','manual','2026-05-21 09:00:00','2026-05-21 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nakamura_keigo_shakumoto.md#第1回】\n\n### 【第1回】2026-05-21 実施済み（正式時刻は TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-21（木）JST TODO–TODO**（開始・終了時刻はカレンダー／Zoom メタで確認）\n- **実施方法:** TODO（対面 / Zoom）\n- **参加者:** 次廣 淳、中村 啓吾\n- **Religo 1to1 レコード:** `one_to_ones.id = 28`（**1セッション＝DB 1行**。正式時刻は TODO のため `scheduled_at = null`）\n\n#### 話した内容（重要）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] マーカーは本文では省略。\n\n**全体像**\n\n- 次廣のシステムエンジニアとしての事業内容、BNI 入会の経緯、今後の協業可能性について相互理解を深めた。\n- 特に、予約管理システムの開発状況、料金体系のパッケージ化の必要性、宮城氏（トレスステラ）との協業可能性について具体的に議論した。\n- 中村さん側からは、笏本縫製／SHAKUNONE の事業概要、新カテゴリー **「日本製ものづくり再興事業プロデューサー」** の意図、コンサルではなく町工場チームとして日本製の価値を広げる構想が共有された。\n\n**決定事項・合意内容**\n\n- **宮城氏（トレスステラ）との接続:** 中村さんが、LINE 予約システム **「リピモ」** を提供する宮城氏と次廣をつなぐ。\n- **予約システムの情報交換:** 次廣の汎用予約管理システムと、宮城氏のリピモはバッティングする可能性があるが、知見共有を優先する。\n- **メインプレゼン改善:** 中村さんは、来週予定のメインプレゼンで **コンサルではないこと** がより伝わるよう、カテゴリープレゼンを改善する。\n- **継続連携:** 中村さんのチーム参加企業に業務改善ニーズがあるため、AI導入支援・業務改善システム構築で DragonFly メンバー含め連携を深める。\n\n**次廣側の事業概要**\n\n- **拠点:** 静岡県藤枝市。ほぼオンライン完結で全国の経営者と取引。\n- **経歴:** 外国語学部卒業後、インターネットブームをきっかけにシステム業界へ転身。SE 歴25〜26年。30歳で独立し、地元に戻って事業展開。\n- **業務形態:** 一人親方として、営業・開発・納品・運用保守まで一貫対応。\n- **強み:** 専門用語に頼らず、現場の業務を人間の言葉で理解し、既存システムを押し付けずワークフローに寄り添って設計する。\n- **AI活用:** AIとの協業により、この1〜2年で業務効率が大幅に向上。時間が生まれ、BNI 活動に参加できる状態になった。\n- **方針:** 小さく始めて確実に改善し、誰でも回せる仕組み・少人数で済む仕組みを作る。\n\n**BNI 入会の背景**\n\n- **入会時期:** 2026年3月（面談時点で約2ヶ月）。\n- **紹介者:** 増本氏から長年誘われていた。\n- **事前接点:** ビジター参加を重ね、宮城氏や平岡氏とも既に面識があった。\n- **入会のきっかけ:** AI 協業で時間が生まれ、「忙しいから無理」という言い訳を克服。信頼関係の中で紹介が生まれる BNI の理念に共感した。\n- **活動状況:** 4月はトレーニング漬けで多忙。5月から落ち着いて振り返り、再受講も検討。中村さんからは **「2回目、3回目で新たな気づきがある」** とアドバイス。\n- **メンバーサポート:** DragonFly メンバーは親身。平山氏と船津さんがメンターとして支援し、増本氏とはビジビリティ向上について継続相談。\n\n**主要プロジェクト事例**\n\n1. **フランチャイズ事業の業務改善（増本氏案件）**\n   - **課題:** 全国200店舗規模のFCで、Google フォームとスプレッドシートで注文管理。顧客管理、対応記録、作業管理が別シートで、同じ情報を何度も入力。属人化により担当者不在時の対応が困難。\n   - **解決:** 注文から発送までを Web 上で一元管理。確認の手間を削減し、誰でも回せる体制を構築。500店舗への拡大を見据えて設計。\n\n2. **防水工事業の日報システム**\n   - **課題:** 外国人職人が多く、手書き日報の文字が読めない。集計時の転記作業が負担。現場状況の即時把握が困難。\n   - **解決:** LINE で日報提出できる仕組みを構築。材料使用量、人数、作業内容を日本語で入力可能にし、現場ごとの人件費・材料費を確認しやすくした。請求時の集計作業も効率化。\n\n3. **観光協会のスタンプラリー**\n   - 静岡の観光協会と連携し、10年継続中のプロジェクト。中部5市2町を周遊するイベントで、LINE から参加・スタンプ収集・プレゼント応募まで完結。\n\n4. **動物園の予約管理システム**\n   - 従来は開園前に並ぶ必要があったが、LINE で予約可能に。電話対応の負担を LINE に集約し、受付業務を軽減。\n\n**今後の事業展開と課題**\n\n- **予約管理システム:** 汎用的な予約管理システムを開発中。完成度は約80%、夏までにリリース予定。\n- **特徴:** 従来の「顧客目線」ではなく **事業者目線** の予約管理。30分の空き時間を無駄にせず、事業者側から **「何日に空いているか」** を提案する形式。\n- **料金体系の課題:** 完全カスタム対応のため都度見積もりが必要で、紹介しにくい。業務改善システムは基本的に3桁万円規模になりやすい。\n- **改善方向:** フロント・ミドル・バックエンドのパッケージ化が必要。船津さんからも同様のアドバイスを受けている。入口を低くする重要性を認識しつつ、家族の時間を犠牲にしない範囲で対応する。\n\n**宮城氏（トレスステラ）との協業可能性**\n\n- 宮城氏は、月額1,100円（税込）の LINE 予約システム **「リピモ」** を提供。ホットペッパービューティーのような機能を LINE 公式上で実現する仕組み。\n- 代理店制度があり、導入サポートで追加収益の可能性もある。\n- 次廣の予約システムとバッティングする可能性はあるが、同業者・周辺事業者との協業実績（デザイナー、コウタ氏など）もあり、まずは知見を広げるために話を聞く方向。\n\n**理想的な紹介先（次廣）**\n\n- **業務改善の必要性を感じている企業:** Excel 管理に限界を感じている、同じ内容を何度も入力している、特定の人しか分からない業務がある、業務改善を後回しにしている。\n- **成長企業:** 売上は伸びているが、現場の仕組みが追いついていない会社。\n- **理想的な紹介者:** 顧問先を持つ税理士やコンサルタント。\n- **現在の獲得チャネル:** 人からの紹介が中心。銀行や税理士からの紹介、保守を通じた継続関係が多い。今後は BNI と派生リファーラルで紹介拡大を狙う。\n\n**中村さん側の事業紹介**\n\n- **会社:** 株式会社笏本縫製（要約上「尺元」と表記揺れあり。本ファイルでは正式表記に統一）。\n- **業種:** ネクタイ・スカーフの縫製工場。工場兼ショップ形式。\n- **経営陣:** 代表39歳、中村さん34歳と、縫製業界では若い。\n- **強み:** 日本でネクタイを生産可能な縫製工場は10社未満。裁断・縫製・検査・発送まで一貫対応。縫製工場としては唯一クラスの自社ブランド（B2C）展開。若さ自体も業界での強み。\n\n**新カテゴリー: 日本製ものづくり再興事業プロデューサー**\n\n- **変更時期:** 2026年4月頃からカテゴリー変更（要約では2025年4月表記あり。参加者リスト上は2026年4月から現行表記）。\n- **目的:** SNS 発信を強化し、日本製の価値を伝える。良いものを作る町工場を集めてチームを形成し、販売会を通じて共同プロモーションする。\n- **重要な線引き:** **コンサルティングではない。** チームとして日本製の価値を広げ、参加企業全体が盛り上がることで、それぞれが恩恵を受ける構想。\n- **ビジネスモデル:** 自社のネクタイ・ハンカチ販売、オンラインショップへの継続的な顧客誘導がキャッシュポイントにもなる。\n- **チーム運営:** 現在16社が参加。LINE グループで次回出店に向けて相互支援し、メンバー同士で知見を共有し助け合う文化がある。\n- **次廣への協業提案:** 参加企業それぞれに業務改善ニーズがある。AI導入支援などで DragonFly メンバーを紹介できる可能性がある。\n\n#### アクションアイテム\n\n- **中村さん:** 次廣と宮城氏（トレスステラ）をつなぐ。\n- **中村さん:** メインプレゼンで、カテゴリープレゼンをより分かりやすく改善し、**コンサルではないこと** を明確化する。\n- **次廣:** 予約管理システムを夏までにリリースする。\n- **次廣:** 料金体系のパッケージ化を検討する。\n- **次廣:** トレーニングの再受講を継続する。\n\n#### 次回予定・フォロー\n\n- 中村さんのメインプレゼンが **翌週（2026-05-26予定）** に控えている。\n- 宮城氏紹介後、予約システムの住み分け・代理店制度・導入サポートの可能性を確認する。\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(29,1,37,122,NULL,NULL,NULL,'manual','2026-05-21 11:00:00',NULL,NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_fujimoto_yuki_tax_advisor.md#第1回】\n\n### 【第1回】2026-05-21\n\n#### 基本情報\n\n- 日時：**2026-05-21（木）JST 11:00–TODO**（開始は Zoom タイトルより。終了時刻は TODO）\n- 実施方法：Zoom\n- 紹介者：**船津麻理子さん**\n- **Religo 1to1 レコード:** `one_to_ones.id = 29`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n##### 1. 次廣の事業共有\n\n- **屋号:** tugilo（次廣 + エスペラント語 ligilo / つなぐ）。\n- **カテゴリー:** AI業務改善・システム構築。\n- **拠点:** 静岡県藤枝市。全国の経営者とオンラインで仕事。\n- **経歴:** エンジニア歴25〜26年。大学はフランス語学科、90年代後半のインターネット黎明期に独学で Web 制作を学び、大学中退後にシステム会社へ。30歳で独立。\n- **BNI参加経緯:** DragonFly 立ち上げ期から誘われていたが、多忙を理由に断り続けた。自身の業務も「Excel限界・二重入力・属人化」と同じ状態だったことに気づき、AI協業で開発工程・議事録・見積・要件定義を仕組み化。時間を作って参加。\n- **提供価値:** プログラムを書く前に業務フローを解きほぐし、必要な部分だけシステム化する。経営者と現場の間に入り、業務構造を整える。\n- **強み:** 既存ツールの押し付けではなく、現場の業務に合わせてゼロから構築できる。小さく始めて使いながら育てる。専門用語に寄りすぎず、人の言葉で業務を整理する。\n\n##### 2. 次廣の実績共有\n\n- **フランチャイズ本部（害虫ブロック）:** 全国200社から500社へ拡大する際、人を増やさず管理できる仕組みを構築。Googleフォーム・スプレッドシート・メールに分散した注文管理を統合し、体感60〜70%の業務改善。\n- **防水工事業:** 外国人労働者が多い現場で、手書き日報が読めない・間違いが多い課題を LINE 連携の日報入力で解決。人件費・材料費・時間、請求時の集計を効率化。\n- **観光局イベント支援:** 静岡中部5市2町の周遊イベントで、LINE を使ったビンゴ・スタンプラリーシステムを提供。連続4年目、今年で5年目。\n- **動物病院予約管理:** 開院前に並ぶ状態を解消し、LINE予約システムを導入。\n\n##### 3. 藤本さんの税務セカンドオピニオン\n\n- **税理士は全員同じではない:** 税金には詳しいが、相続・医療・経営支援・補助金などの強みは経歴により違う。\n- **相続は専門性が高い:** 税理士10人中3人程度しか経験がない専門領域。\n- **顧問税理士以外の意見:** 多くの経営者は顧問税理士以外からアドバイスを受けていない。記帳・申告だけなら誰でもよいが、経営サポートを求めるなら複数意見が必要。\n- **具体例:** 個人事業主の歯科医師が年間2,000万円納税していたケースで、シミュレーションにより年間900万円の納税削減を実現。10年で1億円、30年で3億円規模の差になる。\n- **補助金・助成金:** 税理士全員が詳しいわけではないため、必要に応じて専門家をつなげることにも価値がある。\n\n##### 4. 次廣への法人化アドバイス\n\n- **現状:** 個人事業主で年間売上約2,000万円、頭打ち状態。事業拡大にはパワーチーム化と自分の作業削減が必要。\n- **法人化メリット:** 個人事業主と法人で交際費枠を分けられる。所得分散で税率・枠を最適化できる。\n- **妻の役員化:** 青色専従者給与の上限ではなく、法人役員として給与設計を検討できる。\n- **社会保険料:** 国民健康保険料が高額になりやすいため、法人役員報酬の設計で最適化余地がある。\n- **顧問税理士の活用:** 高校同級生の顧問税理士に、記帳・申告以外の強みや相談できる領域を確認する。\n\n##### 5. AI・ITツール活用\n\n- **AI利用の現状:** 個人・従業員レベルで先行利用が進んでいる一方、個人情報をクラウドAIに投げる運用は問題。\n- **今後の課題:** 企業としての AI 導入ルール、セキュリティ、ガバナンスが数年以内に重要になる。\n- **企業規模差:** 中小企業はAIを使って効率化を進めやすい一方、大企業はセキュリティ面で5〜10年遅れる可能性。\n- **契約しているが使えていない問題:** Microsoft Office や Google Workspace など、有料契約していても全体として活用できていないケースが多い。\n- **LINE活用:** 通常のLINE、公式LINE、LINE WORKS の違いを知らない人が多く、導入支援だけでも価値がある。\n\n##### 6. アイケア・健康の話題\n\n- 次廣は1日10時間以上パソコン・スマホを見ており、目・肩・首の負担が大きい。\n- 視力は良いが老眼が進行。\n- パソコン作業では同じ距離で左右のピント調整が固定されるため、ピント調整機能のトレーニングで改善可能性がある。\n- アイケア相談は継続検討。\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(30,1,37,123,NULL,'85349117783','4X2npZV5QGasXKVx+eKqEA==','manual','2026-05-21 13:00:00','2026-05-21 13:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_gondo_chiemi_campanula.md#第1回】\n\n### 【第1回】2026-05-21 実施済み（開始・終了時刻 TODO）\n\n#### 基本情報\n\n- **日時:** **2026-05-21（木）JST TODO**\n- **実施方法:** TODO（Zoom 等、正式記録を確認）\n- **Religo 1to1 レコード:** `one_to_ones.id = 30`（**1セッション＝DB 1行**。正式時刻は TODO のため `scheduled_at = null`）\n- **ソース:** ユーザー提供 1to1 要約、プロフィール画像\n\n#### 話した内容（重要）\n\n##### 1. 権堂さんの事業共有\n\n- 株式会社Campanula として、企業研修・人材育成・業務改善コンサルティングを提供。\n- 教育CSR事業 Jobstudy.jp、スモールサン会員向け勉強会、キャリア教育コーディネーター養成など、教育・人材育成の実績が厚い。\n- 研修は一般論ではなく、顧客企業の実際の業務内容を使ってカスタマイズする。\n- 建設業・製造業のような現場産業に入り込み、職人・管理職・若手の成長設計を支援している。\n\n##### 2. 権堂さんの具体事例\n\n- **タイル技能者育成:** 職人ゼロの会社で、一級タイル技能士を5年で育てるプログラムを構築。一級2名・二級4名・20代若手8名定着。\n- **マネージャー育成:** 離職率25%の会社で、業務整理・権限移譲・月次フィードバックを継続し、離職ゼロを達成。\n- **評価制度:** 社長の理想から始め、現場管理職が行動ベースに修正する制度設計。全社員に基準を見える化し、外部評価もインセンティブに反映。\n- **業務フロー改善:** フロー上の工程が実際には抜けていた施工会社で、運用徹底と組織再編によりクレーム削減・売上向上・若返りを実現。\n\n##### 3. 次廣の事業共有\n\n- AI業務改善システム構築として、業務フロー整理からシステム化までを支援。\n- システムエンジニア歴26年。文系出身、DTM・ホームページ制作から IT に入り、東京のシステム会社勤務を経て30歳で独立。\n- コロナ前からオンライン業務を行い、コロナ禍でオンライン対応が追い風になった。\n- AI登場により、開発工程、議事録、見積もり、要件整理、提案資料作成が効率化した。\n\n##### 4. 次廣の具体事例\n\n- **外構ブロックフランチャイズ本部:** 全国200店舗の施工店管理が Googleフォーム・スプレッドシート・メール・Excel に分散。1年で500店舗へ拡大しても人を増やさないため、Web受注から工程管理まで一元化。\n- **防水工事業:** 外国人職人が多く、紙の日報で文字間違い・計算ミスが頻発。LINE公式アカウントから日報・工程管理を入力できる仕組みを構築し、月次請求・給与支払いの集計も自動化。\n- **観光局:** 静岡中部の地域周遊イベントで、LINEスタンプラリー・ビンゴ・アンケート機能を提供。4年継続中。\n- **動物病院:** 電話予約と窓口順番待ちを、LINE予約システムで改善。\n\n##### 5. BNI・リファラルマーケット講座\n\n- 権堂さんはリファラルマーケット講座を強く推奨。\n- 「あなたの商品・サービスは断れないほど魅力的か」「誰と一緒にビジネスをやりたいか」など、ビジネスの根幹を問う内容。\n- 一人でビジネスを作ってきたタイプにとって、衝撃的な学び・体系的なビジネス思考の習得になる。\n- 次廣は権堂さんの推奨を実行する意向を示した。\n\n##### 6. 建設業サポートコミュニティ\n\n- BNIメンバーが運営する建設業特化型コミュニティ。\n- 建設業と建設業サポート事業者が、共通言語で困りごとや協力要請を共有できる場。\n- 権堂さんは福岡支部を主催。\n- 静岡支部は次廣の居住地（藤枝市）から車で約1時間の静岡市内で開催。\n- DragonFly AI メンバーの佐藤氏が名古屋支部に参加しており、次廣も佐藤氏から誘われていた。\n\n#### 決定事項・アクション\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| **権堂さん** | リファラルマーケット講座6月の申込フォームを次廣へ送付 | TODO |\n| **次廣** | 建設業サポート静岡支部の日程を佐藤氏に確認し、参加を検討 | TODO |\n| **両者** | 継続的な情報交換と協業機会の模索 | 継続 |\n\n#### 未解決・フォローアップ\n\n- 権堂さんの正式なカテゴリー表記。\n- 権堂さんのお名前の正式な読み・漢字表記。\n- 第1回の開始・終了時刻、実施方法。\n- リファラルマーケット講座6月申込フォームの受領確認。\n- 建設業サポート静岡支部の日程・参加可否。\n- 建設業サポートコミュニティの静岡支部・名古屋支部の参加メンバー確認。\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(31,1,37,14,NULL,'84060508444','5WhkV5vUSc2lhAf6Lbg/SQ==','manual','2026-05-21 14:50:00','2026-05-21 14:45:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nishioka_foreign_trainee.md#第1回】\n\n### 【第1回】2026-05-21\n\n#### 基本情報\n\n- **日時:** 2026-05-21（木）JST 14:50〜TODO（ユーザー提供: `西岡さん121 2026-05-21 14:50(GMT+9:00)`）\n- **実施方法:** TODO（Zoom 等、確認）\n- **相手:** 西岡優希さん（DragonFly メンバー／外国人技能実習生事業）\n- **Religo 1to1 レコード:** `one_to_ones.id = 31`（**1セッション＝DB 1行**）\n- **目的:** 初回相互理解。事業内容、強み、BNIでの関係構築、相互リファラルの可能性を確認する。\n\n#### 話した内容（重要）\n\n##### 1. 次廣の事業背景\n\n- 次廣は現在52歳。文系・フランス語学科出身。\n- 90年代後半、インターネット黎明期に Mac を購入し、音楽制作と Web サイト構築に没頭。\n- 大学6年生の時にシステム会社の社長から声をかけられ、大学を中退して就職。この出会いがキャリアの原点。\n- 入社後は、コンピューター組み立て、インフラ構築、システム設計・開発、営業まで経験。\n- 技術職はコミュニケーションが苦手な人が多かったが、次廣は人と話すのが好きだったため、顧客の困りごとを聞き出し、言語化する力を鍛えた。\n- 30代で独立し、コロナ前からオンラインで全国の経営者とつながって仕事をする体制を構築していた。\n\n##### 2. AI活用による業務効率化\n\n- 以前は自分でプログラムを書いていたが、現在は設計・判断は次廣が行い、実装の多くを AI と協業して進める。\n- 議事録、要件定義、見積もり、提案資料作成も AI で仕組み化し、自分の時間を創出できるようになった。\n- この自社効率化が、DragonFly 参加の決め手にもなった。\n- 家族との時間を大切にしながら仕事を続けるためにも、頑張る人ほど時間がなくなる構造を変えたいという思いがある。\n\n##### 3. 次廣の開発哲学\n\n- 既存ツールを押し付けるのではなく、今の業務に即して現場に合わせて設計する。\n- 最初から大きく作らず、一番困っているところから小さく始め、必要なところを広げていく。\n- 最終的には「人に頼らない状態」「誰でもできる状態」を目指す。\n- 言われたものをそのまま作るのではなく、経営者や現場と話しながら、現場のワークフローを変えすぎずに負担を減らす方法を整理する。\n\n##### 4. 次廣の導入事例\n\n**外構ブロック事業（増本さんの会社）**\n\n- 全国200店舗の取扱店があり、受発注・顧客管理・対応記録が別々のツールで管理されていた。\n- Googleフォーム、スプレッドシート、メールで管理していたため、取扱店ごとの売上集計に時間がかかっていた。\n- 500店舗を目指すにあたり、人を増やさなくても回る仕組みを提案。\n- 注文受付、発送、売上管理、請求書発行、取扱店ごとの活動状況の見える化を一つの流れに整理。\n- 従来 USB メモリで配布していたマニュアルや動画も、スマホで見られるオンライン教材に変更し、教育面も支援。\n\n**防水工事業の工程・日報管理**\n\n- 名古屋の防水工事業者では、外国人職人が多く、手書き日報の字が読みにくい・間違いが多い課題があった。\n- 普段使っている LINE とシステムを連携し、LINE公式アカウントから日報を提出できる仕組みを構築。\n- 作業内容、労働時間、使用材料を現場から1日単位で提出でき、本部では請求管理・人件費・勤怠給与計算に使える形で集計できるようにした。\n\n**問い合わせ・見積作成システム（業種名は要確認）**\n\n- 問い合わせや見積依頼が紙・別ツール・LINE 等に分散し、情報引き継ぎミスが起きていた。\n- 入口を整え、顧客とは LINE でやり取りしながら、見積書・請求書の発行、問い合わせ対応をシステム上で完結できるようにした。\n- 案件状態が誰でも見えるようになり、見積もりから請求書作成までの効率が上がった。\n\n**観光業イベント支援**\n\n- 静岡の観光協会とのコラボで、周遊イベントのスタンプラリー・ビンゴを LINE で参加できる形にした。\n- 4年連続で採用されており、今後も継続予定。\n\n**動物病院・サロンの予約管理**\n\n- 電話対応の負担が大きく、顧客も待つ状況があった。\n- LINE で予約できる仕組みを導入し、顧客が自分で予約できるようにして受付負担を軽減した。\n\n##### 5. 西岡さんの事業\n\n- 建設業を約13年経験した後、約半年前から外国人技能実習生の受入れ事業を開始。\n- インドネシアなどの送り出し機関と連携し、日本に行きたい学生を受入れ先企業とマッチング。\n- ビザ申請から日本到着後の管理までを行う。\n- 多くの組合がオンライン限定や配属後は薄い対応になりがちな中、西岡さん側は実地サポートを重視。\n- 病院付き添い、24時間対応、月1回の寮訪問などを追加料金なしで提供する点が強み。\n- 実習生は異国での不安が大きく、小さな怪我や体調不良でも病院に行きたがることがあるため、組合が対応することは企業側の大きな負担軽減になる。\n- 面接時に日本のルールを守れるか、生活習慣、日本語能力を確認し、受入れ企業が選んだ人材を配属する。\n- 配属後も放置せず、日本のルールを口うるさく伝え、本人の不安を拾うことでトラブル・失踪リスクを下げる。\n\n##### 6. BNI活動・関係構築\n\n- 次廣は増本さんと5〜6年前から付き合いがあり、DragonFly 立ち上げ時から誘われていたが、忙しさを理由に断っていた。\n- AI 協業で自分の時間を作れるようになり、BOD のタイミングで改めて声をかけられ、2026年2月末に参加、3月17日に入会。\n- 入会後1ヶ月で13個のトレーニングを完了。マスモトチルドレンとしてビジビリティを上げる意識もあった。\n- トレーニングで傾聴の重要性を学び、リファラル時には相手の話を最後まで聞くことを意識している。\n- 西岡さんは「最初の1年は関係構築が一番大切」と認識しており、自分の周りでリファラルを出せるよう貢献したいと考えている。\n- 次廣も、まだ DragonFly 内でリファラルを出せていないため、メンバーとの 1to1 を増やしていきたい。\n\n##### 7. メインプレゼン\n\n- 次廣は6月にメインプレゼンを控えており、西岡さんに負けないよう頑張ると話した。\n- 西岡さんは先日メインプレゼンを実施。本人はうまくできなかったと感じているが、次廣は「人柄が伝わってくる、すごく良かった」と評価。\n- 西岡さんは建設業出身で、パソコンや人前での発表経験は多くなかったため、メインプレゼンはかなり緊張した。\n- DragonFly 内では、バーバブルの写真などで次廣の印象があり、西岡さんからは「目立っている」というイメージを持たれていた。\n\n##### 8. 相互リファラルの可能性\n\n- 西岡さんの周囲には建設業関係者が多い。\n- 次廣も、これまでのクライアントに建設業・製造業が多いため、実習生の話を聞いてみると応じた。\n- 建設業の社長は現状に満足していない一方、アナログで頭が固い人も多く、「もっと効率が良くなる」と言われてもピンと来ないことが多い。\n- 次廣は、建設業・製造業の現場に改善余地が大きい理由として、ITリテラシーが高くないこと、ただし紙が一番安心という現場感覚も理解していることを説明。\n- 今後は AI で画面の試作もすぐ作れるため、「今後こうなったらどうですか」と見せながら打ち合わせできる。\n- 西岡さんからは「業務のお悩み事から聞いてくれる人がいるよ」という形でつないでもらえればよい。\n- 次廣はすぐにシステムを売るのではなく、ヒアリングから入り、業務改善や現場の仕事を楽にすることを目的にする。\n- 建設業向けには、モック資料のような「こんな感じのことができます」と説明できる資料を作ることを約束。\n\n##### 9. 次廣の求めるリファラル\n\n- **金の卵:** 今、業務で困っている社長・管理者。\n- **金のガチョウ:** 経営者を支援しているコンサルタント・士業。\n- **協業相手:** B2C システムを作る際に協業できる Web デザイナー。\n- 「何でもできます」は答えているようで答えていないため、今後はターゲットを絞って伝える必要があると確認。\n\n##### 10. 個人背景\n\n- 次廣は10歳下の妻と結婚16年。中学3年生と小学6年生の娘がいる。\n- 猫4匹と暮らしており、チンチラシルバーの兄弟猫3匹と白黒猫1匹。\n- 趣味はキャンプ。結婚前に自分だけの趣味をやめ、夫婦・家族でできる趣味としてキャンプを始めた。\n- 旅行や健康維持のためのジムも続けている。\n- 高校時代は水球部。水中の格闘技とも言われる競技で、周囲を見ながらポジションを取り続ける経験が、全体を見渡す力につながっている。\n\n#### 決定・合意\n\n- 建設業クライアントでの相互リファラル可能性を継続検討する。\n- 西岡さんは、建設業関係者に「業務のお悩みを聞いてくれる人」として次廣をつなぐ可能性がある。\n- 次廣は、自分の建設業・製造業クライアントに実習生ニーズがあるかを聞ける可能性がある。\n- 次廣は、建設業向けにシステム化のイメージを見せられるモック資料を作成する。\n\n#### アクションアイテム\n\n- [ ] **次廣:** 建設業向けに「こんな感じのことができます」と説明できるモック資料を作成する。\n- [ ] **次廣:** 既存の建設業・製造業クライアントで、外国人技能実習生・育成就労への関心がありそうな先を思い出す。\n- [ ] **次廣:** 西岡さんの正式氏名、所属組合名、役職、終了時刻を確認して本ファイルへ反映する。\n- [ ] **西岡さん:** 建設業関係者の中で、業務改善・勤怠・日報・見積・受発注に困っていそうな社長を思い出す。\n\n---','2026-05-21 16:13:21','2026-06-23 22:46:24'),
(32,1,37,124,NULL,'85129485087','DGnP1OtXRv+Ud8UIRCc6TA==','manual','2026-05-22 09:00:00','2026-05-22 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_mitarai_fudotech.md#第1回】\n\n### 【第1回】2026-05-22\n\n#### 基本情報\n\n- **日時:** 2026-05-22（金）JST 09:00〜TODO（ユーザー提供: 本日9時から）\n- **実施方法:** TODO（Zoom 等、確認）\n- **相手:** 御手洗さん（株式会社風土テック／BNI VORTEX）\n- **紹介者:** 加門さん（BNI VORTEX）\n- **Religo 1to1 レコード:** `one_to_ones.id = 32`（**1セッション＝DB 1行**）\n- **目的:** 初回相互理解。建設業採用支援の具体像、次廣の建設業向け AI 業務改善との接点、相互リファーラル可能性を確認する。\n\n#### 主な成果\n\n- 次廣と御手洗さんが初対面し、相互の事業内容を共有した。\n- 次廣は建設業・製造業向けの AI 業務改善システム構築、御手洗さんは建設業の採用支援を専門としており、顧客層と課題解決アプローチの親和性が高いことを確認した。\n- 特に、外国人労働者の日報管理システムと採用支援の連携、顧客紹介、採用後の定着支援の文脈で具体的な協業可能性が見えた。\n\n#### 話した内容（重要）\n\n##### 1. 次廣側の事業概要\n\n- 次廣は AI業務改善システム構築をカテゴリーとし、建設業・製造業など現場管理が発生する業種を主な支援先としている。\n- システムを単に作るのではなく、業務改善のコーチとして伴走し、入口から業務フローを整理して必要な機能を段階的に追加する。\n- Google Workspace 等を使った簡易的な仕組みから、本格的なシステム開発まで、予算・現場リテラシーに合わせて対応する。\n- 強みは、専門用語を一般の人が理解できる言葉に変換し、現場の負担を増やさずに「誰でも回せる状態」を作ること。\n- AI活用により、従来 600〜800万円規模になりがちなシステムを、120万円から開始し 200万円以内程度で実現できるケースがある。\n- 主に10〜30人規模の企業が効果を実感しやすいという認識を共有した。\n- 表記メモ: 要約では「株式会社次（つぎ）」の記載あり。既存運用上は tugilo として記録しているため、法人表記は必要に応じて確認する。\n\n##### 2. 御手洗さん側の事業概要\n\n- 御手洗さんは大分県出身。病院総務、広告営業での飛び込み営業を経て、大学の先輩が代表を務める風土テックに参画したとの要約。\n- 前職の広告営業では駅の地図広告やデジタルサイネージ広告を扱っていたが、一期一会の営業だけでは顧客の本質的な課題解決につながりにくいと感じ、採用支援の道へ移った。\n- 風土テックは「採用の風土を変えるテクノロジー」という意味合いを持つとの説明があった。\n- 代表はリフォーム会社出身で、新卒採用が得意な会社のノウハウをコンサルティング事業化した。\n- 建設業の採用支援として、週1回の定例ミーティング、毎月の SNS 撮影、無料媒体（Indeed / engage 等）の記事変更、SNS・ホームページ・求人媒体の一貫性づくりを行う。\n- 動画企画、台本作成、撮影まで担当し、TikTok / Instagram など縦型動画でスマホ世代へリーチする。\n- 面接前のリマインド、内定後フォロー、MVV 策定、5年後の組織設計まで採用プロセス全体を設計する。\n\n##### 3. 御手洗さんの採用支援の哲学\n\n- 人材紹介で1人100〜200万円を支払い、辞めたら何も残らない従来型の採用支援ではなく、企業側に採用力を蓄積することを重視している。\n- 週1回のミーティングを通じて、採用について考える時間とノウハウを企業内に残す。\n- SNS で働く人の顔や雰囲気を見せ、求職者が「この人たちと働きたい」と思える情報設計を行う。\n- 採用活動は短期的な応募獲得だけでなく、会社の魅力・想い・働く人を見える化し、採用活動を資産化する取り組み。\n\n##### 4. 次廣側の具体事例\n\n###### 害虫ブロック フランチャイズ本部\n\n- DragonFly メンバー・増本さんの会社。全国施工店200社、目標500社規模。\n- Googleフォーム、スプレッドシート、別Excelで注文管理・顧客管理・対応記録が分散し、手作業転記と属人化が発生していた。\n- 受注管理・顧客管理・売上管理を1つのシステムに統合し、情報連携、確認作業削減、担当者に依存しない運用体制づくりを進めた。\n- 増本さんとは DragonFly 立ち上げ時からの知人で、4年間誘われ続けて今期入会した流れも共有。\n\n###### 名古屋の防水工事業・シーリング会社\n\n- 外国人職人が多く、紙の日報では文字が読みにくい、間違いが多いという課題があった。\n- LINE公式アカウントから日報提出できるシステムを構築。\n- 現場での材料使用量、人数、労働時間、経費を記録し、本部で集計できるようにした。\n- 現場負担を減らしながら、請求書作成の元データを自動集計できる点が、御手洗さんの採用支援先とも接続しやすい。\n\n###### 解体業の見積・請求書システム\n\n- リピートが少ない業種で問い合わせが増えにくい課題に対し、LINEで解体現場の写真を送ると仮見積もりを提示し、現地調査後に見積書・請求書を LINE / メールで送信する仕組みを構築。\n- 顧客接点を増やし、問い合わせハードルを下げる改善例として共有。\n\n###### その他事例\n\n- 静岡観光協会の周遊イベント向けスタンプラリー・ビンゴシステム。LINE連携で4年継続中。\n- 動物病院の LINE 予約管理システム。\n\n##### 5. 御手洗さん側の具体事例\n\n###### 神奈川県の水道工事会社\n\n- 週1ミーティング、毎月の SNS 撮影、無料媒体の記事変更を実施。\n- 7ヶ月で32名エントリー、7名入社という大きな成果。\n- 社長や社員の顔出し、会社の雰囲気、水道工事の仕事内容、1日の流れなどを動画で発信。\n- TikTok で興味を持った求職者が engage 等の無料求人媒体で詳細を確認し、メンバー紹介でフルネームを掲載することで安心感を高めた。\n\n###### 埼玉の電気工事会社\n\n- ベトナム人社員が在籍半年未満で、コミュニケーションや報告遅れに課題がある。\n- 紙の日報から LINE やアプリへの移行で改善できる可能性がある。\n- 御手洗さんが、この会社に LINE 日報システムを提案する可能性がある。\n\n#### 協業の可能性\n\n##### 1. 外国人労働者の採用と管理の統合\n\n- 次廣の LINE 日報システムと、御手洗さんの建設業採用支援を組み合わせられる可能性がある。\n- 西岡優希さん（外国人就労支援）との三者連携も候補。西岡さんはベトナム・インドネシアの日本語学校、支援団体ネットワーク、日本語教育、就職斡旋、病院・寮の支援まで関わる文脈がある。\n- 採用、受入れ、現場定着、日報・教育・管理までを一体で提案できる可能性。\n\n##### 2. 顧客紹介\n\n- 御手洗さんの顧客は10〜30人規模の建設業が中心で、次廣の得意領域と一致しやすい。\n- 次廣側の顧客は建設業・製造業の経営者が多く、採用課題を抱えている可能性がある。\n- 士業、税理士、業務改善コンサルとの協業も視野に入る。\n\n##### 3. 補助金・助成金\n\n- IT補助金、AI補助金（今年から新設との要約）を活用し、初期費用の半額〜2/3補助が可能な場合がある。\n- 採用支援とシステム導入を組み合わせた提案パッケージを検討できる。\n\n#### 共通人脈・紹介候補\n\n- **平岡さん:** 次廣・御手洗さん双方とつながりがあり、採用担当者がいる規模の会社を経営している可能性。\n- **増本さん:** 次廣の主要顧客。御手洗さんも建設業交流会で会ったとのこと。\n- **木村杏那さん**（旧姓 **山田杏奈**・名簿誤記「山本杏那」あり）: 業務改善系、DragonFly **2026-06-02 入会済み**（メンバー No.18）。第208回ゲスト参加時は旧姓表記。\n- **岡本さん:** 大分県出身で御手洗さんと同郷との要約。\n- **佐藤さん（名古屋）:** 高校生専門の建設業界採用支援、教育免許保有との要約。\n- **権堂さん:** 社員教育・定着支援、建設業顧客、MVV策定が得意との要約。表記「強藤氏」は権堂さんの可能性があるため要確認。\n- **山城さん:** 練馬会場トップ、全国大会（北海道）で次廣と意気投合との要約。所属・チャプター表記は要確認。\n- **西岡優希さん:** 外国人就労支援。三者連携候補。\n\n#### 決定事項\n\n- 2〜3ヶ月に1回、定期的に情報交換する。\n- 特に LINE システムの活用事例について、継続的に情報共有する。\n- 御手洗さんは風土テックのメンバー表（38名）を次廣に送付する。\n- 次廣は DragonFly の最新メンバー表を御手洗さんに送付する。\n- 6月のリージョンフォーラム（東京）で対面・名刺交換予定。\n\n#### アクションアイテム\n\n- **次廣:** DragonFly の最新メンバー表を御手洗さんに送付する。\n- **御手洗さん:** 風土テックのメンバー表を次廣に送付する。\n- **両者:** 6月リージョンフォーラムで名刺交換する。\n- **両者:** 西岡優希さんとの三者連携を検討する。2026-05-22 に西岡さんから了承を得たため、次廣から御手洗さんへグループ作成可否を確認する。\n- **御手洗さん:** 埼玉の電気工事会社に LINE 日報システムを提案する可能性を検討する。\n\n#### 紹介進行メモ\n\n##### 西岡優希さんとの三者接続\n\n- **2026-05-22 16:10 JST 前後:** 次廣から西岡さんへ、御手洗さんを紹介したい旨を打診。西岡さんより接続了承を得た。\n- **2026-05-22 16:42 JST 前後:** 次廣から御手洗さんへ、西岡さんの紹介文とともに、御手洗さん・西岡さん・次廣の3名グループを作成してよいか確認する文面を作成。\n- **西岡さん紹介の要点:** DragonFly メンバー。建設業を中心に、外国人技能実習生・育成就労の受け入れ支援を行う。日本語学校や送り出し機関と連携し、企業への人材紹介だけでなく、来日後の生活面・病院対応・寮訪問・定着支援まで手厚くサポートする。\n- **接続理由:** 御手洗さんの建設業採用支援と、西岡さんの外国人材受け入れ・定着支援は、「採用前の入口づくり」と「採用後の受け入れ・生活・定着支援」で前後につながる。\n- **次アクション:** 御手洗さんからグループ作成可否の返答を待つ。了承後、3名グループを作成し、建設業の人材不足・外国人材・定着支援の観点で情報交換へ進める。\n\n#### 確認待ち事項\n\n- 御手洗さんの下の名前、正式役職、プロフィールシートURL。\n- 次廣側の正式法人表記（要約上の「株式会社次」と既存運用の tugilo の関係）。\n- 風土テック / フードテック表記の正式扱い（公式サイトは株式会社風土テック）。\n- 御手洗さんの所属チャプター表記（ユーザー確認では VORTEX。要約内に練馬会場・修声チャプター文脈あり）。\n- 次廣の建設業・製造業クライアントで採用課題を抱える企業の特定。\n- 御手洗さんの顧客で業務効率化・システム化が必要な企業の特定。\n- 西岡さんとの外国人採用・日本語学校ネットワーク・現場管理の連携スキーム。\n- AI補助金の申請要件と対象システム。\n\n---','2026-05-22 16:46:29','2026-06-23 22:46:24'),
(33,1,37,52,NULL,'81436970113','+Q0WkZktQwWta233LUH1jw==','manual','2026-05-25 15:00:00','2026-05-25 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_noguchi_yuko_hair_salon_viv.md#第1回】\n\n### 【第1回】2026-05-25 実施済み\n\n#### 基本情報\n\n- **日時:** 2026-05-25（月）JST 15:00–TODO（Zoom 文字起こし要約反映。終了時刻は Zoom メタ等で確認）\n- **実施方法:** Zoom（カメラはノートPCシャッター閉で不具合→解決）\n- **相手:** 野口裕子（HAIR SALON ViV／BNI DragonFly → 退会決定）\n- **Religo 1to1 レコード:** `one_to_ones.id = 33`（**1セッション＝DB 1行**。終了時刻は TODO のため `ended_at = null`）\n- **目的:** お互いの事業紹介。BNI退会背景の理解。パソコン・予約・IT相談。退会後も次廣との接点継続。\n\n#### 主な成果\n\n- 野口さんは **個人経営・火曜営業** と **火曜午前のBNI定例会** が両立できず、**BNI退会を決定**。\n- 次廣は **予約管理システム** を開発中（夏頃リリース）。野口さんへ **リリース時に提案** する流れ。\n- **次廣のパソコン関連相談を無償サポート** で合意。BNI退会後もつながり継続。\n- **軍司さん** による LINE 予約システム（3ヶ月契約）が進行中であることを確認。\n- **ジンボウさん** との 1to1 を次廣経由リファラルとして実施する合意。\n\n#### 話した内容（重要）\n\n※以下はユーザー提供 **Zoom 文字起こし要約**（2026-05-25 反映）。[引用] は省略。\n\n##### 1. 野口さんの事業・退会背景\n\n- **個人経営・スタッフなし** で美容室運営。営業時間不規則（夜7時予約あり）、食事時間確保が困難。\n- **火曜営業** は千葉では差別化だが、DragonFly **火曜午前定例会** で電話対応不可。**週休2日化** が負担。\n- 約2年前にBNI入会予定→ **体調不良入院** で延期。今回入会後、**2026年5月退会決定**。\n- **自宅兼店舗ローン** を80歳まで一人返済。IT・パソコンは不慣れ、専門用語が苦手。\n- BNI負担: 毎週リファーラル/物販、メンター月曜入力催促、退会後リスト即削除、女性メンバーのドライな対応など。\n\n##### 2. 予約・集客の課題\n\n- **ホットペッパー:** 月額38,500円〜、ポイント還元で月によってマイナス。1年で有料解約、予約機能無料＋ポイント支払い継続。\n- **紙とデジタル併用** で記入漏れ・ダブルブッキング。駅店時代は通知不達トラブル。\n- 男性固定客・女性は転店傾向。クーポン新規依存。下階サロンは固定客で安定（対比）。\n\n##### 3. 次廣側の共有\n\n- **予約管理システム** 開発中（2026年夏頃リリース）。事業者目線・開業時間効率提案・個人サロン低価格・広告なし。動物病院・サロン等汎用。\n- 増本さん事例: 従来500〜800万円相当を約200万円規模で提供した文脈も共有。\n- **パソコン相談は無償** — 退会後も継続。脳梗塞後は記録習慣化、降圧剤で血圧安定など健康管理の話も。\n- BNI活用（次廣側メモ）: トレーニング出会いの他メンバー経由リファラル化、スクリーンショット記録、顧客のつながり欲求記録など。\n\n##### 4. 人脈・関連\n\n- **軍司さん:** 税理士・集客強。野口さん LINE 予約 **3ヶ月契約** 構築中。\n- **増本さん:** 近所。害虫ブロック展開、新商品スプレー販売予定。\n- **平岡さん:** BNI全国協会役員、積極勧誘。\n- **主性クラブ静岡:** 今西さん、千恵さん（看護師）等、複数 DragonFly メンバー所属。\n- **ジンボウさん:** 次廣経由で野口さんと 1to1 リファラル予定。\n\n##### 5. 当日のITトラブル\n\n- Zoomカメラが開かない → **ノートPCカメラシャッター閉** が原因。\n- BNIアカデミー **ログイン不具合** で焦燥。平山・倉持による支援歴も話題に。\n\n#### 決定事項\n\n- 野口さんは **BNI退会** するが、**次廣とのつながりは継続**。\n- 次廣は **パソコン関連相談を無償サポート**。\n- 次廣は **夏頃の予約システムリリース時** に野口さんへ提案・営業。\n- **ジンボウさん** との 1to1 を次廣経由 **リファラル** として実施。\n- 野口さんは **軍司さんの LINE システム構築（3ヶ月）** を継続。\n\n#### アクションアイテム\n\n- **次廣:** 今週中に野口さんとの 1to1 を **Religo DB 登録済み**（`one_to_ones.id = 33`）。\n- **次廣:** **夏頃** 予約システムリリース時に野口さんへ営業・提案。\n- **次廣:** 美容業界で面白い人とつながったら野口さんへ紹介。\n- **次廣:** **ジンボウさん** との 1to1 をリファラルとして手配・実施。\n- **野口さん:** 軍司さん LINE 予約システム **3ヶ月契約継続**。\n\n#### 確認待ち事項\n\n- 第1回の **終了時刻**（Zoom メタ）\n- Religo **`one_to_ones.id`**\n- **ジンボウさん** の正式氏名・事業（DragonFly 内照合）\n- 予約システム **正式リリース時期・価格帯**（夏頃の具体月）\n- 軍司さん LINE 構築と次廣予約システムの **役割分担・競合/補完** の整理\n\n---','2026-05-25 20:26:20','2026-06-23 22:46:24'),
(34,1,37,17,NULL,NULL,NULL,'manual','2026-04-03 07:15:00','2026-04-03 07:15:00','2026-04-03 08:15:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_sato_takuto_brightlink.md#第1回】\n\n### 【第1回】2026-04-03\n\n#### 基本情報\n\n- **日時:** **2026-04-03（金）JST 07:15–08:15**（60分）。**取得元:** ユーザー確認（当日の1to1実績）。※過去の Zoom要約段階では日時未記載だったため、本項で確定。\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id = 34`（**1セッション＝DB 1行**）\n\n#### 話した内容（重要）\n\n※**削減せず**蓄積。以下は Zoom要約・当時の整理メモからの**記録**。\n\n- **主な流れ:** 次廣淳（AI・業務改善システム構築）と佐藤拓斗（高校生新卒採用コンサル）が BNI ドラゴンフライチャプターで **初回 1on1**。両者の事業内容を共有し、**テレアポリスト自動作成システム**の開発可能性について具体的検討を開始。静岡県藤枝市という地元の共通点から、今後の協力関係構築の基盤を確立した、との整理。\n- **決定・合意:**\n  - **リスト作成システムの検討開始:** 佐藤氏のテレアポリスト作成業務（現在手作業で **1時間100件**）を自動化するシステムについて、次廣氏が **技術的実現可能性を調査**。\n  - **求人媒体からのデータ取得:** リクナビネクスト等の求人サイトから、**従業員数30名以下** などの条件で自動抽出する仕組みを検討。**スクレイピング技術の活用**、ただし **法的リスクの確認が必要**。\n  - **5月中旬の再会:** 佐藤氏の静岡帰省時（**5月16–17日頃**）に **対面ミーティング** を設定する方向。\n- **次廣側で共有された事業内容:**\n  - **業務改善システム構築:** エクセル・スプレッドシートで分散管理されているデータを一元化し、リアルタイムでの進捗確認を実現。\n  - **LINE活用システム:** 問い合わせから見積もり、請求までを LINE 公式アカウントで完結させる仕組み（建設業向け）。\n  - **スタンプラリー・ビンゴシステム:** 静岡観光協会向けに **5年間運用中**。\n  - **施工管理・日報システム:** 名古屋のシーリング会社向けに、外国人労働者でも入力しやすい LINE ベースの業務日報システムを構築。\n  - **事業の特徴:** ゼロから1を作れる／既製ツールの押し付けではなく現場フローに合わせたカスタマイズ。**小さく始めて改善**（大規模を一気に入れず、入力から段階拡張）。**現場負担の最小化**（経営と現場のギャップを埋め、現場にベネフィットを与える設計）。\n  - **経歴・背景:** システム開発歴 **25–26年**（大学中退後一貫、現在 **52–53歳**）。BNI は増本氏・今西氏との静岡出世クラブでの **約10年の付き合い** から **2024年** にドラゴンフライ参加を決意。動機は技術一辺倒からの転換・仕事の幅拡大。**MSP（メンバーサクセスプログラム）** で学んだビジネススキルに感銘、トレーニング注力中。\n- **佐藤側で共有された事業内容（1to1上の詳細・プロフィールと照合可）:**\n  - **高校生新卒採用の仕組み構築:** ホームページ制作、パンフレット・動画制作、学校訪問代行、求人資料郵送代行まで一括。\n  - **4月依頼でも7月解禁に間に合う** 短期対応が可能。**全国対応**（BNI参加により全国展開が加速）。\n  - **ターゲット:** 従業員 **30名以下** が中心（プロフィールは **20〜30名以下** — 会話では30名以下条件でリスト抽出の話あり）。タイプ **3つ**: ①高校生採用のやり方が分からない ②やりたいが時間・人員不足 ③応募が来ない（我流で抜けがある）。業種: 建設業、製造業、自動車整備、ビルメンテナンス、清掃、介護福祉など。\n  - **実績:** **2024年度** 29社サポート、14社で採用成功（成功率 **約48%**）。**過去5年** 毎年40社以上サポート（2023年32社、2024年は50社近く）。\n  - **経歴・背景:** 事業歴 **5年**。新卒で高校生新卒採用コンサル会社に入社、**2024年3月に独立**（当時 会社設立から **1年** と共有）。学歴: 清水東高校→静岡大学→早稲田大学編入→早稲田大学大学院（**教員免許保有**）。**将来ビジョン:** 高校生以下を対象としたキャリア教育事業。**五教科と社会を結びつける授業** で子どもの将来の選択肢を広げたい。\n- **確認待ち（会話上の論点）:**\n  - リクナビネクストからのデータ取得: **技術的実現可能性** と **法的リスク（利用規約上の二次利用制限）** を次廣氏が調査中。\n  - Google マイビジネス API: 個人事業主リスト作成について、**二次利用禁止ルール** があり、公開情報からの取得方法を検討。\n- **共通点・シナジー:**\n  - **地元:** 両者とも静岡県藤枝市出身・在住。佐藤氏は藤枝市古利（西焼津小学校区）、次廣氏は青葉町（青島中学校区）。\n  - **教育への関心:** 次廣氏は娘の受験を控え、佐藤氏のキャリア教育理念（五教科と社会の結びつけ）に強く共感。\n  - **システム×採用:** 次廣氏は静岡県の大卒求人サイト **「三並び」** のアプリ開発を受注中。**大学生がメールを見ない** ため通知機能が必要、という課題を共有。\n- **アクションアイテム（当時の整理）:**\n  - 次廣氏: 求人媒体からのリスト自動作成システムの **技術調査・提案準備**。\n  - 佐藤氏: **5月中旬の静岡帰省日程確定後**、次廣氏に連絡。\n  - 両者: **名古屋出世クラブ（5月末）** への参加可能性を検討（今西氏が佐藤氏を誘致中）。\n- **次回ミーティング:** **5月16–17日頃**、佐藤氏静岡帰省時に **対面** で実施予定。\n- **プライベート文脈（会話に出た事実の記録・紹介判断とは分離）:** 婚活、飯田氏からの占い（**32歳で結婚** 等）、保険担当の高校同級生からの紹介の動きなどが要約に含まれる。**取り扱い注意。本人確認のうえ参照。**\n\n#### 抽出された課題（事実：会話で言及）\n\n- テレアポ用リスト作成の **手作業負荷**（約1時間100件ペース）。\n- 求人媒体からの自動取得は **技術** に加え **利用規約・法的リスク（二次利用）** の確認が必要、との合意。\n- Google マイビジネス／公開情報は **二次利用禁止** の話題があり、個人事業主リストは **取得経路の設計** が課題。\n\n#### 仮説（tugilo視点）\n\n- **課題①:** リスト作成が **コンサル本業とリソース競合** している。**根拠:** 手作業1時間100件の共有。**構造（仮説）:** リード前処理が属人・手作業 → 営業・提案に振る時間が圧迫 → スケールしにくい。\n- **課題②:** データ取得は **「作れるか」より「取ってよいか」** が先に決まる。**根拠:** スクレイピング・API の **法的リスク確認** が合意事項。**構造（仮説）:** 技術要件とコンプライアンスが分離できないと、開発が進んでも運用不能になりうる。\n- **シナジー:** 「採用」周辺に **通知・進捗・フォロー** のデジタル化が横展開しうる。**根拠:** 三並び案件で **メールを見ない大学生** と通知ニーズの共有。**仮説**としての展開可能性。\n\n#### 次アクション\n\n- 次廣: 技術調査・法務・規約リスク整理・提案準備。\n- 佐藤: 帰省日程確定後に連絡 → 5/16–17頃 対面設定。\n- 双方: 名古屋出世クラブ（5月末）参加の検討。\n\n---','2026-05-25 20:26:20','2026-06-23 22:46:24'),
(35,1,37,137,NULL,NULL,NULL,'manual','2026-05-27 10:00:00','2026-05-27 10:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nampo_yuma_waibous.md#第1回】\n\n### 【第1回】2026-05-27 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-05-27（水）JST 10:00–TODO**（Zoom 文字起こし要約を 2026-05-27 10:50 JST に反映。終了時刻はカレンダー／Zoom で要確認）\n- **実施方法:** **Zoom**\n- **参加者:** 次廣 淳、南方 優馬\n- **紹介者:** 望月 雅幸（BNI DragonFly）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **35**（`members.id` = **137**、`workspaces.slug` = `bni_tifonet`）\n\n#### 主な成果\n\n- AI業務改善システム開発（tugilo）と IT導入補助金ツール・Web制作（ワイボウズ）の **協業可能性** を確認。\n- 次廣は **月9,800円×24ヶ月EC** と **AI会計ツール（開発約50万円）** に関心。\n- **相互紹介の方向性** で合意 — 次廣: 業務改善経営者・士業・銀行経由。南方: 杉山氏士業コミュニティ・ジム代行業者。\n\n#### 話した内容（重要）\n\n##### 次廣側\n\n- エンジニア歴26年。文系→DTM→SE→30歳独立。2025年3月 DragonFly 入会。AIで自身業務大幅削減。\n- 強み: 現場フロー尊重、小さく始めて拡張、属人化排除、非エンジニア向け言語化。\n- 事例: FC本部統合（Laravel+React、約200万）、名古屋防水LINE日報、静岡観光LINE（5年）、解体業LINE見積請求。\n- 見積請求カスタム **約200万円**（会計未実装）— 南方ツール50万円と比較し **非常に安価** と評価。\n- 見積は工数ベースから **ROIベース** へ移行。DragonFly参加2ヶ月で **汎用サービス化** の必要性も認識。\n\n##### 南方側\n\n- 電気工事士→IT派遣SE→Web/EC/補助金。拠点 **一宮市**。\n- **月9,800円×24ヶ月EC**（Shopify）、月約5件。200〜300万案件からBNI向け低価格化。\n- **AI会計ツール**（Clavio）— 開発約50万、サーバー月1万未満、ベンダー複製約10万/件。\n- **補助金営業代理** 30万/社、2025/4-5月売上2.5億、ツール卸2社・利益4,000万見込。\n- Tifonet は **士業メンバー不在**。杉山氏が士業コミュニティ運営。倉持氏（クラケン）と長期協業。\n\n##### 補助金・コンプライアンス（温度感の転換点）\n\n- 南方側は補助金の適法運用（納品必須・本人申請・キックバック回避等）を説明。\n- 次廣は **運用のグレーさ**（キャッシュメリット60万、ノウハウ買取・マーケットリサーチ経由の資金注入等）について **懸念・指摘**。\n- **その後（次廣所感）:** 南方さん **あからさまに不機嫌** の印象。以降の雰囲気は硬化。文字起こし要約には出ていない。\n\n##### 技術・開発\n\n- 南方ツール50万 vs 次廣同等見積200万 — コスト差を確認。\n- 次廣からWebデザイナー紹介は **不要**（南方はDragonFly内で接続済み）。\n\n##### 雑談・個人\n\n- 次廣: 121当日53歳、妻・娘2・猫4、趣味アウトドア・AI研究。\n- 双方 **愛知の取引先** が多い。\n\n#### 決定・合意\n\n- **相互紹介** の方向性確認（表向き）。\n- 南方ツール **50万円の妥当性** — 次廣が市場比較で確認。\n- **協業ポイント（文字上）:** 営業代理30万/社、ツール複製10万/件。\n\n※ **温度感（次廣所感）:** 補助金グレー指摘 **後** **不機嫌** → 終盤硬化。**協業ではなく受動的紹介のみ** と次廣判断（後述）。\n\n#### アクションアイテム（121上）\n\n- **南方:** 杉山氏・ジム代行紹介 — 次廣は **期待しない**\n- **次廣:** **能動的フォローなし**。EC需要 **明示時のみ** 受動的紹介検討\n\n#### 次廣の関与スタンス（121後・確定）\n\n- **協業パートナーにしない**\n- **グレーな商売（補助金系）には協力しない**\n- **できること:** 低コストECコンサルを探している人がいたら **繋ぐ程度**\n\n#### 確認待ち\n\n- 士業コミュニティ・ジム代行紹介 — **期待しない**\n- 第1回終了時刻（Religo DB 登録 **完了**: `one_to_ones.id=35`）\n\n---','2026-05-27 17:00:47','2026-06-23 22:46:24'),
(36,1,37,138,NULL,'83459427012','i3heZ15HSG6RW1qeTCoPBg==','manual','2026-05-28 15:00:00','2026-05-28 15:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_jimbo_ryota_snep.md#第1回】\n\n### 【第1回】2026-05-28\n\n#### 基本情報\n\n- **日時:** 2026-05-28（木）JST TODO（開始・終了時刻は Zoom／カレンダー等で確認）\n- **実施方法:** TODO\n- **相手:** 神保玲太（SNEP株式会社／BNI Diana）\n- **紹介者:** 鈴木健介（BNI Diana）\n- **Religo 1to1 レコード:** `one_to_ones.id = 36`（**1セッション＝DB 1行**。`members.id = 138`（神保玲太／BNI Diana visitor））\n- **目的:** 初回相互理解。10分ネイル・B to B・FC・Smile Nail Earth の優先順位、相互リファーラル条件、業務仕組み化の接点を確認する。\n\n#### 主な成果\n\n- 次廣は、AI業務改善システム構築、とくに **BNI向け予約管理システム** について、神保さんから美容業界の現場感に基づく具体的なフィードバックを得た。\n- ホットペッパーからの脱却支援は、予約システムだけでは不十分で、**集客不安を埋める施策**（MEO、ポスティング等）とセットで提案する必要があると整理できた。\n- 予約管理パッケージは、月額 **1万円以下**、基本 **4,980円** 程度から始め、リマインドや周期フォローなどをオプション化する方向性が明確になった。\n- 神保さんの **10分ネイル** は、ネイルを「おしゃれ」から「身だしなみ」に移し、コンビニコーヒーのように日常導線へ浸透させる戦略だと理解した。\n\n#### 話した内容（重要）\n\n##### 1. 次廣側の事業概要\n\n- 次廣はシステムエンジニア26年目。静岡県藤枝市を拠点に、**AI業務改善システム構築** を行っている。\n- 文系（フランス語学科）出身だが、1990年代のインターネット黎明期に DTM をきっかけに IT 業界へ入り、コンピューター組み立て、インフラ、Webシステム開発まで幅広く経験してきた。\n- DragonFly には 2025年3月に入会。カテゴリーは **AI業務改善システム構築**。入会後の推奨トレーニングを短期間で完了した。\n- 強みは、専門用語に寄りすぎず、経営者と現場の間に入って **人の言葉で業務を整理する** こと。言われたものをそのまま作るのではなく、現場の流れを理解し、既存システムを押し付けずに必要な仕組みを作る。\n- システム開発だけでなく、ファイル管理の改善、業務フロー整理、AI活用など、必要に応じて **業務効率化全般** を伴走する。\n\n##### 2. 次廣側の実績共有\n\n- **FC本部・害虫ブロック管理:** Googleフォーム、Excel、契約店情報が分散していた状態から、販売・顧客・契約店・売上を一元管理できるシステムを構築。店舗数が増えても管理できる土台を作った。\n- **名古屋の防水工事・LINE日報:** 外国人労働者が多く、紙の日報では誤読や集計遅れが出ていた。LINEから人数・時間・材料を現場別に提出できるようにし、人件費・材料費・請求根拠・給与計算に使える状態にした。\n- **静岡中部の観光周遊企画:** LINEから参加できるスタンプラリー／ビンゴの仕組みを構築。\n- **動物病院の予約管理:** LINE予約、前日リマインド、検診後の半年後リマインドなどを実装。神保さんからの予約システム要件と接続する事例として共有した。\n\n##### 3. 神保さんの事業概要\n\n- 神保さんは SNEP株式会社の代表。BNI Diana では現在 **10分ネイル** カテゴリーで活動している。\n- BNI歴は約5年。カテゴリーは、麻布十番のプライベートサロン、医療福祉ネイルケア、現在の10分ネイルへと変遷してきた。\n- 医療福祉ネイルケアは約2年取り組んだが、介護施設ではボランティア色が強く、収益化しにくいと判断。BNI内外のプロフェッショナルを活かす方向として、現在の10分ネイルに転換した。\n- Diana では複数期で三役を経験。プレジデント経験により横のつながりが広がり、その時の仲間とは今も関係が続いている。\n- 趣味・価値観として、HIPHOP/R&B、DJ経験、量子力学など見えないものへの関心、ゴルフ、座右の銘「コツコツが勝つコツ」、基本的に「はい」「喜んで」で受ける姿勢が共有された。\n\n##### 4. 10分ネイルの戦略理解\n\n- 神保さんは、ネイル市場の大半を占める未利用層に対して、ネイルを **おしゃれ** ではなく **身だしなみ** として広げようとしている。\n- 目指しているのは、寝癖を直す、眉毛を整える、ヒゲを剃る、爪を切る／磨く、という日常行動の中にネイルケアを入れること。\n- コンビニコーヒーのように、専門店ではない場所で **ついでにできる導線** を作り、認知と習慣化を先に起こす戦略を取っている。\n- ターゲットは、5人以上のスタッフがいる美容室オーナー、理容室・美容室オーナー、ネイルサロン以外で10分ネイルを提供できる店舗（整体・マッサージ等）。\n- 技術習得後に商材を扱えるようにし、ロイヤリティは取らず、商材販売で収益を積むモデルを想定している。\n\n##### 5. ホットペッパー問題と予約システムの方向性\n\n- 神保さんの見立てでは、美容室・サロンがホットペッパーをやめられない理由は、主に **予約システム依存** と **集客不安** の2つ。\n- ホットペッパーをやめると予約システムが使えなくなり、同時に「お客さんが来なくなるのでは」という不安が残るため、麻薬のようにやめづらい。\n- ポイント負担は店舗側持ち出しで、初回ポイントだけ利用してリピートしない顧客もいる。広告費と実際の増客を比べると、やめた後と大きく変わらないケースもある。\n- 脱ホットペッパー支援は、予約システムだけではなく、**MEO、ポスティング、地域集客** などの専門家と組むパワーチーム型が有効。\n- 美容室とネイルサロンでは顧客行動が異なる。美容室は有名店・表参道・麻布十番などへ行く動機がありやすい一方、ネイルは近場志向が強く、地域密着施策との相性が高い。\n\n##### 6. 予約システムに必要な機能\n\n- リピートしない最大の理由は「気に入らなかった」ではなく **忘れられること**。そのため、自動リマインドが重要。\n- 周期別フォローアップが必要。例: 3週間周期の顧客には3週間前、来店がなければ1ヶ月前、他店に行った可能性がある顧客には1ヶ月半後に再接触する。\n- 一度でも来店した顧客を、3ヶ月〜半年程度、自動で追い続ける仕組みが有効。\n- 次廣の予約システムは、ホットペッパーのように「空き枠から顧客が選ぶ」だけでなく、事業者側が **この時間を提案したい／この時間は開けたくない** という運用をしやすい方向が合いそう。\n- 価格は月額 **1万円以下**、基本 **4,980円** 程度から始め、リマインド・周期フォロー・カスタマイズ等をオプション追加できる構成がよい。\n- 美容室はシャンプー、パーマ、カラー中の手空き、複数スタッフの同時管理があり、ネイル・エステより予約管理が複雑。まずは業種ごとの複雑度を分ける必要がある。\n\n##### 7. 「もしもシリーズ」\n\n- 神保さんから、異業種の視点を活かす **「もしもシリーズ」** の提案があった。\n- 例: 「もしも自分がシステムエンジニアだったらどう広げるか」「もしも次廣が10分ネイルのオーナーだったらどう集客・スケールさせるか」。\n- 業界外の人が外部取締役のように見ることで、業界内では当たり前になっている改善点や新しい打ち手が見えやすくなる。\n- BNIの1to1やパワーチーム単位で実施すると、紹介・協業・商品設計のアイデア出しに使えそう。\n\n##### 8. BNI活動に関する洞察\n\n- 神保さんは、1to1の相手を「目の前の人」ではなく、その後ろに人脈を持つ **ハブ** と捉えている。\n- たまにホームランがあるため、基本的に断らず、異業種と話すことで刺激を受ける姿勢が重要。\n- 美容師など時間の切り売り型ビジネスでは、BNI活動が営業日を削ることになるため、スタッフが2〜3人以上いるかどうかが継続の分かれ目になりやすい。\n- プレジデント経験は横のつながりを作る上で大きく、BNI内の関係資産として残る。\n\n#### 決定・合意\n\n- **予約システム:** BNI向けに、月額1万円以下で始められる予約管理パッケージを検討する。\n- **価格モデル:** 基本4,980円程度から始め、必要な機能を追加できるオプション制を検討する。\n- **ビジネスモデル:** ロイヤリティではなく、商材・機能・オプション販売で広げるモデルを参考にする。\n- **脱ホットペッパー支援:** 予約システム単体ではなく、MEO・ポスティング等の集客支援者と組んだパワーチーム型で考える。\n- **フォロー:** 予約システムのプロトタイプができたら、神保さんに優先して共有し、フィードバックをもらう。\n- **関係継続:** 次廣から積極的に連絡し、定期的にフォローアップする。\n\n#### 次アクション\n\n- **次廣:** 野口さん（美容師・BNI退会予定）との接続を急ぎ実施する。\n- **次廣:** 夏に向けて、予約管理システムの基本機能＋オプション制の形を具体化する。\n- **次廣:** 予約システムのプロトタイプ完成後、神保さんへ最優先で提示する。\n- **次廣:** 増田さんの害虫ブロック管理システムのデモを後日共有する。\n- **次廣:** 神保さんへ Instagram アカウント情報を送付し、10分ネイル理解を深める。\n- **次廣:** 神保さんへ BNI／SNS 等のコネクト申請を行う。\n- **神保さん:** 美容室オーナー（スタッフ5人以上）、理容室、美容室、整体・マッサージ等、10分ネイル導入先候補を検討する。\n- **神保さん:** 次廣に合いそうな、システムエンジニア、税理士、コンサルタント、Webデザイナー等との協業可能性がある人材紹介を検討する。\n\n#### 神保さんへのお礼文（送信用）\n\n> 神保さん、本日は1to1のお時間をいただき、ありがとうございました。  \n> 10分ネイルを「おしゃれ」ではなく「身だしなみ」として広げる考え方、コンビニコーヒーのように生活導線に入れていく戦略がとても勉強になりました。  \n> また、僕が考えている予約管理システムについて、ホットペッパーをやめられない本質が「予約システム」と「集客不安」の2つにあること、リマインドや周期フォローが重要であることなど、かなり具体的なヒントをいただきました。  \n> まずは野口さんとの接続と、予約システムのプロトタイプ整理を進めます。形が見えてきたら、ぜひ最優先でご意見を伺わせてください。  \n> 今後ともよろしくお願いいたします。\n\n---','2026-05-28 17:08:50','2026-06-23 22:46:24'),
(37,1,37,18,NULL,'84716679422','itH7LYidQN2JvdnRcytlHw==','zoom','2026-06-01 14:00:00','2026-06-01 14:00:00','2026-06-01 15:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_harada_saori_ruiled_vision_japan.md#第1回】\n\n### 【第1回】2026-06-01 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-01（月）JST 14:00–15:00**（取得元: ユーザー提供 2026-06-01）\n- **実施方法:** TODO（Zoom / 対面など、会後に確認）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **37**\n- **目的:** 初回相互理解。原田さんの LEDサイネージ事業、販売代理店戦略、看板屋・電気工事士との連携、次廣の業務改善・予約管理システム構想との接点を確認する。\n\n#### ■ 主な成果\n\n- 原田さん（デジタルサイネージ事業）と次廣（システムエンジニア）が、お互いのビジネスを深く理解した。\n- 原田さんの販売代理店戦略では、**看板屋・電気工事士** が特に相性良いことを確認した。\n- 次廣から、知人の **電気工事士** を原田さんへ紹介できる可能性が示された。\n- 次廣の **ホットペッパー代替予約システム** 構想について共有し、店舗集客・予約・MEOパワーチームの接点を確認した。\n- 時間不足のため、改めて **おかわりワントゥーワン** を設定することで合意した。\n\n#### ■ 決定事項・合意内容\n\n| 項目 | 内容 |\n|------|------|\n| **相互紹介** | 次廣が知人の電気工事士への連絡・紹介可否を確認する |\n| **原田さんのターゲット** | 販売代理店獲得では **看板屋・電気工事士** が特に有力。看板屋はサイネージ問い合わせ対応の弱みを補完できる |\n| **次回** | おかわりワントゥーワンを実施予定（日時未定） |\n| **原田さん側** | 来月のメインプレゼン準備 |\n| **次廣側** | 予約管理システム開発を継続（夏頃リリース目標）、6月メインプレゼン準備 |\n\n#### ■ 原田さん側の共有内容（要約）\n\n**デジタルサイネージ事業**\n\n- 事業内容は、LEDビジョン製造、液晶サイネージ製造、販売設置、パネル修理、販売店獲得。\n- 製造元は中国深圳。静岡BNIメンバーから深圳BNIメンバー（劉社長）を紹介され、自社工場を持つサイネージ会社とのパイプラインができた。\n- 1台から納品可能で、毎回1台ずつ見積を作成できる。一般ユーザーより安価な販売代理店価格で提供可能。\n- サイネージは、野立て型、壁面型、シースルータイプ、ホログラフィックタイプ、空間演出用など幅広い。\n\n**導入・販売実績**\n\n- 大阪万博へモニター数十台を納品。\n- 島田市で土地を借りて野立てサイネージを設置。\n- 金谷のBNIメンバー店舗、吉田町のラーメン店、心斎橋のホログラフィックタイプなど導入実績あり。\n- 北海道の看板屋が販売代理店となり、2台の発注を獲得。現地看板屋が設置も担えるため、静岡から現地へ行かずに展開できる。\n\n**販売代理店戦略**\n\n- 加盟金は **550,000円**。ノルマなし、在庫不要、都道府県独占なし。\n- 販売代理店は、社内資料・研修にアクセスでき、販売代理店価格で仕入れできる。\n- BNI入会後、合計約10件の代理店獲得。先月だけで4〜5件の代理店契約が成立。\n- 成功パターンは、BNIトレーニングで同室になった看板制作カテゴリーの方、保険代理店から北海道看板屋への紹介、久米氏経由の浜松大型サイネージ案件など。\n\n**看板屋・電気工事士との連携**\n\n- 看板屋は、看板設置スキル・屋外申請許可の知識があり、サイネージ設置と相性が良い。\n- 電気工事士は、設置工事に必要な電気工事の専門知識がある。\n- 看板屋はサイン看板の仕事で忙しい一方、サイネージ問い合わせに対応できない・どこに頼めばよいか分からない・電気工事が絡み難しそう、という悩みがある。\n- 原田さんは、リファラルマーケティング講座で学んだ **「同業者こそ協業者」** の考え方を、看板屋との協業戦略に活かしている。\n\n#### ■ 次廣側の共有内容（要約）\n\n**キャリア・強み**\n\n- システムエンジニア歴 **26年**。外国語学部フランス語学科出身で、90年代後半のインターネット黎明期に音楽活動を通じてホームページ制作を始めた。\n- コンピューター組み立て、インフラ構築、システム設計開発まで一通り経験。\n- 既存ツールを押し付けず、現場のワークフローに合わせてゼロから設計できる。\n- 専門用語を使わず、相手の立場で説明できることが強み。\n\n**開発スタイル**\n\n- 最初から大きなシステムを作らず、入り口から作り、必要な機能を追加・改善していく **伴走型・育てるシステム開発**。\n- ゴールは、人に頼らない状態、誰でも回せる状態を作ること。\n- 基本的には月額保守料金内で改善要望に対応し、大きな追加コストがかかる場合のみ別途見積。\n\n**主要実績**\n\n| 実績 | 内容 |\n|------|------|\n| **第一ブロック FC本部システム** | 全国約200社のフランチャイズ本部向け。Googleフォーム、メール、スプレッドシート、Excelに分散していた受注・顧客管理を統合。作業効率6〜7割改善 |\n| **防水工事業 LINE日報** | 外国人職人の手書き日報課題に対し、LINEで材料・作業内容・労働時間を提出し、本部で集計・請求・経費管理できる仕組み |\n| **駿河企画観光局 周遊イベント** | 静岡5市2町の周遊イベント。LINEでビンゴ・スタンプラリー参加。10年継続、次回は7月開始予定 |\n| **動物病院予約管理** | B2C向けのLINE連携予約管理 |\n\n**金の卵**\n\n- Excelで限界を感じている会社。\n- 同じ内容を複数ファイルに転記している会社。\n- 特定の人しか分からない業務がある会社。\n- そのような会社を顧問先で見ているコンサルタント、税理士、会計士。\n\n#### ■ 予約管理システム構想（次廣）\n\n- DragonFly入会前から開発を計画しており、**夏頃リリース** を目標。\n- フロントエンド商材として、システム開発への入口を下げる目的がある。\n- サロン事業者が **ホットペッパーをやめたいがやめられない** 状況を課題として捉えている。\n- ホットペッパーは料金が高く、顧客リストを事業者が持てず、クーポン目当ての一見客がリピーターになりにくい。\n- 新システムは、お客様が空き枠を選ぶだけでなく、事業者が開けたくない時間を調整できる **事業者目線の予約管理** を目指す。\n- 月額10,000円以下を目標にし、MEOが得意な人とのパワーチームで **宣伝（新規集客）＋仕組み（予約管理）** をセット提案する構想。\n\n#### ■ 地域・人脈の重なり\n\n- 原田さんの娘さんが青島中学校へバスケの練習試合で訪問予定。次廣の自宅は青島中学校の目の前。\n- 青島中学校近くの寝具店 **眠りのいなべ** を双方が知っている。次廣も利用、原田さんの夫も枕を購入。\n- 島田市は原田さんの居住地で、大井川鐵道のリアルトーマスで有名。\n- 久米氏、増本氏、佐野氏など、BNI人脈の重なりも多い。久米氏経由では浜松メンバーから大型サイネージ案件が成立。\n\n#### ■ 市場観察・今後の展望\n\n- 藤枝周辺でもサイネージが増えているが、好立地に従来型看板が残っている場所も多い。\n- 銀行・マルシェ等で大型サイネージ設置が進んでいる一方、明るさや設置場所・コンテンツの質が地域受容の課題になる。\n- 単に広告を流すだけでなく、地域の懐かしい祭りの風景など、地域性を活かしたコンテンツ提案が重要。\n- 全国の電気工事士・看板屋とのパワーチーム構築により、北海道のように現地パートナーが設置まで対応する展開が可能。\n\n#### ■ アクションアイテム\n\n- [ ] **次廣:** 知人の電気工事士（公共事業・信号取り付け等に関わる方）へ連絡し、原田さんへの紹介可能性を確認する。\n- [ ] **次廣:** 予約管理システムの開発を継続する（夏頃リリース目標）。\n- [ ] **次廣:** 6月のメインプレゼン準備を進める。\n- [ ] **原田さん:** 来月のメインプレゼン準備を進める。\n- [ ] **両者:** おかわりワントゥーワンの日程を調整する。\n\n#### ■ 確認待ち事項\n\n- 次廣の知人の電気工事士を紹介できるか。\n- おかわりワントゥーワンの日程。\n- 原田さんの BNI 活動歴の正確な年月（文字起こし要約とプロフィール記載に一部揺れあり）。\n- Religo `one_to_ones.id`。\n\n---','2026-05-30 13:35:23','2026-06-24 15:48:12'),
(38,1,37,34,NULL,'86416812471','QjTZsT51Q/m770eDU1Ql0w==','zoom','2026-06-01 15:00:00','2026-06-01 15:00:00','2026-06-01 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_konaka_takaaki_becheerz.md#第1回】\n\n### 【第1回】2026-06-01\n\n#### 基本情報\n\n- 日時: **2026-06-01（月）JST 15:00–16:00**\n- 実施方法: Zoom\n- Religo 1to1 ID: `one_to_ones.id = 38`\n- 情報源: Zoom 文字起こし要約（ユーザー提供 2026-06-01）\n\n#### 主な成果\n\n- 次廣が進めている **予約管理システム** と **社内ファイル管理AIシステム（アルシルブ）** は、小中さんとの協業可能性が高いことを確認した。\n- アルシルブは、補助金活用・自治体展開・小中さんのAI研修/開発事業との連携を含め、具体的に事業化検討する対象になった。\n- 次廣が開発中の **BNI用1to1管理システム** について、小中さんは「絶対売れる」「月何十万も取れる可能性がある」と強い関心を示した。\n- 小中さん側の医療カルテ生成支援システムについて、次廣の紹介先クリニックへつなぐ具体アクションが生まれた。\n\n#### 決定事項・合意\n\n- **アルシルブの協業検討:** 次廣が社内ファイル管理AIシステムの骨組みを固め次第、小中さんが具体的な事業化支援に入る。\n- **医療カルテ生成システムの紹介:** 次廣のクライアントである田舎の個人病院の院長夫妻に、小中さん（pipon側）が開発するカルテ生成支援システムを紹介する。\n- **開発案件の相談体制:** 小中さん側（pipon等）で受けきれない開発案件を次廣に相談する。営業フィーは **20〜30%** を乗せる方向で合意。\n\n#### 次廣のBNI活用戦略への助言\n\n- システム開発はBNIで伝わりにくいため、最初の入口になるフロント商材が必要。\n- BNIメンバーは個人事業主・一人社長が多く、最初のハードルを低くすることが重要。無料/有料、有形/無形を問わず、まず接点を作る。\n- 受注よりも、VCP の **V（Visibility / 認知）** の段階として「面白いですね、やってみます」という反応を作ることを優先する。\n- 初対面の1to1同士では互いのことを覚えていないことが多いため、まずは自チャプターメンバー同士の引き合わせから始める方が現実的。\n- BNI外の裏人脈に届けばラッキーだが、基本はBNIメンバー向けに設計する。\n\n#### 予約管理システムの方向性\n\n- 夏頃のリリースを目標に、事業者側の融通を重視した予約管理システムを開発中。\n- 美容・飲食業界には、ホットペッパーをやめたいが広告不安で踏み切れない事業者が多い。\n- 予約管理単体では新規顧客にリーチできないため、MEO専門家とワンチームで広告面もカバーする戦略が有効。\n- 従来の予約システムは顧客目線が中心だが、次廣側は事業者の「ここは開けたくない」といった融通を効かせられる設計を重視する。\n- AI活用も視野に、メニュー選択後に空いている候補を3つ提案するなど、事業者側の都合を優先できる予約体験を検討する。\n\n#### アルシルブ（社内ファイル管理AIシステム）\n\n##### コンセプト\n\n- 個人レベルでAI利用が広がる中、企業として全社的に使える仕組みを提供し、シャドーAI問題に対応する。\n- クラウドサービスではなく、企業のローカル環境に構築する形式。\n- 主要機能は、社内ファイル管理、社内問い合わせ対応、資料テンプレート管理、営業資料の自動生成支援。\n\n##### ターゲット・市場\n\n- 数人規模では導入メリットが薄く、**50人以上の組織**が主対象。\n- 過去資産が蓄積され、ファイルサーバーが整理されていない長期運営企業が向く。\n- 企業より自治体の方が適している可能性があり、次廣は地方自治体に市議会議員などの人脈を持つ。\n\n##### 事業モデル・価格\n\n- IT導入補助金など、AI名称が追加された補助金の活用を検討する。\n- 補助金は下限を攻めると採択率が悪くなるため、ある程度まとまった金額設定が必要。\n- ローカル構築型のため、月額保守・運用支援モデルをどう設計するかが課題。\n- 価格は、ファイル管理業務に人を雇うコストと比較して妥当性を示す。\n\n##### 小中さんの評価・助言\n\n- 「AIは手段であり目的ではない」という前提に沿った設計で、方向性は良い。\n- 大企業が全従業員にClaude研修を受けさせることは少なく、社長や経営幹部が先行して学ぶケースが多い。\n- 現場には設計済みのスキルだけを使わせるなど、ガードレールが重要。\n- 大企業導入では、AIを前面に出すより、業務に合わせた仕組み・システム・フロントを作り、その裏でAIが動く形が現実的。\n- 商談データや社内情報の資産化という価値は、診察音声のカルテ化とも同じ発想で、世の中の流れに合っている。\n\n##### 市場検証・自治体展開\n\n- 既に複数社へ資料を見せており、「これあったらいいね」「早く作ってくれ」という反応を得ている。\n- 企業側には、個人レベルでAI利用が広がる一方で、会社として取り締まりが必要になるという課題認識がある。\n- 自治体展開では、一度導入して RFI（情報提供依頼）を握れれば、RFP を自社システムが通りやすい仕様に寄せ、半永続的な契約につなげられる可能性がある。\n- 共通コンポーネントを作り、枝葉部分を個別カスタマイズすることで、企業・自治体ともに抜けにくい状態を作る。\n\n#### 小中さんの医療カルテ生成支援システム\n\n- 小中さんが右腕として入っている pipon 社のサービス。\n- 診察音声を録音し、独自開発の音声処理基盤で無音検知・フィラー排除などを最適化したうえで、SOAP形式のカルテとして出力する。\n- 医師のカルテ記入時間を削減し、診察効率を上げ、対応可能患者数の増加とクリニック売上向上につなげる。\n- 小中さんが全案件を仕切っており、受注率は高い。\n- オンライン診療や電話応答の簡易診断にも応用可能性がある。\n- 次廣は、院長夫妻と関係が深い田舎のクリニックへ紹介する。\n\n#### BNI用1to1管理システム\n\n- 1to1を実施しても互いに覚えていないことが多く、1時間の時間投資に対してリファラル1件程度は考えないと割に合わない、という課題から開発。\n- Zoom文字起こしを自動取得し、議事録化する。\n- 過去記録から「この人には誰がおすすめか」を提案できる。\n- チャプターごとにメンバー、ブレイクアウト、会話内容、1to1履歴を記録する。\n- Markdown形式で保存し、ローカルではそのデータをもとに提案内容をまとめている。\n- OpenAI連携でオンライン化を進めており、現状は次廣用に強くカスタマイズされている。\n- 小中さんは商業化の可能性を高く評価。法人向けマッチング会社や営業組織でも、営業マンの肌感・勘所がデータ化されていない課題に転用できる可能性がある。\n\n#### 次廣の技術スキル・受注実績として共有したこと\n\n- システムエンジニア歴26年。\n- BtoBシステムはほぼ全般対応可能。会計システムのみ税法上の問題で未経験。\n- 得意分野は工程管理・現場管理システム。\n- 知らない人たちの大きいプロジェクトに投入され、プロジェクトマネージャーを2年間担当した経験がある。\n- 最近の実績として、松本案件（約200万円＋月額3万円保守）、WebView形式のアプリ開発（約300万円）、WordPressカスタムプラグインの小規模対応などを共有。\n- SES的な人月売りより、委託開発での受注を希望。ピンポイント相談は気軽に受ける姿勢。\n\n#### その他の議論\n\n- BNIのコネクト未入力問題は、期日を守らない行動として信頼低下につながる。\n- ウェブマスター業務の負担が大きく、定例会中にスレッド対応で内容を聞けていない問題がある。\n- スライド送りの自動化は、台本・キーワード検知で可能性はあるが、リアルタイム性や話すスピード差が課題。\n- 次廣も小中さんも、常に効率化を考えるタイプ。AIによって頭の中のアイデアを音声入力だけで形にできる、技術者にとって良い時代になったという認識で一致。\n\n#### アクションアイテム\n\n- 次廣: アルシルブの骨組みを固め、小中さんと具体的な協業検討に入る。\n- 次廣: 田舎のクリニック院長夫妻に、小中さんのカルテ生成支援システムを紹介する。\n- 次廣: BNI用1to1管理システムを、誰でも使える形に改良する。\n- 小中さん: pipon で受けきれない開発案件があれば次廣に相談する。\n- 小中さん: 単発の開発案件があれば次廣に相談する。\n\n---','2026-05-30 13:35:23','2026-06-24 15:48:12'),
(39,1,37,51,NULL,'89001802997',NULL,'zoom','2026-06-01 16:00:00',NULL,NULL,'canceled','target_convenience',NULL,'2026-06-04 10:54:33',NULL,'2026-05-30 13:35:23','2026-06-04 10:54:33'),
(40,1,37,140,NULL,'83714290448','i4hQDaQNQeCR0Rc2oz4Yqw==','zoom','2026-06-01 17:00:00','2026-06-01 17:00:00','2026-06-01 18:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_terada_tifonet_engineer_collaboration.md#第1回】\n\n### 【第1回】2026-06-01\n\n#### 基本情報\n\n- **日時:** 2026-06-01（月）JST 17:00-18:00\n- **実施方法:** Zoom（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id = 40`\n- **紹介者:** 西浦さん\n- **相手:** 寺田直史さん（株式会社ハーベスト／BNI Tifonet）\n\n#### ■ 概要\n\n- 次廣と株式会社ハーベストの寺田さんが初回121を行い、システム開発・SES・AI業務改善領域での協業可能性を確認した。\n- 寺田さんのSES事業は、エンジニアへの **90%還元＋ボーナス** を特徴とし、多重下請けで大きく中抜きされる業界構造への問題意識から立ち上げられている。\n- 次廣は、知人エンジニア紹介、キャパシティ超過時のSES活用、アイビーコミュニケーションズ（要表記確認）藤井氏への紹介、法人格が必要な案件でのフロント企業協力について前向きに合意した。\n\n#### ■ 決定事項・合意内容\n\n- **エンジニア紹介:** 次廣が知人エンジニアを寺田さんのSES事業へ紹介する。紹介者には、稼働開始後1ヶ月分の利益を還元する仕組みがある。\n- **案件の相互協力:** 次廣が受注した案件で自分のキャパシティを超える場合、寺田さんのSESエンジニア活用を検討する。\n- **要件定義と実装の分担:** 寺田さんのチャプター内にいる経験20数年・AI活用エンジニアが要件定義を担い、次廣または寺田さん側エンジニアが実装するパワーチーム構想を検討する。\n- **アイビーコミュニケーションズ紹介:** 次廣が名古屋のアイビーコミュニケーションズ藤井氏（BNI ワンスポンス所属、表記要確認）を寺田さんへ紹介し、一次受け案件の獲得機会を作る。\n- **フロント企業協力:** 大手クライアントとの契約で法人格が必要な場合、寺田さんの会社がフロント企業となり、次廣が実装を担当する形も検討する。\n- **AI関連相談:** 寺田さん側にAI関連案件が来た場合、次廣へ相談する。\n\n#### ■ 寺田さん・株式会社ハーベストの事業理解\n\n- **会社名:** 株式会社ハーベスト\n- **代表:** 寺田さん（正式表記は要確認。ユーザー提供では寺田直史、Zoom要約では寺田直行表記あり）\n- **体制:** 社員11名、アルバイト11名、常用業務委託10〜12名、合計32〜33名規模。\n- **事業内容:** フリーランスエンジニアのマッチング、Web広告代理、ホームページ制作、人工芝施工販売、フォトスタジオ運営、人材紹介、外構工事。\n- **SESモデル:** 還元率90%＋ボーナス。一般的なSES会社が30〜40%抜く構造に対し、ハーベスト側の利益を8%程度に抑え、エンジニアへ還元する。\n- **成長戦略:** 広告費を大きく使わず、エンジニア紹介者へ稼働1ヶ月分の利益を還元して紹介ベースで広げる。\n- **現状課題:** 立ち上げ1年半で稼働中エンジニアは1名。フリーランス中心のため案件終了時に離脱しやすく、継続案件・一次受け案件の確保が課題。\n- **今後:** フリーランスだけでは限界があるため、正社員採用も進める。正社員の場合は還元率80%想定。\n\n#### ■ 次廣側の共有内容\n\n- **事業名:** tugilo / 次廣のAI業務改善システム構築。要約内では「次色」「レギロ」表記があるが、正式なプロダクト名は Religo、屋号・事業名は tugilo として要整理。\n- **強み:** 現場のワークフローを大きく変えず、手間を減らすゼロベース開発。小さく始め、段階的に改善する伴走型。\n- **AI駆動開発:** 3年前からAIと協業し、コーディングの大部分をAIに任せることで開発効率を高めている。\n- **主な実績:** 全国200店舗規模のフランチャイズ本部システム、名古屋の防水工事業向けLINE日報・工程管理、静岡中部観光協会の周遊イベント、動物病院のLINE予約管理など。\n- **価格戦略:** 工数見積もりから、ROIや年間効率化効果を示す価値ベース見積もりへ転換。営業手数料は最終見積もりに対して20%上乗せまでを許容し、それ以上は受けない方針。\n\n#### ■ 共通認識・業界観\n\n- AI駆動開発により、単純な工数見積もりや多重下請け構造は今後厳しくなる。\n- 経験者がAIを使う開発と、未経験者がAIを使う開発では品質に大きな差が出る。\n- クライアント側も、AIでモックや要件を具体化できるようになり、システム会社・SES会社への見方が変わっていく。\n- システム業界の多重下請け構造は建設業に近く、クライアントが中抜き構造の無駄に気づくタイミングが来る。\n\n#### ■ BNI・カテゴリー戦略メモ\n\n- 次廣は「システム構築」だけではBNI内で紹介ハードルが高く、個人事業主に伝わりやすいフロント商材として予約管理システムを準備している。\n- 寺田さんは、リフォームリノベーションから人工芝施工卸へカテゴリー変更予定。BNIでまず成功体験を作るため、慣れている人工芝に寄せる戦略。\n- 寺田さんは「人に物を売るのは得意ではない」と認識しており、協業を軸にした戦略に振り切る意向。\n\n#### ■ 保留事項・要確認事項\n\n- 寺田さんの正式氏名表記: ユーザー提供は「寺田直史」、Zoom要約内は「寺田直行」。名刺・BNIプロフィールで確認する。\n- アイビーコミュニケーションズの正式社名表記と、藤井氏との初回面談日程。\n- 次廣が紹介できるエンジニアの人数・年齢層・稼働条件。\n- 大元クライアントを紹介してもらった場合の紹介料・営業フィー設定。\n- 寺田さんのチャプター内エンジニアとのパワーチーム構想の進捗。\n- 次廣の予約管理システムのリリース時期（夏予定）。\n\n#### アクションアイテム\n\n##### ▼ 寺田直史さん\n\n- パワーチーム構想の提案資料を作成し、営業活動を開始する。\n- AI関連案件が来た場合、次廣に相談する。\n\n##### ▼ 自分（次廣）\n\n- 知人エンジニア数名を寺田さんへ紹介する。\n- 10年前にフリーランスエンジニア事業化の相談を受けた人物に連絡し、寺田さんへ紹介できるか確認する。\n- アイビーコミュニケーションズ藤井氏に寺田さんを紹介し、一次受け案件の獲得機会を作る。\n- 自分のキャパシティを超える開発案件が出た場合、寺田さん側SESエンジニア活用を検討する。\n\n##### ▼ 両者\n\n- 今後の案件で協業機会があれば相互に相談する。','2026-05-30 13:35:23','2026-06-23 22:46:24'),
(41,1,37,27,NULL,'89109217407','9Wcixbz/Tiyj6ubYB4XquA==','zoom','2026-06-03 15:00:00','2026-06-03 15:00:00','2026-06-03 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_yamamoto_yoko_idemitsu_credit.md#第1回】\n\n### 【第1回】2026-06-03 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-03（火）JST 15:00–16:00**\n- **実施方法:** Zoom（要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **41**\n- **セッションの性格:** **ほぼ次廣の話を聞いていただく形**。葉子さんの事業深掘りは不足 → **おかわり121** を合意。\n\n#### 主な成果\n\n- 次廣（システムエンジニア・**藤枝在住**）と葉子さんの初回1to1で、**動物病院向け予約システム** に関する具体的な連携機会を特定。\n- 葉子さんが **静岡県獣医師会賛助会員** として動物病院へアプローチを始めるタイミングと、次廣の **名古屋動物病院でのLINE予約実績**（約5年運用・他院推奨意向）が合致。\n- **相互紹介＋チラシ配布** による共同営業の方向で合意。\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| チラシ作成 | 次廣が動物病院向けシステムの **1枚チラシ** を早急に作成（葉子さんが概要説明できるレベル） |\n| 共同営業 | 葉子さんが動物病院へカード提案訪問する際、次廣のチラシを **同時配布** |\n| 獣医師会ルート | 静岡県獣医師会事務局の承認を得て、会員向けチラシ配布を **検討** |\n| 対面・デモ | **2026-06-06** リージョンフォーラムで対面 → その後 **藤枝** でシステムデモ付き詳細打ち合わせ |\n| おかわり121 | 葉子さんの事業・紹介条件を改めてヒアリング |\n\n#### 次廣側の共有（要約・第1回）\n\n**経歴・スタンス**\n\n- SE歴 **26年**、AI活用 **3年目**。文系（フランス語）出身、90年代後半からHP制作経由でIT。30歳で独立し静岡へ、**23年間** 個人事業（屋号 **次廣＝名前＋エスペラント「つなぐ」**）。\n- 強みは **現場に合わせた伴走型**（紙→タブレット、最小機能から段階拡張、属人化解消）。コミュニケーション・要件整理が得意。\n\n**主要実績（話した事例）**\n\n| # | 案件 | 要点 |\n|---|------|------|\n| 1 | 増本氏関連・外壁ブロックFC | 全国200施工店、Googleフォーム+スプレッドシート→一元化、効率60–70%改善、500店舗まで拡大の土台 |\n| 2 | 名古屋・防水工事 | 外国人労働者多め、LINE日報、集計・請求・給与計算連携 |\n| 3 | 駿河企画観光局 | 「どうする家康」周遊スタンプラリー（LINE）、4–5年継続。**新シーズンは2026年7月開始予定**（要約の年表記は2026に校正） |\n| 4 | **名古屋・動物病院** | 獣医3名、午前午後の長い並び・電話負担→ **LINE予約**、補助金で導入コスト抑制、**約5年運用**・他院推奨意向 |\n\n**BNI・紹介の考え方**\n\n- 増本氏から2年前に誘いを受けていたが多忙で見送り。**AIで業務改善し時間ができた**こと、オンライン中心のDragonFlyが働き方と合うことから **2026年3月** に参加（葉子さんは **4月**、約1ヶ月後）。\n- システムは高額でリファーラルが出にくい → **入口商材**（低価格・低ハードル）が必要。受注の中心は依然BNI外。\n\n**個人（雑談・信頼づくり）**\n\n- 家族: 10歳年下の妻、娘2人（中3・小6）。猫4匹（チンチラシルバー系兄弟3＋保護猫1）。\n- 趣味: キャンプ・家族旅行、ジム、娘のダンス→ **Dリーグ** Dr.メッセンジャーズ観戦（2026年5月・お台場アリーナ等）。\n- スポーツ歴: 高校 **水球部**（静岡4校のみ、県大会出場圏）。\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 次廣 | 動物病院向けシステム説明 **チラシ作成**（早急） | 初版 [`materials/animal_hospital_line_reservation_flyer_202606.md`](materials/animal_hospital_line_reservation_flyer_202606.md) |\n| 山本 | 動物病院訪問時にチラシ **配布**、関心ある病院を紹介 | TODO |\n| 山本 | 静岡県獣医師会事務局へチラシ配布 **可否確認** | TODO |\n| 両者 | **2026-06-06** RFで対面 | 予定 |\n| 両者 | RF後 **藤枝** でデモ付き打ち合わせ（日程詳細 **TODO**） | TODO |\n| 両者 | **おかわり121** 実施 | TODO |\n\n#### 保留・確認事項\n\n- チラシの **PDF化・デザイン**（文案初版は `materials/animal_hospital_line_reservation_flyer_202606.md`）\n- 獣医師会事務局の **配布許可**\n- 藤枝デモの **日時**\n- 名古屋導入病院の **推奨コメント** をチラシに載せられるか\n\n---\n\n### 【おかわり121】未実施\n\n- **目的:** 葉子さんの **強み・理想顧客・切り出しトーク・Contact Circle** の言語化。動物病院以外の優先業種の確認。\n- **日時:** TODO\n\n---','2026-05-30 13:35:23','2026-06-23 22:46:24'),
(42,1,37,139,NULL,'85054251043','RdBgZ2BpQF6nq437OGYGDA==','zoom','2026-06-04 09:00:00','2026-06-04 09:00:00','2026-06-04 10:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_fukuda_kohei_anfunini.md#第1回】\n\n### 【第1回】2026-06-04 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-04（水）JST 09:00–10:00**\n- **実施方法:** Zoom\n- **紹介:** 越賀淑恵さん（5/19定例会ビジター参加後）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **42**\n\n#### 主な成果\n\n- 静岡のシステムエンジニア（次廣）と神奈川の教材開発者（航平）の **初回1on1**。\n- ビジネス紹介の方向性、AI活用（ChatGPT初稿→Claude/Gemini仕上げ）、**スマホ専用教材**へのシフト、子育て・受験・教育業界構造について深い意見交換。\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| 紹介（次廣→） | Excel限界企業、社内システム課題企業、WEBデザイナー協業 |\n| 紹介（航平→） | 小〜中規模塾のオーダーメイドテキストニーズ |\n| 教材方針 | A4印刷中心 → **スマホ・タブレット最適化**・デジタル中心へ検討 |\n| 発信 | インスタ継続、ターゲットは **塾運営者** 向けに最適化 |\n| 次回 | 未定。BNI再会時に進捗共有。航平からネタあり次第連絡 |\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 次廣 | 娘の志望校決定後、学習計画を妻と相談（夏〜秋） | TODO |\n| 次廣 | 航平のインスタをフォローし教材サンプル確認 | TODO |\n| 次廣 | DragonFly内で塾関係者・教材ニーズを探索 | TODO |\n| 航平 | スマホ専用オンライン教材プロトタイプ着手 | TODO |\n| 航平 | Claudeで教材ブラッシュアップ試験 | TODO |\n| 航平 | インスタショートをAIで1日3本目標 | TODO |\n| 航平 | 自習スペース＋スマホ預かりの市場調査（韓国モデル） | TODO |\n| 航平 | 次廣長女の受験状況を定期的フォロー（アドバイス） | TODO |\n| 両者 | BNI DragonFlyで再会時に進捗共有 | — |\n| 両者 | 相互ビジネス紹介を探索 | 継続 |\n\n#### 保留・確認事項\n\n- 価格設定・提供方法（オーダーメイドテキスト）\n- スマホ教材の技術・プラットフォーム\n- 韓国型自習スペースの日本需要\n- 次廣長女: 夏以降の学習計画、10月までの吹奏楽と部活引退後のスマホ時間\n\n---','2026-05-30 13:35:23','2026-06-23 22:46:24'),
(43,1,37,99,NULL,'87970810668','EpAXFCa/QpOjsVdWaEVClw==','zoom','2026-05-29 14:00:00','2026-05-29 14:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md#第2回】\n\n### 【第2回】2026-05-29 実施済み（業務改善ヒアリング）\n\n#### 基本情報\n\n- **日時:** **2026-05-29（金）JST 14:00–15:00**\n- **実施方法:** **Zoom**（文字起こし要約より）\n- **Religo 1to1 レコード:** `one_to_ones.id = 43`（**1セッション＝DB 1行**）\n- **目的:** 前回終盤に出た **業務改善・既存システム改善**について、現在の具体的な困りごとをヒアリングする。\n- **結果:** PDF注文書の手入力自動化を第一段階とし、既存 VB + Oracle を温存した社内 Web インターフェース案で提案書・簡易モック作成へ進む。\n\n#### 今日の進め方（次廣側メモ）\n\n最初から提案を押し出すのではなく、まず困りごとを聞く。そのうえで、Google Workspace / GAS で小さく試せる例を提示し、木村さんの現場に近いものがあるか確認する。\n\n**冒頭トーク案**\n\n> 前回、VB + Oracle の既存システムや、Excel で ODBC 接続して加工されている話を伺いました。  \n> 今日はまず、いま実際にどこで困っているかを教えていただきたいです。  \n> そのうえで、全部をいきなり作り替えるのではなく、Google Workspace や GAS を使って、今の運用を活かしたまま小さく効率化できる部分があるかもしれません。  \n> いくつか例を持ってきたので、近いものがあるか見ながらお話しできればと思っています。\n\n#### Google Workspace / GAS 活用例（話題提供）\n\n**1. Oracle / Excel の集計結果を Google スプレッドシートに自動反映**\n\n- **現状イメージ:** Excel で ODBC 接続し、手作業で加工・集計している。\n- **例:** 毎日・毎週決まったタイミングで CSV 出力 → Google スプレッドシートに取り込み → 集計表を自動更新。\n- **効果:** 確認用の表を毎回作り直さなくてよくなり、社内共有もしやすくなる。\n- **確認したいこと:** 今、Excel で毎回作っている表・一覧・集計は何か。\n\n**2. 案件・調査・製本工程の進捗管理表を Google スプレッドシート化**\n\n- **現状イメージ:** 案件・調査・製本工程の状態が、個別 Excel、口頭確認、担当者の記憶に散らばっている。\n- **例:** 案件ごとに「受付中／調査中／確認待ち／制作中／納品済み」などを一覧化。\n- **効果:** 誰が見ても、今どこで止まっているか分かる。\n- **確認したいこと:** 「あの案件どうなっている？」と確認が発生しやすい業務はどこか。\n\n**3. Google フォームで社内依頼・確認事項を受ける**\n\n- **現状イメージ:** メール、口頭、LINE、紙などで依頼や修正指示が散らばる。\n- **例:** 製本依頼、調査依頼、修正依頼、確認事項を Google フォーム入力にし、回答をスプレッドシートに蓄積。\n- **効果:** 依頼内容の抜け漏れを減らし、後から検索できる。\n- **確認したいこと:** 依頼内容が散らばって困っている業務はあるか。\n\n**4. GAS で期限・確認漏れを自動通知**\n\n- **現状イメージ:** 担当者が覚えている、または手作業で追いかけている。\n- **例:** 「3日以上未対応」「納期前日」「確認待ち」の案件をメールや Google Chat に通知。\n- **効果:** 催促・確認・抜け漏れチェックの手間を減らせる。\n- **確認したいこと:** 納期前・確認待ち・未対応で、毎回人が見に行っているものは何か。\n\n**5. 顧客ごとの Google Drive フォルダを自動作成**\n\n- **現状イメージ:** 資料の保存場所やファイル名が人によって違い、探す時間が発生する。\n- **例:** 新規案件登録時に、顧客名・案件番号付きフォルダを自動作成し、テンプレ資料も配置。\n- **効果:** 資料の置き場所が統一され、引き継ぎや確認が楽になる。\n- **確認したいこと:** 顧客資料・調査資料・成果物の保存ルールは統一されているか。\n\n**6. 家系図・ルーツ調査の調査メモ管理**\n\n- **現状イメージ:** 戸籍、文献、調査メモ、成果物、顧客対応履歴が分散しやすい。\n- **例:** 顧客ごとに調査ステータス、参照文献、確認事項、成果物リンクをまとめる。\n- **効果:** 過去案件を再利用しやすくなり、調査ノウハウが社内資産化する。\n- **確認したいこと:** 過去の調査記録・文献メモ・成果物テンプレを再利用できる状態になっているか。\n\n#### 今日の着地点\n\nGoogle Workspace / GAS で全部を解決するのではなく、次の3分類に整理する。\n\n1. **GASで小さく改善できるもの**\n2. **既存 Oracle を活かして連携した方がいいもの**\n3. **Web化・クラウド化まで考えた方がいいもの**\n\n**締めトーク案**\n\n> Google Workspace や GAS で全部を解決するというより、まずは「今の業務を変えずに、手作業・確認・転記を少し減らせる場所」を探すイメージです。  \n> 今日お聞きした内容から、GASで小さく改善できるもの、既存 Oracle を活かして連携した方がいいもの、Web化・クラウド化まで考えた方がいいものに分けて整理できればと思っています。\n\n#### 必ず聞く質問\n\n- 毎週・毎月、必ず手作業で作っている表や資料はありますか？\n- 「この人に聞かないと分からない」業務はどこですか？\n- Excel で ODBC 接続している処理のうち、特に手間が大きいものは何ですか？\n- Google スプレッドシートや GAS で、まず自動化したい作業を1つ選ぶなら何ですか？\n- 顧客資料・調査資料・成果物は、どこに、どのルールで保存されていますか？\n\n#### 実施後議事録（Zoom文字起こし要約ベース）\n\n※以下はユーザー提供の **Zoom 文字起こし要約**に基づく記録。[引用] は元テキストのマーカー（本ファイルでは省略）。\n\n**全体像**\n\n- 次廣が、BPS木村／株式会社国宝社の製本システムにおける業務効率化ニーズをヒアリング。\n- 木村さんは、三菱関連会社が開発した **VB + Oracle の基幹システム**を運用しており、PDF注文書の手入力が大きな負担になっていると共有。\n- 次廣は、既存 VB システムに直接手を加えず、新たな Web インターフェースを社内サーバー上に構築し、PDF注文書を解析して Oracle DB に登録する改善案を提示。\n- 数日以内に、次廣が **提案書と簡易モックを無償で作成**し、実現可能性と費用感を提示することで合意。\n\n**決定事項・合意内容**\n\n- **PDF自動入力の実現方針:** 既存 VB システムには手を加えず、新しい Web ベースの入力画面を作る。PDF注文書をアップロードし、解析結果を確認・修正してから Oracle DB に書き込む。\n- **システム構成:** 既存 Windows サーバーの **Hyper-V** 上に Linux ベースの Web サーバーを構築し、社内ネットワーク経由でアクセスできる構成を検討する。\n- **Google Workspace は今回は主軸にしない:** 外部アクセスやセキュリティリスクを考慮し、既存 VPN 環境を活かした **社内完結型**を優先する。\n- **段階的な実装:** 第一段階は最も負担の大きい **PDF入力自動化**。第二段階で日報などの Excel 帳票の Web化、多端末対応を検討する。\n- **得意先直接入力:** 将来的には得意先向けの直接入力システム提供も可能性として認識。ただし初期スコープには入れない。\n\n**現状の課題**\n\n- **手入力の負担:** 事務員が月間300〜400件（大口顧客のみ）、全体ではその倍近い件数の PDF 注文書を手作業で入力している。\n- **システム構成:** 三菱関連会社が開発した VB + Oracle の基幹システムが稼働中。\n- **データ構造:** ヘッダーとフッターが 1:N の関係。本のパーツごと（表紙、本文、カバー等）に銘柄やメーカーを選択する必要がある。\n- **注文書フォーマット:** 出版社ごとに注文書フォーマットが異なる。PC作成データだけでなく、手書きのものも存在する。\n- **既存改善:** ODBC 経由で Oracle からデータを読み出し、日報作成・分析・伝票出力に活用している。\n\n**提案された解決策**\n\n- **PDF自動入力システム:** 大口顧客の PC 作成 PDF 注文書から優先的に自動化する。手書きは初期対象外または後回し。\n- **入力画面:** ブラウザ上で PDF をドラッグ&ドロップし、解析結果を画面上で確認・修正してから登録する。\n- **DB連携:** Oracle のテーブル定義書を参照し、キー項目、英字項目名、画面項目との対応、シーケンス番号、トリガーに配慮した書き込みロジックを設計する。\n- **サーバー環境:** Windows サーバー上の Hyper-V に Linux Web サーバーを立てる。PC やスマートフォンから社内 Wi-Fi 経由でアクセス可能にする。\n- **セキュリティ:** 外部インターネット公開は行わず、外部からは既存 VPN を利用する。新規外部回線は不要。\n- **参考事例:** 次廣が別顧客向けに進めている VB + SQL Server 環境から Web ベースへ移行する案件と同様の考え方で進められる。\n\n**確認待ち事項**\n\n- **データベース定義書:** テーブル構造、キー項目、英字項目名と画面項目の対応関係。\n- **サンプルPDF:** 注文書フォーマットの実例。機密情報はマスクまたは非公開扱いでよい。\n- **DB書き込み権限:** ODBC 経由で書き込み設定が可能か、または別接続方式が必要か。\n- **VBシステム保守体制:** 三菱関連会社への相談状況、既存システムの保守・改修方針。\n\n**アクションアイテム**\n\n- **次廣:** 数日以内に提案書と簡易モックを作成し、実現可能性と費用感を提示する（無償対応）。\n- **木村さん:** データベース定義書とサンプル PDF を次廣へ共有する。\n- **次廣:** 1to1後のアンケートに回答し、リファラル機会を探る。\n\n**BNI活動・パワーチーム知見**\n\n- 木村さんは 1to1 を **週8件**目標、1件につき1リファラル創出を目標にしている。最大で1日8〜10件行うこともある。\n- 週次計画表で家族時間、トレーニング、商談、BNI活動を色分け管理。2034年のゴールから逆算して、年・月・週に落とし込んでいる。\n- 1to1後に Google フォームで興味分野をチェックしてもらい、リファラルにつなげる運用をしている。\n- パワーチーム構想として、創業30年以上の老舗企業向けに、理念整理、ホームページ、システム改善を一体で提供する **第二創業支援**が話題になった。\n- 次廣側は、1to1やブレイクアウトルームの会話を Markdown で記録し、AIで紹介先を提案する仕組みを自作していると共有。\n\n**技術・AI活用に関する議論**\n\n- 社員が個人レベルで ChatGPT 等へ機密情報を投げる **シャドーAI問題**への懸念を共有。\n- 日本企業は今後1〜2年で AI 利用ガイドライン整備が必要になる、という見立て。\n- AI の普及により非技術者でも技術者風の発言ができる一方、実装後のトラブル増加が懸念される。\n- 補助金を引き出すことが目的化したグレーなシステム提案は断った経験を次廣が共有。信頼できる技術パートナーの見極めが重要。\n\n**交換されたフィードバック**\n\n- **木村さん → 次廣:** YouTube や SNS での話し方のテンポ、人を引き込む表現力、技術的理解の深さ、DB構造を把握している点への安心感。\n- **次廣 → 木村さん:** 家系が政治家や教師という背景による話術の資質、時間管理と BNI 活動の計画性、1to1からリファラルを生むアンケート活用への評価。\n\n**次回予定**\n\n- 次廣が提案書と簡易モックを提示した後、具体的な実装範囲と費用について協議する。\n- 引き続き 1to1 を通じて、BNI活動の知見交換と相互支援を継続する。\n\n---','2026-05-30 13:35:23','2026-06-24 15:49:21'),
(44,1,37,113,NULL,'88597252767','MF27uxnKT2aqvRtXjdXckQ==','zoom','2026-05-29 09:00:00','2026-05-29 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_furuya_shuji_telecom_cost.md#第1回】\n\n### 【第1回】2026-05-29\n\n#### 基本情報\n\n- **日時:** **2026-05-29（金）JST TODO**（開始・終了は Zoom／カレンダーで要確認）\n- **実施方法:** **Zoom**（文字起こし要約ベース・2026-05-29）\n- **相手:** 古屋周治（合同会社TF 代表社員／スマホドクター静岡葵／守成クラブ静岡会場代表／BNI インフィニティ∞・DragonFly 第208回ゲスト）\n- **紹介者:** 増本重孝（BNI DragonFly・害虫ブロック）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **44**（`members.id` = 113／古屋周治 guest）\n- **目的:** 初回相互理解。通信／害虫ブロック／不動産の三本柱、相互リファーラル条件、守成クラブの縁を活かした継続接点を確認する。\n\n> **固有名詞の注記（音声認識の揺れ）:** 製品名は **害虫ブロック**（音声認識で「外注」と誤変換されやすい）。「**古谷**」＝**古屋**。FC 名は「昭庵」ではなく **鐘庵（かねあん）**（次廣の長期保守先 FC 本部）。\n\n#### 話した内容（重要）\n\n※ユーザー提供の **Zoom 文字起こし要約**（2026-05-29）ベース。\n\n**事業共有**\n\n- **次廣:** B2B/B2C のシステム開発 約25〜26年。**会社ごとにフィットさせるカスタマイズ開発**が強み（汎用パッケージは持たない）。**鐘庵（かねあん）フランチャイズ本部**のシステムを10年以上保守。**AI連携の事業者提案型予約システム**を開発中。\n- **古屋:** **不動産仲介・通信回線販売（スマホドクターFC）・害虫ブロック代理**の三本柱。ドクターモバイル（個人向け980円〜5,000円台）、光回線の全国対応＋キャッシュバック、**担当者制の迅速・中立対応**が差別化。課題は **B2C 中心で一気に拡大する型が見えない**こと。\n\n**協業の具体化**\n\n- **鐘庵本部直営店（静岡・愛知 10店舗以上）の通信回線見直し**＝月7,000円程度のコスト削減余地。次廣が回線契約書を共有 → 古屋が固定費削減提案。\n- **予約システム:** ホットペッパー代替として、MEO コンサルと組んだ集客動線。**月額5,000円以内**のサロン向けパッケージ化を検討。\n- **害虫ブロック事業の課題:** 都道府県別代表制で全国展開企業（例: ナック）に一括導入できない／ピタカット液剤の単体販売が取扱店の顧客を奪う懸念／**P-Link 統合**は松本氏が検討中（成分を薄めたスプレー版を入口商品にする案）。\n\n**BNI**\n\n- **次廣:** NE リージョン（2024-03 加入・2ヶ月でトレーニング完了・全オンライン）。松本氏・今西氏と定期飲み会。紹介者は水島氏（高校来30年以上）。\n- **静岡リージョン:** 約150名・朝6時半・対面・県内商売中心。古屋が代表（吉野氏との距離感に留意）。\n\n#### 決定・合意\n\n- **鐘庵の通信回線見直し:** 次廣が契約書を共有 → 古屋が固定費削減提案を作成。\n- **予約システム:** 事業者が空き時間を提案できる新方式を **夏までにリリース予定**。\n- **BNI:** 松本氏・今西氏らとの定期飲み会を継続しネットワーク強化。\n\n#### 次アクション\n\n- **次廣:** 鐘庵の現行通信回線契約書を古屋へ送付（即時）／予約システムのパッケージ化（月額5,000円以内）を検討し古屋に相談／来週の飲み会で害虫ブロックの課題を議論。\n- **古屋:** 鐘庵の回線契約を確認し固定費削減提案を作成／MEO・マイビジネス対策を学習。\n\n---','2026-05-30 13:35:23','2026-06-23 22:46:24'),
(50,1,37,143,NULL,'89131000556','PXefpCDtQfa6IVkp6a9ohA==','zoom','2026-05-21 11:00:00','2026-05-21 11:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(52,1,37,144,NULL,'87313500925','TXIaXTwPQaiXBiKVTc9pfA==','zoom','2026-05-19 17:00:00','2026-05-19 17:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(53,1,37,145,NULL,'86985144664','j3BnDbqfRRu5kHrKvgax6g==','zoom','2026-05-19 16:00:00','2026-05-19 16:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_tanabe_hikaru_telecom_sns.md#第1回】\n\n### 【第1回】2026-05-19 予定\n\n#### 基本情報\n\n- **日時:** **2026-05-19（火）JST 16:00–17:00**（終了は Zoom／カレンダーで要確認）\n- **実施方法:** **TODO**（Zoom 想定 — 招待元で確認）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **53**（`members.id` = **145**）\n\n#### 話した内容（重要）\n\n- （会後記入）\n\n#### アクションアイテム\n\n- （会後記入）\n\n---','2026-05-30 13:35:23','2026-06-23 22:46:24'),
(59,1,37,53,NULL,'82431536307','4ycbbif/RP29DE6HgPlDoQ==','zoom','2026-05-08 18:00:00','2026-05-08 18:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(60,1,37,13,NULL,'82219483510','kuFarPqvSbyZcnkZhlebpA==','zoom','2026-05-08 17:00:00','2026-05-08 17:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(62,1,37,146,NULL,'82336493242','OKWxBvjsTPyTZfh1Fk7/NA==','zoom','2026-05-07 09:00:00','2026-05-07 09:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(63,1,37,147,NULL,'82098291556','w04V3WLZTqOdBPBRLddqYA==','zoom','2026-05-01 17:00:00','2026-05-01 17:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(64,1,37,17,NULL,'82144696668','hSM5Q+RMS5C8RhTSLcRR8Q==','zoom','2026-05-01 14:00:00','2026-05-01 14:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(65,1,37,148,NULL,'86886689396','HIJgRFSzQeKajNVl/0ci9Q==','zoom','2026-05-01 09:00:00','2026-05-01 09:00:00',NULL,'completed',NULL,NULL,NULL,NULL,'2026-05-30 13:35:23','2026-05-30 13:35:23'),
(66,1,37,12,NULL,'85842362927',NULL,'zoom','2026-06-04 15:00:00','2026-06-04 15:00:00','2026-06-04 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nishiura_miyabi_draci.md#第1回】\n\n### 【第1回】2026-06-04\n\n#### 基本情報\n\n- **日時:** 2026-06-04（水）JST **15:00–16:00**\n- **実施方法:** Zoom（西浦さんがレコーディング。次廣が画面共有。途中 PC 切替のため一度切断・再接続）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **66**\n- **主題:** ① Draci 掲示板機能の進捗報告 ② WordPress **3層アカウント管理** の説明・合意\n\n---\n\n#### ■ パートA — 3層アカウント管理体系\n\n##### 背景・現状の課題\n\n| 論点 | 内容 |\n|------|------|\n| **平岡氏のアカウント** | 現状、WordPress **管理画面全体** にアクセス可能 |\n| **平岡氏の意向** | 管理作業は **一切したくない・触りたくない** |\n| **実運用** | ログイン情報は **西浦さん** に渡され、西浦さんが実質的な管理を担当 |\n| **次廣の懸念** | 以前から「平岡氏がこの権限状態で運用できるのか」と疑問を持っていた |\n\n##### 合意した3層構成\n\n| 層 | アカウント種別 | 権限・用途 |\n|----|----------------|------------|\n| **1** | **ドレスシー管理者アカウント**（平岡氏用） | 会員の **承認管理など限定的な機能のみ**。通常メンバーと同様の **ログイン専用** に変更 |\n| **2** | **WordPress システム管理アカウント** | テーマ・設定など **技術的管理機能**。システムを動かす人専用。**1アカウントで十分**（複数人が同時ログインして作業可能） |\n| **3** | **通常メンバーアカウント** | 一般ユーザー向けの標準アクセス。プロフィール自己編集・掲示板利用等 |\n\n##### 決定事項\n\n- **アカウント体系の分離:** 平岡氏のアカウントを通常メンバーと同様の **ログイン専用** にし、別途 **システム管理用アカウント** を作成する\n- **管理画面へのアクセス制限:** 平岡氏は WordPress 管理画面を **一切触らない**。システム運用者向けログインを **別途用意**\n- **管理者アカウント数:** システム管理用は **1つで十分**（複数人同時ログイン可）\n- **作業の無償提供:** 提案書に基づく作業は **既存プロジェクトに含め、追加費用なし**\n- **権限設計の考え方:** 管理画面は普段使わない想定。誤操作防止のため不要機能へのアクセスを制限\n\n##### 会員登録フロー（現状）\n\n1. 新規メンバーが **LINE** で登録申請\n2. **Myria-mu** 側でオリエンテーション\n3. ユーザー枠を作成し **パスワードを発行**\n4. メンバーに情報を渡し、**自分でプロフィールを作成**（Nキャスト方式）\n5. **西浦さん** がユーザー作成〜パスワード発行まで担当。**平岡氏は登録プロセスに直接関与していない**\n\n##### 確認待ち・技術検討\n\n| 項目 | 状態 |\n|------|------|\n| **同一アカウントでの同時ログイン時のバッティング** | 次廣が確認中（「大丈夫だと思う」が **未検証**） |\n| **具体的な権限設定の詳細仕様** | 今後詰める |\n\n##### アクション（アカウント）\n\n| 担当 | 内容 |\n|------|------|\n| **次廣** | WordPress アカウント管理体系を **3種類に分離** して設定 |\n| **次廣** | 平岡氏用権限を **通常メンバーレベル** に変更 |\n| **次廣** | **システム管理用アカウントを1つ** 新規作成（複数作成も可） |\n| **次廣** | **西浦さんと一緒に** アカウント整理作業を実施 |\n\n---\n\n#### ■ パートB — Draci 掲示板・支部検索の進捗（再接続後）\n\n##### 主な成果\n\n- **掲示板機能の基本実装が完了** し、**テストサーバーでの確認段階** に到達\n- 西浦さんから **当初想定より早い完了** について高評価\n- **プラグインなし** で基本機能を実装できたことが成功要因として共有された\n- **支部検索機能** が新規要件として浮上。**来週中の実装** を目指す\n\n##### 完了した機能（掲示板）\n\n| 機能 | 状態 |\n|------|------|\n| **カテゴリー選択・投稿・添付ファイル** | 実装済み |\n| **カテゴリー検索** | 別画面で実装。検索結果を下部表示 |\n| **スマートフォン対応** | 表示最適化が必要な箇所を特定 |\n| **基本仕組み** | 見た目調整は残るが **機能要件は充足** |\n\n##### 決定事項（掲示板・支部）\n\n| 決定 | 内容 |\n|------|------|\n| **テスト公開** | 次廣がテストサーバーを構築し、西浦さんからアクセス可能にして要件確認 |\n| **フォント変更** | 現状の明朝体から **別フォントへ**（西浦さん要望） |\n| **支部検索** | ユーザー管理画面に **支部選択項目** を追加。会員紹介ページで **支部による絞り込み** |\n| **検索仕様** | **単一選択**（チェックボックス式ではない）。1支部選択で該当メンバーのみ表示。未選択時は **全国表示** |\n| **支部と地域の関係** | 掲示板の **地域選択** と会員管理の **支部** は **別概念** と確認 |\n\n##### 新規要件: 支部検索機能\n\n**背景:** 支部が今後設立されていく予定。メンバーに支部情報をタグ付けしておくと将来の管理が容易。\n\n**ユーザー管理側**\n\n- ユーザー編集画面に **支部選択項目**（プルダウン想定）\n- **カスタムフィールド** で支部情報を拡張する可能性\n\n**会員紹介ページ側**\n\n- 各メンバー表示に **支部情報** を追加（アイコン・名前・HP に加えて）\n- 左側に **支部検索**（掲示板カテゴリー検索と同様の UI）\n- 支部未選択時は全国メンバー表示\n\n**未確定**\n\n- 支部名称（東京支部等）は **今後決定**\n- WordPress ユーザー管理の拡張・カスタムフィールド／プラグインの選定は調査中\n\n##### 確認待ち\n\n| 項目 | 内容 |\n|------|------|\n| **掲示板の要件充足** | テストサーバー公開後、西浦さん側で実要件を満たしているか確認 |\n| **支部名称** | 具体名は未確定 |\n\n##### アクション（掲示板・支部）\n\n| 担当 | 期限目安 | 内容 |\n|------|----------|------|\n| **次廣** | **当日〜翌日** | 掲示板 **テストサーバーリンク** を西浦さんへ送付 |\n| **西浦** | リンク受領後 | テストサーバーで掲示板確認し **修正点を FB** |\n| **次廣** | **来週中** | 支部検索の実装方法を調査・実装 |\n| **次廣** | — | 掲示板 **フォント変更** |\n| **次廣** | — | **スマートフォン表示** の見やすさ改善 |\n| **次廣** | — | 掲示板追加に伴う **レイアウトずれ** の修正 |\n\n##### 次回確認\n\n- **明後日:** 西浦さん参加予定（**翌日は不在**）\n- テストサーバー確認後の **詳細 FB**\n- **来週中:** 支部検索の実装状況確認\n\n---','2026-06-04 01:43:27','2026-06-23 22:46:24'),
(67,1,37,51,NULL,'81031997027',NULL,'zoom','2026-06-17 13:00:00','2026-06-17 13:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_iida_kaori_libero.md#第1回】\n\n### 【第1回】2026-06-17（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-17（水）JST 13:00〜**（終了時刻 TODO）\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id` = **67**\n- **目的:** 初回相互理解。次廣の事業紹介・紹介してほしい相手像共有。香さんの BCP 担当文脈から、DragonFly 向け BCP システム開発可能性を確認。\n\n#### 話した内容（重要）\n\n##### 1. 次廣の事業紹介・BNI参加経緯\n\n- 次廣は静岡県藤枝市在住のシステムエンジニア。B2Bの業務システム開発を中心に、営業・要件整理・設計・開発・運用まで一人で伴走するスタイル。\n- 大学は外国語学部フランス語学科。文系出身で、IT用語に寄せず、経営者や現場の言葉で業務を整理できることを強みとして説明した。\n- DragonFly には増本さんから立ち上げ当初から何度も誘われていた。AI活用で自分の業務効率化が進み、時間を作れるようになったため、**2026年3月**に増本さん紹介のゲスト参加から入会した。\n- BNIトレーニングを通じて、26年間「何でもできます」で仕事をしてきたが、BNIでは **「何でもできる＝何もできない」** と見られやすいことを学び、カテゴリーや入口商材の見直しを検討している。\n- 現在のカテゴリー「営業業務改善システム構築」は長く伝わりにくいため、BNI内ではサロン予約システムなど、より紹介しやすいフロント商材を設ける方向で検討している。\n\n##### 2. 次廣の実績・紹介してほしい相手像\n\n- **増本さんの害虫ブロックFC事業:** Googleフォーム・スプレッドシート等に分散していた注文・顧客・取扱店（全国200社超）情報を一元管理。リアルタイムで売上確認でき、500社規模への拡大を見据えた土台にした。\n- **防水工事業（名古屋）:** 外国人職人の手書き日報を LINE 連携システムに置き換え。労働時間・材料費・経費を日報で送信し、請求時の集計を自動化。約5年稼働中。\n- **静岡観光協会・越新町祭り:** LINE と QR コードを使ったスタンプラリーシステムを開発・運用中。地域イベントの周遊施策として約10年関わっている。\n- 紹介してほしい相手は、二重入力・手作業・Excel限界・属人化で困っている経営者や担当者。製造業・建設業・サービス業など、現場ワークフローが固まっている会社と相性がよい。\n- 初回相談・課題整理・改善提案までは無料で対応できると説明した。\n\n##### 3. 香さん側の状況・BNI 1年目の振り返り\n\n- 香さんは今月末で BNI 加入1年となり、来月から2年目に入る。\n- 初期は内部リファーラルを中心に動きがあったが、次第に停滞。リアルイベントやリージョンフォーラムに参加できなかったこと、121をほぼ自分から申し込む形だったことを課題として共有した。\n- 扱っている商品の代理店が多く、チャプター内にすでに契約者がいる場合もある。増本さんにも乗り換え提案をしたが、既存契約の関係で難しかった。\n- 静岡チームは9〜10人規模で仲がよく、増本さんが「背中を見せる兄貴」のような存在になっている点を、香さんが羨ましいと感じている。\n\n##### 4. BCP活動とシステム化の可能性\n\n- 香さんは BCP 担当として、地震・津波・台風・大雨などの災害情報を自分で収集し、チャプターへ発信している。BNI本部の BCP グループより、自分の発信の方が早いこともある。\n- 現在の安否確認は未システム化。メッセンジャーでチームリーダー経由で集約しており、確認漏れや遅延が起きやすい。\n- 香さんが、別チャプターのエンジニアが作った既存の安否確認システムを紹介。既存案は地震中心で、津波・台風・大雨までは十分ではない可能性がある。\n- 次廣は、気象庁 API 等との連携により、震度・津波・台風・大雨などを自動検知し、LINE・メールで同時配信、ワンタップで安否報告（無事／被災）する仕組みは作れると回答した。\n- DragonFly はメンバー所在地が全国に点在しているため、エリア単位の検知・通知が重要になる。\n- 既存システムが月額課金型であるのに対し、香さんは役員交代時の引き継ぎを考えると **買い切り型** を希望。次廣も DragonFly 向けには買い切りで対応可能と伝えた。\n- 費用感は通常 60〜80万円規模になり得るが、DragonFly 向けには **30万円前後** を目安に、格安での提供を検討できると共有した。\n- ただし、すでに別チャプターの既存システムを横串で紹介しようとしていた経緯があり、今期中に次廣案を出すと後出しに見える可能性があるため、香さんは慎重に進める姿勢。\n\n##### 5. メインプレゼン・人物理解\n\n- 次廣は 2026-06-23 の DragonFly メインプレゼンに向けて準備中。リハーサルで清原佳彩美さん・西浦雅さんから大きな改善意見を受け、人となりを前面に出す方向へ再構成している。\n- 西浦雅さんから「次廣さんはそんなんじゃないのに、なぜそんなつまらないプレゼンにしようとするのか」という趣旨の率直なフィードバックがあり、自己紹介・人物像・仕事観を出す必要性を再認識した。\n- 香さんからは、次廣がドラトークやバーバブルに積極的に参加し、遅くまで DragonFly の活動に関わっていることを評価された。\n- 太田一誠さんが自己肯定感の低さを話していた際、次廣が「みんなあなたのことが好きだから大丈夫」と励ましたエピソードも共有された。\n\n##### 6. 紹介候補\n\n- 香さんから、精密機器・医療機器部品を製造する中小企業の社長候補が挙がった。朝3時から出社するほど多忙で、在庫管理が Excel 手入力の状態とのこと。\n- 次廣は、直接訪問して無料で相談・課題整理できると伝えた。香さんがまず訪問し、その後に次廣への紹介を検討する。\n\n#### 決定事項・次アクション\n\n- **香さん:** 別チャプターの BCP システム資料を次廣へ共有する。\n- **次廣:** 資料受領後、DragonFly 向け BCP システムの機能範囲・費用感・買い切り案を整理する。\n- **香さん:** 精密機器・医療機器部品製造業の社長へ直接訪問し、システム相談の場を設定できるか確認する。\n- **次廣:** 2026-06-23 のメインプレゼンに向け、人となりを前面に出した内容へ再構成して臨む。\n- **両者:** 今回は次廣側の話と BCP システム相談で時間を使ったため、次回は **香さんのビジネス紹介・プロフィールシート共有を中心にした「香さんタイム」** を実施する。\n\n#### 校正メモ（Zoom 要約）\n\n| 要約上の表記 | 校正後 | 理由 |\n|--------------|--------|------|\n| 2024年3月に正式入会 | **2026年3月** | 既存の入会経緯・ライブドキュメントと整合 |\n| 静岡県筆田市 | **静岡県藤枝市** | 次廣の居住地 |\n| 主制クラブ | **守成クラブ** | 既存プロフィール・人脈表記と整合 |\n| 宮城さん（メインプレFB文脈） | **西浦雅さん** | 既存メモで「みやび」が「宮城」と誤変換されやすい |\n| 伊世さん | **太田一誠さん** | 既存の固有名詞補正と整合 |\n\n---','2026-06-04 01:43:27','2026-06-23 22:46:24'),
(68,1,37,149,NULL,'85299085926',NULL,'zoom','2026-06-15 11:00:00','2026-06-15 11:00:00','2026-06-15 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kimura_anna_andirich.md#第1回】\n\n### 【第1回】2026-06-15（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-15（月）JST 11:00〜**（終了時刻 TODO）\n- **実施方法:** Zoom（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **68**\n- **目的:** 最近DragonFlyへ移籍してきた木村さんの仕事理解。次廣がウィークリープレゼンで伝えてきた「建設業・Excel限界・業務改善」という説明と丸かぶりしやすく、メンバーがどちらに紹介すればよいか迷う可能性があるため、杏那さんが活きる紹介文・次廣との伝え分け・Google Workspace / Kintone 改善とWebシステム化の協業可能性を確認する。\n\n#### 話した内容（重要）\n\n##### 1. 次廣の自己紹介・業務説明\n\n次廣から、現在53歳のシステムエンジニアで、30歳から独立し、現在は一人会社として開発・要件整理・運用を行っていることを共有した。\n\n主な説明は、顧客の課題を聞き取り、技術用語を避けながら、現場の言葉で解決策を提案するスタイル。建設業・製造業・サービス業など、紙・Excel・LINE・スプレッドシートで業務が散らばっている会社に対し、業務フロー整理からWebシステム化まで対応している。\n\n問い合わせ経路としては、FacebookやXなどのSNS、紹介経由が多いことも共有した。DragonFlyのZoom中心の1to1は、移動時間が不要で効率的に関係構築できる場として捉えている。\n\n##### 2. サービス内容の重複と伝え分け\n\n次廣がウィークリープレゼンで伝えている「建設業・Excel限界・業務改善」の説明と、杏那さんのカテゴリーが近いため、DragonFlyメンバーが紹介先を迷う可能性があることを共有した。\n\n杏那さんは、自社はエンジニア会社ではなく、主に **スプレッドシート / Google Workspace / Kintone** を使って、現場に合う業務管理の仕組みを作る立ち位置だと説明した。独自のシステム開発そのものは担当範囲外であり、ここが次廣との分担ポイントになる。\n\n整理としては、杏那さんは **現場に近い業務整理・スプレッドシート/Google/Kintoneによる管理ツール・運用伴走**、次廣は **Webシステム化・DB化・外部連携・権限管理・専用システム化** という伝え分けが自然。\n\n##### 3. 杏那さんの既存スプレッドシートパッケージ\n\n杏那さんは、建設業向けにスプレッドシートで構築した既存パッケージを説明した。Zoom要約上では名称が **「現率」** と **「現実」** で揺れているため、正式名称は要確認。\n\n主な機能は以下。\n\n| 領域 | 内容 |\n|------|------|\n| **マスター管理** | データベース、顧客リスト、作業者情報など |\n| **案件管理** | 案件情報、作業・業務管理、日報、画像の自動蓄積 |\n| **売上・利益管理** | 売上管理、利益率計算、取引・案件ごとの管理 |\n| **在庫・材料管理** | 在庫管理、材料情報の管理 |\n| **書類・指示書** | 指示書発行、書類発行 |\n| **スケジュール** | Googleカレンダー連携により、全体スケジュールを共有 |\n| **サポート** | 基本6ヶ月のサポート。Zoom要約上の金額は **22,000円** |\n\n既存パッケージは、買い切り型で提供されているが、Zoom要約上の「98,000円から98,000円」は表記として不自然なため、正確な価格体系は要確認。\n\n##### 4. Web化・クラウドサービス化の相談\n\n杏那さんは、既存スプレッドシートベースのパッケージを、より使いやすいWebシステム / クラウドサービスへ発展させたい意向を共有した。現在、別のエンジニア候補2名も検討中であり、次廣にも開発規模・費用感の見積もりを依頼した。\n\n次廣は、スプレッドシートのプルダウンや入力しづらさをWebインターフェースで改善できること、顧客ごとにテンプレートを複製してカスタマイズする方式、共有クラウドサービス方式、顧客ごとの専用システム方式の選択肢を説明した。\n\n次廣の見立てでは、機能を段階的に追加していく現実的な開発が適している。AI駆動開発により工数短縮は可能だが、単純な安売りではなく、初期構築は **120万円程度から**、規模によっては **200万円前後** になる可能性がある。\n\n##### 5. 桜井シーリング様向けシステムとの比較\n\n次廣は、**桜井シーリング様**（名古屋）向けに納品・運用中の建設業システム事例を共有した。案件管理、職人の割り当て、材料管理、取引先別集計、締め日設定、日報送信、材料費管理などを含む包括的な管理システムで、現在 **約200万円規模** で運用されている。\n\n杏那さんのスプレッドシートパッケージは、次廣の理解では **桜井シーリング様向けシステムと同等、部分的にはそれより簡単** な機能をパッケージ化して販売している。Web化相談の背景には、この既存商品のクラウド化・商品力強化がある。\n\nこの事例により、技術的にはWeb化は可能だが、単なる画面化ではなく、段階的に機能を切り出し、テンプレート型のクラウドサービスとして設計する必要があることも示された。\n\n##### 6. 費用・手数料・保守のたたき台\n\n共同案件として進める場合、次廣が開発見積を作成し、杏那さん側で **30%程度の手数料を上乗せ** して顧客へ提示する方向で話した。\n\n保守費用は、次廣側のシステムでは **月額30,000円** を前提にする案を共有した。これは、Webシステム化後の保守・運用・軽微な修正・障害対応の前提として検討する。\n\n##### 7. 補助金・スケジュール\n\n杏那さんは、IT導入補助金の申請期限が9月であることに触れた。補助金を使う場合、審査に必要な仕様・画面イメージ・見積・スケジュールの整理が必要になる。\n\n次廣は、正式に開発を担当する場合、2ヶ月程度の開発スケジュールで段階的に機能を追加していく進め方が現実的だと説明した。ただし、補助金ありきで簡単なシステム開発だけを求められる案件は、これまで基本的に断ってきたことも共有した。\n\n##### 8. AI駆動開発と開発体制\n\n次廣は、Claude Code や Cursor などのAI開発ツールを使い、コーディング作業の効率化を進めていることを説明した。現在は複数プロジェクトを同時進行しており、AIを活用することで開発速度を上げている。\n\nただし、AIで安くするというより、要件整理・画面案・実装・改善サイクルを速く回すための開発スタイルとして説明した。\n\n##### 9. ホームページ制作相談\n\n杏那さんは、自社ホームページ制作についても相談した。次廣は、以前はすべて自分でやりたいタイプだったが、現在は専門領域は専門家へ任せる方がよいと考えていると共有した。\n\nホームページ制作については、次廣が直接抱えるより、米澤さんなどのチームメンバー・専門家への紹介を検討できると伝えた。\n\n#### 決定事項・次アクション\n\n- [ ] **杏那さん:** 既存スプレッドシートパッケージ（「現率」/「現実」表記揺れ・正式名要確認）の資料・構成を次廣へ共有する。\n- [ ] **杏那さん:** 検討中のエンジニア候補2名との比較も踏まえ、今月中にWeb化を誰へ依頼するか関係者と相談する。\n- [ ] **杏那さん:** IT導入補助金の9月期限を見据え、補助金審査に必要な仕様・画面イメージ・スケジュールの準備可否を整理する。\n- [ ] **杏那さん:** Web版の価格設定、既存スプレッドシート版とのサービス区分、名称をどうするか検討する。\n- [ ] **次廣:** 共有されたパッケージ内容を確認し、Webシステム化の開発可能範囲・概算費用・段階開発案をフィードバックする。\n- [ ] **次廣:** DragonFly内で、杏那さんと混同されない紹介文・ウィークリープレゼンでの伝え方を引き続き整理する。\n- [ ] **次廣:** 正式依頼があった場合、テンプレート型クラウドサービスとして切り出せる機能単位・見積・保守費用（月額30,000円前提）を整理する。\n\n#### 確認待ち\n\n- 第1回121の終了時刻。\n- Religo `one_to_ones.id`。\n- 既存スプレッドシートパッケージの正式名称（Zoom要約では「現率」/「現実」が混在）。\n- 買い切り価格の正確なレンジ（Zoom要約では「98,000円から98,000円」と記載）。\n- 補助金関係者・候補エンジニア・紹介先の正式氏名と役割。\n\n---','2026-06-04 01:43:27','2026-06-23 22:46:24'),
(69,1,37,50,NULL,'82538110131',NULL,'zoom','2026-06-12 09:00:00','2026-06-12 09:00:00','2026-06-12 10:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_iida_chiho_sui.md#第1回】\n\n### 【第1回】2026-06-12（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-12（金）JST 09:00-10:00**\n- **実施方法:** Zoom\n- **種別:** **第1回**（BNI 121）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **69**\n- **目的:** 初回相互理解。互いの自己開示を通じて、彗 sui・次廣の業務改善事業・BNIでの立ち位置・今後の紹介可能性を確認する。\n\n#### 話した内容（重要）\n\n##### 1. 初回121の全体像\n\n次廣から先に自己紹介・事業内容・BNIでの立ち位置を共有し、その後、千帆さんの占い師としての仕事・能力の開花・マーケティング活動・家族やBNIでの背景を聞いた。\n\n会話は質問リストに沿った聞き取りではなく、互いの話から気になる点を拾い合う形で進行。結果として、単なる事業理解だけでなく、**メインプレ前日の鑑定予約** まで決まった。\n\n##### 2. 千帆さんの占い師としての特徴\n\n| 論点 | 内容 |\n|------|------|\n| **鑑定方法** | 霊視鑑定。人のオーラから、必要なキーワード・色・未来の延長・守護霊などが見える |\n| **見え方** | 勝手に見えてしまうものと、意図して見ようとして引き出すものの両方がある |\n| **情報量** | 1時間で恋愛・結婚・仕事・人生・守護霊などを総合的に扱う。本人曰く、他の占い師より情報量が多い |\n| **オンライン対応** | オンラインと対面で精度は変わらないため、遠方クライアントにも対応可能 |\n| **価格** | 総合鑑定 **1時間22,000円** |\n| **繁忙期** | 12月は来年の運気、6月下旬〜7月は下半期の運気を知りたい人が増える |\n| **顧問契約** | 経営者との年間契約あり。ただし、質問がない場合はあえて情報を出しすぎない方針 |\n\n千帆さんは、もともとヨガインストラクターを目指していたが、29歳で占い師へ転職。瞑想やスピリチュアル系の人との出会いを通じて後天的に能力が開発され、39度の高熱が1ヶ月続いた後、さらに能力が開いたとのこと。\n\n占いについては、テレビの星座占いのような単純化されたものとは違い、**宿命×環境＝運** と捉えている。双子で誕生日が同じでも運命はまったく違う、という話から、環境や選択の影響を重視していることが分かった。\n\n##### 3. 千帆さんのビジネス展開\n\n| 領域 | 内容 |\n|------|------|\n| **SNS** | Instagram発信、TikTokでのライバー活動 |\n| **動画制作** | 台本作成・撮影・編集・テロップ・効果音まで自分で実施 |\n| **ラジオ** | 仙台で **福耳ラジオ** のMCを担当 |\n| **登壇** | 各地でセミナー講演。浜松では飯田康人さん（保険）の紹介で経営者向けセミナーに登壇し、20名以上の経営者と接点 |\n| **地域での評判** | 浜松で「やばい占い師がいる」と口コミが広がっている |\n| **方針** | 売上を追うより、必要な人に届けること・名前を広げることを優先 |\n| **経理** | 財務コンサルタントに経理を委託し、自身は鑑定・発信・登壇に集中 |\n\n次廣は、千帆さんがInstagram動画をすべて自分で作っていることに驚いた。占い師としての感性だけでなく、発信者・編集者・登壇者としての実行量がある。\n\n##### 4. 鑑定予約の決定\n\n次廣は、2026-06-23にDragonFlyでメインプレゼンを控えているため、その前日に千帆さんの鑑定を受けることになった。\n\n| 項目 | 内容 |\n|------|------|\n| **日時** | **2026-06-22（月）10:00-11:00 JST** |\n| **内容** | 総合鑑定 |\n| **料金** | 22,000円 |\n| **事前準備** | 次廣が質問リストを作成 |\n| **目的** | メインプレゼン前に状態・オーラを整え、仕事・BNIカテゴリー・発信の方向性を確認する |\n| **案内** | 千帆さんが後ほど鑑定案内を送付 |\n\n##### 5. 次廣のバックグラウンド共有\n\n次廣からは、文系外国語学部出身、大学時代のバンド活動・DTM、1990年代後半のインターネット黎明期にホームページ制作からIT業界へ入った経緯を共有した。\n\n30歳で独立し、地元の静岡県藤枝市へ戻ったこと、現在はシステムエンジニア26年目として、個人事業主で営業・開発・運用まで一通り担っていることを話した。\n\n屋号tugiloについては、**ligilo** がエスペラント語由来で「つなぐ」を意味すること、人と人を繋ぐだったり、仕組みと人を繋ぐ。未来とつなぐなどの想いを込めてつけたことも共有した。\n\nBNIでのカテゴリーは、小中さんなど既存メンバーとの重なりを避けるため **AI業務改善システム構築** としているが、入会3ヶ月目の今、さらに入口を低くするカテゴリー変更も検討している。\n\n##### 6. BNIでのフィードバック\n\n###### 千帆さん → 次廣\n\n- 定例会で次廣が発言すると **「空気が変わる」「背筋が伸びる」** ような良い影響がある。\n- パッションのある人として認識されており、入会から日が浅くても既にメンバーに覚えられている。\n- DragonFlyのInstagram投稿への「いいね」等の反応が、アルゴリズム上も良い影響になるため感謝している。\n\n###### 次廣 → 千帆さん\n\n- 千帆さんの話し方には、場を **ふわっと変える独特の雰囲気** がある。\n- 経営者にとって、迷っているときに「こっちで大丈夫」と背中を押してくれる存在として価値がある。\n- 占い師でありながら、動画編集やSNS発信まで自分で積み上げている実行力が印象的。\n\n##### 7. 家族・プライベート（取り扱い注意）\n\n※紹介判断とは分けて、信頼関係の背景として記録する。第三者紹介文には使わない。\n\n次廣からは、妻・娘2人・猫4匹の話、長女との関係変化、推し活を通じた関係修復、幼少期は学校を休ませてキャンプに連れて行っていたが中学以降は休ませていないことなどを共有した。\n\n千帆さんからは、2024年4月に離婚したが同じ方とやり直すことを決め、再婚予定であること、義母との同居や子育てをめぐる価値観の違い、子どもとの時間を優先するため占いの館のような拘束される場では働かない方針を聞いた。\n\n##### 8. BNI・地域コミュニティ\n\n千帆さんのBNI入会は、**BNI以前からの旧知**である清原佳彩美さんから「イケオジがいっぱいいるから入ろう」と誘われたことがきっかけ。入会日はNCAS上 **2025-05-27**。Zoom要約上は「2024年」とも読めるが、「約1年経過」と整合するため、NCASの2025年を正とする。\n\n仙台周辺では、飯田千帆さん、清原佳彩美さん、軍司さんなどが接点。畠山さん、**芳賀崇利**さん（Zoom要約の「加賀」は誤記）も宮城・山形方面の文脈で話題に出た。清原さんとは旧知の仲で、仙台メンバーを集めた飲み会も開催している。\n\n静岡では、9月のBBQイベントに千帆さんも参加予定。宿泊イベントは子ども不可のため、参加方法は検討中。\n\n##### 9. 霊的な話題・霊媒師連携（取り扱い注意）\n\n千帆さんは、守護霊が見えるだけでなく、メッセージを伝えたい守護霊は強く訴えてくることがあると話した。聞かれない限り重い内容は答えない方針だが、次廣の鑑定では見えたことを伝える予定。\n\n北海道の霊媒師に自宅と自身へバリアを張ってもらっており、幽霊がつかない状態にしているとのこと。過去に不整脈のような心臓の痛みがあったが、霊媒師に「胸に突き刺さっているレベル4のお化け」を取ってもらって以降、痛みが出ていないというエピソードも共有された。\n\n増本さんが静岡で霊媒師を呼ぶことに興味を示している話、仙台でも占い＋霊媒師の対面イベントを企画できる可能性が出た。\n\n##### 10. AI・議事録化の可能性\n\n次廣は、Zoom文字起こしとAIを使って議事録を作成していることを共有。千帆さんの鑑定でも、録音・文字起こし・AI要約を使えば、クライアントが後から見返せる鑑定記録を作れる可能性がある。\n\nChatGPTでもそれらしい占い風回答は出せるが、千帆さんの鑑定は「背中を押す」「必要な情報が多い」点で異なるという認識で一致した。\n\n#### 決定事項・次アクション\n\n- [x] **千帆さん:** 2026-06-22 10:00 の鑑定案内を次廣へ送付する。\n- [x] **次廣:** 鑑定に向けて質問リストを作成する（2026-06-13 08:35 JST 作成）。\n- [x] **次廣:** 鑑定で相談したいことを、実際に気になる順（転機・お金・仕事・家族・健康など）に整理する。\n- [ ] **次廣:** 鑑定の録音・文字起こし・AI要約を試す場合、千帆さんに事前確認する（本鑑定後に要約反映済み。共有可否は千帆さん確認 TODO）。\n- [ ] **千帆さん:** 9月静岡BBQ前後に、島田・浜松方面での登壇調整可能性を確認する（葬儀関連会社社長・ライオンズクラブ文脈。詳細要確認）。\n- [ ] **両者:** 仙台での **占い＋霊媒師** 対面イベントの企画可能性を今後検討する。\n\n---','2026-06-04 01:43:27','2026-06-23 22:54:07'),
(70,1,37,48,NULL,'82306905507',NULL,'zoom','2026-06-12 10:00:00','2026-06-12 10:00:00','2026-06-12 11:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kiyohara_kasami_ui.md#第1回】\n\n### 【第1回】2026-06-12（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-12（金）JST 10:00〜**（終了時刻 TODO）\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id` = **70**\n- **目的:** 初回相互理解。伸びるラッシュ・育毛マシン/育毛美容液・FC展開構想の理解。次廣の業務改善システム開発を説明し、将来の協業可能性を確認。\n\n#### 主な成果\n\n- 清原さんの事業背景と製品開発の経緯を深く理解できた。特に、まつ毛美容液「伸びるラッシュ」と育毛マシン・育毛美容液が、現場で困っている顧客を救いたいという原体験から生まれていることを確認した。\n- 業界推奨濃度3%に対し、安定性試験をクリアした上限の **幹細胞50%配合** を選んだことが、清原さんらしい差別化であり、原価より効果を優先した意思決定だと理解した。\n- 次廣のシステムエンジニア業務について、藤井さんの言葉 **「あったらいいな、を形にしてくれる人」** を使い、業務フロー整理・注文/顧客/FC/請求管理の一元化・段階開発の考え方を説明した。\n- 清原さんが、今後の事業拡大時にシステム開発・仕組み化を相談したい意向を示した。\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| **メインプレゼンリハ** | 清原さんが **2026-06-15** の次廣メインプレゼンリハーサルに参加する |\n| **システム相談** | 清原さんの事業拡大・FC展開に合わせ、システム開発に関する相談機会を改めて設定する |\n| **鑑定予約** | 次廣が **飯田千帆**さん（経営者向け開運占い師・彗 sui）の鑑定予約を行う。清原さんとは旧知の仲 |\n| **メインプレゼン調整** | 次廣は **2026-06-23** のメインプレゼンに向け、スライドと説明のズレを修正する |\n| **ビジター招待** | 2026-06-23 に向け、インスタ広告代行・SNS運用コンサル・UFOキャッチャー事業者の参加確定を確認する |\n\n#### 清原さんの背景・原体験\n\n- 清原さんは事業家の祖父のもとで育ち、幼少期から一般的な会社員がいない環境だった。実家では焼肉屋、釣り堀センター、スナック、漬物工場を経営していた。\n- 小学校入学時に共同経営者の夜逃げがあり、連帯保証人として多額の負債を抱える経験をした。このため「ないのが当たり前」という感覚があり、リスクへの恐怖心が少ない。\n- 清原さん自身は、母親が交通事故を起こし3歳の長男が亡くなった際、お腹の中にいたが奇跡的に助かったという出生時のエピソードを持つ。\n- 高校卒業時に家を出るよう言われ、貯金もない状態で、住む場所と国家資格取得の機会がある **寮付き美容室** を選んだ。美容師になりたかったというより、生きるための現実的選択だった。\n- 当初は髪を触ることに興味が持てなかったが、50代女性客がまつ毛パーマ後に初めて鏡を見て飛び跳ねて喜んだ体験が転機になった。「髪を綺麗にしても笑わない人が、まつ毛パーマで初めて笑った」ことが、まつ毛技術への情熱の原点。\n\n#### 製品開発の経緯\n\n- 技術と理論を突き詰めた結果、他店では上がらないまつ毛でも清原さんの施術では上がるという差別化に成功した。\n- 当初はメーカーの東北担当委託講師として活動したが、自分が伝えたい技術や考え方が十分に伝わらないと感じ、独自の講師活動へ進んだ。\n- 市販の効果があるまつ毛美容液には、色素沈着、まぶたの腫れ、かゆみ、充血など副作用があり、約3割の顧客が使用を断念していた。\n- 肌の弱い60代常連客がまつ毛美容液を使えず、まつ毛が非常に短い状況を見て、「この人のまつ毛をどうにか伸ばせないか」と考えたことが開発の直接のきっかけ。\n- まつ毛美容液を作ろうと決めた翌月、化粧品開発展に参加。朝から夕方まで工場・企業担当者と話し、化粧品に詳しい人物と出会い、共同開発が始まった。\n- 清原さんは化粧品製造の常識に縛られず、「濃ければいい」と考え、推奨3%に対して上限を確認。安定性試験で50%がクリアしていると知り、即座に50%での製造を依頼した。\n- 原価が高くなり、一般販売のまつ毛美容液としては価格設定が難しくなったが、試作品を二店舗の全顧客に施術時1回だけ塗布したところ、1ヶ月後に来店した顧客全員のまつ毛が伸びていた。\n- 通常は毎日塗る美容液を、月1回のサロン施術で効果を出せると判断し、**サロン施術用商材** へビジネスモデルを転換した。\n- 販路がない状態で、初回ロットとして500万円分（1,000本）を製造する決断をした。当時は二店舗のうち一店舗を失敗で潰した直後で資金がなかったが、銀行にプレゼンして融資を獲得した。\n\n#### 育毛マシン・育毛美容液\n\n- DragonFly メンバーの松倉氏、木川氏、廣田氏など複数の男性がAGA治療薬を服用し、副作用として男性機能低下やEDが生じ、ED治療薬も併用している状況を知った。\n- 飲酒も加わることへの危機感から、「DragonFlyメンバーの男性がみんな死んでしまう」「命を救わなきゃ」という思いで育毛事業を始めた。\n- 幹細胞には脂肪由来・臍帯由来・毛根由来などがある。市場では脂肪由来・臍帯由来が多いが、清原さんは毛髪への効果を重視し、高価で市場に少ない **毛根由来幹細胞** を選んだ。\n- 通常3%推奨の培養幹細胞を、毛根由来で50%配合。幹細胞の種類と濃度の両面で差別化している。\n- 育毛美容液を頭皮に浸透させるため、エアー圧を利用した独自マシンも開発した。注射レベルまで成分を皮膚深部へ届けられ、痛みは伴わない。\n- 松倉氏はAGA治療薬を中止後に抜け毛が進行していたが、育毛マシンと美容液の使用開始から2ヶ月で明らかな毛量増加が確認された。\n- 女性の脱毛症患者で、医師から「50%以上脱毛すると回復確率は8%」と告げられていたケースでも、2回の施術で顕著な発毛が見られ、医師が驚いている。\n- 女性の脱毛はストレス性・ホルモンバランスの乱れが主因で、男性は男性ホルモンによる脱毛が多い。美容液には幹細胞だけでなく、ミノキシジルに近い成分であるキャピキシルも配合している。\n- 副次的効果として、免疫力向上・美肌効果・体調面の改善もあると清原さんは見ている。\n\n#### 今後の展開\n\n- マシン、美容液、助成金・補助金サポート、ノウハウをまとめて **FCパッケージ化** する方向。\n- まずは成功事例作りを優先する。\n- 次廣との対話で、「ハゲてから来る」のではなく、毛穴が修復不能になる前に施術する **予防育毛** の打ち出しが重要だと整理した。\n- **西浦雅**さん（みやびさん）が清原さんの育毛マシン・美容液を導入し、サロン開業準備を進めている。\n\n#### 次廣の説明・協業可能性\n\n- 次廣は、パソコン作業での「こうなったらいいのに」「なんで私がこれをやらなきゃいけないの？」という不満を解消し、効率化する仕組みを作る仕事だと説明した。\n- 例として、**増本重孝**さん（プロテクトラボ／害虫ブロックFC）のフランチャイズ管理システム **P-Link** を説明。Googleフォーム、メール、スプレッドシート、顧客管理、請求書作成が分断されていた業務を、注文管理・顧客管理・FC管理・請求書発行まで一元化した。\n- 市場価格600万〜800万円規模のシステムを、基本部分120万円から作り、必要な機能を追加していく方式を説明した。\n- システムは直接お金を生むものではなく、時間を生み出す効率化ツール。顧客の業務フローに合わせ、伴走しながら段階的に開発する。\n- 提案作成までは無料で対応でき、予算に応じて段階的に機能追加する提案も可能。\n- 木村アンナさんはGoogleツールを活用した仕組み作りが得意で、システム開発とは異なるアプローチ。スタートアップなど予算が限られる企業は木村さん、より大規模な仕組みが必要な場合は次廣という協業可能性を共有した。\n\n#### 交換されたフィードバック\n\n- 次廣は、清原さんの「濃度を薄めず50%のまま製品化する」発想が清原さんらしいと評価した。\n- 次廣は、清原さんの「失敗から学ぶ」「何でもやってみる」行動力を高く評価した。\n- 清原さんは、次廣のシステムエンジニア業務に強い興味を示し、今後の自社業務拡大時に相談したい意向を表明した。\n\n#### 保留・確認待ち\n\n- 清原さんの事業における具体的なシステム化ニーズ。\n- 次廣のメインプレゼン後のフォローアップ日程。\n- 2026-06-23 のビジター招待者（インスタ広告代行、SNS運用コンサル、UFOキャッチャー事業者）の参加確定。\n\n#### アクションアイテム\n\n| 担当 | アクション |\n|------|------------|\n| 次廣 | **飯田千帆**さんの鑑定予約を実施する |\n| 清原さん | 2026-06-15 の次廣メインプレゼンリハーサルに出席する |\n| 次廣 | 2026-06-23 のメインプレゼンに向け、スライドと説明のズレを修正する |\n| 清原さん | 次廣につなげられる人物を検討する |\n| 次廣 | SNS運用コンサル等のビジター招待を進める |\n\n#### 次回1on1\n\n具体的な日程は未定。システム開発・FC展開の業務導線整理に関する相談として、再度 1to1 を実施することで合意。\n\n---','2026-06-04 01:44:30','2026-06-23 22:46:24'),
(71,1,37,163,NULL,NULL,NULL,'manual','2026-06-04 11:00:00','2026-06-04 11:00:00','2026-06-04 12:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kakiya_naoto_dock.md#第1回】\n\n### 【第1回】2026-06-04 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-06-04（水）JST 11:00–12:00**\n- **実施方法:** Zoom\n- **紹介:** [**田村広大**](1to1_tamura_kodai_money_cooking.md) さん\n- **Religo 1to1 レコード:** `one_to_ones.id` = **71**（相手 member `id=163`・BNI カーネル）\n\n#### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| 紹介（垣谷→） | 業務改善コンサル、建設・製造、MEO業者 |\n| 紹介（次廣→） | HP制作会社、システム開発会社、静岡協業先 |\n| 協業 | 予約管理＋SEO/MEO、HP制作会社向けシステム＋SEO顧問 |\n| 次回121 | 日程未定 |\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 垣谷氏 | MEO・業務改善・建設・製造の紹介先確認・連絡 | TODO |\n| 次廣 | HP制作・システム開発の紹介先確認・連絡 | TODO |\n| 両者 | 資料共有・協業パッケージ具体化 | TODO |\n| 次廣 | Religo 登録・`one_to_ones.id` 反映 | 完了（id=71） |\n| 次廣 | 田村さんへ SEO 紹介完了の一声 | TODO |\n\n---','2026-06-04 12:34:16','2026-06-23 22:46:24'),
(72,1,37,164,NULL,NULL,NULL,'manual','2026-06-04 14:00:00','2026-06-04 14:00:00','2026-06-04 15:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_endo_satomi_mirai_realestate.md#第1回】\n\n### 【第1回】2026-06-04\n\n#### 基本情報\n\n- 日時：**2026-06-04（水）JST 14:00–15:00**（実施済み）\n- 実施方法：**TODO**（対面／Zoom 等）\n- 既知関係：**BNI トレーニングで何度も同組**（SILVIS × DragonFly クロスチャプター）\n\n#### 話した内容（重要）\n\n- **「住宅を買うのがゴールじゃない」** — 次廣が本質的と評価。シンママへの寄り添い・他社で難しいローン・長期迷いの背中押し等の文脈。\n- 空き家転貸・**2027シンママコミュニティ**・2030全国展開のビジョン。\n- 次廣の **業務改善・小さな仕組み化** に関心（食いつきあり）。2027コミュの会員・案件・紹介の見える化は将来の接点。\n- 次廣から **遠藤さんへ繋ぎたい方を数名** 提示（**具体名 TODO** — 下記「接点候補」と121内の実名を照合して追記）。\n\n#### 決定・アクション\n\n- [ ] 次廣: 121で挙げた **紹介候補** を順次お繋ぎ（氏名・紹介文を確定）\n- [ ] 次廣: シンママの住まい・空き家の紹介用 **一言メモ** を整備\n- [ ] 遠藤: 業務整理・仕組み化の具体が出たら次廣へ相談（任意）\n- [x] Religo 1to1 登録（`one_to_ones.id=72`・`members.id=164`）\n\n---','2026-06-04 07:33:36','2026-06-23 22:46:24'),
(73,1,37,150,NULL,NULL,NULL,'manual','2026-06-11 17:00:00','2026-06-11 17:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kadowaki_yui_omoroo.md#第1回】\n\n### 【第1回】2026-06-11（実施済み）\n\n#### 基本情報\n\n- 日時：**2026-06-11（木）JST 17:00〜TODO**\n- 実施方法：Zoom（文字起こし要約ベース）\n- Religo 1to1 レコード：`one_to_ones.id` = **73**（相手 member `id=150`）\n\n#### 話した内容（重要）\n\n##### 1. バズミーキャンパスの全体像\n\n| 論点 | 内容 |\n|------|------|\n| **サービス名** | バズミーキャンパス |\n| **領域** | Instagram特化型オンラインスクール |\n| **生徒数** | 約800人 |\n| **コンセプト** | 学校。小学校1年生から大学まで進級するように段階的に学ぶ |\n| **教材** | 全200コマ前後の授業動画、1本10分程度 |\n| **自主学習** | 図書室＝Instagram教科書 |\n| **定期接点** | 月4回のホームルーム（質疑応答Zoom） |\n| **コミュニティ** | 地域別検索、オフ会、部活制度（合宿部・AI研究部など） |\n| **継続設計** | ログイン、授業視聴、ストーリーズ反応等でコインが貯まる。投稿添削等と交換可能 |\n\n門脇さんは、エステ・バー経営時代に約3,000万円の借金を抱え、広告費をかけずにできる集客手段としてInstagramを始めた。45日で1万フォロワーを達成した経験が、現在のスクールの原点。\n\n個別コンサルは200人を超えた時点で限界を感じ、スクール形式へ移行。現在は、門脇さん本人が直接すべてを教えるのではなく、AIアバター動画や副担任・家庭教師的サポートを組み合わせて、手離れする仕組みにしている。\n\n##### 2. 料金体系\n\n| プラン | 価格 | 内容 |\n|--------|------|------|\n| **自己学習型** | 3,000円 | 授業動画・教科書・ホームルーム・コミュニティ利用。副担任なし |\n| **スクール型** | 15,000円 | 3,000円プランに加え、副担任が毎週声かけ。進級時に門脇さんからの添削あり |\n| **個別指導型** | 50,000円 | スクール型に加え、いつでもチャット質問可能。最短最速で結果を出したい人向け |\n\n日本最安値を目指しており、主婦・アフィリエイター・個人事業主・企業まで幅広い。工務店などは1棟受注できれば十分に回収できる価格設計。\n\n3,000円プランの生徒でも42日で1万フォロワーを達成した例が複数あり、門脇さんは「再現性に特化したスクール」として位置づけている。\n\n##### 3. 今後の展開\n\n| 領域 | 内容 |\n|------|------|\n| **コース拡充** | YouTube、Canva、AI時短などを検討 |\n| **OEM提供** | 他コミュニティや育成スクールへのコンテンツ提供 |\n| **アライアンス** | ネットワークビジネス、美容師、アートメイク、企業コミュニティ、副業コミュニティなど |\n| **運用代行との補完** | 運用代行の予算が合わない人をスクールへ、スクール卒業生を運用代行へ紹介できる |\n\n運用代行は積極的に取りに行くというより、教育・サポートに特化している。運用代行会社とは競合よりも相互補完の可能性が高い。\n\n##### 4. 地方創生プロジェクト\n\n門脇さんは、SNS教育とは別に **熊本県の廃校をホテルに転換する地方創生プロジェクト** に取り組んでいる。\n\n| 論点 | 内容 |\n|------|------|\n| **コンセプト** | 学校生活に戻れる体験型宿泊施設 |\n| **演出案** | 給食当番エプロン、靴箱のラブレター、学校生活を思い出す仕掛け |\n| **ターゲット** | カップル、ファミリー、企業研修・合宿 |\n| **進め方** | いきなりホテル化せず、町おこし協力隊・朝市・地域イベントで関係構築 |\n| **地域住民との関係** | 地域住民が自分の地域を良くしたいと思える状態づくりを重視 |\n| **予定イベント** | 2026-07-04 奥多摩で林間学校イベント（学校を貸し切り、学び＋BBQ） |\n\n次廣からは、静岡の廃校グランピング事例や、夏祭り・地域住民との交流イベントの可能性を共有。門脇さんの地方創生事業は、単なる不動産活用ではなく **地域の意識改革と体験設計** が核にある。\n\n##### 5. BNI参加・チャプター検討\n\n次廣から、門脇さんのバズミーキャンパスは既に **BNI的な相互紹介・コラボ促進** を行っているとフィードバックした。\n\n| 論点 | 内容 |\n|------|------|\n| **門脇さん本人** | すぐ DragonFly 入会というより、他チャプターも見ながら検討 |\n| **営業担当メンバー** | BNI参加を社内議題として前向きに検討 |\n| **学びの価値** | 25秒プレゼン、メインプレゼン、紹介の出し方、営業説明力の向上 |\n| **東京NEリージョン** | 約1,200人規模。学びの場としてレベルが高いと共有 |\n| **DragonFly** | 火曜午前の時間拘束あり。曜日・時間帯が合うチャプター選びが必要 |\n| **ビジター招待** | 門脇さんは800人のコミュニティを持つため、ビジター招待との相性が高い |\n\n門脇さんは、BNIメンバーの職業が特殊で即座に紹介先が浮かばなかった一方で、ビジター招待はできそうという反応。次廣からは、直接の仕事紹介だけでなく、ビジター招待も大きなリファーラルになることを説明した。\n\n##### 6. tugilo / 次廣との連携可能性\n\n次廣は、SNS運用そのものではなく、**SNS・MEO・広告で集客した後の予約・LINE・顧客管理・業務導線** を整える立場として自己紹介した。\n\n開発中の予約システムについては、顧客側が自由に時間を選ぶ従来型ではなく、事業者側の効率も考え、日付やメニューに応じてAIが最適な時間を提案する思想を共有。特に一人サロン・美容院・エステなどで、空き時間が不規則に発生する問題を解消する狙い。\n\n門脇さんの顧客・生徒の中で、SNSで反応は取れたが予約や問い合わせ対応が詰まるケースがあれば、tugilo の出番がある。\n\n---','2026-06-11 19:37:00','2026-06-23 22:46:24'),
(76,1,37,2,NULL,NULL,NULL,'manual','2026-06-12 16:00:00','2026-06-12 16:00:00','2026-06-12 17:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_masumoto_shigetaka_pestblock.md#第1回】\n\n### 【第1回】2026-06-12\n\n#### 基本情報\n\n- **日時:** **2026-06-12（金）JST 16:00–17:00**\n- **実施方法:** Zoom\n- **Religo 1to1 レコード:** `one_to_ones.id` = **76**\n- **主題:** **プロテクトラボ** の新事業 **ピタカット** を **P-Link** に組み込めるか、どう組み込むか\n\n#### ピタカット × P-Link — 組み込みの検討（本題）\n\n**なぜ P-Link 拡張か**\n\n- プロテクトラボは害虫ブロックFC向けに **P-Link** を既に運用中（代表特約店・取扱店・注文・統計）。\n- ピタカットは **別商品・別販売チャネル**（飲食店向け液剤、販売代理店制度）だが、本部が一元管理する構図は同じ。\n- 増本の意向は **Excel・別ツールを増やさず、P-Link に載せたい** こと。次廣も既存基盤の拡張で足りると判断。\n\n**組み込み方針（合意の方向）**\n\n| レイヤ | 害虫ブロック（既存） | ピタカット（新規・P-Link 上に追加） |\n|--------|----------------------|--------------------------------------|\n| 役割 | 代表特約店 → 取扱店 → 施工 | **販売代理店**（第3の役割として新設） |\n| ログイン | 既存の階層別 URL | **販売代理店専用ログイン**（代表・取扱店とは別） |\n| 商品 | 施工ブロック等 | ピタカット（ケース単位の液剤） |\n| 注文管理 | 既存フロー | 同一画面で管理し **フィルタで切替** する案 |\n| 本部機能 | 統計・契約点管理 | ピタカット専用の注文履歴・統計・お知らせ（送信先: 代理店のみ／全体 等） |\n| 技術的参照 | — | 既存の **本部直注文** の概念を応用可能 |\n\n**組み込み可能と判断した根拠**\n\n- 商品マスタ・注文・権限の枠組みが P-Link に既にある。\n- 新規は「販売代理店」ロールとピタカット商品の追加、画面・統計の分岐が中心で、**20万〜30万円** レンジの拡張開発に収まる見込み。\n- 二重登録防止は実装済み。変更履歴・Excel 廃止を足せば、ピタカット追加前に本体の運用品質も上がる。\n\n**組み込まない／別途検討としたもの**\n\n- 飲食店向け **決済代行つきの直接オンライン販売** — 値崩れリスクが高く、第1フェーズでは見送り方向。\n- **LP から P-Link 直結で決済完結** — 構想はあるが、まずは **LP は宣伝のみ → 購入は販売代理店へ** が最もシンプル。\n\n#### ピタカット商品・販売（ビジネス前提）\n\n**商品特性**\n\n- 飲食店店内用の害虫忌避剤。効果は約 **4ヶ月** 持続（害虫ブロック施工ブロックより長いと説明）\n- ゴキブリなど不快害虫専用で室内使用に最適化。ライバルが少ない\n- 法的位置づけ: 経済産業省管轄の「家庭用生活防除剤の自主基準」に該当し、**雑貨扱い**\n\n**販売見込み・候補**\n\n- 山本洸太の店長が「5,500円なら絶対売れる」と評価\n- 販売代理店候補: **古屋 周治**、**今西 俊明**、**太田 一誠**（DragonFly）、**藤井 恵理子**（明石）などが興味を示している\n\n**害虫ブロック（施工）との比較**\n\n| 観点 | 害虫ブロック（施工） | ピタカット（店内液剤） |\n|------|----------------------|------------------------|\n| 効果期間 | 表記3ヶ月・実質4ヶ月程度 | 室内使用で4ヶ月程度 |\n| 販売体制 | 代表特約店→取扱店→施工の階層 | 販売代理店制度（新設） |\n| 利益 | 取扱店が卸値・施工費を自由設定 | 上記価格体系で統一 |\n\n#### P-Link 現状（プロテクトラボ・害虫ブロック）\n\n- 代表特約店が自分で申し込み URL を発行し、取扱店は専用 URL から登録するフローが確立\n- 以前の代表承認プロセスは廃止されシンプル化\n- 海藤さん（氏名 TODO）の二重登録は増本側の指示ミスが原因。システム側で防止機能を追加済み\n- 統計はアンバサダーを除いた正式契約数を表示。テストデータ1件は除外予定\n- **増本 ゆうこ**（ヨウコ）さんの Excel によるメールアドレス変更管理を **システム内に移行** する改善が合意済み（ゆうこさんは増本夫人で、主にプロテクトラボの事務作業を担当）\n\n**LP・補助金（ピタカット周辺）**\n\n- 補助金が通り、機械導入・**山本 洸太** による LP 制作費用が確保\n- LP と P-Link の接続は、第1フェーズでは **宣伝 LP ＋ 代理店経由販売** を優先\n\n#### リスク（ピタカット × P-Link）\n\n- **値崩れ:** 大量仕入れでの安売りがあれば、統一価格の販売代理店が機能しなくなる\n- **代理店の流動性:** コロコロ辞める代理店がいるため、個別運用は現実的でない → **P-Link で仕組み化する理由**\n- **成否:** 販売代理店をどれだけ増やせるか。システムはその土台\n\n---','2026-06-13 08:11:28','2026-06-23 22:46:24'),
(77,1,37,170,NULL,NULL,NULL,'manual','2026-06-10 15:00:00','2026-06-10 15:00:00','2026-06-10 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_yoshida_takuma_yoshida_clinic.md#第1回】\n\n### 【第1回】2026-06-11\n\n#### 基本情報\n\n- **日時:** 2026-06-11 JST **TODO**（開始・終了 — カレンダー／Zoom で確定）\n- **実施方法:** Zoom（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **77**\n- **表記確認:** Zoom要約の「平野拓馬」は誤記。正式な姓は **吉田** として訂正。\n\n#### 主な成果\n\n- 次廣淳（tugilo / システムエンジニア）と吉田拓磨さん（SNSマーケティングコンサルタント）が、初めて正式に業務内容を共有した。\n- 吉田さんは、SNS運用・コンテンツビジネス・コンサルティングを個人で展開しており、次廣はB2B向け業務改善システム開発を一人で手がけている。\n- 両者とも吉田クリニックとのつながりがあり、**吉田クリニックのLINE公式アカウント活用**を含めた具体的な連携案が浮上した。\n- 次廣が一人で抱えがちだった案件を、吉田さんのSNSマーケティング・実行支援と組み合わせ、段階的に協業していく方向性を確認した。\n\n#### 決定事項・合意内容\n\n##### 業務連携の方向性\n\n- 次廣が吉田さんへ、まずは **簡単な案件から段階的に依頼** し、協業を開始する。\n- 吉田さんは、次廣のプロジェクトに対して **実行支援・裏方** として柔軟に参加する意向を示した。\n- 店舗向けSNSマーケティングサービスについて、次廣が持つ店舗・クリニック等のつながりを活用できる可能性を検討する。\n- 役割分担の基本は、**吉田さん＝SNS・集客・収益化動線**、**次廣＝予約・業務改善・システム化**。\n\n##### 吉田クリニックへの提案\n\n- 吉田さんが、吉田クリニックの **LINE公式アカウントのフォロワー増加** と **活用方法** について提案する。\n- 具体案として、**新規予約フォーム**、高校生など若年層向けの集客、**スポーツ外傷に特化したブランディング** を検討する。\n- オンライン診療やAI活用も視野に入れ、吉田クリニック向けの提案内容を整理する。\n\n#### 吉田拓磨さんの事業理解\n\n##### サービス概要\n\n- **主要業務:** SNSを使ったマーケティング、コンテンツビジネス、コンサルティング。現時点では完全に一人で運営。\n- **料金体系:** 年単位のコンサル契約（1年・2年プラン）、対面コンサルなど複数プラン。\n- **顧客獲得:** 初期はSNSで多数のアカウントを作り、集客動線を構築。現在は口コミ・紹介が主流。\n\n##### 使用プラットフォーム・ツール\n\n- **自身の集客:** X（旧Twitter）と Threads が中心。\n- **顧客指導:** Instagram、TikTok、YouTube、X、Threads など、顧客の状況に応じて媒体を選定。\n- **収益化動線:** 公式LINE、Lステップ、プロラインを活用し、フォロワーを商品購入・相談へつなげる。\n\n##### コンサルティング内容\n\n- **インフルエンサー向け:** フォロワーは多いが収益化できていない人に対し、公式LINEとフロントエンド商品の設計を支援。\n- **AI活用指導:** 自身がAIを業務で使うだけでなく、顧客にもAI活用を指導。\n- **店舗・美容室事例:** 三重県の個人美容室に対し、コンセプト設計・ブランディングを支援し、成果につなげた。\n\n##### 学習・事業化の経緯\n\n- 約5年前、SNS運用を教えるスクールで基礎を学習。\n- スクール卒業後は独学で試行錯誤し、現在のビジネスモデルを確立。\n- スクールはやり方を教える一方、顧客獲得方法までは教えなかったため、自力で開拓した。\n\n#### 次廣淳 / tugilo の共有内容\n\n##### システムエンジニアとしての専門性\n\n- **活動期間:** 独立して6年目。一人でシステムエンジニアとして活動。\n- **主要業務:** B2B向け業務改善システム開発、Google Workspace を使った業務効率化提案。\n- **開発スタイル:** AI、特に Claude Code を活用し、プログラミングの大部分をAIと協働して実施。\n\n##### 業務改善のアプローチ\n\n- **現場重視:** 既存の業務フローに余計な一手間を増やさず、現場の人が使いやすいシステムを設計する。\n- **経営者と現場の橋渡し:** 経営者の効率化要望と、現場の作業負担のバランスを取る。\n- **具体例:** Googleフォーム、スプレッドシート、Excel などに分散した業務を、1つのシステムに統合する。\n\n##### AI活用状況\n\n- **使用ツール:** ChatGPT、Gemini / Genspark（表記要確認）、Claude Code、Cursor などを用途に応じて使い分け。\n- **Cursor の活用:** プログラミングだけでなく、Markdown形式のドキュメント作成・構造化にも活用。\n- **プロンプト戦略:** AIにプロンプトを作らせるなど、AI同士を連携させて精度を高めている。\n\n##### キャリア経緯\n\n- 大学時代（1990年代後半）にインターネットとDTMへ興味を持ち、趣味でパソコンを始めた。\n- オンラインチャットで知り合ったシステム会社の社長からアルバイトに誘われ、大学を中退して就職。\n- パソコンの組み立て、インフラ構築、開発、営業、顧客対応まで幅広く経験。\n- 当時のエンジニアはコミュニケーションが苦手な人が多かったため、営業も担当した。\n- 30歳で静岡に戻り独立し、地域密着型のスタイルで現在に至る。\n\n#### 両者の課題と展望\n\n##### 吉田さんの課題\n\n- **店舗営業:** エステ・飲食店など実店舗向けサービスを展開したいが、営業方法やつながりが不足している。\n- **リアルビジネス展開:** SNS上から始まったビジネスのため、実店舗へのアプローチ方法を学ぶ必要がある。\n- **規模拡大:** 現在の顧問料収入に満足せず、より大きく事業展開したい意向がある。\n\n##### 次廣の課題\n\n- **価格設定:** 人の良さが出すぎて価格設定が低く、忙しいが利益が残りにくい状態が続いている。\n- **業務範囲の広さ:** プリンター修理から大規模システム導入まで幅広く対応しており、業務が多岐にわたる。\n- **差別化戦略:** 大手システム会社との差別化として、現場にフィットするシステムと顧客の悩み解決を重視している。\n\n##### 吉田さんの強み\n\n- **裏方適性:** 人の仕組みを作ることが好きで、裏方として働くことを好む。\n- **自己投資:** 自分の人生の幅が広がるなら何でもやりたいという積極的な姿勢。\n- **若さ:** 34歳で、今後の成長余地が大きい。\n\n##### 次廣の強み\n\n- **人脈:** バーでの出会いなど、人とのつながりから仕事が生まれるパターンが多い。\n- **総合スキル:** プログラミング、インフラ、営業、顧客対応まで一人でこなせる。\n- **効率化発想:** 面倒なことを減らしたい性格が、業務改善の発想につながっている。\n\n#### 吉田クリニックとの関係性\n\n##### 次廣と吉田クリニック\n\n- 約20年前、バーで吉田先生と知り合い、ホームページ管理の依頼から関係が始まった。\n- 結婚前からの付き合いで、現在も継続的にサポートしている。\n- プリンター修理から大規模システム導入まで、さまざまな依頼に対応している。\n\n##### 吉田さんと吉田クリニック\n\n- 吉田ひろみさんを通じて吉田家とつながりがある。\n- Zoom要約の末尾が途切れているため、吉田さん側の詳細な関係性は **要確認**。\n\n#### 保留・要確認\n\n- **名の漢字表記:** 既存メモの「拓磨」を採用。名刺等で最終確認。\n- **初回121の開始・終了時刻:** カレンダー／Zoomメタデータで確認。\n- **吉田さんの屋号・会社名・料金詳細:** 顧問プランの具体金額、契約条件。\n- **吉田クリニック提案:** LINE公式アカウントの現状、予約フォーム、オンライン診療、AI活用の実現範囲。\n- **医療広告ガイドライン:** スポーツ外傷・若年層集客を発信する際の表現ルール。\n- **店舗向け展開:** 次廣の店舗人脈のうち、最初に試しやすい候補。\n\n#### アクションアイテム\n\n##### ▼ 吉田拓磨さん\n\n- 吉田クリニック向けに、LINE公式アカウントのフォロワー増加・活用方法を提案する。\n- 新規予約フォーム、若年層向け集客、スポーツ外傷ブランディング、オンライン診療・AI活用を含めた案を整理する。\n- 次廣案件に入る場合の、対応可能範囲・稼働条件・料金感を共有する。\n\n##### ▼ 次廣（自分）\n\n- 吉田さんへ依頼できる **簡単な案件** を洗い出す。\n- 店舗・クリニック・サロン等の人脈の中で、SNSマーケティングと予約/再来店導線をセット提案できる候補を整理する。\n- 吉田クリニックのLINE公式アカウントや既存導線について、現状情報を整理する。\n- 吉田さんの名の漢字・屋号を確認し、必要に応じてYAMLへ追記する。\n\n##### ▼ 両者\n\n- 小さな案件から協業を試す。\n- 店舗向けSNSマーケティング × 予約/再来店/業務改善の共同提案パターンを検討する。\n- 吉田クリニックへの提案内容をすり合わせる。\n\n---','2026-06-13 08:11:28','2026-06-23 22:46:24'),
(78,1,37,12,NULL,NULL,NULL,'manual','2026-06-14 20:00:00','2026-06-14 20:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_nishiura_miyabi_draci.md#第2回】\n\n### 【第2回】2026-06-14\n\n#### 基本情報\n\n- **日時:** 2026-06-14（日）JST **20:00〜**（終了時刻 TODO）\n- **実施方法:** Zoom（ユーザー提供メモ・Zoom要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **78**\n- **主題:** 株式会社Myria-mu の外構SNS集客・施工店送客・インフルエンサー報酬管理を、管理システムとして構築できるかの打診\n\n---\n\n#### ■ 正式表記・前提\n\n| 項目 | 内容 |\n|------|------|\n| **正式氏名** | 西浦 雅（にしうら みやび） |\n| **会社名** | 株式会社Myria-mu |\n| **BNIカテゴリー** | 中小企業サポート |\n| **専門** | 外構工事特化型SNS集客 |\n| **今回の相談対象** | Myria-mu 側の顧客・施工店・インフルエンサー管理システム |\n\n---\n\n#### ■ ペルソナ・関係者整理\n\n| ペルソナ | 役割・関心 |\n|----------|------------|\n| **インフルエンサー** | SNSから外構工事希望者を集客する。専用URLで流入経路を識別し、成約後に報酬を受け取る |\n| **Myria-mu（西浦さん）** | 顧客問い合わせ、施工店選定、送客、契約・報告、報酬計算を管理する中核 |\n| **顧客** | 外構工事希望者。インフルエンサーのSNSや専用リンク経由で問い合わせる |\n| **施工店** | 都道府県・市区町村などのエリアごとに候補を持つ。顧客情報を受け取り、商談・見積・契約・完了報告を行う |\n\n---\n\n#### ■ 現在の業務フロー\n\n1. インフルエンサーのSNS等から、外構工事希望者が問い合わせる。\n2. Myria-mu が問い合わせ内容を確認し、顧客エリアに合う外構業者・施工店を選ぶ。\n3. 候補施工店に顧客情報を送る。首都圏などでは最大3社までに絞り、相見積もり・打ち合わせにつなげる。\n4. 契約・工事完了後、施工店から報告書や契約情報を回収する。\n5. Myria-mu が顧客進捗、契約書、報告、インフルエンサー報酬を手動で管理する。\n\n---\n\n#### ■ システム化したいこと\n\n| 領域 | 要望・検討内容 |\n|------|----------------|\n| **顧客管理** | 問い合わせから契約・工事完了までの進捗を一元管理する |\n| **施工店管理** | 都道府県・市区町村・郵便番号などのエリア条件に基づき、送客候補を最大3社まで自動抽出する |\n| **送客管理** | Myria-mu 側で候補施工店を確認・選択し、顧客情報を送れるようにする |\n| **契約・報告管理** | 契約書、サイン、施工店からの報告、工事完了情報をシステム上で管理する |\n| **インフルエンサー管理** | インフルエンサーごとに専用URLを発行し、クーポンコードではなくリンクで流入元を自動判別する |\n| **報酬計算** | 工事完了・入金予定に基づき、インフルエンサー報酬を自動計算する |\n| **通知** | 工事完了時の入金予定日・金額をインフルエンサー等へ自動通知する |\n| **公式LINE連携** | メール確認の手間を減らすため、公式LINE／Lステップ等からシステム起動・連絡できるか調査する |\n\n---\n\n#### ■ 報酬率・金額に関するメモ\n\n- インフルエンサー報酬は **3% または 4%** の想定。\n- ユーザー提供メモでは **通常3%・アンバサダー4%** とされている一方、Zoom要約末尾には **アンバサダー3%・通常4%** と逆の記述があるため、**正式な報酬率は要確認**。\n- 次廣からは、今回相談の初期構築費として **150,000〜180,000円程度** の費用感を伝えた。\n\n---\n\n#### ■ 実現方針のたたき台\n\n| 案 | 内容 | 向いている場合 |\n|----|------|----------------|\n| **スプレッドシート活用案** | 既存シートを残し、入力フォーム・自動通知・URL管理だけを追加する | 初期費用を抑え、現行運用を大きく変えたくない |\n| **DB化・管理画面案** | 顧客、施工店、インフルエンサー、案件、報酬をDBで管理する | 案件数・施工店数・報酬計算が増え、手動管理が限界になる |\n| **段階導入案** | 専用URL・顧客登録・施工店候補抽出から始め、契約書・報酬通知を後続で追加する | 15〜18万円程度の初期提案に収めたい |\n\n次廣の現時点の見立てでは、**B-Link に近い専用URL発行・流入管理の仕組み**と、**顧客／施工店／インフルエンサーを紐づける管理画面**を組み合わせれば実現可能。公式LINE／Lステップ連携は、利用中サービスのAPI・Webhook・外部リンク起動の仕様確認が必要。\n\n---\n\n#### ■ 次アクション\n\n| 担当 | 内容 |\n|------|------|\n| **次廣** | 公式LINE／Lステップ等の拡張機能・Webhook・外部システム起動可否を調査する |\n| **次廣** | スプレッドシート継続案とDB化案の費用感・実装方法を比較する |\n| **次廣** | 郵便番号・都道府県・市区町村に基づく施工店最大3社抽出の設計を検討する |\n| **次廣** | インフルエンサー専用URL発行、流入判定、報酬計算、入金予定通知の実装方針を整理する |\n| **次廣** | 15〜18万円程度を目安に、初期スコープと追加スコープを分けた概算提案を作成する |\n| **西浦** | 現行スプレッドシート、施工店一覧、エリア条件、契約・報告・報酬計算に使う項目を共有する |\n| **西浦** | 報酬率（通常／アンバサダーの 3%・4% の対応）を確定する |\n\n---\n\n#### ■ 確認待ち・リスク\n\n- 公式LINE／Lステップ側で、どこまで外部システム起動・Webhook連携・個別ユーザー識別ができるか。\n- 顧客情報・契約書・施工店報告を扱うため、個人情報・契約情報の管理範囲を明確にする必要がある。\n- 施工店への一斉送信か、Myria-mu 側で選択してから送客するかで実装範囲が変わる。\n- 報酬計算は、契約金額・入金予定日・工事完了日・キャンセル・返金の扱いを定義する必要がある。\n- 初期費用15〜18万円で収める場合、契約書電子サインや高度なLINE自動化は後続スコープに分けるのが現実的。\n\n---\n\n#### ■ その他の議論（文脈メモ）\n\n##### WordPress 構成・開発体制の課題（西浦さんからの継続要望）\n\n| 論点 | 内容 |\n|------|------|\n| **プラグイン過多** | 動作が重い。基本機能は **余計なプラグインなし** で実装可能 |\n| **セキュリティプラグイン** | 過去にメール配信等のトラブルを引き起こした |\n| **倉本氏の実装** | 高度すぎて他メンバーが運用困難。ユーザー目線の設計になっていない |\n| **データ混在** | 独自コードにより朝礼スライド等で新旧データ混在のトラブル |\n| **簡素化要望** | 倉本氏以外が **トラブル時も自己解決できる** 程度の簡素化を西浦さんは継続要望（未実現） |\n| **ウェブマス** | 松本氏・今井氏も早期体制変更を望む。西浦・太田氏等はウェブマス参加を断り続けている |\n\n##### 次廣のウェブマス参画\n\n- 次廣が **ウェブマスチームに参加** し、**2026-06-03 から** 徐々に業務引き継ぎ開始（朝礼スライド作成等）\n- 関連: [`webmaster_handover_20260603.md`](../webmaster/webmaster_handover_20260603.md)\n\n##### 雑談・環境メモ\n\n- 次廣は Zoom で豪華ホテル風背景。西浦さんは「圧を強めたい日」に使うと発言\n- 西浦さんの iPad が息子のゲーム用になり仕事で使えない。打合せメモは iPad で殴り書き\n- 打合せ中 Wi-Fi 問題あり、西浦さんが切替対応\n\n---','2026-06-15 00:32:22','2026-06-23 22:46:24'),
(79,1,37,132,NULL,NULL,NULL,'manual','2026-06-17 14:15:00','2026-06-17 14:15:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kumagai_ryusho_lifinity.md】\n\n# 1to1_熊谷龍笙_Lifinity\n\n---\n\n**文書の位置づけ:** 熊谷龍笙さんとの 1to1 を **1ファイルで時系列管理**する。第1回は 2026-06-17 14:15 JST 開始。小中貴晃さん紹介で DragonFly にビジター参加済みの方との初回 121 について、事前準備と Zoom 要約を統合した **実施後議事録**。\n**整理:** 事前には通信費削減を中心に捉えていたが、実施後は、携帯料金削減は入口であり、熊谷さんの本体は **長期インターンシップ支援・営業組織づくり・創業支援** にあると整理する。次廣は携帯プラン見直しを個別相談し、AI系企業向けの携帯削減訴求について継続して壁打ちする。\n**日時:** 第1回 **2026-06-17（水）JST 14:15〜**（Zoom。終了時刻 TODO）。\n**Religo 1to1 レコード:** `one_to_ones.id` = **79**。\n\n---\n\n## ■ 実施後サマリー（2026-06-17）\n\n### 主な成果\n\n- 熊谷さんの事業は、表向きの **携帯料金削減** だけでなく、長期インターンシップ支援、営業代行、創業支援まで一体で見る必要があると理解した。\n- Lifinity の携帯削減は、個人契約を法人名義へ切り替えることで、月額 7,000〜10,000円超のプランを 3,000〜5,000円台へ下げる提案。最新ではソフトバンクから追加割引許諾を得て、無制限・かけ放題のフルスペックプランを **2,980円〜** 提供できる。\n- 熊谷さんは、ソフトバンク営業代行 8年・累計 10,000件超の契約実績があり、中小・一人社長・フリーランス向け契約数で日本一を達成した実績を持つ。\n- 携帯削減はあくまで「フック」で、本体は **学生・若者に営業力をつけさせ、売上が立った状態で創業させる仕組み**。\n- 次廣自身も携帯プラン見直しに前向きで、メッセンジャーで個別相談することで合意した。\n- 熊谷さん本人の BNI 入会は、本人がコミュニティ運営に力を使いすぎる懸念があるため、スタッフ入会や他チャプター参加の方が本業拡大に合う可能性を共有した。\n\n### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| **携帯プラン相談** | 次廣が熊谷さんへメッセンジャーで個別連絡し、自身の携帯プラン見直しを相談する |\n| **事業理解** | 次廣は、熊谷さんの事業を「携帯削減の人」だけでなく、長期インターン・営業組織・創業支援の人として理解する |\n| **システム相談** | 次廣は、熊谷さん側でシステム開発の相談があれば声をかけてもらう形を伝えた |\n| **BNI参加方針** | 熊谷さん本人の入会より、スタッフ入会・他チャプター参加の可能性を検討する方が自然 |\n| **AI系企業向け訴求** | AI系企業への携帯削減紹介は実績が薄いため、訴求方法を次廣と改めて壁打ちする |\n\n### 未確定・保留\n\n- Zoom要約では「田中氏の紹介」とあるが、事前のビジター情報では **小中貴晃さん紹介**。本文では既存情報の小中さんを正として扱い、「田中氏」は要確認。\n- ファンダーズ（新会社）は来月18日登記予定。登記後の具体的な事業展開は継続確認。\n- 次廣の携帯プラン変更の条件・台数・タイミングは、個別相談で確認する。\n- AI系企業に対して、携帯削減をどう自然に紹介するかは未確定。\n\n---\n\n## ■ 第1回121 実施後議事録\n\n### 基本情報\n\n| 項目 | 内容 |\n|------|------|\n| **日時** | 2026-06-17（水）JST 14:15〜（終了時刻 TODO） |\n| **形式** | Zoom |\n| **参加者** | 熊谷龍笙さん、次廣 淳 |\n| **きっかけ** | 小中貴晃さんのお繋ぎ、DragonFly ビジター参加後の 121 |\n| **目的** | 入会検討とは切り離し、熊谷さんの事業を次廣が正確に理解し、紹介できる状態を作る |\n\n### 1. Lifinity の携帯料金削減\n\n#### サービス概要\n\n- ソフトバンク回線の名義を、個人から法人へ変更することで通信費を下げる。\n- 月額 7,000〜10,000円超の既存プランを、3,000〜5,000円台へ削減できるケースがある。\n- 去年からソフトバンクより月 500〜1,500円の追加割引許諾を取得し、無制限・かけ放題のフルスペックプランを **2,980円〜** 提供可能になった。\n- 法人、個人事業主、フリーランス、一人社長が対象。1台から契約可能。\n- ソフトバンク営業代行として 8年、累計 10,000件超の契約実績。\n- 去年は、中小企業・一人社長・フリーランスの契約数で日本一を達成。\n- 8年間、一度も広告を打たず、紹介のみで事業継続している。\n\n#### 相性の良い紹介元・活用例\n\n| 紹介元・顧客 | 活用イメージ |\n|--------------|--------------|\n| **ライバー事務所** | 「うちでライブ配信すると携帯を安くできる」という福利厚生にできる |\n| **運送会社** | ドライバー・スタッフ向け福利厚生、複数回線の削減に向く |\n| **CFO系支援者** | 創業したての会社に「まず法人名義に変えましょう」と紹介しやすい |\n| **フリーランスを多く抱える会社** | 一括対応で削減インパクトが大きい |\n\n#### AI系企業との相性\n\n- AI系企業からの携帯紹介は、現状ほぼゼロに近い。\n- AI系企業では、通信費の話題が社内で出にくい傾向がある。\n- 熊谷さんから、AI関連の次廣に対して、紹介の形や訴求方法を改めて「揉んでほしい」と要望があった。\n- 次廣側では、AI導入・業務改善の文脈に **固定費削減・福利厚生・創業初期の法人契約整理** をどう接続するかが検討ポイント。\n\n### 2. Lifinity の本体事業\n\n携帯料金削減は、熊谷さんにとって「フック」であり、本体事業は **長期インターンシップの運営・コンサル**。\n\n- 自社運営と、他社へのコンサル提供の両方を行っている。\n- 営業チャネルとして、テレアポ・訪問販売・ファンセールスを持つ。\n- 社員1名 + インターン生5名のような単位で事業を展開する。\n- 営業代行として、2C・2B を問わず多様な商材を扱う。\n- インターン生に営業力をつけさせ、単なる労働力ではなく、事業を伸ばす人材として育てる。\n\n### 3. 新会社「ファンダーズ」構想\n\n来月18日に登記予定の新会社。テーマは **「才能ではなく仕組みで創業者を生み出す」**。\n\n#### 概要\n\n| 項目 | 内容 |\n|------|------|\n| **会社名** | ファンダーズ（表記 TODO） |\n| **登記予定** | 来月18日 |\n| **共同創業者** | エスクリ元会長・岩本氏（ブライダル業界で「ミスターゼクシー」と呼ばれた人物） |\n| **現状** | 学生インターン10名程度を採用済み。すでに社長候補の学生がいる |\n| **目的** | 学生・若者が、起業前に売上を立てた状態で独立できる環境を作る |\n\n#### 創業支援の仕組み\n\n- 起業前に、社内事業立ち上げから始める。\n- 売上が立った状態でのみ独立を認める。\n- まず営業代行で営業力を身につけさせる。「いいサービスがあれば売れる時代ではない」という前提。\n- 独立後は、コンサル、出資してグループ会社化、商材卸など、複数の関わり方を持つ。\n- 税理士・社労士選びなど、創業手続きも一気通貫で支援する。\n- 優秀な学生を社内に留めようとするより、独立前提にした方が長く関われる、という思想。\n\n### 4. 熊谷さんのキャリア・強み\n\n#### 原点\n\n- 両親・親族が公務員中心の家庭で育った。\n  - 父: 検察官\n  - 兄弟: 警察官\n  - 母: 教員\n- 高校時代、サッカーの怪我を機に「決められたレールに乗るのは楽しくない」と気づき、営業の道へ進んだ。\n\n#### 実績・転機\n\n- 学生時代に営業で新人賞を獲得し、月100万円を達成したことが転機。\n- 学生インターン 120人組織の教育担当として、学生インターンのみで年商 3.5億円を達成。\n- 独立後、新規事業で年収 4,000万円まで到達。\n- 大手上場企業の広告業界でもインターンシップを運営。\n- 「インターン生がインタビューされる」メディアを自社運営。個性を失わせない社会への問題意識が背景。\n- AI会社に出向しながら、自社ホームページも AI を駆使して自作。\n- SNS はすべて削除済み。見せる必要がないと思ったら、自分が好きなようにお金を使えるという考え方。\n\n### 5. 若者・起業家育成についての対話\n\n#### 共通認識\n\n- 熊谷さんは、「バイアウト」という言葉だけを知り、キャッシュを貯めた後に何をしたいか答えられない学生が増えていることを懸念している。\n- 両者とも、アーリーリタイアを安易に目指す風潮には違和感がある。結局どこかで飽き、仕事は続くという見方。\n- 次廣は、AIや低コストの宣伝手段が揃った今、差別化は **人間力** や **その人だから選ばれる理由** に回帰すると共有。\n- 熊谷さんは、SNSが若者に「見せなければならない」という強迫観念を生んでいると見ている。\n\n#### 失敗を許さない社会構造\n\n- 次廣は、創業支援では「失敗した時のフォロー体制」が重要になると共有。\n- 熊谷さんは、売上が立った状態でのみ独立させることで、事前にリスクを最小化している。\n- 次廣は、尊敬するビジネスマンの言葉として「出口を先に考えてから起業する」考え方を共有した。\n\n### 6. 熊谷さんの将来ビジョン\n\n- 経営者になっても **現場を抜ける気は一切ない**。\n- 「全ての事業を知って死にたい」というエゴが原動力。\n- 新規事業の利回りやキャッシュアウトポイントを、自ら体験し続けたい。\n- 若い子たちで、必要なものを広げられるプラットフォームを作ることが夢。\n- 楽天経済圏のように、複数の事業・商材・人材が循環する構想を持っている。\n- 早稲田出身の岩本会長が「起業したい学生の9割が公務員志望」という現実に落ち込んでいたところ、熊谷さんが「若者はもっと頑張っている」と伝えたことが、新会社設立のきっかけになった。\n\n### 7. BNI・DragonFly に関する議論\n\n- 熊谷さんは BNI のビジター参加を 20〜30回程度経験しており、時間の規律を高く評価している。\n- 次廣は、熊谷さん本人が DragonFly に入ると、チャプターを盛り上げるスイッチが入り、本業に集中できなくなるリスクがあると見立てた。\n- 提案としては、熊谷さん本人ではなく **スタッフを入会させる** ことで、本業のビジネス拡大につなげる形が適切。\n- 東京NEリージョンは全国最大規模・約1,200名規模のリージョンであり、どこかのチャプターに参加することは価値がありそう。\n- 熊谷さんは、特定コミュニティに入ると「そのコミュニティを大きくしよう」という人が多く、自分の会社を大きくしたい思いと相容れない部分を感じている。\n\n### 8. 次廣所感\n\n熊谷さんは「通信費削減の人」として紹介すると、かなり小さく見えてしまう。実際には、通信費削減を入口にして紹介を作り、その先で **営業組織づくり・若者育成・創業支援・事業立ち上げ** を回している人。\n\nBNIとの相性はあるが、本人が入ると本業以外のチャプター運営に力を使いすぎる可能性がある。熊谷さん本人を DragonFly に迎えるかどうかより、スタッフや社長候補の学生・若手が BNI で紹介文化、25秒プレゼン、経営者接点を学ぶ方が、熊谷さんの本体事業と合う。\n\n次廣との接点は、すぐに大きな開発案件というより、まずは次廣自身の携帯プラン見直しで熊谷さんのサービスを体験すること。そのうえで、AI系企業・小規模法人・創業初期企業に対して、通信費削減をどう自然に紹介できるかを一緒に言語化するのが良い。\n\n---\n\n## ■ アクションアイテム（実施後）\n\n| 担当 | 内容 | 期限・状態 |\n|------|------|------------|\n| 次廣 | 携帯プランについて、熊谷さんへメッセンジャーで個別連絡する | 近日中 |\n| 次廣 | 熊谷さんのホームページ・事業動向をフォローする | 継続 |\n| 次廣 | AI系企業・業務改善顧客に対する携帯削減の紹介文脈を検討する | 継続 |\n| 次廣 | システム開発の相談があれば熊谷さんに声をかける | 必要時 |\n| 熊谷さん | 本人入会ではなく、スタッフ入会という選択肢を検討する | 継続 |\n| 熊谷さん・次廣 | AI系企業への携帯紹介の訴求方法を改めて議論する | 次回以降 |\n\n### 次回接点\n\n次回 1on1 の日程は未設定。まずはメッセンジャーでの携帯プラン相談を起点に、継続的な関係構築を進める。\n\n---\n\n## ■ 事前メモ（121前に押さえていたこと）\n\n### 今日の主目的\n\n1. 熊谷さんの通信費削減サービスを、次廣が **30秒で紹介できる言葉** にする。\n2. 「どんな相手なら紹介してよいか／紹介しない方がよいか」を具体化する。\n3. BNI入会の説得ではなく、熊谷さんにとっての **BNI参加価値** を本人の言葉で確認する。\n4. 小中さん・オリエン後の流れを踏まえ、再訪・他メンバー接続・紹介の次アクションを決める。\n\n### 現時点の見立て\n\n- 見込みは **★★**。オリエン希望あり、決済権ありのため前向き要素はある。\n- 一方で、オリエン時のメモでは **「現在の紹介で仕事が回っている」** とあり、売上不足を理由に入会するタイプではなさそう。\n- BNIの価値は、短期売上よりも **信用ある経営者接点・継続紹介・大手キャリアのまま見直せる安心感の伝播** として確認する。\n- 今日のゴールは「入会する/しない」ではなく、熊谷さんを紹介できる状態まで理解すること。\n\n---\n\n## ■ 接続コンテキスト（ビジター情報）\n\n| 項目 | 内容 |\n|------|------|\n| **参加種別** | ビジター |\n| **氏名** | 熊谷 龍笙（くまがい りゅうしょう） |\n| **会社名・役職** | 株式会社Lifinity 代表取締役 |\n| **カテゴリー** | 通信費削減 |\n| **紹介者** | 小中 貴晃さん |\n| **紹介者との関係** | 経営者交流会で会った |\n| **メール** | `kumagai.ryusho@lifinity.co.jp` |\n| **電話** | `080-4782-1571` |\n| **オリエン希望** | 有 |\n| **決済権** | 有 |\n| **メンバー見込み** | ★★ |\n| **アテンド** | 小中貴晃さん、渡邊真大さん、佐久間康丞さん、福士利明さん、山口薫さん |\n| **オリエン対応** | 小中貴晃さん |\n\n### カテゴリー詳細（本人説明）\n\n> 無制限/掛け放題を大手キャリアのまま ¥2,980〜 ご案内可能という武器を活かして、お客様の通信費用（携帯、固定回線、クラウドフォン、セキュリティなど）の削減をさせていただいております。\n\n---\n\n## ■ 事業理解（株式会社Lifinity）\n\n### 何を提供しているか\n\n- 通信費の削減支援。\n- 対象は携帯、固定回線、クラウドフォン、セキュリティなど。\n- 大手キャリアのまま、無制限/掛け放題を **¥2,980〜** で案内可能。\n- ソフトバンクをメインに扱い、料金交渉ができる。\n- 一人社長から個人事業主までサポート。\n- 上場会社からも依頼がある。\n- 楽天からの乗り換えが一番多い。\n\n### ビジター参加時のメモ\n\n| 論点 | 内容 |\n|------|------|\n| **事業年数** | ソフトバンクをメインに 8年目 |\n| **強み** | 大手キャリアのまま通信費を下げられる。ソフトバンクに料金交渉ができる |\n| **主な対象** | 一人社長、個人事業主。小規模法人も相性がよさそう |\n| **実績感** | 上場会社からも依頼あり |\n| **入口** | 楽天からの乗り換えが多い |\n| **差別化メモ** | 一人社長・個人事業主をターゲットにしている会社は他に少ない |\n| **電波に関する説明** | 福士さん質問への回答として、山間部はドコモが強いが、都市部等では au / ソフトバンク / ドコモ の比較観点があるとの説明 |\n\n### 確認したいこと\n\n- 「大手キャリアのまま ¥2,980〜」の適用条件。\n- 法人契約・個人契約・個人事業主契約で提案可否が変わるか。\n- いくら以上の通信費なら見直し効果が出やすいか。\n- 携帯だけでなく、固定回線・クラウドフォン・セキュリティまで見直す時の標準的な流れ。\n- 既存契約の違約金・端末残債・名義・利用エリアなど、紹介前に確認すべき注意点。\n\n---\n\n## ■ BNI温度感\n\n### すでに前向きな要素\n\n- オリエン希望あり。\n- 決済権あり。\n- 小中さんとの接点があり、DragonFly 側のフォロー担当も複数名いる。\n- 事業が「経営者の固定費削減」というわかりやすい入口を持っており、BNI内で説明しやすい。\n\n### 慎重に見る点\n\n- オリエン時点では「今のところビジター参加」という整理。\n- 理由として、**現在の紹介で仕事が回っている** こと、従業員が 10名くらいいても仕事が回っていることが記録されている。\n- そのため、売上不足を埋める目的ではなく、紹介の質・継続性・経営者ネットワークの価値を確認する必要がある。\n\n### 今日の聞き方\n\n> 今すでに紹介でお仕事が回っている中で、BNIに期待するとしたら、売上以外にどんな人脈や信用の広がりがあると参加する意味を感じますか？\n\n---\n\n## ■ 第1回121の進め方\n\n### 0. 冒頭（1〜2分）\n\n> 今日は小中さんのお繋ぎでありがとうございます。\n> DragonFlyにも参加いただいて、オリエンも受けられたと聞いています。\n> 今日は入会どうですか、というより、まず熊谷さんの事業をちゃんと理解して、僕が誰かに紹介できる状態にしたいです。\n\n### 1. ビジター参加・小中さん接点の確認（5分）\n\n- DragonFlyに参加してみて、印象に残ったことは何だったか。\n- 小中さんとは経営者交流会でどんな話からつながったのか。\n- オリエンを受けて、BNIについてどう感じたか。\n- 他の交流会・紹介経路と比べて、BNIに違いを感じた点はあるか。\n\n### 2. 事業理解（15分）\n\n- どんな相談が一番多いか。\n- 「通信費削減」と言った時、携帯・固定回線・クラウドフォン・セキュリティのどこから入ることが多いか。\n- 楽天からの乗り換えが多い理由。\n- ソフトバンクへの料金交渉は、一般代理店との違いとしてどう説明すればよいか。\n- 上場会社からの依頼は、どんな課題がきっかけだったか。\n\n### 3. 紹介条件の具体化（15分）\n\n- 紹介しやすい会社規模。\n- 月額通信費の目安。\n- 紹介してほしい業種・避けたい業種。\n- 請求書や契約情報など、初回面談前に用意してもらうと良いもの。\n- 紹介者が相手に伝えるべき一言。\n\n### 4. BNI参加価値の確認（10分）\n\n- すでに紹介で仕事が回っている中で、さらに増やしたい紹介の種類。\n- DragonFlyに入るとしたら、どんなメンバー・顧客層とつながりたいか。\n- 逆に、入会判断で気になっている点。\n- 継続的にBNIに参加する上で、時間・費用・役割のどこがハードルになりそうか。\n\n### 5. 次アクション（5分）\n\n- 次廣から紹介できそうな相手がいるか整理する。\n- 小中さんへの共有内容を決める。\n- 必要なら、請求書見直しのサンプルや紹介用一文を熊谷さんからもらう。\n- 再訪・再121・他メンバー接続の要否を決める。\n\n---\n\n## ■ 質問リスト\n\n### 事業の強みを言語化する質問\n\n- 「通信費削減」と一言で言っても幅が広いと思うのですが、熊谷さんが一番得意なのは携帯・固定回線・クラウドフォン・セキュリティのどこですか？\n- 「大手キャリアのまま安くなる」と聞くとかなり強いですが、適用条件や注意点はありますか？\n- ソフトバンクをメインに8年とのことですが、料金交渉ができる背景はどう説明するとよいですか？\n- 上場会社から依頼される時は、どんな課題や不満から相談が始まりますか？\n- 楽天からの乗り換えが多いとのことですが、何に困って乗り換える方が多いですか？\n\n### 紹介しやすくする質問\n\n- 一番喜ばれるお客様は、何名規模・どんな業種ですか？\n- 一人社長・個人事業主の中でも、特に相性が良い業種はありますか？\n- 月いくら以上通信費を払っていると、見直しの価値が出やすいですか？\n- 紹介前に「請求書があると早い」など、用意してもらうものはありますか？\n- 紹介者が先方に何と言えば、一番誤解なく伝わりますか？\n- 逆に、こういう人は紹介されても困る、という条件はありますか？\n\n### BNI・DragonFlyの確認\n\n- DragonFlyのビジター参加で、印象に残った人やプレゼンはありましたか？\n- オリエンを受けて、BNIの仕組みはどう感じましたか？\n- 今の紹介で仕事が回っている中で、BNIに入るなら何を期待しますか？\n- 熊谷さんにとって「いい紹介」とは、売上以外にどんな条件がありますか？\n- BNIに入る上で、時間・費用・役割・紹介の質のどこが一番気になりますか？\n\n---\n\n## ■ 紹介トーク仮説\n\n### 15秒版\n\n> 携帯や固定回線などの通信費を、大手キャリアのまま見直せる方です。\n> 一人社長や個人事業主、小規模法人の固定費削減に強く、請求書ベースで削減余地を見てくれます。\n\n### 30秒版\n\n> 株式会社Lifinityの熊谷さんは、携帯・固定回線・クラウドフォン・セキュリティなど、通信まわりの固定費削減を支援されています。\n> 特に、大手キャリアのまま無制限/掛け放題を ¥2,980〜 で案内できるのが強みで、一人社長や個人事業主、小規模法人の見直しに向いています。\n> 通信費が高い、楽天から乗り換えたい、法人携帯や固定回線をまとめて見直したい方がいれば、一度請求書ベースで相談してみると良さそうです。\n\n### 紹介時に確認したい前提\n\n- 現在のキャリア。\n- 月額通信費。\n- 台数・回線数。\n- 固定回線・クラウドフォン・セキュリティも含めて見直したいか。\n- 通話量、データ利用量、利用エリア。\n- 法人契約か個人契約か。\n\n---\n\n## ■ 次廣側の自己紹介ショート\n\n> 僕は tugilo という屋号で、業務改善のシステム開発をしています。\n> いきなり大きなシステムを入れるというより、社長が「なんとかしたいけど言葉にできていない」業務のモヤモヤを聞いて、Excel・LINE・予約・顧客管理などを現場に合う形に整理する仕事です。\n> 最近は BNI の中で、害虫ブロックFCの管理、不動産・外構紹介、サロンや動物病院の予約導線など、経営者の固定費や手間を減らす相談が増えています。\n\n熊谷さんには、通信費削減という入口があるため、次廣側は **通信費以外の業務固定費・運用負担** の相談で補完できる可能性がある。\n\n---\n\n## ■ tugiloとしての接点仮説\n\n### 1. 固定費削減 × 業務改善\n\n熊谷さんは通信費の固定費削減、次廣は業務の手間・転記・予約・顧客管理の削減。どちらも経営者にとっては **毎月のムダ・見えないコストを減らす** 仕事。\n\n紹介先の経営者に対しては、以下のような連携が考えられる。\n\n- 通信費が高い → 熊谷さん。\n- 予約・問い合わせ・LINE・顧客管理がバラバラ → 次廣。\n- 小規模法人で固定費と事務作業を同時に見直したい → 熊谷さん + 次廣の順で整理。\n\n### 2. 小規模法人・一人社長向けの入口共有\n\n熊谷さんのターゲットが一人社長・個人事業主であれば、次廣の「業務改善をしたいが大きなシステム導入はまだ早い」層と近い。\n\n今日確認したいのは、熊谷さんがすでに接点を持つ顧客の中に、以下のような困りごとがあるか。\n\n- 請求書・契約書・顧客管理が散らばっている。\n- LINEや電話での問い合わせ管理が属人化している。\n- スタッフが増えたが業務フローが整っていない。\n- 通信費だけでなく、SaaSやIT利用料も見直したい。\n\n---\n\n## ■ DragonFly内の紹介・接続候補の考え方\n\n### 紹介されやすそうな相手\n\n- 法人携帯を複数台持つ経営者。\n- 個人事業主で、携帯・固定回線・クラウドフォンをなんとなく契約したままの人。\n- 楽天モバイルから乗り換えを検討している人。\n- 従業員が増え、通信契約・端末・クラウドフォンの管理が煩雑になっている会社。\n- 店舗・クリニック・サロンなど、固定回線や電話番号が業務に直結する事業者。\n\n### DragonFly内での紹介導線仮説\n\n- 小中さん: 紹介者・オリエン担当として、熊谷さんの温度感確認。\n- 渡邊さん・佐久間さん・福士さん・山口さん: アテンド済みのため、初回接点の印象や紹介余地を聞ける。\n- 経営者接点が多いメンバー: 顧問先・顧客先で固定費削減ニーズを拾いやすい。\n\n※具体的なメンバー名と紹介先は、今日の会話で「どんな業種が最も刺さるか」を確認してから精査する。\n\n---\n\n## ■ 会後アクション候補\n\n### 熊谷さんに依頼するもの\n\n- 紹介者向けの 15秒紹介文。\n- 「こういう請求書なら見直せる」というサンプル条件。\n- 紹介前チェック項目（キャリア、台数、月額、契約名義など）。\n- BNI入会判断で気になっている点。\n\n### 次廣がやること\n\n- 今日の121内容をこのファイルに実施後メモとして追記する。\n- 紹介できそうな相手が見えたら、小中さんとも共有して温度感を確認する。\n- 熊谷さんの紹介トークを、DragonFlyメンバーに伝えやすい形へ短文化する。\n- 必要なら通信費削減と業務改善の補完関係を整理し、相互紹介の可能性を確認する。\n\n---\n\n## ■ メモ（人物・温度感）\n\n- 既存紹介で仕事が回っているため、押し売り型の入会提案は合わない可能性が高い。\n- 「紹介で仕事が回っている人が、BNIに入る意味」を一緒に言語化できると、判断が進みやすい。\n- 通信費削減は、紹介者側が相手に言いやすい。差別化は「大手キャリアのまま」「一人社長・個人事業主に強い」「ソフトバンクへの料金交渉」。\n- 121では、安さだけでなく **安心して紹介できる条件** を確認する。','2026-06-19 12:59:50','2026-06-19 13:00:07'),
(80,1,37,8,NULL,NULL,NULL,'manual','2026-06-19 09:00:00','2026-06-19 09:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_fukushi_toshiaki_universe_products.md#第1回】\n\n### 【第1回】2026-06-19\n\n#### 基本情報\n\n- **日時:** **2026-06-19（金）JST 09:00〜**（終了時刻 TODO）\n- **実施方法:** Zoom（プロフィールシート画面共有あり）\n- **参加者:** 福士利明さん、次廣 淳\n- **Religo 1to1 レコード:** `one_to_ones.id` = **80**\n- **目的:** 福士さんの事業・紹介条件を理解し、次廣から紹介できる相手と、福士さんから紹介してもらいやすい相手を言語化する。\n\n### 1. 次廣の事業紹介\n\n#### 経歴・事業の背景\n\n- 次廣は静岡在住のシステムエンジニア。外国語学部フランス語専攻という文系バックグラウンドから、1990年代後半のインターネット黎明期にパソコン・DTMを趣味として始め、IT業界へ入った。\n- 大学在学中にインターネットで知り合った東京のシステム会社社長から誘われ、大学を中退して入社。コンピュータ組み立て、インフラ構築、システム設計・開発、営業を経験した。\n- 30歳で独立して地元静岡に戻り、システムエンジニアとして26年目。\n- コロナ前からオンラインで全国の仕事を受けており、コロナ禍のオンライン化とAI活用が追い風になった。\n- 屋号は **tugilo（ツギロ）**。自身の名前「つぎひろ」と、世界共通語を目指したエスペラント語の精神を重ねている。\n\n#### 強み・提供価値\n\n- 既存パッケージを押し付けるのではなく、業務に合わせてゼロから作るフルスクラッチ開発が強み。\n- 製造業・建設業など、すでに現場ワークフローがある業種に対し、現場の負担を増やさず **誰でも使えるシステム** を設計する。\n- 例: タブレットのボタン操作だけで登録できるUI、LINEで日報を提出できる仕組みなど。\n- 大規模システムを一気に作るのではなく、小さく始めて改善していく伴走型開発を大切にしている。\n- クラウド・ブラウザベースのシステムが中心で、PC・スマホ対応。Webデザイナーとの協業も行う。\n- AI活用により、一人でも開発効率を大きく上げられる状態になっている。\n\n#### 共有した主な実績\n\n| 顧客 / 領域 | 課題 | 解決内容 |\n|-------------|------|----------|\n| **増本さん / 害虫ブロックFC管理** | 全国200社超の取扱店管理が、Excel・スプレッドシート・Googleフォーム・メールに分散 | 一元管理システムを構築。売上・仕入れ状況をリアルタイムで可視化 |\n| **名古屋の防水工事業者** | 外国人職人を含む現場からの紙の日報が読みにくく、管理工数が大きい | LINEを活用した日報提出システムを構築。作業内容・時間・材料から現場別の人件費・材料費を自動集計 |\n| **静岡・駿河企画観光局** | 周遊イベントの参加管理・行動データ収集 | LINE連携スタンプラリー。プレゼント応募・行動マッピングを実現 |\n| **動物病院** | 予約管理 | 独自のLINE予約管理システムを構築 |\n\n#### 次廣が紹介してほしい相手\n\n- 現場管理に課題を抱える会社。\n- 人員増加を検討しているが、その前に業務の仕組み化余地がありそうな会社。\n- Excel管理が限界、コピペ作業が多い、特定の人しか分からない業務がある会社。\n- 顧問先を持つ士業・コンサルタント。\n- Webデザイナーなど、フロント側を担える協業パートナー。\n\n### 2. 福士さんの経歴・BNIでの変化\n\n- 福士さんは神奈川県川崎市出身、現在は群馬県太田市在住（26年目）。\n- 健康器具メーカーで営業を始め、その後印刷業で25年。うち5年は役員として、M&A後の会社経営にも関わった。\n- 印刷業界が9兆円規模から3兆8,000億円規模へ縮小する過程を経験し、紙からデジタルへの移行を強く実感した。\n- 53歳のとき、妻の許可を得て現職の株式会社ユニバースプロダクツへ転職。営業歴は36〜37年。\n- コロナ禍でZoom操作に苦労したが、初のオンラインチャプターであるBNI DragonFlyに入会し、オンライン営業を習得した。\n- DragonFly入会4年5ヶ月。入会後、約1,000人と1to1を実施。\n- カテゴリ変更後は、毎日最低4人との1to1を継続している。\n\n### 3. 事業1: BtoC国際物流・海外販路支援\n\n- ボトル1個から航空便で世界中に配送できる、BtoC国際物流サービスを提供している。\n- 佐川・日通などの大手がBtoCを嫌がる、利幅の少ない領域の隙間を埋めている。\n- 中国に強力なパイプを持ち、大手が配送できない地域にも対応可能な中国パートナーが強み。\n- 8年前に中国から始まり、東南アジアへ広がり、現在は世界中に展開。FedEx・DHLも含めて活用する。\n- DragonFly内では倉持さんらとパワーチームを組み、中国TikTokライブコマースで日本商品を販売し、配送までつなぐ取り組みも行っている。\n\n### 4. 事業2: コンクリートリバイブ CTP2000\n\n#### 商品概要\n\n- **コンクリートリバイブ CTP2000** は、アメリカ製・水性のコンクリート含浸材。\n- 日本国内の既存製品はシラン・シロキサン系が中心で、人体への有害性が課題になりやすい。一方、CTP2000 は水性で人体への負担が少ない点が特徴。\n- 塗布するとコンクリート内部へ最大14cm以上浸透する。既存品は3〜4cm程度という説明。\n- 内部で化学反応によりゲル化・固着し、コンクリートの微細孔を塞ぐことで内部防水を実現する。\n- リペアではなく、現状維持・保護が主目的。コンクリート劣化の主因である鉄筋の錆びを防ぐ。\n- アメリカでは国防省・NASAへの納入実績がある。\n- 1,600℃耐火テスト、硫酸・塩酸浸漬テストでも優れた結果が出ている。\n\n#### 認証・市場背景\n\n- ゼネコン側の圧力で自主規格では扱われにくかったが、国土交通省認可機関 **NETIS** の登録番号を取得している。\n- コンクリート含浸材カテゴリーで、日本唯一のNETIS登録という説明。\n- 2023年末に政府が「超寿命化計画」を掲げ、既存建物を壊さず維持する方針が強まった。\n- これにより、市町村・県庁からの引き合いが増えている。\n- NETIS番号を使った公共事業には、国からのキックバックがある。\n- スーパーゼネコン1社が今夏に採用検討中。北海道・九州・沖縄でも展開中。\n\n#### 主な用途・ターゲット\n\n| 用途 / 顧客 | 課題・紹介ポイント |\n|-------------|--------------------|\n| **防水工事業** | ナフサ不足による部材調達難の代替。7ヶ月で7社と新規契約、うち2社はBNI会員の防水工事業者 |\n| **太陽光発電パネルの基礎コンクリート** | 雨風にさらされ、基礎コンクリートが劣化しやすい |\n| **食品工場の床面** | 塩・砂糖・調味料による腐食で穴が開き、衛生上の問題や営業停止リスクがある |\n| **原子力発電所の防潮堤** | 海風による塩害対策。幅3m・高さ23m・延長8km規模の構造物 |\n| **ゴルフ練習場の柱** | コンクリート劣化による倒壊リスク対策 |\n| **北海道・東北など寒冷地** | 温度変化によるコンクリートの膨張・収縮への対策 |\n| **化学薬品を使う製造工場床面** | 薬品による腐食対策 |\n\n#### 販売モデル\n\n- 完全直販。代理店・フランチャイズは設けない。\n- ロイヤリティ・契約金は不要。\n- BNIメンバーからの紹介顧客には、初回10%値引きで提供。\n- 定価販売・ダンピング禁止の契約書を締結する。\n- 施工業者（塗装屋、鉄筋工事業者、型枠屋など）との協業パートナーも募集している。\n\n### 5. 相互の接点・協業可能性\n\n#### 福士さん側のシステム構築相談\n\n- 福士さんの会社では、過去に3年・数千万円を投資したシステムが、結果的に使えなくなった苦い経験がある。\n- コロナ前に構築したが、多言語対応などの課題もあり、実運用に乗らなかった。\n- 現在も5社をまとめるシステム構築に課題を抱えており、「いつ・どこで・どう作ればよいか分からない」状態。\n- 福士さんは、次廣の **クライアントと一緒に作る伴走型スタイル** に関心を示し、今後の相談相手として活用したい意向。\n\n#### CTP2000の紹介可能性\n\n- 次廣の実績先である名古屋の防水工事業者が、CTP2000の紹介候補になり得る。\n- 福士さん側では、名古屋エリアの契約がまだゼロ。\n- 次廣がまず、名古屋の防水工事業者へ状況・関心を確認する。\n- 福士さんは、商品資料と7分間ビデオを次廣へ共有する。\n\n---','2026-06-19 12:59:50','2026-06-24 15:48:12'),
(81,1,37,166,NULL,NULL,NULL,'manual','2026-06-19 14:00:00','2026-06-19 14:00:00',NULL,'completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_yokoyama_taiki_aratas.md】\n\n# 1to1_横山太樹_ARATAS\n\n---\n\n**文書の位置づけ:** 渡邊真大さん紹介で DragonFly にビジター参加した横山太樹さん（株式会社ARATAS / 資金調達支援）との初回 121。事前準備と、Zoom要約を統合した **実施後議事録**。  \n**日時:** 第1回 **2026-06-19（金）JST 14:00〜**（Zoom。終了時刻 TODO）。  \n**主な成果:** ARATAS の **元銀行員 × 税理士** の財務顧問サービスが、次廣の法人化・財務戦略・銀行対応・資金繰り課題と高く親和することを確認。次廣は横山さんへ個別相談する意向を示し、横山さんの DragonFly 入会について渡邊真大さんへプッシュすることで合意。  \n**Religo 1to1 レコード:** `one_to_ones.id` = **81**（completed）。\n\n---\n\n## ■ 実施後サマリー（2026-06-19）\n\n### 主要な成果\n\n- 横山さんから、株式会社ARATAS の財務顧問サービスを詳しく聞いた。サービスの核は、**元銀行員の横山さん** と **税理士である代表** の二人体制で、銀行目線と税務目線の両方から経営者の資金調達・決算・事業計画を支援すること。\n- 次廣の現状課題（個人事業主としての法人化検討、入金サイクル長期化に伴う運転資金、銀行対応、会計ソフト、外部パートナー活用）と、ARATAS の支援内容に高い親和性があることを確認した。\n- 次廣は、横山さんへ **法人化・財務戦略・銀行格付け改善** について個別相談する意向を示した。\n- 横山さんの DragonFly 入会について、次廣が渡邊真大さんへ複数回プッシュすることで合意した。\n- 会話の中で、両者が **獨協大学出身** であることが判明。次廣が先輩、横山さんが後輩という共通縁ができた。\n\n### 決定事項・合意\n\n| 項目 | 内容 |\n|------|------|\n| **次回個別相談** | 次廣が、法人化・財務戦略・銀行対応について横山さんへフランクに相談する。具体日程は未設定。 |\n| **会計ソフト** | ARATAS は会計ソフトを指定せず、クライアント側の自由選択を認める。どのソフトにも対応可能。 |\n| **スポット対応** | 月額顧問契約だけでなく、個人事業主・小規模事業者向けのスポット相談・単発支援も可能。 |\n| **DragonFly 入会支援** | 次廣が渡邊真大さん（マオさん）へ、横山さんの DragonFly 入会を複数回プッシュする。 |\n| **AI セキュリティ共有** | 横山さんが、Claude 利用時のセキュリティリスクについて代表へ確認・共有する。 |\n\n### ARATAS のサービス理解\n\n#### 基本コンセプト\n\n- ARATAS は、**元銀行員（横山さん）× 税理士（代表）** の二人体制で財務顧問を提供している。\n- 横山さんは信用金庫に約15年勤務し、うち2年はりそな銀行へ出向。融資・渉外部門長も経験している。\n- 最大の強みは、銀行担当者の思考・審査プロセス・内部事情を知っていること。\n- 横山さんの役割は、経営者の考えや事業計画を、銀行担当者が審査に通しやすい資料・説明に翻訳すること。\n\n#### PDCA型の支援\n\nARATAS の財務顧問は、単発の融資・補助金申請ではなく、以下のサイクルで経営を伴走する。\n\n1. 事業計画を策定する。\n2. 資金調達（補助金・銀行融資）の計画を立てる。\n3. 設備導入・経営実行を進める。\n4. 月次モニタリング・予実管理を行う。\n5. 決算で振り返り、銀行からどう見られるかを分析する。\n6. 次の事業計画・資金調達計画へつなげる。\n\n決算結果をもとに、銀行からの見え方、次に力を入れるべき指標、金利や格付けへの影響をフィードバックする点が特徴。\n\n#### 料金・契約形態\n\n- 基本は月額顧問料形式。\n- 個人事業主・小規模事業者には、スポット相談・単発支援も可能。\n- 補助金申請では、手付金無料キャンペーンを実施中。成功報酬型。\n- 代表税理士との税務顧問契約と同時契約の場合、横山さんの財務顧問がオプションで付帯する。\n\n#### 対応業種・規模\n\n- 業種・規模は問わず対応可能。全国オンライン対応も可能。\n- 創業支援、創業補助金、リスキリング補助金、職場環境改善補助金などにも対応。\n- 一方で、運転資金・設備投資ニーズが少ない純粋サービス業（人件費中心）の場合は、財務顧問の必要性が低い場合もあると正直に説明している。\n\n### 次廣側の課題・相談テーマ\n\n#### 現状\n\n- 次廣は個人事業主として26年間システムエンジニアを継続している。\n- 妻が専従者として経理入力を担当。簿記資格も保有。\n- 現在の税理士は高校の同級生で、月次経費処理・確定申告を依頼している。\n- ただし、事業提案・財務アドバイス・法人化判断の伴走は受けていない。\n- 信金の担当者とは良好な関係があり、融資も通っている実績がある。\n\n#### 課題・関心\n\n- 法人化のタイミングと形態を検討中。マイクロ法人を並行設立する案も含めて整理したい。\n- 法人税の低さと社会保険料負担のトレードオフを正確に理解したい。\n- 開発案件では入金サイクルが1〜6ヶ月超になることがあり、運転資金確保が課題。\n- 銀行格付けの仕組みを今回初めて知り、決算書が金利に直結することを理解した。\n- 現在の会計ソフトが使いにくく、変更を検討している。\n- 一人でプレイヤーとマネジメントを兼務する限界を感じており、外部パートナー活用・法人化・採用を検討している。\n\n### 銀行・融資に関する学び\n\n#### 格付けと金利\n\n- 銀行は、毎年提出される決算書をもとに **正常先・要注意先・破綻懸念先** などの格付けを行う。\n- 格付けに応じた内部金利表があり、リスクが高いほど金利が高くなる。\n- 同じ金額を借りても、財務内容によって金利は大きく異なるため、経営者同士で単純に金利比較しても意味がない。\n- 金利を下げるには、バランスシート・PL・キャッシュフローの改善が必要。\n\n#### 銀行との付き合い方\n\n- 中小企業は、信金・地銀から始まり、成長に応じてメガバンクへステップアップしていくことが多い。\n- 銀行担当者は2年程度で交代するため、関係構築のやり直しが頻繁に起きる。\n- 能力の高い担当者ほど転勤・昇進が早く、担当者スキルのばらつきも大きい。\n- 担当者1人が100社程度を抱えることもあり、個別企業に深く入り込むには限界がある。\n- 横山さんの支援は、銀行担当者が審査を通すための **武器（資料・説明）** を経営者側に用意する役割。\n\n#### 小規模企業共済・中退共\n\n- 次廣はすでに小規模企業共済に加入済みで、退職金代わりとして活用している。\n- 小規模企業共済には貸付制度があり、金利約1.5%で利用できるため、銀行融資より大幅に低コストになる場合がある。\n- 法人化後は、中退共（中小企業退職金共済）も選択肢として加わる。\n\n### AI活用と情報セキュリティ\n\n#### ARATAS のAI活用\n\n- 横山さんは入社直後から **Claude** を業務導入しており、プロンプト設計も行っている。\n- 用途は、顧問先への情報提供システム構築や、補助金申請書類の壁打ち。\n- 個人情報の外部流出を防ぐ設定をしているが、個人情報の入力は最小限に抑えている。\n- 作成したプロンプト・システムの外部販売も検討中。\n\n#### 次廣側の問題意識\n\n- 従業員が無断でAIサービスを利用する **シャドーAI** が、日本企業全体の問題になりつつある。\n- 近い将来、AIを起点とした情報漏洩問題が顕在化する可能性がある。\n- 一方で、企業がAI利用に過度に慎重になると、日本全体がAI活用で世界に5〜10年遅れるリスクもある。\n- 対策としては、ローカルサーバーでのAI運用が理想。次廣は顧問税理士（友人）と、ローカルAIサーバーの実験を計画中。\n- 税理士事務所向けのセキュアなAIサービスは、今後必ず必要になるという認識で両者が一致した。\n\n#### AI時代の専門家価値\n\n- AIで個人でも多くの業務をこなせるようになった一方、AIの回答が正しいかを判断できる専門家の重要性は増している。\n- 新規AIビジネスへの銀行融資は、依然として警戒されやすい。投資家・エンジェル経由の資金調達が主流になりがち。\n- 横山さんは、経営者の **言語化できないビジョン** を引き出し、金融機関に伝わる形に翻訳する役割も担える。\n\n### BNI DragonFly に関するメモ\n\n- 次廣は2025年3月に BNI 入会。東京NEリージョン・DragonFlyチャプター所属。\n- DragonFly は完全オンライン運営で、千葉・静岡メンバーが多い。\n- 東京NEリージョンは約1,200人規模で日本最大。\n- 横山さんは渡邊真大さん紹介で DragonFly にビジター参加し、約20名と接続した。\n- DragonFly には現在税理士が不在のため、横山さんへのニーズは高い。\n- ARATAS は上野拠点で、フォーラム会場の浅草橋にも近いことが入会検討の動機になっている。\n- ARATAS の代表・もう一人のメンバーは横浜リージョンに所属しており、横山さんを東京側へ配置することを戦略的に検討中。\n\n### 共通の大学縁（獨協大学）\n\n- 両者が **獨協大学** 出身であることが判明。次廣が先輩、横山さんが後輩。\n- 次廣は外国語学部フランス語学科出身。卒業はせずに就職。1998年フランスワールドカップに触発されてフランス語を選択した。\n- 横山さんは経済学部出身。北海道出身で、大学卒業後にUターンした。\n- 横山さんは2009年入学・2013年卒。在学中に東日本大震災があり、校舎の多くが耐震基準不足で立入禁止になった。\n- 震災後、姉歯事件に関連する耐震問題が発覚し、獨協大学の建物は順次建て替えられた。\n- 現在は、パルテノン神殿のような現代的な建物が並ぶキャンパスになっている。\n- 最寄り駅の松原団地も、現在は **獨協大学前** に改称されている。\n\n### 未確認・保留事項\n\n- 横山さんの正式入会チャプター。DragonFlyを含む複数チャプターを検討中で、代表の最終判断待ち。\n- 次廣の法人化の具体的なタイミング・形態。マイクロ法人との並行設立案も含めて未決定。\n- ARATAS が開発中の金融機関紹介システム（地域の金融機関担当者を顧客へ紹介するネットワーク）の構築状況。\n- 次廣の顧問税理士（友人）とのローカルAIサーバー共同実験の進捗。\n\n### アクションアイテム\n\n| 担当 | 内容 |\n|------|------|\n| **次廣** | 横山さんへの個別相談をセッティングする（法人化・財務戦略・銀行格付け改善）。 |\n| **次廣** | 渡邊真大さん（マオさん）へ、横山さんの DragonFly 入会を複数回プッシュする。 |\n| **横山さん** | 獨協大学OBとのBNI上での出会いを代表へ報告する。 |\n| **横山さん** | Claude利用のセキュリティリスクについて、代表（ヘビーユーザー）に確認・共有する。 |\n| **次廣** | 税理士（友人）とのローカルAIサーバー実験を継続推進する。 |\n\n### 次回ミーティング\n\n具体的な日程は未設定。次廣から横山さんへ個別に連絡し、財務・法人化に関するフランクな相談セッションを設ける。\n\n### 横山さんへのお礼文案（実施後版）\n\n> 横山さん、本日は121のお時間をいただきありがとうございました。  \n> ARATASさんの財務顧問について、元銀行員の視点と税理士の視点を合わせて、決算書・事業計画・銀行対応を伴走されていることがよく分かりました。  \n> 特に、銀行格付けや金利の考え方、銀行担当者が審査を通すための資料づくりの話は、私自身の法人化・資金繰り・銀行対応を考えるうえでも非常に勉強になりました。  \n> 私自身も法人化や財務戦略について一度フランクに相談させていただきたいので、改めて日程調整させてください。  \n> また、DragonFlyへの参加については、マオさんにも横山さんの良さをしっかりプッシュしておきます。  \n> 獨協大学の後輩だったとは驚きました。何かの縁だと思いますので、今後ともよろしくお願いいたします。\n\n---\n\n## ■ 直前用 5分メモ\n\n### 今日の目的\n\n- 横山さんのサービスを、**「1年以内に資金調達を検討している中小企業経営者」へ紹介できる言葉**に落とす。\n- 「資金調達支援」が、融資・補助金・事業計画・財務顧問・税務顧問のどこまでを含むのか確認する。\n- DragonFly 参加後アンケートで出ている **「製造業関連のビジネスモデルをお持ちの方」** が、具体的にどんな紹介先を指すのか深掘りする。\n- 入会検討状況を確認する。複数チャプター見学中との履歴があるため、今の意思決定ポイントを聞く。\n- 次廣側は、AI業務改善システム構築を売り込むより、**資金調達・補助金・財務管理・製造業DX** の文脈で接点を探す。\n\n### 最初に握ること\n\n> 横山さん、本日はお時間ありがとうございます。渡邊真大さんのビジターとして DragonFly に参加されたと伺っています。  \n> アンケートや対応履歴を拝見すると、ARATASさんは元銀行員と税理士の視点で、補助金・融資・事業計画を含む財務顧問をされていると理解しました。  \n> 今日はまず、横山さんの事業を私が人に紹介できるくらい理解する時間にさせてください。特に「どんな会社を紹介すると一番価値が出るか」「DragonFly でどんなつながりを作りたいか」を教えていただけると嬉しいです。  \n> そのうえで、私のAI業務改善・システム化の話も短く共有し、製造業や中小企業の資金調達・業務改善まわりで相互に紹介しやすい接点を探せたらと思っています。\n\n### 今日のキーワード\n\n- **元銀行員 × 税理士**: 銀行が「貸せるか」で見る視点と、税理士が「守れるか」で見る視点を合わせる。\n- **財務顧問**: 月4万円〜、年4回MTG、決算後の振り返り、事業計画を通じた資金調達伴走。\n- **紹介してほしい相手**: 1年以内に資金調達を検討している中小企業経営者。特に製造業・設備投資・運転資金・補助金活用の可能性がある会社。\n- **IT導入補助金との接続**: 次廣のAI業務改善システム構築と、ARATASの補助金・事業計画支援が接続できるか確認する。\n- **DragonFly上の関心**: 紀川さん・竹内さん・海沼さんとの名刺交換希望。製造業関連のビジネスモデルを持つ人。\n- **入会検討**: メンバーになる見込み ★★★。複数チャプター見学中のため、どこで決めるかの基準を確認。\n\n### 今日確認したい一言\n\n> 横山さんを紹介するときは、  \n> 「1年以内に融資・補助金・設備投資を考えている中小企業経営者に、銀行目線と税理士目線の両方で事業計画と資金調達を伴走してくれる方がいます」  \n> という言い方で合っていますか？\n\n---\n\n## ■ 初回セッション設計（60分想定）\n\n| 時間 | パート | 内容 |\n|------|--------|------|\n| 0〜5分 | オープニング | 渡邊真大さん紹介へのお礼、DragonFly参加の感想、今日の目的共有 |\n| 5〜15分 | 人となり | 元銀行員/税理士連携の背景、ARATASでの役割、なぜ財務顧問か |\n| 15〜30分 | 事業理解 | 月4万円〜財務顧問、年4回MTG、決算後振り返り、事業計画、融資/補助金の範囲 |\n| 30〜42分 | 紹介条件 | 1年以内の資金調達、製造業、設備投資、良い紹介/困る紹介、紹介後の流れ |\n| 42〜52分 | BNI/DragonFly | 入会検討状況、他チャプター見学、DragonFlyで作りたいつながり、紀川/竹内/海沼さん希望の理由 |\n| 52〜58分 | 次廣共有 | AI業務改善システム構築、製造業DX、補助金活用・財務管理との接点 |\n| 58〜60分 | クロージング | 次アクション、紹介候補、資料共有、次回有無 |\n\n---\n\n## ■ 基本プロフィール\n\n| 項目 | 内容 |\n|------|------|\n| **参加種別** | ビジター |\n| **氏名** | 横山 太樹（よこやま たいき） |\n| **会社名** | 株式会社ARATAS |\n| **役職** | 財務業務担当 |\n| **カテゴリー** | 資金調達支援（補助金・融資） |\n| **カテゴリー詳細** | 元銀行員と税理士が行う財務顧問。月4万円〜、年4回MTG、決算後振り返り、事業計画を通じて、資金調達（補助金・融資）に伴走するサービス。 |\n| **紹介者** | 渡邊 真大 |\n| **紹介者との関係** | 顧問税理士 |\n| **HP（ユーザー提供）** | https://lucent-parfait-415ba3.netlify.app/（確認時 404） |\n| **HP（公開確認）** | http://www.aratasmvdc.co.jp/ |\n| **メール** | taiki1002.mvdc@gmail.com |\n| **電話** | 03-5830-7641 |\n| **決済権** | 有 |\n| **BNI経験** | なし |\n| **ビジター経験** | なし |\n| **意思決定タイプ** | 不明 |\n| **メンバーになる見込み** | ★★★ |\n\n### 対応者・関心メンバー\n\n| 項目 | 内容 |\n|------|------|\n| **名刺交換希望** | 紀川さん・竹内さん・海沼さん |\n| **アテンド** | 舩杉牧子、竹内駿太、紀川和弘、海沼功、望月雅幸 |\n| **オリエン** | 舩杉牧子、竹内駿太 |\n| **オリエン希望** | 無（新メンバーの同席OK） |\n\n### アンケート要点\n\n- DragonFly参加後、気付きや学びは **YES**。\n- BNIの仕組みは自身に役立ちそう **YES**。\n- Givers Gain への共感 **YES**。\n- DragonFlyメンバーとして一緒にビジネス拡大したいかは **「詳しく話を聞きたい」**。\n- 連携できそうなメンバーは **製造業関連のビジネスモデルをお持ちの方**。\n- 印象に残ったことは **リファーラル件数が多かったこと**。\n\n### DragonFly 2026-06-09 定例会メモ\n\n- ビジター紹介では、横山さんは **資金調達支援（補助金・融資）**、渡邊真大さん紹介、**元銀行員** と整理されていた。\n- 要点は **融資・補助金活用、決算書・事業計画づくり（全国対応）**。\n- ビジター感想では **「リファーラルが活発で活気がある。1to1希望者が多数いた」** と記録。\n- 次廣側のフォロー候補として、**補助金・融資・決算書。IT導入補助金との接続** が記録されている。\n\n### 対応履歴\n\n- **2026-06-09 10:07 竹内駿太:** 1年以内に資金調達を検討している中小企業をつないでほしい。母体が税理士事務所。顧客は全国に広げていきたい。\n- **2026-06-09 12:05 舩杉牧子:** 決裁者が横浜のシナジーチャプターにおり、いくつかチャプターを見学中。最後に金曜日の「どさんこ」チャプターを見学し、その後どこかに入会決定予定。16日のバーバブルに参加予定。\n\n---\n\n## ■ 公開HPから見えるARATASの訴求\n\n公開HPでは、ARATASは **「元銀行員と税理士。二人で並走する財務顧問」** と表現されている。\n\n### サイト上の主要メッセージ\n\n- 決算書には、銀行が **「貸せるか」** で読む見方と、税理士が **「守れるか」** で読む見方がある。\n- ARATASは、その両方の読み方をひとつの机に並べる財務顧問。\n- 銀行交渉、融資条件、金利、補助金、追加調達、銀行に通る事業計画書が主な相談テーマ。\n- コアターゲットは、特に **拡大期〜戦略期** の経営者。\n\n### フェーズ別の紹介イメージ\n\n| フェーズ | 目安 | 紹介文脈 |\n|----------|------|----------|\n| **立ち上げ期** | 創業1〜3年 / 年商1億円未満 | 創業融資、補助金、銀行対応、月次数字管理 |\n| **拡大期** | 創業3〜5年 / 年商1〜3億円 | 追加資金調達、創業融資後の次の資金、補助金活用 |\n| **成長期** | 年商3〜10億円 | 利益率低下、運転資金、銀行格付け、予実管理 |\n| **戦略期** | 承継・M&A・大型投資 | 設備投資、M&A、事業承継、5年スパンの財務戦略 |\n\n---\n\n## ■ 横山さんの紹介軸整理\n\n### 1. 「補助金の人」ではなく「資金調達の伴走者」\n\n単発の補助金申請代行ではなく、年4回のMTG・決算後振り返り・事業計画を含む財務顧問。紹介時は、補助金だけでなく、銀行融資・資金繰り・財務戦略まで含めて伝えた方がよさそう。\n\n**紹介文に使う表現:**  \n「補助金だけでなく、銀行融資や事業計画まで含めて、資金調達を中長期で見てくれる財務顧問です。」\n\n### 2. 元銀行員 × 税理士の二視点\n\n銀行側の融資判断と、税務・決算側の整え方を同時に見られるのが強み。経営者が、銀行と税理士に別々に相談している状態を一つにまとめる価値がある。\n\n**紹介文に使う表現:**  \n「銀行がどう見るか、税理士がどう守るか、その両方から決算書と事業計画を見てくれる方です。」\n\n### 3. 1年以内に資金調達を考えている会社\n\n対応履歴では、竹内さんへのメモとして **「1年以内に資金調達を検討している中小企業様」** が明確に出ている。121では、これを具体化する。\n\n確認したい条件:\n\n- 金額規模: いくら以上なら相談価値が高いか。\n- 業種: 製造業以外に、建設業、医療、店舗、IT、士業、ECなども対象か。\n- 資金用途: 設備投資、運転資金、採用、新規事業、M&A、事業承継のどれが得意か。\n- タイミング: すでに銀行に相談済みでもよいか。決算前・決算後どちらがよいか。\n- 紹介時に必要な情報: 決算書、資金使途、借入状況、補助金希望など。\n\n### 4. 製造業との相性\n\nアンケートで「製造業関連のビジネスモデルをお持ちの方」と書いているため、製造業の設備投資・補助金・融資・月次管理が主な紹介導線になりそう。\n\n紹介候補の例:\n\n- 設備投資を考えている製造業社長。\n- 新工場・機械導入・省人化投資を検討している会社。\n- 補助金を使いたいが、自社に何が使えるか分からない会社。\n- 売上は伸びているが、資金繰りや銀行対応に不安がある会社。\n- 月次の数字管理や事業計画を整えたい会社。\n\n---\n\n## ■ 初回で聞くこと（チェックリスト）\n\n### 事業理解\n\n- ARATASの母体である税理士事務所との関係はどうなっているか。\n- 横山さん自身の役割は、営業・財務分析・銀行交渉・補助金支援のどこにあるか。\n- 月4万円〜の財務顧問では、具体的に何をどこまで行うか。\n- 年4回MTGの内容は、月次管理・決算振り返り・事業計画・銀行対応のどれが中心か。\n- 補助金と融資では、今どちらを主に紹介してほしいか。\n- 「元銀行員と税理士」のチーム体制は、紹介先にどう説明すると伝わりやすいか。\n\n### 紹介条件\n\n- 1年以内の資金調達とは、どのくらいの準備段階から相談してよいか。\n- 最も嬉しい紹介先は、年商・業種・資金用途でいうとどんな会社か。\n- 製造業以外で相性が良い業種はあるか。\n- 逆に、紹介されても支援しにくい会社はどんな状態か。\n- 紹介時に「決算書を見せる必要があります」と先に言うべきか。\n- 初回無料相談に進める場合、どんな流れになるか。\n\n### DragonFly / BNI\n\n- DragonFly の定例会で一番印象に残ったことは何か。\n- 「リファーラル件数が多い」と感じた背景は何か。\n- 紀川さん・竹内さん・海沼さんと名刺交換したい理由は何か。\n- オリエン希望は「無」だが、新メンバー同席OKとのこと。どの程度まで話を聞きたい状態か。\n- 複数チャプターを見学中とのことだが、今どこまで意思決定が進んでいるか。\n- 入会先を決める基準は、地域、カテゴリー、紹介先、雰囲気、既存メンバーとの相性のどれか。\n- DragonFlyに入った場合、最初の3ヶ月でどんな成果を作りたいか。\n\n### 次廣との接点\n\n- 補助金・融資と、業務改善システム構築が接続する場面はあるか。\n- 製造業や建設業で、補助金を使ったDX・省人化・管理システム導入の相談はあるか。\n- IT導入補助金や類似補助金で、システム開発・業務改善が対象になるケースはどの程度あるか。\n- ARATASの顧問先で、Excel・紙・二重入力・月次報告に課題がある会社はあるか。\n- 次廣から紹介する場合、どんな状態の経営者を最優先に探せばよいか。\n- 横山さんから次廣を紹介するとしたら、どういう顧問先に話しやすいか。\n\n---\n\n## ■ tugilo / 次廣側の共有トーク\n\n> 私は、AI業務改善システム構築というカテゴリーで活動しています。  \n> ざっくり言うと、Excel・紙・LINE・口頭で回っている業務を整理して、会社専用の小さなWebシステムや管理画面にしていく仕事です。  \n> 特に、製造業・建設業・店舗・団体運営のように、現場では回っているけれど、社長や事務側が数字を追いにくい会社と相性があります。  \n> 横山さんの資金調達支援と直接つながるとしたら、IT導入補助金のような制度を使った業務改善、補助金を使った設備投資やDX、銀行向けに数字を見える化したい会社、月次管理を仕組み化したい会社かなと思っています。  \n> 今日は売り込みではなく、横山さんが見ている中小企業の財務課題と、私が見ている業務改善課題がどこで重なるかを教えていただけると嬉しいです。\n\n### 次廣を紹介してほしい相手\n\n- Excelや紙の管理が限界に近い中小企業経営者。\n- 製造業・建設業・施工業・店舗運営で、見積・受注・作業報告・請求・在庫・顧客管理が散らばっている会社。\n- 補助金や融資を使って、業務改善・省人化・管理システム化を検討している会社。\n- 社内にIT担当者はいないが、社長が「そろそろ仕組み化しないとまずい」と感じている会社。\n\n---\n\n## ■ 紹介仮説\n\n### 横山さんへ紹介できそうな人\n\n1. **製造業・設備投資系の経営者**\n   - 設備投資、工場拡張、省人化、機械導入、補助金、銀行融資のいずれかがある。\n   - 紹介文: 「1年以内に資金調達や設備投資を考えているなら、銀行目線と税理士目線の両方で事業計画を見てくれる方がいます。」\n\n2. **建設業・不動産・施工業の経営者**\n   - 運転資金、材料費高騰、職人採用、車両・機械購入、工事案件増加で資金繰り課題が出やすい。\n   - 紹介文: 「融資や補助金を単発で見るのではなく、決算書・事業計画・銀行対応をまとめて相談できる財務顧問です。」\n\n3. **売上は伸びているが、数字管理が弱い会社**\n   - 成長期で資金ショートが怖い、月次予実が弱い、銀行との付き合い方が分からない。\n   - 紹介文: 「会社が次の段階に進む前に、銀行からどう見えるかを一度整理してくれる方がいます。」\n\n### 横山さんから次廣へ紹介してもらえそうな人\n\n1. **補助金を使って業務改善・DXをしたい会社**\n   - 申請だけでなく、実際の業務改善・システム化の中身が必要な会社。\n\n2. **月次管理・予実管理を仕組みにしたい会社**\n   - 財務顧問で見えてきた課題を、現場の入力・集計・見える化まで落とす余地がある。\n\n3. **製造業・建設業の現場業務が紙/Excelに残っている会社**\n   - 現場の数字と財務の数字がつながらず、経営判断が遅れている会社。\n\n---\n\n## ■ 会話で注意すること\n\n- 入会勧誘を前面に出しすぎない。横山さんは「詳しく話を聞きたい」段階なので、まず事業理解と紹介価値を作る。\n- 「補助金が取れる人」と単純化しない。ARATASの強みは、銀行目線・税理士目線・事業計画・財務顧問の組み合わせ。\n- 決裁者・意思決定者の情報に少し矛盾がある。参加情報では決済権「有」、対応履歴では「決裁者が横浜のシナジーチャプターにいる」とあるため、自然に確認する。\n- HPはユーザー提供URLが404だったため、必要なら公開HP `aratasmvdc.co.jp` と同一か確認する。\n\n---\n\n## ■ お礼文案（会後）\n\n> 横山さん、本日は121のお時間をいただきありがとうございました。  \n> ARATASさんの財務顧問について、単なる補助金・融資支援ではなく、元銀行員の視点と税理士の視点を合わせて、決算書・事業計画・銀行対応を伴走されていることがよく分かりました。  \n> 特に「1年以内に資金調達を検討している中小企業」「設備投資や補助金活用を考えている製造業・建設業」という紹介軸は、私の周りでも意識して探してみます。  \n> 私のAI業務改善システム構築についても聞いていただきありがとうございました。補助金や資金調達の先に、実際の業務改善・数字の見える化が必要な会社があれば、壁打ちからでもお声がけください。  \n> 引き続きよろしくお願いいたします。\n\n---\n\n## ■ 実施後追記欄\n\n実施後サマリー・決定事項・アクションアイテム・実施後版お礼文案は、文書上部の **「実施後サマリー（2026-06-19）」** に反映済み。','2026-06-19 12:59:50','2026-06-23 08:10:53'),
(82,1,37,43,NULL,NULL,NULL,'manual','2026-05-14 17:00:00',NULL,NULL,'planned',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_tabuchi_kyohei_tabuchi_stone.md#第1回】\n\n### 【第1回】2026-05-14\n\n#### 基本情報\n\n- 日時：**2026-05-14（木）JST 17:00–TODO**（ユーザー申告。終了時刻は実施後に確定）\n- 実施方法：TODO\n- **Religo 1to1 レコード:** `one_to_ones.id` = **82**\n\n#### 話した内容（重要）\n\n- TODO: 実施後に追記。\n\n#### 決定・合意\n\n- TODO: 実施後に追記。\n\n#### 次アクション\n\n- TODO: 実施後に追記。\n\n---','2026-06-23 08:10:44','2026-06-24 15:48:12'),
(83,1,37,189,NULL,'89956912582',NULL,'manual','2026-07-01 15:00:00','2026-07-01 15:00:00',NULL,'planned',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_hirano_masakuni_biken_tecno.md#第1回】\n\n### 【第1回】2026-07-01\n\n#### 基本情報\n\n- **日時:** **2026-07-01（水）JST 15:00-16:00**\n- **リスケ経緯:** 先方都合により、当初予定 **2026-06-19（金）JST 13:00〜** から変更\n- **実施方法:** TODO\n- **紹介者:** 平岡さん\n- **Religo 1to1 レコード:** `one_to_ones.id` = **83**\n- **主題:** 美研テクノの防水・外部工事、環境部商材、理想紹介先、tugilo との接点確認\n\n#### 会後追記欄\n\n- TODO: 実施後に Zoom 要約 / 手元メモを反映する。\n\n---','2026-06-23 08:10:45','2026-06-24 15:48:12'),
(84,1,37,50,NULL,NULL,NULL,'manual','2026-06-22 10:00:00','2026-06-22 10:00:00','2026-06-22 11:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_iida_chiho_sui.md#第2回】\n\n### 【第2回】2026-06-22 総合鑑定（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-22（月）JST 10:00–11:00**\n- **実施方法:** Zoom\n- **種別:** **第2回**（総合鑑定。第1回は BNI 121）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **84**\n- **内容:** 総合鑑定（メインプレゼン前日・2026-06-23 DragonFly 初メインプレ前）\n- **料金:** 22,000円\n- **関連:** 第1回121（`one_to_ones.id` = **69**）で予約済み。同一相手との継続関係として本ファイルに記録。\n- **記録:** Zoom 文字起こし要約を校正反映（2026-06-22 11:27 JST）\n\n#### 事前準備（質問リスト）\n\n**日時:** 2026-06-22（月）10:00-11:00 JST（第2回・総合鑑定）  \n**目的:** 2026年後半の流れ、仕事・お金・家族・健康・人間関係について、今の自分に必要なことを整理する。メインプレゼンはリハーサル後で内容を変えないため、第2回鑑定の主題にはしない。質問への回答だけでなく、千帆さんに **見えたことも遠慮なく伝えてもらう**。\n\n### 千帆さんへの事前送付文案\n\n> 千帆さん、6/22（月）10時の鑑定、よろしくお願いします。  \n> 事前に、相談したいことを整理してお送りします。  \n>  \n> 以前お話しした通り、僕自身はもともと占いを強く信じるタイプではありません。  \n> ただ、千帆さんの121でのお話を聞いて、占いを「当てるもの」というより、今の状態や流れを整理して、判断の背中を押してもらうものとして受けてみたいと思いました。  \n>  \n> メインプレゼンは翌日にありますが、リハーサル後なので内容は変えない前提です。今回はそこよりも、2026年後半の流れ、仕事・お金・家族・健康・人との関わりについて、今の自分に必要なことを見てもらえたらうれしいです。  \n>  \n> もし鑑定前に知っておきたい私の情報や、事前に整理しておいた方がよいことがあれば教えてください。  \n> こちらでも相談したいことは簡単に整理しておきますが、当日は質問にないことでも、千帆さんに見えたこと・伝えた方がよさそうなことがあれば、遠慮なく教えてください。\n\n### 冒頭で伝える前提\n\n> 明日がDragonFlyで初めてのメインプレゼンです。  \n> ただ、リハーサル後なので、メインプレゼンの内容や気持ちの作り方は今回の相談の中心ではありません。  \n> 今日は、2026年後半の流れ、仕事・お金・家族・健康・人との関わりについて、今の自分に必要なことを聞きたいです。  \n> 質問は用意してきましたが、質問にないことでも、僕に必要なことが見えたらそのまま教えてください。\n\n### 最優先で聞くこと\n\n1. **2026年後半、僕にとって大きな転機になりそうな時期はありますか？**  \n   仕事・家庭・人間関係・体調など、どの領域で流れが変わりそうかも知りたい。\n\n2. **お金・売上の流れで、意識した方がよいことはありますか？**  \n   取りに行くべき仕事、無理に追わない方がよい仕事、価格やお金の受け取り方で気をつけること。\n\n3. **今後の仕事は、どの方向に力を入れると流れが良くなりますか？**  \n   業務改善、予約・LINE・顧客管理、BNI向け仕組み、AI活用のどこに軸を置くべきか。Religoは当面自分専用なので、事業として広げる前提では聞かない。\n\n4. **今の僕に、仕事上で見落としているリスクや詰まりはありますか？**  \n   頑張りすぎ、抱え込み、単価、時間の使い方、人との組み方など。\n\n### 家族・自分の状態\n\n5. **妻・娘たちとの向き合い方で、今の僕に必要なことはありますか？**  \n   仕事やBNIに力を入れる時期だからこそ、家庭で気をつけることを知りたい。\n\n6. **長女の受験期に、父親としてどう支えるのがよいですか？**  \n   口を出すべきこと、見守るべきこと、言葉にした方がよいこと。\n\n7. **健康面・身体の使い方で、気をつけることはありますか？**  \n   今の生活で負担が出ているところ、見落としている不調、整えた方がよい習慣があれば知りたい。\n\n8. **守護霊や見守ってくれている存在から、今の僕に必要なメッセージはありますか？**\n\n9. **今の僕が、手放した方がよい思い込みや癖はありますか？**\n\n### 人間関係・BNI\n\n10. **僕が組むと良い人のタイプ、組まない方がよい人のタイプはありますか？**\n\n11. **DragonFlyの中で、今後特に大事にした方がよいご縁は誰ですか？**  \n   仕事・パワーチーム・学び・人としての成長の観点で、意識すべき人を知りたい。\n\n12. **逆に、距離感に気をつけた方がよい関係性はありますか？**  \n    悪い意味ではなく、力を使いすぎないための距離感を知りたい。\n\n13. **僕はBNIの中で、どんな役割を担うと流れが良くなりますか？**  \n    システムの人、場を整える人、話を整理する人、紹介をつなぐ人など。\n\n### 仕事・紹介の見せ方（時間があれば）\n\n14. **僕が一番紹介されやすくなる言葉は何ですか？**  \n   BNIメンバーが第三者に説明しやすい一言、避けた方がよい表現があれば知りたい。\n\n15. **今のBNIでのカテゴリーや見せ方は、中長期ではこのままでよいですか？**  \n   明日のメインプレゼンには反映しない前提で、「AI業務改善システム構築」で進むべきか、今後もっと伝わりやすい入口に変えた方がよいか。\n\n16. **僕の商品・サービスは、今の見せ方で価値が伝わっていますか？**  \n    価格・パッケージ・入口商品の作り方で見直すべき点があれば知りたい。\n\n17. **今後、法人向け・個人事業主向け・BNIメンバー向けのどこを優先すべきですか？**\n\n### 第2回鑑定後に整理すること\n\n- [ ] 2026年後半の転機・お金・健康・守護霊メッセージ\n- [ ] 家族との向き合い方\n- [ ] 仕事の優先順位\n- [ ] BNIカテゴリー・紹介文の見直しポイント\n- [ ] 第2回鑑定内容をAI要約する場合の共有可否\n\n#### 校正メモ（文字起こし）\n\n| 誤記（要約） | 正しい表記 | 備考 |\n|--------------|------------|------|\n| **松本氏**（BNI成功事例） | **増本 重孝** | 害虫ブロックFC・P-Link 文脈。DragonFly メンバー |\n| **コナカさん** | **小中 貴晃** | BeCheerz／AI研修。同チームで領域が重なる文脈 |\n| **出世静岡** | **守成クラブ静岡** | Zoom要約の誤変換 |\n\n#### 主要な成果\n\n家族を人生の軸に置きながらも、**ビジネス拡大・法人化・健康管理** の3領域において具体的な方向性が示された。BNI（DragonFly）入会3ヶ月の次廣氏に対し、**今後3年間のコミット** と **人前での発信強化** が最重要アクションとして合意された。\n\n#### 決定事項・合意内容\n\n| 論点 | 内容 |\n|------|------|\n| **BNI活動方針** | 最低 **3年間コミット** することが強く推奨され、本人もその意向あり |\n| **単独路線の維持** | コラボよりも **自分単体の強み・サービス構築** を深める方向が適切と判断 |\n| **法人化のタイミング** | **来年夏頃** が目安。現時点では個人事業主として十分に機能しており、焦る必要なし |\n| **奥様との連携** | 法人化の意思決定には奥様への丁寧な説明（節税・役員報酬メリット等）が前提条件 |\n| **営業スタイルの継続** | 「人の役に立ってからお金」というスタイルは変えず、数値目標を上乗せする形で拡張 |\n\n#### ビジネス戦略・成長方針\n\n##### 発信・登壇活動の強化\n\n- フォーラムや対面イベントでの **登壇を2回以上** 行うことが推奨\n- DragonFly 内の **シェアストーリー** 発表に積極的に手を挙げる姿勢が重要\n- **経営者向けオンラインセミナー** の開催が新たな集客チャネルとして提示\n- **「とにかく喋る機会を増やす」** ことが営業成績向上の直接的トリガーと指摘\n\n##### ターゲット顧客の明確化\n\n- **増本重孝**さんの成功事例（BNI実績）に類似した **業種拡大を目指す経営者** がターゲット\n- **フランチャイズ展開を検討している経営者** が具体的なターゲット層として言語化\n- **飲食店フランチャイズ** とは既に10年以上の取引実績あり、この領域での実績を発信材料にする\n- **会長クラスの経営者** およびその周辺人脈へのアプローチが売上拡大の鍵\n\n##### AI・最新技術の活用\n\n- **AIの使い方を教える講師・先生** としての柱が将来的に形成される可能性\n- 小中貴晃さんなど同チームメンバーと領域が重複するため、**差別化の言語化** が必要\n\n##### 収益目標\n\n- 現状の上限は約 **3,000万円** に自己設定されている可能性があり、それ以上を目指す野心の解放が課題\n- BNI活動を通じて **年収500〜600万円増** の見込みあり、既にその兆しを実感中\n- **3,000万円超の案件** を取りに行く意識を持つことが推奨\n\n#### 法人化について\n\n| 論点 | 内容 |\n|------|------|\n| **現状** | 個人事業主として運営中。売上規模的には法人化が税務上有利と税理士からも指摘済み |\n| **二の足を踏む理由** | 法人化のタイミングで脳梗塞や諸トラブルが重なった経験から慎重姿勢 |\n| **本質的な障壁** | 家族との時間を減らしたくないという価値観が、大型案件獲得への踏み出しを抑制 |\n| **打開策** | 奥様に「法人化＝節税・役員報酬で家族に還元できる手段」として分かりやすく説明することで合意が得やすくなる |\n| **推奨時期** | **来年夏頃**。吉日については別途鑑定で確認予定 |\n\n#### 健康管理\n\n| 論点 | 内容 |\n|------|------|\n| **既往歴** | 2年前に **脳梗塞** を経験。入院は約1週間で後遺症なし |\n| **現在の懸念** | 減塩は意識しているが、飲み会増加・暴飲暴食傾向を妻から指摘されている |\n| **再発リスク** | 高血圧由来の脳梗塞再発リスクは低いが、急激な暴飲暴食には注意が必要 |\n\n**推奨対策:**\n\n- 足つぼマッサージの定期実施\n- **足湯デトックス**（毒素排出）を体験すること。\n- 血液サラサラを意識した生活習慣の改善\n- 日々の **調味料の質**（料理酒・みりん等）を見直すことで体質改善\n- **発酵食品・麹** の摂取推奨\n\n#### 家族・プライベート（取り扱い注意）\n\n※紹介判断とは分けて、信頼関係の背景として記録する。第三者紹介文には使わない。\n\n##### 夫婦関係\n\n- 奥様は次廣氏を **圧倒的な信頼感** で見守っており、浮気等の懸念は一切なし\n- 夫婦関係が崩れるとすれば次廣氏の **言葉足らず** が原因になりうるため、飲み会前後の **こまめな連絡** が有効\n- **2〜3ヶ月に1回** の二人きりデートをする\n- 奥様に **事務作業（仕訳・税理士対応等）** を既に依頼しており、さらに業務を委譲していくことが推奨\n- 奥様の外出・友人との時間を増やすきっかけを作ることで、夫婦双方の充実度が向上する\n\n##### 長女・アンナちゃん（2011年6月23日生・中学3年生）\n\n- 吹奏楽部に所属。音楽の才能を伸ばすことが重要\n- 将来は **看護・福祉系（看護師）** の可能性が高く、幼少期にも本人が言及したことがある\n- **ダンス** と吹奏楽の2つを現在並行中\n- 高校時代に **留学** する映像が見えており、資金準備が必要\n- **英語力強化** が才能を伸ばす上で重要。英会話・語学学習への投資を推奨\n- 父親としての役割は **口出しせず送迎等のサポート** に徹すること。口出しは奥様の役割\n- 将来の結婚は **27歳前後** の見込み\n\n##### 次女・こなつちゃん（2014年8月4日生・小学6年生）\n\n- **クリエイター・発信系** の才能があり、TikTokerやライバーへの関心を持つ\n- 普通のレールには乗りたくないタイプ。**会社員を強制しない** 姿勢が重要\n- 一時的なギャル期を経て、専門学校・大学進学頃に落ち着く見込み\n- 親の役割は **温かく見守る** こと。帰る場所（部屋・ご飯）を確保するだけで十分\n- 学校では普通に振る舞っており、家庭内でのみ個性が強く出るタイプ\n\n#### 趣味・自己開放\n\n- 結婚を機に **ゴルフ等の個人趣味を意識的にすべて辞めた** 経緯があり、現在「趣味は家族」と答えている\n- 趣味の封印が **欲・モチベーションの低下** につながっており、これが **収益上限の心理的ブレーキ** になっている\n- **ゴルフ再開** が営業トリガーになる可能性（接待ゴルフ・BNIゴルフコンペ活用）\n- **ツーリング（バイク）** が潜在的にやりたいこととして浮上。客先とのツーリングも選択肢\n- **コーヒー巡り** を夫婦の共通趣味として育てることが推奨\n- **個性・面白さ** をもっと全開に出すことが、飲み会・ネットワーキングでの存在感向上につながる\n\n#### 神社参拝・スピリチュアルアドバイス\n\n| 神社 | 内容 |\n|------|------|\n| **新屋山神社**（富士吉田） | 4〜5年間継続参拝中で相性が良い。**金運神社**として著名 |\n| **大井神社**（島田） | **毎月参拝**に適したパワースポットとして推奨 |\n| **いわき神社**（地元） | パワーが弱いため、大井神社を優先 |\n\n**参拝方法:** 毎月 **1日**（理想は1日と15日）に **午前中** に参拝。二礼二拍手一礼の後、**名前・住所・夢・ビジョン・感謝** を声に出して宣言することで後押しが強まる。\n\n#### BNI活動方針\n\n- **WEBマスター** への立候補済み。**サポート代表** への昇格も視野に入れることが推奨\n- **守成クラブ静岡** への参加再開を宣言済みだが腰が重い状態。**司会・役割を担う** ことで仕事が循環する\n- **小中貴晃**さんとの相性が良く、**ティーアップし合う** 関係が理想（共同商品開発ではなく相互紹介）\n- **Givers Gain** の精神が体現されており、テイカーへのロールモデルになれる存在\n- **翌日のメインプレゼン** では、**数値**（人件費削減額等）を用いた具体的な成果訴求と、**夢・ビジョン** の言語化が重要\n\n#### 占い活用法の提案\n\n- 重要な意思決定（案件受諾・人事採用・方角・吉日確認等）には **スポット鑑定（電話1分300円）** が有効\n- 「この人と組んで大丈夫か」「この日に動くべきか」等の **リスクヘッジ** に活用できる\n- 法人化の **吉日** については別途鑑定予定\n\n#### アクションアイテム\n\n| 担当 | アクション | 状態 |\n|------|------------|------|\n| 次廣 | 足つぼマッサージ・足湯デトックス（チエさんのサロン・浜松）を体験する | [ ] |\n| 次廣 | **大井神社**（島田）に **7月中** に午前参拝を開始し、毎月1日の参拝ルーティンを確立する | [ ] |\n| 次廣 | **2026-06-23** メインプレゼンで数値実績・夢ビジョンを盛り込んだ発表を行う | [ ] |\n| 次廣 | **守成クラブ静岡** の例会に参加再開し、司会等の役割に立候補する | [ ] |\n| 次廣 | 奥様に法人化のメリット（節税・役員報酬・旅費経費化）を分かりやすく説明する | [ ] |\n| 次廣 | ゴルフ再開を検討し、BNIゴルフコンペへの参加を視野に入れる | [ ] |\n| 次廣 | アンナちゃんの英語学習・語学投資を検討する | [ ] |\n| 次廣 | 奥様が外出・友人と過ごす機会を作るきっかけを提供する（例：コーヒー豆の買い出し指令） | [ ] |\n| 次廣 | 飲み会前後のこまめな連絡を習慣化し、奥様の安心感を維持する | [ ] |\n| 次廣 | 日々の調味料・食生活の質を見直し、デトックス習慣を取り入れる | [ ] |\n| 次廣 | 法人化の吉日について別途スポット鑑定を依頼する（来年夏頃のタイミング） | [ ] |\n\n#### 次回セッション\n\n特定の日程は未設定。**人生の岐路や重要な意思決定のタイミング** で随時スポット鑑定・次回セッションを依頼する方針で合意。\n\n---','2026-06-23 22:52:57','2026-06-23 22:54:07'),
(85,1,37,149,NULL,'86553241846',NULL,'zoom','2026-06-24 13:00:00','2026-06-24 13:00:00','2026-06-24 14:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_kimura_anna_andirich.md#第2回】\n\n### 【第2回】2026-06-24（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-24（火）JST 13:00–14:00**\n- **実施方法:** Zoom（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **85**\n- **目的:** 第1回の続き。ゲンリツ／クライント案件の想い、Web化の本音、補助金チーム参画、協業の形を整理する。\n\n#### 校正メモ（Zoom要約）\n\n| 誤記・表記揺れ | 校正後の扱い |\n|----------------|--------------|\n| Anna / アンナ | **木村 杏那**（きむら あんな） |\n| ドラゴンフライ | **BNI DragonFly** |\n| ゲンリツ（第1回文脈） | 第2回の技術詳細は主に **運送会社クライアント** のスプレッドシート案件。パッケージ商品「ゲンリツ」との関係は要確認 |\n| 望月さん | 正式氏名・役割 TODO（次廣が来週121予定・IT導入補助金） |\n| 奥本さん | 正式氏名・役割 TODO（Google Workspace × AI 効率化。2回目121未設定） |\n| 松本さん | 正式氏名・役割 TODO（食事の場を設定予定） |\n\n#### 話した内容（重要）\n\n##### 1. 杏那さんの心理的整理・サービス方向性\n\n- 法人化しているが実態は **個人スキルの売り切り** に近く、大きな決断（初期投資・チーム組成）に踏み出せないパターンを繰り返してきた、という自己認識が共有された。\n- エンジニアと比べて自分のサービスが「しょぼい」と感じる瞬間があるが、次廣は **金額による差別化・ターゲット明確化・自分が選ばれる理由** を磨くことで揺らぎが減ると助言。\n- **BNIに特化してターゲットを絞る** ことで自信が安定し、競合比較から解放される、という整理を双方で確認。\n- 前回121後の迷いが言語化され、**表情・顔つきがすっきりした** 変化も相互に確認。\n\n##### 2. 補助金活用チームへの参画決断\n\n- 杏那さんは当初、「**補助金のためのサービスはやりたくない**」という気持ちがあった。\n- 一方で、チーム内で **最も信頼できるメンバー** と再度話し合い、**自分のビジョンや仕様を尊重してもらえる** ことを確認したうえで、**今回は参加してみる** と決断。\n- チャレンジが失敗しても **現行の業務改善サービスは継続** できるため、リスクは限定的と判断。\n- **Google Workspace** を使った既存サービスは、新しいシステム化と **並行して維持** する方針。\n- システム化費用は **300〜400万円規模** を想定。**IT導入補助金（最大3分の2補助）** の活用が有効と確認。\n- 補助金チームが提示した **エンジニア** とはまだ **2回しか話していない** ため、信頼性の最終判断は今後のコミュニケーション次第（要確認）。\n\n##### 3. 運送会社クライアントのスプレッドシート現状\n\n**構成（要約）**\n\n| 要素 | 内容 |\n|------|------|\n| タブ構成 | **31タブ**（1日1シート）＋統合シート＋指示書シート×4 |\n| 参照 | マスターシートからプルダウン参照 |\n| GAS | 並び替えボタンを実装 |\n\n**主な問題点**\n\n- 複数人が同時に **並び替えボタン** を押すとバグが発生。\n- **統合シート** が個別タブの追加・削除・日付変更に依存し、ヒューマンエラーで全体が崩壊するリスク。\n- IT非熟練の現場スタッフには **操作が複雑すぎる**。\n- 元請けがCSVシステムを導入したことで **CSVインポート機能** の追加が発生し、さらなる重量化が懸念。\n\n**次廣の見解**\n\n- **データベース化が最善策**。スプレッドシートは「システムに業務を合わせる」構造になり、本来の目的（楽にする）に反しやすい。\n- インプットとアウトプットが決まっているなら、中間処理は極力シンプルにすべき。\n\n**UI継続性**\n\n- 杏那さんは、Excel→スプレッドシート移行時も **ビューを変えなかった** 経緯があり、システム化でも **現在の見た目・操作感を維持** したいと強調。\n- 次廣は **UIは要望に応じて再現可能** と回答。\n\n**今後の進め方**\n\n- 社長は信頼関係があるが、「**またお金がかかる**」と思われないよう、メリットを **少しずつ伝えながら** 提案機会を見る。\n- Web化・システム化の際は **次廣に依頼したい** と杏那さんが明言。\n- 詳細ヒアリング・ **現場訪問** を双方で検討。\n\n##### 4. 失敗した既存システムの教訓（同クライアント周辺）\n\n- 知人に **70万円** で依頼したシステムは、機能的には要件を満たすが **UXが悪く現場で使われていない**。\n- ドライバーのシフト管理は結局 **紙に戻り**、手書き→手入力の **二重作業** が発生。\n- 根本原因: 初期ヒアリングで **「目的」ではなく「機能」** を中心に設計したため、現場の使いやすさが担保されなかった。\n- 次廣の原則: **「システム導入が目的にならない。現場がどこで困っているかを最初に聞くことが最重要。」**\n- UX改善・修正・再開発のいずれかは **未定**（要確認）。\n\n##### 5. BNI活動記録ツール（Religo）の共有\n\n- 次廣が開発中のツール。**Zoom文字起こし** を活用し、誰と何を話したか・次回話題・BOR相手などを記録。例会中に操作できるUI。\n- **リファラル提案機能:** ユーザーAの会話相手とユーザーBの履歴を照合し、「つなげると良い」提案を自動生成する構想。直接紹介ではなく **間接的リファーラル創出** を支援。\n- 現状は次廣の自分用だが、DragonFlyメンバーへの提供・ **サービス化** を検討中。\n- 杏那さんが高く評価。**BNI特化の共同サービス** として商品化できる可能性を次廣が提案。\n\n##### 6. フィードバック・相互評価\n\n- 杏那さんは次廣の **メインプレゼン** を「めっちゃよかった、重みが伝わる」と称賛。\n- 次廣はリハーサル重視、非技術者向けに **「何ができるか」より「人となり」** を伝えるアプローチが功を奏したと説明。\n- 次廣は杏那さんの **ヒアリング能力** とAIの組み合わせを高く評価。\n- 次廣は杏那さんの **スプレッドシート＋GAS** の作り込みを「技術者でもすごい」と称賛。\n- 次廣は「**杏那さんじゃなきゃ駄目なものが絶対ある**」と助言。他者比較ではなく、選ばれる理由を大切にする。\n\n##### 7. その他・関連メンバー\n\n- **奥本さん**（Google Workspace × AI 効率化）との121が未実施のまま。杏那さんが2回目をセッティングする。\n- 次廣は来週 **望月さん** とIT導入補助金について121予定。\n- **松本さん** を交えた食事の場を近日設定する意向。\n\n#### 未決・オープンクエスチョン\n\n- 31タブ構成の **軽量化限界** と、DB化・Web化の **具体設計** の進め方。\n- CSVインポート追加後の **重量増加** 対策。\n- 70万円システムの **扱い**（UX改善 / 修正 / 再開発）。\n- 杏那さん側エンジニアスタッフの **Claude Code 等による技術習得**（実践ベースで模索中）。\n- 補助金チームエンジニアの **信頼性** 最終判断。\n\n#### 決定事項・次アクション\n\n- [ ] **杏那さん:** 補助金チームの信頼できるメンバーに次廣を紹介し、システム開発相談を進める（近日中）。\n- [ ] **杏那さん:** 運送会社クライアントへシステム化メリットを少しずつ伝え、Web化提案の地ならし。\n- [ ] **杏那さん:** スプレッドシートの仕様書（要件定義の元データ）を書き出す。\n- [ ] **杏那さん:** 奥本さんとの2回目121をセッティング。\n- [ ] **次廣:** Religo（BNI活動記録ツール）開発継続、DragonFlyメンバー提供を検討。\n- [ ] **次廣:** 来週、望月さんとIT導入補助金について121。\n- [ ] **次廣 & 杏那さん:** 運送会社クライアントの詳細ヒアリング・現場訪問を検討。\n- [ ] **次廣 & 杏那さん:** 松本さんを交えた食事の場を設定。\n\n#### 次回121\n\n- 具体的日程は未確定。双方とも継続的な121を希望。杏那さんから「ちょこちょこワントゥーワンお願いします」と依頼あり。\n\n#### 実施前メモ（第2回・参考）\n\n<details>\n<summary>第2回実施前の準備メモ（2026-06-24）</summary>\n\n会前の目的: ゲンリツの想い、Web化本音、持ち物不安、協業形の整理。見積は急がない方針。\n\n第1回後の杏那さんメッセージ要点: 頼れるエンジニアとして嬉しい／前段階すみ分けOK／補助金きっかけでWeb化希望／持ち物不安／スプレッドシート限界も感じる。\n\n</details>\n\n---','2026-06-23 14:18:01','2026-06-24 15:50:37'),
(86,1,37,22,NULL,'81875844027',NULL,'zoom','2026-06-24 14:00:00','2026-06-24 14:00:00','2026-06-24 15:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_otake_erika_welfare.md#第1回】\n\n### 【第1回】2026-06-24（実施済み）\n\n#### 基本情報\n\n- **日時:** **2026-06-24（水）JST 14:00–15:00**\n- **実施方法:** Zoom（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **86**\n- **目的:** 初回の相互理解。絵理香さんの事業（ネイル＋福利厚生）の理解と、BNI活動の課題（リファラル・121申し込み）への実践アドバイス。\n\n#### 校正メモ（Zoom要約）\n\n| 誤記・表記揺れ | 校正後の扱い |\n|----------------|--------------|\n| えりか / エリカ | **大竹 絵理香**（おおたけ えりか） |\n| 次廣 / 次広 | **次廣（淳）** = tugilo・本人 |\n| ワンツーワン | **121**（1to1） |\n| ドラトーク | DragonFly内のトークルーム（チャプター連絡） |\n| 松倉さん | 正式氏名・役割 TODO（既存メンバー。絵理香さんが121申し込み予定） |\n| 平山ゆみさん | 正式氏名・役割 TODO（一度退会。1年経過後に再加入予定） |\n| コナカさん | 正式氏名・役割 TODO（「5年後・10年後が不安」と発言。福利厚生ターゲット候補） |\n| 増本さん | 正式氏名・役割 TODO（積極的な121スタイルの参考例） |\n| 知人（27歳男性） | スバル出身のSE経験者→転職コンサルタント。次廣との接続を検討 |\n\n#### 話した内容（重要）\n\n##### 1. 絵理香さんの事業と背景\n\n- **二本柱:** ネイル（労働収入）と福利厚生事業（権利収入）。最終目標は時間的・経済的自立。\n- **家族構成:** 夫・子ども2人の4人家族。一軒家の一室でネイルサロンを運営。\n- **ネイル歴:** 6〜7年目。独学・最低限の費用で検定を全取得し、サロン勤務 → 店長 → 昨年独立。\n- **独立の動機:** 経済的自立と子どもへの余裕ある支援。夫の収入に依存せず自分の判断で動ける環境を作りたい。\n- **2年後の目標:** 完全な経済的自立（次廣は「シングルマザーになれる状態」と表現）。\n\n##### 2. 福利厚生の会への加入経緯\n\n- **福利厚生の会**（事業ネットワーク）には2023年、兄の勧めで半強制的に加入。\n- 最初の2年はほぼ活動せず、今年1月から本格始動。\n- （**BNI DragonFly** への入会＝宣誓式は **2025-12-23**。福利厚生の会とは別の加入。）\n\n##### 3. 福利厚生事業の詳細\n\n- **仕組み:** 個人・中小企業向け福利厚生サービスを広めるネットワーク型事業。ガソリン割引など生活直結のサービスを含む。\n- **収入モデル:** 権利収入（手数料収入）。直接声をかけた人数が4〜6人でも、紹介の倍々拡大で月最大500万円に達した事例あり。\n- **上限設計:** 1人月500万円で打ち止め。「とんがり山」でなく「台形」型の収益分布を目指し、一人勝ちを防ぐ思想。\n- **理事長の理念:** 社会貢献・雇用創出を重視。ネットワークビジネスの悪いイメージを変えたい。\n- **平山ゆみさんとの連携予定:** 一度退会しており、1年経過後に再加入をお願いする予定。シングルマザー支援との親和性が高い。\n\n##### 4. BNI活動の課題と実践的アドバイス\n\n**リファラルの蓄積・分割発表（絵理香さんの新発見）**\n\n- リファラルは毎週その週のものを発表する必要はなく、**貯めて分割して発表できる**（今回初めて知った）。\n- 活用例：ビジター訪問時に12人が「つながりたい」と言ってくれた場合、9件分を数週に分けて発表することで毎週リファラルを出せる状態を作れる。\n- **ライブリファラル:** BNI会員の飲食店を利用した事実もリファラルとして申告可能。取引先へのお土産として利用した場合も有効。\n\n**ビジター招待戦略**\n\n- ビジターを呼ぶことが最もシンプルかつ効果的なリファラル創出手段。\n- 最低3人が「つながりたい」と言ってくれることが多く、3週に分ければ毎週1件以上のリファラルを確保できる。\n- 「最近こういうことをやっているんだけど、一緒に来ない？」という誘い方が有効（パワーチームワークショップで学んだ手法）。\n\n**121申し込みの心理的障壁**\n\n- 絵理香さんの課題：「忙しいのに申し込んでいいか」と考えすぎて行動できない。\n- 次廣のアドバイス：プレゼン後に「お疲れ様でした、ぜひ121しましょう」と言うだけで喜ばれる。断る人は断るので遠慮不要。\n- 増本さんの例：「これ俺のためになるの？」と平気で聞くスタイル。断られることを気にしない姿勢が参考になる。\n\n**トレーニング・ワークショップ**\n\n- 絵理香さんは必須トレーニングを1回受講済み。次廣は「年1回は繰り返し受けるべき」と推奨。\n- 絵理香さんはパワーチームワークショップ参加を検討すると表明。\n\n##### 5. 顧客管理の課題と提案（ネイル）\n\n- **現状:** お客様情報をすべて記憶で管理。カルテなし。「ふわっと匂わせて」前回情報を引き出す方法。\n- **課題認識:** お客様が増えると記憶が追いつかない。既存の月額システム（「システムカルテくん」等）は規模的にオーバースペックと感じている。\n- **次廣の提案:** まずメモ帳など紙媒体から始めれば十分。前職サロンの紙カルテは「邪魔くさい」と感じていた背景もある。\n- **次廣の視点:** 顧客情報を記録・記憶することは「私じゃなきゃダメ」という差別化につながる。お客様への本気度の表れ。\n\n##### 6. 次廣のシステムエンジニア事業（紹介）\n\n- **サービス内容:** 業務効率化・システム開発。特にExcelや手作業のコピペが多い企業（建設業・製造業など）の業務改善が得意領域。\n- **木村アンナさんとの差別化:** アンナさんはGoogleスプレッドシートを活用した低価格・簡易的な効率化が得意。次廣はそうした方法をやめたい企業向けの本格的なシステム提供が専門。\n- **収益モデル:** システム開発（一発納品）＋保守契約（継続収入）のセット。「蛇口から水が出るのと同様」にシステム稼働を維持するメンテナンスを継続提供。\n- **ターゲット規模:** 5〜10人以上の企業が理想だが、規模よりも「困っていること」を持つ人が対象。個人ネイリストの顧客管理相談にも対応可能。\n- **千葉さんのアドバイス:** 同業者との協業より一人でやる方が向いていると言われた。同業同士では遠慮が生まれ力を出し切れないパターンになりがち。\n- **福利厚生事業への参加見送り:** 仕組みを妻に説明できなかったため参加を断念。「妻が納得できないことはやらない」を判断基準にしている。\n\n##### 7. フィードバック・相互評価\n\n- **次廣 → 絵理香さん:** 外見からは想像できないほど芯が強く、バスケ経験・成田育ちの背景から培われた意志の強さがある。BNIメンバーにまだ伝わっていない魅力がある。\n- **次廣 → 絵理香さん:** 121を自分から申し込まない姿勢はもったいない。プレゼン後に「ぜひ121しましょう」と声をかけるだけで喜ばれる。\n- **次廣 → 絵理香さん:** 松倉さんに怒られた件は、「注意してくださってありがとうございます」と先に伝えることで関係改善につながる。伝え方次第で褒めてもらえる関係にもなれる。\n- **絵理香さん → 次廣:** メインプレゼンや事業への取り組み姿勢を高く評価。「すごい」と繰り返し表現。\n- **絵理香さん（自己評価）:** リファラルを毎週その週のものを発表しなければならないと思い込んでおり、蓄積できることを今回初めて知った。\n\n##### 8. コナカさんへのリファラル機会\n\n- コナカさんが「5年後・10年後が不安」と発言していたことを次廣が言及。絵理香さんの福利厚生事業のターゲット像と一致する可能性がある。\n- 絵理香さんはコナカさんとまだ121をしていないため、次廣がつなぎを提案。\n\n#### 決定事項・次アクション\n\n- [ ] **絵理香さん:** 本日中に松倉さんへ121申し込みのメッセージを送る（「昨日は注意してくださってありがとうございます。いろいろ教わりたいので121をお願いします」）。\n- [ ] **絵理香さん:** 知人の27歳男性（SE経験・転職コンサルタント）に次廣との接続を打診し、OKならメッセンジャーグループで紹介する。\n- [ ] **絵理香さん:** 次回から自ら積極的に121を申し込む（プレゼン後など機会を捉えて）。\n- [ ] **絵理香さん:** ビジターを呼ぶことを意識し、ビジター経由のリファラル蓄積戦略を実践する。\n- [ ] **次廣:** ドラトークに絵理香さんとの121写真を投稿し、「芯のある人物」としてティーアップを行う。\n- [ ] **次廣:** 松倉さんに対して絵理香さんの魅力・芯の強さを事前に伝える（ティーアップ）。\n\n#### 確認待ち\n\n- Religo `one_to_ones.id`（DB登録後に追記）。\n- 知人（27歳・スバル出身SE→転職コンサルタント）と次廣をつなぐか（絵理香さんが本人に確認）。\n- 平山ゆみさんの再加入タイミング（1年経過後）。\n- コナカさんへの121申し込み（未確定）。\n- （解消済み）「2023年加入」は福利厚生の会への加入。BNI入会＝2025/12/23 で別件。\n\n#### 次回121\n\n- 特定の日程は未設定。次廣は絵理香さんからの申し込みを歓迎する姿勢を示した。\n\n---','2026-06-23 14:18:01','2026-06-24 15:48:12'),
(87,1,37,51,NULL,'82163579920',NULL,'zoom','2026-06-25 13:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(88,1,37,169,NULL,'83016098515',NULL,'zoom','2026-06-26 09:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(89,1,37,44,NULL,'81192062572',NULL,'zoom','2026-06-26 10:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(90,1,37,191,NULL,'86089525244',NULL,'zoom','2026-06-26 17:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(91,1,37,135,NULL,'86575958347',NULL,'zoom','2026-07-01 13:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(92,1,37,28,NULL,'84487091838',NULL,'zoom','2026-07-02 14:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(93,1,37,31,NULL,'89263599516',NULL,'zoom','2026-07-02 15:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(94,1,37,190,NULL,'89000861916',NULL,'zoom','2026-07-02 16:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(95,1,37,30,NULL,'88169264613',NULL,'zoom','2026-07-17 18:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(96,1,37,20,NULL,'86488272462',NULL,'zoom','2026-07-23 18:00:00',NULL,NULL,'planned',NULL,NULL,NULL,NULL,'2026-06-23 14:18:01','2026-06-23 14:18:01'),
(97,1,37,46,NULL,NULL,NULL,'manual','2026-05-29 15:00:00','2026-05-29 15:00:00','2026-05-29 16:00:00','completed',NULL,NULL,NULL,'【ソース: docs/meetings/1to1/1to1_fujii_eriko_hiraten.md#第1回】\n\n### 【第1回】2026-05-29 実施済み\n\n#### 基本情報\n\n- **日時:** **2026-05-29（金）JST 15:00–16:00**（取得元: ユーザー確認 2026-05-30）\n- **実施方法:** **Zoom**（文字起こし要約ベース）\n- **Religo 1to1 レコード:** `one_to_ones.id` = **97**（**1セッション＝DB 1行**）\n\n#### ■ 概要\n\n- **参加者:** 次廣 淳、藤井 恵理子 様\n- **主な流れ:** 次廣の経歴・提供価値・事例・開発中システムの説明 → 藤井さんの HiraTen／播州織／海外展開の共有 → 相互リファーラル・個人的共通点（水泳・音楽・静岡）→ 次アクション合意\n\n#### ■ 主な成果\n\n- 次廣は静岡拠点のシステムエンジニア（**25年以上**）。現場に合わせた業務改善とAI活用が強み。DragonFly は **2024年3月入会**（増本氏・今西氏との縁）。\n- 今後は中小向けシステム開発とB2Cサービス展開を視野に、**BNIメンバー向け人脈管理システム（Religo）** を開発中であることを共有。\n- 藤井さんは **議事録管理・人物情報の保存** に課題を感じており、BO記録・1to1履歴・AIマッチング構想に **強い関心** を示した。\n\n#### ■ 決定事項・合意内容\n\n| 項目 | 内容 |\n|------|------|\n| **カテゴリー** | 現行「AI業務改善システム構築」。BNI活用の観点から**見直しを検討中**（時期は先） |\n| **小中氏との棲み分け** | tugilo＝**業務改善・システム化**、小中氏＝**AI教育・情報発信**（※要約の「小林氏」は文脈上 **小中氏** と解釈して記載） |\n| **キャッチフレーズ** | 藤井さん提案 **「あったらいいなを形にしてくれる」** を次廣の**6月メインプレゼン**で使用予定 |\n| **保守体制** | 売り切りではなく **伴走型・継続改良** の保守契約 |\n| **次回121** | 日程未定。次廣から積極的に打診 |\n| **対面イベント** | 次廣は1月大阪イベントは未参加。次回は参加意向 |\n\n#### ■ 次廣側の共有内容（要約）\n\n**強み・提供価値**\n\n- 文系出身（外国語学部・フランス語）。IT用語を **経営者・現場向けの言葉** に翻訳。営業経験あり。\n- 既存ツールに業務を合わせず、**現場ワークフローに合わせた設計**。小さく始め段階拡張。**属人化の解消**。\n- AIで自身の業務を効率化し、それがDragonFly入会の余力につながった。コロナ以降のオンライン化で**静岡から全国対応**。\n\n**主要事例**\n\n| 案件 | 課題 | 解決・成果 |\n|------|------|------------|\n| 増本氏 FC本部 | Googleフォーム＋スプレッドシートで約200社の受発注、集計負荷 | 入り口から整理し顧客・作業履歴を統合。**500店舗規模**へ人を増やさず拡張の土台。売上の一覧把握 |\n| 防水工事業者 | 外国人職人の紙日報、集計困難 | LINE日報→人件費・材料費・労働時間を自動集計。現場コストの可視化 |\n| 動物病院 | 予約管理 | LINEベース。獣医師3名から選択するカレンダー予約 |\n\n**開発中（BNI向け・Religo）**\n\n- **BO（ブレイクアウト）同室記録**、話した内容の記録\n- **1to1履歴**（文字起こし連携で自動保存）\n- **AIマッチング**（「この人に紹介できるのは誰か」）\n- **将来構想:** チャプター内で1to1情報を共有し、紹介の輪を広げる（藤井さんも共感）\n\n**理想的な紹介先（次廣が伝えた軸）**\n\n- ツール・Excelに管理が分散／Excel限界／同じ内容の二重入力\n- 相性: 税理士・会計士、業務改善コンサル、補助金コンサル、デザイナー（B2C UI）\n- 得意業種: **建設・製造**、ITに疎い中小経営者\n\n**確認待ち（次廣側）**\n\n- **6月メインプレゼン**準備中（平山氏メンター）\n- カテゴリー見直しはもう少し先\n- B2C（予約管理等）でリファーラルハードルを下げる検討\n\n#### ■ 藤井側の共有内容（要約）\n\n**HiraTen（ヒラテン）**\n\n- 播州織の**日傘・ストール・アパレル**の製造販売。\n- オーストラリア（2024）では傘よりストール・生地が好評。**パリ／カンヌ**出展の話が進行。BNIフランスと接続。\n- 百貨店は**2026年6月**から出店再開予定。メンズ日傘は6年前から製造、昨年から本格化。\n\n#### ■ アクションアイテム\n\n| 担当 | 内容 | 期限 |\n|------|------|------|\n| 次廣 | DragonFly **インスタ用情報**を入力 | **今週末まで** |\n| 次廣 | **関西方面**メンバーとの1to1を積極実施 | 5月以降継続 |\n| 次廣 | **バーチャルバーブル**参加を増やす | — |\n| 藤井 | シフト管理などで困っている**知人を次廣へ紹介** | 都度 |\n\n#### ■ 個人的背景・共通点\n\n**次廣:** 53歳。妻（10歳年下）、娘2人（中3・小6）。ペットはチンチラシルバー3匹＋保護猫1匹（要約表記「八割」・正式名は **TODO**）。36歳で結婚しアウトドア・キャンプを二人の趣味として開始。30歳独立、静岡拠点。\n\n**共通点:** 水球（次廣＝高校、藤井＝小中学生で約10年）。音楽（次廣＝大学バンド・学祭でユニコーン演奏、藤井＝ブルーハーツ・ユニコーン等パンク系）。藤井さんは富士山・静岡の朝日を好み、静岡に何度も訪問。\n\n**地域ネットワーク:** 今西氏とは約6年・自宅から車5分。BNI静岡は7年前入会、PTA会長と重なり3年不参加、**年会費のみ継続**。DragonFly静岡メンバーは一時5名→減少。\n\n---','2026-06-24 15:49:41','2026-06-24 15:49:50');
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
) ENGINE=InnoDB AUTO_INCREMENT=628 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(376,852,39,'2026-06-02 10:15:08','2026-06-02 10:15:08'),
(559,1005,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(560,985,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(561,1006,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(562,1008,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(563,1007,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(564,987,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(565,1009,46,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(566,1005,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(567,985,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(568,1006,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(569,1008,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(570,1007,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(571,987,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(572,1009,47,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(573,1005,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(574,985,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(575,1006,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(576,1008,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(577,1007,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(578,987,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(579,1009,48,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(580,1005,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(581,985,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(582,1006,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(583,1008,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(584,1007,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(585,987,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(586,1009,49,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(587,1005,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(588,985,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(589,1006,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(590,1008,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(591,1007,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(592,987,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(593,1009,50,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(594,1005,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(595,985,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(596,1006,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(597,1008,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(598,1007,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(599,987,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(600,1009,51,'2026-06-16 10:14:13','2026-06-16 10:14:13'),
(618,1055,52,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(619,1038,52,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(620,1061,52,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(621,1098,52,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(622,1086,52,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(623,1055,53,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(624,1038,53,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(625,1061,53,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(626,1098,53,'2026-06-23 08:08:42','2026-06-23 08:08:42'),
(627,1092,53,'2026-06-23 08:08:42','2026-06-23 08:08:42');
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
) ENGINE=InnoDB AUTO_INCREMENT=1099 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(664,11,149,'guest',13,2,'2026-05-18 22:56:51','2026-06-05 09:27:03'),
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
(862,13,162,'guest',13,5,'2026-06-02 08:49:44','2026-06-02 08:49:44'),
(863,14,1,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(864,14,2,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(865,14,3,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(866,14,8,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(867,14,4,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(868,14,5,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(869,14,6,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(870,14,9,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(871,14,10,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(872,14,11,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(873,14,12,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(874,14,13,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(875,14,14,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(876,14,15,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(877,14,17,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(878,14,18,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(879,14,135,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(880,14,149,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(881,14,19,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(882,14,20,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(883,14,21,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(884,14,22,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(885,14,23,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(886,14,24,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(887,14,25,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(888,14,26,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(889,14,27,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(890,14,28,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(891,14,30,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(892,14,31,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(893,14,32,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(894,14,34,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(895,14,35,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(896,14,36,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(897,14,37,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(898,14,136,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(899,14,39,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(900,14,40,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(901,14,29,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(902,14,41,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(903,14,42,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(904,14,43,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(905,14,44,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(906,14,46,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(907,14,47,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(908,14,48,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(909,14,49,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(910,14,50,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(911,14,51,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(912,14,53,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(913,14,165,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(914,14,54,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(915,14,65,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(916,14,78,'regular',NULL,NULL,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(917,14,166,'visitor',21,20,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(918,14,167,'visitor',17,6,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(919,14,168,'visitor',17,9,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(920,14,169,'guest',13,2,'2026-06-09 08:47:11','2026-06-09 08:47:11'),
(974,16,1,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(975,16,2,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(976,16,3,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(977,16,8,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(978,16,4,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(979,16,5,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(980,16,6,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(981,16,9,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(982,16,10,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(983,16,11,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(984,16,12,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(985,16,13,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(986,16,14,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(987,16,15,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(988,16,17,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(989,16,18,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(990,16,135,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(991,16,149,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(992,16,19,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(993,16,20,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(994,16,21,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(995,16,22,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(996,16,23,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(997,16,24,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(998,16,25,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(999,16,26,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1000,16,27,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1001,16,28,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1002,16,30,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1003,16,31,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1004,16,32,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1005,16,34,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1006,16,35,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1007,16,36,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1008,16,37,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1009,16,136,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1010,16,39,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1011,16,40,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1012,16,29,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1013,16,41,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1014,16,42,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1015,16,43,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1016,16,44,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1017,16,46,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1018,16,47,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1019,16,48,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1020,16,49,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1021,16,50,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1022,16,51,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1023,16,53,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1024,16,54,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1025,16,65,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1026,16,78,'regular',NULL,NULL,'2026-06-16 09:57:54','2026-06-16 09:57:54'),
(1027,18,1,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1028,18,2,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1029,18,3,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1030,18,8,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1031,18,4,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1032,18,5,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1033,18,6,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1034,18,9,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1035,18,10,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1036,18,11,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1037,18,12,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1038,18,13,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1039,18,14,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1040,18,15,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1041,18,17,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1042,18,18,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1043,18,135,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1044,18,149,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1045,18,19,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1046,18,20,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1047,18,21,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1048,18,22,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1049,18,23,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1050,18,24,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1051,18,25,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1052,18,26,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1053,18,27,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1054,18,28,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1055,18,30,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1056,18,31,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1057,18,32,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1058,18,34,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1059,18,35,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1060,18,36,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1061,18,37,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1062,18,136,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1063,18,39,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1064,18,40,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1065,18,29,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1066,18,41,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1067,18,42,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1068,18,43,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1069,18,44,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1070,18,46,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1071,18,47,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1072,18,48,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1073,18,49,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1074,18,50,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1075,18,51,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1076,18,53,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1077,18,165,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1078,18,54,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1079,18,65,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1080,18,78,'regular',NULL,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1081,18,171,'visitor',49,24,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1082,18,172,'visitor',49,49,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1083,18,173,'visitor',6,12,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1084,18,174,'visitor',149,1,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1085,18,175,'visitor',48,48,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1086,18,176,'visitor',37,30,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1087,18,177,'visitor',37,4,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1088,18,178,'visitor',37,18,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1089,18,179,'visitor',20,20,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1090,18,180,'visitor',34,34,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1091,18,181,'visitor',41,11,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1092,18,182,'visitor',49,25,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1093,18,183,'visitor',136,9,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1094,18,184,'proxy',165,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1095,18,185,'proxy',6,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1096,18,186,'guest',37,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1097,18,187,'guest',19,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04'),
(1098,18,188,'guest',19,NULL,'2026-06-23 08:04:04','2026-06-23 08:04:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES
(1,'App\\Models\\User',2,'religo-admin','fc4ea95195a45cca5d253758c75a777ab10a1eaea63435f2fb5a577fddc2e1a0','[\"*\"]','2026-06-07 12:34:49',NULL,'2026-05-28 22:27:00','2026-06-07 12:34:49'),
(2,'App\\Models\\User',2,'religo-admin','461a044d5c3c6fe7af4276d62bc24a78e2b3229a30d0a977b6d4dc06777225e9','[\"*\"]','2026-06-23 14:23:52',NULL,'2026-05-29 05:37:44','2026-06-23 14:23:52'),
(3,'App\\Models\\User',2,'religo-admin','5a013168a09435757d78cd53bebe302298b93c5dbecdee1a67b4956a9ed44b81','[\"*\"]','2026-06-02 17:06:02',NULL,'2026-05-31 10:39:42','2026-06-02 17:06:02'),
(4,'App\\Models\\User',2,'religo-admin','004bea0cf450f71345d60499007a1b3a2ab93131aacf27e98dcfe67e344ef4d7','[\"*\"]','2026-06-04 12:08:33',NULL,'2026-06-04 10:46:26','2026-06-04 12:08:33'),
(5,'App\\Models\\User',2,'religo-admin','a04df85751ca37c955412e0b49891ccb6232707516c57cfd78a50d649e9b866c','[\"*\"]','2026-06-04 12:40:26',NULL,'2026-06-04 10:46:55','2026-06-04 12:40:26'),
(6,'App\\Models\\User',2,'religo-admin','30fd7c4ed4e1d227707022ebc48db08506f09f134cfe4d4260a3b30f3e6ca4de','[\"*\"]','2026-06-24 15:54:46',NULL,'2026-06-04 13:57:00','2026-06-24 15:54:46'),
(7,'App\\Models\\User',2,'religo-admin','8d129c7bce11344718683a6f6f7e26debb88267dfcd480a8d341f48578aea330','[\"*\"]','2026-06-06 16:24:05',NULL,'2026-06-06 16:24:05','2026-06-06 16:24:05'),
(8,'App\\Models\\User',2,'religo-admin','e7707deb10c03a21e3e691a7b8609625acf2b8f457f608bcd7711b5f699a6668','[\"*\"]','2026-06-07 05:11:18',NULL,'2026-06-06 07:35:59','2026-06-07 05:11:18');
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
('0AZrrCiYDDzCCeAmWOcTGKT1ppDwDv5KfUfBIb72',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiclJINTVobGVRcnUxVDY3dm9lcHZCSVE2c2Q2cWFJajlPVm1jNGlVciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1782171699),
('6wGlIZmrpfvJyfU8F1VDziRxsjXOHMPcfoiafcf8',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmJsNThMS3dsYnhCeFd2NjNEZU1mNmJhUlV6S01rTFN4MThnVFJZQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1781841699),
('aXkgoHAlct26ulWsZDJCmz2VWXKIuXfb7CoBZ7oA',NULL,'192.168.65.1','curl/8.7.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTUhlR0ZqQXVHakZoNGZWNDBhRm1JdFNCSTBoaWNwQ0lDVmR3MmY3UyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MTY6Imh0dHA6Ly8xMjcuMC4wLjEiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1781694651),
('BZF4dhtgQ9MuFIdkjDj0SSZh7kYpaAGkuP2XARdB',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGtiNDAxOE9qWDlBWnlYZVRqVEJsdWtKdUR6SWRpckpGQkl2MW5hRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1782284086),
('kgwOSl8TP9ZqElpfLvRBFHYa27ihrV0agZMDWAiR',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMXRidW1PMlkzNDRsWkpvdXllV1d1czJGbWQxSEhEVk9jeWttUzNBdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1782276545),
('YR8XPJpfPBzfAHgzxBNL5bOUaBD7xv2PtgmYC5Ge',NULL,'172.28.0.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVmd0MlJja3dXeWNRR045YklDRVZocFVDTXdIYnNITjRMc0dQODBVciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1781572344),
('ZzSM5CFlL9HY4MQCPPsnK6SYM22FyWfmb2f8l5r7',NULL,'192.168.65.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiVFpRam9oR0NRSkZWaWRBNzZ4TUkyaXpjeUgwR1piOFVUZU8zTFpLeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHA6Ly9sb2NhbGhvc3QvYWRtaW4iO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1782226653);
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
(1,2,1,'openai','eyJpdiI6IlIxemFwMjV6aXdvRFFlYmJXaEh2U3c9PSIsInZhbHVlIjoiN3N6cm5hU2hNZWM0YXRreEgrV3hlSk43S2wzUDR5TG5nZm9tcnlSQ1lEd1ZhWlhqVXpOUm5GUm1OTGl3U1EydytUUDAwaVQyRWVVQmR0T045dnYya1ZxK0k5b2pxSytiTE13UFJFNmdMMFZYeTJYWUtRNDY5bjBWcmNNcjZxTlNUM2liQnNYWHQwSGNTek53eVdpRVA1L3ZTdW1NOFM5SU5jc1F5T1RZeENsM2daTHBwSjczc04xNk53cW1razc3SFJQb3BoTWl3VVlhWUFWM1U1c3pLTWc2Z1NKeVhOWjlaL2RiVzdTcmd6QT0iLCJtYWMiOiJhZmY3OTE2ZWZjYTE4YThiZWY0NTZiZDIwNTRiOTI1NTc0MDFmZTRiNWRkYjA0N2JjOTU1YTJmMmM5MGRhNDMwIiwidGFnIjoiIn0=',NULL,1,'2026-05-30 08:46:35','2026-06-04 22:41:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(11,'BNI SILVIS','bni_silvis',NULL,'2026-06-04 07:33:36','2026-06-04 07:33:36'),
(12,'BNI クリエーションズ','bni_creations',NULL,'2026-06-23 08:10:44','2026-06-23 08:10:44');
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
(1,2,'NHCBopvRQtCYXFKPsKfc-g','4AVorcStRP2KzYIRra6cpA','tugi@tugilo.com','eyJpdiI6Inl5M3Q2dThNZTRQYjJXT2lFQW9sNmc9PSIsInZhbHVlIjoiUXpBSGlpdlJqaEhrWFBoWDJWSDNRN29YS3RoN25HVXVpRGVaMUxQY3UwdXQ4Y01FbTY5TEI4TUdGeWJ4azhKTGIvNEIxRnFsYi9TRHRYS0lBYXViMTRPRmNHdmp0UXh1dnh3ZFg5SUxqK1IyLytVbUw5VkZaZmJFaEFRZjMwcktVM0RIWVUyYUxZSTVsUWRMVVROUElTZzVpSkxZbXArVngyMzd1SWQvRUZOakhTWSt2SGNzZXR5ZENkSkR3VmRia003Q3BCMUsvZlRYMmZEb3IxcEwyUXhtK0tmQWc0cTZsRXJQZHFCWUlqL3NpRFBwQkhLRUoxc3czMk1jdkNwL21ZUjhzRlo2NHluanJwMmxkMkNHL2ZNVnVrUkFtb3JTZ3YzbHVCUytNNTBGemZWZ2tnUDFQU2VyV2NKOHZSaXNNMnM3QnBZNlBSWStGajNGQ1ROdzZCWTdhS3FhL2Q3djgrUDFTRkpIM2Z6cWE1N2JIWVN0Y3VCUmtoY0ErWGsrYWhFQWxlNWtTcmJxNk0wRDZJYmZuL092R2Z0YmNpQ1kyQlpsZDc0QUppVzJ1L0k2cWtwWEVwRmhXYlRpVDJjSTk3VisydFVlaEowR2R5dzFVMjk3b29TMXFNcG43T0pYc3BpbDNGd2g4K3dSRWtXYjVwMmgzenRLNEFMM2ZJdFVhWDVQUm5RdytTVDhMeER0b2NBejl1QmxtQ3hhOUZCSDY1UUwvWkUvT2dwWGhydzdWaGxIcGRFa3hpb1Y1K2NDYWNjQUNGckNROWJReGt6Z3JiNm9SRTlkWTl2Z0VIajlpSUs4VExzM0R0aUJZaGZnWXEyeTV1bGQ5VnFwZlNBbkJOenIwTmxTK216Kzc0OHdkYnIyWkxLZC9Ub3RLSkRUZ0xxNEdpMGRjSlgzbFhJUHdPcmRGYnNjaHpSVDdxM0t4aE1ZM2orelo5cW1HOUErY3c3SFhnbEYyTTJqcEp4SU1McHdUTGdqaExBUDkvNHhKL1VjWUk0S2EySVRMVC9uRzMwalFSb2NNSGFvdDNJcDlsY0kzK1FYQVN3V21OTWVuM1VpNmExUFVBSXU1cXlkQkZ1bmQwc2sxcDN5VURCV25rWDB5RWtPWTh1OUs3MHUxdDlNZnc9PSIsIm1hYyI6IjBiYWZhZjM3Njk5YTA1ZWVjYzdjNmJiZWY4ZmNmMWJiNzczMjNjMGI2OTNmMTg3YmMxZjRhOWEwNmQ4Zjc1MWIiLCJ0YWciOiIifQ==','eyJpdiI6Ikl1VldPVlBNRmxYZXh0aFdOTys0N2c9PSIsInZhbHVlIjoiOU1GLy9UaTVZZiszSlZSTEZDTzRIejNIcWJMM2s4Z2ZZZkIxZ2VYdkZscVJWdzUrTGVZQlViM3NBVTF1M0pHTzdFeDlUSENSQUJ3bldIdzBpbXdvR1NCZG02OGYxYzNmWXFzdmZoWHZhOS9mdWs3RGp5VFo0UmkxUThMYlg1aXRyTVdBZ0x0SUd6MkVtNCtiWElablRLVysxZDBQL0lIVnZycERUeUhNaGw4WVR4cm8yQ25aTVk1ZjZKVjVBdWpHblpGS3lzQ2gydDAvdHZWTXhGcmJIc2JXUHZ4TVlaanlHL01uT1hxZk13eGNQc2VselY3bk9QU0wwengwbDYyK3lpbEgxUkxGdmFoU3pBcjhtdDJyR0xRUlFhdkhDZWhKck4xa2dwU0VqVGh5TWpiVUs5dTRNOXgvd2FiaVR3cjc1ZWZ0MkVscjAvR05OaXFFUGg2ZXhBaEhnUmxYeXplNDJlaTRyenVGZ29VQjQwdXc0QzlrYUMydU5xek5wVUFYUnBMdTRuTmh2VmczNTFsUG1kczgvVk11Lzh1ZEZZbUlydFh5NWt0RHJyMmUydXhjdVhnZFlVWGRKTjFPeXFKUXFTaEs2aEJlMWljcU50aUFEMnAwM0JQTm1LZnJ6SEtQUFMyck52cmpyOVN3NUZ4OU00OXVCVmNRTml4RzdMYlVhSHJmUEhvZzdhT2FpaTRIYTlWUk9YYXd5eFlWWVBhbmpFemRLMFNiN1A0MVd6OHlwcGFTdXUrdW1SZHhDL2E5R1FHVkJMY3hkbjZLUVZ1RDEremMxN2k4eVZuWEpKd1I1aDF4bGRIMUtYTWtvUWdHaEJSZnQxWHJIbXFlR2grRVJtN2cyOEFJcVlzZFg4dDdGOUtJOGIxbCtPN1NzUjQ4OG1LRmlObWtLWWM5b25BNFV3b0tqNkordUkyemI5R0Z2Q1FORUhUOW5EK1hRUTF6bVdXN3NqdG1ZTmRYSC80VnJNMEFSdU43YTQveFRjeHNpN05wbmFnbXdwV0RwTHROSnZaY05MOHBMUHVDNlFVYTVrK3M0TExvMGVSenlpbC9LTUhRNVlXRjArdGd0R3BkZWw1dmFSVmRpb3BFQm5xSElUT3o1ajFLSTJXWjBFbWVSMStpS1E9PSIsIm1hYyI6ImFmZDJlODQ5Yzk2NWZhN2MzZjEyM2EyODExY2NmNmJlZGRiOGI4ZWU3NmNhYjhjOGIzYmEyYmFhZTdjMDRhNmEiLCJ0YWciOiIifQ==','2026-06-24 00:13:35','user:read:user meeting:read:list_meetings meeting:read:summary meeting:read:past_meeting meeting:read:list_past_instances meeting:read:list_past_participants cloud_recording:read:list_recording_files','2026-05-30 01:06:32','2026-06-23 14:13:36');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(5,2,'2026-06-04 10:44:30','apply',1,1,2,'{\"import_ids\":[45,44,49,50],\"details\":[{\"import_id\":44,\"result\":\"imported\"},{\"import_id\":45,\"result\":\"held\"},{\"import_id\":49,\"result\":\"skipped\"},{\"import_id\":50,\"result\":\"skipped\"}]}','2026-06-04 01:44:30','2026-06-04 01:44:30'),
(6,2,'2026-06-23 23:14:54','apply',0,14,0,'{\"import_ids\":[67,66,64,63,62,61,60,59,58,57,56,55,54,51],\"details\":[{\"import_id\":51,\"result\":\"held\"},{\"import_id\":54,\"result\":\"held\"},{\"import_id\":55,\"result\":\"held\"},{\"import_id\":56,\"result\":\"held\"},{\"import_id\":57,\"result\":\"held\"},{\"import_id\":58,\"result\":\"held\"},{\"import_id\":59,\"result\":\"held\"},{\"import_id\":60,\"result\":\"held\"},{\"import_id\":61,\"result\":\"held\"},{\"import_id\":62,\"result\":\"held\"},{\"import_id\":63,\"result\":\"held\"},{\"import_id\":64,\"result\":\"held\"},{\"import_id\":66,\"result\":\"held\"},{\"import_id\":67,\"result\":\"held\"}]}','2026-06-23 14:14:54','2026-06-23 14:14:54'),
(7,2,'2026-06-23 23:18:01','apply',12,0,1,'{\"import_ids\":[67,66,64,63,62,61,60,59,58,57,56,54,51],\"details\":[{\"import_id\":51,\"result\":\"imported\"},{\"import_id\":54,\"result\":\"imported\"},{\"import_id\":56,\"result\":\"imported\"},{\"import_id\":57,\"result\":\"imported\"},{\"import_id\":58,\"result\":\"imported\"},{\"import_id\":59,\"result\":\"imported\"},{\"import_id\":60,\"result\":\"imported\"},{\"import_id\":61,\"result\":\"skipped\"},{\"import_id\":62,\"result\":\"imported\"},{\"import_id\":63,\"result\":\"imported\"},{\"import_id\":64,\"result\":\"imported\"},{\"import_id\":66,\"result\":\"imported\"},{\"import_id\":67,\"result\":\"imported\"}]}','2026-06-23 14:18:01','2026-06-23 14:18:01');
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
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(42,2,37,1,'85299085926',NULL,'scheduled','株式会社Andirich 木村杏那さん: 1to1調整用','2026-06-11 14:00:00',NULL,60,NULL,1,'medium',149,'matched','木村杏那',NULL,1,'imported',68,'{\"uuid\":\"79SMQbboStWlDku\\/1dZ2Ag==\",\"id\":85299085926,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eAndirich \\u6728\\u6751\\u674f\\u90a3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T13:06:19Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85299085926?pwd=GWD2NBUlONxJaQ4pueEujRHrgVm3b4.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(43,2,37,1,'82538110131',NULL,'scheduled','飯田千帆さん: 1to1調整用','2026-06-12 09:00:00',NULL,60,NULL,1,'medium',50,'matched','飯田千帆',NULL,1,'imported',69,'{\"uuid\":\"X7hpvFTiQL65x\\/cQDhqlcg==\",\"id\":82538110131,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u5343\\u5e06\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-12T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T04:02:12Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82538110131?pwd=5vBZNOQVq0PVNaURpaH7MgEBbDVD1T.1\"}','2026-06-04 01:41:40','2026-06-04 01:43:27'),
(44,2,37,1,'82306905507',NULL,'scheduled','株式会社u\'i 清原佳彩美さん: 1to1調整用','2026-06-12 10:00:00',NULL,60,NULL,1,'medium',48,'matched','清原佳彩美',NULL,1,'imported',70,'{\"uuid\":\"6bwZ7SwkQBaFe0Q4lmq1aQ==\",\"id\":82306905507,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eu\'i \\u6e05\\u539f\\u4f73\\u5f69\\u7f8e\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-12T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T08:19:01Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82306905507?pwd=cqrPA4vKEy90wTYjOh4t2SnaN2YuOz.1\"}','2026-06-04 01:41:40','2026-06-04 01:44:30'),
(45,2,37,1,'82063966389',NULL,'scheduled','熊谷龍笙さん: 1to1調整用','2026-06-17 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','熊谷龍笙',NULL,0,'held',NULL,'{\"uuid\":\"EoCycEd6TZqStx3VpF5jmA==\",\"id\":82063966389,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u718a\\u8c37\\u9f8d\\u7b19\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-17T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T23:39:52Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82063966389?pwd=pmrLZXu1NVyDmr0tagaz5BE6fdhqGw.1\"}','2026-06-04 01:41:40','2026-06-23 14:14:03'),
(46,2,37,1,'85054251043','RdBgZ2BpQF6nq437OGYGDA==','past','アンフィニ 福田航平さん: 1to1調整用','2026-06-04 09:00:00',NULL,60,NULL,1,'medium',139,'matched','福田航平',NULL,1,'imported',42,'{\"uuid\":\"RdBgZ2BpQF6nq437OGYGDA==\",\"id\":85054251043,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30a2\\u30f3\\u30d5\\u30a3\\u30cb \\u798f\\u7530\\u822a\\u5e73\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-04T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-21T22:45:22Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85054251043?pwd=ba1o9a2mhaw3a9H6ROtS1C4BeaHt3z.1\"}','2026-06-04 01:41:43','2026-06-04 01:43:27'),
(47,2,37,1,'89109217407','9Wcixbz/Tiyj6ubYB4XquA==','past','山本葉子さん: 1to1調整用','2026-06-03 15:00:00',NULL,60,NULL,1,'medium',27,'matched','山本葉子',NULL,1,'imported',41,'{\"uuid\":\"9Wcixbz\\/Tiyj6ubYB4XquA==\",\"id\":89109217407,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5c71\\u672c\\u8449\\u5b50\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-03T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-29T11:59:21Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89109217407?pwd=bDE5WtzsZjjMfJc2Nvoobf5qMRV2sx.1\"}','2026-06-04 01:41:44','2026-06-04 01:43:41'),
(48,2,37,1,'83714290448','i4hQDaQNQeCR0Rc2oz4Yqw==','past','株式会社ハーベスト 寺田直史さん: 1to1調整用','2026-06-01 17:00:00',NULL,60,NULL,1,'medium',140,'matched','寺田直史',NULL,1,'imported',40,'{\"uuid\":\"i4hQDaQNQeCR0Rc2oz4Yqw==\",\"id\":83714290448,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30cf\\u30fc\\u30d9\\u30b9\\u30c8 \\u5bfa\\u7530\\u76f4\\u53f2\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-28T07:49:41Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83714290448?pwd=D6hxZbvXx8cb4wOi4az1dqdMRWx02d.1\"}','2026-06-04 01:41:45','2026-06-04 01:43:27'),
(49,2,37,1,'86416812471','QjTZsT51Q/m770eDU1Ql0w==','past','株式会社pipon 小中貴晃さん: 1to1調整用','2026-06-01 15:00:00',NULL,60,NULL,1,'medium',34,'matched','小中貴晃',NULL,1,'imported',38,'{\"uuid\":\"QjTZsT51Q\\/m770eDU1Ql0w==\",\"id\":86416812471,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793epipon \\u5c0f\\u4e2d\\u8cb4\\u6643\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T04:36:44Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86416812471?pwd=mkiUsHGZLwkqcIjab9KYAAUUNNZmpO.1\"}','2026-06-04 01:41:47','2026-06-04 01:44:30'),
(50,2,37,1,'84716679422','itH7LYidQN2JvdnRcytlHw==','past','RUILED VISION JAPAN株式会社 原田里織さん: 1to1調整用','2026-06-01 14:00:00',NULL,60,NULL,1,'medium',18,'matched','原田里織',NULL,1,'imported',37,'{\"uuid\":\"itH7LYidQN2JvdnRcytlHw==\",\"id\":84716679422,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"RUILED VISION JAPAN\\u682a\\u5f0f\\u4f1a\\u793e \\u539f\\u7530\\u91cc\\u7e54\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-01T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-26T08:09:09Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84716679422?pwd=QHTRp3oMGIJGI7J5abG5aTPxj6kaZe.1\"}','2026-06-04 01:41:48','2026-06-04 01:44:30'),
(51,2,37,1,'86553241846',NULL,'scheduled','木村あんなさん121 次廣淳さん: 1to1調整用','2026-06-24 14:00:00',NULL,60,NULL,1,'medium',149,'matched','木村あんな',NULL,1,'imported',85,'{\"uuid\":\"VVNFc4l2Q4WKZefJC035hQ==\",\"id\":86553241846,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6728\\u6751\\u3042\\u3093\\u306a\\u3055\\u3093121 \\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-06-24T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-17T11:04:08Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86553241846?pwd=am4HnyOxahNto8MxPl9ohUaa10DjeE.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(52,2,37,1,'85339676510',NULL,'scheduled','次廣淳さん: 1to1調整用','2026-07-02 13:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'pending',NULL,'{\"uuid\":\"IJHIm\\/h+QESSqAWeEsquJQ==\",\"id\":85339676510,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-07-02T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T08:30:29Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85339676510?pwd=0scGBiep9rcbA8xxZQ4sAKg2QSPBf3.1\"}','2026-06-23 14:13:03','2026-06-23 14:14:03'),
(53,2,37,1,'81312937778',NULL,'scheduled','次廣淳さん: 1to1調整用','2026-07-02 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'pending',NULL,'{\"uuid\":\"Eq00QUDUTeiTZUg5eRYP3A==\",\"id\":81312937778,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-07-02T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T08:30:50Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81312937778?pwd=w1Jeo2X5zj2dcmpp4qRtgYGnNzYXmg.1\"}','2026-06-23 14:13:03','2026-06-23 14:14:03'),
(54,2,37,1,'81875844027',NULL,'scheduled','大竹絵理香さん: 1to1調整用','2026-06-24 14:00:00',NULL,60,NULL,1,'medium',22,'matched','大竹絵理香',NULL,1,'imported',86,'{\"uuid\":\"UQgEvyS0SXKzJGSak1Q0WA==\",\"id\":81875844027,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5927\\u7af9\\u7d75\\u7406\\u9999\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-24T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-17T10:38:01Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81875844027?pwd=RhQ3MukeCvB8U4boQaHO3QQw2rqWf6.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(55,2,37,1,'83653544858',NULL,'scheduled','みつなびアプリ開発打合せ','2026-06-25 10:00:00',NULL,60,NULL,0,'low',NULL,'unmatched',NULL,NULL,0,'held',NULL,'{\"uuid\":\"mRGB1i2\\/QnaXtM3lEG2NxQ==\",\"id\":83653544858,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u307f\\u3064\\u306a\\u3073\\u30a2\\u30d7\\u30ea\\u958b\\u767a\\u6253\\u5408\\u305b\",\"type\":2,\"start_time\":\"2026-06-25T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-19T04:24:34Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83653544858?pwd=y96hM3rckagcphNMZRWAuGLPhVH57F.1\"}','2026-06-23 14:13:03','2026-06-23 14:17:43'),
(56,2,37,1,'82163579920',NULL,'scheduled','飯田香さん: 1to1調整用','2026-06-25 13:00:00',NULL,60,NULL,1,'medium',51,'matched','飯田香',NULL,1,'imported',87,'{\"uuid\":\"Kwg7ueM6R2+G9WbedCSF6w==\",\"id\":82163579920,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u9999\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-25T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-17T05:58:55Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82163579920?pwd=4LyJOwQ5jAttgVqb5uactqcKhRmymY.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(57,2,37,1,'83016098515',NULL,'scheduled','株式会社ONODE 竹村さん: 1to1調整用','2026-06-26 09:00:00',NULL,60,NULL,1,'medium',169,'matched','竹村',NULL,1,'imported',88,'{\"uuid\":\"4NZt9bErTGuF4Jwrj\\/jh9A==\",\"id\":83016098515,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eONODE \\u7af9\\u6751\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-26T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-17T22:58:54Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83016098515?pwd=dsVbaaRZn8b8nmMKxHh53RfEpoxDDg.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(58,2,37,1,'81192062572',NULL,'scheduled','ハート・プランニング 木村　健悟さん: 1to1調整用','2026-06-26 10:00:00',NULL,60,NULL,1,'medium',44,'matched','健悟',NULL,1,'imported',89,'{\"uuid\":\"9MRajlTJSpeRBUmQbK3LMA==\",\"id\":81192062572,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30cf\\u30fc\\u30c8\\u30fb\\u30d7\\u30e9\\u30f3\\u30cb\\u30f3\\u30b0 \\u6728\\u6751\\u3000\\u5065\\u609f\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-26T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T08:43:12Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81192062572?pwd=sEFdx7SohBDvOep44U7Sj1aakt55zf.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(59,2,37,1,'86089525244',NULL,'scheduled','株式会社サイクス 門松 直幸さん: 1to1調整用','2026-06-26 17:00:00',NULL,60,NULL,1,'medium',191,'matched','直幸',NULL,1,'imported',90,'{\"uuid\":\"vWCcaTBER+u\\/Ha2mhp2Z3w==\",\"id\":86089525244,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30b5\\u30a4\\u30af\\u30b9 \\u9580\\u677e \\u76f4\\u5e78\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-26T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-17T00:18:57Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86089525244?pwd=JLbRoZwSj2aLgmQcKHMFaFgKITI01Q.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(60,2,37,1,'86575958347',NULL,'scheduled','4Stella合同会社 森園友喜さん: 1to1調整用','2026-07-01 13:00:00',NULL,60,NULL,1,'medium',135,'matched','森園友喜',NULL,1,'imported',91,'{\"uuid\":\"IQbysAGxQkG15RxEq9MUYw==\",\"id\":86575958347,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"4Stella\\u5408\\u540c\\u4f1a\\u793e \\u68ee\\u5712\\u53cb\\u559c\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-01T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T08:23:17Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86575958347?pwd=zD53arOZla0kHUNJbNKTohVV1TzPM0.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(61,2,37,1,'89956912582',NULL,'scheduled','有限会社テクノプロテクト 平野眞邦さん: 1to1調整用','2026-07-01 15:00:00',NULL,60,NULL,1,'medium',189,'matched','平野眞邦',NULL,1,'imported',83,'{\"uuid\":\"ZGMTy4AhRuCDU\\/tcFIPBXQ==\",\"id\":89956912582,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6709\\u9650\\u4f1a\\u793e\\u30c6\\u30af\\u30ce\\u30d7\\u30ed\\u30c6\\u30af\\u30c8 \\u5e73\\u91ce\\u771e\\u90a6\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-01T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-19T05:17:56Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89956912582?pwd=MgjwTD8F6EP40aUYKWueXaqy0uhZLE.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(62,2,37,1,'84487091838',NULL,'scheduled','ＳＤＧｕｓサポーターズ株式会社 梅澤　朗広さん: 1to1調整用','2026-07-02 14:00:00',NULL,60,NULL,1,'medium',28,'matched','朗広',NULL,1,'imported',92,'{\"uuid\":\"YTZcpFE6QCuD4m\\/7+axulQ==\",\"id\":84487091838,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\uff33\\uff24\\uff27\\uff55\\uff53\\u30b5\\u30dd\\u30fc\\u30bf\\u30fc\\u30ba\\u682a\\u5f0f\\u4f1a\\u793e \\u6885\\u6fa4\\u3000\\u6717\\u5e83\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-02T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T12:23:17Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84487091838?pwd=ky2F3iunpRBdrf8lWNAfeGnXpA9Ef3.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(63,2,37,1,'89263599516',NULL,'scheduled','合同会社moonlight 望月雅幸さん: 1to1調整用','2026-07-02 15:00:00',NULL,60,NULL,1,'medium',31,'matched','望月雅幸',NULL,1,'imported',93,'{\"uuid\":\"Wc42SfV+TrOQrYpuOHQQgw==\",\"id\":89263599516,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5408\\u540c\\u4f1a\\u793emoonlight \\u671b\\u6708\\u96c5\\u5e78\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-02T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T13:01:36Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89263599516?pwd=9p6kEVJtD98N0qbMyjTr5OD7WLS7af.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(64,2,37,1,'89000861916',NULL,'scheduled','合同会社LaughRally 西原海成さん: 1to1調整用','2026-07-02 16:00:00',NULL,60,NULL,1,'medium',190,'matched','西原海成',NULL,1,'imported',94,'{\"uuid\":\"3OnkKG2MSaeVs6haKPr4Tw==\",\"id\":89000861916,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5408\\u540c\\u4f1a\\u793eLaughRally \\u897f\\u539f\\u6d77\\u6210\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-02T07:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T13:52:43Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/89000861916?pwd=wUpwFKg2MvwArxPqZ2xaCLjW6fbU0a.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(65,2,37,1,'81094155396',NULL,'scheduled','舩杉牧子さん: 1to1調整用','2026-07-09 17:00:00',NULL,60,NULL,1,'medium',NULL,'new','舩杉牧子',NULL,0,'pending',NULL,'{\"uuid\":\"02z8V9UaTz+g6u4PyTme8Q==\",\"id\":81094155396,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u8229\\u6749\\u7267\\u5b50\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-09T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T10:35:52Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81094155396?pwd=vMaEFdORqUhtUx1nrL1IhQkPe6bgz3.1\"}','2026-06-23 14:13:03','2026-06-23 14:14:52'),
(66,2,37,1,'88169264613',NULL,'scheduled','ケイティ＆アソシエイツ 越賀淑恵さん: 1to1調整用','2026-07-17 18:00:00',NULL,60,NULL,1,'medium',30,'matched','越賀淑恵',NULL,1,'imported',95,'{\"uuid\":\"SFfYeA6NTSGisoZlNUUSMw==\",\"id\":88169264613,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u30b1\\u30a4\\u30c6\\u30a3\\uff06\\u30a2\\u30bd\\u30b7\\u30a8\\u30a4\\u30c4 \\u8d8a\\u8cc0\\u6dd1\\u6075\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-17T09:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-11T13:35:42Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88169264613?pwd=dWbNZiYtDa2d7hsbUQ96Xm7geBVb73.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(67,2,37,1,'86488272462',NULL,'scheduled','舩杉牧子さん: 1to1調整用','2026-07-23 18:00:00',NULL,60,NULL,1,'medium',20,'matched','舩杉牧子',NULL,1,'imported',96,'{\"uuid\":\"F2tUrITzQPa2pncUm3MrXA==\",\"id\":86488272462,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u8229\\u6749\\u7267\\u5b50\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-07-23T09:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-23T11:43:04Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86488272462?pwd=psAeqbgzpTn584S7lB5rvadqI59URW.1\"}','2026-06-23 14:13:03','2026-06-23 14:18:01'),
(68,2,37,1,'85312096768','DpQStDhSQPuPSwI/7ts2bw==','past','今井税理士事務所株式会社ARATAS 横山大樹さん: 1to1調整用','2026-06-19 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','横山大樹',NULL,0,'pending',NULL,'{\"uuid\":\"DpQStDhSQPuPSwI\\/7ts2bw==\",\"id\":85312096768,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u4eca\\u4e95\\u7a0e\\u7406\\u58eb\\u4e8b\\u52d9\\u6240\\u682a\\u5f0f\\u4f1a\\u793eARATAS \\u6a2a\\u5c71\\u5927\\u6a39\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-19T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-16T00:34:50Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85312096768?pwd=QFAcbqVsa3bifa7UyWoib88ebPkOON.1\"}','2026-06-23 14:13:05','2026-06-23 14:14:03'),
(69,2,37,1,'86261438582','a/3caT5fRjmCId6Mh4gOfw==','past','株式会社ユニバースプロダクツ 福士利明さん: 1to1調整用','2026-06-19 09:00:00',NULL,60,NULL,1,'medium',NULL,'new','福士利明',NULL,0,'pending',NULL,'{\"uuid\":\"a\\/3caT5fRjmCId6Mh4gOfw==\",\"id\":86261438582,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30e6\\u30cb\\u30d0\\u30fc\\u30b9\\u30d7\\u30ed\\u30c0\\u30af\\u30c4 \\u798f\\u58eb\\u5229\\u660e\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-19T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-16T00:07:17Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86261438582?pwd=TturSdYK0G2oNwWSaz3a8f3DUa7war.1\"}','2026-06-23 14:13:06','2026-06-23 14:14:03'),
(70,2,37,1,'82063966389','+xdqixPiSra+foCDfUzO4g==','past','熊谷龍笙さん: 1to1調整用','2026-06-17 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','熊谷龍笙',NULL,0,'pending',NULL,'{\"uuid\":\"+xdqixPiSra+foCDfUzO4g==\",\"id\":82063966389,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u718a\\u8c37\\u9f8d\\u7b19\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-17T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T23:39:52Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82063966389?pwd=pmrLZXu1NVyDmr0tagaz5BE6fdhqGw.1\"}','2026-06-23 14:13:07','2026-06-23 14:14:03'),
(71,2,37,1,'86156923122','qiBMAz2+R3qzBQXogYAfjg==','past','飯田香さん: 1to1調整用','2026-06-17 13:00:00',NULL,60,NULL,1,'medium',NULL,'new','飯田香',NULL,0,'pending',NULL,'{\"uuid\":\"qiBMAz2+R3qzBQXogYAfjg==\",\"id\":86156923122,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u9999\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-17T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-09T02:50:45Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86156923122?pwd=ehn9eeWbOh1vRSXqS42vvV4gCBytf3.1\"}','2026-06-23 14:13:08','2026-06-23 14:14:03'),
(72,2,37,1,'88180768716','GQgYzI2rReqQc6f9ioTP3A==','past','木村さん121','2026-06-15 11:00:00',NULL,60,NULL,1,'medium',NULL,'new','木村',NULL,0,'pending',NULL,'{\"uuid\":\"GQgYzI2rReqQc6f9ioTP3A==\",\"id\":88180768716,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6728\\u6751\\u3055\\u3093121\",\"type\":2,\"start_time\":\"2026-06-15T02:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-09T03:34:48Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88180768716?pwd=QMquiBPLa9z4nTOoEQ2kVGbrdWLWbR.1\"}','2026-06-23 14:13:09','2026-06-23 14:14:03'),
(73,2,37,1,'81938747696','fwlw/er8R+eYrVil7ck0GA==','past','西浦様打合せ','2026-06-14 20:00:00',NULL,60,NULL,1,'medium',NULL,'new','西浦',NULL,0,'pending',NULL,'{\"uuid\":\"fwlw\\/er8R+eYrVil7ck0GA==\",\"id\":81938747696,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u897f\\u6d66\\u69d8\\u6253\\u5408\\u305b\",\"type\":2,\"start_time\":\"2026-06-14T11:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-14T01:48:52Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/81938747696?pwd=RYeDDbKfuAA0DZdiZvsFP0bGqNYANb.1\"}','2026-06-23 14:13:10','2026-06-23 14:14:03'),
(74,2,37,1,'82306905507','53ufImGbQ1af/67ERtboaQ==','past','株式会社u\'i 清原佳彩美さん: 1to1調整用','2026-06-12 10:00:00',NULL,60,NULL,1,'medium',NULL,'new','清原佳彩美',NULL,0,'pending',NULL,'{\"uuid\":\"53ufImGbQ1af\\/67ERtboaQ==\",\"id\":82306905507,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eu\'i \\u6e05\\u539f\\u4f73\\u5f69\\u7f8e\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-12T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T08:19:01Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82306905507?pwd=cqrPA4vKEy90wTYjOh4t2SnaN2YuOz.1\"}','2026-06-23 14:13:11','2026-06-23 14:14:03'),
(75,2,37,1,'82538110131','hvT9ArZ+S2Wm94T/4L8pcw==','past','飯田千帆さん: 1to1調整用','2026-06-12 09:00:00',NULL,60,NULL,1,'medium',NULL,'new','飯田千帆',NULL,0,'pending',NULL,'{\"uuid\":\"hvT9ArZ+S2Wm94T\\/4L8pcw==\",\"id\":82538110131,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u98ef\\u7530\\u5343\\u5e06\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-12T00:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T04:02:12Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82538110131?pwd=5vBZNOQVq0PVNaURpaH7MgEBbDVD1T.1\"}','2026-06-23 14:13:12','2026-06-23 14:14:03'),
(76,2,37,1,'84922668048','teUQ464iTsugbrUW2V11jA==','past','株式会社オモロー 門脇優衣さん: 1to1調整用','2026-06-11 17:00:00',NULL,60,NULL,1,'medium',NULL,'new','門脇優衣',NULL,0,'pending',NULL,'{\"uuid\":\"teUQ464iTsugbrUW2V11jA==\",\"id\":84922668048,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793e\\u30aa\\u30e2\\u30ed\\u30fc \\u9580\\u8107\\u512a\\u8863\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T08:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-08T11:26:26Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/84922668048?pwd=f9x2gqX2BIk6G79WNnrNcOmxYJkboT.1\"}','2026-06-23 14:13:14','2026-06-23 14:14:03'),
(77,2,37,1,'82085598006','rloqHut/R/e3axAfYbIrzw==','past','次廣淳さん: 1to1調整用','2026-06-11 15:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'pending',NULL,'{\"uuid\":\"rloqHut\\/R\\/e3axAfYbIrzw==\",\"id\":82085598006,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-06-11T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-08T01:02:01Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/82085598006?pwd=U3E7yFZdLz4JqmZH3l15abW4k3xZjy.1\"}','2026-06-23 14:13:15','2026-06-23 14:14:03'),
(78,2,37,1,'85299085926','79SMQbboStWlDku/1dZ2Ag==','past','株式会社Andirich 木村杏那さん: 1to1調整用','2026-06-11 14:00:00',NULL,60,NULL,1,'medium',NULL,'new','木村杏那',NULL,0,'pending',NULL,'{\"uuid\":\"79SMQbboStWlDku\\/1dZ2Ag==\",\"id\":85299085926,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eAndirich \\u6728\\u6751\\u674f\\u90a3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T05:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-02T13:06:19Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85299085926?pwd=GWD2NBUlONxJaQ4pueEujRHrgVm3b4.1\"}','2026-06-23 14:13:17','2026-06-23 14:14:03'),
(79,2,37,1,'83358734181','6zfxuDE/Q9+7kbstM24bUQ==','past','次廣淳さん: 1to1調整用','2026-06-11 13:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'pending',NULL,'{\"uuid\":\"6zfxuDE\\/Q9+7kbstM24bUQ==\",\"id\":83358734181,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-06-11T04:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-08T01:01:54Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83358734181?pwd=pA1jlr9C7BaMaYLylG8mjCB2nvP0Nl.1\"}','2026-06-23 14:13:18','2026-06-23 14:14:03'),
(80,2,37,1,'83955465958','TAj+4gI+RfWIAR96gD5trA==','past','次廣淳さん: 1to1調整用','2026-06-11 12:00:00',NULL,60,NULL,1,'medium',NULL,'new','次廣淳',NULL,0,'pending',NULL,'{\"uuid\":\"TAj+4gI+RfWIAR96gD5trA==\",\"id\":83955465958,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u6b21\\u5ee3\\u6df3\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":8,\"start_time\":\"2026-06-11T03:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-08T01:02:11Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/83955465958?pwd=VpiozhhHHMRALj0FBktMY79FYABUwz.1\"}','2026-06-23 14:13:20','2026-06-23 14:14:03'),
(81,2,37,1,'86846787039','JR7UBSGxTeSJShgGcyJU/A==','past','株式会社J.NOVA 打田康平さん: 1to1調整用','2026-06-11 11:00:00',NULL,60,NULL,1,'medium',NULL,'new','打田康平',NULL,0,'pending',NULL,'{\"uuid\":\"JR7UBSGxTeSJShgGcyJU\\/A==\",\"id\":86846787039,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u682a\\u5f0f\\u4f1a\\u793eJ.NOVA \\u6253\\u7530\\u5eb7\\u5e73\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T02:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-03T08:43:50Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/86846787039?pwd=zosZOT4EBSsdLW7ffqmsSYnphQjbnn.1\"}','2026-06-23 14:13:22','2026-06-23 14:14:03'),
(82,2,37,1,'88571905941','9xzdcp5gQj6i4aZCdZTTRg==','past','吉田　匠真さん: 1to1調整用','2026-06-11 10:00:00',NULL,60,NULL,1,'medium',NULL,'new','匠真',NULL,0,'pending',NULL,'{\"uuid\":\"9xzdcp5gQj6i4aZCdZTTRg==\",\"id\":88571905941,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u5409\\u7530\\u3000\\u5320\\u771f\\u3055\\u3093: 1to1\\u8abf\\u6574\\u7528\",\"type\":2,\"start_time\":\"2026-06-11T01:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-05-30T00:25:51Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/88571905941?pwd=hKb7w2zzlj5hQRRX556X0HtpWYYbMz.1\"}','2026-06-23 14:13:23','2026-06-23 14:14:03'),
(83,2,37,1,'85842362927','CkjAZrjDSWigfCCfnQmjDQ==','past','西浦さん打合せ','2026-06-04 15:00:00',NULL,60,NULL,1,'medium',NULL,'new','西浦',NULL,0,'pending',NULL,'{\"uuid\":\"CkjAZrjDSWigfCCfnQmjDQ==\",\"id\":85842362927,\"host_id\":\"NHCBopvRQtCYXFKPsKfc-g\",\"topic\":\"\\u897f\\u6d66\\u3055\\u3093\\u6253\\u5408\\u305b\",\"type\":2,\"start_time\":\"2026-06-04T06:00:00Z\",\"duration\":60,\"timezone\":\"Asia\\/Tokyo\",\"created_at\":\"2026-06-03T14:08:54Z\",\"join_url\":\"https:\\/\\/us06web.zoom.us\\/j\\/85842362927?pwd=hK6VWE1KJSXtC1gU5gbznMHsezWxqe.1\"}','2026-06-23 14:13:25','2026-06-23 14:14:03');
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

-- Dump completed on 2026-06-24  7:32:58
