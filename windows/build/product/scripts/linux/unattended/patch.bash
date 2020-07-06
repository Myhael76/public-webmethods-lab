#!/bin/bash

# This script installs the provided wm install script in /opt/softwareag 
# and patches it to the latest version in online mode
# No instance is created at install time
# Must have access to online Software AG fix servers
# TODO
# - does not consider proxy needs for the moment. Add subsequently if necessary
# Prerequisites
# - centos-wm-install-helper docker image must exist. build and test it before using this project, which uses the names defined there
# - the image declared in the set-env for the above project must contain all the products in the provided script


# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_MSR_START=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_MSR_START_PATH=$(dirname "$SCRIPT_MSR_START")

. ${SCRIPT_MSR_START_PATH}/assure-run-folder.bash

pushd .

cd ${RUN_FOLDER}

echo `date +%y-%m-%dT%H.%M.%S_%3N`" - Applying latest fixes ..."
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - Applying latest fixes ..." >> ${RUN_FOLDER}/script-trace.txt
cd /opt/sagsum/bin/

cat ${SCRIPT_MSR_START_PATH}/wm/fixes/online-against-install-folder.wmscript.txt > /dev/shm/fixes.wmscript.txt
cat /mnt/secret/empower-credentials-fixes.txt >> /dev/shm/fixes.wmscript.txt

./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt \
 > ${RUN_FOLDER}/03-patching.out \
 2> ${RUN_FOLDER}/03-patching.err 

rm /dev/shm/fixes.wmscript.txt

echo `date +%y-%m-%dT%H.%M.%S_%3N`" - Finished!"
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - Finished!" >> ${RUN_FOLDER}/script-trace.txt
popd .