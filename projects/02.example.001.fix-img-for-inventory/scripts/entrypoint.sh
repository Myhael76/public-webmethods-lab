#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logD "Environment Dump"
logEnv

logI "Boostrapping SUM"
bootstrapSum

logI "Preparing script"
# mkdir -p "${WMLAB_RUN_FOLDER}"

cp /mnt/wm-files/patch.wmscript "${WMLAB_RUN_BASE_MOUNT}/"

cat ${WMLAB_FIXES_ONLINE_CRED_FILE} >> "${WMLAB_RUN_BASE_MOUNT}/patch.wmscript"

logI "Creating fixes image"

cd /opt/sag/sum/bin

cmd="./UpdateManagerCMD.sh -readScript "'"'"${WMLAB_RUN_BASE_MOUNT}/patch.wmscript"'"'
cmd="${cmd} -installDir /mnt/wm-files/inventory.json"
cmd="${cmd} -createImage "'"'"${WMLAB_RUN_BASE_MOUNT}/fixes.image"'"'

controlledExec "${cmd}" "02.Update"
