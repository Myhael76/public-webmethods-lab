#!/bin/sh

initSetupCommons(){
    # dependency
    export WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT=${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT:-"/mnt/scripts/lib/common"}

    # swithces
    export WMLAB_FIXES_ONLINE=${WMLAB_FIXES_ONLINE:-0}       # default patch offline
    export WMLAB_SKIP_PATCHING=${WMLAB_SKIP_PATCHING:-0}     # always patch by default, 1 means skip

    # the following MUST be set properly!
    export WMLAB_INSTALLER_BIN=${WMLAB_INSTALLER_BIN:-"Variable not set! Provide file path name for installer"}
    export WMLAB_PRODUCTS_IMAGE=${WMLAB_PRODUCTS_IMAGE:-"Variable not set! Provide file path name for products image"}
    export WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE:-"Variable not set! Provide an installer script!"}
    export WMLAB_FIXES_ONLINE_CRED_FILE=${WMLAB_FIXES_ONLINE_CRED_FILE:-"./secret/sumCredentials.txt"}
    export WMLAB_FIXES_IMAGE_FILE=${WMLAB_FIXES_IMAGE_FILE:-"Variable not set! Provide file path name for fixes image"}
    export WMLAB_SUM10_BOOTSTRAP_BIN=${WMLAB_SUM10_BOOTSTRAP_BIN:-"Variable not set! Provide file path name for Update Manager v10 boostrap"}
    export WMLAB_SUM11_BOOTSTRAP_BIN=${WMLAB_SUM11_BOOTSTRAP_BIN:-"Variable not set! Provide file path name for Update Manager v11 boostrap"}

    if [ ${WMLAB_SKIP_PATCHING} -ne 0 ]; then
        export WMLAB_FIXES_DATE_TAG="fixes-none"
    else
        export WMLAB_FIXES_DATE_TAG=${WMLAB_FIXES_DATE_TAG:-"fixes-undeclared"}
    fi

}

initSetupCommons
if [ -f ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh ]; then
    . ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh
else
    echo "file ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/commons.sh does not exist, cannot continue!"

    tail -f /dev/null

    exit 1
fi

installProducts(){
    # param $1 is the products installation script
    ## TODO: chceck install home consistency with provided script
    SCRIPT_FILE=${1}
    if [ -z ${SCRIPT_FILE+x} ]; then
        logD "Installer script not provided, using the framework variable WMLAB_INSTALL_SCRIPT_FILE=${WMLAB_INSTALL_SCRIPT_FILE}"
        SCRIPT_FILE="${WMLAB_INSTALL_SCRIPT_FILE}"
    fi

    if [ -f "${WMLAB_INSTALLER_BIN}" ]; then
        logI "Installing products according to script ${SCRIPT_FILE} ..."
        if [ -f "${SCRIPT_FILE}" ]; then

            installCmd="${WMLAB_INSTALLER_BIN}"
            installCmd="${installCmd} -readScript "'"'"${SCRIPT_FILE}"'"'
            if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
                installCmd="${installCmd} -debugLvl verbose"
            fi
            installCmd="${installCmd} -debugFile "'"'"${WMLAB_RUN_FOLDER}/01.01.product-install.log"'"'
            controlledExec "${installCmd}" "01.01.product-install"
            
            # "${WMLAB_INSTALLER_BIN}" \
            #     -readScript "${SCRIPT_FILE}" \
            #     -debugLvl verbose \
            #     -debugFile "${WMLAB_RUN_FOLDER}/01.01.product-install.log"\
            #     > "${WMLAB_RUN_FOLDER}/01.01.product-install.out" \
            #     2> "${WMLAB_RUN_FOLDER}/01.01.product-install.err"
            
            RESULT_installProducts=$?
            if [ ${RESULT_installProducts} -eq 0 ] ; then
                logI "Product installation successful"
            else
                logE "Product installation failed, code ${RESULT_installProducts}"
            fi
        else
            logE "Product installation failed: invalid installer script file: ${WMLAB_INSTALLER_BIN}"
            RESULT_installProducts=1
        fi
    else
            logE "Product installation failed: invalid installer file: ${WMLAB_INSTALLER_BIN}"
            RESULT_installProducts=2
    fi
}

patchInstallation(){
    ###### 03 - Patch installation
    # TODO: render patching optional with a parameter
    logI "Applying fixes ..."
    pushd . >/dev/null
    cd "${WMLAB_SUM_HOME}/bin"

    echo "installSP=N" >/dev/shm/fixes.wmscript.txt
    echo "installDir=${WMLAB_INSTALL_HOME}" >>/dev/shm/fixes.wmscript.txt
    echo "selectedFixes=spro:all" >>/dev/shm/fixes.wmscript.txt

    if [ ${WMLAB_FIXES_ONLINE} -eq 1 ] ; then
        echo "action=Install fixes from Empower" >> /dev/shm/fixes.wmscript.txt
        cat "${WMLAB_FIXES_ONLINE_CRED_FILE}" >> /dev/shm/fixes.wmscript.txt
    else
        echo "action=Install fixes from image" >> /dev/shm/fixes.wmscript.txt
        echo "imageFile=${WMLAB_FIXES_IMAGE_FILE}" >> /dev/shm/fixes.wmscript.txt
    fi

    controlledExec "./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt" "01.03.PatchInstallation"
    #./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt \
    #    > "${WMLAB_RUN_FOLDER}/patching.out" \
    #    2> "${WMLAB_RUN_FOLDER}/patching.err" 
    
    RESULT_patchInstallation=$?
        
    rm -f /dev/shm/fixes.wmscript.txt
    popd >/dev/null
}

startInstallerInAttendedMode(){
    # force new run_folder
    WMLAB_RUN_FOLDER="${WMLAB_RUN_BASE_MOUNT}/"`date +%y-%m-%dT%H.%M.%S_%3N`
    mkdir -p ${WMLAB_RUN_FOLDER}
    ${WMLAB_INSTALLER_BIN} -console \
        -installDir "${WMLAB_INSTALL_HOME}" \
        -readImage "${WMLAB_PRODUCTS_IMAGE}" \
        -writeScript ${WMLAB_RUN_FOLDER}/install.wmscript.txt
}

genericProductsSetup(){
    installProducts "${1}"
    if [[ ${RESULT_installProducts} -eq 0 ]] ; then
        takeInstallationSnapshot 01.Setup-01-after-install

        if [ ${WMLAB_SKIP_PATCHING} -eq 0 ]; then
            bootstrapSum
            if [[ ${RESULT_bootstrapSum} -eq 0 ]] ; then
                patchInstallation
                if [[ ${RESULT_patchInstallation} -eq 0 ]] ; then
                    takeInstallationSnapshot 01.Setup-02-after-patch
                    RESULT_genericProductsSetup=0
                else
                    logE "Patching failed: ${PATCH_RESULT}"
                    RESULT_genericProductsSetup=3 # 3 - patching failed
                fi
            else
                logE "SUM Bootstrap failed: ${SUM_BOOT_RESULT}"
                RESULT_genericProductsSetup=2 # 2 - bootstrap failed
            fi
        else
            logI "Patching skipped..."
            RESULT_genericProductsSetup=0
        fi
    else
        logE "Installation failed: ${INSTALL_RESULT}"
        RESULT_genericProductsSetup=1 # 1 - installation failed
    fi
}

