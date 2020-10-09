#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logD "Environment dump below"
logEnv

ERROR_CODE=0
WMLAB_DEBUG_ON=${WMLAB_DEBUG_ON:-0}

logI "Checking docker client availability..."
docker info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    logI "Docker ok, setting up umtool-${WMLAB_PRODUCTS_VERSION}..."
    if [ -f "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile" ]; then
        if [ -f ${WMLAB_INSTALL_SCRIPT_FILE} ]; then
            genericProductsSetup "${WMLAB_INSTALL_SCRIPT_FILE}"
            #/mnt/scripts/local/install.wmscript.txt

            if [ "${RESULT_genericProductsSetup}" -eq 0 ]; then
                logI "Taking a snapshot of current images"
                docker images > ${WMLAB_RUN_FOLDER}/docker-images-before-build.out

                # cleaning up install folder
                basicInstallationCleanup

                logI "Preparing docker build context"
                dockerBuildContextFolder=${WMLAB_RUN_FOLDER}/dockerBuildContext
                mkdir -p "${dockerBuildContextFolder}/SAG_HOME/UniversalMessaging/lib"
                cp /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile "${dockerBuildContextFolder}/"
                cp -r "${WMLAB_INSTALL_HOME}/jvm" "${dockerBuildContextFolder}/SAG_HOME/"
                cp -r "${WMLAB_INSTALL_HOME}/UniversalMessaging/classes" "${dockerBuildContextFolder}/SAG_HOME/UniversalMessaging/"
                cp -r "${WMLAB_INSTALL_HOME}/UniversalMessaging/lib/classes" "${dockerBuildContextFolder}/SAG_HOME/UniversalMessaging/lib/"
                # Note: * does not work inside the string...
                cp    "${WMLAB_INSTALL_HOME}/UniversalMessaging/lib/"*.jar   "${dockerBuildContextFolder}/SAG_HOME/UniversalMessaging/lib/"
                mkdir -p "${dockerBuildContextFolder}/SAG_HOME/common/lib/ext/log4j"
                cp "${WMLAB_INSTALL_HOME}/common/lib/ext/log4j/log4j-api.jar" "${dockerBuildContextFolder}/SAG_HOME/common/lib/ext/log4j/"
                cp "${WMLAB_INSTALL_HOME}/common/lib/ext/log4j/log4j-core.jar" "${dockerBuildContextFolder}/SAG_HOME/common/lib/ext/log4j/"
                mkdir -p "${dockerBuildContextFolder}/SAG_HOME/UniversalMessaging/tools/runner"
                cp "${WMLAB_INSTALL_HOME}/UniversalMessaging/tools/runner/"* "${dockerBuildContextFolder}/SAG_HOME/UniversalMessaging/tools/runner/"

                logI "Building docker image umtool-${WMLAB_PRODUCTS_VERSION}"
                pushd .
                cd "${dockerBuildContextFolder}"
                controlledExec "docker build -t umtool-${WMLAB_PRODUCTS_VERSION} ." "04.buildContainer"
                logI "Image built, taking a snapshot of current images"
                docker images > ${WMLAB_RUN_FOLDER}/docker-images-after-build.out
                popd
            else
                logE "Product Installation failed! (Code ${RESULT_genericProductsSetup})"
                ERROR_CODE=4
            fi
        else
            logE "Product Installation script not provided! WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE}"
            ERROR_CODE=3
        fi
    else
        logE "Dockerfile for provided version not found! Expected /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile"
        ERROR_CODE=2
    fi
else
    logE "Docker is not aailable!"
    ERROR_CODE=1
fi

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
    logD "Stopping for debugging"
    tail -f /dev/null
fi

exit ${ERROR_CODE}