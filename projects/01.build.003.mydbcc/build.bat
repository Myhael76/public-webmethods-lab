@echo off

if exist .\.env goto build-dbcc

echo Environment not set, setting it now

call .\generateEnv.bat

:build-dbcc

docker-compose up
docker-compose down