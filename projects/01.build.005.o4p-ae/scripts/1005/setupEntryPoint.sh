#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

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

		# clean up a little
		basicInstallationCleanup

		logI "Building docker image for o4p-ae-server-${WMLAB_PRODUCTS_VERSION}:${WMLAB_FIXES_DATE_TAG}"

		# preparing the folder structure
		mkdir -p ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/lib/ext/
		#mkdir -p \
		#	${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/ \
		#	${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/db \
		#	${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/optimize


		# bring files to the context
		cp "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/Dockerfile" "${WMLAB_RUN_FOLDER}/docker-build-context"
		#mv ${WMLAB_INSTALL_HOME}/jvm/jvm ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/jvm/
		#mv ${WMLAB_INSTALL_HOME}/common/bin ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		#mv ${WMLAB_INSTALL_HOME}/common/lib ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		#mv ${WMLAB_INSTALL_HOME}/common/db ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		#mv ${WMLAB_INSTALL_HOME}/common/conf ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		#mv ${WMLAB_INSTALL_HOME}/common/EventTypeStore ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		#mv ${WMLAB_INSTALL_HOME}/common/runtime ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/
		#mv ${WMLAB_INSTALL_HOME}/optimize ${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/
		# There are other files to copy, I do not know which ones at this point.
		# not copying this results in some class not found errors, even if the classes are actually loaded
		# TODO: optimize image
		cp -r "${WMLAB_INSTALL_HOME}/"* "${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/"

		downloadCmd='curl -o "'"${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}"'" "'"${WMLAB_JDBC_DRIVER_URL}"'"'
		controlledExec "${downloadCmd}" "03-JDBCDriver-Download"

		if [ -f "${WMLAB_RUN_FOLDER}/docker-build-context/SAG_HOME/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" ]; then

			## Note: following folders contain logs, they should be mounted
			# optimize/analysis/logs
			# common/runtime/agent/logs
			# This is a log file that changes rarely
			# common/lib/derby.log

			pushd . > /dev/null
			cd "${WMLAB_RUN_FOLDER}/docker-build-context"
			controlledExec \
				"docker build -t o4p-ae-server-${WMLAB_PRODUCTS_VERSION}:last-build -t o4p-ae-server-${WMLAB_PRODUCTS_VERSION}:${WMLAB_FIXES_DATE_TAG} --build-arg BASE_IMAGE=ccs-admin-tool-${WMLAB_PRODUCTS_VERSION}:${WMLAB_FIXES_DATE_TAG} ." \
				"05.buildO4PAEContainer"
			if [ ${RESULT_controlledExec} -ne 0 ]; then
				logE "docker build failed! Code: ${RESULT_controlledExec}"
			fi
			popd > /dev/null
		else
			logE "JDBC driver download failed (code ${RESULT_controlledExec}), cannot continue!"
		fi
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
