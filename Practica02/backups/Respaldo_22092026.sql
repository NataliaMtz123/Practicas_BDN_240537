CREATE DATABASE  IF NOT EXISTS `db_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_test`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: db_test
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_users` varchar(80) NOT NULL,
  `description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'tb_users','Create','root@localhost','Usuario creado. ID=2, email=yazmin.esquivel@utxicotepec.edu.mx, nickname=Yazmin','2026-09-08 11:40:30',_binary ''),(2,'tb_users','Create','root@localhost','Usuario creado. ID=4, email=aylin.luna@utxicotepec.edu.mx, nickname=Aylin','2026-09-08 11:41:09',_binary ''),(3,'tb_users','Create','root@localhost','Usuario creado. ID=5, email=natali.martinez@utxicotepec.edu.mx, nickname=Natalia','2026-09-08 11:41:28',_binary ''),(4,'tb_users','Create','natalia.martinez@PC-02','Usuario creado. ID=6, email=maria.hernandez@gmail.com, nickname=mari123','2026-09-08 12:05:04',_binary ''),(5,'tb_users','Create','natalia.martinez@PC-02','Usuario creado. ID=7, email=240235@utxicotepec.edu.mx, nickname=yaz123','2026-09-08 12:05:21',_binary ''),(6,'tb_users','Create','natalia.martinez@PC-02','Usuario creado. ID=9, email=240220@utxicotepec.edu.mx, nickname=sam123','2026-09-08 12:05:45',_binary ''),(7,'tb_users','Update','marco.ramirez@DESKTOP-1FPT0T3','Usuario actualizado. ID=7. Cambios: email: [240235@utxicotepec.edu.mx] -> [yomero@gmail.com]','2026-09-09 18:25:26',_binary ''),(8,'tb_users','Delete','marco.ramirez@DESKTOP-1FPT0T3','Usuario eliminado. ID=4, email=aylin.luna@utxicotepec.edu.mx, nickname=Aylin','2026-09-09 18:25:46',_binary ''),(9,'tb_products','Create','root@localhost','Producto creado (Rol Vendedor). ID=1, SKU=SKU-001, Nombre=Laptop Lenovo IdeaPad','2026-09-22 08:32:31',_binary ''),(10,'tb_products','Create','root@localhost','Producto creado (Rol Vendedor). ID=2, SKU=SKU-002, Nombre=Mouse Logitech M185','2026-09-22 08:32:31',_binary ''),(11,'tb_products','Create','root@localhost','Producto creado (Rol Vendedor). ID=3, SKU=SKU-003, Nombre=Teclado Mecánico RGB','2026-09-22 08:32:31',_binary ''),(12,'tb_products','Create','root@localhost','Producto creado (Rol Vendedor). ID=4, SKU=SKU-004, Nombre=Monitor Samsung 24\"','2026-09-22 08:32:31',_binary ''),(13,'tb_products','Create','root@localhost','Producto creado (Rol Vendedor). ID=5, SKU=SKU-005, Nombre=Audífonos Bluetooth','2026-09-22 08:32:31',_binary ''),(14,'tb_products','Create','yazmin.esquivel@PC-03','Producto creado (Rol Vendedor). ID=6, SKU=PROD-001, Nombre=Laptop Dell XPS 13','2026-09-22 11:13:54',_binary ''),(15,'tb_products','Create','yazmin.esquivel@PC-03','Producto creado (Rol Vendedor). ID=7, SKU=PROD-002, Nombre=Smartphone Samsung S23','2026-09-22 11:13:54',_binary ''),(16,'tb_products','Create','yazmin.esquivel@PC-03','Producto creado (Rol Vendedor). ID=8, SKU=PROD-003, Nombre=Audífonos Sony WH-1000XM5','2026-09-22 11:13:54',_binary ''),(17,'tb_products','Create','yazmin.esquivel@PC-03','Producto creado (Rol Vendedor). ID=9, SKU=PROD-004, Nombre=Monitor LG 27 Pulgadas','2026-09-22 11:13:54',_binary ''),(18,'tb_products','Create','yazmin.esquivel@PC-03','Producto creado (Rol Vendedor). ID=10, SKU=PROD-005, Nombre=Teclado Mecánico Logitech','2026-09-22 11:13:54',_binary ''),(19,'tb_users','Create','yazmin.esquivel@PC-03','Usuario creado. ID=13, email=carlos.mendoza@utxicotepec.edu.mx, nick=Carlos','2026-09-22 11:45:28',_binary ''),(20,'tb_users','Create','yazmin.esquivel@PC-03','Usuario creado. ID=14, email=ana.lopez@utxicotepec.edu.mx, nick=Ana','2026-09-22 11:45:28',_binary ''),(21,'tb_users','Create','yazmin.esquivel@PC-03','Usuario creado. ID=15, email=sofia.reyes@utxicotepec.edu.mx, nick=Sofi','2026-09-22 11:45:28',_binary '');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'SKU-001','Laptop Lenovo IdeaPad','Laptop de 15.6 pulgadas con procesador Intel Core i5 y 8GB de RAM.',12500.00,15,_binary '','2026-09-22 08:32:31','2026-09-22 08:32:31'),(2,'SKU-002','Mouse Logitech M185','Mouse inalámbrico ergonómico con receptor USB.',350.00,40,_binary '','2026-09-22 08:32:31','2026-09-22 08:32:31'),(3,'SKU-003','Teclado Mecánico RGB','Teclado mecánico con iluminación RGB y conexión USB.',850.00,25,_binary '','2026-09-22 08:32:31','2026-09-22 08:32:31'),(4,'SKU-004','Monitor Samsung 24\"','Monitor LED Full HD de 24 pulgadas para oficina y entretenimiento.',3200.00,12,_binary '','2026-09-22 08:32:31','2026-09-22 08:32:31'),(5,'SKU-005','Audífonos Bluetooth','Audífonos inalámbricos Bluetooth con micrófono integrado.',650.00,30,_binary '','2026-09-22 08:32:31','2026-09-22 08:32:31'),(6,'PROD-001','Laptop Dell XPS 13','Laptop ultraligera con procesador Intel i7 y 16GB RAM',24999.00,10,_binary '','2026-09-22 11:13:54','2026-09-22 11:13:54'),(7,'PROD-002','Smartphone Samsung S23','Teléfono móvil con cámara de 50MP y pantalla AMOLED',18500.50,15,_binary '','2026-09-22 11:13:54','2026-09-22 11:13:54'),(8,'PROD-003','Audífonos Sony WH-1000XM5','Audífonos inalámbricos con cancelación de ruido activa',6800.00,25,_binary '','2026-09-22 11:13:54','2026-09-22 11:13:54'),(9,'PROD-004','Monitor LG 27 Pulgadas','Monitor Gaming 4K IPS de 144Hz',7499.99,8,_binary '','2026-09-22 11:13:54','2026-09-22 11:13:54'),(10,'PROD-005','Teclado Mecánico Logitech','Teclado RGB con switches táctiles inalámbrico',2200.00,30,_binary '','2026-09-22 11:13:54','2026-09-22 11:13:54');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT(
            'Producto creado (Rol Vendedor). ID=', NEW.ID,
            ', SKU=', NEW.SKU,
            ', Nombre=', NEW.name
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT(
            'Producto actualizado (Rol Vendedor). ID=', NEW.ID
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT(
            'Producto eliminado (Rol Vendedor). ID=', OLD.ID,
            ', SKU=', OLD.SKU
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `nick` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (2,'yazmin.esquivel@utxicotepec.edu.mx','Yazmin','827ccb0eea8a706c4c34a16891f84e7b','2026-09-08 11:40:30','2026-09-09 17:45:42',NULL),(5,'natali.martinez@utxicotepec.edu.mx','Natalia','827ccb0eea8a706c4c34a16891f84e7b','2026-09-08 11:41:28','2026-09-09 17:45:42',NULL),(6,'maria.hernandez@gmail.com','mari123','52dcb810931e20f7aa2f49b3510d3805','2026-09-08 12:05:04','2026-09-09 17:45:42',NULL),(7,'yomero@gmail.com','yaz123','52dcb810931e20f7aa2f49b3510d3805','2026-09-08 12:05:21','2026-09-09 18:25:26',NULL),(9,'240220@utxicotepec.edu.mx','sam123','52dcb810931e20f7aa2f49b3510d3805','2026-09-08 12:05:45','2026-09-09 17:45:42',NULL),(13,'carlos.mendoza@utxicotepec.edu.mx','Carlos','827ccb0eea8a706c4c34a16891f84e7b','2026-09-22 11:45:28',NULL,NULL),(14,'ana.lopez@utxicotepec.edu.mx','Ana','827ccb0eea8a706c4c34a16891f84e7b','2026-09-22 11:45:28',NULL,NULL),(15,'sofia.reyes@utxicotepec.edu.mx','Sofi','827ccb0eea8a706c4c34a16891f84e7b','2026-09-22 11:45:28',NULL,NULL);
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Create',
        USER(),
        CONCAT(
            'Usuario creado. ID=', NEW.ID,
            ', email=', NEW.email,
            ', nick=', NEW.nick
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_update` AFTER UPDATE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Update',
        USER(),
        CONCAT(
            'Usuario actualizado. ID=', NEW.ID,
            '. Cambios: ',
            CONCAT_WS(
                ', ',
                IF(
                    NOT (OLD.email <=> NEW.email),
                    CONCAT(
                        'email: [',
                        COALESCE(OLD.email, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.email, 'NULL'),
                        ']'
                    ),
                    NULL
                ),
                IF(
                    NOT (OLD.nickname <=> NEW.nickname),
                    CONCAT(
                        'nickname: [',
                        COALESCE(OLD.nickname, 'NULL'),
                        '] -> [',
                        COALESCE(NEW.nickname, 'NULL'),
                        ']'
                    ),
                    NULL
                )
            )
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_delete` AFTER DELETE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        operation,
        db_users,
        description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Delete',
        USER(),
        CONCAT(
            'Usuario eliminado. ID=', OLD.ID,
            ', email=', OLD.email,
            ', nickname=', OLD.nickname
        ),
        CURRENT_TIMESTAMP,
        b'1'
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

-- Dump completed on 2026-09-22 12:01:14
