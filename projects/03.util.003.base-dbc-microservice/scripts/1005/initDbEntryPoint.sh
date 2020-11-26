#!/bin/sh

# Notes

# Create DB, storage and user example

# dbConfigurator.bat -a create -d sqlserver -c storage -v latest
#     -l jdbc:wm:sqlserver://DBserver:1433;databaseName=master -u webmuser -p w3bmpass
#     -au sa -ap sa_password -n webmdb

# import framework functions
. ${WMLAB_COMMON_SHELL_LIB_DIR_MOUNT_POINT}/common.sh

logI "Initializing database for webmethods products..."
logEnv
INIT_RESULT=0

if [ `portIsReachable ${WMLAB_SQLSERVER_HOSTNAME} ${WMLAB_DB_PORT}` ]; then

    if [[ "${WMLAB_DB_TYPE}" == "sqlserver"]]; then
        DBC_DB_URL="jdbc:wm:sqlserver://${WMLAB_DB_HOSTNAME}:${WMLAB_DB_PORT};databaseName=${WMLAB_DB_DATABASE_NAME}"
        DBC_DB_URL_M="jdbc:wm:sqlserver://${WMLAB_DB_HOSTNAME}:${WMLAB_DB_PORT};databaseName=master"
    fi
    logD "Computed database URL: ${DBC_DB_URL}"

    cd "${WMLAB_INSTALL_HOME}/common/db/bin/"

    if [ $? -eq 0 ]; then

        if [[ "${WMLAB_DB_TYPE}" == "sqlserver"]]; then

            # This script assumes database itself ("storage") must be created as well
            # TODO: check if this may become a "switch"

            logI "Creating the database, user and storage"

            ./dbConfigurator.sh \
                --action      create \
                --dbms        sqlserver \
                --component   storage \
                --version     latest \
                --url         "${DBC_DB_URL_M}" \
                --user        "${WMLAB_DB_USER_NAME}" \
                --password    "${WMLAB_DB_PASSWORD}" \
                -au           "${WMLAB_DB_ADMIN_USER_NAME}" \
                -ap           "${WMLAB_DB_ADMIN_USER_NAME}" \
                -n            "${WMLAB_DB_ADMIN_PASSWORD}" \
                --printActions \
                > ${WMLAB_RUN_FOLDER}/db-01.storage-initialize.out \
                2> ${WMLAB_RUN_FOLDER}/db-01.storage-initialize.err

            DBC_RESULT=$?
            if [ ${DBC_RESULT} -ne 0 ] ; then
                logE "Database initialization failed: ${DBC_RESULT}"
                INIT_RESULT=4
            else
                logI "Creating database assets"
                ./dbConfigurator.sh \
                    --action    create \
                    --dbms      sqlserver \
                    --component All \
                    --version   latest \
                    --url       "${DBC_DB_URL}" \
                    --user      "${WMLAB_DB_USER_NAME}" \
                    --password  "${WMLAB_DB_PASSWORD}" \
                    --printActions \
                    > ${WMLAB_RUN_FOLDER}/db-02.assets-initialize.out \
                    2> ${WMLAB_RUN_FOLDER}/db-02.assets-initialize.err
                # TODO: Error check
                DBC_RESULT=$?
                if [ ${DBC_RESULT} -ne 0 ] ; then
                    logE "Database initialization failed: ${DBC_RESULT}"
                    INIT_RESULT=5
                else
                    logI "database initialized successfully"
                    INIT_RESULT=0
                fi
            fi
        else
            logI "Database type not supported by WMLAB: ${WMLAB_DB_TYPE}"
            INIT_RESULT=3
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


