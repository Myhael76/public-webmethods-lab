#!/bin/bash

# convention: f() sets global var RESULT_f numeric variable as result, 0 means success. Transform - in _ to avoid syntax errors
# do not use "echo" mode function returns
# convention: function names in camelCase (avoid -, it is an operator)

# Source this for its reusable functions

export RED='\033[0;31m'
export NC='\033[0m' 				  	# No Color
export Green="\033[0;32m"        		# Green
export Cyan="\033[0;36m"         		# Cyan

LOG_TOKEN_NC="COMMMON"
LOG_TOKEN="${Green}COMMON${NC}"

function logI(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} - ${1}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_NC} -INFO- ${1}" >> ${SAG_RUN_FOLDER}/script.trace.log
}

function logE(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} - ${RED}${1}${NC}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_NC} -ERROR- ${1}" >> ${SAG_RUN_FOLDER}/script.trace.log
}

function assureRunFolder(){
    if [[ ""${SAG_RUN_FOLDER} == "" ]]; then
        export SAG_RUN_FOLDER="/opt/sag/mnt/runs/run_"`date +%y-%m-%dT%H.%M.%S`
        mkdir -p ${SAG_RUN_FOLDER}
        logI "SAG_RUN_FOLDER set to "${SAG_RUN_FOLDER}
    fi
}

assureRunFolder

function bootstrapSum(){
    assureRunFolder
    logI "Bootstrapping SUM ..."
    /opt/sag/mnt/wm-install-files/sum-bootstrap.bin --accept-license -d /opt/sag/sum \
        > ${SAG_RUN_FOLDER}/sum-boot.out \
        2> ${SAG_RUN_FOLDER}/sum-boot.err
    RESULT_bootstrapSum=$?
    logI "Result: ${RESULT_bootstrapSum}"
    if [[ ${RESULT_bootstrapSum} -eq 0 ]] ; then
        logI "SUM Bootstrap successful"
    else
        logE "SUM Boostrap failed, code ${RESULT_bootstrapSum}"
    fi 
}

function installProducts(){
    # param $1 is the products installation script

    logI "Installing product ..."

    /opt/sag/mnt/wm-install-files/installer.bin \
        -readScript ${1} \
        -debugLvl verbose \
        -debugFile ${SAG_RUN_FOLDER}/product-install.log \
        > ${SAG_RUN_FOLDER}/product-install.out \
        2> ${SAG_RUN_FOLDER}/product-install.err
    
    RESULT_installProducts=$?
    if [[ ${RESULT_installProducts} -eq 0 ]] ; then
        logI "Product installation successful"
    else
        logE "Product installation failed, code ${RESULT_installProducts}"
    fi 
}

function patchInstallation(){
    ###### 03 - Patch installation
    # TODO: render patching optional with a parameter
    logI "Applying latest fixes ..."
    pushd .
    cd /opt/sag/sum/bin/

    if [[ ${SAG_FIXES_ONLINE} -eq 1 ]] ; then
        cat /opt/sag/mnt/scripts/unattended/wm/fixes/online-against-install-folder.wmscript.txt > /dev/shm/fixes.wmscript.txt
        cat /opt/sag/mnt/secret/empower-credentials-fixes.txt >> /dev/shm/fixes.wmscript.txt

        ./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt \
        > ${SAG_RUN_FOLDER}/patching.out \
        2> ${SAG_RUN_FOLDER}/patching.err 
        RESULT_patchInstallation=$?
        rm /dev/shm/fixes.wmscript.txt
    else
        ./UpdateManagerCMD.sh -readScript /opt/sag/mnt/scripts/unattended/wm/fixes/offline-against-install-folder.wmscript.txt \
        > ${SAG_RUN_FOLDER}/patching.out \
        2> ${SAG_RUN_FOLDER}/patching.err
        RESULT_patchInstallation=$?
    fi
    popd
}

function cleanMwsInstanceParameters(){
    unset MWS_DB_TYPE
    unset MWS_DB_HOST
    unset MWS_DB_PORT
    unset MWS_DB_NAME
    unset MWS_DB_URL
    unset MWS_DB_USERNAME
    unset MWS_DB_PASSWORD
    unset MWS_NODE_NAME
}

function assureMwsInstanceParameters(){

    if [[ ""${MWS_DB_TYPE} == "" ]]; then
        export MWS_DB_TYPE="mysqlce"
    fi
    echo -e "${Green}MWS_DB_TYPE=${NC}"${MWS_DB_TYPE}

    if [[ ""${MWS_DB_HOST} == "" ]]; then
        export MWS_DB_HOST="mysql"
    fi
    echo -e "${Green}MWS_DB_HOST=${NC}"${MWS_DB_HOST}

    if [[ ""${MWS_DB_PORT} == "" ]]; then
        export MWS_DB_PORT="3306"
    fi
    echo -e "${Green}MWS_DB_PORT=${NC}"${MWS_DB_PORT}

    if [[ ""${MWS_DB_NAME} == "" ]]; then
        export MWS_DB_NAME="webmethods"
    fi
    echo -e "${Green}MWS_DB_NAME=${NC}"${MWS_DB_NAME}

    if [[ ""${MWS_DB_URL} == "" ]]; then
        if [[ ""${MWS_DB_TYPE} == "mysqlce" ]]; then
            export MWS_DB_URL="jdbc:mysql://${MWS_DB_HOST}:${MWS_DB_PORT}/${MWS_DB_NAME}?useSSL=false"
        else
            export MWS_DB_URL="NOT IMPLEMENTED YET"
        fi
    fi
    echo -e "${Green}MWS_DB_URL=${NC}"${MWS_DB_URL}

    if [[ ""${MWS_DB_USERNAME} == "" ]]; then
        export MWS_DB_USERNAME="webmethods"
    fi
    echo -e "${Green}MWS_DB_USERNAME=${NC}"${MWS_DB_USERNAME}

    if [[ ""${MWS_DB_PASSWORD} == "" ]]; then
        export MWS_DB_PASSWORD="webmethods"
    fi
    #echo -e "${Green}MWS_DB_PASSWORD=${NC}"${MWS_DB_PASSWORD}

    if [[ ""${MWS_NODE_NAME} == "" ]]; then
        export MWS_NODE_NAME="localhost"
    fi
    echo -e "${Green}MWS_NODE_NAME=${NC}"${MWS_NODE_NAME}
}

function createMwsInstance(){

    assureMwsInstanceParameters
    temp=`(echo > /dev/tcp/${MWS_DB_HOST}/${MWS_DB_PORT}) >/dev/null 2>&1`
    CHK_DB_UP=$?
    
    logI "CHK_DB_UP: ${CHK_DB_UP}"

    if [[ ${CHK_DB_UP} -eq 0 ]] ; then

        logI "Taking snapshot before creation..."
        mkdir -p /${SAG_RUN_FOLDER}/snapshots/IC-01-before-instance-creation/
        cp -r /opt/sag/products /${SAG_RUN_FOLDER}/snapshots/IC-01-before-instance-creation/

        # TODO: parametrize eventually
        if [[ ""${MWS_DB_TYPE} == "mysqlce" ]]; then
            cp /opt/sag/mnt/extra/lib/ext/mysql-connector-java-8.0.15.jar /opt/sag/products/MWS/lib/
            cp /opt/sag/mnt/extra/lib/ext/mysql-connector-java-8.0.15.jar /opt/sag/products/common/lib/ext/
            cp -r /opt/sag/mnt/extra/overwrite/install-time/mws/mysqlce/* /opt/sag/products/
        fi

        logI "Instance does not exist, creating ..."
        JAVA_OPTS='-Ddb.type='${MWS_DB_TYPE}

        JAVA_OPTS=${JAVA_OPTS}' -Ddb.url="'${MWS_DB_URL}'"'
        JAVA_OPTS=${JAVA_OPTS}' -Ddb.username="'${MWS_DB_USERNAME}'"'
        JAVA_OPTS=${JAVA_OPTS}' -Ddb.password="'${MWS_DB_PASSWORD}'"'

        JAVA_OPTS=${JAVA_OPTS}' -Dnode.name='${MWS_NODE_NAME}
        JAVA_OPTS=${JAVA_OPTS}' -Dserver.features=default'
        JAVA_OPTS=${JAVA_OPTS}' -Dinstall.service=false'

        #TODO: analyze further
        #JAVA_OPTS=${JAVA_OPTS}' -DjndiProviderUrl="'${}'"'
        #JAVA_OPTS=${JAVA_OPTS}' -Ddb.driver="'${}'"'

        cmd="./mws.sh new ${JAVA_OPTS}"
        
        logI "Command to execute is"
        logI "Command (1): ./mws.sh new ${JAVA_OPTS}"
        logI "Command (2): ${cmd}"

        logI "Creating default instance "
        pushd .
        cd /opt/sag/products/MWS/bin
        eval ${cmd} >/${SAG_RUN_FOLDER}/01-mws-new.out 2>/${SAG_RUN_FOLDER}/01-mws-new.err
        NEW_RET_VAL=$?
        popd

        logI "Taking snapshot after creation..."
        mkdir -p /${SAG_RUN_FOLDER}/snapshots/IC-02-after-creation/
        cp -r /opt/sag/products /${SAG_RUN_FOLDER}/snapshots/IC-02-after-creation/

        if [[ ${NEW_RET_VAL} -eq 0 ]] ; then
            logI "Instance default created, initializing ..."
            pushd .
            cd /opt/sag/products/MWS/bin
            ./mws.sh init >/${SAG_RUN_FOLDER}/02-mws-init.out 2>/${SAG_RUN_FOLDER}/02-mws-init.err
            MWS_INIT_RESULT=$?
            popd

            logI "Taking snapshot after init..."
            mkdir -p /${SAG_RUN_FOLDER}/snapshots/IC-03-after-init/
            cp -r /opt/sag/products /${SAG_RUN_FOLDER}/snapshots/IC-03-after-init/

            if [[ ${MWS_INIT_RESULT} -eq 0 ]] ; then
                logI "Instance default initialized "
                RESULT_createMwsInstance=0
            else
                logE "Instance default not initialized, error code ${MWS_INIT_RESULT}"
                RESULT_createMwsInstance=3 # Init failed
            fi
        else
            logE "Instance default not created, error code ${NEW_RET_VAL}"
            RESULT_createMwsInstance=2 # Creation failed
        fi
    else
        logE "Instance cannot be created, mysql must be reachable"
        RESULT_createMwsInstance=1 # DB not ready
    fi
}

function setupMwsForBpm(){
    assureRunFolder
    logI "Setting up MWS for BPM"
    installProducts ${SAG_SCRIPTS_HOME}/unattended/wm/products/mws/bpm-set-1.wmscript.txt
    if [[ ${RESULT_installProducts} -eq 0 ]] ; then
        logI "Taking Snapshot after install"
        mkdir -p ${SAG_RUN_FOLDER}/snapshots/after-install/
        cp -r /opt/sag/products ${SAG_RUN_FOLDER}/snapshots/after-install/
        logI "Bootstrapping Update Manager"
        bootstrapSum
        if [[ ${RESULT_bootstrapSum} -eq 0 ]] ; then
            logI "Applying fixes"
            patchInstallation
            if [[ ${RESULT_patchInstallation} -eq 0 ]] ; then
                logI "Taking Snapshot after patching"
                mkdir -p ${SAG_RUN_FOLDER}/snapshots/after-patch/
                cp -r /opt/sag/products ${SAG_RUN_FOLDER}/snapshots/after-patch/
                logI "Creating default instance"
                createMwsInstance

                if [[ ${RESULT_createMwsInstance} -eq 0 ]] ; then
                    RESULT_setupMwsForBpm=0
                else
                    logE "Create instance failed: ${PATCH_RESULT}"
                    RESULT_setupMwsForBpm=4
                fi
            else
                logE "Patching failed: ${PATCH_RESULT}"
                RESULT_setupMwsForBpm=3 # 3 - patching failed
            fi
        else
            logE "SUM Bootstrap failed: ${SUM_BOOT_RESULT}"
            RESULT_setupMwsForBpm=2 # 2 - bootstrap failed
        fi
    else
        logE "Installation failed: ${INSTALL_RESULT}"
        RESULT_setupMwsForBpm=1 # 1 - installation failed
    fi
}

function startupMwsContainerEntrypoint(){
    unset SAG_RUN_FOLDER # force new run folder
    assureRunFolder
    HEALTHY=1
    if [ ! -d "/opt/sag/products/MWS/server/default/bin" ] ; then
        HEALTHY=0
        logI "Container has not been set up, installing and creating the instance"
        setupMwsForBpm
        if [[ ${RESULT_setupMwsForBpm} -eq 0 ]] ; then
            logI "Setup Successful"
            HEALTHY=1
        else
            logE "Setup failed"
        fi
    fi
    if [[ ${HEALTHY} -eq 1 ]] ; then
        cd /opt/sag/products/MWS/bin/
        ./mws.sh run
    else
        logE "Cannot start, instance is not healthy"
    fi

    # TODO: Remove when ready
    logI "Stopping for debug, CTRL-C to finish"
    tail -f /dev/null
}