$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

Invoke-Expression -Command ". $PSThisScriptRoot\set-env.ps1"

docker exec mws /opt/sag/products/profiles/MWS_default/bin/shutdown.sh

Write-Host "Wait for eventual snapshot to finish then hit enter"

pause

docker-compose -f .\02-mws_docker-compose.yml down -v

pause