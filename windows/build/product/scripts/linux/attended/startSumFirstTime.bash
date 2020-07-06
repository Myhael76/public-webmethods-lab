#!/bin/bash

CRT_INSTALL_DATE=`date +%y-%m-%dT%H.%M.%S`

mkdir -p /mnt/runs/install_${CRT_INSTALL_DATE}
echo "Note file for script: " + /mnt/runs/install_${CRT_INSTALL_DATE}/fixes.wmscript
echo "Press any key ..."

read

pushd .
cd /opt/sagsum/bin/

./UpdateManagerCMD.sh

popd .