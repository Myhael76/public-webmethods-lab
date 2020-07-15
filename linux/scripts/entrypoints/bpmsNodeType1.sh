#!/bin/sh

export LOG_TOKEN="BPMS_NODE_TYPE1 Startup"

. ${SAG_SCRIPTS_HOME}/common-functions.sh

startupBpmsType1ContainerEntrypoint

# TODO: Remove when ready
logI "TEMP - waiting for shutdown command"
tail -f /dev/null
