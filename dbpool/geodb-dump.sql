CREATE SCHEMA geodb;
USING geodb;

-- MariaDB dump 10.19  Distrib 10.6.12-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: geodb
-- ------------------------------------------------------
-- Server version	10.6.12-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `BOXES`
--
DROP TABLE IF EXISTS `TECHNOLANG`;
create TABLE TECHNOLANG(
                           technoid VARCHAR(40),
                           langid VARCHAR(40)
);
DROP TABLE IF EXISTS `BOXES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BOXES` (
  `id` varchar(40) NOT NULL,
  `ent_type` varchar(40) DEFAULT NULL,
  `json` varchar(4000) DEFAULT NULL,
  `x0` double DEFAULT NULL,
  `y0` double DEFAULT NULL,
  `x1` double DEFAULT NULL,
  `y1` double DEFAULT NULL,
  `visible_size` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BOXES`
--

LOCK TABLES `BOXES` WRITE;
/*!40000 ALTER TABLE `BOXES` DISABLE KEYS */;
INSERT INTO `BOXES` VALUES ('cb044690-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"cb044690-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"FETCH_DATA\",\"anchor\":{\"x\":400,\"y\":475,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[{\"ref\":\"db2b8f62-e5c0-11ed-97a6-3d61cba2bb21\"}],\"incomingLinks\":[],\"ent_type\":\"Drawable\"}',400,475,600,525,200),('cb90f631-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"cb90f631-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"SLICE\",\"anchor\":{\"x\":750,\"y\":650,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[{\"ref\":\"f6d9bde2-e5c0-11ed-9765-0b2baba1be26\"}],\"incomingLinks\":[{\"ref\":\"db2b8f62-e5c0-11ed-97a6-3d61cba2bb21\"}],\"ent_type\":\"Drawable\"}',750,650,950,700,200),('ccc27151-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"ccc27151-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"TRANSFORM\",\"anchor\":{\"x\":1050,\"y\":425,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[{\"ref\":\"ce277f91-e5c0-11ed-97a6-3d61cba2bb21\"},{\"ref\":\"d0429761-e5c0-11ed-97a6-3d61cba2bb21\"},{\"ref\":\"d22bc9c1-e5c0-11ed-97a6-3d61cba2bb21\"}],\"outgoingLinks\":[],\"incomingLinks\":[{\"ref\":\"dc562cb2-e5c0-11ed-97a6-3d61cba2bb21\"}],\"ent_type\":\"Drawable\"}',1050,425,1250,475,200),('ce277f91-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"ce277f91-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"TRANSFORM\",\"anchor\":{\"x\":1125,\"y\":475,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[{\"ref\":\"de2917f2-e5c0-11ed-97a6-3d61cba2bb21\"}],\"incomingLinks\":[{\"ref\":\"f6d9bde2-e5c0-11ed-9765-0b2baba1be26\"}],\"ent_type\":\"Drawable\"}',1125,475,1325,525,200),('d0429761-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"d0429761-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"TRANSFORM\",\"anchor\":{\"x\":1475,\"y\":625,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[{\"ref\":\"dffdd7f1-e5c0-11ed-97a6-3d61cba2bb21\"}],\"incomingLinks\":[{\"ref\":\"de2917f2-e5c0-11ed-97a6-3d61cba2bb21\"}],\"ent_type\":\"Drawable\"}',1475,625,1675,675,200),('d22bc9c1-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"d22bc9c1-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"TRANSFORM\",\"anchor\":{\"x\":1850,\"y\":450,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[{\"ref\":\"e17eab92-e5c0-11ed-97a6-3d61cba2bb21\"}],\"incomingLinks\":[{\"ref\":\"dffdd7f1-e5c0-11ed-97a6-3d61cba2bb21\"}],\"ent_type\":\"Drawable\"}',1850,450,2050,500,200),('d3996381-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"d3996381-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"TRANSFORM\",\"anchor\":{\"x\":2200,\"y\":625,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[],\"incomingLinks\":[{\"ref\":\"e17eab92-e5c0-11ed-97a6-3d61cba2bb21\"}],\"ent_type\":\"Drawable\"}',2200,625,2400,675,200),('d6a9fee0-e5c0-11ed-97a6-3d61cba2bb21','Drawable','{\"id\":\"d6a9fee0-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"__INSTALL\",\"anchor\":{\"x\":425,\"y\":275,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":200,\"y\":50,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"outgoingLinks\":[],\"incomingLinks\":[],\"ent_type\":\"Drawable\"}',425,275,625,325,200),('db2b8f62-e5c0-11ed-97a6-3d61cba2bb21','Link','{\"id\":\"db2b8f62-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"LINK\",\"anchor\":{\"x\":425,\"y\":460,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":-1,\"y\":0,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"source\":{\"ref\":\"cb044690-e5c0-11ed-97a6-3d61cba2bb21\"},\"destination\":{\"ref\":\"cb90f631-e5c0-11ed-97a6-3d61cba2bb21\"},\"ent_type\":\"Link\"}',425,460,424,460,0),('de2917f2-e5c0-11ed-97a6-3d61cba2bb21','Link','{\"id\":\"de2917f2-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"LINK\",\"anchor\":{\"x\":1425,\"y\":510,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":-1,\"y\":0,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"source\":{\"ref\":\"ce277f91-e5c0-11ed-97a6-3d61cba2bb21\"},\"destination\":{\"ref\":\"d0429761-e5c0-11ed-97a6-3d61cba2bb21\"},\"ent_type\":\"Link\"}',1425,510,1424,510,0),('dffdd7f1-e5c0-11ed-97a6-3d61cba2bb21','Link','{\"id\":\"dffdd7f1-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"LINK\",\"anchor\":{\"x\":1650,\"y\":610,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":-1,\"y\":0,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"source\":{\"ref\":\"d0429761-e5c0-11ed-97a6-3d61cba2bb21\"},\"destination\":{\"ref\":\"d22bc9c1-e5c0-11ed-97a6-3d61cba2bb21\"},\"ent_type\":\"Link\"}',1650,610,1649,610,0),('e17eab92-e5c0-11ed-97a6-3d61cba2bb21','Link','{\"id\":\"e17eab92-e5c0-11ed-97a6-3d61cba2bb21\",\"name\":\"LINK\",\"anchor\":{\"x\":1875,\"y\":485,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":-1,\"y\":0,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"source\":{\"ref\":\"d22bc9c1-e5c0-11ed-97a6-3d61cba2bb21\"},\"destination\":{\"ref\":\"d3996381-e5c0-11ed-97a6-3d61cba2bb21\"},\"ent_type\":\"Link\"}',1875,485,1874,485,0),('f6d9bde2-e5c0-11ed-9765-0b2baba1be26','Link','{\"id\":\"f6d9bde2-e5c0-11ed-9765-0b2baba1be26\",\"name\":\"LINK\",\"anchor\":{\"x\":850,\"y\":460,\"z\":0,\"t\":0,\"tag\":\"\"},\"size\":{\"x\":-1,\"y\":0,\"z\":0,\"t\":0,\"tag\":\"\"},\"parent\":null,\"children\":[],\"source\":{\"ref\":\"cb90f631-e5c0-11ed-97a6-3d61cba2bb21\"},\"destination\":{\"ref\":\"ce277f91-e5c0-11ed-97a6-3d61cba2bb21\"},\"ent_type\":\"Link\"}',850,460,849,460,0);
/*!40000 ALTER TABLE `BOXES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `METADATA`
--

DROP TABLE IF EXISTS `METADATA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `METADATA` (
  `id` varchar(40) NOT NULL,
  `json` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `METADATA`
--

LOCK TABLES `METADATA` WRITE;
/*!40000 ALTER TABLE `METADATA` DISABLE KEYS */;
INSERT INTO `METADATA` VALUES ('cb044690-e5c0-11ed-97a6-3d61cba2bb21','{\"id\":\"cb044690-e5c0-11ed-97a6-3d61cba2bb21\",\"ent_type\":\"Drawable\",\"text\":\"\\ndefine type map<T>={[key:string]:T}\\n\\nasync function main(ports:Port[],services:Service[]):Promise<map<any>[]>{\\n  const cc=await fetch(`http://some.host/some/path`)\\n  const jj = await cc.json()\\n  return jj\\n}\\n\\n\",\"technology\":\"javascript-node\",\"content_type\":\"application/javascript\"}'),('cb90f631-e5c0-11ed-97a6-3d61cba2bb21','{\"id\":\"cb90f631-e5c0-11ed-97a6-3d61cba2bb21\",\"ent_type\":\"Drawable\",\"text\":\"async function main(ports:Port[],services:Service[]):Promise<map<any>[]>{\\n  ports.inp.fetch().forEach( d => ports.out.push(d) )\\n}\",\"technology\":\"javascript-node\",\"content_type\":\"application/javascript\"}'),('d6a9fee0-e5c0-11ed-97a6-3d61cba2bb21','{\"id\":\"d6a9fee0-e5c0-11ed-97a6-3d61cba2bb21\",\"ent_type\":\"Drawable\",\"text\":\"#/bin/bash\\n\\nif [ -n $(node -v) ]; then\\n  echo \\\"node is not installed\\\"\\n  curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - &&\\\\\\n  sudo apt-get install -y nodejs\\nelse\\n  echo \\\"nodejs is installed $(node -v)\\\"\\nfi\\n\\nnode -v\\nnpm -v\",\"technology\":\"javascript-node\",\"content_type\":\"application/javascript\"}');
/*!40000 ALTER TABLE `METADATA` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-28 14:57:54


create definer = admin@localhost function box_contains_point(px decimal(15), py decimal(15), bx0 decimal(15), by0 decimal(15), bx1 decimal(15), by1 decimal(15)) returns tinyint(1)
BEGIN
return px between bx0 and bx1 and py between by0 and by1;
END;


create definer = admin@localhost function box_intersects_box(ax0 decimal(15), ay0 decimal(15), ax1 decimal(15), ay1 decimal(15), bx0 decimal(15), by0 decimal(15), bx1 decimal(15), by1 decimal(15)) returns tinyint(1)
BEGIN
return box_contains_point(ax0,ay0, bx0,by0,bx1,by1)
  OR box_contains_point(ax0,ay1, bx0,by0,bx1,by1)
  OR box_contains_point(ax1,ay1, bx0,by0,bx1,by1)
  OR box_contains_point(ax1,ay0, bx0,by0,bx1,by1)
  OR box_contains_point(bx0,by0, ax0,ay0,ax1,ay1)
  OR box_contains_point(bx0,by1, ax0,ay0,ax1,ay1)
  OR box_contains_point(bx1,by1, ax0,ay0,ax1,ay1)
  OR box_contains_point(bx1,by0, ax0,ay0,ax1,ay1);
END;


create definer = admin@localhost function get_box(ax decimal(15), ay decimal(15), szx decimal(15), szy decimal(15)) returns geometry
BEGIN
return ST_POLYGONFROMTEXT(CONCAT(
        'POLYGON((',
        ax,' ',ay,',',
        ax+szx,' ',ay,',',
        ax+szx,' ',ay+szy,',',
        ax,' ',ay+szy,',',
        ax,' ',ay,'',
        '))'));
END;

create definer = admin@localhost function get_box_from_json(json varchar(4000)) returns geometry
BEGIN
	DECLARE ax NUMERIC(15);
	DECLARE ay NUMERIC(15);
	DECLARE szx NUMERIC(15);
	DECLARE szy NUMERIC(15);
	DECLARE boxtype VARCHAR(50);
SELECT JSON_VALUE(json,'$.ent_type') INTO boxtype;
SELECT JSON_VALUE(json,'$.anchor.x') INTO ax;
SELECT JSON_VALUE(json,'$.anchor.y') INTO ay;
SELECT JSON_VALUE(json,'$.size.x') INTO szx;
SELECT JSON_VALUE(json,'$.size.y') INTO szy;
return get_box(ax,ay,szx,szy);
END;


create definer = admin@localhost procedure store_box(IN ent_id varchar(40), IN ent_ent_type varchar(40), IN ent_json varchar(4000), IN ent_x0 double, IN ent_y0 double, IN ent_x1 double, IN ent_y1 double, IN ent_visible_size double)
BEGIN
DELETE FROM BOXES WHERE ID=ent_id;
COMMIT;
INSERT INTO BOXES(id,ent_type,json,x0,y0,x1,y1,visible_size)
VALUES (ent_id,ent_ent_type,ent_json,ent_x0,ent_y0,ent_x1,ent_y1,ent_visible_size);
COMMIT;
end;

