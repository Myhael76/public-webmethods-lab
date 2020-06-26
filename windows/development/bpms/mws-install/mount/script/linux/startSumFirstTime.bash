#!/bin/bash

CRT_INSTALL_DATE=`date +%y-%m-%dT%H.%M.%S`

mkdir -p /mnt/wm-install-mws-mount/install_${CRT_INSTALL_DATE}
echo "Note file for script: " + /mnt/wm-install-mws-mount/install_${CRT_INSTALL_DATE}/fixes.wmscript
echo "Press any key ..."

read

pushd .
cd /opt/sagsum/bin/

./UpdateManagerCMD.sh

popd .