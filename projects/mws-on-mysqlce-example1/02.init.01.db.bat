@echo off
docker-compose -f docker-compose_mydbcc.yml up

:: ensure cleaning

docker-compose -f docker-compose_mydbcc.yml down
