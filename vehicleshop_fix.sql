-- This should fix the issue of the Car Garage not showing Vehicles.

USE `essentialmode`;

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(30) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) NOT NULL DEFAULT '',
  `stored` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`plate`)
);
