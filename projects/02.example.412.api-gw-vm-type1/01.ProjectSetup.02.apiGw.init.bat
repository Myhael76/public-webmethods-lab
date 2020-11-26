@echo off

docker-compose -f 04.ProjectStructure.init.docker-compose.yml up

:: ensure cleaning

docker-compose -f 04.ProjectStructure.init.docker-compose.yml down

pause