@echo off

copy .env_base.md .env
echo . >>.\.env

echo ## Local files and folders for project 00.prepare.002.fix-img-creation >>.\.env

Powershell.exe -executionpolicy Bypass -File .\powershell\generateEnvFile.ps1