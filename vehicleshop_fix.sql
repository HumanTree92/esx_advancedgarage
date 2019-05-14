-- Changed version of owned_vehicles to remove issues with car's not showing up

USE `essentialmode`;

CREATE TABLE `owned_vehicles` (
	`owner` varchar(22) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NOT NULL DEFAULT '',
	`stored` TINYINT(1) NOT NULL DEFAULT '0',

	PRIMARY KEY (`plate`)
);

-- My owned_vehicles that i use

USE `essentialmode`;

CREATE TABLE `owned_vehicles` (
	`owner` varchar(30) NOT NULL,
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext NOT NULL,
	`type` VARCHAR(20) NOT NULL DEFAULT 'car',
	`job` VARCHAR(20) NOT NULL,
	`stored` TINYINT(1) NOT NULL DEFAULT '0',

	PRIMARY KEY (`plate`)
);
