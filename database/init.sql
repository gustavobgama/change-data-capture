GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator' IDENTIFIED BY 'replpass';

GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium' IDENTIFIED BY 'dbz';

CREATE DATABASE IF NOT EXISTS inventory DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

USE inventory;

CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1008 DEFAULT CHARSET=utf8;

INSERT INTO `customers` VALUES 
    (1001,'Sally','Thomas','sally.thomas@acme.com'),
    (1002,'George','Bailey','gbailey@foobar.com'),
    (1003,'Edward','Walker','ed@walker.com'),
    (1004,'Anne','Kretchmar','annek@noanswer.org');
