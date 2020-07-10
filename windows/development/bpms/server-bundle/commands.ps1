Write-Host "1"

. .\..\..\..\common\config\set-env.ps1

$env:MWS_MAIN_PORT=50585

function mwsUp(){
    Write-Host "mwsUp called"
}

$command=$args[0]

Write-Host "Received command ${command}"

Pause

mwsUp


# $env:IS_TE_MAIN_PORT=50150

# to see env
# dir env:
