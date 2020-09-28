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

beforeStartConfig(){
    logI "Configure - before start"
    cp -rf /mnt/conf/o4p-ae/config/* ${WMLAB_WM_INSTALL_HOME}/optimize/analysis/conf/
    # local only, to be properly inserted n the project
    export JAVA_HOME=${WMLAB_WM_INSTALL_HOME}/jvm/jvm/jre/
    export CCS_ADMIN_HOME=/opt/sag/ccs-admin/
    chmod u+x ${CCS_ADMIN_HOME}bin/password_admin.sh
    ${CCS_ADMIN_HOME}bin/password_admin.sh -t \
        ${WMLAB_WM_INSTALL_HOME}/optimize/analysis/conf/deployed-passman \
        ${WMLAB_WM_INSTALL_HOME}/optimize/analysis/conf/security/passman/optimize
}

afterStartConfig(){
    # todo
    logI "Configure - after start"
}

trap "onInterrupt" SIGINT SIGTERM
trap "onKill" SIGKILL


beforeStartConfig

cd ${WMLAB_WM_INSTALL_HOME}/optimize/analysis/bin/

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    GLUE_OPTS="$GLUE_OPTS -Xdebug"
fi


beforeStartConfig
logI "Starting up Analytic Engine"

# Note: the "go background" & already included in the product script!
controlledExec "./startupAnalyticEngineNoWrapper.sh" "02.1.Analysis Engine first run"

afterStartConfig

SERVER_PID=$(ps -ef | grep -i "com.webmethods.optimize.stack.Stack" | grep -v grep | grep -v $0 | awk '{ if (NR==1) {print $2}}')
ps -ef | grep -i "com.webmethods.optimize.stack.Stack"
logD "Found SERVER_PID: ${SERVER_PID}"
logI "Waiting for server PID ${SERVER_PID}"

#wait ${SERVER_PID}

## Cannot read like this, not a subprocess of the current shell :( 
## TODO: find better solution only if needed.

while [ -e /proc/${SERVER_PID} ]
do
    sleep 5
done

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    logD "Container finished, stopping for debug..."
    tail -f /dev/null
fi
