@echo off

call .\pullJars.bat

SET ENTRY_POINT=/opt/softwareag/script/just-wait.sh
docker-compose -f .\S02-alpine_dbcc_docker-compose.yml up

pause