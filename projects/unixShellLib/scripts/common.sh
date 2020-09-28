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

    export WMLAB_LOG_TOKEN=${WMLAB_LOG_TOKEN:-"PUBLIC_WM_LAB Common"}
    export WMLAB_DEBUG_ON=${WMLAB_DEBUG_ON:-1} # Debug by default is 1
    export WMLAB_RUN_BASE_MOUNT=${WMLAB_RUN_BASE_MOUNT:-/mnt/runs}
    export WMLAB_RUN_FOLDER=${WMLAB_RUN_FOLDER:-"${WMLAB_RUN_BASE_MOUNT}/${CRT_DATE}"} # ATTN Alpine does not have millis, we accept that
    export WMLAB_PRODUCTS_VERSION=${WMLAB_PRODUCTS_VERSION:-"1005"}           # assume no version combinations
    # Installation assets
    export WMLAB_INSTALL_HOME=${WMLAB_INSTALL_HOME:-"/opt/sag/products"}      # default install home
    export WMLAB_INSTALLER_BIN=${WMLAB_INSTALLER_BIN:-"/mnt/sag/artifacts/Installers/LNX64/installer.bin"}
    export WMLAB_PRODUCTS_IMAGE=${WMLAB_PRODUCTS_IMAGE:-"pleaseProvideProductsImageFileHere_env_WMLAB_PRODUCTS_IMAGE"}
    export WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE:-"Please provide an installer script!"}
    # Patching assets
    export WMLAB_SKIP_PATCHING=${WMLAB_SKIP_PATCHING:-0}                      # always patch by default, 1 means skip
    export WMLAB_SUM_HOME=${WMLAB_SUM_HOME:-"/opt/sag/sum"}                   # default sum install home
    export WMLAB_FIXES_ONLINE=${WMLAB_FIXES_ONLINE:-1}                        # default go online
    #when going online provide credentials in the dedicated file
    export WMLAB_FIXES_ONLINE_CRED_FILE=${WMLAB_FIXES_ONLINE_CRED_FILE:-"./secret/sumCredentials.txt"}  # default go online
    export WMLAB_FIXES_IMAGE_FILE=${WMLAB_FIXES_IMAGE_FILE:-"pleaseProvideFixesImageFileHere_env_WMLAB_FIXES_IMAGE_FILE"}
    export WMLAB_MONITORING_ON=${WMLAB_MONITORING_ON:-"0"}
    export WMLAB_TAKE_SNAPHOTS=${WMLAB_TAKE_SNAPHOTS:-"0"}

    ### Follow the convention for artifacts or provide the variables upfront!
    ### These rules are valid for all containers
    export WMLAB_SUM10_BOOTSTRAP_BIN=${WMLAB_SUM10_BOOTSTRAP_BIN:-"/mnt/sag/artifacts/Installers/LNX64/sum10.bin"}
    export WMLAB_SUM11_BOOTSTRAP_BIN=${WMLAB_SUM11_BOOTSTRAP_BIN:-"/mnt/sag/artifacts/Installers/LNX64/sum11.bin"}

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
            > "${WMLAB_RUN_FOLDER}/01.02.sum-boot.out" \
            2> "${WMLAB_RUN_FOLDER}/01.02.sum-boot.err"
        RESULT_bootstrapSum=$?
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
        logI "Installing products according to script ${SCRIPT_FILE} ..."
        if [ -f "${SCRIPT_FILE}" ]; then
            "${WMLAB_INSTALLER_BIN}" \
                -readScript "${SCRIPT_FILE}" \
                -debugLvl verbose \
                -debugFile "${WMLAB_RUN_FOLDER}/01.01.product-install.log"\
                > "${WMLAB_RUN_FOLDER}/01.01.product-install.out" \
                2> "${WMLAB_RUN_FOLDER}/01.01.product-install.err"
            
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
    logI "Applying fixes ..."
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
        echo "imageFile=${WMLAB_FIXES_IMAGE_FILE}" >> /dev/shm/fixes.wmscript.txt
    fi

    controlledExec "./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt" "01.03.PatchInstallation"
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
    installProducts "${1}"
    if [[ ${RESULT_installProducts} -eq 0 ]] ; then
        takeInstallationSnapshot 01.Setup-01-after-install

        if [ ${WMLAB_SKIP_PATCHING} -eq 0 ]; then
            bootstrapSum
            if [[ ${RESULT_bootstrapSum} -eq 0 ]] ; then
                patchInstallation
                if [[ ${RESULT_patchInstallation} -eq 0 ]] ; then
                    takeInstallationSnapshot 01.Setup-02-after-patch
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
            logI "Patching skipped..."
            RESULT_genericProductsSetup=0
        fi
    else
        logE "Installation failed: ${INSTALL_RESULT}"
        RESULT_genericProductsSetup=1 # 1 - installation failed
    fi
}

startDstatResourceMonitor(){
    if [ "${WMLAB_MONITORING_ON}" -eq 1 ]; then
        if command -v dstat &> /dev/null
        then
            logI "Spawning new dstat resource monitor."
            d=`date +%y-%m-%dT%H.%M.%S_%3N`
            pushd .
            nohup dstat -t -T -l -c -m -s -r -d --fs --disk-tps --disk-util --tcp --dbus -n -N total,lo --net-packets --output "${WMLAB_RUN_FOLDER}/dstat_output_$d.csv" >/dev/null &
            popd
            logI "dstat resource monitor launched, output file is ${WMLAB_RUN_FOLDER}/dstat_output_$d.csv"
        else
            logW "dstat command not found"
        fi
    else
        logW "startDstatResourceMonitor cannot be launched, monitoring is disabled"
    fi
}

startDockerMonitor(){
    # parameter $1 -> grep tocken, normally the docker instance name or id
    if [ "${WMLAB_MONITORING_ON}" -eq 1 ]; then
        h=`docker stats -a --no-stream | grep CPU | awk -v OFS="," '$1=$1'`
        h=${h/,\/,/,}
        h=${h/NET,I\/O/NET I,NET O}
        h=${h/BLOCK,I\/O/BLOCK I,BLOCK O}
        h=${h/CPU,%/CPU%}
        h=${h/MEM,USAGE/MEM UASGE}
        h=${h/MEM,%/MEM%}
        d=`date +%y-%m-%dT%H.%M.%S_%3N`

        f="${WMLAB_RUN_FOLDER}/dockerMon_$1_$d.csv"

        logI "Starting new docker monitor for container $1, file is $f"
        echo $h > "$f"

        daemonDockerMonitor $1 $f &
    else
        logW "startDstatResourceMonitor cannot be launched, monitoring is disabled"
    fi
}

daemonDockerMonitor(){
    # parameter $1 -> grep tocken, normally the docker instance name or id
    # parameter $2 -> file
    while true; do
        sleep 1
        writeDockerMonitorLine $1 >> $2
    done
}

writeDockerMonitorLine(){
    # parameter $1 -> grep tocken, normally the docker instance name or id
    d=`date +%y-%m-%dT%H.%M.%S_%3N`
    l=`docker stats -a --no-stream | grep $1 | awk -v OFS="," '$1=$1'`
    l=${l/,\/,/,}
    l=${l/,\/,/,}
    l=${l/,\/,/,}
   echo "$d,$l"
}