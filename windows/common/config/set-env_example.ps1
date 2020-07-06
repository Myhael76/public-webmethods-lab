# COPY this file into set-env.ps1 and fill the values from your environment
# set-env.ps1 must exist on the local directory but will NOT be tracked by git

# For constants used throughout the scripts see readme.md

# ATTN: all paths below have to be mountable by Docker Desktop, set permissions accrodingly

# ?
$env:SAG_WM_INSTALL_BASE_DIR="."

# Default Entry point for playground containers
$env:ENTRY_POINT="tail -f /dev/null"

# ######### Install related artifacts

# Where is the 10.5 instaler?
$env:SAG_INSTALLER_BIN="c:\your-path\SoftwareAGInstaller20191216-LinuxX86.bin"

# Where is the 10.5 update manager bootstrap?
$env:SAG_UPD_MGR_BIN="c:\your-path\SoftwareAGUpdateManagerInstaller20200214-LinuxX86.bin"

# Where is the 10.5 products image? (Yes, prepare it before running this project!)
$env:SAG_PRODUCT_IMAGE="c:\your-path\1005\LNX64_MWS4BPM.zip"

# ######### Licenses

# Business Rules
$env:SAG_LIC_BR="c:\your-path\BR.xml"

# Microservices Runtime
$env:SAG_LIC_MSR="c:\your-path\MSR.xml"

# Integration Server
$env:SAG_LIC_IS="c:\your-path\IS.xml"

# Universal Messaging Realm Server
$env:SAG_LIC_UM="c:\your-path\UM.xml"