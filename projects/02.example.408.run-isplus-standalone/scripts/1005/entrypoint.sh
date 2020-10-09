#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

logD "Environment dump below"
logEnv

onInterrupt(){
	logI "Interrupted! Shutting down Universal Messaging"
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
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

beforeStartConfig

cd /opt/sag/products/IntegrationServer/bin/

./startContainer.sh

afterStartConfig

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    logD "Container finished, stopping for debug..."
    tail -f /dev/null
fi
