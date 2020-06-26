#!/bin/bash

CRT_INSTALL_DATE=`date +%y-%m-%dT%H.%M.%S`

mkdir -p /mnt/wm-install-mws-mount/install_${CRT_INSTALL_DATE}

pushd .

cd /mnt/wm-install-mws-mount/install_${CRT_INSTALL_DATE}

/mnt/wm-install-files/installer.bin -console \
 -installDir /opt/softwareag \
 -writeScript /mnt/wm-install-mws-mount/install_${CRT_INSTALL_DATE}/thisInstallation.wmscript \
 -readImage /mnt/wm-install-files/products.zip \
 -debugLvl verbose \
 -debugFile /mnt/wm-install-mws-mount/install_${CRT_INSTALL_DATE}/thisInstallation.log

 popd .