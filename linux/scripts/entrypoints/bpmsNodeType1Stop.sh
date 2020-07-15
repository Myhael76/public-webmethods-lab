#!/bin/sh

export LOG_TOKEN="BPMS_NODE_TYPE1 Shutdown"

. ${SAG_SCRIPTS_HOME}/common-functions.sh

shutdownBpmsType1ContainerEntrypoint