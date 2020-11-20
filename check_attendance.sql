/*
 Navicat Premium Data Transfer

 Source Server         : Attendance DB
 Source Server Type    : MySQL
 Source Server Version : 100411
 Source Host           : localhost:3306
 Source Schema         : check_attendance

 Target Server Type    : MySQL
 Target Server Version : 100411
 File Encoding         : 65001

 Date: 30/03/2020 10:10:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `user_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`no`, `user_code`, `device_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (1, '1820010164', '971493546a8b21cb', 'Nevir Wizurai Sabilillah', 'Mobile Developer');

-- ----------------------------
-- Table structure for timestamp
-- ----------------------------
DROP TABLE IF EXISTS `timestamp`;
CREATE TABLE `timestamp`  (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `user_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `date` date NULL DEFAULT NULL,
  `check_in` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `check_out` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`no`, `user_code`, `device_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of timestamp
-- ----------------------------
INSERT INTO `timestamp` VALUES (3, '1820010164', '971493546a8b21cb', '2020-03-21', '08:12:00', '17:18:00');
INSERT INTO `timestamp` VALUES (4, '1820010164', '971493546a8b21cb', '2020-03-22', '07:56:00', '18:00:00');
INSERT INTO `timestamp` VALUES (5, '1820010164', '971493546a8b21cb', '2020-03-23', '08:12:00', '20:00:00');
INSERT INTO `timestamp` VALUES (6, '1820010164', '971493546a8b21cb', '2020-03-24', '07:45:00', '18:00:11');
INSERT INTO `timestamp` VALUES (7, '1820010164', '971493546a8b21cb', '2020-03-25', '08:23:00', '20:00:00');
INSERT INTO `timestamp` VALUES (8, '1820010164', '971493546a8b21cb', '2020-03-26', '07:33:00', '20:01:00');
INSERT INTO `timestamp` VALUES (15, '1820010164', '971493546a8b21cb', '2020-03-27', '14:40:26', '14:41:05');
INSERT INTO `timestamp` VALUES (16, '1820010164', '971493546a8b21cb', '2020-03-28', '15:35:36', '15:36:17');
INSERT INTO `timestamp` VALUES (17, '1820010164', '971493546a8b21cb', '2020-03-30', '09:46:54', '09:47:04');

SET FOREIGN_KEY_CHECKS = 1;
