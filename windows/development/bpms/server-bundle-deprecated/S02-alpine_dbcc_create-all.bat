@echo off

call .\pullJars.bat

SET ENTRY_POINT=/opt/softwareag/script/create-all.sh
docker-compose -f .\S02-alpine_dbcc_docker-compose.yml up

IF ERRORLEVEL 0 GOTO end

echo Database creation failed, code: %errorlevel%

pause

:end
REM we do not need the stopped container
docker-compose -f .\S02-alpine_dbcc_docker-compose.yml down
