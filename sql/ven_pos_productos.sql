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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-02 22:06:31
