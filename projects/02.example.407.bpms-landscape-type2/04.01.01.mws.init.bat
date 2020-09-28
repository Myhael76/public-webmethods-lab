@echo off

docker-compose -f .\04.01.docker-compose_mws_setup.yml up

:: ensure cleaning

docker-compose -f .\04.01.docker-compose_mws_setup.yml down
