#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

onInterrupt(){
	logI "Interrupted! Shutting down API Gateway Advanced"
	controlledExec "/opt/sag/products/profiles/IS_default/bin/shutdown.sh" "Shutdown IS"
	controlledExec "/opt/sag/products/InternalDataStore/bin/shutdown.sh"   "Shutdown Internal Data Store"
	controlledExec "/opt/sag/products/profiles/SPM/bin/shutdown.sh"        "Shutdown SPM"
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

trap "onInterrupt" SIGINT SIGTERM
trap "onKill" SIGKILL

startDstatResourceMonitor

logI "Starting up API Gateway"

controlledExec "/opt/sag/products/InternalDataStore/bin/startup.sh" "Startup Internal Data Store"
controlledExec "/opt/sag/products/profiles/SPM/bin//startup.sh"     "Startup SPM"

cd /opt/sag/products/profiles/IS_default/bin/

controlledExec "./console.sh" "Ron API Gw" & wait
