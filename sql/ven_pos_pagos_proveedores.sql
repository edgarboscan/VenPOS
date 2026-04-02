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
-- Table structure for table `pagos_proveedores`
--

DROP TABLE IF EXISTS `pagos_proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos_proveedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `proveedor_id` int NOT NULL,
  `compra_id` int DEFAULT NULL COMMENT 'Opcional: si el pago es a una compra específica',
  `monto` decimal(12,2) NOT NULL,
  `fecha_pago` date NOT NULL,
  `forma_pago` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'EFECTIVO',
  `referencia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_pago_proveedor` (`proveedor_id`),
  KEY `fk_pago_compra` (`compra_id`),
  KEY `fk_pago_proveedor_empresa` (`empresa_id`),
  KEY `idx_pagos_proveedor_fecha` (`proveedor_id`,`fecha_pago`),
  CONSTRAINT `fk_pago_compra` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_pago_proveedor` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_pago_proveedor_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos_proveedores`
--

LOCK TABLES `pagos_proveedores` WRITE;
/*!40000 ALTER TABLE `pagos_proveedores` DISABLE KEYS */;
INSERT INTO `pagos_proveedores` VALUES (1,1,1,NULL,4500.00,'2026-02-25','TRANSFERENCIA',NULL,'2026-03-30 19:25:53'),(2,1,2,NULL,720.00,'2026-03-01','EFECTIVO',NULL,'2026-03-30 19:25:53'),(3,2,3,NULL,2500.00,'2026-03-10','CHEQUE',NULL,'2026-03-30 19:25:53'),(4,1,1,1,4500.00,'2026-02-25','TRANSFERENCIA',NULL,'2026-03-30 19:38:37'),(5,1,2,2,720.00,'2026-03-01','EFECTIVO',NULL,'2026-03-30 19:38:40'),(6,2,3,3,2500.00,'2026-03-10','CHEQUE',NULL,'2026-03-30 19:38:45'),(7,1,2,2,50.00,'2026-04-01','Pago Movil',NULL,'2026-04-01 14:30:54');
/*!40000 ALTER TABLE `pagos_proveedores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_pago_proveedor_after_insert` AFTER INSERT ON `pagos_proveedores` FOR EACH ROW BEGIN
    IF NEW.compra_id IS NOT NULL THEN
        UPDATE compras 
        SET saldo_pendiente = saldo_pendiente - NEW.monto,
            estado = IF(saldo_pendiente - NEW.monto <= 0, 'PAGADO', 'PENDIENTE')
        WHERE id = NEW.compra_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-02 15:11:15
