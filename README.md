# Description

Proof of concept using [Apache Kafka](https://kafka.apache.org/) and [Debezium](https://debezium.io/) to implement the [Change Data Capture](https://en.wikipedia.org/wiki/Change_data_capture) pattern to a MySQL database.

The goal here is to capture to a specific kafka topic the changes (insert, update and delete) made to the customers at its MySQL's table.

# Installation

[Docker](https://docs.docker.com/engine/install/) and [docker compose](https://docs.docker.com/compose/install/) are pre requisites and must be installed.

```shell
$ git clone https://github.com/gustavobgama/change-data-capture.git
$ cd change-data-capture && docker-compose up -d
```

## Create the MySQL connector

```shell
$ curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{"name":"inventory-connector","config":{"connector.class":"io.debezium.connector.mysql.MySqlConnector","tasks.max":"1","database.hostname":"mysql","database.port":"3306","database.user":"debezium","database.password":"dbz","database.server.id":"184054","database.server.name":"dbserver1","database.include.list":"inventory","database.history.kafka.bootstrap.servers":"kafka:9092","database.history.kafka.topic":"dbhistory.inventory"}}'
```

## Check if connector was correctly created:

```shell
$ curl -i -X GET -H "Accept:application/json" localhost:8083/connectors/inventory-connector
```

# Usage

Let's do some operations with the database table `customers` and observe the result at the correspondent kafka topic: `dbserver1.inventory.customers`.

Watch the topic `dbserver1.inventory.customers`:

```shell
$ docker-compose exec kafka /bin/kafka-console-consumer --bootstrap-server kafka:9092 --topic dbserver1.inventory.customers --from-beginning
```

Then make some database changes: 

## Insert a customer

```shell
$ docker-compose exec mysql sh -c 'MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql -uroot inventory -e "INSERT INTO customers (first_name, last_name, email) VALUES (\"John\", \"Doe\", \"john.doe@email.com\");"'
```

## Update a customer

```shell
$ docker-compose exec mysql sh -c 'MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql -uroot inventory -e "UPDATE customers SET first_name = \"Anne Marie\" WHERE id = 1004;"'
```

## Delete a customer

```shell
$ docker-compose exec mysql sh -c 'MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql -uroot inventory -e "DELETE customers WHERE id = 1004;"'
```

# References

* [Debezium tutorial](https://debezium.io/documentation/reference/1.5/tutorial.html)