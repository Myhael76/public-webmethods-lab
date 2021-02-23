#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

logI "Checking docker client availability..."
docker info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    logI "Building production image for mock project 451..."

    mkdir -p /tmp/bCtx/packages

    cp "${WMLAB_DOCKERFILE}" /tmp/bCtx/
    cp -r "${WMLAB_SOURCE_PACKAGES_FOLDER}"/* /tmp/bCtx/packages/

    cd /tmp/bCtx/

    controlledExec "docker build -t mock451prod ." 
else
    logE "Docker is not available!"
    exit 1
fi
