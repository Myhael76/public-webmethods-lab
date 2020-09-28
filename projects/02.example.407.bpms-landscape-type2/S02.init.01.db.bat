@echo off
docker-compose -f .\S02.docker-compose_mydbcc.yml up

:: ensure cleaning

docker-compose -f .\S02.docker-compose_mydbcc.yml down
