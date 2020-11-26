@echo off

if exist .\.env goto build-dbcc

echo Environment not set, setting it now

call .\generateEnv.bat

:build-dbcc

set H_WMLAB_FIXES_DATE_TAG=fixes-2030-11-30
set H_WMLAB_FIXES_IMAGE_FILE=C:\my\file\here.zip

docker-compose up
docker-compose down