#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Setting up ..."
logEnv

setupLocal(){
    logI "Executing the local setup part"
    cp "${WMLAB_INSTALL_SCRIPT_FILE}" /tmp/install.wmscript
    # TODO: sed variables, now hardwired
    genericProductsSetup /tmp/install.wmscript
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