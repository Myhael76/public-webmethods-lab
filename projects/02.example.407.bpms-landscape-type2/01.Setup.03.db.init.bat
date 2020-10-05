@echo off
docker-compose -f 01.Setup.03.docker-compose.mydbcc.yml up

:: ensure cleaning

docker-compose -f 01.Setup.03.docker-compose.mydbcc.yml down
