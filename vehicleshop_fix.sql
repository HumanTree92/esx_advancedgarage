
USE `essentialmode`;

CREATE TABLE `owned_vehicles` (
	`owner` varchar(22) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext NOT NULL,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NOT NULL DEFAULT '',
	`stored` TINYINT(1) NOT NULL DEFAULT '0',

	PRIMARY KEY (`plate`)
);
