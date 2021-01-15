@echo off

if exist .\.env goto produceImage

echo Environment not set, setting it now

call .\generateEnv.bat

:produceImage

SET H_WMLAB_PRODUCTS_VERSION=1005
SET H_WMLAB_PLATFORM_STRING=LNXAMD64
SET H_WMLAB_WMSCRIPT_FILE=.\ProductsImage_%H_WMLAB_PLATFORM_STRING%_%H_WMLAB_PRODUCTS_VERSION%.wmscript.txt

call ..\01.build.000.commons\secret\get-empower-credentials.bat

echo "Empower user is %H_WMLAB_EMPOWER_USER%"

docker-compose up
docker-compose down

set H_WMLAB_EMPOWER_USER=