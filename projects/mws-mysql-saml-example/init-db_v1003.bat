@echo off

set H_WMLAB_PRODUCTS_VERSION=1003

:: set H_WMLAB_JDBC_DRIVER_URL=https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.15/mysql-connector-java-8.0.15.jar
:: set H_WMLAB_JDBC_DRIVER_FILENAME=mysql-connector-java-8.0.15.jar

docker-compose -f docker-compose_mydbcc.yml up

:: ensure cleaning

docker-compose -f docker-compose_mydbcc.yml down
