$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# eventually deal with environment specifics here

$cmdToken1 = $args[0]

switch -exact -casesensitive ($cmdToken1){
    "up" { docker-compose up; break}
    "down" { docker-compose down; break}
    "shell" { docker exec -ti openssl-helper /bin/sh;  break}
    Default {Write-Host "Unknown command: $cmdToken1"; break}
}