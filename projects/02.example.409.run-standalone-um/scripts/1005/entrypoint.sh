#!/bin/sh

. /mnt/scripts/lib/common.sh

logD "Environment dump below"
logEnv

onInterrupt(){
	logI "Interrupted! Shutting down Universal Messaging"
    cd "${WMLAB_WM_INSTALL_HOME}/UniversalMessaging/server/${WMLAB_REALM_NAME}/bin"
    controlledExec "./nstopserver" "Shutdown"
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

afterCreateConfig(){
    #todo
    logI "Configure - after create"
}

beforeStartConfig(){
    # todo
    logI "Configure - before start"
}

afterStartConfig(){
    # todo
    logI "Configure - after start"
}

trap "onInterrupt" SIGINT SIGTERM
trap "onKill" SIGKILL

if [ ! -d ${WMLAB_WM_INSTALL_HOME}/UniversalMessaging/server/${WMLAB_REALM_NAME}/bin ]; then
    logI "Realm ${WMLAB_REALM_NAME} does not exist, creating now"
    cd ${WMLAB_WM_INSTALL_HOME}/UniversalMessaging/tools/InstanceManager/
    controlledExec './ninstancemanager.sh create ${WMLAB_REALM_NAME} rs 0.0.0.0 9000' "01.Create realm ${WMLAB_REALM_NAME}"
    afterCreateConfig
fi

beforeStartConfig

cd "${WMLAB_WM_INSTALL_HOME}/UniversalMessaging/server/${WMLAB_REALM_NAME}/bin"
controlledExec "./nserver" "02.Universal Messaging Server Run" &

SERVER_PID=$!
logI "Universal Messaging Server PID: ${SERVER_PID}"

afterStartConfig

wait ${SERVER_PID}

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    logD "Container finished, stopping for debug..."
    tail -f /dev/null
fi
