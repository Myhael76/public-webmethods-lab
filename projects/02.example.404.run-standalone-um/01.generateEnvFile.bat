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

type .\.env_base.md >> .\.env

echo You will now be asked to provide the location of project's required files

pause

Powershell.exe -executionpolicy Bypass -File .\powershell\generateEnvFile.ps1

