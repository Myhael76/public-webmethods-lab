@echo off


@echo off

if exist .\.env goto produceImage

echo Environment not set, setting it now

call .\generateEnv.bat

:produceImage

docker-compose up
docker-compose down
