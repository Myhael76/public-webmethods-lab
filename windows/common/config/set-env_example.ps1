# COPY this file into set-env.ps1 and fill the values from your environment
# set-env.ps1 must exist on the local directory but will NOT be tracked by git

# For constants used throughout the scripts see readme.md

# ATTN: all paths below have to be mountable by Docker Desktop, set permissions accrodingly

# This project Home
$env:SAG_W_WM_LAB_HOME = (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) -replace "\\windows\\common\\config", ""

# Allow scripts to overwrite the entrypoint
Write-Host "SAG_W_ENTRY_POINT: " -NoNewline
if (-not (Test-Path env:SAG_W_ENTRY_POINT)) { 
	$env:SAG_W_ENTRY_POINT="tail -f /dev/null"
	Write-Host "Using default: " -ForegroundColor Yellow -NoNewline
} else {
	Write-Host "Using provided: " -ForegroundColor Green -NoNewline
}
Write-Host  $env:SAG_W_ENTRY_POINT

# ######### Install related artifacts

# Where is the 10.5 instaler?
$env:SAG_W_INSTALLER_BIN="c:\your-path\SoftwareAGInstaller20191216-LinuxX86.bin"

# Where is the 10.5 update manager bootstrap?
$env:SAG_W_UPD_MGR_BIN="c:\your-path\SoftwareAGUpdateManagerInstaller20200214-LinuxX86.bin"

# Where is the 10.5 products image? (Yes, prepare it before running this project!)
$env:SAG_W_PRODUCT_IMAGE="c:\your-path\1005\LNX64_BPMS_Products.zip"

# Where is the 10.5 fixes image? (Yes, prepare it before running this project!)
$env:SAG_W_FIXES_IMAGE="c:\your-path\1005\LNX64_BPMS_Fixes.zip"

# Runs folder will hold run traces and logs
$env:SAG_W_RUNS_FOLDER="c:\your-path\runs"

# put on 1 if fix installation has to happen online
$env:SAG_W_FIXES_ONLINE=0
# 0 - normal use, 1 - take install folder snapshots for analysis, advanced use
$env:SAG_W_TAKE_SNAPHOTS=0

########## Licenses

# Business Rules
$env:SAG_W_LIC_BR="c:\your-path\BR.xml"
# Microservices Runtime
$env:SAG_W_LIC_MSR="c:\your-path\MSR.xml"
# Integration Server
$env:SAG_W_LIC_IS="c:\your-path\IS.xml"
# Universal Messaging Realm Server
$env:SAG_W_LIC_UM="c:\your-path\UM.xml"
# MashZone NG  Server
$env:SAG_W_LIC_MZNG="c:\your-path\MashZoneNextGen.xml"
# Terracotta BigMemory Server
$env:SAG_W_LIC_TC="c:\your-path\terracotta-license.key"
# API MicroGateway
$env:SAG_W_LIC_API_MICROGW="c:\your-path\Microgateway.xml"
# Digital Event Services
$env:SAG_W_LIC_DES="c:\your-path\Digital_Event_Services.xml"


# ######### Proxy
# uncomment if used and set the correct value
# for yum see
# https://www.linuxtechi.com/proxy-settings-yum-command-on-rhel-centos-servers/
# for update manager see
# https://documentation.softwareag.com/a_installer_and_update_manager/Using_SAG_Update_Manager_for_10-5_and_later/index.html#page/sag-update-manager-help%2Fre-supported_arguments_startup_scripts.html
# for now only http proxy with no login 
# TODO: Extend as needed

# $env:HTTP_PROXY_URL=http://proxy-server-here:12345

########## Ports
# Convention:
# all ports are defined as XXXYY, where
#  XXX is the prefix of the project 
#  YY is one of the suffixes in the below code
# Give acronyms to ISes (e.g. below TE)
# These ports are set on the docker-compose project, the below ones are examples
# Set default values if not provided here

Write-Host "SAG_W_PROJECT_PORT_PREFIX: " -NoNewline
if (-not (Test-Path env:SAG_W_PROJECT_PORT_PREFIX)) { 
	$env:SAG_W_PROJECT_PORT_PREFIX="401"
	Write-Host "Using default: " -ForegroundColor Yellow -NoNewline
} else {
	Write-Host "Using provided: " -ForegroundColor Green -NoNewline
}
Write-Host  $env:SAG_W_PROJECT_PORT_PREFIX

# Supporting non Software AG software
$env:SAG_W_ADMINER_PORT=$env:SAG_W_PROJECT_PORT_PREFIX+"01"
$env:SAG_W_SAML_IDP1_CLEAR_PORT:SAG_W_PROJECT_PORT_PREFIX+"02"
$env:SAG_W_SAML_IDP1_SSL_PORT:SAG_W_PROJECT_PORT_PREFIX+"03"
$env:SAG_W_MYSQL_PORT=$env:SAG_W_PROJECT_PORT_PREFIX+"36"

# Software AG platform ports
$env:SAG_W_MWS_PORT=$env:SAG_W_PROJECT_PORT_PREFIX+"85"
$env:SAG_W_IS_TE_PORT=$env:SAG_W_PROJECT_PORT_PREFIX+"55"
$env:SAG_W_UM_PORT=$env:SAG_W_PROJECT_PORT_PREFIX+"90"
$env:SAG_W_AE_PORT_CFG=$env:SAG_W_PROJECT_PORT_PREFIX+"15"
$env:SAG_W_AE_PORT_REG=$env:SAG_W_PROJECT_PORT_PREFIX+"16"
$env:SAG_W_DC_PORT_CFG=$env:SAG_W_PROJECT_PORT_PREFIX+"25"
$env:SAG_W_DC_PORT_REG=$env:SAG_W_PROJECT_PORT_PREFIX+"26"

Write-Host "Adminer port: $env:SAG_W_ADMINER_PORT"
Write-Host "MySQL port: $env:SAG_W_MYSQL_PORT"
Write-Host "SAML IdP clear port: $env:SAG_W_SAML_IDP1_CLEAR_PORT"
Write-Host "SAML IdP SSL port: $env:SAG_W_SAML_IDP1_SSL_PORT"
Write-Host "MWS port: $env:SAG_W_MWS_PORT"
Write-Host "IS_TE port: $env:SAG_W_IS_TE_PORT"
Write-Host "UM port: $env:SAG_W_UM_PORT"
Write-Host "Analytic Engine configuration port: $env:SAG_W_AE_PORT_CFG"
Write-Host "Analytic Engine registry port: $env:SAG_W_AE_PORT_REG"
Write-Host "Data Collector configuration port: $env:SAG_W_DC_PORT_CFG"
Write-Host "Data Collector registry port: $env:SAG_W_DC_PORT_REG"