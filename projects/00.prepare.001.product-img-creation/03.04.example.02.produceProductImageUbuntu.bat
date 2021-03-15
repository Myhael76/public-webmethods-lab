@echo off

if exist .\.env goto produceImage

echo Environment not set, setting it now

call .\generateEnv.bat

:produceImage

SET H_WMLAB_PRODUCTS_VERSION=1005
SET H_WMLAB_PLATFORM_STRING=LNXAMD64
SET H_WMLAB_WMSCRIPT_FILE=.\ProductsImage_%H_WMLAB_PLATFORM_STRING%_%H_WMLAB_PRODUCTS_VERSION%.wmscript.txt
SET H_WMLAB_BASE_OS_IMAGE=ubuntu

Powershell.exe -executionpolicy Bypass -File .\powershell\produceImage.ps1
