@echo off

REM Parameters
REM %1 -> install folder to mount, it will preserve the installation result
REM 2% -> Software AG Installer
REM %3 -> Software AG Update Manager Bootstrap
REM %4 -> Product image
REM %5 -> workFolder for this session
REM %6 -> Business Rule License File
REM %7 -> mws scripts from the github server bundle

REM Change network accordingly if database needs to be reached

docker run -ti --rm^
 --entrypoint /bin/bash^
 --name mws-install^
 --hostname mws-install^
 --network="server-bundle_project_internal_network"^
 -v /var/run/docker.sock:/var/run/docker.sock^
 -v %2:/tmp/installer.bin^
 -v %3:/tmp/sum-boostrap.bin^
 -v %4:/tmp/product-image.zip^
 -v %5/:/work-folder/^
 -v %6:/tmp/br-license.xml^
 -v %7:/scripts/^
 my-centos7-docker

pause