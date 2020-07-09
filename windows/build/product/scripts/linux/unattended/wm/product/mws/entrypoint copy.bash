#!/bin/bash

# check if instance exists
# if instance does not exist, create it with configured parameters
# the instance folder should be a persistent volume mount

if [ ! -d "/opt/softwareag/MWS/server/default/bin" ]; then
    echo "Instance does not exist, creating ..."
    . /opt/softwareag/set-instance-parameters.bash
    JAVA_OPTS='-Ddb.type='${MWS_DB_TYPE}

    JAVA_OPTS=${JAVA_OPTS}' -Ddb.url="'${MWS_DB_URL}'"'
    JAVA_OPTS=${JAVA_OPTS}' -Ddb.username="'${MWS_DB_USERNAME}'"'
    JAVA_OPTS=${JAVA_OPTS}' -Ddb.password="'${MWS_DB_PASSWORD}'"'

    JAVA_OPTS=${JAVA_OPTS}' -Dnode.name='${MWS_NODE_NAME}
    JAVA_OPTS=${JAVA_OPTS}' -Dserver.features=default'
    JAVA_OPTS=${JAVA_OPTS}' -Dinstall.service=false'

    echo "JAVA_OPTS: ${JAVA_OPTS}"
    # To analyze further
    #JAVA_OPTS=${JAVA_OPTS}' -DjndiProviderUrl="'${}'"'
    #JAVA_OPTS=${JAVA_OPTS}' -Ddb.driver="'${}'"'

    pushd .

    cd /opt/softwareag/MWS/bin
    ./mws.sh new ${JAVA_OPTS}
    echo "----> instance default created"
    ./mws.sh init
    echo "----> instance default initialized"
    popd
fi

echo "----> instance default starting ..."
cd /opt/softwareag/MWS/bin
./mws.sh start