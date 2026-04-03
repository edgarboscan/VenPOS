CREATE DATABASE  IF NOT EXISTS `ven_pos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ven_pos`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: ven_pos
-- ------------------------------------------------------
-- Server version	8.0.45

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
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icono` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_icono` enum('icon','symbol') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'symbol',
  `padre_id` int DEFAULT NULL,
  `orden` int DEFAULT '0',
  `nivel` int DEFAULT '0',
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_padre` (`padre_id`),
  KEY `idx_activo` (`activo`),
  KEY `idx_orden` (`orden`),
  CONSTRAINT `menus_ibfk_1` FOREIGN KEY (`padre_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,'Home','/src/pages/home.php','home','symbol',NULL,1,0,1,'2026-02-12 14:46:32','2026-04-02 12:59:00'),(2,'Pos','/src/pages/ventas/pos.php','point_of_sale','symbol',NULL,2,0,1,'2026-03-30 22:01:24','2026-04-01 23:41:18'),(3,'Compras',NULL,'local_mall','symbol',NULL,3,0,1,'2026-03-30 22:05:53','2026-03-30 22:12:11'),(4,'Compras','/src/pages/compras/index.php','local_mall','symbol',3,1,1,1,'2026-03-30 22:07:14','2026-04-01 23:41:18'),(5,'Proveedores','/src/pages/compras/proveedores.php','diversity_3','symbol',3,2,1,1,'2026-03-30 22:12:11','2026-04-01 23:41:18'),(6,'CxP','/src/pages/compras/cxp.php','paid','symbol',3,3,1,1,'2026-03-30 22:12:11','2026-04-01 23:41:18'),(7,'Reportes','/src/pages/compras/reportes.php','receipt_long','symbol',3,4,1,1,'2026-03-30 22:12:11','2026-04-01 23:41:18'),(8,'Inventario',NULL,'inventory','symbol',NULL,4,0,1,'2026-03-31 01:26:57','2026-03-31 01:26:57'),(9,'Stock','/src/pages/Inventario/index.php','inventory_2','symbol',8,1,1,1,'2026-03-31 02:17:52','2026-04-01 23:40:11'),(10,'Productos','/src/pages/inventario/productos.php','stockpot','symbol',8,2,1,1,'2026-03-31 02:17:52','2026-04-01 23:40:11'),(11,'Ajuste','/src/pages/inventario/ajustes.php','box_add','symbol',8,3,1,1,'2026-03-31 02:17:52','2026-04-01 23:41:18'),(12,'Cargo/Descargo','/src/pages/intouts.php','box_add','symbol',8,4,1,1,'2026-03-31 02:17:52','2026-04-01 23:41:18');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-03 10:45:24
