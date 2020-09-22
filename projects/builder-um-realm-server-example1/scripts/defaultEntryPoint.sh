#!/bin/sh

. /mnt/scripts/lib/common.sh

logD "Environment dump below"
logEnv

logI "Checking docker client availability..."
docker info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    logI "Docker ok, setting up um-realm-server-${WMLAB_PRODUCTS_VERSION}..."
    if [ -f "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile" ]; then
        if [ -f ${WMLAB_INSTALL_SCRIPT_FILE} ]; then
            genericProductsSetup "${WMLAB_INSTALL_SCRIPT_FILE}"
            #/mnt/scripts/local/install.wmscript.txt

            if [ "${RESULT_genericProductsSetup}" -eq 0 ]; then
                logI "Building container um-realm-server-${WMLAB_PRODUCTS_VERSION}"
                logI "Taking a snapshot of current images"
                docker images > ${WMLAB_RUN_FOLDER}/docker-images-before-build.out
                mkdir -p ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME

                cp /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile "${WMLAB_RUN_FOLDER}/docker-build-context"
                pushd .
                cd "${WMLAB_RUN_FOLDER}/docker-build-context"

                mkdir -p \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/ \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/conf \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/lib \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/server \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/classes \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/tools/runner \
                    ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/tools/InstanceManager

                logI "Building docker image um-realm-server-${WMLAB_PRODUCTS_VERSION}"

                mv ${WMLAB_INSTALL_HOME}/jvm/jvm ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/

                rm -rf ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/jvm/sample
                rm -f ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/jvm/src.zip
                rm -rf ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/jvm/man
                rm -rf ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/jvm/demo

                mv ${WMLAB_INSTALL_HOME}/common/bin ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
                mv ${WMLAB_INSTALL_HOME}/common/lib ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
                mv ${WMLAB_INSTALL_HOME}/common/metering ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
                mv ${WMLAB_INSTALL_HOME}/install ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/
                # users.txt may be mounted or overwritten at runtime
                mv ${WMLAB_INSTALL_HOME}/common/conf/users.txt ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/conf
                mv ${WMLAB_INSTALL_HOME}/UniversalMessaging/lib ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/
                mv ${WMLAB_INSTALL_HOME}/UniversalMessaging/classes ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/
                mv ${WMLAB_INSTALL_HOME}/UniversalMessaging/server/profiles ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/server/
                mv ${WMLAB_INSTALL_HOME}/UniversalMessaging/server/templates ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/server/
                mv ${WMLAB_INSTALL_HOME}/UniversalMessaging/tools/runner ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/tools/
                mv ${WMLAB_INSTALL_HOME}/UniversalMessaging/tools/InstanceManager/*.sh ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/UniversalMessaging/tools/InstanceManager/
                
                controlledExec "docker build -t um-realm-server-${WMLAB_PRODUCTS_VERSION} ." "buildUmRealmServerContainer"

                logI "Image built, taking a snapshot of current images"
                docker images > ${WMLAB_RUN_FOLDER}/docker-images-after-build.out
                logI "Pruning untagged images ..."
                docker image prune -f # remove intermediary alpine + jvm image or older untagged um-realm-server
                popd
            else
                logE "Product Installation failed! (Code ${RESULT_genericProductsSetup})"
                exit 4
            fi
        else
            logE "Product Installation script not provided! WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE}"
            exit 3
        fi
    else
        logE "Dockerfile for provided version not found! Expected /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile"
		exit 2
    fi
else
    logE "Docker is not available!"
    exit 1
fi

tail -f /dev/null
exit 0