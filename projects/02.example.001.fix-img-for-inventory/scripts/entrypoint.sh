#!/bin/sh

. /mnt/scripts/lib/common.sh

logI "Boostrapping SUM"
bootstrapSum

logI "Preparing script"

cp /mnt/wm-files/patch.wmscript "${WMLAB_RUN_FOLDER}"

cat /mnt/wm-files/sum-online-credentials.txt >> "${WMLAB_RUN_FOLDER}/patch.wmscript"

logI "Creating fixes image"

cd /opt/sag/sum/bin

./UpdateManagerCMD.sh \
    -readScript "${WMLAB_RUN_FOLDER}/patch.wmscript" \
    -installDir /mnt/wm-files/inventory.json \
    -createImage "${WMLAB_RUN_FOLDER}/fixes.image" \
    > "${WMLAB_RUN_FOLDER}/Update.out" \
    2> "${WMLAB_RUN_FOLDER}/Update.err"

