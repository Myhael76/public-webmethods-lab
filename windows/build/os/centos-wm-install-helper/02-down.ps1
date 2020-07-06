$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

Invoke-Expression -Command ". $PSThisScriptRoot\..\..\..\common\config\set-env.ps1"

docker-compose down