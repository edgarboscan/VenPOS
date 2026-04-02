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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-02 22:06:33
