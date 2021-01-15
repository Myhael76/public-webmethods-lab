#!/bin/sh

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

logD "Environment Dump"
logEnv

# logI "Preparing script"

cp /mnt/products.wmscript /dev/shm/products.wmscript

if [ -z ${WMLAB_EMPOWER_PASSWORD} ]; then
    logE "Empower user password not received! Cannot produce image"
else
    logI "Creating product image"
    
    cd /tmp

    crtTime=`date +%y-%m-%dT%H.%M.%S_%3N`
    imageFile="${WMLAB_PRODUCT_IMAGE_DIR}/Products_${WMLAB_PLATFORM_STRING}_${WMLAB_PRODUCTS_VERSION}_${crtTime}.wmimage.zip"
    
    echo "Username=${WMLAB_EMPOWER_USER}" >> /dev/shm/products.wmscript
    echo "Password=${WMLAB_EMPOWER_PASSWORD}" >> /dev/shm/products.wmscript
    echo "imagePlatform=${WMLAB_PLATFORM_STRING}" >> /dev/shm/products.wmscript
    echo "LicenseAgree=Accept" >> /dev/shm/products.wmscript
    echo "InstallLocProducts=" >> /dev/shm/products.wmscript
    echo "imageFile=${imageFile}" >> /dev/shm/products.wmscript    

    cmd="${WMLAB_INSTALLER_BIN} -readScript /dev/shm/products.wmscript"
    cmd="${cmd} -writeImage ${imageFile}"

    controlledExec "${cmd}" "02.ImageCreation"

    rm /dev/shm/products.wmscript
fi