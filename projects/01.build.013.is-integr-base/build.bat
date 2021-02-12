@echo off

if exist .\.env goto build

echo Environment not set, setting it now

call .\generateEnv.bat

:build

docker-compose up
docker-compose down