#!/bin/sh

. /mnt/scripts/lib/common.sh

logD "Environment dump below"
logEnv

onInterrupt(){
	logI "Interrupted! Shutting down Analytic Engine"
    cd ${SAG_HOME}/optimize/analysis/bin/
    controlledExec "./shutdown.sh" "03.Analysis Engine shutdown" &
	exit 0 # managed expected exit
}

onKill(){
	logW "Killed!"
}

afterCreateConfig(){
    #todo
    logI "Configure - after create"
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

cd ${SAG_HOME}/optimize/analysis/bin/




if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    GLUE_OPTS="$GLUE_OPTS -Xdebug"
fi


logI "Starting up Analytic Engine"

# Note: the "go background" & already included in the product script!
controlledExec "./startupAnalyticEngineNoWrapper.sh" "02.Analysis Engine run"

SERVER_PID=$!
logI "Analysis Engine Server PID: ${SERVER_PID}"

afterStartConfig

SERVER_PID=$(ps -ef | grep -i "com.webmethods.optimize.stack.Stack" | grep -v grep | grep -v $0 | awk '{ if (NR==1) {print $2}}')
logI "Waiting for server PID ${SERVER_PID}"

#wait ${SERVER_PID}

## Cannot wait, not a subprocess of the current shell :( 
## TODO: find better solution only if needed.

while [ -e /proc/${SERVER_PID} ]
do
    sleep 5
done

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    logD "Container finished, stopping for debug..."
    tail -f /dev/null
fi
