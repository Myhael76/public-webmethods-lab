#!/bin/sh

# import setup & framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

shutdown(){

    logI "Stopping Analysis Engine ..."
    cd /opt/sag/products/optimize/analysis/bin/
    ./shutdown.sh

    logI "Stopping Integration Server ..."
    cd /opt/sag/products/IntegrationServer/instances/default/bin/
    ./shutdown.sh

    logI "Stopping My WebMethods Server ..."
    cd /opt/sag/products/MWS/bin
    ./mws.sh stop
    
    logI "Stopping Universal Messaging Realm Server ..."
    cd /opt/sag/products/UniversalMessaging/server/umserver/bin/
    ./nserverdaemon stop

    logI "Stopping SPM ..."
    cd /opt/sag/products/profiles/SPM/bin/
    ./shutdown.sh
}

logI "Staring up up BPMS Type 1 - Single Node"
logEnv

trap "shutdown" SIGINT SIGTERM

# UM start
logI "Starting Universal Messaging Realm Server ..."
cd /opt/sag/products/UniversalMessaging/server/umserver/bin/
./nserverdaemon start

# MWS start (use this process id to wait...)
logI "Starting My WebMethods Server ..."
cd /opt/sag/products/MWS/bin
controlledExec "./mws.sh run" "StartupMWS" &
PID=$!

# IS PLus Start
logI "Starting Integration Server ..."
cd /opt/sag/products/IntegrationServer/instances/default/bin/
./startup.sh

# Optimize AE start
logI "Starting Analysis Engine ..."
cd /opt/sag/products/optimize/analysis/bin/
./startup.sh

# Optimize Data Collector
# TODO

logI "Waiting for MWS to finish...."
wait ${PID}

if [ ${WMLAB_DEBUG_ON} -eq 1 ]; then
    logD "Container finished, stopping for debug..."
    tail -f /dev/null
fi