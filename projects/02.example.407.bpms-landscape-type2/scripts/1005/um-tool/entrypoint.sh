#!/bin/sh

onInterrupt(){
	logI "Interrupted!"
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

trap "onInterrupt" SIGINT
trap "onKill" SIGKILL

logI "Dummy entry point: waiting for tail -f /dev/null"

tail -f /dev/null & wait