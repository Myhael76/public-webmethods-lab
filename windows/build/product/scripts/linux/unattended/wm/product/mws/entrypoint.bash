#!/bin/bash

# check if instance exists
# if instance does not exist, create it with configured parameters
# instance creation time params are ENV variables
# the instance and the profile folders should be persistent volume mounts

RED='\033[0;31m'
NC='\033[0m' 				  	# No Color
Green="\033[0;32m"        		# Green
Cyan="\033[0;36m"         		# Cyan
LOG_TOKEN_NC="MWS_DOCKER_ENTRY_POINT"
LOG_TOKEN="${Green}MWS_DOCKER_ENTRY_POINT${NC}"
# Assure Run_FOLDER
RUN_FOLDER="/mnt/runs/mws_container_start_"`date +%y-%m-%dT%H.%M.%S`
mkdir -p ${RUN_FOLDER}

function logI(){
    echo -e "${LOG_TOKEN} - ${1}"
    echo "${LOG_TOKEN_NC} -INFO- ${1}" >> ${RUN_FOLDER}/entrypoint.trace.log
}

function logE(){
    echo -e "${LOG_TOKEN} - ${Red}${1}${NC}"
    echo "${LOG_TOKEN_NC} -ERROR- ${1}" >> ${RUN_FOLDER}/entrypoint.trace.log
}

logI "MWS enrypoint.bash starting..."

cd /opt/softwareag/MWS/bin

if [ ! -d "/opt/softwareag/MWS/server/default/bin" ] ; then
    temp=`(echo > /dev/tcp/mysql/3306) >/dev/null 2>&1`
    CHK_DB_UP=$?
    
    logI "CHK_DB_UP: ${CHK_DB_UP}"

    if [[ ${CHK_DB_UP} -eq 0 ]] ; then

        logI "Taking snapshot before creation..."
        mkdir -p ${RUN_FOLDER}/snapshots/01-before-instance-creation/opt
        cp -r /opt/softwareag ${RUN_FOLDER}/snapshots/01-before-instance-creation/opt

        logI "Instance does not exist, creating ..."
        . /opt/softwareag/set-instance-parameters.bash
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
        
        #echo "----> Command to execute is"
        #echo ${cmd}

        logI "Creating default instance "
        eval ${cmd} >${RUN_FOLDER}/01-mws-new.out 2>${RUN_FOLDER}/01-mws-new.err
        
        NEW_RET_VAL=$?

        logI "Taking snapshot after creation..."
        mkdir -p ${RUN_FOLDER}/snapshots/02-after-creation/opt
        cp -r /opt/softwareag ${RUN_FOLDER}/snapshots/02-after-creation/opt

        if [[ ${NEW_RET_VAL} -eq 0 ]] ; then
            logI "Instance default created, initializing ..."
            ./mws.sh init >${RUN_FOLDER}/02-mws-init.out 2>${RUN_FOLDER}/02-mws-init.err
            MWS_INIT_RESULT=$?

            logI "Taking snapshot after init..."
            mkdir -p ${RUN_FOLDER}/snapshots/03-after-init/opt
            cp -r /opt/softwareag ${RUN_FOLDER}/snapshots/03-after-init/opt

            if [[ ${MWS_INIT_RESULT} -eq 0 ]] ; then
                logI "Instance default initialized "
            else
                logE "Instance default not initialized, error code ${MWS_INIT_RESULT}"
                logI "${Cyan}Suspending container instance for debugging..."
                tail -f /dev/null
            fi
        else
            logE "Instance default not created, error code ${NEW_RET_VAL}"
            logI "Suspending container instance for debugging..."
            tail -f /dev/null
        fi
    else
        logE "Instance cannot be created, mysql must be reachable"
        logI "Stopping for debug..."
        #TODO: parametrize server and port
        tail -f /dev/null
    fi
fi

logI "Taking snapshot before start..."
mkdir -p ${RUN_FOLDER}/snapshots/04-before-start/opt
cp -r /opt/softwareag ${RUN_FOLDER}/snapshots/04-before-start/opt

logI "Instance default starting ..."
./mws.sh run >${RUN_FOLDER}/03-mws-run.out 2>${RUN_FOLDER}/03-mws-run.err

logI "My WebMethods Instance was shut down. Suspending for debug in case this was stopped from inside."

logI "Taking snapshot after shutdown..."
mkdir -p ${RUN_FOLDER}/snapshots/05-after-shutdown/opt
cp -r /opt/softwareag ${RUN_FOLDER}/snapshots/05-after-shutdown/opt

logI "Suspending container execution..."
tail -f /dev/null