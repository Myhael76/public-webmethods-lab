
$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

Write-Output "Script folder: $PSThisScriptRoot"

if( Test-Path $PSThisScriptRoot\..\..\..\common\config\set-env.ps1 -PathType Leaf){
    Invoke-Expression -Command ". $PSThisScriptRoot\..\..\..\common\config\set-env.ps1"

    $command=$args[0]

    switch  -exact -casesensitive  ($command) {
        "up"      { docker-compose up;      break }
        "down"    { docker-compose down;    break }
        "destroy" { docker-compose down -v; break }
        "stop"    { docker-compose stop;    break }
        "start"   { docker-compose start;   break }
        "shell"   { docker exec -ti wm-install-helper-base bash; break }
        Default   { Write-Host "Unknown command $command";       break }
    }  
}else{
    Write-Host "Project set-env.ps1 file does not exist, set up the project first!"
}
