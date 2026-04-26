-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 22. Mrz 2023 um 18:35
-- Server-Version: 10.4.27-MariaDB
-- PHP-Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `ism_demo`
--
CREATE DATABASE IF NOT EXISTS `ism_demo` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ism_demo`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE IF NOT EXISTS `customer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(45) DEFAULT NULL,
  `surname` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `customer`
--

INSERT INTO `customer` (`id`, `firstname`, `surname`, `email`) VALUES
(1, 'John', 'Richards', 'john.ri@mydomain.com'),
(2, 'Paul', 'Jagger', 'pja@guuglemail.com'),
(3, 'George', 'Watts', 'gw@company.com');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `iban`
--

DROP TABLE IF EXISTS `iban`;
CREATE TABLE IF NOT EXISTS `iban` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iban` varchar(30) NOT NULL,
  `customer` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_customer_id` (`customer`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `iban`
--

INSERT INTO `iban` (`id`, `iban`, `customer`) VALUES
(1, ' DE40 7532 0075 0348 6510 72', 1),
(2, ' DEE40753200750348651072', 2),
(3, 'DE54494501201000513885', 3),
(4, 'ATU02 2027 2083 0027 2542', 3),
(5, 'DE91100000000123456789', 2),
(6, 'DK9520000123456789', 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `order`
--

DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_date` datetime DEFAULT NULL,
  `customer_id` int(10) DEFAULT NULL,
  `status` enum('NEW','PROCESSING','DONE','CANCELD') NOT NULL DEFAULT 'NEW',
  PRIMARY KEY (`id`),
  KEY `FK_Customer_id` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `order`
--

INSERT INTO `order` (`id`, `order_date`, `customer_id`, `status`) VALUES
(1, '2023-03-02 18:23:11', 3, 'NEW'),
(2, '2023-03-16 18:23:11', 3, 'PROCESSING'),
(3, '2023-03-12 18:25:01', 1, 'DONE'),
(4, '2023-03-01 18:31:53', 2, 'DONE');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `order_position`
--

DROP TABLE IF EXISTS `order_position`;
CREATE TABLE IF NOT EXISTS `order_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_order_id` (`order_id`),
  KEY `FK_product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `order_position`
--

INSERT INTO `order_position` (`id`, `order_id`, `product_id`, `amount`) VALUES
(1, 1, 100, 1),
(2, 1, 103, 2),
(3, 3, 103, 3),
(4, 2, 100, 4),
(5, 4, 100, 1),
(6, 4, 103, 3),
(7, 4, 101, 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `ean` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Daten für Tabelle `product`
--

INSERT INTO `product` (`id`, `name`, `price`, `ean`) VALUES
(100, 'Grandmaster 1000', '999', '4654687231321'),
(101, 'Grandmaster 2000', '1420', '4654687231323'),
(103, 'Flashmaster Pro ', '1599', '4654687231325');

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `iban`
--
ALTER TABLE `iban`
  ADD CONSTRAINT `iban_ibfk_1` FOREIGN KEY (`customer`) REFERENCES `customer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints der Tabelle `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints der Tabelle `order_position`
--
ALTER TABLE `order_position`
  ADD CONSTRAINT `order_position_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `order_position_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;