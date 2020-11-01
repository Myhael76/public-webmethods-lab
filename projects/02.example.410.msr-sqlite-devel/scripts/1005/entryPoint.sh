#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

logD "Environment dump below"
logEnv

onInterrupt(){
	logI "Interrupted! Shutting down MSR"
    cd /opt/sag/products/IntegrationServer/bin/
    ./shutdown.sh
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

beforeStartConfig(){
    logI "Configure - before start"
    #cp -f /mnt/init-conf/IS_HOME/* ${WMLAB_INSTALL_HOME}/IntegrationServer/
    cp -rf /mnt/init-conf/IS_HOME/* ${WMLAB_INSTALL_HOME}/IntegrationServer/
    # todo
    # link all packages in the project folder
    mkdir -p ${WMLAB_RUN_FOLDER}/IS/logs
    pushd .
    cd ${WMLAB_INSTALL_HOME}/IntegrationServer/
    if [ -d "./logs" ]; then
        logW "logs directory already exists, this should not happen! Pausing for debug"
        tail -f /dev/null
    fi
    ln -s ${WMLAB_RUN_FOLDER}/IS/logs
    popd
}

afterStartConfig(){
    # todo
    logI "Configure - after start"
}

trap "onInterrupt" SIGINT SIGTERM
trap "onKill" SIGKILL

beforeStartConfig

cd ${WMLAB_INSTALL_HOME}/IntegrationServer/bin/

logI "Starting MSR, check run folder for logs"
controlledExec "./server.sh -log both" "Startup MSR" & wait

afterStartConfig

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    logD "Container finished, stopping for debug..."
    tail -f /dev/null
fi 