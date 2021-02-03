@echo off

copy .\.env_base.md .\.env

echo You will now be asked to provide the location of project 01.build.000.commons required files

pause

echo ## Local files >>.\.env

Powershell.exe -executionpolicy Bypass -File .\powershell\generateEnvFile.ps1