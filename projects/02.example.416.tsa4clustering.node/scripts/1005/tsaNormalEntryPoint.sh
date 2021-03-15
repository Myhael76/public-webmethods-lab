#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

onInterrupt(){
	logI "Interrupted! Shutting down TMC & TSA"
	controlledExec "${WMLAB_INSTALL_HOME}/Terracotta/tools/management-console/bin/stop-tmc.sh" "Shutdown TMC"
	controlledExec "${WMLAB_INSTALL_HOME}/Terracotta/server/wrapper/bin/shutdown.sh"   "Shutdown TSA"
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

trap "onInterrupt" SIGINT SIGTERM
trap "onKill" SIGKILL

startDstatResourceMonitor

logI "Starting up Terracotta Server"

controlledExec "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/startTc.sh"  "Startup TSA"

controlledExec "${WMLAB_INSTALL_HOME}/Terracotta/tools/management-console/bin/start-tmc.sh" "Start TMC and wait" & wait

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
    logD "Stopping execution for debug"
    tail -f /dev/null
fi