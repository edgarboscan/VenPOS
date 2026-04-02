CREATE DATABASE  IF NOT EXISTS `ven_pos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ven_pos`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: ven_pos
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `productos_componentes`
--

DROP TABLE IF EXISTS `productos_componentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos_componentes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_compuesto_id` int NOT NULL COMMENT 'Producto compuesto (padre)',
  `producto_componente_id` int NOT NULL COMMENT 'Producto componente (simple)',
  `cantidad` decimal(12,4) NOT NULL DEFAULT '1.0000' COMMENT 'Cantidad del componente necesaria para una unidad del compuesto',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_compuesto_componente` (`producto_compuesto_id`,`producto_componente_id`),
  KEY `fk_compuesto_componente` (`producto_componente_id`),
  CONSTRAINT `fk_compuesto_hijo` FOREIGN KEY (`producto_componente_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_compuesto_padre` FOREIGN KEY (`producto_compuesto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos_componentes`
--

LOCK TABLES `productos_componentes` WRITE;
/*!40000 ALTER TABLE `productos_componentes` DISABLE KEYS */;
INSERT INTO `productos_componentes` VALUES (1,24,21,1.0000,'2026-03-31 17:41:58','2026-03-31 17:41:58'),(2,24,22,1.0000,'2026-03-31 17:41:58','2026-03-31 17:41:58'),(3,24,23,1.0000,'2026-03-31 17:41:58','2026-03-31 17:41:58');
/*!40000 ALTER TABLE `productos_componentes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-02 22:06:29
