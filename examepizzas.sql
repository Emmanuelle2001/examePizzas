CREATE DATABASE  IF NOT EXISTS `examepizzas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `examepizzas`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: examepizzas
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Carmen Vargas','Calle Roble 45, Colonia Centro','555-2001'),(2,'Gustavo Herrera','Av. Reforma 789, Colonia Juárez','555-2002'),(3,'Fernanda Castillo','Calle Olivo 123, Las Palmas','555-2003'),(4,'Ernesto Molina','Paseo Central 456, Del Valle','555-2004'),(5,'Lorena Aguilar','Blvd. Tecnológico 890, La Florida','555-2005'),(6,'Sergio Contreras','Calle Pino 567, Lomas Verdes','555-2006'),(7,'Mónica Salazar','Av. Álamo 234, Bosques','555-2007'),(8,'Daniel Ríos','Calle Cedro 678, Lomas Altas','555-2008'),(9,'Teresa Núñez','Paseo Fresno 901, Real del Monte','555-2009'),(10,'Arturo Zamora','Blvd. Sauces 345, El Refugio','555-2010'),(11,'Rosa Jiménez','Calle Nogal 567, Vista Hermosa','555-2011'),(12,'Francisco León','Av. Olmo 789, Las Fuentes','555-2012'),(13,'Elena Pacheco','Calle Roble 234, San Pedro','555-2013'),(14,'Héctor Luna','Paseo Pino 678, Jardines','555-2014'),(15,'Claudia Esparza','Blvd. Fresno 890, Los Sauces','555-2015'),(16,'Raúl Montes','Calle Encino 456, Del Prado','555-2016'),(17,'Silvia Arias','Av. Sauce 123, Las Águilas','555-2017'),(18,'Jorge Palacios','Paseo Cedro 567, Lomas','555-2018'),(19,'Lucía Valdez','Calle Pino 789, Santa Fe','555-2019'),(20,'Óscar Medina','Blvd. Olivo 234, Las Misiones','555-2020'),(21,'Beatriz Cuevas','Calle Nogal 678, La Herradura','555-2021'),(22,'Alberto Peña','Av. Roble 345, El Dorado','555-2022'),(23,'Gabriela Solís','Paseo Fresno 456, Los Pinos','555-2023'),(24,'Fernando Guerrero','Calle Encino 789, Santa Mónica','555-2024'),(25,'Patricia Márquez','Blvd. Sauces 123, Lomas Verdes','555-2025'),(26,'Ricardo Cervantes','Av. Olmo 456, Real del Monte','555-2026'),(27,'Marcela Tovar','Calle Pino 567, El Mirador','555-2027'),(28,'Guillermo Rosas','Paseo Cedro 890, Jardines del Valle','555-2028'),(29,'Mónica Rangel','Calle Roble 234, San Ángel','555-2029'),(30,'Armando Fuentes','Blvd. Fresno 567, La Paz','555-2030');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedido` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_pedido` int NOT NULL,
  `id_pizza` int NOT NULL,
  `cantidad` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_pizza` (`id_pizza`),
  CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`id_pizza`) REFERENCES `pizzas` (`id_pizza`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
INSERT INTO `detalle_pedido` VALUES (1,1,3,2,100.00),(2,1,12,1,90.00),(3,1,19,1,130.00),(4,2,7,1,60.00),(5,2,15,2,220.00),(6,2,21,1,140.00),(7,3,2,3,150.00),(8,3,10,1,90.00),(9,3,24,1,150.00),(10,4,6,2,120.00),(11,4,13,1,100.00),(12,4,18,2,260.00),(13,5,4,1,50.00),(14,5,11,3,270.00),(15,5,22,1,140.00),(16,6,8,2,140.00),(17,6,14,2,200.00),(18,6,17,1,120.00),(19,7,1,4,160.00),(20,7,9,1,80.00),(21,7,20,1,140.00),(22,8,5,2,120.00),(23,8,16,1,110.00),(24,8,23,2,280.00),(25,9,3,2,100.00),(26,9,10,2,180.00),(27,9,19,1,130.00),(28,10,7,1,60.00),(29,10,12,3,270.00),(30,10,18,1,130.00),(31,11,2,1,50.00),(32,11,15,2,220.00),(33,11,21,2,280.00),(34,12,6,2,120.00),(35,12,13,1,100.00),(36,12,24,1,150.00),(37,13,4,3,150.00),(38,13,11,1,90.00),(39,13,17,2,240.00),(40,14,8,2,140.00),(41,14,14,1,100.00),(42,14,22,2,280.00),(43,15,1,3,120.00),(44,15,9,2,160.00),(45,15,20,1,140.00),(46,16,5,1,60.00),(47,16,16,2,220.00),(48,16,19,2,260.00),(49,17,3,2,100.00),(50,17,10,1,90.00),(51,17,23,1,140.00),(52,18,7,3,180.00),(53,18,12,1,90.00),(54,18,18,1,130.00),(55,19,2,2,100.00),(56,19,13,2,200.00),(57,19,21,1,140.00),(58,20,6,1,60.00),(59,20,15,2,220.00),(60,20,17,2,240.00),(61,21,4,2,100.00),(62,21,9,3,240.00),(63,21,24,1,150.00),(64,22,8,1,70.00),(65,22,11,2,180.00),(66,22,20,2,280.00),(67,23,1,2,80.00),(68,23,14,1,100.00),(69,23,22,2,280.00),(70,24,5,3,180.00),(71,24,16,1,110.00),(72,24,18,1,130.00),(73,25,3,2,100.00),(74,25,10,2,180.00),(75,25,23,1,140.00),(76,26,7,1,60.00),(77,26,12,3,270.00),(78,26,19,2,260.00),(79,27,2,2,100.00),(80,27,9,1,80.00),(81,27,21,2,280.00),(82,28,6,2,120.00),(83,28,15,2,220.00),(84,28,17,1,120.00),(85,29,4,3,150.00),(86,29,13,1,100.00),(87,29,24,1,150.00),(88,30,1,2,80.00),(89,30,11,2,180.00),(90,30,20,2,280.00);
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id_pedido` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int NOT NULL,
  `fecha` date NOT NULL,
  `total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_pedido`),
  KEY `id_cliente` (`id_cliente`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,1,'2025-01-08',320.00),(2,2,'2025-01-22',420.00),(3,3,'2025-02-14',390.00),(4,4,'2025-02-28',480.00),(5,5,'2025-03-07',460.00),(6,6,'2025-03-21',460.00),(7,7,'2025-04-11',380.00),(8,8,'2025-04-25',510.00),(9,9,'2025-05-09',410.00),(10,10,'2025-05-23',460.00),(11,11,'2025-06-13',550.00),(12,12,'2025-06-27',370.00),(13,13,'2025-07-04',480.00),(14,14,'2025-07-18',520.00),(15,15,'2025-08-08',420.00),(16,16,'2025-08-22',540.00),(17,17,'2025-09-05',330.00),(18,18,'2025-09-19',400.00),(19,19,'2025-10-10',440.00),(20,20,'2025-10-24',520.00),(21,21,'2025-11-07',490.00),(22,22,'2025-11-21',530.00),(23,23,'2025-12-05',460.00),(24,24,'2025-12-19',420.00),(25,25,'2026-01-09',420.00),(26,26,'2026-01-23',590.00),(27,27,'2026-02-13',460.00),(28,28,'2026-02-27',460.00),(29,29,'2026-03-06',400.00),(30,30,'2026-03-15',540.00);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pizzas`
--

DROP TABLE IF EXISTS `pizzas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pizzas` (
  `id_pizza` int NOT NULL AUTO_INCREMENT,
  `tamano` varchar(20) NOT NULL,
  `ingredientes` varchar(200) NOT NULL,
  `precio` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_pizza`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pizzas`
--

LOCK TABLES `pizzas` WRITE;
/*!40000 ALTER TABLE `pizzas` DISABLE KEYS */;
INSERT INTO `pizzas` VALUES (1,'chica','',40.00),(2,'chica','Jamón',50.00),(3,'chica','Piña',50.00),(4,'chica','Champiñones',50.00),(5,'chica','Jamón, Piña',60.00),(6,'chica','Jamón, Champiñones',60.00),(7,'chica','Piña, Champiñones',60.00),(8,'chica','Jamón, Piña, Champiñones',70.00),(9,'mediana','',80.00),(10,'mediana','Jamón',90.00),(11,'mediana','Piña',90.00),(12,'mediana','Champiñones',90.00),(13,'mediana','Jamón, Piña',100.00),(14,'mediana','Jamón, Champiñones',100.00),(15,'mediana','Piña, Champiñones',100.00),(16,'mediana','Jamón, Piña, Champiñones',110.00),(17,'grande','',120.00),(18,'grande','Jamón',130.00),(19,'grande','Piña',130.00),(20,'grande','Champiñones',130.00),(21,'grande','Jamón, Piña',140.00),(22,'grande','Jamón, Champiñones',140.00),(23,'grande','Piña, Champiñones',140.00),(24,'grande','Jamón, Piña, Champiñones',150.00);
/*!40000 ALTER TABLE `pizzas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-16 17:23:29
