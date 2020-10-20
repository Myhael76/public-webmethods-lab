#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Setting up BPMS Type 1 - Single Node"
logEnv

setupLocal(){
    logI "Executing the local setup part"
    genericProductsSetup "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/node/install.wmscript.txt"
    RESULT_setupLocal="${RESULT_genericProductsSetup}"
}

generateBndFile(){
    fullFileName="${WMLAB_INSTALL_HOME}/MWS/lib/${WMLAB_BND_FILENAME}"
    logI "Preparing BND file ${WMLAB_BND_FILENAME}"
    echo "# attach as fragment to the caf.server bundle" > ${fullFileName}
    echo "Fragment-Host: com.webmethods.caf.server" >> ${fullFileName}
    echo "Bundle-SymbolicName: ${WMLAB_Bundle_SymbolicName}" >> ${fullFileName}
    echo "Bundle-Version: ${WMLAB_Bundle_Version}" >> ${fullFileName}
    echo "Include-Resource: ${WMLAB_JDBC_DRIVER_FILENAME}" >> ${fullFileName}
    echo "-exportcontents: *" >> ${fullFileName}
    echo "Bundle-ClassPath: ${WMLAB_JDBC_DRIVER_FILENAME}" >> ${fullFileName}
    echo "Import-Package: *;resolution:=optional" >> ${fullFileName}
    logD "Dump BND File ${WMLAB_BND_FILENAME}"
    controlledExec "cat ${fullFileName}" "DumpBndFile"
}

prepareJdbcDriver(){
    downloadCmd="curl -o "'"${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"'
    controlledExec "${downloadCmd}" "03-JDBCDriver-Download"

    if [ -f "${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" ]; then
        cp ${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME} ${WMLAB_INSTALL_HOME}/MWS/lib/${WMLAB_JDBC_DRIVER_FILENAME}
        generateBndFile
        RESULT_prepareJdbcDriver=0
    else
        RESULT_prepareJdbcDriver=1
        logE "Could not download JDBC driver from ${WMLAB_JDBC_DRIVER_URL}"
    fi
    unset downloadCmd
}

linkDatabase(){
    temp=`(echo > /dev/tcp/${WMLAB_MYSQL_HOSTNAME}/3306) >/dev/null 2>&1`
    CHK_DB_UP=$?

    if [ ${CHK_DB_UP} -eq 0 ] ; then
        logI "Updating instance"
        pushd .
        cd "${WMLAB_INSTALL_HOME}/MWS/bin"
        controlledExec "./mws.sh update" "04-UpdateInstance"
        #if [ ${RESULT_controlledExec} -eq 0 ]; then
        #    controlledExec "./mws.sh create-osgi-profile" "05-CreateOsgiProfile"
        #    logI "Update successful"
            RESULT_linkDatabase=0
        #else
        #    logE "MWS default instance update failed! code ${RESULT_controlledExec}"
        #    RESULT_linkDatabase=3
        #fi
        popd
    else
        logE "Database not reachable: ${WMLAB_MYSQL_HOSTNAME}:3306"
        RESULT_linkDatabase=1
    fi

    unset CHK_DB_UP
}

initializeMwsDefaultInstance(){
    logI "Initializing default MWS instance..."
    
    temp=`(echo > /dev/tcp/${WMLAB_MYSQL_HOSTNAME}/3306) >/dev/null 2>&1`
    CHK_DB_UP=$?

    if [ ${CHK_DB_UP} -eq 0 ] ; then
        pushd .
        cd "${WMLAB_INSTALL_HOME}/MWS/bin"
        controlledExec "./mws.sh init" "05-InitInstance"
        if [ "${RESULT_controlledExec}" -eq 0 ]; then
            RESULT_initializeMwsDefaultInstance=0
            logI "Init command successful"
        else
            RESULT_initializeMwsDefaultInstance=2
            logE "Init command failed (code ${RESULT_controlledExec})"
        fi
        popd
    else
        logE "Database at ${WMLAB_MYSQL_HOSTNAME}:3306 not reachable!"
        RESULT_initializeMwsDefaultInstance=1
    fi
}

# Main Sequence
startDstatResourceMonitor
setupLocal
if [ "${RESULT_setupLocal}" -eq 0 ]; then
    prepareJdbcDriver
    if [ ${RESULT_prepareJdbcDriver} -eq 0 ]; then
        linkDatabase
        if [ ${RESULT_linkDatabase} -eq 0 ]; then
            takeInstallationSnapshot "AfterSetup"
            initializeMwsDefaultInstance
            takeInstallationSnapshot "AfterMwsInit"
            if [ "${RESULT_initializeMwsDefaultInstance}" -eq 0 ]; then
                logI "Setup successful"
            else
                logE "Initialize instance failed (code ${RESULT_initializeMwsDefaultInstance}), cannot continue!"
            fi
        else
            logE "Bind DB Driver failed (code ${RESULT_linkDatabase}), cannot continue!"
        fi
    else
        logE "JDBC Driver setup failed (code ${RESULT_prepareJdbcDriver}), cannot continue!"
    fi
else
    logE "Setting up MWS failed (code ${RESULT_setupLocal}), cannot continue!"
fi

takeInstallationSnapshot "AfterSetup"

if [ "${WMLAB_DEBUG_ON}" -eq 1 ]; then
    logD "Stopping execution for debug"
    tail -f /dev/null
fi