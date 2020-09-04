@echo off
docker-compose -f docker-compose_mws_setup.yml up

:: ensure cleaning

docker-compose -f docker-compose_mws_setup.yml down
