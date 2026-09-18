-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: codenbugs_bd
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `boleto`
--

DROP TABLE IF EXISTS `boleto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `boleto` (
  `id_boleto` int NOT NULL AUTO_INCREMENT,
  `id_viaje_reg` int NOT NULL,
  `id_usuario_cliente` int NOT NULL,
  `numero_asiento` int NOT NULL,
  `fecha_pago` datetime NOT NULL,
  `monto_pagado` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_boleto`),
  UNIQUE KEY `id_viaje_reg` (`id_viaje_reg`,`numero_asiento`),
  KEY `id_usuario_cliente` (`id_usuario_cliente`),
  CONSTRAINT `boleto_ibfk_1` FOREIGN KEY (`id_viaje_reg`) REFERENCES `viaje_regular` (`id_viaje_reg`),
  CONSTRAINT `boleto_ibfk_2` FOREIGN KEY (`id_usuario_cliente`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boleto`
--

LOCK TABLES `boleto` WRITE;
/*!40000 ALTER TABLE `boleto` DISABLE KEYS */;
INSERT INTO `boleto` VALUES (1,3,2,7,'2026-09-20 16:00:00',45.00),(2,3,2,11,'2026-09-20 16:00:00',45.00);
/*!40000 ALTER TABLE `boleto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus`
--

DROP TABLE IF EXISTS `bus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bus` (
  `id_bus` int NOT NULL AUTO_INCREMENT,
  `id_sucursal` int NOT NULL,
  `placa` varchar(20) NOT NULL,
  `marca` varchar(50) NOT NULL,
  `modelo` varchar(50) NOT NULL,
  `anio` int NOT NULL,
  `capacidad_pasajeros` int NOT NULL,
  `estado_operativo` enum('activo','inactivo') DEFAULT 'activo',
  `kilometraje_actual` decimal(10,2) NOT NULL,
  `foto_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_bus`),
  UNIQUE KEY `placa` (`placa`),
  KEY `id_sucursal` (`id_sucursal`),
  CONSTRAINT `bus_ibfk_1` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursal` (`id_sucursal`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus`
--

LOCK TABLES `bus` WRITE;
/*!40000 ALTER TABLE `bus` DISABLE KEYS */;
INSERT INTO `bus` VALUES (1,1,'CA456987','MCI','102-C3',2026,35,'activo',1200.00,''),(2,3,'CA88662','Mercedes','86564-1',2020,60,'activo',20100.00,'');
/*!40000 ALTER TABLE `bus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chofer`
--

DROP TABLE IF EXISTS `chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chofer` (
  `id_chofer` int NOT NULL AUTO_INCREMENT,
  `id_sucursal` int NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `licencia` varchar(50) NOT NULL,
  `tipo_licencia` varchar(20) NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `salario_base` decimal(10,2) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `foto_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_chofer`),
  UNIQUE KEY `licencia` (`licencia`),
  KEY `id_sucursal` (`id_sucursal`),
  CONSTRAINT `chofer_ibfk_1` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursal` (`id_sucursal`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chofer`
--

LOCK TABLES `chofer` WRITE;
/*!40000 ALTER TABLE `chofer` DISABLE KEYS */;
INSERT INTO `chofer` VALUES (1,1,'Juan José Quiñones Díaz','4568216574','A','2028-04-19','4569-8365',250.00,'activo',''),(2,3,'Jesús Adiel Castillo López','525624656','A','2030-03-13','8975-3111',5000.00,'activo','');
/*!40000 ALTER TABLE `chofer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion_sistema`
--

DROP TABLE IF EXISTS `configuracion_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_sistema` (
  `id_configuracion` int NOT NULL AUTO_INCREMENT,
  `monto_depreciacion_por_km` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_configuracion`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_sistema`
--

LOCK TABLES `configuracion_sistema` WRITE;
/*!40000 ALTER TABLE `configuracion_sistema` DISABLE KEYS */;
INSERT INTO `configuracion_sistema` VALUES (1,0.50);
/*!40000 ALTER TABLE `configuracion_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `control_viaje`
--

DROP TABLE IF EXISTS `control_viaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `control_viaje` (
  `id_control` int NOT NULL AUTO_INCREMENT,
  `id_viaje_reg` int DEFAULT NULL,
  `id_viaje_priv` int DEFAULT NULL,
  `hora_real_salida` datetime NOT NULL,
  `kilometraje_inicial` decimal(10,2) NOT NULL,
  `hora_real_llegada` datetime DEFAULT NULL,
  `kilometraje_final` decimal(10,2) DEFAULT NULL,
  `gasto_combustible` decimal(10,2) DEFAULT NULL,
  `monto_depreciacion_aplicado` decimal(10,2) DEFAULT NULL,
  `pago_chofer_aplicado` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_control`),
  KEY `id_viaje_reg` (`id_viaje_reg`),
  KEY `id_viaje_priv` (`id_viaje_priv`),
  CONSTRAINT `control_viaje_ibfk_1` FOREIGN KEY (`id_viaje_reg`) REFERENCES `viaje_regular` (`id_viaje_reg`),
  CONSTRAINT `control_viaje_ibfk_2` FOREIGN KEY (`id_viaje_priv`) REFERENCES `viaje_privado` (`id_viaje_priv`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `control_viaje`
--

LOCK TABLES `control_viaje` WRITE;
/*!40000 ALTER TABLE `control_viaje` DISABLE KEYS */;
INSERT INTO `control_viaje` VALUES (1,3,NULL,'2026-09-20 14:15:00',1000.00,'2026-09-20 16:45:00',1100.00,500.00,50.00,NULL),(2,NULL,5,'2026-12-22 12:00:00',1000.00,NULL,NULL,NULL,NULL,NULL),(3,4,NULL,'2026-09-30 14:15:00',1001.00,'2026-09-30 16:30:00',1200.00,500.00,99.50,NULL),(4,2,NULL,'2026-09-11 14:15:00',20000.00,'2026-09-11 16:45:00',20100.00,500.00,50.00,NULL);
/*!40000 ALTER TABLE `control_viaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento`
--

DROP TABLE IF EXISTS `mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento` (
  `id_mantenimiento` int NOT NULL AUTO_INCREMENT,
  `id_bus` int NOT NULL,
  `monto_mano_obra` decimal(10,2) NOT NULL,
  `monto_repuestos` decimal(10,2) NOT NULL,
  `fecha_mantenimiento` date NOT NULL,
  PRIMARY KEY (`id_mantenimiento`),
  KEY `id_bus` (`id_bus`),
  CONSTRAINT `mantenimiento_ibfk_1` FOREIGN KEY (`id_bus`) REFERENCES `bus` (`id_bus`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento`
--

LOCK TABLES `mantenimiento` WRITE;
/*!40000 ALTER TABLE `mantenimiento` DISABLE KEYS */;
INSERT INTO `mantenimiento` VALUES (1,1,150.00,300.00,'2026-09-17');
/*!40000 ALTER TABLE `mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ruta` (
  `id_ruta` int NOT NULL AUTO_INCREMENT,
  `id_sucursal_origen` int NOT NULL,
  `id_sucursal_destino` int NOT NULL,
  `distancia_km` decimal(10,2) NOT NULL,
  `precio_boleto` decimal(10,2) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  PRIMARY KEY (`id_ruta`),
  KEY `id_sucursal_origen` (`id_sucursal_origen`),
  KEY `id_sucursal_destino` (`id_sucursal_destino`),
  CONSTRAINT `ruta_ibfk_1` FOREIGN KEY (`id_sucursal_origen`) REFERENCES `sucursal` (`id_sucursal`),
  CONSTRAINT `ruta_ibfk_2` FOREIGN KEY (`id_sucursal_destino`) REFERENCES `sucursal` (`id_sucursal`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta`
--

LOCK TABLES `ruta` WRITE;
/*!40000 ALTER TABLE `ruta` DISABLE KEYS */;
INSERT INTO `ruta` VALUES (1,3,1,91.00,45.00,'activo'),(2,1,3,92.00,45.00,'activo');
/*!40000 ALTER TABLE `ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sucursal`
--

DROP TABLE IF EXISTS `sucursal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sucursal` (
  `id_sucursal` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `latitud` decimal(10,6) DEFAULT NULL,
  `longitud` decimal(10,6) DEFAULT NULL,
  PRIMARY KEY (`id_sucursal`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sucursal`
--

LOCK TABLES `sucursal` WRITE;
/*!40000 ALTER TABLE `sucursal` DISABLE KEYS */;
INSERT INTO `sucursal` VALUES (1,'Quetzal1','Zona 2 Quetzaltenango',14.843750,-91.511446),(2,'Quetzal2','1A Avenida 1-08, Totonicapán',14.910438,-91.370298),(3,'Quetzal3','Zona 1, Huehuetenango',15.313870,-91.476771);
/*!40000 ALTER TABLE `sucursal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `id_sucursal_asignada` int DEFAULT NULL,
  `rol` enum('Cliente','Admin_Sis','Admin_Suc') NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `nit` varchar(20) DEFAULT NULL,
  `dpi` varchar(20) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `contrasena` varchar(255) NOT NULL,
  `saldo_cartera` decimal(10,2) DEFAULT '0.00',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  PRIMARY KEY (`id_usuario`),
  KEY `id_sucursal_asignada` (`id_sucursal_asignada`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_sucursal_asignada`) REFERENCES `sucursal` (`id_sucursal`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,NULL,'Admin_Sis','Administrador Principal','CF','0000000000000',NULL,NULL,'admin123',0.00,'activo'),(2,NULL,'Cliente','Guillermo Emanuel Montejo Martinez','1235','1234567891234','3111-8801','Zona 7, Quetzaltenango','YKTest123',7100.00,'activo'),(3,1,'Admin_Suc','Rudy José López Domingo','4568795','9876543219876','4569-7894','Zona 3, Quetzaltenango','Q1admin123',500.00,'activo'),(4,2,'Admin_Suc','Leonel Gutiérrez Paz','4687954','465763549324','4569-1122','Zona 5, Totonicapán','Q2admin123',0.00,'activo'),(5,3,'Admin_Suc','Maria Laura Castillo Quiñones','5644954','1237894561231','4596-8733','Zona 3, Huehuetenango','Q3admin123',0.00,'activo');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viaje_privado`
--

DROP TABLE IF EXISTS `viaje_privado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viaje_privado` (
  `id_viaje_priv` int NOT NULL AUTO_INCREMENT,
  `id_sucursal` int DEFAULT NULL,
  `id_usuario_cliente` int NOT NULL,
  `id_bus` int DEFAULT NULL,
  `id_chofer` int DEFAULT NULL,
  `origen` varchar(150) NOT NULL,
  `destino` varchar(150) NOT NULL,
  `fecha_hora_salida` datetime NOT NULL,
  `fecha_hora_retorno` datetime DEFAULT NULL,
  `cantidad_pasajeros` int NOT NULL,
  `precio_estimado` decimal(10,2) DEFAULT NULL,
  `bono_chofer` decimal(10,2) DEFAULT NULL,
  `estado` enum('solicitado','cotizado','pagado','en_curso','finalizado') NOT NULL DEFAULT 'solicitado',
  PRIMARY KEY (`id_viaje_priv`),
  KEY `id_usuario_cliente` (`id_usuario_cliente`),
  KEY `id_bus` (`id_bus`),
  KEY `id_chofer` (`id_chofer`),
  KEY `fk_viaje_privado_sucursal` (`id_sucursal`),
  CONSTRAINT `fk_viaje_privado_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursal` (`id_sucursal`),
  CONSTRAINT `viaje_privado_ibfk_1` FOREIGN KEY (`id_usuario_cliente`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `viaje_privado_ibfk_2` FOREIGN KEY (`id_bus`) REFERENCES `bus` (`id_bus`),
  CONSTRAINT `viaje_privado_ibfk_3` FOREIGN KEY (`id_chofer`) REFERENCES `chofer` (`id_chofer`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viaje_privado`
--

LOCK TABLES `viaje_privado` WRITE;
/*!40000 ALTER TABLE `viaje_privado` DISABLE KEYS */;
INSERT INTO `viaje_privado` VALUES (3,1,2,1,1,'Quetzaltenango, Parque Central','Panajachel, Lago de Atitlán','2026-09-20 07:00:00','2026-09-22 17:00:00',20,3000.00,NULL,'cotizado'),(5,1,2,1,1,'Zona 1, Quetzaltenango','Puerto San José','2026-12-22 11:00:00','2026-12-24 02:00:00',20,3000.00,NULL,'en_curso');
/*!40000 ALTER TABLE `viaje_privado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viaje_regular`
--

DROP TABLE IF EXISTS `viaje_regular`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `viaje_regular` (
  `id_viaje_reg` int NOT NULL AUTO_INCREMENT,
  `id_ruta` int NOT NULL,
  `id_bus` int NOT NULL,
  `id_chofer` int NOT NULL,
  `fecha_hora_salida` datetime NOT NULL,
  `fecha_hora_llegada_estimada` datetime NOT NULL,
  `estado` enum('programado','en_curso','finalizado') DEFAULT 'programado',
  PRIMARY KEY (`id_viaje_reg`),
  KEY `id_ruta` (`id_ruta`),
  KEY `id_bus` (`id_bus`),
  KEY `id_chofer` (`id_chofer`),
  CONSTRAINT `viaje_regular_ibfk_1` FOREIGN KEY (`id_ruta`) REFERENCES `ruta` (`id_ruta`),
  CONSTRAINT `viaje_regular_ibfk_2` FOREIGN KEY (`id_bus`) REFERENCES `bus` (`id_bus`),
  CONSTRAINT `viaje_regular_ibfk_3` FOREIGN KEY (`id_chofer`) REFERENCES `chofer` (`id_chofer`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viaje_regular`
--

LOCK TABLES `viaje_regular` WRITE;
/*!40000 ALTER TABLE `viaje_regular` DISABLE KEYS */;
INSERT INTO `viaje_regular` VALUES (1,1,2,2,'2026-09-15 14:00:00','2026-09-15 16:30:00','finalizado'),(2,1,2,2,'2026-09-11 14:00:00','2026-09-11 16:30:00','finalizado'),(3,2,1,1,'2026-09-20 14:00:00','2026-09-20 16:30:00','finalizado'),(4,2,1,1,'2026-09-30 14:00:00','2026-09-30 16:30:00','finalizado');
/*!40000 ALTER TABLE `viaje_regular` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'codenbugs_bd'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-17 18:55:35
