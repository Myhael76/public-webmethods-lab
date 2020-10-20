@echo off
docker-compose -f 01.Setup.03.docker-compose.mydbcc.yml up

pause
:: ensure cleaning

docker-compose -f 01.Setup.03.docker-compose.mydbcc.yml down

pause