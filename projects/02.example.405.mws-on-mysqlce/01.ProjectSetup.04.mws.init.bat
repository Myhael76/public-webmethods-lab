@echo off

docker-compose -f 04.ProjectStructure.mws.init.docker-compose.yml up

:: ensure cleaning

docker-compose -f 04.ProjectStructure.mws.init.docker-compose.yml down
