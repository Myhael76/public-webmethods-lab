$env:SAG_W_PROJECT_PORT_PREFIX=402

$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Eventually set project specific variables here

# Import general project commands
Write-Output "Script folder: $PSThisScriptRoot"
Invoke-Expression -Command "$PSThisScriptRoot\..\..\..\common\scripts\project-commands.ps1 $PSThisScriptRoot $args"
