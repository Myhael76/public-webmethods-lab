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

if(('mws','mysql','adminer','mydbcc','bpms-node-type1').contains($component)){
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
                "down"    {
                    if('bpms-node-type1'.Equals($component)){
                        #docker exec bpms1-bpms-node-type1 ${SAG_SCRIPTS_HOME}/entrypoints/bpmsNodeType1Stop.sh
                        docker exec -ti $env:SAG_W_PJ_NAME-bpms-node-type1 /opt/sag/mnt/scripts/entrypoints/bpmsNodeType1Stop.sh
                    }
                    docker-compose -f $dcYmlFileName down;
                    break
                }
                "destroy" {
                    if('bpms-node-type1'.Equals($component)){
                        #docker exec bpms1-bpms-node-type1 /opt/sag/mnt/scripts/entrypoints/bpmsNodeType1Stop.sh
                        docker exec -ti $env:SAG_W_PJ_NAME-bpms-node-type1 /opt/sag/mnt/scripts/entrypoints/bpmsNodeType1Stop.sh
                    }elseif('mws'.Equals($component)){
                        docker exec -ti $env:SAG_W_PJ_NAME-mws /opt/sag/mnt/scripts/entrypoints/mwsStop.sh
                    }
                    docker-compose -f $dcYmlFileName down -v;
                    break
                }
                "start"   {docker-compose -f $dcYmlFileName start;   break}
                "stop"    {
                    if('bpms-node-type1'.Equals($component)){
                        docker exec -ti $env:SAG_W_PJ_NAME-bpms-node-type1 /opt/sag/mnt/scripts/entrypoints/bpmsNodeType1Stop.sh
                    } elseif('mws'.Equals($component)){
                        docker exec -ti $env:SAG_W_PJ_NAME-mws /opt/sag/mnt/scripts/entrypoints/mwsStop.sh
                    }
                    docker-compose -f $dcYmlFileName stop;
                    break
                }
                Default {Write-Host "Unknown cmdToken2 for $component $cmdToken1 $cmdToken2"; break}
            };break
        }
        "init"{
            if('mydbcc'.Equals($component)){
                # check if mysql is up (Automatic recursive start is not working, to investigate eventually)
                # Test-NetConnection -ComputerName localhost -Port $env:SAG_W_MYSQL_PORT
                # if(-Not $?){
                #     Write-Host "My SQL Must be up! Starting..."
                #     Invoke-Expression -Command "$MyInvocation.MyCommand.Definition mysql dc up"
                # }
                Test-NetConnection -ComputerName localhost -Port $env:SAG_W_MYSQL_PORT

                $socket = new-object Net.Sockets.TcpClient
                $socket.connect('localhost',$env:SAG_W_MYSQL_PORT)
                $bConnected=$socket.Connected
                if(${bConnected}){

                    Push-Location .
                    Set-Location ${PSThisScriptRoot}\..\..\
                    .\pullContent.bat
                    Pop-Location

                    $env:SAG_W_ENTRY_POINT="/opt/sag/mnt/scripts/entrypoints/dbcInit.sh"
                    docker-compose -f $dcYmlFileName up
                    # Note: error management broken
                    # TODO: explore this later
                    # Write-Host "Exit $LastExitCode; $?"
                    # if($?){
                    #     Write-Host "Database creation successful"
                    # }else{
                    #     Write-Host "Database creation failed"
                    #     Pause
                    # }
                    docker-compose -f $dcYmlFileName down -v;
                    }
                else {
                    Write-Error "MySQL not up nor startable!"
                }
            }else{
                Write-Host "Cannot init $component"
            }
            break
        }
        "shell"{
            docker exec -ti "$env:SAG_W_PJ_NAME-$component" $cmdToken2; break
        }
        Default {Write-Host "Unknown cmdToken1 for mws: $cmdToken1"; break}
    }
}else{
    Write-Host "Unknown component: $component"
}
