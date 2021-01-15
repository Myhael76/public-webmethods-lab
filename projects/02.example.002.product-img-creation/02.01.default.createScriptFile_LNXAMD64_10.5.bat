SET H_WMLAB_PLATFORM_STRING=LNXAMD64
SET H_WMLAB_PRODUCTS_VERSION=1005

powershell.exe -ExecutionPolicy Bypass^
 -file .\powershell\createImgCreationScript.ps1^
 -frmkVersionString "%H_WMLAB_PRODUCTS_VERSION%"^
 -installerPlatformString "%H_WMLAB_PLATFORM_STRING%"^
 >> .\ProductsImage_%H_WMLAB_PLATFORM_STRING%_%H_WMLAB_PRODUCTS_VERSION%.wmscript.txt