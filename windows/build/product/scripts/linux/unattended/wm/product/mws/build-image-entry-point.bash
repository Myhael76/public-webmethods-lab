#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_START=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_START_PATH=$(dirname "$SCRIPT_START")

RED='\033[0;31m'
NC='\033[0m' 				  	# No Color
Green="\033[0;32m"        		# Green
Cyan="\033[0;36m"         		# Cyan

LOG_TOKEN="${Cyan}BUILD_MWS_DOCKER_IMAGE${NC}"

. ${SCRIPT_START_PATH}/../../../assure-run-folder.bash

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - setup products ..."
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - setup products ..." >> ${RUN_FOLDER}/script-trace.txt

${SCRIPT_START_PATH}/../../../setup.bash ${SCRIPT_START_PATH}/bpm-set-1.wmscript.txt

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - setup complete"
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - setup complete" >> ${RUN_FOLDER}/script-trace.txt

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - taking installation snapshot ..."
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - taking installation snapshot ..." >> ${RUN_FOLDER}/script-trace.txt

mkdir -p ${RUN_FOLDER}/snapshot/after-install/opt
cp -r /opt/softwareag ${RUN_FOLDER}/snapshot/after-install/opt

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - cleaning up install folder ..."
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - cleaning up install folder ..." >> ${RUN_FOLDER}/script-trace.txt

${SCRIPT_START_PATH}/../../util/cleanup-install-folder.bash \
 > ${RUN_FOLDER}/install-folder-cleanup.out 2> ${RUN_FOLDER}/install-folder-cleanup.err 

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - install folder cleaned"
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - install folder cleaned" >> ${RUN_FOLDER}/script-trace.txt

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - building image ..."
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - building image ..." >> ${RUN_FOLDER}/script-trace.txt

cp ${SCRIPT_START_PATH}/Dockerfile /opt/softwareag
cp ${SCRIPT_START_PATH}/entrypoint.bash /opt/softwareag
cp ${SCRIPT_START_PATH}/set-instance-parameters.bash /opt/softwareag

cd /opt/softwareag
docker build -t "wm-mws-for-bpm" . \
 > ${RUN_FOLDER}/docker-build.out 2> ${RUN_FOLDER}/docker-build.err 

echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" - ${LOG_TOKEN} - image built"
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - image built" >> ${RUN_FOLDER}/script-trace.txt