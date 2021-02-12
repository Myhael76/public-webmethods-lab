::@echo off

:: rename this file to get-empower-credentials.bat and chose one of the following options

:: declare your empwower user here if you want
:: SET H_WMLAB_EMPOWER_USER=me@acme.com

:: option 1: write credentials in clear text here. This is needed for unattended execution
:: this files remains local (according to .gitignore) and the credentials are never logged

:: SET H_WMLAB_EMPOWER_PASS=yourPassword

:: Alternatively, ask user for credentials
:: this is the preferred way if you execute the bat files in attended mode

setlocal EnableDelayedExpansion

if "!H_WMLAB_EMPOWER_USER!" == "" goto inputUser
goto managePwd

:inputUser
set /P H_WMLAB_EMPOWER_USER="Enter Empower user: "

set H_WMLAB_EMPOWER_USER=%H_WMLAB_EMPOWER_USER%

:managePwd
if "!H_WMLAB_EMPOWER_PASS!" == "" goto inputPwd
goto end

:inputPwd
set "psCommand=powershell -Command "$pword = read-host 'Enter Password for empower user %H_WMLAB_EMPOWER_USER%' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""

for /f "usebackq delims=" %%p in (`%psCommand%`) do set H_WMLAB_EMPOWER_PASS_1=%%p

set "psCommand=powershell -Command "$pword = read-host 'Enter Password for empower user %H_WMLAB_EMPOWER_USER% again' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""

for /f "usebackq delims=" %%p in (`%psCommand%`) do set H_WMLAB_EMPOWER_PASS_2=%%p

if "%H_WMLAB_EMPOWER_PASS_1%" == "%H_WMLAB_EMPOWER_PASS_2%" goto endInput

echo Passwords do not match, try again
goto inputPwd

:endInput
SET H_WMLAB_EMPOWER_PASS=%H_WMLAB_EMPOWER_PASS_1%
SET H_WMLAB_EMPOWER_PASS_1=
SET H_WMLAB_EMPOWER_PASS_2=

:end
