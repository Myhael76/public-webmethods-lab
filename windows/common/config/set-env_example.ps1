# COPY this file into set-env.ps1 and fill the values from your environment
# set-env.ps1 must exist on the local directory but will NOT be tracked by git

# For constants used throughout the scripts see readme.md

# ATTN: all paths below have to be mountable by Docker Desktop, set permissions accrodingly

# ?
$env:SAG_WM_INSTALL_BASE_DIR="."

# Allow scripts to overwrite the entrypoint
Write-Host "ENTRY_POINT: " -NoNewline
if (-not (Test-Path env:ENTRY_POINT)) { 
	$env:ENTRY_POINT="tail -f /dev/null"
	Write-Host "Using default ENTRY_POINT: " -ForegroundColor Yellow -NoNewline
} else {
	Write-Host "Using provided ENTRY_POINT: " -ForegroundColor Green -NoNewline
}
Write-Host  $env:ENTRY_POINT

# ######### Install related artifacts

# Where is the 10.5 instaler?
$env:SAG_INSTALLER_BIN="c:\your-path\SoftwareAGInstaller20191216-LinuxX86.bin"

# Where is the 10.5 update manager bootstrap?
$env:SAG_UPD_MGR_BIN="c:\your-path\SoftwareAGUpdateManagerInstaller20200214-LinuxX86.bin"

# Where is the 10.5 products image? (Yes, prepare it before running this project!)
$env:SAG_PRODUCT_IMAGE="c:\your-path\1005\LNX64_BPMS_Products.zip"

# Where is the 10.5 fixes image? (Yes, prepare it before running this project!)
$env:SAG_FIXES_IMAGE="c:\your-path\1005\LNX64_BPMS_Fixes.zip"

# put on 1 if fix installation has to happen online
$env:SAG_FIXES_ONLINE=0

# ######### Licenses

# Business Rules
$env:SAG_LIC_BR="c:\your-path\BR.xml"

# Microservices Runtime
$env:SAG_LIC_MSR="c:\your-path\MSR.xml"

# Integration Server
$env:SAG_LIC_IS="c:\your-path\IS.xml"

# Universal Messaging Realm Server
$env:SAG_LIC_UM="c:\your-path\UM.xml"

# ######### Proxy
# uncomment if used and set the correct value
# for yum see
# https://www.linuxtechi.com/proxy-settings-yum-command-on-rhel-centos-servers/
# for update manager see
# https://documentation.softwareag.com/a_installer_and_update_manager/Using_SAG_Update_Manager_for_10-5_and_later/index.html#page/sag-update-manager-help%2Fre-supported_arguments_startup_scripts.html
# for now only http proxy with no login 
# TODO: Extend as needed

# $env:HTTP_PROXY_URL=http://proxy-server-here:12345

# ######### Ports
# Convention:
# all ports are defined as 5XXYY, where
#  XX is the number of the project 
#  YY is one of the following
#  - 85 -> MWS
#  - 50 -> Main IS, contining TE client
#  - 6? -> more IS / MSR ports
# Give acronyms to ISes (e.g. below TE)
# These ports are set on the docker-compose project, the below ones are examples

# $env:MWS_MAIN_PORT=50185
# $env:IS_TE_MAIN_PORT=50150
