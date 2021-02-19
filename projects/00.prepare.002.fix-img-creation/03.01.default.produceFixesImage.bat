@echo off

if exist .\.env goto checkCred

echo Environment not set, setting it now

call .\generateEnv.bat

SET H_WMLAB_FIXES_ONLINE_CRED_FILE=..\01.build.000.commons\secret\sum\empower-credentials-fixes.txt

:checkCred

if exist ..\01.build.000.commons\secret\sum\empower-credentials-fixes.txt goto produceImage

goto err1

:produceImage

SET H_WMLAB_INVENTORY_FILE=inventory_10.5.0_LNXAMD64.json
SET H_WMLAB_PRODUCTS_VERSION=1005
SET H_WMLAB_PLATFORM_STRING=LNXAMD64

::set /P H_WMLAB_FIXES_DATE_TAG="Enter current fix image tag: "

docker-compose up
docker-compose down

goto end

:err1

echo Please produce the credentials first

:end