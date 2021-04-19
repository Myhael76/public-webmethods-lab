#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

# Prerequisites

checkPrerequisites(){
    local c1=262144 # p1 -> vm.max_map_count
    local p1=$(sysctl "vm.max_map_count" | cut -d " " -f 3)
    if [[ ! $p1 -lt $c1 ]]; then
        logI "vm.max_map_count is adequate ($p1)"
    else
        logE "vm.max_map_count is NOT adequate ($p1), container will exit now"
		return 1
    fi
}

checkPrerequisites || exit 1

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

controlledExec "./console.sh" "Run API Gw" & wait

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
    logD "Stopping execution for debug"
    tail -f /dev/null
fi