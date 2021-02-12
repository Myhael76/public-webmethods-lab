#!/bin/sh

# import framework functions
. /mnt/scripts/lib/common/common.sh

logD "Environment Dump"
logEnv

logI "Boostrapping SUM"
bootstrapSum

logI "Preparing script"

cp /mnt/wm-files/patch.wmscript "${WMLAB_RUN_FOLDER}/"
cat /mnt/wm-files/sum-online-credentials.txt >> "${WMLAB_RUN_BASE_MOUNT}/patch.wmscript"

WMLAB_PLATFORM_STRING=${WMLAB_PLATFORM_STRING:-"LNXAMD64"}

sed -i 's|__PLATFORM_HERE__|'"${WMLAB_PLATFORM_STRING}"'|g' "${WMLAB_RUN_FOLDER}/patch.wmscript"

cat ${WMLAB_FIXES_ONLINE_CRED_FILE} >> "${WMLAB_RUN_FOLDER}/patch.wmscript"

logI "Creating fixes image"

cd /opt/sag/sum/bin

cmd="./UpdateManagerCMD.sh -readScript "'"'"${WMLAB_RUN_FOLDER}/patch.wmscript"'"'
cmd="${cmd} -installDir /mnt/wm-files/inventory.json"
cmd="${cmd} -imagePlatform ${WMLAB_PLATFORM_STRING}"
cmd="${cmd} -createImage "'"'"/mnt/fixesOutDir/fixes_${WMLAB_FIXES_DATE_TAG}_${WMLAB_PLATFORM_STRING}_${WMLAB_PRODUCTS_VERSION}.wmimage.zip"'"'

controlledExec "${cmd}" "02.Update"
