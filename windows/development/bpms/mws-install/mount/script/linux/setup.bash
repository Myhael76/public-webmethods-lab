#!/bin/bash

# This script installs MWS in /opt/softwareag with BPMS related UIs and patches it to the latest version in online mode
# No MWS instance is created at install time
# Must have access to onine Software AG fix servers
# TODO
# - does not consider proxy needs for the moment. Add subsequently if necessary
# Prerequisites
# - centos-wm-install-helper docker image must exist. build and test it before using this project, which uses the names defined there
# - the image declared in the set-env for the above project must contain all the products in wm/install.wmscript

CRT_INSTALL_DATE=`date +%y-%m-%dT%H.%M.%S`

RUN_FOLDER=/mnt/wm-install-mws-mount/runs/install_${CRT_INSTALL_DATE}

mkdir -p ${RUN_FOLDER}

pushd .

cd ${RUN_FOLDER}

###### 01 - install
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - 01 - Installing product ..."
/mnt/wm-install-files/installer.bin \
 -readScript /mnt/wm-install-mws-mount/script/linux/wm/install.wmscript \
 -debugLvl verbose \
 -debugFile ${RUN_FOLDER}/01-install.log \
 > ${RUN_FOLDER}/01-install.out \
 2> ${RUN_FOLDER}/01-install.err

###### 02 - boot spm
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - 02 - Bootstrapping SPM ..."

/mnt/wm-install-files/sum-bootstrap.bin --accept-license -d /opt/sagsum \
 > ${RUN_FOLDER}/02-sum-boot.out \
 2> ${RUN_FOLDER}/02-sum-boot.err

###### 03 - Patch installation
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - 03 - Applying latest fixes ..."
cd /opt/sagsum/bin/

cp /mnt/wm-install-mws-mount/script/linux/wm/fixes.wmscript.txt /dev/shm/fixes.wmscript.txt
cat /mnt/wm-install-base-mount/secret/empower-cred-fixes.txt >> /dev/shm/fixes.wmscript.txt

./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt \
 > ${RUN_FOLDER}/03-patching.out \
 2> ${RUN_FOLDER}/03-patching.err 

rm /dev/shm/fixes.wmscript.txt

echo `date +%y-%m-%dT%H.%M.%S_%3N`" - Finished!"
popd .