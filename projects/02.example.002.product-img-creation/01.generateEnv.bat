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

:: copy local env file
echo . >>.\.env
type .\.env_base.md >> .\.env

echo . >>.\.env
echo ## Local files and folders >>.\.env

Powershell.exe -executionpolicy Bypass -File .\powershell\generateEnvFile.ps1