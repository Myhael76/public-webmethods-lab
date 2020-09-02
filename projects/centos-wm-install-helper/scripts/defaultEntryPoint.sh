#!/bin/sh

. /mnt/scripts/lib/common.sh

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
