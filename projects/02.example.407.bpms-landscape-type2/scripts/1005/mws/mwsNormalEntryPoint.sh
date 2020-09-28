#!/bin/sh

. /mnt/scripts/lib/common.sh

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

startDstatResourceMonitor

logI "Starting up MWS"

cd /opt/sag/products/MWS/bin

controlledExec "./mws.sh run" "StartupMWS" & wait
