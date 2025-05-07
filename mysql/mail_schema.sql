-- Проверка и выбор базы данных
CREATE DATABASE IF NOT EXISTS `php_mysql_db`;
USE `php_mysql_db`;

-- Таблица для хранения доменов
CREATE TABLE IF NOT EXISTS `virtual_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Таблица для хранения пользователей
CREATE TABLE IF NOT EXISTS `virtual_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(150) NOT NULL,
  `maildir` varchar(255) NOT NULL,
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `domain_id` (`domain_id`),
  CONSTRAINT `virtual_users_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `virtual_domains` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Таблица для хранения алиасов
CREATE TABLE IF NOT EXISTS `virtual_aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_id` int(11) NOT NULL,
  `source` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `domain_id` (`domain_id`),
  KEY `source` (`source`),
  CONSTRAINT `virtual_aliases_ibfk_1` FOREIGN KEY (`domain_id`) REFERENCES `virtual_domains` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Вставляем тестовый домен (только если таблица пуста)
INSERT IGNORE INTO `virtual_domains` (`id`, `name`) VALUES
(1, 'ramhlocal.com'),
(2, 'mail.ramhlocal.com');

-- Вставляем тестового пользователя (только если таблица пуста)
-- Пароль: test123
INSERT IGNORE INTO `virtual_users` (`id`, `domain_id`, `email`, `password`, `maildir`, `quota`) VALUES
(1, 1, 'user@ramhlocal.com', '$6$LDpTOLVTH$FkbcVkBP5NoqgM00GKSPYL28TvzOJaVE3STyUf4JWGLglg9B6bkJBRzYg2rUJX/wZ.IqRQvZ4ZC.PrO1YI2T21', 'ramhlocal.com/user/', 1073741824);

-- Вставляем тестовый алиас (только если таблица пуста)
INSERT IGNORE INTO `virtual_aliases` (`id`, `domain_id`, `source`, `destination`) VALUES
(1, 1, 'alias@ramhlocal.com', 'user@ramhlocal.com'); 