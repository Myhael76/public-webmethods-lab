#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logD "Environment dump below"
logEnv

logI "Checking docker client availability..."
docker info >/dev/null 2>&1


if [ $? -eq 0 ]; then
    logI "Docker ok"

    controlledExec "yum -y install unzip" "Install unzip"

    logI "Setting up MWS with central configuration to extract ccs-admin tool"
    if [ -f "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile" ]; then
        if [ -f "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/install.wmscript.txt" ]; then
            genericProductsSetup "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/install.wmscript.txt"
            if [ "${RESULT_genericProductsSetup}" -eq 0 ]; then
                if [ -f ${WMLAB_INSTALL_HOME}/MWS/ccs/tools/ccs-admin.zip ]; then
                    logI "Building container ccs-admin-tool-${WMLAB_PRODUCTS_VERSION}:${WMLAB_FIXES_DATE_TAG}"
                    logI "Taking a snapshot of current images"
                    docker images > ${WMLAB_RUN_FOLDER}/04.docker-images-before-build.out
                    mkdir -p /tmp/dockerBuildContext
                    pushd . > /dev/null
                    cd /tmp/dockerBuildContext/
                    cp /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile .
                    unzip ${WMLAB_INSTALL_HOME}/MWS/ccs/tools/ccs-admin.zip
                    cp ${WMLAB_INSTALL_HOME}/common/lib/ext/log4j/log4j-core.jar ./ccs-admin/libs/
                    cp ${WMLAB_INSTALL_HOME}/common/lib/ext/log4j/log4j-api.jar ./ccs-admin/libs/

                    controlledExec "docker build -t ccs-admin-tool-${WMLAB_PRODUCTS_VERSION}:last-build -t ccs-admin-tool-${WMLAB_PRODUCTS_VERSION}:${WMLAB_FIXES_DATE_TAG} ." "buildCcsAdminToolContainer"
                    logI "Image built, taking a snapshot of current images"
                    docker images > ${WMLAB_RUN_FOLDER}/docker-images-after-build.out
                    logI "Pruning untagged images ..."
                    docker image prune -f # remove intermediary alpine + jvm image or older untagged mydbcc
                    popd > /dev/null
                else
                    logE "ccs-admin tool not installed! check your installation health!"
                fi
            else
                logE "Product Installation failed! (Code ${RESULT_genericProductsSetup})"
                # exit 2
            fi
        else
            logE "Product Installation script not provided, expected /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/install.wmscript.txt"
            # exit 3
        fi
    else
        logE "Dockerfile for provided version not found! Expected /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile"
    fi
else
    logE "Docker is not available!"
    #exit 1
fi

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
	logD "Stopping execution for debug"
	tail -f /dev/null
fi

exit 0

