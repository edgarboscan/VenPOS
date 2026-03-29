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
-- Dumping events for database 'ven_pos'
--

--
-- Dumping routines for database 'ven_pos'
--
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
    DECLARE v_count INT;

    -- Verificar si el email existe
    SELECT COUNT(*) INTO v_count FROM usuarios WHERE email = p_email;
    
    IF v_count = 0 THEN
        -- CASO 1: Email no existe
        DO SLEEP(1.5);
        SELECT JSON_OBJECT(
            'estado', 'error',
            'codigo', 'CREDENCIALES_INVALIDAS',
            'mensaje', 'Email o contraseña incorrectos',
            'metadata', JSON_OBJECT('timestamp', NOW())
        ) AS resultado;
        
    ELSE
        -- El email existe, obtenemos datos
        SELECT u.id, u.password, u.activo, (
			select count(*)  
				from roles r INNER JOIN 
					usuario_roles ur ON r.id = ur.rol_id AND r.nombre = 'Super Administrador'
				where ur.usuario_id = u.id)
        INTO v_usuario_id, v_password_hash,  v_activo, v_is_super
        FROM usuarios u
        WHERE email = p_email;
        
        IF v_activo = 0 THEN
            -- CASO 2: Usuario inactivo
            SELECT JSON_OBJECT(
                'estado', 'error',
                'codigo', 'CUENTA_INACTIVA',
                'mensaje', 'Usuario desactivado',
                'metadata', JSON_OBJECT('timestamp', NOW())
            ) AS resultado;
            
        ELSE
            -- CASO 3: Usuario activo
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
            WHERE ur.usuario_id = v_usuario_id
            AND r.activo = 1;
            
            -- Respuesta final
            SELECT 
                JSON_OBJECT(
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
                        'roles', v_roles_json
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-29 18:27:09
