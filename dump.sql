CREATE DATABASE  IF NOT EXISTS `immo_la2_poo1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `immo_la2_poo1`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: immo_la2_poo1
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

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
-- Table structure for table `BAIL`
--

DROP TABLE IF EXISTS `BAIL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BAIL` (
  `ID_BAIL` int NOT NULL AUTO_INCREMENT,
  `ID_TIERS_AGENT` int NOT NULL,
  `DATE_EFFET_BAIL` date NOT NULL,
  `DUREE_BAIL` int NOT NULL DEFAULT '3' COMMENT 'Durée du bail en années',
  `MOIS_RECONDUCTION_BAIL` int NOT NULL COMMENT 'Numéro du mois de reconduction du bail',
  `DUREE_CONGE_DEPART` int NOT NULL DEFAULT '3' COMMENT 'Durée du congé de départ en nombre de mois',
  `LOYER_INITIAL` decimal(8,2) NOT NULL,
  `MONTANT_DERNIER_LOYER` decimal(8,2) DEFAULT '0.00',
  `DATE_REVISION_ANNUELLE` date DEFAULT NULL,
  `COMMENTAIRE_CALCUL` varchar(100) DEFAULT NULL,
  `IRL_BASE` varchar(20) DEFAULT NULL,
  `VALEUR_IRL_BASE` decimal(5,2) DEFAULT NULL,
  `PROVISION_CHARGES` decimal(5,2) NOT NULL DEFAULT '0.00',
  `OBJET_CHARGES` varchar(100) DEFAULT NULL,
  `JOUR_ECHEANCE` int NOT NULL DEFAULT '5' COMMENT 'No du jour d''échéance, compris entre 1 et 10',
  `MODE_REGLEMENT` varchar(5) DEFAULT NULL,
  `MONTANT_DEPOT_GARANTIE` decimal(7,2) NOT NULL DEFAULT '0.00',
  `ID_BIEN` int NOT NULL COMMENT 'Identifiant du bien concerné',
  `DATE_RECEPTION_PREAVIS_FIN` date DEFAULT NULL,
  `DATE_FIN_BAIL` date DEFAULT NULL,
  `VALIDE` int NOT NULL DEFAULT '0',
  `ETAT_BAIL` varchar(10) DEFAULT 'EN COURS',
  `ID_DESTINATION` int NOT NULL DEFAULT '1' /*!80023 INVISIBLE */,
  PRIMARY KEY (`ID_BAIL`),
  KEY `BAIL___fk_BIEN` (`ID_BIEN`),
  KEY `BAIL_DESTINATION_ID_DESTINATION_fk` (`ID_DESTINATION`),
  CONSTRAINT `BAIL___fk_BIEN` FOREIGN KEY (`ID_BIEN`) REFERENCES `BIEN` (`ID_BIEN`) ON DELETE CASCADE,
  CONSTRAINT `BAIL_DESTINATION_ID_DESTINATION_fk` FOREIGN KEY (`ID_DESTINATION`) REFERENCES `DESTINATION` (`ID_DESTINATION`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BAIL`
--

LOCK TABLES `BAIL` WRITE;
/*!40000 ALTER TABLE `BAIL` DISABLE KEYS */;
INSERT INTO `BAIL` (`ID_BAIL`, `ID_TIERS_AGENT`, `DATE_EFFET_BAIL`, `DUREE_BAIL`, `MOIS_RECONDUCTION_BAIL`, `DUREE_CONGE_DEPART`, `LOYER_INITIAL`, `MONTANT_DERNIER_LOYER`, `DATE_REVISION_ANNUELLE`, `COMMENTAIRE_CALCUL`, `IRL_BASE`, `VALEUR_IRL_BASE`, `PROVISION_CHARGES`, `OBJET_CHARGES`, `JOUR_ECHEANCE`, `MODE_REGLEMENT`, `MONTANT_DEPOT_GARANTIE`, `ID_BIEN`, `DATE_RECEPTION_PREAVIS_FIN`, `DATE_FIN_BAIL`, `VALIDE`, `ETAT_BAIL`, `ID_DESTINATION`) VALUES (7,15,'2023-02-01',3,2,3,500.00,0.00,NULL,NULL,'2023-T4',100.00,0.00,NULL,5,NULL,1000.00,1,NULL,'2023-02-28',0,'TERMINE',1),(9,15,'2023-03-01',3,3,3,500.00,0.00,NULL,NULL,'2023-T4',100.00,0.00,NULL,5,NULL,1000.00,1,NULL,NULL,0,'EN COURS',1);
/*!40000 ALTER TABLE `BAIL` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`ilg`@`localhost`*/ /*!50003 TRIGGER `BAIL_AFTER_INSERT` AFTER INSERT ON `BAIL` FOR EACH ROW BEGIN
    /* Recherche de tous les propriétaires du bien */
    DECLARE v_fin BOOLEAN DEFAULT FALSE;
    DECLARE v_id_tiers INT DEFAULT 0;
    DECLARE v_part_tiers INT DEFAULT 0;
    DECLARE v_curseur CURSOR FOR SELECT ID_TIERS,PART FROM PROPRIETE WHERE ID_BIEN = NEW.ID_BIEN;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;

    OPEN v_curseur;
    labelcurseur : LOOP
    FETCH v_curseur INTO v_id_tiers,v_part_tiers;
    IF v_fin THEN
     LEAVE labelcurseur;
    END IF;
    CALL CreationHonorairesProprietaire(NEW.ID_BAIL,v_id_tiers,v_part_tiers);
 END LOOP labelcurseur;
CLOSE v_curseur;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `BIEN`
--

DROP TABLE IF EXISTS `BIEN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BIEN` (
  `ID_BIEN` int NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du bien',
  `LIB_BIEN` varchar(50) NOT NULL COMMENT 'description du bien',
  `ADR_NO_VOIE` varchar(7) DEFAULT NULL COMMENT 'Numéro dans la voie',
  `NOM_VOIE` varchar(100) DEFAULT NULL COMMENT 'Nom de la voie',
  `CODE_POSTAL` varchar(5) DEFAULT NULL COMMENT 'Code postal de la commune',
  `COMMUNE` varchar(100) DEFAULT NULL COMMENT 'Nom de la commune',
  `COMPLEMENT_ADRESSE` varchar(5) DEFAULT NULL COMMENT 'Exemple : N° appartement, étage ...',
  `DATE_CREATION` datetime NOT NULL,
  `DATE_DERNIERE_MAJ` datetime NOT NULL,
  `SURFACE_HABITABLE` decimal(5,1) NOT NULL DEFAULT '20.0',
  `NOMBRE_PIECES` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`ID_BIEN`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BIEN`
--

LOCK TABLES `BIEN` WRITE;
/*!40000 ALTER TABLE `BIEN` DISABLE KEYS */;
INSERT INTO `BIEN` VALUES (1,'Appartement croisé','1','Avenue Foch','59700','MARCQ EN BAROEUL','56','2024-01-21 13:11:42','2024-01-21 13:11:46',154.0,7),(2,'Appartement Zup Sud','42','Bouleavrd Albert 1er','35200','RENNES','15','2024-01-21 13:11:42','2024-01-21 13:11:46',100.0,4),(3,'SUPER ECOLE',NULL,NULL,'62000','LENS',NULL,'1970-01-01 00:00:00','1970-01-01 00:00:00',15.0,1),(4,'SUPER ECOLE',NULL,NULL,'62000','LENS',NULL,'1970-01-01 00:00:00','1970-01-01 00:00:00',15.0,1);
/*!40000 ALTER TABLE `BIEN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DESTINATION`
--

DROP TABLE IF EXISTS `DESTINATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DESTINATION` (
  `ID_DESTINATION` int NOT NULL AUTO_INCREMENT,
  `LIB_DESTINATION` varchar(100) NOT NULL,
  PRIMARY KEY (`ID_DESTINATION`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DESTINATION`
--

LOCK TABLES `DESTINATION` WRITE;
/*!40000 ALTER TABLE `DESTINATION` DISABLE KEYS */;
INSERT INTO `DESTINATION` VALUES (1,'Résidence principale'),(2,'Profession libérale'),(3,'Résidence secondaire'),(4,'Commerce');
/*!40000 ALTER TABLE `DESTINATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HONORAIRE`
--

DROP TABLE IF EXISTS `HONORAIRE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HONORAIRE` (
  `ID_HONORAIRE` int NOT NULL AUTO_INCREMENT,
  `ID_TIERS` int NOT NULL,
  `ID_TYPE_HONORAIRE` int NOT NULL,
  `ID_BAIL` int NOT NULL,
  `MONTANT_HONORAIRE` decimal(7,2) DEFAULT NULL,
  `DATE_REGLEMENT` date DEFAULT NULL,
  PRIMARY KEY (`ID_HONORAIRE`),
  KEY `HONORAIRE_TYPE_HONORAIRE_ID_TYPE_HONORAIRE_fk` (`ID_TYPE_HONORAIRE`),
  KEY `HONORAIRE_TIERS_ID_TIERS_fk` (`ID_TIERS`),
  CONSTRAINT `HONORAIRE_TIERS_ID_TIERS_fk` FOREIGN KEY (`ID_TIERS`) REFERENCES `TIERS` (`ID_TIERS`),
  CONSTRAINT `HONORAIRE_TYPE_HONORAIRE_ID_TYPE_HONORAIRE_fk` FOREIGN KEY (`ID_TYPE_HONORAIRE`) REFERENCES `TYPE_HONORAIRE` (`ID_TYPE_HONORAIRE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HONORAIRE`
--

LOCK TABLES `HONORAIRE` WRITE;
/*!40000 ALTER TABLE `HONORAIRE` DISABLE KEYS */;
/*!40000 ALTER TABLE `HONORAIRE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROPRIETE`
--

DROP TABLE IF EXISTS `PROPRIETE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PROPRIETE` (
  `ID_TIERS` int NOT NULL,
  `ID_BIEN` int NOT NULL,
  `PART` int NOT NULL DEFAULT '100',
  PRIMARY KEY (`ID_TIERS`,`ID_BIEN`),
  KEY `PROPRIETE_BIEN_ID_BIEN_fk` (`ID_BIEN`),
  CONSTRAINT `PROPRIETE_BIEN_ID_BIEN_fk` FOREIGN KEY (`ID_BIEN`) REFERENCES `BIEN` (`ID_BIEN`),
  CONSTRAINT `PROPRIETE_TIERS_ID_TIERS_fk` FOREIGN KEY (`ID_TIERS`) REFERENCES `TIERS` (`ID_TIERS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROPRIETE`
--

LOCK TABLES `PROPRIETE` WRITE;
/*!40000 ALTER TABLE `PROPRIETE` DISABLE KEYS */;
INSERT INTO `PROPRIETE` VALUES (1,1,100),(4,2,25),(5,2,25),(6,2,50);
/*!40000 ALTER TABLE `PROPRIETE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SIGNATURE`
--

DROP TABLE IF EXISTS `SIGNATURE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SIGNATURE` (
  `ID_SIGNATURE` int NOT NULL AUTO_INCREMENT,
  `TYPE_SIGNATURE` varchar(1) DEFAULT NULL,
  `DATE_SIGNATURE` date DEFAULT NULL,
  `ID_BAIL` int NOT NULL,
  `ID_TIERS` int NOT NULL,
  PRIMARY KEY (`ID_SIGNATURE`),
  KEY `SIGNATURE_BAIL_ID_BAIL_fk` (`ID_BAIL`),
  KEY `SIGNATURE_TIERS_ID_TIERS_fk` (`ID_TIERS`),
  CONSTRAINT `SIGNATURE_BAIL_ID_BAIL_fk` FOREIGN KEY (`ID_BAIL`) REFERENCES `BAIL` (`ID_BAIL`),
  CONSTRAINT `SIGNATURE_TIERS_ID_TIERS_fk` FOREIGN KEY (`ID_TIERS`) REFERENCES `TIERS` (`ID_TIERS`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SIGNATURE`
--

LOCK TABLES `SIGNATURE` WRITE;
/*!40000 ALTER TABLE `SIGNATURE` DISABLE KEYS */;
INSERT INTO `SIGNATURE` VALUES (2,'L',NULL,9,7);
/*!40000 ALTER TABLE `SIGNATURE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TIERS`
--

DROP TABLE IF EXISTS `TIERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TIERS` (
  `ID_TIERS` int NOT NULL AUTO_INCREMENT,
  `NOM_TIERS` varchar(100) NOT NULL COMMENT 'Nom du tiers ou raison sociale',
  `PRENOM_TIERS` varchar(100) DEFAULT NULL COMMENT 'Prénom du tiers si personne physique',
  `TEL_TIERS` varchar(10) NOT NULL DEFAULT '00000000' COMMENT 'No de téléphone du tiers',
  `MAIL_TIERS` varchar(100) DEFAULT NULL COMMENT 'Adresse mail du tiers',
  `TYPE_TIERS` int NOT NULL DEFAULT '1' COMMENT 'Type de tiers',
  `NAISSANCE_TIERS` date DEFAULT NULL,
  `ADRESSE_TIERS` varchar(100) DEFAULT NULL COMMENT 'Adresse du tiers',
  `CP_TIERS` char(5) DEFAULT NULL,
  `VILLE_TIERS` varchar(100) DEFAULT NULL,
  `PIECE_IDENTITE_TIERS` varchar(1000) DEFAULT NULL COMMENT 'Pièce identitié du tiers, chemin d accès au fichier',
  `RIB_TIERS` varchar(1000) DEFAULT NULL COMMENT 'RIB TIERS , chemin d accès au fichier',
  `NUMERO_SS_TIERS` char(15) DEFAULT NULL,
  PRIMARY KEY (`ID_TIERS`),
  KEY `TIERS_TYPE_TIERS_ID_TYPE_TIERS_fk` (`TYPE_TIERS`),
  CONSTRAINT `TIERS_TYPE_TIERS_ID_TYPE_TIERS_fk` FOREIGN KEY (`TYPE_TIERS`) REFERENCES `TYPE_TIERS` (`ID_TYPE_TIERS`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TIERS`
--

LOCK TABLES `TIERS` WRITE;
/*!40000 ALTER TABLE `TIERS` DISABLE KEYS */;
INSERT INTO `TIERS` VALUES (1,'DUPONT','PIERRE','00000000','pdupont@gmail.com',2,'1954-01-21','20 Rue de l\'herrengrie','59700','MARCQ EN BAROEUL','/tmp/pi.pdf','/tmp/rib.pdf','154015935063445'),(2,'DURAND','MARIE','00000000','mdurand@gmail.com',2,'1970-11-27','192 Bd du général de Gaulle','59100','ROUBAIX','/tmp/pi.pdf','/tmp/rib.pdf','270113556412578'),(3,'DUVAL','Jeanne','00000000',NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'DUPOND','Anne','0678787878',NULL,1,'1970-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(5,'CURIE','Sylvain','0678787878',NULL,2,'1890-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(6,'CURIE','Marie','0678787878',NULL,2,'1890-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(7,'EINSTEIN','Jane','0678787878',NULL,1,'1890-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(8,'EINSTEIN','Pierre','0678787878',NULL,2,'1890-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(9,'EINSTEIN','Albert','0678787878',NULL,2,'1890-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(10,'EINSTEIN','Zoe','0678787878',NULL,2,'1890-12-31',NULL,NULL,NULL,NULL,NULL,NULL),(14,'VALLE','Isabelle','0909090909','',1,'1970-12-12',NULL,NULL,NULL,NULL,NULL,NULL),(15,'MICHKA','Chloé','0909090909',NULL,3,'2001-08-18',NULL,NULL,NULL,NULL,NULL,NULL),(21,'LE GLAZ','Isabelle','00000000','isabelle.le-glaz@centralelille.fr',2,'2000-10-10','XXXX','59290','MARCQ EN BAROEUL','kjskqsjdsqh','XXX','XXXXX'),(22,'LE GLAZ','Isabelle','00000000','isabelle.le-glaz@centralelille.fr',2,'2000-10-10','XXXX','59290','MARCQ EN BAROEUL','kjskqsjdsqh','XXX','XXXXX'),(23,'LE GLAZ','Isabelle','00000000','isabelle.le-glaz@centralelille.fr',2,'2000-10-10','XXXX','59290','MARCQ EN BAROEUL','kjskqsjdsqh','XXX','XXXXX');
/*!40000 ALTER TABLE `TIERS` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`ilg`@`localhost`*/ /*!50003 TRIGGER `TIERS_BEFORE_INSERT` BEFORE INSERT ON `TIERS` FOR EACH ROW BEGIN
SET NEW.NOM_TIERS = UPPER(NEW.NOm_TIERS);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`ilg`@`localhost`*/ /*!50003 TRIGGER `TIERS_BEFORE_UPDATE` BEFORE UPDATE ON `TIERS` FOR EACH ROW BEGIN
SET NEW.NOM_TIERS = UPPER(NEW.NOm_TIERS);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `TYPE_HONORAIRE`
--

DROP TABLE IF EXISTS `TYPE_HONORAIRE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TYPE_HONORAIRE` (
  `ID_TYPE_HONORAIRE` int NOT NULL AUTO_INCREMENT,
  `TYPE_HONORAIRE` varchar(100) NOT NULL,
  `PAYE_PAR` char(1) NOT NULL DEFAULT 'P',
  `VALEUR_TARIF` decimal(5,2) NOT NULL DEFAULT '0.00',
  `TYPE_TARIF` varchar(100) NOT NULL DEFAULT 'POURCENTAGE',
  PRIMARY KEY (`ID_TYPE_HONORAIRE`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TYPE_HONORAIRE`
--

LOCK TABLES `TYPE_HONORAIRE` WRITE;
/*!40000 ALTER TABLE `TYPE_HONORAIRE` DISABLE KEYS */;
INSERT INTO `TYPE_HONORAIRE` VALUES (1,'Visite, constitution de dossier, rédaction de bail','P',60.00,'POURCENTAGE'),(2,'Entremise et négociation','P',15.00,'POURCENTAGE'),(3,'Etat des lieux d’entrée','P',10.00,'CONSTANTE'),(4,'Visite, constitution de dossier, rédaction de bail','L',60.00,'POURCENTAGE'),(5,'Etat des lieux d’entrée','L',10.00,'CONSTANTE');
/*!40000 ALTER TABLE `TYPE_HONORAIRE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TYPE_TIERS`
--

DROP TABLE IF EXISTS `TYPE_TIERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TYPE_TIERS` (
  `ID_TYPE_TIERS` int NOT NULL AUTO_INCREMENT,
  `LIB_TYPE_TIERS` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_TYPE_TIERS`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TYPE_TIERS`
--

LOCK TABLES `TYPE_TIERS` WRITE;
/*!40000 ALTER TABLE `TYPE_TIERS` DISABLE KEYS */;
INSERT INTO `TYPE_TIERS` VALUES (1,'LOCATAIRE'),(2,'PROPRIETAIRE'),(3,'AGENT IMMOBILIER'),(4,'GARANT'),(11,'CHANGEMENT DE TYPE');
/*!40000 ALTER TABLE `TYPE_TIERS` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`ilg`@`localhost`*/ /*!50003 TRIGGER `TYPE_TIERS_BEFORE_INSERT` BEFORE INSERT ON `TYPE_TIERS` FOR EACH ROW BEGIN
SET NEW.LIB_TYPE_TIERS = UPPER(NEW.LIB_TYPE_TIERS);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`ilg`@`localhost`*/ /*!50003 TRIGGER `TYPE_TIERS_BEFORE_UPDATE` BEFORE UPDATE ON `TYPE_TIERS` FOR EACH ROW BEGIN
SET NEW.LIB_TYPE_TIERS = UPPER(NEW.LIB_TYPE_TIERS);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'immo_la2_poo1'
--
/*!50003 DROP FUNCTION IF EXISTS `ControleProprietaireBail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` FUNCTION `ControleProprietaireBail`(P_ID_BAIL INT,P_ID_PROPRIETAIRE INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE V_RESULTAT BOOLEAN DEFAULT FALSE ;
    DECLARE V_BIEN INT DEFAULT 0;
    DECLARE V_NB_PROPRIETAIRES INT DEFAULT 0;
    SELECT ID_BIEN INTO V_BIEN FROM BAIL WHERE ID_BAIL = P_ID_BAIL;
    SELECT count(*) INTO V_NB_PROPRIETAIRES FROM PROPRIETE WHERE ID_TIERS= P_ID_PROPRIETAIRE AND ID_BIEN = V_BIEN;
    IF ( V_NB_PROPRIETAIRES  = 1 ) THEN
        SET V_RESULTAT = TRUE;
    end if;
    RETURN V_RESULTAT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `estProprietaire` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` FUNCTION `estProprietaire`(P_ID_TIERS INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE V_TYPE_TIERS VARCHAR(50) DEFAULT 0;
    SELECT TYPE_TIERS.LIB_TYPE_TIERS INTO V_TYPE_TIERS FROM TYPE_TIERS,TIERS
    WHERE TIERS.TYPE_TIERS= TYPE_TIERS.ID_TYPE_TIERS AND ID_TIERS=P_ID_TIERS;
    IF ( V_TYPE_TIERS = "PROPRIETAIRE") THEN
        RETURN(TRUE);
    ELSE
        RETURN(FALSE);
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `LoyerBail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` FUNCTION `LoyerBail`(P_ID_BAIL INT) RETURNS decimal(5,2)
    DETERMINISTIC
BEGIN
    DECLARE V_RESULTAT DECIMAL(5,2) DEFAULT NULL ;
    SELECT LOYER_INITIAL INTO V_RESULTAT FROM BAIL WHERE ID_BAIL = P_ID_BAIL;
    RETURN V_RESULTAT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `PiecesBail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` FUNCTION `PiecesBail`(P_ID_BAIL INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE V_RESULTAT INT DEFAULT NULL ;
    DECLARE V_BIEN INT DEFAULT 0;
    SELECT ID_BIEN INTO V_BIEN FROM BAIL WHERE ID_BAIL = P_ID_BAIL;
    SELECT NOMBRE_PIECES INTO V_RESULTAT FROM BIEN WHERE ID_BIEN = V_BIEN;
    RETURN V_RESULTAT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AjoutLocataire` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` PROCEDURE `AjoutLocataire`(IN P_ID_BAIL INT, IN P_ID_LOCATAIRE INT)
BEGIN
    DECLARE V_TYPE_TIERS VARCHAR(50) DEFAULT 0;
    SELECT TYPE_TIERS.LIB_TYPE_TIERS INTO V_TYPE_TIERS FROM TYPE_TIERS,TIERS
    WHERE TIERS.TYPE_TIERS= TYPE_TIERS.ID_TYPE_TIERS AND ID_TIERS=P_ID_LOCATAIRE;
    IF ( V_TYPE_TIERS = "LOCATAIRE") THEN
        INSERT INTO SIGNATURE(TYPE_SIGNATURE,ID_TIERS,ID_BAIL) VALUES ('L',P_ID_LOCATAIRE,P_ID_BAIL);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur - le tiers indiqué n est pas un locataire';
    end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreationBail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` PROCEDURE `CreationBail`(IN P_ID_BIEN INT,IN P_ID_AGENT INT, IN P_DATE_EFFET DATE,IN P_LOYER DECIMAL(7,2),IN P_IRL_BASE VARCHAR(20), IN P_IRL DECIMAL(5,2),IN P_CHARGES DECIMAL(5,2))
BEGIN
    DECLARE V_TYPE_TIERS VARCHAR(50) DEFAULT 0;
    DECLARE V_MOIS_RECONDUCTION INT DEFAULT 1;
    DECLARE V_DEPOT_GARANTIE DECIMAL(7,2) DEFAULT 0;
    DECLARE V_NB_BAIL INT DEFAULT 0;
    DECLARE V_ID_BAIL_PRECEDENT INT DEFAULT 0;
    DECLARE V_DATE_FIN_BAIL DATE;

    /* Il faut vérifier qu'il n'existe pas de bail avec une période de couverture commune avec celui qu'on va rechercher */
    /* c'est à dire que le dernier bail a bien une date de fin inférieure à la date d'effet */
        SELECT count(*) INTO V_NB_BAIL FROM BAIL WHERE ID_BIEN = P_ID_BIEN AND ETAT_BAIL <> 'TERMINE';

    IF (V_NB_BAIL > 0) THEN
        /* On a un bail en cours */
        SELECT ID_BAIL ,DATE_FIN_BAIL INTO V_ID_BAIL_PRECEDENT, V_DATE_FIN_BAIL
        FROM BAIL WHERE ID_BIEN = P_ID_BIEN AND ETAT_BAIL <> 'TERMINE';
        IF (V_DATE_FIN_BAIL > P_DATE_EFFET) THEN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Erreur - il y a déjà un bail en cours sur cette période';
        end if;
    end if ;
    /* Vérification du type de tiers pour le tiers agent */
    SELECT TYPE_TIERS.LIB_TYPE_TIERS INTO V_TYPE_TIERS FROM TYPE_TIERS,TIERS
    WHERE TIERS.TYPE_TIERS= TYPE_TIERS.ID_TYPE_TIERS AND ID_TIERS=P_ID_AGENT;
    SET V_MOIS_RECONDUCTION = MONTH(P_DATE_EFFET);
    SET V_DEPOT_GARANTIE = 2 * P_LOYER;
    IF ( V_TYPE_TIERS = "AGENT IMMOBILIER") THEN
    INSERT INTO BAIL (ID_BIEN,ID_TIERS_AGENT,DATE_EFFET_BAIL,LOYER_INITIAL,IRL_BASE,VALEUR_IRL_BASE,MOIS_RECONDUCTION_BAIL,MONTANT_DEPOT_GARANTIE)
    VALUES (P_ID_BIEN,P_ID_AGENT,P_DATE_EFFET,P_LOYER,P_IRL_BASE,P_IRL,V_MOIS_RECONDUCTION,V_DEPOT_GARANTIE);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur - le tiers indiqué n est pas un agent immobilier';
    END IF;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreationHonorairesProprietaire` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ilg`@`localhost` PROCEDURE `CreationHonorairesProprietaire`(IN P_ID_BAIL INT, IN P_ID_TIERS INT,IN P_PART_TIERS INT)
BEGIN
        DECLARE v_fin BOOLEAN DEFAULT FALSE;
        DECLARE v_id_type INT DEFAULT 0;
        DECLARE v_type VARCHAR(100);
        DECLARE v_paye_par VARCHAR(1) DEFAULT 'X';
        DECLARE v_type_tarif VARCHAR(100);
        DECLARE v_valeur_tarif DECIMAL(5,2);
        DECLARE v_montant_honoraire DECIMAL(5,2) DEFAULT 0;
        DECLARE v_curseur CURSOR FOR SELECT ID_TYPE_HONORAIRE,TYPE_HONORAIRE,PAYE_PAR,TYPE_TARIF,VALEUR_TARIF FROM TYPE_HONORAIRE WHERE PAYE_PAR='P';
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_fin = TRUE;

        /* Controle du proprietaire fourni */
IF ( ControleProprietaireBail(P_ID_BAIL,P_ID_TIERS)) THEN
        OPEN v_curseur;
        /* Balayage des honoraires dus par le prorpiétaire */
labelcurseur : LOOP
  FETCH v_curseur INTO v_id_type,v_type,v_paye_par,v_type_tarif,v_valeur_tarif;
  IF v_fin THEN
   LEAVE labelcurseur;
  END IF;
  IF (v_type_tarif = 'POURCENTAGE') THEN
      /* Il nous faut le montant du loyer pour calculer */
      SET v_montant_honoraire = (P_PART_TIERS /100 ) * LoyerBail(P_ID_BAIL) * v_valeur_tarif /100;
      INSERT INTO HONORAIRE(ID_TIERS,ID_TYPE_HONORAIRE,ID_BAIL,MONTANT_HONORAIRE)
          VALUES(P_ID_TIERS,v_id_type,P_ID_BAIL,v_montant_honoraire);
  end if;
  IF (v_type_tarif = 'CONSTANTE') THEN
      /* Il nous faut le nombre de pieces pour calculer l'honoraire */
      SET v_montant_honoraire = PiecesBail(P_ID_BAIL) * v_valeur_tarif;
      INSERT INTO HONORAIRE(ID_TIERS,ID_TYPE_HONORAIRE,ID_BAIL,MONTANT_HONORAIRE)
          VALUES(P_ID_TIERS,v_id_type,P_ID_BAIL,v_montant_honoraire);
  end if;
END LOOP labelcurseur;
CLOSE v_curseur;

ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erreur - le tiers indiqué n est pas un proprietaire associé au bail';
END IF;
 end ;;
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

-- Dump completed on 2024-02-14  8:18:56
