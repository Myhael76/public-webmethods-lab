#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

onInterrupt(){
	logI "Interrupted!"
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

trap "onInterrupt" SIGINT
trap "onKill" SIGKILL

logI "Default entry point: waiting for tail -f /dev/null"

tail -f /dev/null & wait
