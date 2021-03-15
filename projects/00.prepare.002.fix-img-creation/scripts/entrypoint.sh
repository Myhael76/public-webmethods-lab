#!/bin/sh

# import framework functions
. /mnt/scripts/lib/common/common.sh

WMLAB_FIXES_ONLINE_CRED_FILE=${WMLAB_FIXES_ONLINE_CRED_FILE:-"/mnt/secret/empower-credentials-fixes.txt"}
WMLAB_PLATFORM_STRING=${WMLAB_PLATFORM_STRING:-"LNXAMD64"}
WMLAB_INVENTORY_FILE=${WMLAB_INVENTORY_FILE:-"/mnt/wm-files/inventory.json"}

logD "Environment Dump"
logEnv

if [ -f "${WMLAB_FIXES_ONLINE_CRED_FILE}" ]; then
    if [ -f "${WMLAB_INVENTORY_FILE}" ]; then
        logI "Boostrapping SUM"
        bootstrapSum

        if [ ${RESULT_bootstrapSum} -eq 0 ]; then
            logI "Preparing script"
            cp /mnt/wm-files/patch.wmscript "${WMLAB_RUN_FOLDER}/"
            cat "${WMLAB_FIXES_ONLINE_CRED_FILE}" >> "${WMLAB_RUN_FOLDER}/patch.wmscript"

            WMLAB_FIXES_DATE_TAG=${WMLAB_FIXES_DATE_TAG:-`date +%y-%m-%d`}

            sed -i 's|__PLATFORM_HERE__|'"${WMLAB_PLATFORM_STRING}"'|g' "${WMLAB_RUN_FOLDER}/patch.wmscript"

            cat ${WMLAB_FIXES_ONLINE_CRED_FILE} >> "${WMLAB_RUN_FOLDER}/patch.wmscript"

            logI "Creating fixes image"

            cd /opt/sag/sum/bin 

            cmd="./UpdateManagerCMD.sh -readScript "'"'"${WMLAB_RUN_FOLDER}/patch.wmscript"'"'
            cmd="${cmd} -installDir ${WMLAB_INVENTORY_FILE}"
            cmd="${cmd} -imagePlatform ${WMLAB_PLATFORM_STRING}"
            cmd="${cmd} -createImage "'"'"/mnt/fixesOutDir/fixes_${WMLAB_FIXES_DATE_TAG}_${WMLAB_PLATFORM_STRING}_${WMLAB_PRODUCTS_VERSION}.wmimage.zip"'"'

            controlledExec "${cmd}" "02.Update"
        else
            logE "SUM Bootstrap failed, code ${RESULT_bootstrapSum}, taking a snapshots of logs"
            cp -r /opt/sag/sum/logs "${WMLAB_RUN_FOLDER}"
            exit 2
        fi
    else
        logE "Inventory file does not exist!"
        exit 2
    fi
else
    logE "Credentials file does not exist!"
    exit 1
fi

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
	logD "Stopping execution for debug"
	tail -f /dev/null
fi 