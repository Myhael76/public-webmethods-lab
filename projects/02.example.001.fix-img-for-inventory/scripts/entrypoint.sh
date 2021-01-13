#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logD "Environment Dump"
logEnv

logI "Boostrapping SUM"
bootstrapSum

logI "Preparing script"
# mkdir -p "${WMLAB_RUN_FOLDER}"

cp /mnt/wm-files/patch.wmscript "${WMLAB_RUN_FOLDER}/"

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
