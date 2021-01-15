#!/bin/sh

## This file groups common shell functions to be used in any circumstance
## by convention function f produces RESULT_f, 0 means success
## do not use - (minus) in names, it is an operator
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
    export WMLAB_LIB_COMMON=${WMLAB_LIB_COMMON:-"/mnt/scripts/lib/common"}
    export WMLAB_PRODUCTS_VERSION=${WMLAB_PRODUCTS_VERSION:-"1005"}           # assume no version combinations
    # Installation assets
    export WMLAB_INSTALL_HOME=${WMLAB_INSTALL_HOME:-"/opt/sag/products"}      # default install home
    # Patching assets
    export WMLAB_SUM_HOME=${WMLAB_SUM_HOME:-"/opt/sag/sum"}                   # default sum install home
    #when going online provide credentials in the dedicated file
    export WMLAB_MONITORING_ON=${WMLAB_MONITORING_ON:-"0"}
    export WMLAB_TAKE_SNAPHOTS=${WMLAB_TAKE_SNAPHOTS:-"0"}
    export WMLAB_CTRL_EXEC_STDOUT_ON=${WMLAB_CTRL_EXEC_STDOUT_ON:-"0"}

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
    if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
        echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_D} - ${1}"
        echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -DEBUG- ${1}" >> ${WMLAB_RUN_FOLDER}/script.trace.log
    fi
}

logEnv(){
    logI "=========Current environment dump begin"
    env | grep WMLAB | grep -v PASSWORD | sort
    env | grep WMLAB | grep -v PASSWORD | sort >> ${WMLAB_RUN_FOLDER}/script.trace.log
    logI "=========Current environment dump end"
}

controlledExec(){
    # Param $1 - command to execute in a controlled manner
    # Param $2 - tag for trace files
    logD "Executing command: ${1}"
    if [ "${WMLAB_CTRL_EXEC_STDOUT_ON}" -eq 1 ]; then 
        eval "${1}" >${WMLAB_RUN_FOLDER}/controlledExec_${2}.out 2>${WMLAB_RUN_FOLDER}/controlledExec_${2}.err
    else
        eval "${1}" >/dev/null 2>${WMLAB_RUN_FOLDER}/controlledExec_${2}.err
    fi
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
        bootstrapCmd="${BIN_FILE} --accept-license -d "'"'"${WMLAB_SUM_HOME}"'"'
        controlledExec "${bootstrapCmd}" "01.02.sum-boot"
        #${BIN_FILE} --accept-license -d "${WMLAB_SUM_HOME}" \
        #    > "${WMLAB_RUN_FOLDER}/01.02.sum-boot.out" \
        #    2> "${WMLAB_RUN_FOLDER}/01.02.sum-boot.err"
        if [ ${RESULT_controlledExec} -eq 0 ]; then
            logI "SUM Bootstrap successful"
            RESULT_bootstrapSum=0
        else
            logE "SUM Boostrap failed, code ${RESULT_controlledExec}"
            RESULT_bootstrapSum=2
        fi
    else
        logE "Invalid Software AG Update Manager boostrap file: ${BIN_FILE}"
        RESULT_bootstrapSum=1
    fi
}

takeInstallationSnapshot(){
    # $1 is the "tag" of the snapshot
    if [ ${WMLAB_TAKE_SNAPHOTS} -eq 1 ]; then
        logI "Taking snapshot ${1} ..."
        mkdir -p "/${WMLAB_RUN_FOLDER}/snapshots/$1/"
        cp -r "${WMLAB_INSTALL_HOME}" "/${WMLAB_RUN_FOLDER}/snapshots/$1/"
    else
        logW "Snapshot ${1} not taken because snapshot taking is disabled!"
    fi
}

startDstatResourceMonitor(){
    if [ "${WMLAB_MONITORING_ON}" -eq 1 ]; then
        if command -v dstat &> /dev/null
        then
            logI "Spawning new dstat resource monitor."
            d=`date +%y-%m-%dT%H.%M.%S_%3N`
            pushd . > /dev/null
            nohup dstat -t -T -l -c -m -s -r -d --fs --disk-tps --disk-util --tcp --dbus -n -N total,lo --net-packets --output "${WMLAB_RUN_FOLDER}/dstat_output_$d.csv" >/dev/null &
            popd > /dev/null
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

basicInstallationCleanup(){

    logI "Cleanup installation folder"

    rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm*.bck
    rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm/sample
    rm -f ${WMLAB_INSTALL_HOME}/jvm/jvm/src.zip
    rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm/man
    rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm/demo
    rm -f ${WMLAB_INSTALL_HOME}/common/lib/derby.log

    rm -rf ${WMLAB_INSTALL_HOME}/install/fix/backup

    # we do not need windows scripts on linux
    find ${WMLAB_INSTALL_HOME} -type f -name *.bat -exec rm -f "{}" \;
}
