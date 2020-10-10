#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Setting up MSR ..."
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

		DOCKER_CONTEXT_FOLDER="${WMLAB_RUN_FOLDER}/docker-build-context"

		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common"
		cp -r "${WMLAB_INSTALL_HOME}/common/bin"  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/conf" "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/db"   "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"
		cp -r "${WMLAB_INSTALL_HOME}/common/lib"  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/common/"

		cp -r "${WMLAB_INSTALL_HOME}/jvm"         "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/"
		cp -r "${WMLAB_INSTALL_HOME}/WS-Stack"    "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/"

		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/lib/jars/custom"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/bin"                              "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/lib"                              "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/updates"                          "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/web"                              "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		#cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/docker"                           "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/replicate"                        "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/config"                           "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/.tc.dev.log4j.properties"         "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/"

		mkdir -p "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/packages"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/packages/Default"                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/packages"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/packages/WmRoot"                   "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/packages"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/packages/WmPublic"                 "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/packages"
		#cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/packages/WmCloud"                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/packages"
		cp -r "${WMLAB_INSTALL_HOME}/IntegrationServer/packages/WmAdmin"                  "${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/packages"

		# remove license
		rm -f "${WMLAB_INSTALL_HOME}/IntegrationServer/config/licenseKey.xml"
		touch "${WMLAB_INSTALL_HOME}/IntegrationServer/config/licenseKey.xml" # (work around for known bug)

		# Mysqlce driver is not packaged
		logI "Downloading mysqlce driver"
		downloadCmd="curl -o "'"${DOCKER_CONTEXT_FOLDER}/SAG_HOME/IntegrationServer/lib/jars/custom/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"'
		controlledExec "${downloadCmd}" "03-JDBCDriver-Download"

		cp /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile "${DOCKER_CONTEXT_FOLDER}/" 

		logI "Building docker image for msr-lean-devel-${WMLAB_PRODUCTS_VERSION}"

		pushd . 
		cd "${DOCKER_CONTEXT_FOLDER}"/
		controlledExec "docker build -t msr-lean-devel-${WMLAB_PRODUCTS_VERSION} ." "05.buildIsPlusContainer"
		if [ ${RESULT_controlledExec} -ne 0 ]; then
			logE "docker build failed! Code: ${RESULT_controlledExec}"
		fi
		popd
	else
		logE "MSR Lean setup failed (code ${RESULT_setupLocal}), cannot continue!"
	fi

else
    logE "Docker is not available!"
    exit 1
fi

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
	logD "Stopping execution for debug"
	tail -f /dev/null
fi
