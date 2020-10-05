#!/bin/sh

    #   - WMLAB_DB_HOST_NAME=${H_WMLAB_DB_HOSTNAME}
    #   - WMLAB_DB_PORT=3306
    #   - WMLAB_DB_USER_NAME=${H_WMLAB_MYSQL_USER_NAME}
    #   - WMLAB_MYSQL_PASSWORD=${H_WMLAB_MYSQL_PASSWORD}

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

logI "Initializing database for webmethods products..."
logEnv
INIT_RESULT=0

if [ `portIsReachable ${WMLAB_DB_HOST_NAME} ${WMLAB_DB_PORT}` ]; then

    apk add --no-cache curl
    curl -o "${WMLAB_DBCC_INSTALL_HOME}/common/lib/ext/${WMLAB_JDBC_DRIVER_FILENAME}" "${WMLAB_JDBC_DRIVER_URL}"

    DBC_DB_URL="jdbc:mysql://${WMLAB_DB_HOST_NAME}:${WMLAB_DB_PORT}/${WMLAB_MYSQL_DATABASE_NAME}?useSSL=false"
    logD "Computed database URL: ${DBC_DB_URL}"

    cd "${WMLAB_DBCC_INSTALL_HOME}/common/db/bin/"

    if [ $? -eq 0 ]; then
        ./dbConfigurator.sh \
            --action create \
            --dbms mysqlce \
            --url "${DBC_DB_URL}" \
            --component All \
            --user "${WMLAB_MYSQL_USER_NAME}" \
            --password "${WMLAB_MYSQL_PASSWORD}" \
            --version latest \
            --printActions \
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
         logE "Folder ${WMLAB_DBCC_INSTALL_HOME}/common/db/bin/ not found"
         INIT_RESULT=2
    fi
else
    logE "Database is not reachable! Host ${WMLAB_DB_HOST_NAME}; port ${WMLAB_DB_PORT}"
    INIT_RESULT=1
fi

exit ${INIT_RESULT}