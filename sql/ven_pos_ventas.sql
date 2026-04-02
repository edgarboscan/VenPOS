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
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `cliente_id` int DEFAULT NULL,
  `fecha_venta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `impuesto` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tipo_venta` enum('CONTADO','CREDITO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CONTADO',
  `saldo_pendiente` decimal(12,2) DEFAULT '0.00' COMMENT 'Para ventas a crédito',
  `estado` enum('COMPLETADA','ANULADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'COMPLETADA',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_ventas_cliente` (`cliente_id`),
  KEY `fk_ventas_empresa` (`empresa_id`),
  KEY `idx_fecha` (`fecha_venta`),
  KEY `idx_ventas_fecha_tipo` (`fecha_venta`,`tipo_venta`),
  KEY `idx_ventas_cliente_estado` (`cliente_id`,`estado`),
  CONSTRAINT `fk_ventas_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_ventas_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
INSERT INTO `ventas` VALUES (7,1,1,'2026-03-15 10:30:00',425.00,0.00,425.00,'CONTADO',0.00,'COMPLETADA','2026-03-30 19:38:55','2026-03-30 19:38:55'),(8,1,2,'2026-03-16 15:20:00',350.00,0.00,350.00,'CREDITO',200.00,'COMPLETADA','2026-03-30 19:38:59','2026-04-01 14:29:08'),(9,2,3,'2026-03-17 11:45:00',116.00,0.00,116.00,'CONTADO',0.00,'COMPLETADA','2026-03-30 19:39:03','2026-03-30 19:39:03'),(10,2,4,'2026-03-18 09:10:00',239.00,0.00,239.00,'CREDITO',189.00,'COMPLETADA','2026-03-30 19:39:06','2026-03-30 19:39:22'),(11,3,5,'2026-03-19 14:30:00',328.00,0.00,310.00,'CONTADO',0.00,'COMPLETADA','2026-03-30 19:39:10','2026-03-30 19:39:10'),(12,1,1,'2026-03-20 12:00:00',150.00,0.00,150.00,'CREDITO',0.00,'COMPLETADA','2026-03-30 19:39:14','2026-03-30 19:39:25');
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_ventas_estado` AFTER UPDATE ON `ventas` FOR EACH ROW BEGIN
    DECLARE v_usuario_id INT DEFAULT @app_user_id;
    IF OLD.estado != NEW.estado THEN
        INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
        VALUES ('ventas', NEW.id, 'UPDATE',
                CONCAT('Venta ID ', NEW.id, ' - Estado: ', OLD.estado, ' -> ', NEW.estado),
                 IFNULL(v_usuario_id, CURRENT_USER())  -- fallback al usuario técnico
    );
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

-- Dump completed on 2026-04-02 22:06:30
