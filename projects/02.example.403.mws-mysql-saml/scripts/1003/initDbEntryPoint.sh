#!/bin/sh

# import setup & framework functions
. ${WMLAB_SETUP_SHELL_LIB_DIR_MOUNT_POINT}/setupCommons.sh

logI "Initializing database for webmethods products..."
logEnv
INIT_RESULT=0

if [ `portIsReachable ${WMLAB_MYSQL_HOSTNAME} 3306` ]; then

    apk add --no-cache curl
    curl -o "${WMLAB_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"

    DBC_DB_URL="jdbc:mysql://${WMLAB_MYSQL_HOSTNAME}:3306/${WMLAB_MYSQL_DATABASE_NAME}?useSSL=false"
    logD "Computed database URL: ${DBC_DB_URL}"

    cd "${WMLAB_INSTALL_HOME}/common/db/bin/"

    echo 'CLASSPATH="$CLASSPATH:$DCI_HOME/../lib/ext/'"${WMLAB_JDBC_DRIVER_FILENAME}"'"' >> setEnv.sh

    if [ $? -eq 0 ]; then
        ./dbConfigurator.sh \
            --action create \
            --dbms mysqlc \
            --url "${DBC_DB_URL}" \
            --component All \
            --user "${WMLAB_MYSQL_USER_NAME}" \
            --password "${WMLAB_MYSQL_PASSWORD}" \
            --version latest \
            > ${WMLAB_RUN_FOLDER}/db-initialize.out \
            2> ${WMLAB_RUN_FOLDER}/db-initialize.err
        # TODO: Error check
        DBC_RESULT=$?
        if [ ${DBC_RESULT} -ne 0 ] ; then
            logE "Database initialization failed: ${DBC_RESULT}"
            INIT_RESULT=3
        else
            logI "database initialized successfully"
            INIT_RESULT=0
        fi
    else
         logE "Folder ${WMLAB_INSTALL_HOME}/common/db/bin/ not found"
         INIT_RESULT=2
    fi
else
    logE "Database is not reachable! Host ${WMLAB_MYSQL_HOSTNAME}; port ${WMLAB_DB_PORT}"
    INIT_RESULT=1
fi
exit ${INIT_RESULT}