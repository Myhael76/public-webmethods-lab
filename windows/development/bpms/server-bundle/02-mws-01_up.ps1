$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

Invoke-Expression -Command ". $PSThisScriptRoot\set-env.ps1"

docker-compose -f .\02-mws_docker-compose.yml up

pause