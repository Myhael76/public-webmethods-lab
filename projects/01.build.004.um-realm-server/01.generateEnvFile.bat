@echo off

:: this project depends on the .env from project 00 and 001.build.000

:: take .env from 00
if exist ..\00.commons\.env goto copy_00_env

PUSHD .
cd ..\00.commons
echo generating .env file for project 00.commons
call generateEnv.bat
POPD

:copy_00_env
copy ..\00.commons\.env .

:: take .env from 001.build.000

if exist ..\01.build.000.commons\.env goto take_01_000_env

PUSHD .
cd ..\01.build.000.commons
echo generating .env file for project 00.commons
call generateEnvInstallCommons.bat

POPD

:take_01_000_env

type ..\01.build.000.commons\.env >> .\.env

type .\.env_base.md  >> .\.env


echo You will now be asked to provide the location of project 01.build.004.um-realm-server required files

pause

Powershell.exe -executionpolicy Bypass -File .\powershell\generateEnvFile.ps1

