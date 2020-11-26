#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Setting up API Gateway Advanced ..."
logEnv

setupLocal(){
    logI "Executing the local setup part"
    genericProductsSetup "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/install.wmscript.txt"
    RESULT_setupLocal="${RESULT_genericProductsSetup}"
}

# Main Sequence
startDstatResourceMonitor
setupLocal
takeInstallationSnapshot "AfterSetup"

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
    logD "Stopping execution for debug"
    tail -f /dev/null
fi