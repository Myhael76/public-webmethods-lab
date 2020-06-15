@echo off

call .\pullJars.bat

SET ENTRY_POINT=/opt/softwareag/script/just-wait.sh
docker-compose -f .\alpine_dbcc_docker-compose.yml up

pause