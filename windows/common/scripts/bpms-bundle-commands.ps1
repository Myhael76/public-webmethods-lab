# Parameters
# [0] -> component name (e.g. mws) by convention = container instance name
# [1] -> command type (dc -> docker-compose; run -> run command against the)
# [2] -> dc verb in case [1] = dc, script name if [1] = run
# ASSUME execution directory is the docker compose project

# Source project environment
$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Invoke-Expression -Command ". $PSThisScriptRoot\..\config\set-env.ps1"

$component=$args[0]
$cmdToken1=$args[1]
$cmdToken2=$args[2]

if(('mws','mysql','adminer').contains($component)){
    switch -exact -casesensitive ($cmdToken1){
        "dc" {
            switch -exact -casesensitive ($cmdToken2){
                "up" {}
                "down" {}
                "destroy" {}
                "start" {}
                "stop" {}
                Default {Write-Host "Unknown cmdToken2 for $component $cmdToken1 $cmdToken2"; break}
            }
        }
        "shell"{
            
        }
        Default {Write-Host "Unknown cmdToken1 for mws: $cmdToken1"; break}
    }
}else{
    Write-Host "Unknown component: $component"
}
