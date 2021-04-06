USE `es_extended`;

CREATE TABLE `owned_vehicles` (
	`owner` varchar(40) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NOT NULL DEFAULT 'civ',
	`category` VARCHAR(50) DEFAULT NULL,
	`name` varchar(60) NOT NULL DEFAULT 'Unknown',
	`fuel` int(11) NOT NULL DEFAULT '100',
	`stored` TINYINT(1) NOT NULL DEFAULT '0',

	PRIMARY KEY (`plate`)
);
