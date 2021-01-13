@echo off

if exist .\.env goto produceImage

echo Environment not set, setting it now

call .\generateEnv.bat

:produceImage


SET H_WMLAB_INVENTORY_FILE=inventory_10.5.0_W64.json
SET H_WMLAB_PRODUCTS_VERSION=1005
SET H_WMLAB_PLATFORM_STRING=W64

docker-compose up
docker-compose down
