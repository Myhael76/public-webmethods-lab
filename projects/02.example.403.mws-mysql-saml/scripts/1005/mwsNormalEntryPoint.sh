#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

onInterrupt(){
	logI "Interrupted! Shutting down MWS"
	/opt/sag/products/profiles/MWS_default/bin/shutdown.sh
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

trap "onInterrupt" SIGINT SIGTERM
trap "onKill" SIGKILL

logI "Starting up MWS"

cd /opt/sag/products/MWS/bin

controlledExec "./mws.sh run" "StartupMWS" & wait
