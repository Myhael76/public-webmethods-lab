#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

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
