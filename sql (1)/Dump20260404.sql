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
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_integridad`
--

LOCK TABLES `auditoria_integridad` WRITE;
/*!40000 ALTER TABLE `auditoria_integridad` DISABLE KEYS */;
INSERT INTO `auditoria_integridad` VALUES (56,'usuarios',4,NULL,'LOGIN','Inicio de Sesión exitoso fecha0','2026-03-30 19:00:47','root@localhost'),(57,'usuarios',4,NULL,'LOGIN','Inicio de Sesión exitoso fecha0','2026-03-30 19:00:56','root@localhost'),(58,'usuarios',4,NULL,'LOGIN','Inicio de Sesión exitoso.','2026-03-30 19:13:04','sistema'),(59,'compras',2,NULL,'UPDATE','Compra ID 2 - Factura FAC-002 | Estado: PENDIENTE -> PAGADO','2026-03-30 19:25:53','root@localhost'),(60,'productos',1,NULL,'UPDATE','Precio actualizado de 340.00 a 350.00','2026-03-30 19:25:53','cperez'),(61,'clientes',2,NULL,'INSERT','Nuevo cliente registrado: Inversiones López','2026-03-30 19:25:53','admin'),(62,'ventas',2,NULL,'INSERT','Venta a crédito por 350.00','2026-03-30 19:25:53','vendedor1'),(63,'productos',1,NULL,'UPDATE','Cambio de: Televisor 40\" Sony -> Televisor 40\" Sony','2026-03-30 19:31:50','root@localhost'),(64,'productos',2,NULL,'UPDATE','Cambio de: Zapatillas Nike Air Max -> Zapatillas Nike Air Max','2026-03-30 19:31:50','root@localhost'),(65,'productos',3,NULL,'UPDATE','Cambio de: Leche Condensada La Lechera -> Leche Condensada La Lechera','2026-03-30 19:31:50','root@localhost'),(66,'productos',4,NULL,'UPDATE','Cambio de: Smartphone Samsung Galaxy A14 -> Smartphone Samsung Galaxy A14','2026-03-30 19:31:50','root@localhost'),(67,'productos',5,NULL,'UPDATE','Cambio de: Camiseta Adidas Original -> Camiseta Adidas Original','2026-03-30 19:31:50','root@localhost'),(68,'productos',6,NULL,'UPDATE','Cambio de: Cereal Fitness -> Cereal Fitness','2026-03-30 19:31:50','root@localhost'),(69,'productos',7,NULL,'UPDATE','Cambio de: Lámpara LED Mesa -> Lámpara LED Mesa','2026-03-30 19:31:50','root@localhost'),(70,'productos',8,NULL,'UPDATE','Cambio de: Balón de Fútbol -> Balón de Fútbol','2026-03-30 19:31:50','root@localhost'),(71,'productos',9,NULL,'UPDATE','Cambio de: Audífonos Sony WH-1000 -> Audífonos Sony WH-1000','2026-03-30 19:31:50','root@localhost'),(72,'productos',10,NULL,'UPDATE','Cambio de: Mochila Nike -> Mochila Nike','2026-03-30 19:31:50','root@localhost'),(73,'productos',11,NULL,'UPDATE','Cambio de: Agua Mineral 1.5L -> Agua Mineral 1.5L','2026-03-30 19:31:50','root@localhost'),(74,'productos',12,NULL,'UPDATE','Cambio de: Set Ollas Hogar -> Set Ollas Hogar','2026-03-30 19:31:50','root@localhost'),(75,'productos',13,NULL,'UPDATE','Cambio de: Raqueta Tenis -> Raqueta Tenis','2026-03-30 19:31:50','root@localhost'),(76,'productos',14,NULL,'UPDATE','Cambio de: Tablet Samsung Tab A8 -> Tablet Samsung Tab A8','2026-03-30 19:31:50','root@localhost'),(77,'productos',15,NULL,'UPDATE','Cambio de: Pantalón Deportivo -> Pantalón Deportivo','2026-03-30 19:31:50','root@localhost'),(78,'productos',16,NULL,'UPDATE','Cambio de: Café Nescafé 200g -> Café Nescafé 200g','2026-03-30 19:31:50','root@localhost'),(79,'productos',17,NULL,'UPDATE','Cambio de: Ventilador de Torre -> Ventilador de Torre','2026-03-30 19:31:50','root@localhost'),(80,'productos',18,NULL,'UPDATE','Cambio de: Cuerda Saltar -> Cuerda Saltar','2026-03-30 19:31:50','root@localhost'),(81,'productos',19,NULL,'UPDATE','Cambio de: Monitor Samsung 27\" -> Monitor Samsung 27\"','2026-03-30 19:31:50','root@localhost'),(82,'productos',20,NULL,'UPDATE','Cambio de: Gorra Nike -> Gorra Nike','2026-03-30 19:31:50','root@localhost'),(83,'compras',2,NULL,'UPDATE','Compra ID 2 - Factura FAC-002 | Estado: PENDIENTE -> PAGADO','2026-03-30 19:38:40','root@localhost'),(84,'clientes',2,NULL,'UPDATE','Cliente: Inversiones López C.A. María López -> Inversiones López C.A. María López | Documento: J-98765432','2026-03-30 19:39:18','root@localhost'),(85,'clientes',4,NULL,'UPDATE','Cliente: John Smith -> John Smith | Documento: E-123456','2026-03-30 19:39:22','root@localhost'),(86,'clientes',1,NULL,'UPDATE','Cliente: Carlos Pérez -> Carlos Pérez | Documento: V-12345678','2026-03-30 19:39:25','root@localhost'),(87,'productos',1,NULL,'UPDATE','Precio actualizado de 340.00 a 350.00','2026-03-30 19:39:33','cperez'),(88,'clientes',2,NULL,'INSERT','Nuevo cliente registrado: Inversiones López','2026-03-30 19:39:33','admin'),(89,'ventas',2,NULL,'INSERT','Venta a crédito por 350.00','2026-03-30 19:39:33','vendedor1'),(90,'clientes',1,NULL,'UPDATE','Cliente: Carlos Pérez -> Carlos Pérez | Documento: V-12345678','2026-03-30 19:41:46','root@localhost'),(91,'clientes',2,NULL,'UPDATE','Cliente: Inversiones López C.A. María López -> Inversiones López C.A. María López | Documento: J-98765432','2026-03-30 19:41:46','root@localhost'),(92,'clientes',3,NULL,'UPDATE','Cliente: Ana González -> Ana González | Documento: V-87654321','2026-03-30 19:41:46','root@localhost'),(93,'clientes',4,NULL,'UPDATE','Cliente: John Smith -> John Smith | Documento: E-123456','2026-03-30 19:41:46','root@localhost'),(94,'clientes',5,NULL,'UPDATE','Cliente: Luisa Fernández -> Luisa Fernández | Documento: V-56789012','2026-03-30 19:41:46','root@localhost'),(95,'compras',2,NULL,'UPDATE','Compra ID 2 - Factura FAC-002 | Estado: PAGADO -> PENDIENTE','2026-03-30 19:41:46','root@localhost'),(96,'productos',21,1,'UPDATE','Cambio de: Destornillador Phillips -> Destornillador Phillips','2026-03-31 17:25:33','root@localhost'),(97,'productos',22,1,'UPDATE','Cambio de: Martillo -> Martillo','2026-03-31 17:25:33','root@localhost'),(98,'productos',23,1,'UPDATE','Cambio de: Llave ajustable -> Llave ajustable','2026-03-31 17:25:33','root@localhost'),(99,'productos',24,1,'UPDATE','Cambio de: Kit de Herramientas Básico -> Kit de Herramientas Básico','2026-03-31 17:25:33','root@localhost'),(100,'productos',21,1,'UPDATE','Cambio de: Destornillador Phillips -> Destornillador Phillips','2026-03-31 17:40:41','1'),(101,'productos',22,1,'UPDATE','Cambio de: Martillo -> Martillo','2026-03-31 17:40:41','1'),(102,'productos',23,1,'UPDATE','Cambio de: Llave ajustable -> Llave ajustable','2026-03-31 17:40:41','1'),(103,'productos',24,1,'UPDATE','Cambio de: Kit de Herramientas Básico -> Kit de Herramientas Básico','2026-03-31 17:40:41','1'),(104,'productos',1,NULL,'UPDATE','Cambio de: Televisor 40\" Sony -> Televisor 40\" Sony','2026-04-01 03:21:35','root@localhost'),(105,'productos',2,NULL,'UPDATE','Cambio de: Zapatillas Nike Air Max -> Zapatillas Nike Air Max','2026-04-01 03:21:35','root@localhost'),(106,'productos',3,NULL,'UPDATE','Cambio de: Leche Condensada La Lechera -> Leche Condensada La Lechera','2026-04-01 03:21:35','root@localhost'),(107,'productos',4,NULL,'UPDATE','Cambio de: Smartphone Samsung Galaxy A14 -> Smartphone Samsung Galaxy A14','2026-04-01 03:21:35','root@localhost'),(108,'productos',5,NULL,'UPDATE','Cambio de: Camiseta Adidas Original -> Camiseta Adidas Original','2026-04-01 03:21:35','root@localhost'),(109,'productos',1,NULL,'UPDATE','Cambio de: Televisor 40\" Sony -> Televisor 40\" Sony','2026-04-01 03:25:49','root@localhost'),(110,'productos',2,NULL,'UPDATE','Cambio de: Zapatillas Nike Air Max -> Zapatillas Nike Air Max','2026-04-01 03:25:49','root@localhost'),(111,'productos',3,NULL,'UPDATE','Cambio de: Leche Condensada La Lechera -> Leche Condensada La Lechera','2026-04-01 03:25:49','root@localhost'),(112,'productos',4,NULL,'UPDATE','Cambio de: Smartphone Samsung Galaxy A14 -> Smartphone Samsung Galaxy A14','2026-04-01 03:25:49','root@localhost'),(113,'productos',5,NULL,'UPDATE','Cambio de: Camiseta Adidas Original -> Camiseta Adidas Original','2026-04-01 03:25:49','root@localhost'),(114,'clientes',2,NULL,'UPDATE','Cliente: Inversiones López C.A. María López -> Inversiones López C.A. María López | Documento: J-98765432','2026-04-01 14:29:08','root@localhost'),(115,'precios',121,NULL,'UPDATE','Producto ID 101 - Empresa ID 1 | Costo: 0.00 -> 0.70 | PVP: 1.00 -> 1.00','2026-04-02 23:55:33','root@localhost');
/*!40000 ALTER TABLE `auditoria_integridad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Electrónica','Productos electrónicos y gadgets',1,'2026-03-30 19:27:17','2026-03-30 19:27:43'),(2,'Ropa','Prendas de vestir',1,'2026-03-30 19:27:17','2026-03-30 19:27:43'),(3,'Alimentos','Productos alimenticios no perecederos',1,'2026-03-30 19:27:17','2026-03-30 19:27:43'),(4,'Hogar','Artículos para el hogar',1,'2026-03-30 19:27:17','2026-03-30 19:27:43'),(5,'Deportes','Equipo deportivo',1,'2026-03-30 19:27:17','2026-03-30 19:27:43'),(6,'Ferretria','Ferreteira, Materiales de contruccion',1,'2026-03-31 17:20:04','2026-03-31 17:20:10'),(7,'Viveres','Viveres en general',1,'2026-04-02 17:52:31','2026-04-02 17:52:38');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `tipo_documento` enum('CEDULA','RUC','PASAPORTE','OTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'CEDULA',
  `numero_documento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `limite_credito` decimal(12,2) DEFAULT '0.00',
  `saldo_credito` decimal(12,2) DEFAULT '0.00' COMMENT 'Deuda actual del cliente',
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresa_documento` (`empresa_id`,`numero_documento`),
  KEY `fk_clientes_empresa` (`empresa_id`),
  KEY `idx_clientes_documento` (`numero_documento`),
  KEY `idx_clientes_nombre` (`nombre`),
  CONSTRAINT `fk_clientes_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,1,'CEDULA','V-12345678','Carlos','Pérez','Calle 1, Edif. Centro','0412-1234567','cperez@gmail.com',500.00,0.00,1,'2026-03-30 19:35:31','2026-03-30 19:35:31'),(2,1,'RUC','J-98765432','Inversiones López C.A. María','López','Av. Rómulo Gallegos','0212-9876543','mlopez@invlopez.com',1500.00,200.00,1,'2026-03-30 19:35:31','2026-04-01 14:29:08'),(3,2,'CEDULA','V-87654321','Ana','González','Urb. Las Acacias, Casa 23','0416-5556789','agonzalez@yahoo.com',300.00,0.00,1,'2026-03-30 19:35:31','2026-03-30 19:35:31'),(4,2,'PASAPORTE','E-123456','John','Smith','Calle 10, Quinta Smith','0424-1112233','jsmith@hotmail.com',0.00,189.00,1,'2026-03-30 19:35:31','2026-03-30 19:39:22'),(5,3,'CEDULA','V-56789012','Luisa','Fernández','Av. Ppal, Torre Mega, Piso 5','0412-9998877','lfernandez@gmail.com',800.00,0.00,1,'2026-03-30 19:35:31','2026-03-30 19:35:31');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_clientes` AFTER UPDATE ON `clientes` FOR EACH ROW BEGIN
	 DECLARE v_usuario_id INT DEFAULT @app_user_id;

    INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
    VALUES (
	 	'clientes', 
		 NEW.id, 
		 'UPDATE',
		 CONCAT('Cliente: ', OLD.nombre, ' ', IFNULL(OLD.apellido,''), ' -> ', NEW.nombre, ' ', IFNULL(NEW.apellido,''), ' | Documento: ', OLD.numero_documento),
		 IFNULL(v_usuario_id, CURRENT_USER()));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `codigos_productos`
--

DROP TABLE IF EXISTS `codigos_productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigos_productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `producto_id` int NOT NULL,
  `tipo_codigo` enum('EAN13','UPC','QR','CODIGO_INTERNO','OTRO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CODIGO_INTERNO',
  `codigo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_unico` (`codigo`),
  KEY `fk_codigos_producto` (`producto_id`),
  CONSTRAINT `fk_codigos_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigos_productos`
--

LOCK TABLES `codigos_productos` WRITE;
/*!40000 ALTER TABLE `codigos_productos` DISABLE KEYS */;
INSERT INTO `codigos_productos` VALUES (1,1,'EAN13','4905524112345',1,'2026-03-30 19:31:56'),(2,2,'EAN13','7891234567890',1,'2026-03-30 19:31:56'),(3,4,'UPC','887276412345',1,'2026-03-30 19:31:56'),(4,9,'EAN13','4905524999999',1,'2026-03-30 19:31:56'),(5,14,'QR','https://samsung.com/tabA8',1,'2026-03-30 19:31:56'),(6,20,'CODIGO_INTERNO','GORRA-NK-001',1,'2026-03-30 19:31:56'),(13,101,'CODIGO_INTERNO','0000001',1,'2026-04-02 18:38:46');
/*!40000 ALTER TABLE `codigos_productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras`
--

DROP TABLE IF EXISTS `compras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `proveedor_id` int NOT NULL,
  `numero_factura` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_compra` date NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `impuesto` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `saldo_pendiente` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Deuda actual',
  `estado` enum('PENDIENTE','PAGADO','ANULADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresa_factura` (`empresa_id`,`numero_factura`),
  KEY `fk_compras_proveedor` (`proveedor_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_compras_fecha_estado` (`fecha_compra`,`estado`),
  KEY `idx_compras_proveedor_estado` (`proveedor_id`,`estado`),
  CONSTRAINT `fk_compras_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_compras_proveedor` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras`
--

LOCK TABLES `compras` WRITE;
/*!40000 ALTER TABLE `compras` DISABLE KEYS */;
INSERT INTO `compras` VALUES (1,1,1,'FAC-001','2026-02-10',4500.00,0.00,4500.00,0.00,'PAGADO','2026-03-30 19:37:35','2026-03-30 19:41:46'),(2,1,2,'FAC-002','2026-02-15',920.00,0.00,920.00,150.00,'PENDIENTE','2026-03-30 19:38:14','2026-04-01 14:30:54'),(3,2,3,'FAC-003','2026-02-20',2500.00,0.00,2500.00,0.00,'PAGADO','2026-03-30 19:38:23','2026-03-30 19:41:46'),(4,3,4,'FAC-004','2026-03-01',3800.00,0.00,3800.00,3800.00,'PENDIENTE','2026-03-30 19:38:27','2026-03-30 19:41:46'),(5,1,5,'FAC-005','2026-03-05',1350.00,0.00,1350.00,1350.00,'PENDIENTE','2026-03-30 19:38:31','2026-03-30 19:38:31');
/*!40000 ALTER TABLE `compras` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_compras_estado` AFTER UPDATE ON `compras` FOR EACH ROW BEGIN
	    DECLARE v_usuario_id INT DEFAULT @app_user_id;

    IF OLD.estado != NEW.estado THEN
        INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
        VALUES ('compras', NEW.id, 'UPDATE',
                CONCAT('Compra ID ', NEW.id, ' - Factura ', NEW.numero_factura,
                       ' | Estado: ', OLD.estado, ' -> ', NEW.estado),
                IFNULL(v_usuario_id, CURRENT_USER()));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `compras_detalle`
--

DROP TABLE IF EXISTS `compras_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras_detalle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `compra_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` decimal(12,2) NOT NULL,
  `precio_compra` decimal(12,2) NOT NULL COMMENT 'Costo unitario',
  `subtotal` decimal(12,2) NOT NULL,
  `impuesto` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detalle_compra` (`compra_id`),
  KEY `fk_detalle_producto` (`producto_id`),
  CONSTRAINT `fk_detalle_compra` FOREIGN KEY (`compra_id`) REFERENCES `compras` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_detalle`
--

LOCK TABLES `compras_detalle` WRITE;
/*!40000 ALTER TABLE `compras_detalle` DISABLE KEYS */;
INSERT INTO `compras_detalle` VALUES (20,1,1,10.00,250.00,2500.00,0.00,2500.00),(21,1,9,20.00,95.00,1900.00,0.00,1900.00),(22,1,14,5.00,130.00,650.00,0.00,650.00),(23,2,3,200.00,1.50,300.00,0.00,300.00),(24,2,6,100.00,2.80,280.00,0.00,280.00),(25,2,16,80.00,3.50,280.00,0.00,280.00),(26,2,11,200.00,0.60,120.00,0.00,120.00),(27,3,2,30.00,48.00,1440.00,0.00,1440.00),(28,3,10,20.00,24.00,480.00,0.00,480.00),(29,3,20,50.00,8.50,425.00,0.00,425.00),(30,4,4,12.00,178.00,2136.00,0.00,2136.00),(31,4,14,8.00,128.00,1024.00,0.00,1024.00),(32,4,19,3.00,205.00,615.00,0.00,615.00),(33,5,5,50.00,12.50,625.00,0.00,625.00),(34,5,13,15.00,41.00,615.00,0.00,615.00),(35,5,15,30.00,18.50,555.00,0.00,555.00);
/*!40000 ALTER TABLE `compras_detalle` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_compra_detalle_after_insert` AFTER INSERT ON `compras_detalle` FOR EACH ROW BEGIN
    DECLARE v_empresa_id INT;
    DECLARE v_maneja_inventario TINYINT(1);
    
    SELECT empresa_id INTO v_empresa_id FROM compras WHERE id = NEW.compra_id;
    SELECT maneja_inventario INTO v_maneja_inventario FROM productos WHERE id = NEW.producto_id;
    
    IF v_maneja_inventario = 1 THEN
        INSERT INTO inventario (empresa_id, producto_id, stock_actual, ultima_actualizacion)
        VALUES (v_empresa_id, NEW.producto_id, NEW.cantidad, NOW())
        ON DUPLICATE KEY UPDATE 
            stock_actual = stock_actual + NEW.cantidad,
            ultima_actualizacion = NOW();
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `configuracion_auditoria`
--

DROP TABLE IF EXISTS `configuracion_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_auditoria` (
  `id_auditoria` int NOT NULL AUTO_INCREMENT,
  `id_config` int NOT NULL,
  `grupo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `clave` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_nuevo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `accion` enum('INSERT','UPDATE','DELETE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_id` int DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_cambio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `idx_config_auditoria_config` (`id_config`),
  KEY `idx_config_auditoria_fecha` (`fecha_cambio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_auditoria`
--

LOCK TABLES `configuracion_auditoria` WRITE;
/*!40000 ALTER TABLE `configuracion_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuracion_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion_grupos`
--

DROP TABLE IF EXISTS `configuracion_grupos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_grupos` (
  `id_grupo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icono` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orden` int DEFAULT '0',
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_grupos_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_grupos`
--

LOCK TABLES `configuracion_grupos` WRITE;
/*!40000 ALTER TABLE `configuracion_grupos` DISABLE KEYS */;
INSERT INTO `configuracion_grupos` VALUES (1,'general','Configuraciones generales del sistema','settings',1,1,'2026-03-03 13:42:20'),(2,'seguridad','Parámetros de seguridad y autenticación','security',2,1,'2026-03-03 13:42:20'),(3,'notificaciones','Configuración de correos y notificaciones','notifications',3,1,'2026-03-03 13:42:20'),(4,'paginacion','Configuración de paginación por defecto','pagination',5,1,'2026-03-03 13:42:20'),(5,'api','Configuraciones de APIs externas','api',6,1,'2026-03-03 13:42:20'),(6,'backup','Configuración de respaldos','backup',7,1,'2026-03-03 13:42:20'),(7,'monitoreo','Parámetros de monitoreo y logs','monitoring',8,1,'2026-03-03 13:42:20');
/*!40000 ALTER TABLE `configuracion_grupos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion_sistema`
--

DROP TABLE IF EXISTS `configuracion_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_sistema` (
  `id_config` int NOT NULL AUTO_INCREMENT,
  `grupo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Grupo o módulo de la configuración',
  `clave` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Clave única del parámetro',
  `valor` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Valor del parámetro',
  `tipo_dato` enum('texto','numero','booleano','fecha','json','archivo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'texto',
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Descripción del parámetro',
  `es_publico` tinyint(1) DEFAULT '0' COMMENT 'Visible para el frontend',
  `es_editable` tinyint(1) DEFAULT '1' COMMENT 'Puede ser modificado',
  `es_requerido` tinyint(1) DEFAULT '0',
  `valor_defecto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `opciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'JSON con opciones disponibles',
  `validacion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Reglas de validación en formato JSON',
  `orden` int DEFAULT '0',
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario_creacion` int DEFAULT NULL,
  `usuario_actualizacion` int DEFAULT NULL,
  PRIMARY KEY (`id_config`),
  UNIQUE KEY `uq_config_grupo_clave` (`grupo`,`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_sistema`
--

LOCK TABLES `configuracion_sistema` WRITE;
/*!40000 ALTER TABLE `configuracion_sistema` DISABLE KEYS */;
INSERT INTO `configuracion_sistema` VALUES (1,'general','nombre_sistema','VenPOS - Point of Sales ONLINE','texto','Nombre del sistema',1,1,0,'VenPOS - Point of Sales ONLINE',NULL,NULL,1,1,'2026-03-03 13:42:43','2026-03-29 05:25:44',NULL,NULL),(2,'general','version','1.0.0','texto','Versión actual del sistema',1,1,0,'1.0.0',NULL,NULL,2,1,'2026-03-03 13:42:43','2026-03-03 13:42:43',NULL,NULL),(3,'general','entorno','produccion','texto','Entorno de ejecución (desarrollo, testing, produccion)',0,1,0,'produccion',NULL,NULL,3,1,'2026-03-03 13:42:43','2026-03-03 13:42:43',NULL,NULL),(4,'general','zona_horaria','Caracas','texto','Zona horaria del sistema',1,1,0,'UTC',NULL,NULL,4,1,'2026-03-03 13:42:43','2026-03-03 13:46:56',NULL,NULL),(5,'general','formato_fecha','Y-m-d H:i:s','texto','Formato de fecha por defecto',1,1,0,'Y-m-d H:i:s',NULL,NULL,5,1,'2026-03-03 13:42:43','2026-03-03 13:42:43',NULL,NULL),(6,'general','idioma_defecto','es','texto','Idioma por defecto',1,1,0,'es',NULL,NULL,6,1,'2026-03-03 13:42:43','2026-03-03 13:42:43',NULL,NULL),(7,'general','moneda','Bs','texto','Moneda por defecto',1,1,0,'CLP',NULL,NULL,7,1,'2026-03-03 13:42:43','2026-03-03 13:46:22',NULL,NULL),(8,'general','debug_mode','0','booleano','Modo debug activado',0,1,0,'0',NULL,NULL,8,1,'2026-03-03 13:42:43','2026-03-03 13:42:43',NULL,NULL),(9,'seguridad','tiempo_sesion_minutos','120','numero','Tiempo de sesión en minutos',0,1,0,'120',NULL,NULL,1,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(10,'seguridad','intentos_login_max','5','numero','Máximos intentos de login',0,1,0,'5',NULL,NULL,2,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(11,'seguridad','bloqueo_tiempo_minutos','30','numero','Tiempo de bloqueo por intentos fallidos',0,1,0,'30',NULL,NULL,3,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(12,'seguridad','longitud_minima_password','8','numero','Longitud mínima de contraseña',0,1,0,'8',NULL,NULL,4,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(13,'seguridad','requiere_mayusculas','1','booleano','Requiere mayúsculas en password',0,1,0,'1',NULL,NULL,5,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(14,'seguridad','requiere_numeros','1','booleano','Requiere números en password',0,1,0,'1',NULL,NULL,6,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(15,'seguridad','requiere_simbolos','1','booleano','Requiere símbolos en password',0,1,0,'0',NULL,NULL,7,1,'2026-03-03 13:42:44','2026-03-29 14:42:15',NULL,NULL),(16,'seguridad','two_factor_auth','0','booleano','Autenticación de dos factores',0,1,0,'0',NULL,NULL,8,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(17,'seguridad','password_expira_dias','90','numero','Días para expiración de password',0,1,0,'90',NULL,NULL,9,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(18,'seguridad','sesiones_concurrentes','1','booleano','Permitir sesiones concurrentes',0,1,0,'1',NULL,NULL,10,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL),(19,'notificaciones','email_smtp_host','smtp.gmail.com','texto','Host SMTP',0,1,0,'smtp.gmail.com',NULL,NULL,1,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(20,'notificaciones','email_smtp_puerto','587','numero','Puerto SMTP',0,1,0,'587',NULL,'{\"min\":1,\"max\":65535}',2,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(21,'notificaciones','email_smtp_seguridad','tls','texto','Tipo de seguridad (tls, ssl, none)',0,1,0,'tls','[\"tls\",\"ssl\",\"none\"]','{\"opciones\":[\"tls\",\"ssl\",\"none\"]}',3,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(22,'notificaciones','email_cuenta','notificaciones@example.com','texto','Cuenta de correo',0,1,0,NULL,NULL,'{\"email\":true}',4,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(23,'notificaciones','email_password','','texto','Contraseña de correo',0,1,0,NULL,NULL,NULL,5,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(24,'notificaciones','email_nombre_remitente','VenPOS','texto','Nombre del remitente',1,1,0,'VenPOS - Point of Sales ONLINE',NULL,NULL,6,1,'2026-03-03 13:42:45','2026-03-29 05:25:44',NULL,NULL),(25,'notificaciones','notificaciones_activas','1','booleano','Activar notificaciones',1,1,0,'1',NULL,NULL,7,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(26,'notificaciones','notificaciones_email_admin','admin@example.com','texto','Email del administrador',0,1,0,NULL,NULL,'{\"email\":true}',8,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(27,'notificaciones','notificaciones_alerta_severidad','[\"severa\",\"critica\"]','json','Severidades que envían notificación',0,1,0,'[\"severa\",\"critica\"]','[\"leve\",\"moderada\",\"severa\",\"critica\"]',NULL,9,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(36,'paginacion','registros_por_pagina_defecto','10','numero','Registros por página por defecto',1,1,0,'10',NULL,'{\"min\":5,\"max\":100}',1,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(37,'paginacion','max_registros_por_pagina','100','numero','Máximo de registros por página permitido',0,1,0,'100',NULL,'{\"min\":10,\"max\":500}',2,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(38,'paginacion','paginacion_max_botones','5','numero','Número máximo de botones de paginación',1,1,0,'5',NULL,'{\"min\":3,\"max\":20}',3,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(39,'paginacion','ordenamiento_defecto','nombre','texto','Campo de ordenamiento por defecto',0,1,0,'nombre',NULL,NULL,4,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(40,'paginacion','ordenamiento_direccion_defecto','ASC','texto','Dirección de ordenamiento por defecto',0,1,0,'ASC',NULL,'{\"opciones\":[\"ASC\",\"DESC\"]}',5,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(41,'api','api_rate_limit','100','numero','Límite de peticiones por minuto',0,1,0,'100',NULL,NULL,1,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(42,'api','api_timeout_segundos','30','numero','Timeout de API en segundos',0,1,0,'30',NULL,NULL,2,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(43,'api','api_version','v1','texto','Versión de la API',1,1,0,'v1',NULL,NULL,3,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(44,'api','api_token_expiracion_horas','24','numero','Expiración del token API en horas',0,1,0,'24',NULL,NULL,4,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(45,'api','cors_origenes_permitidos','[\"http://localhost:8000\",\"https://app.example.com\"]','json','Orígenes CORS permitidos',0,1,0,'[\"*\"]',NULL,NULL,5,1,'2026-03-03 13:42:45','2026-03-03 13:47:48',NULL,NULL),(46,'backup','backup_activo','1','booleano','Activar backups automáticos',0,1,0,'1',NULL,NULL,1,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(47,'backup','backup_frecuencia_horas','24','numero','Frecuencia de backup en horas',0,1,0,'24',NULL,NULL,2,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(48,'backup','backup_retener_dias','30','numero','Días a retener backups',0,1,0,'30',NULL,NULL,3,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(49,'backup','backup_ruta','/var/backups/sistema/','texto','Ruta para guardar backups',0,1,0,'./backups/',NULL,NULL,4,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(50,'backup','backup_hora_ejecucion','03:00','texto','Hora de ejecución del backup',0,1,0,'03:00',NULL,NULL,5,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(51,'monitoreo','log_nivel','WARNING','texto','Nivel de logging (DEBUG, INFO, WARNING, ERROR)',0,1,0,'WARNING','[\"DEBUG\",\"INFO\",\"WARNING\",\"ERROR\"]',NULL,1,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(52,'monitoreo','log_retener_dias','30','numero','Días a retener logs',0,1,0,'30',NULL,NULL,2,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(53,'monitoreo','monitoreo_activo','1','booleano','Activar monitoreo',0,1,0,'1',NULL,NULL,3,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(54,'monitoreo','alertas_criticas_email','admin@example.com','texto','Email para alertas críticas',0,1,0,NULL,NULL,NULL,4,1,'2026-03-03 13:42:45','2026-03-03 13:42:45',NULL,NULL),(55,'general','permite_stock_negativo_insumos','1','booleano','Permite quedar negativo sctok de insumos',1,1,0,'0',NULL,NULL,0,1,'2026-03-03 13:48:59','2026-03-03 13:50:19',NULL,NULL),(56,'seguridad','requiere_minusculas','1','booleano','Requiere minusculas en password',0,1,0,'1',NULL,NULL,6,1,'2026-03-03 13:42:44','2026-03-03 13:42:44',NULL,NULL);
/*!40000 ALTER TABLE `configuracion_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruc` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

LOCK TABLES `empresas` WRITE;
/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
INSERT INTO `empresas` VALUES (1,'Mi Empresa SRL','123456789','Calle Falsa 123','555-1234','contacto@miempresa.com',NULL,1,'2026-03-30 18:24:45','2026-03-30 18:24:45'),(2,'Distribuidora El Sol','J-12345678-0','Av. Principal, Centro Comercial Plaza, Nivel 1','+58 212-5551212','ventas@elsol.com',NULL,1,'2026-03-30 19:25:53','2026-03-30 19:25:53'),(3,'Supermercado La Económica','J-87654321-9','Calle 5, Urb. Las Mercedes','+58 212-5553434','info@laeconomica.com',NULL,1,'2026-03-30 19:25:53','2026-03-30 19:25:53'),(4,'Tiendas MegaMax','J-11223344-5','Av. Libertador, Torre MegaMax','+58 212-5555656','contacto@megamax.com',NULL,1,'2026-03-30 19:25:53','2026-03-30 19:25:53');
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_empresas` AFTER UPDATE ON `empresas` FOR EACH ROW BEGIN
    DECLARE v_usuario_id INT DEFAULT @app_user_id;
    INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
    VALUES ('empresas', NEW.id, 'UPDATE',
            CONCAT('Cambio de nombre: ', OLD.nombre, ' -> ', NEW.nombre, ' | RUC: ', OLD.ruc, ' -> ', NEW.ruc),
            FNULL(v_usuario_id, CURRENT_USER()));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `formas_pago`
--

DROP TABLE IF EXISTS `formas_pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formas_pago` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formas_pago`
--

LOCK TABLES `formas_pago` WRITE;
/*!40000 ALTER TABLE `formas_pago` DISABLE KEYS */;
INSERT INTO `formas_pago` VALUES (1,'EFECTIVO',1),(2,'TARJETA_CREDITO',1),(3,'TARJETA_DEBITO',1),(4,'TRANSFERENCIA',1),(5,'CHEQUE',1),(6,'CREDITO',1),(7,'PAGO MOVIL',1);
/*!40000 ALTER TABLE `formas_pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `stock_actual` decimal(12,2) NOT NULL DEFAULT '0.00',
  `stock_minimo` decimal(12,2) DEFAULT '0.00',
  `stock_maximo` decimal(12,2) DEFAULT NULL,
  `ultima_actualizacion` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresa_producto` (`empresa_id`,`producto_id`),
  KEY `fk_inventario_producto` (`producto_id`),
  KEY `idx_inventario_stock_actual` (`stock_actual`),
  KEY `idx_inventario_empresa_producto` (`empresa_id`,`producto_id`),
  CONSTRAINT `fk_inventario_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_inventario_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (61,1,1,24.00,3.00,50.00,'2026-03-30 19:38:55','2026-03-30 19:36:13','2026-03-30 19:38:55'),(62,1,2,40.00,5.00,100.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(63,1,3,370.00,20.00,500.00,'2026-03-30 19:38:55','2026-03-30 19:36:13','2026-03-30 19:38:55'),(64,1,4,7.00,2.00,30.00,'2026-03-30 19:38:59','2026-03-30 19:36:13','2026-03-30 19:38:59'),(65,1,5,100.00,10.00,150.00,'2026-03-30 19:38:31','2026-03-30 19:36:13','2026-03-30 19:38:31'),(66,1,6,220.00,15.00,300.00,'2026-03-30 19:38:14','2026-03-30 19:36:13','2026-03-30 19:38:14'),(67,1,7,25.00,5.00,80.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(68,1,8,30.00,6.00,100.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(69,1,9,31.00,2.00,40.00,'2026-03-30 19:38:59','2026-03-30 19:36:13','2026-03-30 19:38:59'),(70,1,10,18.00,4.00,60.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(71,1,11,650.00,50.00,1000.00,'2026-03-30 19:39:14','2026-03-30 19:36:13','2026-03-30 19:39:14'),(72,1,12,10.00,2.00,30.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(73,1,13,35.00,3.00,50.00,'2026-03-30 19:38:31','2026-03-30 19:36:13','2026-03-30 19:38:31'),(74,1,14,11.00,1.00,20.00,'2026-03-30 19:37:35','2026-03-30 19:36:13','2026-03-30 19:37:35'),(75,1,15,65.00,8.00,90.00,'2026-03-30 19:38:31','2026-03-30 19:36:13','2026-03-30 19:38:31'),(76,1,16,160.00,10.00,200.00,'2026-03-30 19:38:14','2026-03-30 19:36:13','2026-03-30 19:38:14'),(77,1,17,14.00,3.00,40.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(78,1,18,40.00,10.00,120.00,'2026-03-30 19:39:14','2026-03-30 19:36:13','2026-03-30 19:39:14'),(79,1,19,5.00,1.00,15.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(80,1,20,57.00,10.00,150.00,'2026-03-30 19:39:14','2026-03-30 19:36:13','2026-03-30 19:39:14'),(81,2,1,10.00,3.00,50.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(82,2,2,54.00,5.00,100.00,'2026-03-30 19:39:03','2026-03-30 19:36:13','2026-03-30 19:39:03'),(83,2,3,180.00,20.00,500.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(84,2,4,4.00,2.00,30.00,'2026-03-30 19:39:06','2026-03-30 19:36:13','2026-03-30 19:39:06'),(85,2,5,29.00,10.00,150.00,'2026-03-30 19:39:03','2026-03-30 19:36:13','2026-03-30 19:39:03'),(86,2,6,86.00,15.00,300.00,'2026-03-30 19:39:03','2026-03-30 19:36:13','2026-03-30 19:39:03'),(87,2,7,20.00,5.00,80.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(88,2,8,22.00,6.00,100.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(89,2,9,8.00,2.00,40.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(90,2,10,32.00,4.00,60.00,'2026-03-30 19:38:23','2026-03-30 19:36:13','2026-03-30 19:38:23'),(91,2,11,400.00,50.00,1000.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(92,2,12,8.00,2.00,30.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(93,2,13,15.00,3.00,50.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(94,2,14,4.00,1.00,20.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(95,2,15,25.00,8.00,90.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(96,2,16,60.00,10.00,200.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(97,2,17,10.00,3.00,40.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(98,2,18,30.00,10.00,120.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(99,2,19,3.00,1.00,15.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(100,2,20,95.00,10.00,150.00,'2026-03-30 19:38:23','2026-03-30 19:36:13','2026-03-30 19:38:23'),(101,3,1,12.00,3.00,50.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(102,3,2,35.00,5.00,100.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(103,3,3,220.00,20.00,500.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(104,3,4,19.00,2.00,30.00,'2026-03-30 19:38:27','2026-03-30 19:36:13','2026-03-30 19:38:27'),(105,3,5,45.00,10.00,150.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(106,3,6,110.00,15.00,300.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(107,3,7,20.00,5.00,80.00,'2026-03-30 19:39:10','2026-03-30 19:36:13','2026-03-30 19:39:10'),(108,3,8,27.00,6.00,100.00,'2026-03-30 19:39:10','2026-03-30 19:36:13','2026-03-30 19:39:10'),(109,3,9,10.00,2.00,40.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(110,3,10,14.00,4.00,60.00,'2026-03-30 19:39:10','2026-03-30 19:36:13','2026-03-30 19:39:10'),(111,3,11,480.00,50.00,1000.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(112,3,12,8.00,2.00,30.00,'2026-03-30 19:39:10','2026-03-30 19:36:13','2026-03-30 19:39:10'),(113,3,13,18.00,3.00,50.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(114,3,14,13.00,1.00,20.00,'2026-03-30 19:38:27','2026-03-30 19:36:13','2026-03-30 19:38:27'),(115,3,15,30.00,8.00,90.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(116,3,16,75.00,10.00,200.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(117,3,17,10.00,3.00,40.00,'2026-03-30 19:39:10','2026-03-30 19:36:13','2026-03-30 19:39:10'),(118,3,18,40.00,10.00,120.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13'),(119,3,19,7.00,1.00,15.00,'2026-03-30 19:38:27','2026-03-30 19:36:13','2026-03-30 19:38:27'),(120,3,20,55.00,10.00,150.00,'2026-03-30 19:36:13','2026-03-30 19:36:13','2026-03-30 19:36:13');
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_inventario` AFTER UPDATE ON `inventario` FOR EACH ROW BEGIN
    DECLARE v_usuario_id INT DEFAULT @app_user_id;
    IF OLD.stock_minimo != NEW.stock_minimo OR OLD.stock_maximo != NEW.stock_maximo THEN
        INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
        VALUES ('inventario', NEW.id, 'UPDATE',
                CONCAT('Producto ID ', NEW.producto_id, ' - Empresa ID ', NEW.empresa_id,
                       ' | Stock mínimo: ', OLD.stock_minimo, ' -> ', NEW.stock_minimo,
                       ' | Stock máximo: ', OLD.stock_maximo, ' -> ', NEW.stock_maximo),
                FNULL(v_usuario_id, CURRENT_USER()));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ips_log`
--

DROP TABLE IF EXISTS `ips_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ips_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `pagina` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metodo` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_referer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT (now()),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ip` (`ip`) USING BTREE,
  KEY `idx_fecha` (`fecha`) USING BTREE,
  KEY `idx_ip_fecha` (`ip`,`fecha`) USING BTREE,
  KEY `idx_usuario_id` (`usuario_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ips_log`
--

LOCK TABLES `ips_log` WRITE;
/*!40000 ALTER TABLE `ips_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ips_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marcas`
--

DROP TABLE IF EXISTS `marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas`
--

LOCK TABLES `marcas` WRITE;
/*!40000 ALTER TABLE `marcas` DISABLE KEYS */;
INSERT INTO `marcas` VALUES (1,'Sony',1),(2,'Nike',1),(3,'Nestlé',1),(4,'Samsung',1),(5,'Adidas',1),(6,'Trupper',1),(7,'P.A.N',1);
/*!40000 ALTER TABLE `marcas` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `pagos_clientes`
--

DROP TABLE IF EXISTS `pagos_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pagos_clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `cliente_id` int NOT NULL,
  `venta_id` int DEFAULT NULL COMMENT 'Venta a la que se aplica el pago',
  `monto` decimal(12,2) NOT NULL,
  `fecha_pago` date NOT NULL,
  `forma_pago` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'EFECTIVO',
  `referencia` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_pago_cliente` (`cliente_id`),
  KEY `fk_pago_venta` (`venta_id`),
  KEY `fk_pago_cliente_empresa` (`empresa_id`),
  KEY `idx_pagos_cliente_fecha` (`cliente_id`,`fecha_pago`),
  CONSTRAINT `fk_pago_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_pago_cliente_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pago_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagos_clientes`
--

LOCK TABLES `pagos_clientes` WRITE;
/*!40000 ALTER TABLE `pagos_clientes` DISABLE KEYS */;
INSERT INTO `pagos_clientes` VALUES (4,1,2,8,100.00,'2026-03-20','TRANSFERENCIA',NULL,'2026-03-30 19:39:18'),(5,2,4,10,50.00,'2026-03-21','EFECTIVO',NULL,'2026-03-30 19:39:22'),(6,1,1,12,150.00,'2026-03-22','EFECTIVO',NULL,'2026-03-30 19:39:25'),(9,1,2,8,50.00,'2026-04-01','Efectivo',NULL,'2026-04-01 14:29:08');
/*!40000 ALTER TABLE `pagos_clientes` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_pago_cliente_after_insert` AFTER INSERT ON `pagos_clientes` FOR EACH ROW BEGIN
    IF NEW.venta_id IS NOT NULL THEN
        UPDATE ventas 
        SET saldo_pendiente = saldo_pendiente - NEW.monto
        WHERE id = NEW.venta_id;
        
        -- Si el saldo llega a cero, no se cambia estado de venta (opcional)
    END IF;
    
    -- Actualizar saldo_credito del cliente
    UPDATE clientes 
    SET saldo_credito = fn_saldo_cliente(NEW.cliente_id)
    WHERE id = NEW.cliente_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permisos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
INSERT INTO `permisos` VALUES (1,'ver','Permiso para visualizar el menú','2026-02-12 14:44:48'),(2,'crear','Permiso para crear registros','2026-02-12 14:44:48'),(3,'editar','Permiso para modificar registros','2026-02-12 14:44:48'),(4,'eliminar','Permiso para eliminar registros','2026-02-12 14:44:48'),(5,'Todos','Todos los permisos','2026-02-13 22:49:25');
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `precios`
--

DROP TABLE IF EXISTS `precios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `precios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `precio_compra` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Costo',
  `precio_venta` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precio_oferta` decimal(12,2) DEFAULT '0.00',
  `fecha_inicio_oferta` date DEFAULT NULL,
  `fecha_fin_oferta` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresa_producto` (`empresa_id`,`producto_id`),
  KEY `fk_precios_producto` (`producto_id`),
  KEY `idx_precios_empresa_producto_activo` (`empresa_id`,`producto_id`,`activo`),
  CONSTRAINT `fk_precios_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_precios_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `precios`
--

LOCK TABLES `precios` WRITE;
/*!40000 ALTER TABLE `precios` DISABLE KEYS */;
INSERT INTO `precios` VALUES (61,1,1,250.00,350.00,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(62,1,2,45.00,79.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(63,1,3,1.50,2.50,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(64,1,4,180.00,249.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(65,1,5,12.00,25.00,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(66,1,6,2.80,4.50,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(67,1,7,8.00,15.00,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(68,1,8,15.00,29.90,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(69,1,9,95.00,149.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(70,1,10,22.00,39.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(71,1,11,0.60,1.20,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(72,1,12,35.00,59.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(73,1,13,40.00,69.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(74,1,14,130.00,199.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(75,1,15,18.00,32.00,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(76,1,16,3.50,5.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(77,1,17,42.00,75.00,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(78,1,18,5.00,9.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(79,1,19,200.00,289.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(80,1,20,8.00,14.99,NULL,NULL,NULL,1,'2026-03-30 19:32:32','2026-03-30 19:32:32'),(81,3,1,255.00,345.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(82,3,2,46.50,78.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(83,3,3,1.55,2.40,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(84,3,4,178.00,245.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(85,3,5,12.50,24.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(86,3,6,2.90,4.40,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(87,3,7,8.20,14.50,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(88,3,8,15.50,29.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(89,3,9,97.00,145.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(90,3,10,23.00,39.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(91,3,11,0.58,1.15,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(92,3,12,35.50,58.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(93,3,13,41.00,68.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(94,3,14,128.00,195.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(95,3,15,18.50,31.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(96,3,16,3.60,5.80,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(97,3,17,43.00,73.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(98,3,18,5.20,9.80,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(99,3,19,205.00,285.00,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(100,3,20,8.20,14.50,NULL,NULL,NULL,1,'2026-03-30 19:32:45','2026-03-30 19:32:45'),(101,2,1,260.00,340.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(102,2,2,48.00,75.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(103,2,3,1.40,2.30,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(104,2,4,175.00,239.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(105,2,5,13.00,23.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(106,2,6,2.70,4.20,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(107,2,7,7.50,14.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(108,2,8,16.00,28.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(109,2,9,100.00,139.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(110,2,10,24.00,38.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(111,2,11,0.55,1.10,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(112,2,12,36.00,55.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(113,2,13,42.00,65.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(114,2,14,125.00,189.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(115,2,15,19.00,30.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(116,2,16,3.40,5.50,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(117,2,17,44.00,70.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(118,2,18,5.50,9.50,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(119,2,19,210.00,279.00,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(120,2,20,8.50,13.99,NULL,NULL,NULL,1,'2026-03-30 19:33:22','2026-03-30 19:33:22'),(121,1,101,0.70,1.00,NULL,'1900-01-01','1900-01-01',1,'2026-04-02 18:21:42','2026-04-02 23:55:33');
/*!40000 ALTER TABLE `precios` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_precios` AFTER UPDATE ON `precios` FOR EACH ROW BEGIN
    DECLARE v_usuario_id INT DEFAULT @app_user_id;
    IF OLD.precio_venta != NEW.precio_venta OR OLD.precio_compra != NEW.precio_compra THEN
        INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
        VALUES ('precios', NEW.id, 'UPDATE',
                CONCAT('Producto ID ', NEW.producto_id, ' - Empresa ID ', NEW.empresa_id,
                       ' | Costo: ', OLD.precio_compra, ' -> ', NEW.precio_compra,
                       ' | PVP: ', OLD.precio_venta, ' -> ', NEW.precio_venta),
                IFNULL(v_usuario_id, CURRENT_USER()));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo_principal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SKU o código interno',
  `nombre` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `categoria_id` int DEFAULT NULL,
  `marca_id` int DEFAULT NULL,
  `unidad_medida_id` int DEFAULT NULL,
  `tipo_producto` enum('simple','compuesto') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'simple',
  `stock_minimo` decimal(12,2) DEFAULT '0.00' COMMENT 'Stock mínimo global (puede sobrescribirse por empresa en inventario)',
  `maneja_inventario` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = afecta inventario, 0 = no afecta inventario',
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_principal` (`codigo_principal`),
  KEY `fk_productos_categoria` (`categoria_id`),
  KEY `fk_productos_marca` (`marca_id`),
  KEY `fk_productos_unidad` (`unidad_medida_id`),
  KEY `idx_productos_nombre` (`nombre`),
  KEY `idx_productos_codigo_principal` (`codigo_principal`),
  CONSTRAINT `fk_productos_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_productos_marca` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_productos_unidad` FOREIGN KEY (`unidad_medida_id`) REFERENCES `unidades_medida` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES (1,'SKU001','Televisor 40\" Sony','TV LED Full HD 40 pulgadas',1,1,1,'simple',5.00,1,1,'2026-03-30 19:30:16','2026-04-01 03:21:35'),(2,'SKU002','Zapatillas Nike Air Max','Calzado deportivo tallas 38-44',2,2,1,'simple',5.00,1,1,'2026-03-30 19:30:24','2026-04-01 03:21:35'),(3,'SKU003','Leche Condensada La Lechera','Leche condensada 395g',3,3,2,'simple',5.00,1,1,'2026-03-30 19:30:33','2026-04-01 03:21:35'),(4,'SKU004','Smartphone Samsung Galaxy A14','Teléfono inteligente 128GB',1,4,1,'simple',5.00,1,1,'2026-03-30 19:31:09','2026-04-01 03:21:35'),(5,'SKU005','Camiseta Adidas Original','Camiseta deportiva algodón',2,5,1,'simple',5.00,1,1,'2026-03-30 19:31:09','2026-04-01 03:21:35'),(6,'SKU006','Cereal Fitness','Cereal integral 500g',3,3,2,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(7,'SKU007','Lámpara LED Mesa','Lámpara de escritorio regulable',4,NULL,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(8,'SKU008','Balón de Fútbol','Balón tamaño 5',5,5,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(9,'SKU009','Audífonos Sony WH-1000','Audífonos cancelación ruido',1,1,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(10,'SKU010','Mochila Nike','Mochila deportiva 30L',2,2,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(11,'SKU011','Agua Mineral 1.5L','Agua purificada sin gas',3,NULL,3,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(12,'SKU012','Set Ollas Hogar','Set 3 ollas acero inoxidable',4,NULL,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(13,'SKU013','Raqueta Tenis','Raqueta profesional',5,5,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(14,'SKU014','Tablet Samsung Tab A8','Tablet 10.5 pulgadas',1,4,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(15,'SKU015','Pantalón Deportivo','Pantalón jogger elástico',2,5,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(16,'SKU016','Café Nescafé 200g','Café instantáneo',3,3,2,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(17,'SKU017','Ventilador de Torre','Ventilador silencioso 40W',4,NULL,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(18,'SKU018','Cuerda Saltar','Cuerda ajustable',5,NULL,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(19,'SKU019','Monitor Samsung 27\"','Monitor curvo 144Hz',1,4,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(20,'SKU020','Gorra Nike','Gorra deportiva ajustable',2,2,1,'simple',0.00,1,1,'2026-03-30 19:31:09','2026-03-30 19:31:50'),(21,'HERR-01','Destornillador Phillips','Destornillador Phillips Mango de goma',6,6,1,'simple',0.00,1,1,'2026-03-31 17:07:06','2026-03-31 17:40:41'),(22,'HERR-02','Martillo','Martillo Cabo de Madera',6,6,1,'simple',0.00,1,1,'2026-03-31 17:07:06','2026-03-31 17:40:41'),(23,'HERR-03','Llave ajustable','Llave Ajustable Aluminio',6,6,1,'simple',0.00,1,1,'2026-03-31 17:07:06','2026-03-31 17:40:41'),(24,'KIT-001','Kit de Herramientas Básico','Kit de Herramientas Básico',6,NULL,1,'compuesto',0.00,1,1,'2026-03-31 17:07:06','2026-03-31 17:40:41'),(101,'0000001','Harina P.A.N 1Kg','Harina Precocida',7,7,1,'simple',10.00,1,1,'2026-04-02 18:21:42','2026-04-02 18:21:42');
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_productos_update` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    DECLARE v_usuario_id INT DEFAULT @app_usuario_id;
    DECLARE v_empresa_id INT DEFAULT @app_empresa_id;
    
    INSERT INTO auditoria_integridad 
        (tabla_origen, id_registro, empresa_id, tipo_evento, descripcion, usuario)
    VALUES (
        'productos', 
        NEW.id, 
        v_empresa_id,
        'UPDATE', 
        CONCAT('Cambio de: ', OLD.nombre, ' -> ', NEW.nombre),
        IFNULL(v_usuario_id, CURRENT_USER())
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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

--
-- Table structure for table `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proveedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `ruc` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contacto_nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresa_ruc` (`empresa_id`,`ruc`),
  KEY `fk_proveedores_empresa` (`empresa_id`),
  KEY `idx_proveedores_ruc` (`ruc`),
  KEY `idx_proveedores_nombre` (`nombre`),
  CONSTRAINT `fk_proveedores_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proveedores`
--

LOCK TABLES `proveedores` WRITE;
/*!40000 ALTER TABLE `proveedores` DISABLE KEYS */;
INSERT INTO `proveedores` VALUES (1,1,'J-11111111-1','Distribuidora Sony Venezuela','Zona Industrial Sur, Galpón 12','0212-1111111','ventas@sonyve.com','Roberto Díaz',1,'2026-03-30 19:25:53','2026-03-30 19:25:53'),(2,1,'J-22222222-2','Alimentos Nestlé C.A.','Av. Principal, Centro Empresarial','0212-2222222','pedidos@nestle.com','María Fernanda',1,'2026-03-30 19:25:53','2026-03-30 19:25:53'),(3,2,'J-33333333-3','Calzados Nike Venezuela','Calle 7, Zona Industrial Norte','0212-3333333','ventas@nike.com.ve','Carlos Méndez',1,'2026-03-30 19:25:53','2026-03-30 19:25:53'),(4,2,'J-44444444-4','Electrónica Samsung','Av. Libertador, Edif. Samsung','0212-4444444','soporte@samsung.com','Andrés López',1,'2026-03-30 19:25:53','2026-03-30 19:25:53'),(5,3,'J-55555555-5','Textiles Adidas','Calle 22, La Florida','0212-5555555','ventas@adidas.com.ve','Laura Paredes',1,'2026-03-30 19:25:53','2026-03-30 19:25:53');
/*!40000 ALTER TABLE `proveedores` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_audit_proveedores` AFTER UPDATE ON `proveedores` FOR EACH ROW BEGIN
    DECLARE v_usuario_id INT DEFAULT @app_user_id;
    INSERT INTO auditoria_integridad (tabla_origen, id_registro, tipo_evento, descripcion, usuario)
    VALUES ('proveedores', NEW.id, 'UPDATE',
            CONCAT('Proveedor: ', OLD.nombre, ' -> ', NEW.nombre, ' | RUC: ', OLD.ruc, ' -> ', NEW.ruc),
             IFNULL(v_usuario_id, CURRENT_USER())  -- fallback al usuario técnico
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rol_menu_permisos`
--

DROP TABLE IF EXISTS `rol_menu_permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol_menu_permisos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rol_id` int NOT NULL,
  `menu_id` int NOT NULL,
  `puede_ver` tinyint(1) DEFAULT '1',
  `puede_crear` tinyint(1) DEFAULT '0',
  `puede_editar` tinyint(1) DEFAULT '0',
  `puede_eliminar` tinyint(1) DEFAULT '0',
  `permisos_extra` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_rol_menu` (`rol_id`,`menu_id`),
  KEY `idx_rol` (`rol_id`),
  KEY `idx_menu` (`menu_id`),
  CONSTRAINT `rol_menu_permisos_ibfk_1` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rol_menu_permisos_ibfk_2` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol_menu_permisos`
--

LOCK TABLES `rol_menu_permisos` WRITE;
/*!40000 ALTER TABLE `rol_menu_permisos` DISABLE KEYS */;
INSERT INTO `rol_menu_permisos` VALUES (54,2,1,1,1,1,1,NULL,'2026-03-29 05:32:27','2026-03-29 05:32:27'),(55,6,2,1,1,1,1,NULL,'2026-03-30 22:03:32','2026-03-30 22:03:32');
/*!40000 ALTER TABLE `rol_menu_permisos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `permisos` json DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `idx_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Super Administrador','Acceso total al sistema','[\"*\"]',1,'2026-02-26 17:15:07','2026-02-26 17:15:07'),(2,'Administrador','Gestión del sistema sin permisos de super','[\"ver_dashboard\", \"gestionar_usuarios\", \"gestionar_roles\", \"ver_reportes\"]',1,'2026-02-26 17:15:07','2026-02-26 17:15:07'),(6,'Vendedor','Puede realizar ventas y consultas',NULL,1,'2026-03-30 19:45:52','2026-03-30 19:45:52');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unidades_medida`
--

DROP TABLE IF EXISTS `unidades_medida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unidades_medida` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abreviatura` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidades_medida`
--

LOCK TABLES `unidades_medida` WRITE;
/*!40000 ALTER TABLE `unidades_medida` DISABLE KEYS */;
INSERT INTO `unidades_medida` VALUES (1,'Unidad','ud',1),(2,'Kilogramo','kg',1),(3,'Litro','L',1);
/*!40000 ALTER TABLE `unidades_medida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_empresas`
--

DROP TABLE IF EXISTS `usuario_empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_empresas` (
  `usuario_id` int NOT NULL,
  `empresa_id` int NOT NULL,
  `es_predeterminada` tinyint(1) DEFAULT '0' COMMENT 'Empresa por defecto para el usuario',
  `fecha_asignacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usuario_id`,`empresa_id`),
  KEY `fk_ue_empresa` (`empresa_id`),
  CONSTRAINT `fk_ue_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ue_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_empresas`
--

LOCK TABLES `usuario_empresas` WRITE;
/*!40000 ALTER TABLE `usuario_empresas` DISABLE KEYS */;
INSERT INTO `usuario_empresas` VALUES (1,1,1,'2026-03-30 19:45:52'),(1,2,0,'2026-03-30 19:45:52'),(1,3,0,'2026-03-30 19:45:52'),(4,1,1,'2026-03-30 19:45:52'),(6,1,1,'2026-03-30 19:45:52');
/*!40000 ALTER TABLE `usuario_empresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_roles`
--

DROP TABLE IF EXISTS `usuario_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_roles` (
  `usuario_id` int NOT NULL,
  `rol_id` int NOT NULL,
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usuario_id`,`rol_id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_rol` (`rol_id`),
  CONSTRAINT `usuario_roles_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usuario_roles_ibfk_2` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_roles`
--

LOCK TABLES `usuario_roles` WRITE;
/*!40000 ALTER TABLE `usuario_roles` DISABLE KEYS */;
INSERT INTO `usuario_roles` VALUES (1,2,'2026-03-29 16:05:01'),(4,1,'2026-03-29 05:32:52'),(6,6,'2026-03-30 19:45:52');
/*!40000 ALTER TABLE `usuario_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cedula` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `img_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cedula` (`cedula`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_activo` (`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'V-12345678','Admin','Sistema','$2y$12$qW6cG.qtQaRYJZJlQONPh.osxuK1DTUk6sesmZCkfv3e89C18cAIm',NULL,'admin@sistema.com',NULL,1,'2026-02-26 17:15:08','2026-02-26 23:54:13'),(4,'13301699','Edgar','Boscan','$2y$10$okSkERYOlQEvHHMr63jbJOG1pVR9PnFl1HRUbvTKMkRAfiIAlB.ly','04246853071','edgarboscan@gmail.com','https://api.dicebear.com/9.x/avataaars-neutral/svg?seed=Jameson',1,'2026-02-27 15:55:43','2026-02-27 19:07:28'),(6,'V-99999999','Vendedor','Uno','$2y$10$ejemploHashAqui','0412-0000000','vendedor1@example.com',NULL,1,'2026-03-30 19:45:52','2026-03-30 19:45:52');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `ventas_detalle`
--

DROP TABLE IF EXISTS `ventas_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas_detalle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `venta_id` int NOT NULL,
  `producto_id` int NOT NULL,
  `cantidad` decimal(12,2) NOT NULL,
  `precio_venta` decimal(12,2) NOT NULL COMMENT 'Precio unitario al momento de la venta',
  `descuento` decimal(12,2) DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL,
  `impuesto` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_detalle_venta` (`venta_id`),
  KEY `fk_detalle_venta_producto` (`producto_id`),
  CONSTRAINT `fk_detalle_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_venta_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas_detalle`
--

LOCK TABLES `ventas_detalle` WRITE;
/*!40000 ALTER TABLE `ventas_detalle` DISABLE KEYS */;
INSERT INTO `ventas_detalle` VALUES (17,7,1,1.00,350.00,0.00,350.00,0.00,350.00),(18,7,3,30.00,2.50,0.00,75.00,0.00,75.00),(19,8,4,1.00,249.99,0.00,249.99,0.00,249.99),(20,8,9,1.00,149.99,50.00,149.99,0.00,99.99),(21,9,2,1.00,75.00,0.00,75.00,0.00,75.00),(22,9,5,1.00,23.00,0.00,23.00,0.00,23.00),(23,9,6,4.00,4.20,0.00,16.80,0.00,16.80),(24,10,4,1.00,239.00,0.00,239.00,0.00,239.00),(25,11,7,2.00,14.50,0.00,29.00,0.00,29.00),(26,11,8,1.00,29.00,0.00,29.00,0.00,29.00),(27,11,10,2.00,39.00,8.00,78.00,0.00,70.00),(28,11,12,1.00,58.00,0.00,58.00,0.00,58.00),(29,11,17,2.00,73.00,0.00,146.00,0.00,146.00),(30,12,11,50.00,1.20,0.00,60.00,0.00,60.00),(31,12,18,5.00,9.99,0.00,49.95,0.00,49.95),(32,12,20,3.00,14.99,0.00,44.97,0.00,44.97);
/*!40000 ALTER TABLE `ventas_detalle` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_venta_detalle_after_insert` AFTER INSERT ON `ventas_detalle` FOR EACH ROW trg_block: BEGIN
    DECLARE v_empresa_id INT;
    DECLARE v_tipo_producto ENUM('simple', 'compuesto');
    DECLARE v_maneja_inventario TINYINT(1);
    DECLARE v_compuesto_id INT;
    DECLARE v_cantidad_compuesto DECIMAL(12,4);
    DECLARE v_componente_id INT;
    DECLARE v_cantidad_componente DECIMAL(12,4);
    DECLARE v_cantidad_total_componente DECIMAL(12,4);
    DECLARE v_done INT DEFAULT 0;
    DECLARE cur_componentes CURSOR FOR
        SELECT producto_componente_id, cantidad
        FROM productos_componentes
        WHERE producto_compuesto_id = v_compuesto_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    SELECT empresa_id INTO v_empresa_id FROM ventas WHERE id = NEW.venta_id;
    SELECT tipo_producto, maneja_inventario INTO v_tipo_producto, v_maneja_inventario 
    FROM productos WHERE id = NEW.producto_id;
    
    -- Si no maneja inventario, salir
    IF v_maneja_inventario = 0 THEN
        LEAVE trg_block;
    END IF;
    
    IF v_tipo_producto = 'compuesto' THEN
        -- Producto compuesto: descontar sus componentes
        SET v_compuesto_id = NEW.producto_id;
        SET v_cantidad_compuesto = NEW.cantidad;

        OPEN cur_componentes;
        read_loop: LOOP
            FETCH cur_componentes INTO v_componente_id, v_cantidad_componente;
            IF v_done THEN
                LEAVE read_loop;
            END IF;
            SET v_cantidad_total_componente = v_cantidad_compuesto * v_cantidad_componente;
            -- Actualizar inventario del componente
            UPDATE inventario
            SET stock_actual = stock_actual - v_cantidad_total_componente,
                ultima_actualizacion = NOW()
            WHERE empresa_id = v_empresa_id AND producto_id = v_componente_id;
            -- Si el componente no existe en inventario, crearlo con stock negativo
            IF ROW_COUNT() = 0 THEN
                INSERT INTO inventario (empresa_id, producto_id, stock_actual, ultima_actualizacion)
                VALUES (v_empresa_id, v_componente_id, -v_cantidad_total_componente, NOW());
            END IF;
        END LOOP;
        CLOSE cur_componentes;
    ELSE
        -- Producto simple: descontar directamente su stock
        UPDATE inventario
        SET stock_actual = stock_actual - NEW.cantidad,
            ultima_actualizacion = NOW()
        WHERE empresa_id = v_empresa_id AND producto_id = NEW.producto_id;
        -- Si no existe, crearlo con stock negativo
        IF ROW_COUNT() = 0 THEN
            INSERT INTO inventario (empresa_id, producto_id, stock_actual, ultima_actualizacion)
            VALUES (v_empresa_id, NEW.producto_id, -NEW.cantidad, NOW());
        END IF;
    END IF;
END trg_block */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'ven_pos'
--

--
-- Dumping routines for database 'ven_pos'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_deuda_proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_deuda_proveedor`(p_proveedor_id INT) RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_deuda DECIMAL(12,2);
    SELECT IFNULL(SUM(saldo_pendiente), 0) INTO v_deuda
    FROM compras
    WHERE proveedor_id = p_proveedor_id AND estado IN ('PENDIENTE');
    RETURN v_deuda;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_get_menus_con_permisos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_get_menus_con_permisos`(
    p_usuario_id INT,
    p_is_super TINYINT
) RETURNS json
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_result JSON;
    
    -- Inicializar con array vacío
    SET v_result = JSON_ARRAY();
    
    IF p_is_super = 1 THEN
        -- SUPER: Ve todos los menús con todos los permisos
        SELECT IFNULL(
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', m.id,
                    'nombre', m.nombre,
                    'url', m.url,
                    'icono', m.icono,
                    'tipo_icono', m.tipo_icono,
                    'padre_id', m.padre_id,
                    'orden', m.orden,
                    'nivel', m.nivel,
                    'permisos', JSON_OBJECT(
                        'puede_ver', 1,
                        'puede_crear', 1,
                        'puede_editar', 1,
                        'puede_eliminar', 1
                    )
                )
            ),
            JSON_ARRAY()
        ) INTO v_result
        FROM menus m
        WHERE m.activo = 1
        ORDER BY m.nivel, m.orden;
        
    ELSE
        -- Usuario normal: Obtiene menús según sus roles
        -- PRIMERO: Obtener los menús únicos con sus permisos máximos usando una subconsulta
        SELECT IFNULL(
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', menu_data.id,
                    'nombre', menu_data.nombre,
                    'url', menu_data.url,
                    'icono', menu_data.icono,
                    'padre_id', menu_data.padre_id,
                    'orden', menu_data.orden,
                    'nivel', menu_data.nivel,
                    'permisos', JSON_OBJECT(
                        'puede_ver', menu_data.max_ver,
                        'puede_crear', menu_data.max_crear,
                        'puede_editar', menu_data.max_editar,
                        'puede_eliminar', menu_data.max_eliminar
                    )
                )
            ),
            JSON_ARRAY()
        ) INTO v_result
        FROM (
            SELECT DISTINCT
                m.id,
                m.nombre,
                m.url,
                m.icono,
                m.padre_id,
                m.orden,
                m.nivel,
                -- Usar MAX en una subconsulta separada
                (SELECT MAX(rmp2.puede_ver) FROM rol_menu_permisos rmp2 
                 WHERE rmp2.menu_id = m.id 
                 AND rmp2.rol_id IN (SELECT rol_id FROM usuario_roles WHERE usuario_id = p_usuario_id)
                ) AS max_ver,
                (SELECT MAX(rmp2.puede_crear) FROM rol_menu_permisos rmp2 
                 WHERE rmp2.menu_id = m.id 
                 AND rmp2.rol_id IN (SELECT rol_id FROM usuario_roles WHERE usuario_id = p_usuario_id)
                ) AS max_crear,
                (SELECT MAX(rmp2.puede_editar) FROM rol_menu_permisos rmp2 
                 WHERE rmp2.menu_id = m.id 
                 AND rmp2.rol_id IN (SELECT rol_id FROM usuario_roles WHERE usuario_id = p_usuario_id)
                ) AS max_editar,
                (SELECT MAX(rmp2.puede_eliminar) FROM rol_menu_permisos rmp2 
                 WHERE rmp2.menu_id = m.id 
                 AND rmp2.rol_id IN (SELECT rol_id FROM usuario_roles WHERE usuario_id = p_usuario_id)
                ) AS max_eliminar
            FROM menus m
            WHERE m.activo = 1
            AND EXISTS (
                SELECT 1 
                FROM rol_menu_permisos rmp
                INNER JOIN usuario_roles ur ON rmp.rol_id = ur.rol_id
                WHERE ur.usuario_id = p_usuario_id
                AND rmp.menu_id = m.id
                AND rmp.puede_ver = 1
            )
        ) AS menu_data
        ORDER BY menu_data.nivel, menu_data.orden;
    END IF;
    
    RETURN v_result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_saldo_cliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_saldo_cliente`(p_cliente_id INT) RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_saldo DECIMAL(12,2);
    SELECT IFNULL(SUM(saldo_pendiente), 0) INTO v_saldo
    FROM ventas
    WHERE cliente_id = p_cliente_id AND tipo_venta = 'CREDITO' AND estado = 'COMPLETADA';
    RETURN v_saldo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_stock_producto_compuesto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_stock_producto_compuesto`(p_producto_id INT, p_empresa_id INT) RETURNS decimal(12,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_stock_min DECIMAL(12,2) DEFAULT 99999999;
    DECLARE v_componente_id INT;
    DECLARE v_cantidad_componente DECIMAL(12,4);
    DECLARE v_stock_componente DECIMAL(12,2);
    DECLARE v_maneja_inventario TINYINT(1);
    DECLARE v_done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT producto_componente_id, cantidad
        FROM productos_componentes
        WHERE producto_compuesto_id = p_producto_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
    
    SELECT maneja_inventario INTO v_maneja_inventario FROM productos WHERE id = p_producto_id;
    
    IF v_maneja_inventario = 0 THEN
        RETURN NULL;
    END IF;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_componente_id, v_cantidad_componente;
        IF v_done THEN
            LEAVE read_loop;
        END IF;
        SELECT stock_actual INTO v_stock_componente
        FROM inventario
        WHERE empresa_id = p_empresa_id AND producto_id = v_componente_id;
        IF v_stock_componente IS NULL THEN
            SET v_stock_min = 0;
            LEAVE read_loop;
        END IF;
        SET v_stock_min = LEAST(v_stock_min, FLOOR(v_stock_componente / v_cantidad_componente));
    END LOOP;
    CLOSE cur;
    
    IF v_stock_min = 99999999 THEN
        SET v_stock_min = 0;
    END IF;
    
    RETURN v_stock_min;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_validar_stock_producto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_validar_stock_producto`(
    p_producto_id INT,
    p_empresa_id INT,
    p_cantidad DECIMAL(12,2)
) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_tipo_producto ENUM('simple', 'compuesto');
    DECLARE v_maneja_inventario TINYINT(1);
    DECLARE v_stock_actual DECIMAL(12,2);
    DECLARE v_componente_id INT;
    DECLARE v_cantidad_componente DECIMAL(12,4);
    DECLARE v_stock_componente DECIMAL(12,2);
    DECLARE v_done INT DEFAULT 0;
    DECLARE cur_comp CURSOR FOR
        SELECT producto_componente_id, cantidad
        FROM productos_componentes
        WHERE producto_compuesto_id = p_producto_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
    
    SELECT tipo_producto, maneja_inventario INTO v_tipo_producto, v_maneja_inventario
    FROM productos WHERE id = p_producto_id;
    
    IF v_maneja_inventario = 0 THEN
        RETURN 1; -- No gestiona inventario, siempre válido
    END IF;
    
    IF v_tipo_producto = 'compuesto' THEN
        OPEN cur_comp;
        comp_loop: LOOP
            FETCH cur_comp INTO v_componente_id, v_cantidad_componente;
            IF v_done THEN
                LEAVE comp_loop;
            END IF;
            SELECT stock_actual INTO v_stock_componente
            FROM inventario
            WHERE empresa_id = p_empresa_id AND producto_id = v_componente_id;
            IF v_stock_componente IS NULL OR v_stock_componente < (p_cantidad * v_cantidad_componente) THEN
                CLOSE cur_comp;
                RETURN 0;
            END IF;
        END LOOP;
        CLOSE cur_comp;
        RETURN 1;
    ELSE
        SELECT stock_actual INTO v_stock_actual
        FROM inventario
        WHERE empresa_id = p_empresa_id AND producto_id = p_producto_id;
        IF v_stock_actual IS NULL OR v_stock_actual < p_cantidad THEN
            RETURN 0;
        END IF;
        RETURN 1;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_auditoria_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditoria_json`(
    IN p_tabla VARCHAR(50),
    IN p_desde DATE,
    IN p_hasta DATE,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (a.descripcion LIKE "%', p_search, '%" OR a.usuario LIKE "%', p_search, '%")'),
        '');
    SET @tabla_cond = IF(p_tabla IS NOT NULL AND p_tabla != '', CONCAT(' AND a.tabla_origen = "', p_tabla, '"'), '');
    SET @fecha_cond = CONCAT(' AND (', IF(p_desde IS NOT NULL, CONCAT('DATE(a.fecha_auditoria) >= "', p_desde, '"'), '1=1'), ' AND ', IF(p_hasta IS NOT NULL, CONCAT('DATE(a.fecha_auditoria) <= "', p_hasta, '"'), '1=1'), ')');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM auditoria_integridad a
        WHERE 1=1
        ', @tabla_cond, @fecha_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", a.id_auditoria,
                "tabla", a.tabla_origen,
                "id_registro", a.id_registro,
                "evento", a.tipo_evento,
                "descripcion", a.descripcion,
                "fecha", a.fecha_auditoria,
                "usuario", a.usuario
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM auditoria_integridad a
        WHERE 1=1
        ', @tabla_cond, @fecha_cond, @search_cond, '
        ORDER BY a.fecha_auditoria DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiar_empresa_contexto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cambiar_empresa_contexto`(
    IN p_usuario_id INT,
    IN p_empresa_id INT
)
BEGIN
    DECLARE v_tiene_acceso INT;
    
    SELECT COUNT(*) INTO v_tiene_acceso
    FROM usuario_empresas
    WHERE usuario_id = p_usuario_id AND empresa_id = p_empresa_id;
    
    IF v_tiene_acceso = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'El usuario no tiene acceso a esta empresa'
        ) AS result;
    ELSE
        -- Establecer variable de sesión para el contexto actual
        SET @app_empresa_id = p_empresa_id;
        SET @app_usuario_id = p_usuario_id;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'message', 'Contexto cambiado',
            'empresa_id', p_empresa_id
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_categorias_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categorias_listar_json`(
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    -- Paginación
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    -- Total de registros
    SELECT COUNT(*) INTO v_total
    FROM categorias c
    WHERE (p_activo IS NULL OR c.activo = p_activo)
      AND (p_search IS NULL OR p_search = '' OR c.nombre LIKE CONCAT('%', p_search, '%'))
      OR (p_search IS NULL OR p_search = '' OR c.descripcion LIKE CONCAT('%', p_search, '%'));
    
    IF v_total = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', JSON_ARRAY(),
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', 0,
                'last_page', 0,
                'from', 0,
                'to', 0
            )
        ) AS result;
    ELSE
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', c.id,
                'nombre', c.nombre,
                'descripcion', c.descripcion,
                'activo', c.activo
            )
        ), JSON_ARRAY()) INTO v_result
        FROM categorias c
        WHERE (p_activo IS NULL OR c.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR c.nombre LIKE CONCAT('%', p_search, '%'))
           OR (p_search IS NULL OR p_search = '' OR c.descripcion LIKE CONCAT('%', p_search, '%'))
        ORDER BY c.nombre
        LIMIT v_offset, p_limit;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', v_result,
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', v_total,
                'last_page', CEIL(v_total / p_limit),
                'from', IF(v_total = 0, 0, v_offset + 1),
                'to', LEAST(v_offset + p_limit, v_total)
            )
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_categoria_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categoria_actualizar_json`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar categoría: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM categorias WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Categoría no encontrada') AS result;
    ELSE
        START TRANSACTION;
        UPDATE categorias
        SET nombre = IFNULL(p_nombre, nombre),
            descripcion = IFNULL(p_descripcion, descripcion),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Categoría actualizada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_categoria_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categoria_crear_json`(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear categoría: ', @text)) AS result;
    END;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO categorias (nombre, descripcion, activo)
        VALUES (p_nombre, p_descripcion, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Categoría creada', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_categoria_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categoria_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar categoría: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM categorias WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Categoría no encontrada') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM categorias WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Categoría eliminada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_categoria_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categoria_existe`(
    IN p_id INT,
    IN p_nombre VARCHAR(100)
)
    COMMENT 'Verifica si una categoría existe por id o nombre'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_nombre IS NULL OR p_nombre = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o nombre') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM categorias WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'descripcion', descripcion, 'activo', activo)
                INTO v_data FROM categorias WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM categorias WHERE nombre = p_nombre;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'descripcion', descripcion, 'activo', activo)
                INTO v_data FROM categorias WHERE nombre = p_nombre;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Categoría ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Categoría ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_categoria_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categoria_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'nombre', nombre,
        'descripcion', descripcion,
        'activo', activo
    ) INTO v_result
    FROM categorias WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Categoría no encontrada') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_clientes_credito_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_clientes_credito_json`(
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (c.nombre LIKE "%', p_search, '%" OR c.numero_documento LIKE "%', p_search, '%" OR c.telefono LIKE "%', p_search, '%")'),
        '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND c.empresa_id = ', p_empresa_id), '');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM clientes c
        WHERE c.saldo_credito > 0
        ', @empresa_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", c.id,
                "documento", c.numero_documento,
                "nombre", CONCAT(c.nombre, " ", IFNULL(c.apellido, "")),
                "telefono", c.telefono,
                "email", c.email,
                "limite_credito", c.limite_credito,
                "saldo_credito", c.saldo_credito
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM clientes c
        WHERE c.saldo_credito > 0
        ', @empresa_cond, @search_cond, '
        ORDER BY c.saldo_credito DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_clientes_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_clientes_listar_json`(
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_empresa_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere empresa_id') AS result;
    ELSE
        IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
        IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
        IF p_limit > 100 THEN SET p_limit = 100; END IF;
        SET v_offset = (p_page - 1) * p_limit;
        
        SELECT COUNT(*) INTO v_total
        FROM clientes c
        WHERE c.empresa_id = p_empresa_id
          AND (p_activo IS NULL OR c.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR c.nombre LIKE CONCAT('%', p_search, '%')
               OR c.numero_documento LIKE CONCAT('%', p_search, '%') OR c.email LIKE CONCAT('%', p_search, '%'));
        
        IF v_total = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'data', JSON_ARRAY(),
                'pagination', JSON_OBJECT('current_page', p_page, 'per_page', p_limit, 'total', 0, 'last_page', 0, 'from', 0, 'to', 0)) AS result;
        ELSE
            SELECT IFNULL(JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', c.id,
                    'tipo_documento', c.tipo_documento,
                    'numero_documento', c.numero_documento,
                    'nombre', c.nombre,
                    'apellido', c.apellido,
                    'direccion', c.direccion,
                    'telefono', c.telefono,
                    'email', c.email,
                    'limite_credito', c.limite_credito,
                    'saldo_credito', c.saldo_credito,
                    'activo', c.activo
                )
            ), JSON_ARRAY()) INTO v_result
            FROM clientes c
            WHERE c.empresa_id = p_empresa_id
              AND (p_activo IS NULL OR c.activo = p_activo)
              AND (p_search IS NULL OR p_search = '' OR c.nombre LIKE CONCAT('%', p_search, '%')
                   OR c.numero_documento LIKE CONCAT('%', p_search, '%') OR c.email LIKE CONCAT('%', p_search, '%'))
            ORDER BY c.nombre
            LIMIT v_offset, p_limit;
            
            SELECT JSON_OBJECT(
                'status', 'success',
                'data', v_result,
                'pagination', JSON_OBJECT(
                    'current_page', p_page,
                    'per_page', p_limit,
                    'total', v_total,
                    'last_page', CEIL(v_total / p_limit),
                    'from', IF(v_total = 0, 0, v_offset + 1),
                    'to', LEAST(v_offset + p_limit, v_total)
                )
            ) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cliente_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cliente_actualizar_json`(
    IN p_id INT,
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(20),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_limite_credito DECIMAL(12,2),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar cliente: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM clientes WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Cliente no encontrado') AS result;
    ELSE
        START TRANSACTION;
        UPDATE clientes
        SET tipo_documento = IFNULL(p_tipo_documento, tipo_documento),
            numero_documento = IFNULL(p_numero_documento, numero_documento),
            nombre = IFNULL(p_nombre, nombre),
            apellido = IFNULL(p_apellido, apellido),
            direccion = IFNULL(p_direccion, direccion),
            telefono = IFNULL(p_telefono, telefono),
            email = IFNULL(p_email, email),
            limite_credito = IFNULL(p_limite_credito, limite_credito),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Cliente actualizado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cliente_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cliente_crear_json`(
    IN p_empresa_id INT,
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(20),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_limite_credito DECIMAL(12,2),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear cliente: ', @text)) AS result;
    END;
    
    IF p_empresa_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere empresa_id') AS result;
    ELSEIF p_numero_documento IS NULL OR p_numero_documento = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El número de documento es obligatorio') AS result;
    ELSEIF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO clientes (empresa_id, tipo_documento, numero_documento, nombre, apellido, direccion, telefono, email, limite_credito, saldo_credito, activo)
        VALUES (p_empresa_id, p_tipo_documento, p_numero_documento, p_nombre, p_apellido, p_direccion, p_telefono, p_email, IFNULL(p_limite_credito, 0), 0, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Cliente creado', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cliente_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cliente_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar cliente: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM clientes WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Cliente no encontrado') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM clientes WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Cliente eliminado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cliente_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cliente_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'empresa_id', empresa_id,
        'tipo_documento', tipo_documento,
        'numero_documento', numero_documento,
        'nombre', nombre,
        'apellido', apellido,
        'direccion', direccion,
        'telefono', telefono,
        'email', email,
        'limite_credito', limite_credito,
        'saldo_credito', saldo_credito,
        'activo', activo
    ) INTO v_result
    FROM clientes WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Cliente no encontrado') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigos_productos_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigos_productos_listar_json`(
    IN p_producto_id INT,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_producto_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere producto_id') AS result;
    ELSE
        IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
        IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
        IF p_limit > 100 THEN SET p_limit = 100; END IF;
        SET v_offset = (p_page - 1) * p_limit;
        
        SELECT COUNT(*) INTO v_total
        FROM codigos_productos cp
        WHERE cp.producto_id = p_producto_id
          AND (p_search IS NULL OR p_search = '' OR cp.codigo LIKE CONCAT('%', p_search, '%'));
        
        IF v_total = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'data', JSON_ARRAY(),
                'pagination', JSON_OBJECT('current_page', p_page, 'per_page', p_limit, 'total', 0, 'last_page', 0, 'from', 0, 'to', 0)) AS result;
        ELSE
            SELECT IFNULL(JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', cp.id,
                    'producto_id', cp.producto_id,
                    'tipo_codigo', cp.tipo_codigo,
                    'codigo', cp.codigo,
                    'activo', cp.activo
                )
            ), JSON_ARRAY()) INTO v_result
            FROM codigos_productos cp
            WHERE cp.producto_id = p_producto_id
              AND (p_search IS NULL OR p_search = '' OR cp.codigo LIKE CONCAT('%', p_search, '%'))
            ORDER BY cp.id
            LIMIT v_offset, p_limit;
            
            SELECT JSON_OBJECT(
                'status', 'success',
                'data', v_result,
                'pagination', JSON_OBJECT(
                    'current_page', p_page,
                    'per_page', p_limit,
                    'total', v_total,
                    'last_page', CEIL(v_total / p_limit),
                    'from', IF(v_total = 0, 0, v_offset + 1),
                    'to', LEAST(v_offset + p_limit, v_total)
                )
            ) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_producto_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_producto_actualizar_json`(
    IN p_id INT,
    IN p_tipo_codigo VARCHAR(20),
    IN p_codigo VARCHAR(100),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar código: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM codigos_productos WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Código no encontrado') AS result;
    ELSE
        START TRANSACTION;
        UPDATE codigos_productos
        SET tipo_codigo = IFNULL(p_tipo_codigo, tipo_codigo),
            codigo = IFNULL(p_codigo, codigo),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Código actualizado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_producto_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_producto_crear_json`(
    IN p_producto_id INT,
    IN p_tipo_codigo VARCHAR(20),
    IN p_codigo VARCHAR(100),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear código: ', @text)) AS result;
    END;
    
    IF p_producto_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere producto_id') AS result;
    ELSEIF p_codigo IS NULL OR p_codigo = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El código es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO codigos_productos (producto_id, tipo_codigo, codigo, activo)
        VALUES (p_producto_id, p_tipo_codigo, p_codigo, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Código creado', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_producto_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_producto_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar código: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM codigos_productos WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Código no encontrado') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM codigos_productos WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Código eliminado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_producto_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_producto_existe`(
    IN p_id INT,
    IN p_codigo VARCHAR(100)
)
    COMMENT 'Verifica si un código de producto existe por id o código'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_codigo IS NULL OR p_codigo = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o código') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM codigos_productos WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'producto_id', producto_id, 'tipo_codigo', tipo_codigo, 'codigo', codigo, 'activo', activo)
                INTO v_data FROM codigos_productos WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM codigos_productos WHERE codigo = p_codigo;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'producto_id', producto_id, 'tipo_codigo', tipo_codigo, 'codigo', codigo, 'activo', activo)
                INTO v_data FROM codigos_productos WHERE codigo = p_codigo;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Código ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_codigo, '"')), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Código ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_codigo, '"')), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_codigo_producto_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_producto_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'producto_id', producto_id,
        'tipo_codigo', tipo_codigo,
        'codigo', codigo,
        'activo', activo
    ) INTO v_result
    FROM codigos_productos WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Código no encontrado') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_compras_por_periodo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_compras_por_periodo_json`(
    IN p_desde DATE,
    IN p_hasta DATE,
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_estado VARCHAR(20),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (pr.nombre LIKE "%', p_search, '%" OR c.numero_factura LIKE "%', p_search, '%")'),
        '');
    SET @estado_cond = IF(p_estado IS NOT NULL AND p_estado != '', CONCAT(' AND c.estado = "', p_estado, '"'), '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND c.empresa_id = ', p_empresa_id), '');
    SET @fecha_cond = CONCAT(' AND (', IF(p_desde IS NOT NULL, CONCAT('c.fecha_compra >= "', p_desde, '"'), '1=1'), ' AND ', IF(p_hasta IS NOT NULL, CONCAT('c.fecha_compra <= "', p_hasta, '"'), '1=1'), ')');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM compras c
        INNER JOIN proveedores pr ON c.proveedor_id = pr.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond, @estado_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", c.id,
                "fecha_compra", c.fecha_compra,
                "proveedor", pr.nombre,
                "numero_factura", c.numero_factura,
                "total", c.total,
                "saldo_pendiente", c.saldo_pendiente,
                "estado", c.estado
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM compras c
        INNER JOIN proveedores pr ON c.proveedor_id = pr.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond, @estado_cond, '
        ORDER BY c.fecha_compra DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_empresa_actualizar_json`(
    IN p_id INT,
    IN p_nombre VARCHAR(150),
    IN p_ruc VARCHAR(20),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_logo TEXT,
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar empresa: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM empresas WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Empresa no encontrada') AS result;
    ELSE
        START TRANSACTION;
        UPDATE empresas
        SET nombre = IFNULL(p_nombre, nombre),
            ruc = IFNULL(p_ruc, ruc),
            direccion = IFNULL(p_direccion, direccion),
            telefono = IFNULL(p_telefono, telefono),
            email = IFNULL(p_email, email),
            logo = IFNULL(p_logo, logo),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Empresa actualizada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_empresa_crear_json`(
    IN p_nombre VARCHAR(150),
    IN p_ruc VARCHAR(20),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_logo TEXT,
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear empresa: ', @text)) AS result;
    END;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO empresas (nombre, ruc, direccion, telefono, email, logo, activo)
        VALUES (p_nombre, p_ruc, p_direccion, p_telefono, p_email, p_logo, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Empresa creada', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_empresa_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar empresa: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM empresas WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Empresa no encontrada') AS result;
    ELSE
        START TRANSACTION;
        -- Borrado físico; si se prefiere lógico, cambiar a UPDATE activo=0
        DELETE FROM empresas WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Empresa eliminada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_empresa_existe`(
    IN p_id INT,
    IN p_ruc VARCHAR(20)
)
    COMMENT 'Verifica si una empresa existe por id o ruc'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_ruc IS NULL OR p_ruc = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o ruc') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM empresas WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'ruc', ruc, 'direccion', direccion, 'telefono', telefono, 'email', email, 'logo', logo, 'activo', activo)
                INTO v_data FROM empresas WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM empresas WHERE ruc = p_ruc;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'ruc', ruc, 'direccion', direccion, 'telefono', telefono, 'email', email, 'logo', logo, 'activo', activo)
                INTO v_data FROM empresas WHERE ruc = p_ruc;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Empresa ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('con ruc ', p_ruc)), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Empresa ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('con ruc ', p_ruc)), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_empresa_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_empresa_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'nombre', nombre,
        'ruc', ruc,
        'direccion', direccion,
        'telefono', telefono,
        'email', email,
        'logo', logo,
        'activo', activo
    ) INTO v_result
    FROM empresas WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Empresa no encontrada') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_formas_pago_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_formas_pago_listar_json`(
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SELECT COUNT(*) INTO v_total
    FROM formas_pago f
    WHERE (p_activo IS NULL OR f.activo = p_activo)
      AND (p_search IS NULL OR p_search = '' OR f.nombre LIKE CONCAT('%', p_search, '%'));
    
    IF v_total = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', JSON_ARRAY(),
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', 0,
                'last_page', 0,
                'from', 0,
                'to', 0
            )
        ) AS result;
    ELSE
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT('id', f.id, 'nombre', f.nombre, 'activo', f.activo)
        ), JSON_ARRAY()) INTO v_result
        FROM formas_pago f
        WHERE (p_activo IS NULL OR f.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR f.nombre LIKE CONCAT('%', p_search, '%'))
        ORDER BY f.nombre
        LIMIT v_offset, p_limit;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', v_result,
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', v_total,
                'last_page', CEIL(v_total / p_limit),
                'from', IF(v_total = 0, 0, v_offset + 1),
                'to', LEAST(v_offset + p_limit, v_total)
            )
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_forma_pago_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_forma_pago_actualizar_json`(
    IN p_id INT,
    IN p_nombre VARCHAR(50),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar forma de pago: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM formas_pago WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Forma de pago no encontrada') AS result;
    ELSE
        START TRANSACTION;
        UPDATE formas_pago
        SET nombre = IFNULL(p_nombre, nombre),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Forma de pago actualizada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_forma_pago_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_forma_pago_crear_json`(
    IN p_nombre VARCHAR(50),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear forma de pago: ', @text)) AS result;
    END;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO formas_pago (nombre, activo) VALUES (p_nombre, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Forma de pago creada', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_forma_pago_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_forma_pago_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar forma de pago: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM formas_pago WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Forma de pago no encontrada') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM formas_pago WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Forma de pago eliminada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_forma_pago_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_forma_pago_existe`(
    IN p_id INT,
    IN p_nombre VARCHAR(50)
)
    COMMENT 'Verifica si una forma de pago existe por id o nombre'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_nombre IS NULL OR p_nombre = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o nombre') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM formas_pago WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'activo', activo)
                INTO v_data FROM formas_pago WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM formas_pago WHERE nombre = p_nombre;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'activo', activo)
                INTO v_data FROM formas_pago WHERE nombre = p_nombre;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Forma de pago ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Forma de pago ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_forma_pago_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_forma_pago_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'activo', activo) INTO v_result
    FROM formas_pago WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Forma de pago no encontrada') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_configuracion_sistema` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_configuracion_sistema`(
    IN p_incluir_privadas TINYINT(1),
    IN p_filtro_grupo VARCHAR(100)
)
BEGIN
    DECLARE v_total_configuraciones INT;
    DECLARE v_total_grupos INT;
    
    -- Obtener JSON completo con metadata
    SELECT 
        JSON_OBJECT(
            'metadata', JSON_OBJECT(
                'total_grupos', (SELECT COUNT(DISTINCT grupo) FROM configuracion_sistema 
                                 WHERE (p_incluir_privadas = 1 OR es_publico = 1)
                                 AND (p_filtro_grupo IS NULL OR grupo = p_filtro_grupo)),
                'total_configuraciones', (SELECT COUNT(*) FROM configuracion_sistema 
                                         WHERE (p_incluir_privadas = 1 OR es_publico = 1)
                                         AND (p_filtro_grupo IS NULL OR grupo = p_filtro_grupo)),
                'fecha_generacion', NOW(),
                'version', (SELECT valor FROM configuracion_sistema WHERE clave = 'version' LIMIT 1),
                'entorno', (SELECT valor FROM configuracion_sistema WHERE clave = 'entorno' LIMIT 1)
            ),
            'grupos', JSON_OBJECTAGG(
                c.grupo,
                JSON_OBJECT(
                    'info', JSON_OBJECT(
                        'nombre', c.grupo,
                        'icono', g.icono,
                        'descripcion', g.descripcion,
                        'orden', g.orden,
                        'total_configuraciones', c.total_configs
                    ),
                    'configuraciones', c.configs_json
                )
            )
        ) AS configuracion_completa
    FROM (
        SELECT 
            c.grupo,
            MAX(g.icono) as icono,
            MAX(g.descripcion) as descripcion_grupo,
            MAX(g.orden) as orden_grupo,
            COUNT(*) as total_configs,
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'clave', c.clave,
                    'valor', CASE 
                        WHEN c.tipo_dato = 'json' AND c.valor IS NOT NULL 
                            THEN JSON_EXTRACT(c.valor, '$')
                        WHEN c.tipo_dato = 'booleano' THEN 
                            CASE WHEN c.valor IN ('1', 'true', 'True', 'TRUE') THEN true ELSE false END
                        WHEN c.tipo_dato = 'numero' AND c.valor REGEXP '^-?[0-9]+\.?[0-9]*$' 
                            THEN CAST(c.valor AS DECIMAL(20,6))
                        ELSE c.valor
                    END,
                    'tipo', c.tipo_dato,
                    'descripcion', c.descripcion,
                    'publico', c.es_publico = 1,
                    'editable', c.es_editable = 1,
                    'requerido', c.es_requerido = 1,
                    'valor_defecto', CASE 
                        WHEN c.valor_defecto IS NOT NULL AND c.tipo_dato = 'json' 
                            THEN JSON_EXTRACT(c.valor_defecto, '$')
                        ELSE c.valor_defecto
                    END,
                    'opciones', CASE 
                        WHEN c.opciones IS NOT NULL 
                            THEN JSON_EXTRACT(c.opciones, '$')
                        ELSE NULL
                    END,
                    'validacion', CASE 
                        WHEN c.validacion IS NOT NULL 
                            THEN JSON_EXTRACT(c.validacion, '$')
                        ELSE NULL
                    END,
                    'orden', c.orden,
                    'activo', c.activo = 1,
                    'fecha_actualizacion', c.fecha_actualizacion
                )
            ) as configs_json
        FROM configuracion_sistema c
        LEFT JOIN configuracion_grupos g ON c.grupo = g.nombre
        WHERE (p_incluir_privadas = 1 OR c.es_publico = 1)
            AND (p_filtro_grupo IS NULL OR c.grupo = p_filtro_grupo)
        GROUP BY c.grupo
        ORDER BY MAX(g.orden), MAX(c.orden)
    ) c
    LEFT JOIN configuracion_grupos g ON c.grupo = g.nombre
    GROUP BY c.grupo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_listar_empresas_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_empresas_json`(
    IN p_activo TINYINT(1),
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    -- Valores por defecto y límite máximo
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    -- Obtener total de registros con filtros
    SELECT COUNT(*) INTO v_total
    FROM empresas e
    WHERE (p_activo IS NULL OR e.activo = p_activo)
      AND (p_search IS NULL OR p_search = '' OR e.nombre LIKE CONCAT('%', p_search, '%') 
           OR e.ruc LIKE CONCAT('%', p_search, '%') OR e.email LIKE CONCAT('%', p_search, '%'));
    
    -- Si no hay registros, devolver array vacío
    IF v_total = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', JSON_ARRAY(),
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', 0,
                'last_page', 0,
                'from', 0,
                'to', 0
            )
        ) AS result;
    ELSE
        -- Obtener datos paginados
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', e.id,
                'nombre', e.nombre,
                'ruc', e.ruc,
                'direccion', e.direccion,
                'telefono', e.telefono,
                'email', e.email,
                'activo', e.activo
            )
        ), JSON_ARRAY()) INTO v_result
        FROM empresas e
        WHERE (p_activo IS NULL OR e.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR e.nombre LIKE CONCAT('%', p_search, '%') 
               OR e.ruc LIKE CONCAT('%', p_search, '%') OR e.email LIKE CONCAT('%', p_search, '%'))
        ORDER BY e.id
        LIMIT v_offset, p_limit;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', v_result,
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', v_total,
                'last_page', CEIL(v_total / p_limit),
                'from', IF(v_total = 0, 0, v_offset + 1),
                'to', LEAST(v_offset + p_limit, v_total)
            )
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_listar_empresas_usuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_empresas_usuario`(
    IN p_usuario_id INT,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (e.nombre LIKE "%', p_search, '%" OR e.ruc LIKE "%', p_search, '%")'),
        '');
    SET @usuario_cond = IF(p_usuario_id IS NOT NULL, CONCAT(' AND ue.usuario_id = ', p_usuario_id), '');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM usuario_empresas ue
        INNER JOIN empresas e ON ue.empresa_id = e.id
        WHERE 1=1
        ', @usuario_cond, @search_cond, ' AND e.activo = 1');
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", e.id,
                "nombre", e.nombre,
                "ruc", e.ruc,
                "predeterminada", ue.es_predeterminada
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM usuario_empresas ue
        INNER JOIN empresas e ON ue.empresa_id = e.id
        WHERE 1=1
        ', @usuario_cond, @search_cond, ' AND e.activo = 1
        ORDER BY ue.es_predeterminada DESC, e.nombre
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login`(
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE v_usuario_id INT;
    DECLARE v_password_hash VARCHAR(255);
    DECLARE v_activo TINYINT(1);
    DECLARE v_is_super TINYINT(1);
    DECLARE v_menus_json JSON;
    DECLARE v_roles_json JSON;
    DECLARE v_empresas_json JSON;
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count FROM usuarios WHERE email = p_email;
    
    IF v_count = 0 THEN
        DO SLEEP(1.5);
        SELECT JSON_OBJECT(
            'estado', 'error',
            'codigo', 'CREDENCIALES_INVALIDAS',
            'mensaje', 'Email o contraseña incorrectos',
            'metadata', JSON_OBJECT('timestamp', NOW())
        ) AS resultado;
    ELSE
        SELECT u.id, u.password, u.activo, (
            SELECT COUNT(*)  
            FROM roles r 
            INNER JOIN usuario_roles ur ON r.id = ur.rol_id 
            WHERE r.nombre = 'Super Administrador' AND ur.usuario_id = u.id
        ) INTO v_usuario_id, v_password_hash, v_activo, v_is_super
        FROM usuarios u
        WHERE email = p_email;
        
        IF v_activo = 0 THEN
            SELECT JSON_OBJECT(
                'estado', 'error',
                'codigo', 'CUENTA_INACTIVA',
                'mensaje', 'Usuario desactivado',
                'metadata', JSON_OBJECT('timestamp', NOW())
            ) AS resultado;
        ELSE
            -- Obtener menús
            SET v_menus_json = fn_get_menus_con_permisos(v_usuario_id, v_is_super);
            
            -- Obtener roles
            SELECT IFNULL(
                JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'id', r.id,
                        'nombre', r.nombre,
                        'descripcion', r.descripcion,
                        'permisos_globales', r.permisos
                    )
                ),
                JSON_ARRAY()
            ) INTO v_roles_json
            FROM roles r
            INNER JOIN usuario_roles ur ON r.id = ur.rol_id
            WHERE ur.usuario_id = v_usuario_id AND r.activo = 1;
            
            -- Obtener empresas asignadas al usuario
            SELECT IFNULL(
                JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'id', e.id,
                        'nombre', e.nombre,
                        'ruc', e.ruc,
                        'predeterminada', IFNULL(ue.es_predeterminada, 0)
                    )
                ),
                JSON_ARRAY()
            ) INTO v_empresas_json
            FROM empresas e
            INNER JOIN usuario_empresas ue ON e.id = ue.empresa_id
            WHERE ue.usuario_id = v_usuario_id AND e.activo = 1;
            
            SELECT JSON_OBJECT(
                'estado', 'exito',
                'requiere_verificacion', TRUE,
                'usuario', (
                    SELECT JSON_OBJECT(
                        'id', u.id,
                        'cedula', u.cedula,
                        'nombre', u.nombre,
                        'apellido', u.apellido,
                        'nombre_completo', CONCAT(u.nombre, ' ', u.apellido),
                        'email', u.email,
                        'telefono', u.telefono,
                        'img_url', u.img_url,
                        'activo', u.activo
                    )
                    FROM usuarios u
                    WHERE u.id = v_usuario_id
                ),
                'seguridad', JSON_OBJECT('password_hash', v_password_hash),
                'acceso', JSON_OBJECT(
                    'menus', v_menus_json,
                    'roles', v_roles_json,
                    'empresas', v_empresas_json
                ),
                'metadata', JSON_OBJECT(
                    'timestamp', NOW(),
                    'version', '1.0.0'
                )
            ) AS resultado;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marcas_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marcas_listar_json`(
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SELECT COUNT(*) INTO v_total
    FROM marcas m
    WHERE (p_activo IS NULL OR m.activo = p_activo)
      AND (p_search IS NULL OR p_search = '' OR m.nombre LIKE CONCAT('%', p_search, '%'));
    
    IF v_total = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', JSON_ARRAY(),
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', 0,
                'last_page', 0,
                'from', 0,
                'to', 0
            )
        ) AS result;
    ELSE
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT('id', m.id, 'nombre', m.nombre, 'activo', m.activo)
        ), JSON_ARRAY()) INTO v_result
        FROM marcas m
        WHERE (p_activo IS NULL OR m.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR m.nombre LIKE CONCAT('%', p_search, '%'))
        ORDER BY m.nombre
        LIMIT v_offset, p_limit;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', v_result,
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', v_total,
                'last_page', CEIL(v_total / p_limit),
                'from', IF(v_total = 0, 0, v_offset + 1),
                'to', LEAST(v_offset + p_limit, v_total)
            )
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marca_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marca_actualizar_json`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar marca: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM marcas WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Marca no encontrada') AS result;
    ELSE
        START TRANSACTION;
        UPDATE marcas
        SET nombre = IFNULL(p_nombre, nombre),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Marca actualizada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marca_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marca_crear_json`(
    IN p_nombre VARCHAR(100),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear marca: ', @text)) AS result;
    END;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO marcas (nombre, activo) VALUES (p_nombre, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Marca creada', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marca_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marca_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar marca: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM marcas WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Marca no encontrada') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM marcas WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Marca eliminada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marca_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marca_existe`(
    IN p_id INT,
    IN p_nombre VARCHAR(100)
)
    COMMENT 'Verifica si una marca existe por id o nombre'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_nombre IS NULL OR p_nombre = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o nombre') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM marcas WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'activo', activo)
                INTO v_data FROM marcas WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM marcas WHERE nombre = p_nombre;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'activo', activo)
                INTO v_data FROM marcas WHERE nombre = p_nombre;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Marca ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Marca ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_marca_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marca_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'activo', activo) INTO v_result
    FROM marcas WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Marca no encontrada') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagar_credito_cliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pagar_credito_cliente`(
    IN p_empresa_id INT,
    IN p_cliente_id INT,
    IN p_venta_id INT,
    IN p_monto DECIMAL(12,2),
    IN p_fecha_pago DATE,
    IN p_forma_pago VARCHAR(50)
)
BEGIN
    DECLARE v_saldo_venta DECIMAL(12,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', 'Error al registrar pago de cliente') AS result;
    END;
    
    START TRANSACTION;
    
    IF p_venta_id IS NOT NULL THEN
        SELECT saldo_pendiente INTO v_saldo_venta FROM ventas WHERE id = p_venta_id FOR UPDATE;
        IF p_monto > v_saldo_venta THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto supera el saldo pendiente de la venta';
        END IF;
    END IF;
    
    INSERT INTO pagos_clientes (empresa_id, cliente_id, venta_id, monto, fecha_pago, forma_pago)
    VALUES (p_empresa_id, p_cliente_id, p_venta_id, p_monto, p_fecha_pago, p_forma_pago);
    
    COMMIT;
    
    SELECT JSON_OBJECT('status', 'success', 'message', 'Pago de crédito registrado') AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagar_proveedor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pagar_proveedor`(
    IN p_empresa_id INT,
    IN p_proveedor_id INT,
    IN p_compra_id INT,
    IN p_monto DECIMAL(12,2),
    IN p_fecha_pago DATE,
    IN p_forma_pago VARCHAR(50)
)
BEGIN
    DECLARE v_saldo_compra DECIMAL(12,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', 'Error al registrar pago a proveedor') AS result;
    END;
    
    START TRANSACTION;
    
    IF p_compra_id IS NOT NULL THEN
        SELECT saldo_pendiente INTO v_saldo_compra FROM compras WHERE id = p_compra_id FOR UPDATE;
        IF p_monto > v_saldo_compra THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto supera el saldo pendiente de la compra';
        END IF;
    END IF;
    
    INSERT INTO pagos_proveedores (empresa_id, proveedor_id, compra_id, monto, fecha_pago, forma_pago)
    VALUES (p_empresa_id, p_proveedor_id, p_compra_id, p_monto, p_fecha_pago, p_forma_pago);
    
    COMMIT;
    
    SELECT JSON_OBJECT('status', 'success', 'message', 'Pago registrado') AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagos_clientes_periodo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pagos_clientes_periodo_json`(
    IN p_empresa_id INT,
    IN p_desde DATE,
    IN p_hasta DATE,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (CONCAT(c.nombre, " ", IFNULL(c.apellido, "")) LIKE "%', p_search, '%" OR pc.referencia LIKE "%', p_search, '%")'),
        '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND pc.empresa_id = ', p_empresa_id), '');
    SET @fecha_cond = CONCAT(' AND (', IF(p_desde IS NOT NULL, CONCAT('pc.fecha_pago >= "', p_desde, '"'), '1=1'), ' AND ', IF(p_hasta IS NOT NULL, CONCAT('pc.fecha_pago <= "', p_hasta, '"'), '1=1'), ')');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM pagos_clientes pc
        INNER JOIN clientes c ON pc.cliente_id = c.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", pc.id,
                "fecha_pago", pc.fecha_pago,
                "cliente", CONCAT(c.nombre, " ", IFNULL(c.apellido, "")),
                "monto", pc.monto,
                "forma_pago", pc.forma_pago,
                "referencia", pc.referencia,
                "venta_id", pc.venta_id
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM pagos_clientes pc
        INNER JOIN clientes c ON pc.cliente_id = c.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond, '
        ORDER BY pc.fecha_pago DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagos_proveedores_periodo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pagos_proveedores_periodo_json`(
    IN p_empresa_id INT,
    IN p_desde DATE,
    IN p_hasta DATE,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (pr.nombre LIKE "%', p_search, '%" OR pp.referencia LIKE "%', p_search, '%")'),
        '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND pp.empresa_id = ', p_empresa_id), '');
    SET @fecha_cond = CONCAT(' AND (', IF(p_desde IS NOT NULL, CONCAT('pp.fecha_pago >= "', p_desde, '"'), '1=1'), ' AND ', IF(p_hasta IS NOT NULL, CONCAT('pp.fecha_pago <= "', p_hasta, '"'), '1=1'), ')');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM pagos_proveedores pp
        INNER JOIN proveedores pr ON pp.proveedor_id = pr.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", pp.id,
                "fecha_pago", pp.fecha_pago,
                "proveedor", pr.nombre,
                "monto", pp.monto,
                "forma_pago", pp.forma_pago,
                "referencia", pp.referencia,
                "compra_id", pp.compra_id
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM pagos_proveedores pp
        INNER JOIN proveedores pr ON pp.proveedor_id = pr.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond, '
        ORDER BY pp.fecha_pago DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_productos_con_precios_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_productos_con_precios_json`(
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_categoria_id INT,
    IN p_marca_id INT,
    IN p_tipo_producto VARCHAR(20),
    IN p_page INT,
    IN p_limit INT,
    OUT p_mensaje VARCHAR(255),
    OUT p_codigo_resultado INT   
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    DECLARE v_search_cond VARCHAR(500);
    DECLARE v_cat_cond VARCHAR(100);
    DECLARE v_marca_cond VARCHAR(100);
    DECLARE v_tipo_cond VARCHAR(100);
    DECLARE v_error_message VARCHAR(255);
        
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('Error: ', v_error_message);
        SET p_codigo_resultado = 500;
    END;
    
    IF p_empresa_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere empresa_id') AS result;
            SET p_mensaje = 'Se requiere empresa_id';
			SET p_codigo_resultado = 400;
    ELSE
        -- Valores por defecto y límite máximo
        IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
        IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
        IF p_limit > 100 THEN SET p_limit = 100; END IF;
        SET v_offset = (p_page - 1) * p_limit;
        
        -- Construir condiciones de filtro
        SET v_search_cond = IF(p_search IS NOT NULL AND p_search != '',
            CONCAT(' AND (p.nombre LIKE "%', REPLACE(p_search, '"', '\\"'), '%" OR p.codigo_principal LIKE "%', REPLACE(p_search, '"', '\\"'), '%")'),
            '');
        SET v_cat_cond = IF(p_categoria_id IS NOT NULL, CONCAT(' AND p.categoria_id = ', p_categoria_id), '');
        SET v_marca_cond = IF(p_marca_id IS NOT NULL, CONCAT(' AND p.marca_id = ', p_marca_id), '');
        SET v_tipo_cond = IF(p_tipo_producto IS NOT NULL AND p_tipo_producto != '', CONCAT(' AND p.tipo_producto = "', p_tipo_producto, '"'), '');
        
        -- Obtener total de registros (con filtros)
        SET @sql_count = CONCAT('
            SELECT COUNT(*) INTO @v_total
            FROM productos p
            WHERE p.activo = 1
            ', v_search_cond, v_cat_cond, v_marca_cond, v_tipo_cond);
        PREPARE stmt_count FROM @sql_count;
        EXECUTE stmt_count;
        DEALLOCATE PREPARE stmt_count;
        SET v_total = @v_total;
        
        -- Si no hay registros, devolver array vacío
        IF v_total = 0 THEN
            SELECT JSON_OBJECT(
                'status', 'success',
                'data', JSON_ARRAY(),
                'pagination', JSON_OBJECT(
                    'current_page', p_page,
                    'per_page', p_limit,
                    'total', 0,
                    'last_page', 0,
                    'from', 0,
                    'to', 0
                )
            ) AS result;
        ELSE
            -- Construir la consulta para obtener datos paginados, usando una subconsulta que obtiene los IDs paginados
            SET @sql_data = CONCAT('
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        "id", fp.id,
                        "codigo", fp.codigo_principal,
                        "nombre", fp.nombre,
                        "descripcion", fp.descripcion,
                        "categoria_id", fp.categoria_id,
                        "categoria", c.nombre,
                        "marca_id", fp.marca_id,
                        "marca", m.nombre,
                        "unidad_medida_id", fp.unidad_medida_id,
                        "unidad_medida", um.nombre,
                        "unidad_medida_abreviatura", um.abreviatura,
                        "tipo", fp.tipo_producto,
                        "maneja_inventario", fp.maneja_inventario,
                        "stock_minimo", fp.stock_minimo,
                        "precio_compra", pr.precio_compra,
                        "precio_venta", pr.precio_venta,
                        "activo", pr.activo,
                        "utilidad_absoluta", IF(pr.precio_venta IS NOT NULL AND pr.precio_compra IS NOT NULL, 
                                                ROUND(pr.precio_venta - pr.precio_compra, 2), NULL),
                        "margen_sobre_costo", IF(pr.precio_compra IS NOT NULL AND pr.precio_compra != 0,
                                                ROUND((pr.precio_venta - pr.precio_compra) / pr.precio_compra * 100, 2), NULL),
                        "margen_sobre_venta", IF(pr.precio_venta IS NOT NULL AND pr.precio_venta != 0,
                                                ROUND((pr.precio_venta - pr.precio_compra) / pr.precio_venta * 100, 2), NULL),
                        "stock", IF(fp.tipo_producto = "compuesto" OR fp.maneja_inventario = 0, NULL, i.stock_actual),
                        "componentes", (
                            SELECT IFNULL(JSON_ARRAYAGG(
                                JSON_OBJECT(
                                    "id", pc.producto_componente_id,
                                    "nombre", p2.nombre,
                                    "cantidad", pc.cantidad
                                )
                            ), JSON_ARRAY())
                            FROM productos_componentes pc
                            INNER JOIN productos p2 ON pc.producto_componente_id = p2.id
                            WHERE pc.producto_compuesto_id = fp.id
                        ),
                        "precios", (
                            SELECT IFNULL(JSON_ARRAYAGG(
                                JSON_OBJECT(
                                    "id", price.id,
                                    "precio_compra", price.precio_compra,
                                    "precio_venta", price.precio_venta,
                                    "precio_oferta", price.precio_oferta,
                                    "fecha_inicio_oferta", price.fecha_inicio_oferta,
                                    "fecha_fin_oferta", price.fecha_fin_oferta,
                                    "activo", price.activo,
                                    "created_at", price.created_at,
                                    "updated_at", price.updated_at,
                                    "utilidad_absoluta", IF(price.precio_venta IS NOT NULL AND price.precio_compra IS NOT NULL, 
                                                ROUND(price.precio_venta - price.precio_compra, 2), NULL),
                        "margen_sobre_costo", IF(price.precio_compra IS NOT NULL AND price.precio_compra != 0,
                                                ROUND((price.precio_venta - price.precio_compra) / price.precio_compra * 100, 2), NULL),
                        "margen_sobre_venta", IF(price.precio_venta IS NOT NULL AND price.precio_venta != 0,
                                                ROUND((price.precio_venta - price.precio_compra) / price.precio_venta * 100, 2), NULL)
                                )
                            ), JSON_ARRAY())
                            FROM precios price
                            WHERE price.producto_id = fp.id AND price.empresa_id = ', p_empresa_id, '
                        ),
                        "codigos", (
                            SELECT IFNULL(JSON_ARRAYAGG(
                                JSON_OBJECT(
                                    "id", code.id,
                                    "tipo_codigo", code.tipo_codigo,
                                    "codigo", code.codigo,
                                    "activo", code.activo,
                                    "created_at", code.created_at
                                )
                            ), JSON_ARRAY())
                            FROM codigos_productos code
                            WHERE code.producto_id = fp.id
                        )
                    )
                ) INTO @v_result
                FROM (
                    SELECT p.id, p.codigo_principal, p.nombre, p.descripcion, p.tipo_producto, p.maneja_inventario, p.stock_minimo, p.categoria_id, p.marca_id, p.unidad_medida_id, p.activo
                    FROM productos p
                    WHERE p.activo = 1
                    ', v_search_cond, v_cat_cond, v_marca_cond, v_tipo_cond, '
                    ORDER BY p.id
                    LIMIT ', v_offset, ', ', p_limit, '
                ) AS fp
                LEFT JOIN categorias c ON fp.categoria_id = c.id
                LEFT JOIN unidades_medida um ON fp.unidad_medida_id = um.id
                LEFT JOIN marcas m ON fp.marca_id = m.id
                LEFT JOIN precios pr ON fp.id = pr.producto_id AND pr.empresa_id = ', p_empresa_id, ' AND pr.activo = 1
                LEFT JOIN inventario i ON fp.id = i.producto_id AND i.empresa_id = ', p_empresa_id);
            PREPARE stmt_data FROM @sql_data;
            EXECUTE stmt_data;
            DEALLOCATE PREPARE stmt_data;
            SET v_result = @v_result;
            
            SELECT JSON_OBJECT(
                'status', 'success',
                'data', IFNULL(v_result, JSON_ARRAY()),
                'pagination', JSON_OBJECT(
                    'current_page', p_page,
                    'per_page', p_limit,
                    'total', v_total,
                    'last_page', CEIL(v_total / p_limit),
                    'from', IF(v_total = 0, 0, v_offset + 1),
                    'to', LEAST(v_offset + p_limit, v_total)
                )
            ) AS result;
            
            SET p_mensaje = 'Listado obtenido exitosamente';
			SET p_codigo_resultado = 200;
            
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_productos_stock_minimo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_productos_stock_minimo_json`(
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (p.nombre LIKE "%', p_search, '%" OR p.codigo_principal LIKE "%', p_search, '%")'),
        '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND i.empresa_id = ', p_empresa_id), '');
    
    -- Total: solo productos simples que manejan inventario y cuyo stock está por debajo del mínimo
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM inventario i
        INNER JOIN productos p ON i.producto_id = p.id
        WHERE p.tipo_producto = "simple"
          AND p.maneja_inventario = 1
          AND i.stock_actual <= i.stock_minimo
        ', @empresa_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "producto_id", p.id,
                "producto", p.nombre,
                "codigo", p.codigo_principal,
                "stock_actual", i.stock_actual,
                "stock_minimo", i.stock_minimo,
                "diferencia", i.stock_minimo - i.stock_actual
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM inventario i
        INNER JOIN productos p ON i.producto_id = p.id
        WHERE p.tipo_producto = "simple"
          AND p.maneja_inventario = 1
          AND i.stock_actual <= i.stock_minimo
        ', @empresa_cond, @search_cond, '
        ORDER BY (i.stock_minimo - i.stock_actual) DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_producto_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_producto_actualizar_json`(
    IN p_id INT,
    IN p_codigo_principal VARCHAR(50),
    IN p_nombre VARCHAR(200),
    IN p_descripcion TEXT,
    IN p_categoria_id INT,
    IN p_marca_id INT,
    IN p_unidad_medida_id INT,
    IN p_tipo_producto VARCHAR(20),
    IN p_stock_minimo DECIMAL(12,2),
    IN p_maneja_inventario TINYINT(1),
    IN p_activo TINYINT(1),
    IN p_componentes JSON,  -- JSON array de componentes: [{"producto_componente_id": 10, "cantidad": 2}]
    IN p_precios JSON,  -- JSON array de precios: [{"precio_compra": 0.00,  "precio_venta": 0.00,  "precio_oferta": 0.00,  "fecha_inicio_oferta": y/m/d, "fecha_fin_oferta": y/m/d, "activo": 1 }]
    IN p_codigos JSON  -- JSON array de codigos: [{"tipo_codigo": 'EAN13', "codigo": 0000000, "Activo": 1}]
)
BEGIN
    DECLARE v_exists INT;
    DECLARE v_idx INT DEFAULT 0;
    DECLARE v_len INT;
    DECLARE v_comp_id INT;
    DECLARE v_comp_cantidad DECIMAL(12,4);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar producto: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM productos WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Producto no encontrado') AS result;
    ELSE
        START TRANSACTION;
        UPDATE productos
        SET codigo_principal = IFNULL(p_codigo_principal, codigo_principal),
            nombre = IFNULL(p_nombre, nombre),
            descripcion = IFNULL(p_descripcion, descripcion),
            categoria_id = IFNULL(p_categoria_id, categoria_id),
            marca_id = IFNULL(p_marca_id, marca_id),
            unidad_medida_id = IFNULL(p_unidad_medida_id, unidad_medida_id),
            tipo_producto = IFNULL(p_tipo_producto, tipo_producto),
            stock_minimo = IFNULL(p_stock_minimo, stock_minimo),
            maneja_inventario = IFNULL(p_maneja_inventario, maneja_inventario),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        
        -- Actualizar componentes si es compuesto
        IF p_tipo_producto = 'compuesto' THEN
            -- Eliminar componentes existentes
            DELETE FROM productos_componentes WHERE producto_compuesto_id = p_id;
            -- Insertar nuevos si vienen
            IF p_componentes IS NOT NULL AND JSON_LENGTH(p_componentes) > 0 THEN
                SET v_len = JSON_LENGTH(p_componentes);
                WHILE v_idx < v_len DO
                    SET v_comp_id = JSON_UNQUOTE(JSON_EXTRACT(p_componentes, CONCAT('$[', v_idx, '].producto_componente_id')));
                    SET v_comp_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_componentes, CONCAT('$[', v_idx, '].cantidad')));
                    INSERT INTO productos_componentes (producto_compuesto_id, producto_componente_id, cantidad)
                    VALUES (p_id, v_comp_id, v_comp_cantidad);
                    SET v_idx = v_idx + 1;
                END WHILE;
            END IF;
        END IF;
        
        -- Actualizar Precios
        
        IF p_precios IS NOT NULL AND JSON_LENGTH(p_precios) > 0 THEN
			DELETE FROM precios WHERE producto_id = p_id;
			SET v_len = JSON_LENGTH(p_precios);
            WHILE v_idx < v_len DO
				SET @v_precio_compra = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].precio_compra')));
                SET @v_precio_venta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].precio_venta')));
                SET @v_precio_oferta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].precio_oferta')));
                SET @v_fecha_inicio_oferta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].fecha_inicio_oferta')));
                SET @v_fecha_fin_oferta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].fecha_fin_oferta')));
                SET @v_activo = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].activo')));
                
                IF @v_fecha_inicio_oferta IS NULL THEN
					SET @v_fecha_inicio_oferta = '1900-01-01';
				END IF;
                
                IF @v_fecha_fin_oferta IS NULL THEN
					SET @v_fecha_fin_oferta = '1900-01-01';
				END IF;
                
                INSERT INTO `ven_pos`.`precios`
					(`empresa_id`, `producto_id`, `precio_compra`, `precio_venta`, `precio_oferta`, `fecha_inicio_oferta`,
                    `fecha_fin_oferta`, `activo`) 
				VALUES(@app_empresa_id, v_id,  @v_precio_compra, @v_precio_venta, @v_precio_oferta, @v_fecha_inicio_oferta, 
					@v_fecha_fin_oferta, @v_activo);                
                SET v_idx = v_idx + 1;
            END WHILE;
        END IF;
        
        -- Actualizar Codigos
        IF p_codigos IS NOT NULL AND JSON_LENGTH(p_codigos) > 0 THEN
			DELETE FROM codigos_productos WHERE producto_id = p_id;
			SET v_len = JSON_LENGTH(p_codigos);
            WHILE v_idx < v_len DO
				SET @v_tipo_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_codigos, CONCAT('$[', v_idx, '].tipo_codigo')));
                SET @v_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_codigos, CONCAT('$[', v_idx, '].codigo')));
                SET @v_activo = JSON_UNQUOTE(JSON_EXTRACT(p_codigos, CONCAT('$[', v_idx, '].activo')));
                INSERT INTO `ven_pos`.`codigos_productos` 
					(`producto_id`, `tipo_codigo`, `codigo`, `activo`) 
                    VALUES(v_id, @v_tipo_codigo, @v_codigo, @v_activo);

                SET v_idx = v_idx + 1;
            END WHILE;
        END IF;
                
        
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Producto actualizado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_producto_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_producto_crear_json`(
    IN p_codigo_principal VARCHAR(50),
    IN p_nombre VARCHAR(200),
    IN p_descripcion TEXT,
    IN p_categoria_id INT,
    IN p_marca_id INT,
    IN p_unidad_medida_id INT,
    IN p_tipo_producto VARCHAR(20),
    IN p_stock_minimo DECIMAL(12,2),
    IN p_maneja_inventario TINYINT(1),
    IN p_activo TINYINT(1),
    IN p_componentes JSON,  -- JSON array de componentes: [{"producto_componente_id": 10, "cantidad": 2}]
    IN p_precios JSON,  -- JSON array de precios: [{"precio_compra": 0.00,  "precio_venta": 0.00,  "precio_oferta": 0.00,  "fecha_inicio_oferta": y/m/d, "fecha_fin_oferta": y/m/d, "activo": 1 }]
    IN p_codigos JSON  -- JSON array de codigos: [{"tipo_codigo": 'EAN13', "codigo": 0000000, "Activo": 1}]
)
BEGIN
    DECLARE v_id INT;
    DECLARE v_idx INT DEFAULT 0;
    DECLARE v_len INT;
    DECLARE v_comp_id INT;
    DECLARE v_comp_cantidad DECIMAL(12,4);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear producto: ', @text)) AS result;
    END;
    IF (@app_empresa_id IS NULL) THEN
		ROLLBACK;
		SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('La empresa es requerida: ', @text)) AS result;

    ELSE
    
    
    IF p_codigo_principal IS NULL OR p_codigo_principal = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El código principal es obligatorio') AS result;
    ELSEIF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO productos (codigo_principal, nombre, descripcion, categoria_id, marca_id, unidad_medida_id,
                               tipo_producto, stock_minimo, maneja_inventario, activo)
        VALUES (p_codigo_principal, p_nombre, p_descripcion, p_categoria_id, p_marca_id, p_unidad_medida_id,
                IFNULL(p_tipo_producto, 'simple'), IFNULL(p_stock_minimo, 0), IFNULL(p_maneja_inventario, 1), IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        
        -- Si es compuesto, insertar componentes
        IF p_tipo_producto = 'compuesto' AND p_componentes IS NOT NULL AND JSON_LENGTH(p_componentes) > 0 THEN
            SET v_len = JSON_LENGTH(p_componentes);
            WHILE v_idx < v_len DO
                SET v_comp_id = JSON_UNQUOTE(JSON_EXTRACT(p_componentes, CONCAT('$[', v_idx, '].producto_componente_id')));
                SET v_comp_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_componentes, CONCAT('$[', v_idx, '].cantidad')));
                INSERT INTO productos_componentes (producto_compuesto_id, producto_componente_id, cantidad)
                VALUES (v_id, v_comp_id, v_comp_cantidad);
                SET v_idx = v_idx + 1;
            END WHILE;
        END IF;
        
        IF p_precios IS NOT NULL AND JSON_LENGTH(p_precios) > 0 THEN
			SET v_len = JSON_LENGTH(p_precios);
            WHILE v_idx < v_len DO
				SET @v_precio_compra = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].precio_compra')));
                SET @v_precio_venta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].precio_venta')));
                SET @v_precio_oferta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].precio_oferta')));
                SET @v_fecha_inicio_oferta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].fecha_inicio_oferta')));
                SET @v_fecha_fin_oferta = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].fecha_fin_oferta')));
                SET @v_activo = JSON_UNQUOTE(JSON_EXTRACT(p_precios, CONCAT('$[', v_idx, '].activo')));
                
                IF @v_fecha_inicio_oferta IS NULL THEN
					SET @v_fecha_inicio_oferta = '1900-01-01';
				END IF;
                
                IF @v_fecha_fin_oferta IS NULL THEN
					SET @v_fecha_fin_oferta = '1900-01-01';
				END IF;
                
                INSERT INTO `ven_pos`.`precios`
					(`empresa_id`, `producto_id`, `precio_compra`, `precio_venta`, `precio_oferta`, `fecha_inicio_oferta`,
                    `fecha_fin_oferta`, `activo`) 
				VALUES(@app_empresa_id, v_id,  @v_precio_compra, @v_precio_venta, @v_precio_oferta, @v_fecha_inicio_oferta, 
					@v_fecha_fin_oferta, @v_activo);                
                SET v_idx = v_idx + 1;
            END WHILE;
        END IF;
        
        IF p_codigos IS NOT NULL AND JSON_LENGTH(p_codigos) > 0 THEN
			SET v_len = JSON_LENGTH(p_codigos);
            WHILE v_idx < v_len DO
				SET @v_tipo_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_codigos, CONCAT('$[', v_idx, '].tipo_codigo')));
                SET @v_codigo = JSON_UNQUOTE(JSON_EXTRACT(p_codigos, CONCAT('$[', v_idx, '].codigo')));
                SET @v_activo = JSON_UNQUOTE(JSON_EXTRACT(p_codigos, CONCAT('$[', v_idx, '].activo')));
                INSERT INTO `ven_pos`.`codigos_productos` 
					(`producto_id`, `tipo_codigo`, `codigo`, `activo`) 
                    VALUES(v_id, @v_tipo_codigo, @v_codigo, @v_activo);

                SET v_idx = v_idx + 1;
            END WHILE;
        END IF;
        
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Producto creado', 'id', v_id) AS result;
    END IF;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_producto_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_producto_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar producto: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM productos WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Producto no encontrado') AS result;
    ELSE
        START TRANSACTION;
        -- Borrado físico (cascada elimina componentes, códigos, precios, inventario)
        DELETE FROM productos WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Producto eliminado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_producto_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_producto_existe`(
    IN p_id INT,
    IN p_codigo VARCHAR(50)
)
    COMMENT 'Verifica si un producto existe por su id o codigo. Devuelve JSON con estado y datos.'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT(
            'status', 'error',
            'codigo', '500',
            'message', v_error_message
        ) AS result;
    END;
    
    -- Validar que al menos un parámetro sea válido
    IF (p_id IS NULL OR p_id <= 0) AND (p_codigo IS NULL OR p_codigo = '') THEN
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'Debe proporcionar al menos un id válido o un código para buscar'
        ) AS result;
    ELSE
        -- Buscar por ID si se proporciona y es válido
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM productos WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT(
                    'id', id,
                    'codigo_principal', codigo_principal,
                    'nombre', nombre,
                    'descripcion', descripcion,
                    'activo', activo
                ) INTO v_data
                FROM productos WHERE id = p_id;
            END IF;
        ELSE
            -- Buscar por código exacto (mejor que LIKE para existencia)
            SELECT COUNT(*) INTO v_existe FROM productos WHERE codigo_principal = p_codigo;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT(
                    'id', id,
                    'codigo_principal', codigo_principal,
                    'nombre', nombre,
                    'descripcion', descripcion,
                    'activo', activo
                ) INTO v_data
                FROM productos WHERE codigo_principal = p_codigo;
            END IF;
        END IF;
        
        -- Preparar respuesta
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT(
                'status', 'success',
                'message', CONCAT(
                    'Producto ',
                    IF(p_id IS NOT NULL AND p_id > 0, CONCAT('con id ', p_id), CONCAT('con código ', p_codigo)),
                    ' no existe. Disponible'
                ),
                'exists', FALSE,
                'data', NULL
            ) AS result;
        ELSE
            SELECT JSON_OBJECT(
                'status', 'success',
                'message', CONCAT(
                    'Producto ',
                    IF(p_id IS NOT NULL AND p_id > 0, CONCAT('con id ', p_id), CONCAT('con código ', p_codigo)),
                    ' ya existe'
                ),
                'exists', TRUE,
                'data', v_data
            ) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_producto_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_producto_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', p.id,
        'codigo_principal', p.codigo_principal,
        'nombre', p.nombre,
        'descripcion', p.descripcion,
        'categoria_id', p.categoria_id,
        'marca_id', p.marca_id,
        'unidad_medida_id', p.unidad_medida_id,
        'tipo_producto', p.tipo_producto,
        'stock_minimo', p.stock_minimo,
        'maneja_inventario', p.maneja_inventario,
        'activo', p.activo,
        'utilidad_absoluta', IF(pr.precio_venta IS NOT NULL AND pr.precio_compra IS NOT NULL, 
			ROUND(pr.precio_venta - pr.precio_compra, 2), NULL),
         'margen_sobre_costo', IF(pr.precio_compra IS NOT NULL AND pr.precio_compra != 0,
			ROUND((pr.precio_venta - pr.precio_compra) / pr.precio_compra * 100, 2), NULL),
         'margen_sobre_venta', IF(pr.precio_venta IS NOT NULL AND pr.precio_venta != 0,
			ROUND((pr.precio_venta - pr.precio_compra) / pr.precio_venta * 100, 2), NULL),
         'stock', IF(p.tipo_producto = "compuesto" OR p.maneja_inventario = 0, NULL, i.stock_actual),
         'componentes', (
            SELECT IFNULL(JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', pc.id,
                    'producto_componente_id', pc.producto_componente_id,
                    'nombre', p2.nombre,
                    'cantidad', pc.cantidad
                )
            ), JSON_ARRAY())
            FROM productos_componentes pc
            INNER JOIN productos p2 ON pc.producto_componente_id = p2.id
            WHERE pc.producto_compuesto_id = p.id
        ),
         'precios', (
			SELECT IFNULL(JSON_ARRAYAGG(
				JSON_OBJECT(
                                    "id", price.id,
                                    "precio_compra", price.precio_compra,
                                    "precio_venta", price.precio_venta,
                                    "precio_oferta", price.precio_oferta,
                                    "fecha_inicio_oferta", price.fecha_inicio_oferta,
                                    "fecha_fin_oferta", price.fecha_fin_oferta,
                                    "activo", price.activo,
                                    "created_at", price.created_at,
                                    "updated_at", price.updated_at,
                                    "utilidad_absoluta", IF(price.precio_venta IS NOT NULL AND price.precio_compra IS NOT NULL, 
                                                ROUND(price.precio_venta - price.precio_compra, 2), NULL),
                        "margen_sobre_costo", IF(price.precio_compra IS NOT NULL AND price.precio_compra != 0,
                                                ROUND((price.precio_venta - price.precio_compra) / price.precio_compra * 100, 2), NULL),
                        "margen_sobre_venta", IF(price.precio_venta IS NOT NULL AND price.precio_venta != 0,
                                                ROUND((price.precio_venta - price.precio_compra) / price.precio_venta * 100, 2), NULL)
                                )
			), JSON_ARRAY())
			FROM precios price
			WHERE price.producto_id = p.id AND price.empresa_id = @app_empresa_id
         ),
		 'codigos', (
			SELECT IFNULL(JSON_ARRAYAGG(
				JSON_OBJECT(
            "id", code.id,
            "tipo_codigo", code.tipo_codigo,
            "codigo", code.codigo,
            "activo", code.activo,
            "created_at", code.created_at
           )), JSON_ARRAY())
           FROM codigos_productos code
           WHERE code.producto_id = p.id
                        )
    ) INTO v_result
    FROM productos p 
    LEFT JOIN precios pr ON p.id = pr.producto_id AND pr.empresa_id = @app_empresa_id AND pr.activo = 1
    LEFT JOIN inventario i ON p.id = i.producto_id AND i.empresa_id = @app_empresa_id 
    WHERE p.id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Producto no encontrado') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedores_deuda_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedores_deuda_json`(
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (p.nombre LIKE "%', p_search, '%" OR p.ruc LIKE "%', p_search, '%" OR p.contacto_nombre LIKE "%', p_search, '%")'),
        '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND p.empresa_id = ', p_empresa_id), '');
    
    -- Total (proveedores con deuda)
    SET @sql_count = CONCAT('
        SELECT COUNT(DISTINCT p.id) INTO @v_total
        FROM proveedores p
        INNER JOIN compras c ON p.id = c.proveedor_id
        WHERE c.saldo_pendiente > 0
        ', @empresa_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", p.id,
                "ruc", p.ruc,
                "nombre", p.nombre,
                "telefono", p.telefono,
                "email", p.email,
                "contacto", p.contacto_nombre,
                "deuda_total", total_deuda
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM (
            SELECT p.id, p.ruc, p.nombre, p.telefono, p.email, p.contacto_nombre,
                   SUM(c.saldo_pendiente) AS total_deuda
            FROM proveedores p
            INNER JOIN compras c ON p.id = c.proveedor_id
            WHERE c.saldo_pendiente > 0
              ', @empresa_cond, @search_cond, '
            GROUP BY p.id
            ORDER BY total_deuda DESC
            LIMIT ', v_offset, ', ', p_limit, '
        ) AS p');
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedores_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedores_listar_json`(
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_empresa_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere empresa_id') AS result;
    ELSE
        IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
        IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
        IF p_limit > 100 THEN SET p_limit = 100; END IF;
        SET v_offset = (p_page - 1) * p_limit;
        
        SELECT COUNT(*) INTO v_total
        FROM proveedores p
        WHERE p.empresa_id = p_empresa_id
          AND (p_activo IS NULL OR p.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR p.nombre LIKE CONCAT('%', p_search, '%')
               OR p.ruc LIKE CONCAT('%', p_search, '%') OR p.contacto_nombre LIKE CONCAT('%', p_search, '%'));
        
        IF v_total = 0 THEN
            SELECT JSON_OBJECT(
                'status', 'success',
                'data', JSON_ARRAY(),
                'pagination', JSON_OBJECT(
                    'current_page', p_page,
                    'per_page', p_limit,
                    'total', 0,
                    'last_page', 0,
                    'from', 0,
                    'to', 0
                )
            ) AS result;
        ELSE
            SELECT IFNULL(JSON_ARRAYAGG(
                JSON_OBJECT(
                    'id', p.id,
                    'ruc', p.ruc,
                    'nombre', p.nombre,
                    'direccion', p.direccion,
                    'telefono', p.telefono,
                    'email', p.email,
                    'contacto_nombre', p.contacto_nombre,
                    'activo', p.activo
                )
            ), JSON_ARRAY()) INTO v_result
            FROM proveedores p
            WHERE p.empresa_id = p_empresa_id
              AND (p_activo IS NULL OR p.activo = p_activo)
              AND (p_search IS NULL OR p_search = '' OR p.nombre LIKE CONCAT('%', p_search, '%')
                   OR p.ruc LIKE CONCAT('%', p_search, '%') OR p.contacto_nombre LIKE CONCAT('%', p_search, '%'))
            ORDER BY p.nombre
            LIMIT v_offset, p_limit;
            
            SELECT JSON_OBJECT(
                'status', 'success',
                'data', v_result,
                'pagination', JSON_OBJECT(
                    'current_page', p_page,
                    'per_page', p_limit,
                    'total', v_total,
                    'last_page', CEIL(v_total / p_limit),
                    'from', IF(v_total = 0, 0, v_offset + 1),
                    'to', LEAST(v_offset + p_limit, v_total)
                )
            ) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedor_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedor_actualizar_json`(
    IN p_id INT,
    IN p_ruc VARCHAR(20),
    IN p_nombre VARCHAR(150),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_contacto_nombre VARCHAR(100),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar proveedor: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM proveedores WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Proveedor no encontrado') AS result;
    ELSE
        START TRANSACTION;
        UPDATE proveedores
        SET ruc = IFNULL(p_ruc, ruc),
            nombre = IFNULL(p_nombre, nombre),
            direccion = IFNULL(p_direccion, direccion),
            telefono = IFNULL(p_telefono, telefono),
            email = IFNULL(p_email, email),
            contacto_nombre = IFNULL(p_contacto_nombre, contacto_nombre),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Proveedor actualizado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedor_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedor_crear_json`(
    IN p_empresa_id INT,
    IN p_ruc VARCHAR(20),
    IN p_nombre VARCHAR(150),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_contacto_nombre VARCHAR(100),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear proveedor: ', @text)) AS result;
    END;
    
    IF p_empresa_id IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Se requiere empresa_id') AS result;
    ELSEIF p_ruc IS NULL OR p_ruc = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El RUC es obligatorio') AS result;
    ELSEIF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO proveedores (empresa_id, ruc, nombre, direccion, telefono, email, contacto_nombre, activo)
        VALUES (p_empresa_id, p_ruc, p_nombre, p_direccion, p_telefono, p_email, p_contacto_nombre, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Proveedor creado', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedor_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedor_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar proveedor: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM proveedores WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Proveedor no encontrado') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM proveedores WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Proveedor eliminado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedor_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedor_existe`(
    IN p_id INT,
    IN p_ruc VARCHAR(20)
)
    COMMENT 'Verifica si un proveedor existe por id o ruc'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_ruc IS NULL OR p_ruc = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o ruc') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM proveedores WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'empresa_id', empresa_id, 'ruc', ruc, 'nombre', nombre, 'direccion', direccion, 'telefono', telefono, 'email', email, 'contacto_nombre', contacto_nombre, 'activo', activo)
                INTO v_data FROM proveedores WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM proveedores WHERE ruc = p_ruc;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'empresa_id', empresa_id, 'ruc', ruc, 'nombre', nombre, 'direccion', direccion, 'telefono', telefono, 'email', email, 'contacto_nombre', contacto_nombre, 'activo', activo)
                INTO v_data FROM proveedores WHERE ruc = p_ruc;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Proveedor ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('con ruc ', p_ruc)), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Proveedor ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('con ruc ', p_ruc)), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_proveedor_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proveedor_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'empresa_id', empresa_id,
        'ruc', ruc,
        'nombre', nombre,
        'direccion', direccion,
        'telefono', telefono,
        'email', email,
        'contacto_nombre', contacto_nombre,
        'activo', activo
    ) INTO v_result
    FROM proveedores WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Proveedor no encontrado') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_compra`(
    IN p_empresa_id INT,
    IN p_proveedor_id INT,
    IN p_numero_factura VARCHAR(50),
    IN p_fecha_compra DATE,
    IN p_detalle JSON
)
BEGIN
    DECLARE v_total DECIMAL(12,2) DEFAULT 0;
    DECLARE v_subtotal DECIMAL(12,2) DEFAULT 0;
    DECLARE v_compra_id INT;
    DECLARE v_idx INT DEFAULT 0;
    DECLARE v_len INT;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad DECIMAL(12,2);
    DECLARE v_precio DECIMAL(12,2);
    DECLARE v_line_subtotal DECIMAL(12,2);
    DECLARE v_tipo_producto ENUM('simple', 'compuesto');
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', CONCAT('Error al registrar compra: ', @text),
            'sqlstate', @sqlstate,
            'errno', @errno
        ) AS result;
    END;
    
    START TRANSACTION;
    
    -- Validar que todos los productos en la compra sean simples
    SET v_len = JSON_LENGTH(p_detalle);
    WHILE v_idx < v_len DO
        SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].producto_id')));
        SELECT tipo_producto INTO v_tipo_producto FROM productos WHERE id = v_producto_id;
        IF v_tipo_producto = 'compuesto' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pueden comprar productos compuestos directamente';
        END IF;
        SET v_idx = v_idx + 1;
    END WHILE;
    
    -- Calcular totales
    SET v_idx = 0;
    WHILE v_idx < v_len DO
        SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].producto_id')));
        SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].cantidad')));
        SET v_precio = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].precio_compra')));
        
        SET v_line_subtotal = v_cantidad * v_precio;
        SET v_subtotal = v_subtotal + v_line_subtotal;
        SET v_total = v_total + v_line_subtotal;
        
        SET v_idx = v_idx + 1;
    END WHILE;
    
    -- Insertar cabecera
    INSERT INTO compras (empresa_id, proveedor_id, numero_factura, fecha_compra, subtotal, total, saldo_pendiente, estado)
    VALUES (p_empresa_id, p_proveedor_id, p_numero_factura, p_fecha_compra, v_subtotal, v_total, v_total, 'PENDIENTE');
    
    SET v_compra_id = LAST_INSERT_ID();
    
    -- Insertar detalle y actualizar inventario
    SET v_idx = 0;
    WHILE v_idx < v_len DO
        SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].producto_id')));
        SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].cantidad')));
        SET v_precio = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].precio_compra')));
        SET v_line_subtotal = v_cantidad * v_precio;
        
        INSERT INTO compras_detalle (compra_id, producto_id, cantidad, precio_compra, subtotal, total)
        VALUES (v_compra_id, v_producto_id, v_cantidad, v_precio, v_line_subtotal, v_line_subtotal);
        
        -- Actualizar precio de compra en tabla precios (para producto simple)
        UPDATE precios 
        SET precio_compra = v_precio, updated_at = NOW()
        WHERE empresa_id = p_empresa_id AND producto_id = v_producto_id;
        
        SET v_idx = v_idx + 1;
    END WHILE;
    
    COMMIT;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'message', 'Compra registrada',
        'compra_id', v_compra_id,
        'total', v_total
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_venta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_venta`(
    IN p_usuario_id INT,
    IN p_empresa_id INT,
    IN p_cliente_id INT,
    IN p_tipo_venta VARCHAR(10),
    IN p_detalle JSON
)
BEGIN
    DECLARE v_total DECIMAL(12,2) DEFAULT 0;
    DECLARE v_subtotal DECIMAL(12,2) DEFAULT 0;
    DECLARE v_venta_id INT;
    DECLARE v_idx INT DEFAULT 0;
    DECLARE v_len INT;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad DECIMAL(12,2);
    DECLARE v_precio_venta DECIMAL(12,2);
    DECLARE v_descuento DECIMAL(12,2);
    DECLARE v_line_subtotal DECIMAL(12,2);
    DECLARE v_line_total DECIMAL(12,2);
    DECLARE v_error_msg VARCHAR(255);
    DECLARE v_tiene_acceso INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', CONCAT('Error al registrar venta: ', @text),
            'sqlstate', @sqlstate,
            'errno', @errno
        ) AS result;
    END;
    
    -- Validar acceso del usuario a la empresa
    SELECT COUNT(*) INTO v_tiene_acceso
    FROM usuario_empresas
    WHERE usuario_id = p_usuario_id AND empresa_id = p_empresa_id;
    
    IF v_tiene_acceso = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'error',
            'message', 'No tiene permisos para operar en esta empresa'
        ) AS result;
    ELSE
        START TRANSACTION;
        
        SET @app_empresa_id = p_empresa_id;
        SET @app_usuario_id = p_usuario_id;
        
        -- Validar stock usando la función
        SET v_len = JSON_LENGTH(p_detalle);
        WHILE v_idx < v_len DO
            SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].producto_id')));
            SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].cantidad')));
            
            IF fn_validar_stock_producto(v_producto_id, p_empresa_id, v_cantidad) = 0 THEN
                SET v_error_msg = CONCAT('Stock insuficiente para producto ID ', v_producto_id);
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
            END IF;
            
            SET v_idx = v_idx + 1;
        END WHILE;
        
        -- Calcular totales
        SET v_idx = 0;
        WHILE v_idx < v_len DO
            SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].producto_id')));
            SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].cantidad')));
            SET v_descuento = COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].descuento'))), 0);
            
            SELECT precio_venta INTO v_precio_venta FROM precios 
            WHERE empresa_id = p_empresa_id AND producto_id = v_producto_id AND activo = 1;
            
            SET v_line_subtotal = v_cantidad * v_precio_venta;
            SET v_line_total = v_line_subtotal - v_descuento;
            SET v_subtotal = v_subtotal + v_line_subtotal;
            SET v_total = v_total + v_line_total;
            
            SET v_idx = v_idx + 1;
        END WHILE;
        
        -- Insertar venta
        INSERT INTO ventas (empresa_id, cliente_id, fecha_venta, subtotal, total, tipo_venta, saldo_pendiente, estado)
        VALUES (p_empresa_id, p_cliente_id, NOW(), v_subtotal, v_total, p_tipo_venta, 
                IF(p_tipo_venta = 'CREDITO', v_total, 0), 'COMPLETADA');
        
        SET v_venta_id = LAST_INSERT_ID();
        
        -- Insertar detalle
        SET v_idx = 0;
        WHILE v_idx < v_len DO
            SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].producto_id')));
            SET v_cantidad = JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].cantidad')));
            SET v_descuento = COALESCE(JSON_UNQUOTE(JSON_EXTRACT(p_detalle, CONCAT('$[', v_idx, '].descuento'))), 0);
            
            SELECT precio_venta INTO v_precio_venta FROM precios 
            WHERE empresa_id = p_empresa_id AND producto_id = v_producto_id AND activo = 1;
            
            SET v_line_subtotal = v_cantidad * v_precio_venta;
            SET v_line_total = v_line_subtotal - v_descuento;
            
            INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_venta, descuento, subtotal, total)
            VALUES (v_venta_id, v_producto_id, v_cantidad, v_precio_venta, v_descuento, v_line_subtotal, v_line_total);
            
            SET v_idx = v_idx + 1;
        END WHILE;
        
        -- Si es crédito, actualizar saldo_credito del cliente
        IF p_tipo_venta = 'CREDITO' THEN
            UPDATE clientes SET saldo_credito = fn_saldo_cliente(p_cliente_id) WHERE id = p_cliente_id;
        END IF;
        
        COMMIT;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'message', 'Venta registrada',
            'venta_id', v_venta_id,
            'total', v_total
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_clientes_credito_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_clientes_credito_json`(IN p_empresa_id INT)
BEGIN
    DECLARE v_clientes JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'cliente_id', c.id,
            'nombre_completo', CONCAT(c.nombre, ' ', IFNULL(c.apellido, '')),
            'documento', c.numero_documento,
            'telefono', c.telefono,
            'email', c.email,
            'limite_credito', c.limite_credito,
            'saldo_actual', c.saldo_credito,
            'disponible', c.limite_credito - c.saldo_credito
        )
    ), JSON_ARRAY()) INTO v_clientes
    FROM clientes c
    WHERE c.empresa_id = p_empresa_id
        AND c.saldo_credito > 0
        AND c.activo = 1
    ORDER BY c.saldo_credito DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'total_clientes_con_deuda', JSON_LENGTH(v_clientes),
        'clientes', v_clientes
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_compras_periodo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_compras_periodo_json`(
    IN p_empresa_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_compras JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'id', c.id,
            'fecha', c.fecha_compra,
            'factura', c.numero_factura,
            'proveedor', p.nombre,
            'total', c.total,
            'saldo', c.saldo_pendiente,
            'estado', c.estado
        )
    ), JSON_ARRAY()) INTO v_compras
    FROM compras c
    INNER JOIN proveedores p ON c.proveedor_id = p.id
    WHERE c.empresa_id = p_empresa_id
        AND c.fecha_compra BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY c.fecha_compra DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'periodo', JSON_OBJECT('inicio', p_fecha_inicio, 'fin', p_fecha_fin),
        'total_registros', JSON_LENGTH(v_compras),
        'compras', v_compras
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_compra_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_compra_json`(IN p_compra_id INT)
BEGIN
    DECLARE v_cabecera JSON;
    DECLARE v_detalle JSON;
    
    SELECT JSON_OBJECT(
        'id', c.id,
        'fecha', c.fecha_compra,
        'factura', c.numero_factura,
        'subtotal', c.subtotal,
        'impuesto', c.impuesto,
        'total', c.total,
        'saldo_pendiente', c.saldo_pendiente,
        'estado', c.estado,
        'proveedor', JSON_OBJECT(
            'id', p.id,
            'nombre', p.nombre,
            'ruc', p.ruc,
            'telefono', p.telefono
        ),
        'empresa', JSON_OBJECT(
            'id', e.id,
            'nombre', e.nombre,
            'ruc', e.ruc
        )
    ) INTO v_cabecera
    FROM compras c
    INNER JOIN proveedores p ON c.proveedor_id = p.id
    INNER JOIN empresas e ON c.empresa_id = e.id
    WHERE c.id = p_compra_id;
    
    IF v_cabecera IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Compra no encontrada') AS result;
    ELSE
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                'producto_id', prod.id,
                'producto_nombre', prod.nombre,
                'cantidad', cd.cantidad,
                'precio_compra', cd.precio_compra,
                'subtotal', cd.subtotal,
                'total', cd.total
            )
        ), JSON_ARRAY()) INTO v_detalle
        FROM compras_detalle cd
        INNER JOIN productos prod ON cd.producto_id = prod.id
        WHERE cd.compra_id = p_compra_id;
        
        SELECT JSON_OBJECT('status', 'success', 'compra', v_cabecera, 'detalle', v_detalle) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_pagos_clientes_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_pagos_clientes_json`(
    IN p_empresa_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_pagos JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'id', pc.id,
            'fecha', pc.fecha_pago,
            'cliente', CONCAT(c.nombre, ' ', IFNULL(c.apellido, '')),
            'monto', pc.monto,
            'forma_pago', pc.forma_pago,
            'referencia', pc.referencia,
            'venta_id', pc.venta_id
        )
    ), JSON_ARRAY()) INTO v_pagos
    FROM pagos_clientes pc
    INNER JOIN clientes c ON pc.cliente_id = c.id
    WHERE pc.empresa_id = p_empresa_id
        AND pc.fecha_pago BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY pc.fecha_pago DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'periodo', JSON_OBJECT('inicio', p_fecha_inicio, 'fin', p_fecha_fin),
        'total_pagos', JSON_LENGTH(v_pagos),
        'pagos', v_pagos
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_pagos_proveedores_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_pagos_proveedores_json`(
    IN p_empresa_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_pagos JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'id', pp.id,
            'fecha', pp.fecha_pago,
            'proveedor', prov.nombre,
            'monto', pp.monto,
            'forma_pago', pp.forma_pago,
            'referencia', pp.referencia,
            'compra_factura', c.numero_factura
        )
    ), JSON_ARRAY()) INTO v_pagos
    FROM pagos_proveedores pp
    INNER JOIN proveedores prov ON pp.proveedor_id = prov.id
    LEFT JOIN compras c ON pp.compra_id = c.id
    WHERE pp.empresa_id = p_empresa_id
        AND pp.fecha_pago BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY pp.fecha_pago DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'periodo', JSON_OBJECT('inicio', p_fecha_inicio, 'fin', p_fecha_fin),
        'total_pagos', JSON_LENGTH(v_pagos),
        'pagos', v_pagos
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_proveedores_deuda_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_proveedores_deuda_json`(IN p_empresa_id INT)
BEGIN
    DECLARE v_proveedores JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'proveedor_id', p.id,
            'nombre', p.nombre,
            'ruc', p.ruc,
            'telefono', p.telefono,
            'deuda_total', fn_deuda_proveedor(p.id),
            'ultima_compra', (SELECT MAX(fecha_compra) FROM compras WHERE proveedor_id = p.id AND estado = 'PENDIENTE')
        )
    ), JSON_ARRAY()) INTO v_proveedores
    FROM proveedores p
    WHERE p.empresa_id = p_empresa_id
        AND p.activo = 1
        AND fn_deuda_proveedor(p.id) > 0
    ORDER BY fn_deuda_proveedor(p.id) DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'total_proveedores_con_deuda', JSON_LENGTH(v_proveedores),
        'proveedores', v_proveedores
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_stock_minimo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_stock_minimo_json`(IN p_empresa_id INT)
BEGIN
    DECLARE v_productos JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'producto_id', p.id,
            'codigo', p.codigo_principal,
            'nombre', p.nombre,
            'stock_actual', i.stock_actual,
            'stock_minimo', i.stock_minimo,
            'categoria', cat.nombre,
            'marca', m.nombre
        )
    ), JSON_ARRAY()) INTO v_productos
    FROM inventario i
    INNER JOIN productos p ON i.producto_id = p.id
    LEFT JOIN categorias cat ON p.categoria_id = cat.id
    LEFT JOIN marcas m ON p.marca_id = m.id
    WHERE i.empresa_id = p_empresa_id
        AND i.stock_actual <= i.stock_minimo
        AND p.activo = 1
    ORDER BY (i.stock_actual / NULLIF(i.stock_minimo, 0)) ASC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'total_productos_criticos', JSON_LENGTH(v_productos),
        'productos', v_productos
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_top_productos_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_top_productos_json`(
    IN p_empresa_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_limite INT
)
BEGIN
    DECLARE v_top JSON;
    
    SET p_limite = IFNULL(p_limite, 10);
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'producto_id', p.id,
            'codigo', p.codigo_principal,
            'nombre', p.nombre,
            'categoria', cat.nombre,
            'total_vendido', total_cantidad,
            'ingreso_total', total_ingreso
        )
    ), JSON_ARRAY()) INTO v_top
    FROM (
        SELECT vd.producto_id,
               SUM(vd.cantidad) AS total_cantidad,
               SUM(vd.total) AS total_ingreso
        FROM ventas_detalle vd
        INNER JOIN ventas v ON vd.venta_id = v.id
        WHERE v.empresa_id = p_empresa_id
            AND v.estado = 'COMPLETADA'
            AND DATE(v.fecha_venta) BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY vd.producto_id
        ORDER BY total_cantidad DESC
        LIMIT p_limite
    ) AS stats
    INNER JOIN productos p ON stats.producto_id = p.id
    LEFT JOIN categorias cat ON p.categoria_id = cat.id
    ORDER BY stats.total_cantidad DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'periodo', JSON_OBJECT('inicio', p_fecha_inicio, 'fin', p_fecha_fin),
        'limite', p_limite,
        'productos', v_top
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_ventas_periodo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_ventas_periodo_json`(
    IN p_empresa_id INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    DECLARE v_ventas JSON;
    
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'id', v.id,
            'fecha', v.fecha_venta,
            'cliente', CONCAT(IFNULL(c.nombre, 'Consumidor Final'), ' ', IFNULL(c.apellido, '')),
            'tipo', v.tipo_venta,
            'total', v.total,
            'estado', v.estado
        )
    ), JSON_ARRAY()) INTO v_ventas
    FROM ventas v
    LEFT JOIN clientes c ON v.cliente_id = c.id
    WHERE v.empresa_id = p_empresa_id
        AND DATE(v.fecha_venta) BETWEEN p_fecha_inicio AND p_fecha_fin
    ORDER BY v.fecha_venta DESC;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'empresa_id', p_empresa_id,
        'periodo', JSON_OBJECT('inicio', p_fecha_inicio, 'fin', p_fecha_fin),
        'total_registros', JSON_LENGTH(v_ventas),
        'ventas', v_ventas
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_reporte_venta_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reporte_venta_json`(IN p_venta_id INT)
BEGIN
    DECLARE v_cabecera JSON;
    DECLARE v_detalle JSON;
    DECLARE v_result JSON;
    
    -- Cabecera
    SELECT JSON_OBJECT(
        'id', v.id,
        'fecha', v.fecha_venta,
        'tipo', v.tipo_venta,
        'subtotal', v.subtotal,
        'impuesto', v.impuesto,
        'total', v.total,
        'estado', v.estado,
        'cliente', JSON_OBJECT(
            'id', c.id,
            'nombre', CONCAT(c.nombre, ' ', IFNULL(c.apellido, '')),
            'documento', c.numero_documento,
            'telefono', c.telefono
        ),
        'empresa', JSON_OBJECT(
            'id', e.id,
            'nombre', e.nombre,
            'ruc', e.ruc
        )
    ) INTO v_cabecera
    FROM ventas v
    LEFT JOIN clientes c ON v.cliente_id = c.id
    INNER JOIN empresas e ON v.empresa_id = e.id
    WHERE v.id = p_venta_id;
    
    IF v_cabecera IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Venta no encontrada') AS result;
    ELSE
        -- Detalle
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                'producto_id', p.id,
                'producto_nombre', p.nombre,
                'cantidad', vd.cantidad,
                'precio_unitario', vd.precio_venta,
                'descuento', vd.descuento,
                'subtotal', vd.subtotal,
                'total', vd.total
            )
        ), JSON_ARRAY()) INTO v_detalle
        FROM ventas_detalle vd
        INNER JOIN productos p ON vd.producto_id = p.id
        WHERE vd.venta_id = p_venta_id;
        
        SET v_result = JSON_OBJECT(
            'status', 'success',
            'venta', v_cabecera,
            'detalle', v_detalle
        );
        SELECT v_result AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_top_productos_vendidos_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_top_productos_vendidos_json`(
    IN p_empresa_id INT,
    IN p_desde DATE,
    IN p_hasta DATE,
    IN p_search VARCHAR(100),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (p.nombre LIKE "%', p_search, '%" OR p.codigo_principal LIKE "%', p_search, '%")'),
        '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND v.empresa_id = ', p_empresa_id), '');
    SET @fecha_cond = CONCAT(' AND (', IF(p_desde IS NOT NULL, CONCAT('DATE(v.fecha_venta) >= "', p_desde, '"'), '1=1'), ' AND ', IF(p_hasta IS NOT NULL, CONCAT('DATE(v.fecha_venta) <= "', p_hasta, '"'), '1=1'), ')');
    
    -- Total de productos distintos que cumplen filtros
    SET @sql_count = CONCAT('
        SELECT COUNT(DISTINCT vd.producto_id) INTO @v_total
        FROM ventas_detalle vd
        INNER JOIN ventas v ON vd.venta_id = v.id
        INNER JOIN productos p ON vd.producto_id = p.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "producto_id", p.id,
                "producto", p.nombre,
                "codigo", p.codigo_principal,
                "total_vendido", total_vendido,
                "ingreso_total", ingreso_total
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM (
            SELECT vd.producto_id,
                   SUM(vd.cantidad) AS total_vendido,
                   SUM(vd.total) AS ingreso_total
            FROM ventas_detalle vd
            INNER JOIN ventas v ON vd.venta_id = v.id
            WHERE 1=1
            ', @empresa_cond, @fecha_cond, '
            GROUP BY vd.producto_id
            ORDER BY total_vendido DESC
            LIMIT ', v_offset, ', ', p_limit, '
        ) AS stats
        INNER JOIN productos p ON stats.producto_id = p.id
        WHERE 1=1
        ', @search_cond);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_unidades_medida_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_unidades_medida_listar_json`(
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT,
    OUT p_mensaje VARCHAR(255),
    OUT p_codigo_resultado INT 
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    DECLARE v_error_message VARCHAR(255);
        
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        ROLLBACK;
        SET p_mensaje = CONCAT('Error: ', v_error_message);
        SET p_codigo_resultado = 500;
    END;
    -- Paginación
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    -- Total
    SELECT COUNT(*) INTO v_total
    FROM unidades_medida u
    WHERE (p_activo IS NULL OR u.activo = p_activo)
      AND (p_search IS NULL OR p_search = '' OR u.nombre LIKE CONCAT('%', p_search, '%')
           OR u.abreviatura LIKE CONCAT('%', p_search, '%'));
    
    IF v_total = 0 THEN
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', JSON_ARRAY(),
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', 0,
                'last_page', 0,
                'from', 0,
                'to', 0
            )
        ) AS result;
    ELSE
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', u.id,
                'nombre', u.nombre,
                'abreviatura', u.abreviatura,
                'activo', u.activo
            )
        ), JSON_ARRAY()) INTO v_result
        FROM unidades_medida u
        WHERE (p_activo IS NULL OR u.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR u.nombre LIKE CONCAT('%', p_search, '%')
               OR u.abreviatura LIKE CONCAT('%', p_search, '%'))
        ORDER BY u.nombre
        LIMIT v_offset, p_limit;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', v_result,
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', v_total,
                'last_page', CEIL(v_total / p_limit),
                'from', IF(v_total = 0, 0, v_offset + 1),
                'to', LEAST(v_offset + p_limit, v_total)
            )
        ) AS result;
    END IF;
    SET p_mensaje = 'Listado obtenido exitosamente.';
	SET p_codigo_resultado = 200;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_unidad_medida_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_unidad_medida_actualizar_json`(
    IN p_id INT,
    IN p_nombre VARCHAR(50),
    IN p_abreviatura VARCHAR(10),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar unidad de medida: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM unidades_medida WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Unidad de medida no encontrada') AS result;
    ELSE
        START TRANSACTION;
        UPDATE unidades_medida
        SET nombre = IFNULL(p_nombre, nombre),
            abreviatura = IFNULL(p_abreviatura, abreviatura),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Unidad de medida actualizada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_unidad_medida_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_unidad_medida_crear_json`(
    IN p_nombre VARCHAR(50),
    IN p_abreviatura VARCHAR(10),
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear unidad de medida: ', @text)) AS result;
    END;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO unidades_medida (nombre, abreviatura, activo)
        VALUES (p_nombre, p_abreviatura, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Unidad de medida creada', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_unidad_medida_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_unidad_medida_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar unidad de medida: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM unidades_medida WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Unidad de medida no encontrada') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM unidades_medida WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Unidad de medida eliminada') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_unidad_medida_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_unidad_medida_existe`(
    IN p_id INT,
    IN p_nombre VARCHAR(50)
)
    COMMENT 'Verifica si una unidad de medida existe por id o nombre'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_nombre IS NULL OR p_nombre = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id o nombre') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM unidades_medida WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'abreviatura', abreviatura, 'activo', activo)
                INTO v_data FROM unidades_medida WHERE id = p_id;
            END IF;
        ELSE
            SELECT COUNT(*) INTO v_existe FROM unidades_medida WHERE nombre = p_nombre;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'nombre', nombre, 'abreviatura', abreviatura, 'activo', activo)
                INTO v_data FROM unidades_medida WHERE nombre = p_nombre;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Unidad de medida ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' no existe'), 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', CONCAT('Unidad de medida ', IF(p_id>0, CONCAT('con id ', p_id), CONCAT('"', p_nombre, '"')), ' ya existe'), 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_unidad_medida_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_unidad_medida_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'nombre', nombre,
        'abreviatura', abreviatura,
        'activo', activo
    ) INTO v_result
    FROM unidades_medida WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Unidad de medida no encontrada') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuarios_listar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuarios_listar_json`(
    IN p_search VARCHAR(100),
    IN p_activo TINYINT(1),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    SELECT COUNT(*) INTO v_total
    FROM usuarios u
    WHERE (p_activo IS NULL OR u.activo = p_activo)
      AND (p_search IS NULL OR p_search = '' OR u.nombre LIKE CONCAT('%', p_search, '%')
           OR u.apellido LIKE CONCAT('%', p_search, '%') OR u.email LIKE CONCAT('%', p_search, '%')
           OR u.cedula LIKE CONCAT('%', p_search, '%'));
    
    IF v_total = 0 THEN
        SELECT JSON_OBJECT('status', 'success', 'data', JSON_ARRAY(),
            'pagination', JSON_OBJECT('current_page', p_page, 'per_page', p_limit, 'total', 0, 'last_page', 0, 'from', 0, 'to', 0)) AS result;
    ELSE
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', u.id,
                'cedula', u.cedula,
                'nombre', u.nombre,
                'apellido', u.apellido,
                'telefono', u.telefono,
                'email', u.email,
                'img_url', u.img_url,
                'activo', u.activo
            )
        ), JSON_ARRAY()) INTO v_result
        FROM usuarios u
        WHERE (p_activo IS NULL OR u.activo = p_activo)
          AND (p_search IS NULL OR p_search = '' OR u.nombre LIKE CONCAT('%', p_search, '%')
               OR u.apellido LIKE CONCAT('%', p_search, '%') OR u.email LIKE CONCAT('%', p_search, '%')
               OR u.cedula LIKE CONCAT('%', p_search, '%'))
        ORDER BY u.nombre
        LIMIT v_offset, p_limit;
        
        SELECT JSON_OBJECT(
            'status', 'success',
            'data', v_result,
            'pagination', JSON_OBJECT(
                'current_page', p_page,
                'per_page', p_limit,
                'total', v_total,
                'last_page', CEIL(v_total / p_limit),
                'from', IF(v_total = 0, 0, v_offset + 1),
                'to', LEAST(v_offset + p_limit, v_total)
            )
        ) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_actualizar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_actualizar_json`(
    IN p_id INT,
    IN p_cedula VARCHAR(13),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_img_url TEXT,
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al actualizar usuario: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM usuarios WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Usuario no encontrado') AS result;
    ELSE
        START TRANSACTION;
        UPDATE usuarios
        SET cedula = IFNULL(p_cedula, cedula),
            nombre = IFNULL(p_nombre, nombre),
            apellido = IFNULL(p_apellido, apellido),
            password = IF(p_password IS NOT NULL AND p_password != '', SHA2(p_password, 256), password),
            telefono = IFNULL(p_telefono, telefono),
            email = IFNULL(p_email, email),
            img_url = IFNULL(p_img_url, img_url),
            activo = IFNULL(p_activo, activo)
        WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Usuario actualizado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_crear_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_crear_json`(
    IN p_cedula VARCHAR(13),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_img_url TEXT,
    IN p_activo TINYINT(1)
)
BEGIN
    DECLARE v_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al crear usuario: ', @text)) AS result;
    END;
    
    IF p_cedula IS NULL OR p_cedula = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'La cédula es obligatoria') AS result;
    ELSEIF p_nombre IS NULL OR p_nombre = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'El nombre es obligatorio') AS result;
    ELSEIF p_password IS NULL OR p_password = '' THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'La contraseña es obligatoria') AS result;
    ELSE
        START TRANSACTION;
        INSERT INTO usuarios (cedula, nombre, apellido, password, telefono, email, img_url, activo)
        VALUES (p_cedula, p_nombre, p_apellido, SHA2(p_password, 256), p_telefono, p_email, p_img_url, IFNULL(p_activo, 1));
        SET v_id = LAST_INSERT_ID();
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Usuario creado', 'id', v_id) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_eliminar_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_eliminar_json`(IN p_id INT)
BEGIN
    DECLARE v_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SELECT JSON_OBJECT('status', 'error', 'message', CONCAT('Error al eliminar usuario: ', @text)) AS result;
    END;
    
    SELECT COUNT(*) INTO v_exists FROM usuarios WHERE id = p_id;
    IF v_exists = 0 THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Usuario no encontrado') AS result;
    ELSE
        START TRANSACTION;
        DELETE FROM usuarios WHERE id = p_id;
        COMMIT;
        SELECT JSON_OBJECT('status', 'success', 'message', 'Usuario eliminado') AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_existe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_existe`(
    IN p_id INT,
    IN p_cedula VARCHAR(13),
    IN p_email VARCHAR(100)
)
    COMMENT 'Verifica si un usuario existe por id, cédula o email'
BEGIN
    DECLARE v_existe INT DEFAULT 0;
    DECLARE v_data JSON DEFAULT NULL;
    DECLARE v_error_message VARCHAR(255);
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_message = MESSAGE_TEXT;
        SELECT JSON_OBJECT('status', 'error', 'codigo', '500', 'message', v_error_message) AS result;
    END;
    
    IF (p_id IS NULL OR p_id <= 0) AND (p_cedula IS NULL OR p_cedula = '') AND (p_email IS NULL OR p_email = '') THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Debe proporcionar id, cédula o email') AS result;
    ELSE
        IF p_id IS NOT NULL AND p_id > 0 THEN
            SELECT COUNT(*) INTO v_existe FROM usuarios WHERE id = p_id;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'cedula', cedula, 'nombre', nombre, 'apellido', apellido, 'telefono', telefono, 'email', email, 'img_url', img_url, 'activo', activo)
                INTO v_data FROM usuarios WHERE id = p_id;
            END IF;
        ELSEIF p_cedula IS NOT NULL AND p_cedula != '' THEN
            SELECT COUNT(*) INTO v_existe FROM usuarios WHERE cedula = p_cedula;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'cedula', cedula, 'nombre', nombre, 'apellido', apellido, 'telefono', telefono, 'email', email, 'img_url', img_url, 'activo', activo)
                INTO v_data FROM usuarios WHERE cedula = p_cedula;
            END IF;
        ELSEIF p_email IS NOT NULL AND p_email != '' THEN
            SELECT COUNT(*) INTO v_existe FROM usuarios WHERE email = p_email;
            IF v_existe > 0 THEN
                SELECT JSON_OBJECT('id', id, 'cedula', cedula, 'nombre', nombre, 'apellido', apellido, 'telefono', telefono, 'email', email, 'img_url', img_url, 'activo', activo)
                INTO v_data FROM usuarios WHERE email = p_email;
            END IF;
        END IF;
        
        IF v_existe = 0 THEN
            SELECT JSON_OBJECT('status', 'success', 'message', 'Usuario no existe', 'exists', FALSE, 'data', NULL) AS result;
        ELSE
            SELECT JSON_OBJECT('status', 'success', 'message', 'Usuario ya existe', 'exists', TRUE, 'data', v_data) AS result;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_usuario_obtener_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_obtener_json`(IN p_id INT)
BEGIN
    DECLARE v_result JSON;
    SELECT JSON_OBJECT(
        'id', id,
        'cedula', cedula,
        'nombre', nombre,
        'apellido', apellido,
        'telefono', telefono,
        'email', email,
        'img_url', img_url,
        'activo', activo
    ) INTO v_result
    FROM usuarios WHERE id = p_id;
    
    IF v_result IS NULL THEN
        SELECT JSON_OBJECT('status', 'error', 'message', 'Usuario no encontrado') AS result;
    ELSE
        SELECT JSON_OBJECT('status', 'success', 'data', v_result) AS result;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ventas_por_periodo_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ventas_por_periodo_json`(
    IN p_desde DATE,
    IN p_hasta DATE,
    IN p_empresa_id INT,
    IN p_search VARCHAR(100),
    IN p_estado VARCHAR(20),
    IN p_tipo_venta VARCHAR(10),
    IN p_page INT,
    IN p_limit INT
)
BEGIN
    DECLARE v_offset INT;
    DECLARE v_total INT;
    DECLARE v_result JSON;
    
    IF p_page IS NULL OR p_page < 1 THEN SET p_page = 1; END IF;
    IF p_limit IS NULL OR p_limit < 1 THEN SET p_limit = 10; END IF;
    IF p_limit > 100 THEN SET p_limit = 100; END IF;
    SET v_offset = (p_page - 1) * p_limit;
    
    -- Condiciones
    SET @search_cond = IF(p_search IS NOT NULL AND p_search != '',
        CONCAT(' AND (CONCAT(c.nombre, " ", IFNULL(c.apellido, "")) LIKE "%', p_search, '%" OR v.id = ', p_search, ')'),
        '');
    SET @estado_cond = IF(p_estado IS NOT NULL AND p_estado != '', CONCAT(' AND v.estado = "', p_estado, '"'), '');
    SET @tipo_cond = IF(p_tipo_venta IS NOT NULL AND p_tipo_venta != '', CONCAT(' AND v.tipo_venta = "', p_tipo_venta, '"'), '');
    SET @empresa_cond = IF(p_empresa_id IS NOT NULL, CONCAT(' AND v.empresa_id = ', p_empresa_id), '');
    SET @fecha_cond = CONCAT(' AND (', IF(p_desde IS NOT NULL, CONCAT('DATE(v.fecha_venta) >= "', p_desde, '"'), '1=1'), ' AND ', IF(p_hasta IS NOT NULL, CONCAT('DATE(v.fecha_venta) <= "', p_hasta, '"'), '1=1'), ')');
    
    -- Total
    SET @sql_count = CONCAT('
        SELECT COUNT(*) INTO @v_total
        FROM ventas v
        LEFT JOIN clientes c ON v.cliente_id = c.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond, @estado_cond, @tipo_cond);
    PREPARE stmt_count FROM @sql_count;
    EXECUTE stmt_count;
    DEALLOCATE PREPARE stmt_count;
    SET v_total = @v_total;
    
    -- Datos
    SET @sql_data = CONCAT('
        SELECT IFNULL(JSON_ARRAYAGG(
            JSON_OBJECT(
                "id", v.id,
                "fecha_venta", v.fecha_venta,
                "cliente", CONCAT(c.nombre, " ", IFNULL(c.apellido, "")),
                "tipo_venta", v.tipo_venta,
                "total", v.total,
                "saldo_pendiente", v.saldo_pendiente,
                "estado", v.estado
            )
        ), JSON_ARRAY()) INTO @v_result
        FROM ventas v
        LEFT JOIN clientes c ON v.cliente_id = c.id
        WHERE 1=1
        ', @empresa_cond, @fecha_cond, @search_cond, @estado_cond, @tipo_cond, '
        ORDER BY v.fecha_venta DESC
        LIMIT ', v_offset, ', ', p_limit);
    PREPARE stmt_data FROM @sql_data;
    EXECUTE stmt_data;
    DEALLOCATE PREPARE stmt_data;
    SET v_result = @v_result;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', v_result,
        'pagination', JSON_OBJECT(
            'current_page', p_page,
            'per_page', p_limit,
            'total', v_total,
            'last_page', CEIL(v_total / p_limit),
            'from', IF(v_total = 0, 0, v_offset + 1),
            'to', LEAST(v_offset + p_limit, v_total)
        )
    ) AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_venta_detalle_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_venta_detalle_json`(IN p_venta_id INT)
BEGIN
    DECLARE v_cabecera JSON;
    DECLARE v_detalle JSON;
    DECLARE v_total_utilidad DECIMAL(12,2);
    
    -- Cabecera de la venta
    SELECT JSON_OBJECT(
        'id', v.id,
        'empresa_id', v.empresa_id,
        'cliente', CONCAT(c.nombre, ' ', IFNULL(c.apellido, '')),
        'fecha_venta', v.fecha_venta,
        'subtotal', v.subtotal,
        'impuesto', v.impuesto,
        'total', v.total,
        'tipo_venta', v.tipo_venta,
        'saldo_pendiente', v.saldo_pendiente,
        'estado', v.estado
    ) INTO v_cabecera
    FROM ventas v
    LEFT JOIN clientes c ON v.cliente_id = c.id
    WHERE v.id = p_venta_id;
    
    -- Detalle con utilidad por línea (usando precio_compra actual de la tabla precios)
    -- Nota: se usa el precio_compra de la empresa en la fecha de venta (último precio registrado)
    SELECT IFNULL(JSON_ARRAYAGG(
        JSON_OBJECT(
            'producto_id', vd.producto_id,
            'producto', p.nombre,
            'cantidad', vd.cantidad,
            'precio_venta', vd.precio_venta,
            'precio_compra', pr.precio_compra,
            'descuento', vd.descuento,
            'subtotal', vd.subtotal,
            'total', vd.total,
            'utilidad_absoluta', ROUND((vd.precio_venta - pr.precio_compra) * vd.cantidad, 2),
            'margen_sobre_costo', ROUND((vd.precio_venta - pr.precio_compra) / pr.precio_compra * 100, 2),
            'margen_sobre_venta', ROUND((vd.precio_venta - pr.precio_compra) / vd.precio_venta * 100, 2)
        )
    ), JSON_ARRAY()) INTO v_detalle
    FROM ventas_detalle vd
    INNER JOIN productos p ON vd.producto_id = p.id
    LEFT JOIN precios pr ON p.id = pr.producto_id AND pr.empresa_id = (SELECT empresa_id FROM ventas WHERE id = p_venta_id) AND pr.activo = 1
    WHERE vd.venta_id = p_venta_id;
    
    -- Calcular utilidad total de la venta
    SELECT IFNULL(SUM((vd.precio_venta - pr.precio_compra) * vd.cantidad), 0) INTO v_total_utilidad
    FROM ventas_detalle vd
    LEFT JOIN precios pr ON vd.producto_id = pr.producto_id 
        AND pr.empresa_id = (SELECT empresa_id FROM ventas WHERE id = p_venta_id) 
        AND pr.activo = 1
    WHERE vd.venta_id = p_venta_id;
    
    SELECT JSON_OBJECT(
        'status', 'success',
        'data', JSON_OBJECT(
            'cabecera', v_cabecera,
            'detalle', v_detalle,
            'resumen', JSON_OBJECT(
                'total_venta', v_cabecera->>'$.total',
                'utilidad_total', v_total_utilidad,
                'margen_promedio', ROUND(v_total_utilidad / (v_cabecera->>'$.total') * 100, 2)
            )
        )
    ) AS result;
END ;;
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

-- Dump completed on 2026-04-04 13:28:40
