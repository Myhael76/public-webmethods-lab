@echo off


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
