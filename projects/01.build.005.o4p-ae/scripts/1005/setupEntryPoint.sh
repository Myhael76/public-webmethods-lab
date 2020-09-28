#!/bin/sh

. /mnt/scripts/lib/common.sh

logI "Setting up Analytic Engine ..."
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

		logI "Building docker image for o4p-ae-server-${WMLAB_PRODUCTS_VERSION}"

		# preparing the folder structure
		mkdir -p ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME
		mkdir -p \
			${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/ \
			${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/db \
			${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/optimize


		# clean up a little
		rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm/sample
		rm -f ${WMLAB_INSTALL_HOME}/jvm/jvm/src.zip
		rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm/man
		rm -rf ${WMLAB_INSTALL_HOME}/jvm/jvm/demo
		rm -f ${WMLAB_INSTALL_HOME}/common/lib/derby.log
		rm -rf ${WMLAB_INSTALL_HOME}/jvm/*.bck
		
		# bring files to the context
		cp /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile "${WMLAB_RUN_FOLDER}/docker-build-context"
		mv ${WMLAB_INSTALL_HOME}/jvm/jvm ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/
		mv ${WMLAB_INSTALL_HOME}/common/bin ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		mv ${WMLAB_INSTALL_HOME}/common/lib ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		mv ${WMLAB_INSTALL_HOME}/common/db ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		mv ${WMLAB_INSTALL_HOME}/common/conf ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		mv ${WMLAB_INSTALL_HOME}/common/EventTypeStore ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		mv ${WMLAB_INSTALL_HOME}/common/runtime ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		mv ${WMLAB_INSTALL_HOME}/optimize ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/

		downloadCmd="curl -o "'"${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"'
		controlledExec "${downloadCmd}" "03-JDBCDriver-Download"

		## Note: following folders contain logs, they should be mounted
		# optimize/analysis/logs
		# common/runtime/agent/logs
		# This is a log file that changes rarely
		# common/lib/derby.log

		pushd . 
		cd "${WMLAB_RUN_FOLDER}/docker-build-context"
		controlledExec "docker build -t o4p-ae-server-${WMLAB_PRODUCTS_VERSION} ." "05.buildO4PAEContainer"
		if [ ${RESULT_controlledExec} -ne 0 ]; then
			logE "docker build failed! Code: ${RESULT_controlledExec}"
		fi
		popd
	else
		logE "Analytic Engine setup failed (code ${RESULT_setupLocal}), cannot continue!"
	fi

else
    logE "Docker is not available!"
    exit 1
fi

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
	logD "Stopping execution for debug"
	tail -f /dev/null
fi
