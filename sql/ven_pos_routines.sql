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
    IN p_componentes JSON
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
                                    "updated_at", price.updated_at
                                )
			), JSON_ARRAY())
			FROM precios price
			WHERE price.producto_id = p.id AND price.empresa_id = @app_empresa_id
         ),
         "codigos", (
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

-- Dump completed on 2026-04-02 22:06:35
