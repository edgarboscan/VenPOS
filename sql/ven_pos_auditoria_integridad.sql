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
-- Table structure for table `auditoria_integridad`
--

DROP TABLE IF EXISTS `auditoria_integridad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_integridad` (
  `id_auditoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tabla_origen` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_registro` bigint unsigned NOT NULL,
  `empresa_id` int DEFAULT NULL,
  `tipo_evento` enum('INSERT','UPDATE','DELETE','LOGIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_auditoria` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_tabla_fecha` (`tabla_origen`,`fecha_auditoria`),
  KEY `idx_auditoria_fecha` (`fecha_auditoria`),
  KEY `idx_auditoria_fecha_tabla` (`fecha_auditoria`,`tabla_origen`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_integridad`
--

LOCK TABLES `auditoria_integridad` WRITE;
/*!40000 ALTER TABLE `auditoria_integridad` DISABLE KEYS */;
INSERT INTO `auditoria_integridad` VALUES (56,'usuarios',4,NULL,'LOGIN','Inicio de Sesión exitoso fecha0','2026-03-30 19:00:47','root@localhost'),(57,'usuarios',4,NULL,'LOGIN','Inicio de Sesión exitoso fecha0','2026-03-30 19:00:56','root@localhost'),(58,'usuarios',4,NULL,'LOGIN','Inicio de Sesión exitoso.','2026-03-30 19:13:04','sistema'),(59,'compras',2,NULL,'UPDATE','Compra ID 2 - Factura FAC-002 | Estado: PENDIENTE -> PAGADO','2026-03-30 19:25:53','root@localhost'),(60,'productos',1,NULL,'UPDATE','Precio actualizado de 340.00 a 350.00','2026-03-30 19:25:53','cperez'),(61,'clientes',2,NULL,'INSERT','Nuevo cliente registrado: Inversiones López','2026-03-30 19:25:53','admin'),(62,'ventas',2,NULL,'INSERT','Venta a crédito por 350.00','2026-03-30 19:25:53','vendedor1'),(63,'productos',1,NULL,'UPDATE','Cambio de: Televisor 40\" Sony -> Televisor 40\" Sony','2026-03-30 19:31:50','root@localhost'),(64,'productos',2,NULL,'UPDATE','Cambio de: Zapatillas Nike Air Max -> Zapatillas Nike Air Max','2026-03-30 19:31:50','root@localhost'),(65,'productos',3,NULL,'UPDATE','Cambio de: Leche Condensada La Lechera -> Leche Condensada La Lechera','2026-03-30 19:31:50','root@localhost'),(66,'productos',4,NULL,'UPDATE','Cambio de: Smartphone Samsung Galaxy A14 -> Smartphone Samsung Galaxy A14','2026-03-30 19:31:50','root@localhost'),(67,'productos',5,NULL,'UPDATE','Cambio de: Camiseta Adidas Original -> Camiseta Adidas Original','2026-03-30 19:31:50','root@localhost'),(68,'productos',6,NULL,'UPDATE','Cambio de: Cereal Fitness -> Cereal Fitness','2026-03-30 19:31:50','root@localhost'),(69,'productos',7,NULL,'UPDATE','Cambio de: Lámpara LED Mesa -> Lámpara LED Mesa','2026-03-30 19:31:50','root@localhost'),(70,'productos',8,NULL,'UPDATE','Cambio de: Balón de Fútbol -> Balón de Fútbol','2026-03-30 19:31:50','root@localhost'),(71,'productos',9,NULL,'UPDATE','Cambio de: Audífonos Sony WH-1000 -> Audífonos Sony WH-1000','2026-03-30 19:31:50','root@localhost'),(72,'productos',10,NULL,'UPDATE','Cambio de: Mochila Nike -> Mochila Nike','2026-03-30 19:31:50','root@localhost'),(73,'productos',11,NULL,'UPDATE','Cambio de: Agua Mineral 1.5L -> Agua Mineral 1.5L','2026-03-30 19:31:50','root@localhost'),(74,'productos',12,NULL,'UPDATE','Cambio de: Set Ollas Hogar -> Set Ollas Hogar','2026-03-30 19:31:50','root@localhost'),(75,'productos',13,NULL,'UPDATE','Cambio de: Raqueta Tenis -> Raqueta Tenis','2026-03-30 19:31:50','root@localhost'),(76,'productos',14,NULL,'UPDATE','Cambio de: Tablet Samsung Tab A8 -> Tablet Samsung Tab A8','2026-03-30 19:31:50','root@localhost'),(77,'productos',15,NULL,'UPDATE','Cambio de: Pantalón Deportivo -> Pantalón Deportivo','2026-03-30 19:31:50','root@localhost'),(78,'productos',16,NULL,'UPDATE','Cambio de: Café Nescafé 200g -> Café Nescafé 200g','2026-03-30 19:31:50','root@localhost'),(79,'productos',17,NULL,'UPDATE','Cambio de: Ventilador de Torre -> Ventilador de Torre','2026-03-30 19:31:50','root@localhost'),(80,'productos',18,NULL,'UPDATE','Cambio de: Cuerda Saltar -> Cuerda Saltar','2026-03-30 19:31:50','root@localhost'),(81,'productos',19,NULL,'UPDATE','Cambio de: Monitor Samsung 27\" -> Monitor Samsung 27\"','2026-03-30 19:31:50','root@localhost'),(82,'productos',20,NULL,'UPDATE','Cambio de: Gorra Nike -> Gorra Nike','2026-03-30 19:31:50','root@localhost'),(83,'compras',2,NULL,'UPDATE','Compra ID 2 - Factura FAC-002 | Estado: PENDIENTE -> PAGADO','2026-03-30 19:38:40','root@localhost'),(84,'clientes',2,NULL,'UPDATE','Cliente: Inversiones López C.A. María López -> Inversiones López C.A. María López | Documento: J-98765432','2026-03-30 19:39:18','root@localhost'),(85,'clientes',4,NULL,'UPDATE','Cliente: John Smith -> John Smith | Documento: E-123456','2026-03-30 19:39:22','root@localhost'),(86,'clientes',1,NULL,'UPDATE','Cliente: Carlos Pérez -> Carlos Pérez | Documento: V-12345678','2026-03-30 19:39:25','root@localhost'),(87,'productos',1,NULL,'UPDATE','Precio actualizado de 340.00 a 350.00','2026-03-30 19:39:33','cperez'),(88,'clientes',2,NULL,'INSERT','Nuevo cliente registrado: Inversiones López','2026-03-30 19:39:33','admin'),(89,'ventas',2,NULL,'INSERT','Venta a crédito por 350.00','2026-03-30 19:39:33','vendedor1'),(90,'clientes',1,NULL,'UPDATE','Cliente: Carlos Pérez -> Carlos Pérez | Documento: V-12345678','2026-03-30 19:41:46','root@localhost'),(91,'clientes',2,NULL,'UPDATE','Cliente: Inversiones López C.A. María López -> Inversiones López C.A. María López | Documento: J-98765432','2026-03-30 19:41:46','root@localhost'),(92,'clientes',3,NULL,'UPDATE','Cliente: Ana González -> Ana González | Documento: V-87654321','2026-03-30 19:41:46','root@localhost'),(93,'clientes',4,NULL,'UPDATE','Cliente: John Smith -> John Smith | Documento: E-123456','2026-03-30 19:41:46','root@localhost'),(94,'clientes',5,NULL,'UPDATE','Cliente: Luisa Fernández -> Luisa Fernández | Documento: V-56789012','2026-03-30 19:41:46','root@localhost'),(95,'compras',2,NULL,'UPDATE','Compra ID 2 - Factura FAC-002 | Estado: PAGADO -> PENDIENTE','2026-03-30 19:41:46','root@localhost'),(96,'productos',21,1,'UPDATE','Cambio de: Destornillador Phillips -> Destornillador Phillips','2026-03-31 17:25:33','root@localhost'),(97,'productos',22,1,'UPDATE','Cambio de: Martillo -> Martillo','2026-03-31 17:25:33','root@localhost'),(98,'productos',23,1,'UPDATE','Cambio de: Llave ajustable -> Llave ajustable','2026-03-31 17:25:33','root@localhost'),(99,'productos',24,1,'UPDATE','Cambio de: Kit de Herramientas Básico -> Kit de Herramientas Básico','2026-03-31 17:25:33','root@localhost'),(100,'productos',21,1,'UPDATE','Cambio de: Destornillador Phillips -> Destornillador Phillips','2026-03-31 17:40:41','1'),(101,'productos',22,1,'UPDATE','Cambio de: Martillo -> Martillo','2026-03-31 17:40:41','1'),(102,'productos',23,1,'UPDATE','Cambio de: Llave ajustable -> Llave ajustable','2026-03-31 17:40:41','1'),(103,'productos',24,1,'UPDATE','Cambio de: Kit de Herramientas Básico -> Kit de Herramientas Básico','2026-03-31 17:40:41','1'),(104,'productos',1,NULL,'UPDATE','Cambio de: Televisor 40\" Sony -> Televisor 40\" Sony','2026-04-01 03:21:35','root@localhost'),(105,'productos',2,NULL,'UPDATE','Cambio de: Zapatillas Nike Air Max -> Zapatillas Nike Air Max','2026-04-01 03:21:35','root@localhost'),(106,'productos',3,NULL,'UPDATE','Cambio de: Leche Condensada La Lechera -> Leche Condensada La Lechera','2026-04-01 03:21:35','root@localhost'),(107,'productos',4,NULL,'UPDATE','Cambio de: Smartphone Samsung Galaxy A14 -> Smartphone Samsung Galaxy A14','2026-04-01 03:21:35','root@localhost'),(108,'productos',5,NULL,'UPDATE','Cambio de: Camiseta Adidas Original -> Camiseta Adidas Original','2026-04-01 03:21:35','root@localhost'),(109,'productos',1,NULL,'UPDATE','Cambio de: Televisor 40\" Sony -> Televisor 40\" Sony','2026-04-01 03:25:49','root@localhost'),(110,'productos',2,NULL,'UPDATE','Cambio de: Zapatillas Nike Air Max -> Zapatillas Nike Air Max','2026-04-01 03:25:49','root@localhost'),(111,'productos',3,NULL,'UPDATE','Cambio de: Leche Condensada La Lechera -> Leche Condensada La Lechera','2026-04-01 03:25:49','root@localhost'),(112,'productos',4,NULL,'UPDATE','Cambio de: Smartphone Samsung Galaxy A14 -> Smartphone Samsung Galaxy A14','2026-04-01 03:25:49','root@localhost'),(113,'productos',5,NULL,'UPDATE','Cambio de: Camiseta Adidas Original -> Camiseta Adidas Original','2026-04-01 03:25:49','root@localhost'),(114,'clientes',2,NULL,'UPDATE','Cliente: Inversiones López C.A. María López -> Inversiones López C.A. María López | Documento: J-98765432','2026-04-01 14:29:08','root@localhost');
/*!40000 ALTER TABLE `auditoria_integridad` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-02 15:11:14
