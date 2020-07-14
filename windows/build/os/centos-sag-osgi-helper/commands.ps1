
$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

Write-Output "Script folder: $PSThisScriptRoot"
Invoke-Expression -Command ". $PSThisScriptRoot\..\..\..\common\config\set-env.ps1"

$command=$args[0]

switch  -exact -casesensitive  ($command) {
    "up"      { docker-compose up;      break }
    "down"    { docker-compose down;    break }
    "destroy" { docker-compose down -v; break }
    "stop"    { docker-compose stop;    break }
    "start"   { docker-compose start;   break }
    "shell"   { docker exec -ti centos-sag-osgi-helper-base bash; break }
    Default   { Write-Host "Unknown command $command";       break }
}
