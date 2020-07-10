# Parameters
# [0] -> component name (e.g. mws) by convention = container instance name
# [1] -> command type (dc -> docker-compose; run -> run command against the)
# [2] -> dc verb in case [1] = dc, script name if [1] = run
# ASSUME execution directory is the docker compose project

# Source project environment
$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Invoke-Expression -Command ". $PSThisScriptRoot\..\config\set-env.ps1"

$projectFolder=$args[0]
$component=$args[1]
$cmdToken1=$args[2]
$cmdToken2=$args[3]

if(('mws','mysql','adminer').contains($component)){
    $dcYmlFileName="$projectFolder\docker-compose_$component.yml"

    if( -Not (Test-Path $dcYmlFileName -PathType Leaf)){
        Copy-Item $PSThisScriptRoot\..\docker-compose\bpms-bundle\${component}.yml $dcYmlFileName
        Write-Host "Just cloned $dcYmlFileName"
    }
    $env:SAG_W_PJ_NAME=Split-Path $projectFolder -Leaf

    switch -exact -casesensitive ($cmdToken1){
        "dc" {
            switch -exact -casesensitive ($cmdToken2){
                "up"      {docker-compose -f $dcYmlFileName up;      break}
                "down"    {docker-compose -f $dcYmlFileName down;    break}
                "destroy" {docker-compose -f $dcYmlFileName down -v; break}
                "start"   {docker-compose -f $dcYmlFileName start;   break}
                "stop"    {docker-compose -f $dcYmlFileName stop;    break}
                Default {Write-Host "Unknown cmdToken2 for $component $cmdToken1 $cmdToken2"; break}
            }
        }
        "shell"{
            docker exec -ti "$env:SAG_W_PJ_NAME-$component" $cmdToken2
        }
        Default {Write-Host "Unknown cmdToken1 for mws: $cmdToken1"; break}
    }
}else{
    Write-Host "Unknown component: $component"
}
