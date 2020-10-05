@echo off

docker-compose -f .\01.Setup.04.docker-compose_mws.yml up

:: ensure cleaning

docker-compose -f .\01.Setup.04.docker-compose_mws.yml down
