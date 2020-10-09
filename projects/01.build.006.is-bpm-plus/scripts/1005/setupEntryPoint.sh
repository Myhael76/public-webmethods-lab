#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Setting up BPMS IS+ ..."
logD "Environment dump below"
logEnv

setupLocal(){
    logI "Executing the local setup part"
    genericProductsSetup "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/install.wmscript.txt"
    RESULT_setupLocal="${RESULT_genericProductsSetup}"
}

# Main Sequence

logI "Checking docker client availability..."
docker info >/dev/null 2>&1
if [ $? -eq 0 ]; then
	setupLocal
	if [ "${RESULT_setupLocal}" -eq 0 ]; then
		logI "Setup successful"
		logI "Taking a snapshot of current docker images"
		docker images > ${WMLAB_RUN_FOLDER}/04.docker-images-before-build.out

		basicInstallationCleanup

		# clean up a little
		
		logI "Preparing the docker context ... "

		rm -rf "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/config/repository4.cnf"

		DOCKER_CONTEXT_FOLDER="${WMLAB_RUN_FOLDER}/docker-build-context"
		# bring files to the context
		# jvm for development & experimentation, but production images should only copy the jre
		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/jvm"
		cp "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile" "${DOCKER_CONTEXT_FOLDER}/"
		cp -r "${WMLAB_INSTALL_HOME}/jvm/jvm" "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/jvm/"

		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/install"
		cp -r "${WMLAB_INSTALL_HOME}/install/jars"       "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/install/"
		cp -r "${WMLAB_INSTALL_HOME}/install/products"   "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/install/"
		cp -r "${WMLAB_INSTALL_HOME}/install/profile"    "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/install/"

		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common"
		cp -r "${WMLAB_INSTALL_HOME}/common/bin"                          "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/conf"                         "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/db"                           "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/DigitalEventServices"         "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/EventTypeStore"               "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/lib"                          "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/runtime"                      "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"

		cp -r "${WMLAB_INSTALL_HOME}/WS-Stack" "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/"

		# TODO: parametrize instance name if needed
		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/packages"
		
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/bin"                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/lib"                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/config"               "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/updates"              "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/web"                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/"
		cp    "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/"*log4j*.properties   "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/packages/Default"     "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/packages/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/default/packages/"Wm*         "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/default/packages/"
		
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/docker"                                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/lib"                                     "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/updates"                                 "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/bin"                                     "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/features"                                "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp    "${WMLAB_INSTALL_HOME}/IntegrationServer/"*log4j*.properties                      "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"

		cp "${WMLAB_INSTALL_HOME}/IntegrationServer/instances/is_instance."*                    "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/"
		cp "${WMLAB_INSTALL_HOME}/profiles/IS_default/configuration/custom_wrapper.conf"        "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/instances/custom_wrapper.conf.template"

		mkdir -p "${DOCKER_CONTEXT_FOLDER}/extra/profiles/IS_default/configuration/org.eclipse.equinox.simpleconfigurator/"
		cp "${WMLAB_INSTALL_HOME}/profiles/IS_default/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info.fixes" "${DOCKER_CONTEXT_FOLDER}/extra/profiles/IS_default/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info"
		cp "${WMLAB_INSTALL_HOME}/profiles/IS_default/configuration/security"                                                  "${DOCKER_CONTEXT_FOLDER}/extra/profiles/IS_default/configuration/"

		# Correction for a potential bug (???)

		sed -i 's|\.\${SAG_ROOT_DIR}|\${SAG_ROOT_DIR}|g' "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/bin/startContainer.sh"

		# Mysqlce driver is not packaged
		logI "Downloading mysqlce driver"
		mkdir -p ${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/lib/jars/custom
		downloadCmd="curl -o "'"${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/lib/jars/custom/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"'
		controlledExec "${downloadCmd}" "03-JDBCDriver-Download"

		## Note: following folders contain logs, they should be mounted
		# optimize/analysis/logs
		# common/runtime/agent/logs
		# This is a log file that changes rarely
		# common/lib/derby.log

		logI "Building docker image for bpm-isplus-${WMLAB_PRODUCTS_VERSION}"

		pushd . 
		cd "${WMLAB_RUN_FOLDER}/docker-build-context"
		controlledExec "docker build -t bpm-isplus-${WMLAB_PRODUCTS_VERSION} ." "05.buildIsPlusContainer"
		if [ ${RESULT_controlledExec} -ne 0 ]; then
			logE "docker build failed! Code: ${RESULT_controlledExec}"
		fi
		popd
	else
		logE "IS Plus setup failed (code ${RESULT_setupLocal}), cannot continue!"
	fi

else
    logE "Docker is not available!"
    exit 1
fi

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
	logD "Stopping execution for debug"
	tail -f /dev/null
fi
