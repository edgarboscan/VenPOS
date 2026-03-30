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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-31 19:38:39
