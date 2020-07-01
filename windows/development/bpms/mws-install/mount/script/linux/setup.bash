#!/bin/bash

CRT_INSTALL_DATE=`date +%y-%m-%dT%H.%M.%S`

RUN_FOLDER=/mnt/wm-install-mws-mount/runs/install_${CRT_INSTALL_DATE}

mkdir -p ${RUN_FOLDER}

pushd .

cd ${RUN_FOLDER}

###### 01 - install

/mnt/wm-install-files/installer.bin \
 -readScript /mnt/wm-install-mws-mount/script/linux/wm/install.wmscript \
 -debugLvl verbose \
 -debugFile ${RUN_FOLDER}/01-install.log \
 > ${RUN_FOLDER}/01-install.out \
 2> ${RUN_FOLDER}/01-install.err

###### 02 - boot spm

/mnt/wm-install-files/sum-bootstrap.bin --accept-license -d /opt/sagsum \
 > ${RUN_FOLDER}/02-sum-boot.out \
 2> ${RUN_FOLDER}/02-sum-boot.err
 
###### 03 - copy files

cp /mnt/wm-install-base-libs/mysql*.jar /opt/softwareag/MWS/lib/
cp /mnt/wm-install-mws-mount/lib/* /opt/softwareag/MWS/lib/

###### 04 - Patch installation
 
cd /opt/sagsum/bin/

cp /mnt/wm-install-mws-mount/script/linux/wm/fixes.wmscript.txt /dev/shm/fixes.wmscript.txt
cat /mnt/wm-install-base-mount/secret/empower-cred-fixes.txt >> /dev/shm/fixes.wmscript.txt

./UpdateManagerCMD.sh -readScript /dev/shm/fixes.wmscript.txt \
 > ${RUN_FOLDER}/04-patching.out \
 2> ${RUN_FOLDER}/04-patching.err 

rm /dev/shm/fixes.wmscript.txt

popd .