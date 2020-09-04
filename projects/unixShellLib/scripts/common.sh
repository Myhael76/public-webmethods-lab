#!/bin/sh

## This file groups common shell functions to be used in any circumstance
## by convention function f produces RESULT_f, 0 means success
## do not use - in names, it is an operator
## Convention: all relevant variables are prefixed with WMLAB_ 

init(){
    ########### Constants
    export NC='\033[0m' 				  	# No Color
    export RED='\033[0;31m'
    export Green="\033[0;32m"
    export Yellow="\033[0;33m"
    export Blue="\033[0;34m"
    export Cyan="\033[0;36m"
    CRT_DATE=`date +%y-%m-%dT%H.%M.%S_%3N`

    ########### Variables with defaults 
    # (using shell expansion: https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)

    WMLAB_LOG_TOKEN=${WMLAB_LOG_TOKEN:-"PUBLIC_WM_LAB Common"}
    WMLAB_DEBUG_ON=${WMLAB_DEBUG_ON:-1} # Debug by default is 1
    WMLAB_RUN_BASE_MOUNT=${WMLAB_RUN_BASE_MOUNT:-/mnt/runs}
    WMLAB_RUN_FOLDER=${WMLAB_RUN_FOLDER:-"${WMLAB_RUN_BASE_MOUNT}/${CRT_DATE}"} # ATTN Alpine does not have millis, we accept that
    WMLAB_PRODUCTS_VERSION=${WMLAB_PRODUCTS_VERSION:-"1005"}           # assume no version combinations
    # Installation assets
    WMLAB_INSTALL_HOME=${WMLAB_INSTALL_HOME:-"/opt/sag/products"}      # default install home
    WMLAB_INSTALLER_BIN=${WMLAB_INSTALLER_BIN:-"/mnt/sag/artifacts/Installers/LNX64/installer.bin"}
    WMLAB_PRODUCTS_IMAGE=${WMLAB_PRODUCTS_IMAGE:-"pleaseProvideProductsImageFileHere_env_WMLAB_PRODUCTS_IMAGE"}
    WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE:-"Pleae provide an installer script!"}
    # Patching assets
    WMLAB_SKIP_PATCHING=${WMLAB_SKIP_PATCHING:-0}                      # always patch by default, 1 means skip
    WMLAB_SUM_HOME=${WMLAB_SUM_HOME:-"/opt/sag/sum"}                   # default sum install home
    WMLAB_FIXES_ONLINE=${WMLAB_FIXES_ONLINE:-1}                        # default go online
    #when going online provide credentials in the dedicated file
    WMLAB_FIXES_ONLINE_CRED_FILE=${WMLAB_FIXES_ONLINE_CRED_FILE:-"./secret/sumCredentials.txt"}  # default go online
    WMLAB_FIXES_IMAGE_FILE=${WMLAB_FIXES_IMAGE_FILE:-"pleaseProvideFixesImageFileHere_env_WMLAB_FIXES_IMAGE_FILE"}

    ### Follow the convention for artifacts or provide the variables upfront!
    ### These rules are valid for all containers
    WMLAB_SUM10_BOOTSTRAP_BIN=${WMLAB_SUM10_BOOTSTRAP_BIN:-"/mnt/sag/artifacts/Installers/LNX64/sum10.bin"}
    WMLAB_SUM11_BOOTSTRAP_BIN=${WMLAB_SUM11_BOOTSTRAP_BIN:-"/mnt/sag/artifacts/Installers/LNX64/sum11.bin"}

    ########### Derived Variables 
    LOG_TOKEN_C_D="${Blue}DEBUG:${Green}${LOG_TOKEN}${NC}"
    LOG_TOKEN_C_W="${Yellow}WARN :${Green}${LOG_TOKEN}${NC}"
    LOG_TOKEN_C_I="${Green}INFO :${Green}${LOG_TOKEN}${NC}"
    LOG_TOKEN_C_E="${RED}ERROR:${Green}${LOG_TOKEN}${NC}"

    ########### Ensure prerequisites
    mkdir -p ${WMLAB_RUN_FOLDER}
}

init
########### Log functions

logI(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_I} - ${1}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -INFO - ${1}" >> ${WMLAB_RUN_FOLDER}/script.trace.log
}

logW(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_W} - ${1}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -WARN - ${1}" >> ${WMLAB_RUN_FOLDER}/script.trace.log
}

logE(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_E} - ${RED}${1}${NC}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -ERROR- ${1}" >> ${WMLAB_RUN_FOLDER}/script.trace.log
}

logD(){
    if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
        echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_D} - ${1}"
        echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -DEBUG- ${1}" >> ${WMLAB_RUN_FOLDER}/script.trace.log
    fi
}

logEnv(){
    logI "=========Current environment dump begin"
    env | grep WMLAB | sort
    env | grep WMLAB | sort >> ${WMLAB_RUN_FOLDER}/script.trace.log
    logI "=========Current environment dump end"
}

controlledExec(){
    # Param $1 - command to execute in a controlled manner
    # Param $2 - tag for trace files
    logD "Executing command: ${1}"
    eval "${1}" >${WMLAB_RUN_FOLDER}/controlledExec_${2}.out 2>${WMLAB_RUN_FOLDER}/controlledExec_${2}.err
    RESULT_controlledExec=$?
}

portIsReachable(){
    # Params: $1 -> host $2 -> port
    if [ -f /usr/bin/nc ]; then 
        nc -z ${1} ${2}                                         # alpine image
    else
        temp=`(echo > /dev/tcp/${1}/${2}) >/dev/null 2>&1`      # centos image
    fi
    if [ $? -eq 0 ] ; then echo 1; else echo 0; fi
}

bootstrapSum(){
    BIN_FILE="${WMLAB_SUM11_BOOTSTRAP_BIN}"
    if [ "${WMLAB_PRODUCTS_VERSION}" -lt 1005 ]; then
        BIN_FILE="${WMLAB_SUM10_BOOTSTRAP_BIN}"
    fi
    logD "SUM boostrap file is: ${BIN_FILE}"
    if [ -f  ${BIN_FILE} ]; then
        logI "Bootstrapping SUM from ${BIN_FILE}..."
        ${BIN_FILE} --accept-license -d "${WMLAB_SUM_HOME}" \
            > "${WMLAB_RUN_FOLDER}/sum-boot.out" \
            2> "${WMLAB_RUN_FOLDER}/sum-boot.err"
        RESULT_bootstrapSum=$?
        logI "Result: ${RESULT_bootstrapSum}"
        if [ ${RESULT_bootstrapSum} -eq 0 ]; then
            logI "SUM Bootstrap successful"
        else
            logE "SUM Boostrap failed, code ${RESULT_bootstrapSum}"
        fi
    else
        logE "Invalid Software AG Update Manager boostrap file: ${BIN_FILE}"
        RESULT_bootstrapSum=1
    fi
}

##bootStrapSum10() { bootStrapSum "${WMLAB_SUM10_BOOTSTRAP_BIN}"; RESULT_bootstrapSum10=${RESULT_bootstrapSum}; unset RESULT_bootstrapSum; }

##bootStrapSum11() { bootStrapSum "${WMLAB_SUM11_BOOTSTRAP_BIN}"; RESULT_bootstrapSum11=${RESULT_bootstrapSum}; unset RESULT_bootstrapSum;}

takeInstallationSnapshot(){
    # $1 is the "tag" of the snapshot
    if [ ${WMLAB_TAKE_SNAPHOTS} -eq 1 ]; then
        logI "Taking snapshot ${1} ..."
        mkdir -p "/${WMLAB_RUN_FOLDER}/snapshots/$1/"
        cp -r "${WMLAB_INSTALL_HOME}" "/${WMLAB_RUN_FOLDER}/snapshots/$1/"
    fi
}

installProducts(){
    # param $1 is the products installation script
    ## TODO: chceck install home consistency with provided script
    SCRIPT_FILE=${1}
    if [ -z ${SCRIPT_FILE+x} ]; then
        logD "Installer script not provided, using the framework variable WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE}"
        SCRIPT_FILE="${WMLAB_INSTALL_SCRIPT_FILE}"
    fi

    if [ -f "${WMLAB_INSTALLER_BIN}" ]; then
        logI "Installing products ..."
        if [ -f "${SCRIPT_FILE}" ]; then
            "${WMLAB_INSTALLER_BIN}" \
                -readScript "${SCRIPT_FILE}" \
                -debugLvl verbose \
                -debugFile "${WMLAB_RUN_FOLDER}/product-install.log"\
                > "${WMLAB_RUN_FOLDER}/product-install.out" \
                2> "${WMLAB_RUN_FOLDER}/product-install.err"
            
            RESULT_installProducts=$?
            if [ ${RESULT_installProducts} -eq 0 ] ; then
                logI "Product installation successful"
            else
                logE "Product installation failed, code ${RESULT_installProducts}"
            fi
        else
            logE "Product installation failed: invalid installer script file: ${WMLAB_INSTALLER_BIN}"
            RESULT_installProducts=1
        fi
    else
            logE "Product installation failed: invalid installer file: ${WMLAB_INSTALLER_BIN}"
            RESULT_installProducts=2
    fi
}

patchInstallation(){
    ###### 03 - Patch installation
    # TODO: render patching optional with a parameter
    logI "Applying latest fixes ..."
    pushd .
    cd "${WMLAB_SUM_HOME}/bin"

    echo "installSP=N" >/dev/shm/fixes.wmscript.txt
    echo "installDir=${WMLAB_INSTALL_HOME}" >>/dev/shm/fixes.wmscript.txt
    echo "selectedFixes=spro:all" >>/dev/shm/fixes.wmscript.txt

    if [ ${WMLAB_FIXES_ONLINE} -eq 1 ] ; then
        echo "action=Install fixes from Empower" >> /dev/shm/fixes.wmscript.txt
        cat "${WMLAB_FIXES_ONLINE_CRED_FILE}" >> /dev/shm/fixes.wmscript.txt
    else
        echo "action=Install fixes from image" >> /dev/shm/fixes.wmscript.txt
        echo "${WMLAB_FIXES_IMAGE_FILE}" >> /dev/shm/fixes.wmscript.txt
    fi

    controlledExec "./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt" "PatchInstallation"
    #./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt \
    #    > "${WMLAB_RUN_FOLDER}/patching.out" \
    #    2> "${WMLAB_RUN_FOLDER}/patching.err" 
    
    RESULT_patchInstallation=$?
        
    rm -f /dev/shm/fixes.wmscript.txt
    popd
}

startInstallerInAttendedMode(){
    # force new run_folder
    WMLAB_RUN_FOLDER="${WMLAB_RUN_BASE_MOUNT}/"`date +%y-%m-%dT%H.%M.%S_%3N`
    mkdir -p ${WMLAB_RUN_FOLDER}
    ${WMLAB_INSTALLER_BIN} -console \
        -installDir "${WMLAB_INSTALL_HOME}" \
        -readImage "${WMLAB_PRODUCTS_IMAGE}" \
        -writeScript ${WMLAB_RUN_FOLDER}/install.wmscript.txt
}

genericProductsSetup(){
    logI "Installing products according to script ${1}"
    installProducts ${1}
    if [[ ${RESULT_installProducts} -eq 0 ]] ; then
        takeInstallationSnapshot Setup-01-after-install
        logI "Bootstrapping Update Manager"
        bootstrapSum
        if [[ ${RESULT_bootstrapSum} -eq 0 ]] ; then
            logI "Applying fixes"
            patchInstallation
            if [[ ${RESULT_patchInstallation} -eq 0 ]] ; then
                takeInstallationSnapshot Setup-02-after-patch
                RESULT_genericProductsSetup=0
            else
                logE "Patching failed: ${PATCH_RESULT}"
                RESULT_genericProductsSetup=3 # 3 - patching failed
            fi
        else
            logE "SUM Bootstrap failed: ${SUM_BOOT_RESULT}"
            RESULT_genericProductsSetup=2 # 2 - bootstrap failed
        fi
    else
        logE "Installation failed: ${INSTALL_RESULT}"
        RESULT_genericProductsSetup=1 # 1 - installation failed
    fi
}