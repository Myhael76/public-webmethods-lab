#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Setting up MWS ..."
logEnv

setupLocal(){
    logI "Executing the local setup part"
    genericProductsSetup "/mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/install.wmscript.txt"
    RESULT_setupLocal="${RESULT_genericProductsSetup}"
}

createMwsDefaultInstance(){
    logI "Creating MWS default instance"

    MWS_DB_URL="jdbc:mysql://${WMLAB_MYSQL_HOSTNAME}:3306/${WMLAB_MYSQL_DATABASE_NAME}?useSSL=false"

    JAVA_OPTS='-Ddb.type=mysqlce'

    JAVA_OPTS=${JAVA_OPTS}' -Ddb.url="'${MWS_DB_URL}'"'
    JAVA_OPTS=${JAVA_OPTS}' -Ddb.username="'${WMLAB_MYSQL_USER_NAME}'"'
    JAVA_OPTS=${JAVA_OPTS}' -Ddb.password="'${WMLAB_MYSQL_PASSWORD}'"'

    JAVA_OPTS=${JAVA_OPTS}' -Dnode.name='${WMLAB_MWS_HOSTNAME}
    #JAVA_OPTS=${JAVA_OPTS}' -Dserver.features=default'
    #JAVA_OPTS=${JAVA_OPTS}' -Dinstall.service=false'
    
    cmd="./mws.sh new ${JAVA_OPTS}"

    pushd . > /dev/null
    cd /opt/sag/products/MWS/bin
    controlledExec "${cmd}" "02-CreateDefaultInstance"
    popd > /dev/null
    RESULT_createInstance="${RESULT_controlledExec}"
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
        logI "Downloading database driver..."
        downloadCmd="curl -o "'"${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"'
        controlledExec "${downloadCmd}" "03-JDBCDriver-Download"

        if [ -f "${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" ]; then
            # ln -s ${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME} ${WMLAB_INSTALL_HOME}/MWS/lib/${WMLAB_JDBC_DRIVER_FILENAME}
            cp ${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME} ${WMLAB_INSTALL_HOME}/MWS/lib/${WMLAB_JDBC_DRIVER_FILENAME}
            logD "generating BND file"
            generateBndFile
            logI "Updating instance"
            pushd . > /dev/null
            cd "${WMLAB_INSTALL_HOME}/MWS/bin"
            controlledExec "./mws.sh update" "04-UpdateInstance"
            if [ ${RESULT_controlledExec} -eq 0 ]; then
                controlledExec "./mws.sh create-osgi-profile" "05-CreateOsgiProfile"
                logI "Update successful"
                RESULT_linkDatabase=0
            else
                logE "MWS default instance update failed! code ${RESULT_controlledExec}"
                RESULT_linkDatabase=3
            fi
            popd > /dev/null
        else
            logE "Database driver cannot be downloaded !"
            RESULT_linkDatabase=2
        fi
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
        pushd . > /dev/null
        cd "${WMLAB_INSTALL_HOME}/MWS/bin"
        controlledExec "./mws.sh init" "05-InitInstance"
        if [ "${RESULT_controlledExec}" -eq 0 ]; then
            RESULT_initializeMwsDefaultInstance=0
            logI "Init command successful"
        else
            RESULT_initializeMwsDefaultInstance=2
            logE "Init command failed (code ${RESULT_controlledExec})"
        fi
        popd > /dev/null
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
        takeInstallationSnapshot "Before MWS server Instance Creation"
        createMwsDefaultInstance
        takeInstallationSnapshot "After MWS server Instance Creation"
        if [ "${RESULT_createInstance}" -eq 0 ]; then
            initializeMwsDefaultInstance
            if [ "${RESULT_initializeMwsDefaultInstance}" -eq 0 ]; then
                logI "Setup successful"
            else
                logE "Initialize instance failed (code ${RESULT_initializeMwsDefaultInstance}), cannot continue!"
            fi
        else
            logE "Create instance failed (code ${RESULT_createInstance}), cannot continue!"
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