$PSThisScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

$env:ENTRY_POINT="/mnt/scripts/unattended/wm/product/mws/build-image-entry-point.bash"

${PSThisScriptRoot}

Push-Location .

Set-Location ..\..\..\..\..\..\..\..\build\os\centos-wm-install-helper

.\01-up.ps1

.\03-destroy.ps1

Pop-Location