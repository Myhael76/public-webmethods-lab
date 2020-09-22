#!/bin/sh

# Notes

# Create DB, storage and user example

# dbConfigurator.bat -a create -d sqlserver -c storage -v latest
#     -l jdbc:wm:sqlserver://DBserver:1433;databaseName=master -u webmuser -p w3bmpass
#     -au sa -ap sa_password -n webmdb

. /mnt/scripts/lib/common.sh

logI "Initializing database for webmethods products..."
logEnv
INIT_RESULT=0

if [ `portIsReachable ${WMLAB_SQLSERVER_HOSTNAME} 1433` ]; then

    DBC_DB_URL="jdbc:wm:sqlserver://${WMLAB_SQLSERVER_HOSTNAME}:1433;databaseName=${WMLAB_SQLSERVER_DATABASE_NAME}"
    DBC_DB_URL_M="jdbc:wm:sqlserver://${WMLAB_SQLSERVER_HOSTNAME}:1433;databaseName=master"
    logD "Computed database URL: ${DBC_DB_URL}"

    cd "${WMLAB_DBCC_INSTALL_HOME}/common/db/bin/"

    if [ $? -eq 0 ]; then
        logI "Creating the database, user and storage"

        ./dbConfigurator.sh \
            --action create \
            --dbms sqlserver \
            --component storage \
            --version latest \
            --url "${DBC_DB_URL_M}" \
            --user "${WMLAB_SQLSERVER_USER_NAME}" \
            --password "${WMLAB_SQLSERVER_PASSWORD}" \
            -au sa \
            -ap "${WMLAB_SQLSERVER_SA_PASSWORD}" \
            -n "${WMLAB_SQLSERVER_DATABASE_NAME}" \
            --printActions \
            > ${WMLAB_RUN_FOLDER}/db-01.storage-initialize.out \
            2> ${WMLAB_RUN_FOLDER}/db-01.storage-initialize.err
        
        logI "Creating database assets"
        ./dbConfigurator.sh \
            --action create \
            --dbms sqlserver \
            --component All \
            --version latest \
            --url "${DBC_DB_URL}" \
            --user "${WMLAB_SQLSERVER_USER_NAME}" \
            --password "${WMLAB_SQLSERVER_PASSWORD}" \
            --printActions \
            > ${WMLAB_RUN_FOLDER}/db-02.assets-initialize.out \
            2> ${WMLAB_RUN_FOLDER}/db-02.assets-initialize.err
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


