#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_START=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_START_PATH=$(dirname "$SCRIPT_START")

pushd .

cd /opt/softwareag

cp ${SCRIPT_START_PATH}/Dockerfile .
cp ${SCRIPT_START_PATH}/entrypoint.bash .
cp ${SCRIPT_START_PATH}/set-instance-parameters.bash .

# need to provide the jdbc jar as a fragment for caf bundle
mkdir -p ./MWS/lib
cp -r ${SCRIPT_START_PATH}/lib/*.bnd ./MWS/lib/
cp -r ${SCRIPT_START_PATH}/lib/mysql*.jar ./MWS/lib/

 docker build -t mws-centos-7 .

popd