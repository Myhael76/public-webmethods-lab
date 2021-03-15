@echo off

:: built with a multi-node setup in mind

docker-compose -f 04.ProjectStructure.init.%H_WMLAB_APIGW_HOSTNAME%.docker-compose.yml up

:: ensure cleaning

docker-compose -f 04.ProjectStructure.init.%H_WMLAB_APIGW_HOSTNAME%.docker-compose.yml down

pause