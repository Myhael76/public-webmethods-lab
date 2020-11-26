#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logD "Environment dump below"
logEnv

logI "Checking docker client availability..."
docker info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    logI "Docker ok, setting up DBC-${WMLAB_PRODUCTS_VERSION}..."
    if [ -f "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile" ]; then
        if [ -f ${WMLAB_INSTALL_SCRIPT_FILE} ]; then
            genericProductsSetup "${WMLAB_INSTALL_SCRIPT_FILE}"
            #/mnt/scripts/local/install.wmscript.txt

            if [ "${RESULT_genericProductsSetup}" -eq 0 ]; then
                logI "Building container mydbcc-${WMLAB_PRODUCTS_VERSION}"
                logI "Taking a snapshot of current images"
                docker images > ${WMLAB_RUN_FOLDER}/docker-images-before-build.out
                cp /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile "${WMLAB_INSTALL_HOME}"
                pushd .
                cd "${WMLAB_INSTALL_HOME}"
                logI "Building docker image mydbcc-${WMLAB_PRODUCTS_VERSION}"
                controlledExec "docker build -t mydbcc-${WMLAB_PRODUCTS_VERSION}:last-build -t mydbcc-${WMLAB_PRODUCTS_VERSION}:${WMLAB_FIXES_DATE_TAG}  ." "buildDbccContainer"
                logI "Image built, taking a snapshot of current images"
                docker images > ${WMLAB_RUN_FOLDER}/docker-images-after-build.out
                logI "Pruning untagged images ..."
                docker image prune -f # remove intermediary alpine + jvm image or older untagged mydbcc
                popd
            else
                logE "Product Installation failed! (Code ${RESULT_genericProductsSetup})"
                cp "${WMLAB_INSTALL_SCRIPT_FILE}" ${WMLAB_RUN_FOLDER}/install.script.txt
                cp "${WMLAB_PRODUCTS_IMAGE}"  ${WMLAB_RUN_FOLDER}/image.zip
                # exit 2
            fi
        else
            logE "Product Installation script not provided! WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE}"
            # exit 3
        fi
    else
        logE "Dockerfile for provided version not found! Expected /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile"
    fi
else
    logE "Docker is not aailable!"
    #exit 1
fi

exit 0