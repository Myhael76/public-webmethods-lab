#!/bin/sh

. ${SAG_SCRIPTS_HOME}/common-functions.sh

startupBpmsType1ContainerEntrypoint

# TODO: Remove when ready
logI "TEMP - waiting for shutdown command"
tail -f /dev/null
