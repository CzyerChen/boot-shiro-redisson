-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `USER_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `USERNAME` varchar(50) NOT NULL COMMENT '用户名',
  `PASSWORD` varchar(128) NOT NULL COMMENT '密码',
  `DEPT_ID` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `EMAIL` varchar(128) DEFAULT NULL COMMENT '邮箱',
  `MOBILE` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `STATUS` char(1) NOT NULL COMMENT '状态 0锁定 1有效',
  `CRATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `MODIFY_TIME` datetime DEFAULT NULL COMMENT '修改时间',
  `LAST_LOGIN_TIME` datetime DEFAULT NULL COMMENT '最近访问时间',
  `SSEX` char(1) DEFAULT NULL COMMENT '性别 0男 1女',
  `THEME` varchar(10) DEFAULT NULL COMMENT '主题',
  `AVATAR` varchar(100) DEFAULT NULL COMMENT '头像',
  `DESCRIPTION` varchar(100) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES ('4', 'bird', '42ee25d1e43e9f57119a00d0a39e5250', '5', 'mrbird@hotmail.com', '13455533222', '1', '2017-12-27 15:47:19', '2018-03-21 09:05:12', '2019-04-17 15:15:05', '0', 'indigo', 'default.jpg', '');
INSERT INTO `t_user` VALUES ('6', 'tester', '243e29429b340192700677d48c09d992', '6', 'tester@qq.com', '13888888888', '1', '2017-12-27 17:35:14', '2018-03-27 09:21:08', '2018-01-23 09:17:27', '1', 'teal', 'default.jpg', null);
INSERT INTO `t_user` VALUES ('23', 'test', 'ac3af72d9f95161a502fd326865c2f15', '6', 'scott@qq.com', '15134627380', '1', '2017-12-29 16:16:39', '2018-03-29 16:18:36', '2018-03-20 17:59:04', '0', 'blue-grey', 'default.jpg', '');
INSERT INTO `t_user` VALUES ('24', 'smith', '228208eafc74e48c44619cc543fc0efe', '3', 'smith@qq.com', '13364754932', '1', '2017-12-29 16:21:31', '2018-02-27 08:48:16', '2018-02-27 08:48:27', '1', 'teal', 'default.jpg', null);
INSERT INTO `t_user` VALUES ('25', 'allen', '83baac97928a113986054efacaeec1d2', '3', 'allen@qq.com', '13427374857', '0', '2017-12-29 16:21:54', '2018-01-17 11:28:16', null, '1', 'indigo', 'default.jpg', null);
INSERT INTO `t_user` VALUES ('26', 'martin', 'b26c9edca9a61016bca1f6fb042e679e', '4', 'martin@qq.com', '15562736678', '1', '2017-12-29 16:22:24', '2018-01-25 09:23:15', '2018-01-25 17:24:50', '1', 'teal', 'default.jpg', null);
INSERT INTO `t_user` VALUES ('27', 'ford', '0448f0dcfd856b0e831842072b532141', '6', 'ford@qq.com', '15599998373', '0', '2017-12-29 16:22:52', '2018-03-13 11:19:56', '2018-03-08 16:31:59', '0', 'cyan', 'default.jpg', null);
INSERT INTO `t_user` VALUES ('91', '系统监控员', '7c28d1cd33414ac15832f7be92668b7a', '6', 'xtjk@qq.com', '18088736652', '1', '2018-01-09 15:52:56', null, '2018-01-09 15:53:12', '0', 'cyan', 'default.jpg', null);
INSERT INTO `t_user` VALUES ('167', 'claire', '0d89ef778d56a302bcc5b222f540d38c', '1', 'clairelove.chen@gmail.com', '13711111111', '1', '2019-04-16 16:29:09', null, null, '2', 'green', 'default.jpg', null);



-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role` (
  `ROLE_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `ROLE_NAME` varchar(100) NOT NULL COMMENT '角色名称',
  `REMARK` varchar(100) DEFAULT NULL COMMENT '角色描述',
  `CREATE_TIME` datetime NOT NULL COMMENT '创建时间',
  `MODIFY_TIME` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`ROLE_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_role
-- ----------------------------
INSERT INTO `t_role` VALUES ('1', '管理员', '管理员', '2017-12-27 16:23:11', '2018-02-24 16:01:45');
INSERT INTO `t_role` VALUES ('2', '测试账号', '测试账号', '2017-12-27 16:25:09', '2018-01-23 09:11:11');
INSERT INTO `t_role` VALUES ('3', '注册账户', '注册账户，只可查看，不可操作', '2017-12-29 16:00:15', '2018-02-24 17:33:45');
INSERT INTO `t_role` VALUES ('23', '用户管理员', '负责用户的增删改操作', '2018-01-09 15:32:41', null);
INSERT INTO `t_role` VALUES ('24', '系统监控员', '可查看系统监控信息，但不可操作', '2018-01-09 15:52:01', '2018-03-07 19:05:33');
INSERT INTO `t_role` VALUES ('25', '用户查看', '查看用户，无相应操作权限', '2018-01-09 15:56:30', null);
INSERT INTO `t_role` VALUES ('63', '影院工作者', '可查看影视信息', '2018-02-06 08:48:28', '2018-03-07 19:05:26');
INSERT INTO `t_role` VALUES ('64', '天气预报员', '可查看天气预报信息', '2018-02-27 08:47:04', null);
INSERT INTO `t_role` VALUES ('65', '文章审核', '文章类', '2018-02-27 08:48:01', '2018-03-13 11:20:34');


-- ----------------------------
-- Table structure for t_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_user_role`;
CREATE TABLE `t_user_role` (
  `USER_ID` bigint(20) NOT NULL COMMENT '用户ID',
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_user_role
-- ----------------------------
INSERT INTO `t_user_role` VALUES ('27', '3');
INSERT INTO `t_user_role` VALUES ('24', '65');
INSERT INTO `t_user_role` VALUES ('26', '3');
INSERT INTO `t_user_role` VALUES ('26', '23');
INSERT INTO `t_user_role` VALUES ('26', '24');
INSERT INTO `t_user_role` VALUES ('25', '3');
INSERT INTO `t_user_role` VALUES ('91', '24');
INSERT INTO `t_user_role` VALUES ('4', '1');
INSERT INTO `t_user_role` VALUES ('6', '1');
INSERT INTO `t_user_role` VALUES ('6', '2');
INSERT INTO `t_user_role` VALUES ('6', '3');
INSERT INTO `t_user_role` VALUES ('6', '25');
INSERT INTO `t_user_role` VALUES ('6', '63');
INSERT INTO `t_user_role` VALUES ('23', '2');
INSERT INTO `t_user_role` VALUES ('23', '3');
INSERT INTO `t_user_role` VALUES ('23', '23');
INSERT INTO `t_user_role` VALUES ('23', '24');
INSERT INTO `t_user_role` VALUES ('23', '25');
INSERT INTO `t_user_role` VALUES ('167', '1');
INSERT INTO `t_user_role` VALUES ('167', '2');
INSERT INTO `t_user_role` VALUES ('167', '3');
INSERT INTO `t_user_role` VALUES ('167', '23');
INSERT INTO `t_user_role` VALUES ('167', '24');
INSERT INTO `t_user_role` VALUES ('167', '25');
INSERT INTO `t_user_role` VALUES ('167', '63');
INSERT INTO `t_user_role` VALUES ('167', '64');
INSERT INTO `t_user_role` VALUES ('167', '65');


-- ----------------------------
-- Table structure for t_permission
-- ----------------------------
DROP TABLE IF EXISTS `t_permission`;
CREATE TABLE `t_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permissionname` varchar(32) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_permission
-- ----------------------------
INSERT INTO `t_permission` VALUES ('1', 'add', '2');
INSERT INTO `t_permission` VALUES ('2', 'del', '1');
INSERT INTO `t_permission` VALUES ('3', 'update', '2');
INSERT INTO `t_permission` VALUES ('4', 'query', '3');
INSERT INTO `t_permission` VALUES ('5', 'user:query', '1');
INSERT INTO `t_permission` VALUES ('6', 'user:edit', '2');


-- ----------------------------
-- Table structure for t_dept
-- ----------------------------
DROP TABLE IF EXISTS `t_dept`;
CREATE TABLE `t_dept` (
  `DEPT_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门ID',
  `PARENT_ID` bigint(20) NOT NULL COMMENT '上级部门ID',
  `DEPT_NAME` varchar(100) NOT NULL COMMENT '部门名称',
  `ORDER_NUM` bigint(20) DEFAULT NULL COMMENT '排序',
  `CREATE_TIME` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`DEPT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of t_dept
-- ----------------------------
INSERT INTO `t_dept` VALUES ('1', '0', '开发部', null, '2018-01-04 15:42:26');
INSERT INTO `t_dept` VALUES ('2', '1', '开发一部', null, '2018-01-04 15:42:34');
INSERT INTO `t_dept` VALUES ('3', '1', '开发二部', null, '2018-01-04 15:42:29');
INSERT INTO `t_dept` VALUES ('4', '0', '市场部', null, '2018-01-04 15:42:36');
INSERT INTO `t_dept` VALUES ('5', '0', '人事部', null, '2018-01-04 15:42:32');
INSERT INTO `t_dept` VALUES ('6', '0', '测试部', null, '2018-01-04 15:42:38');
