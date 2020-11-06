USE `es_extended`;

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
	`owner` varchar(40) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` varchar(20) NOT NULL DEFAULT 'car',
	`job` varchar(20) NOT NULL DEFAULT 'civ',
	`stored` tinyint(1) NOT NULL DEFAULT '0',
	`garage` varchar(255) NOT NULL DEFAULT 'Los_Santos',
	
	PRIMARY KEY (`plate`)
);
