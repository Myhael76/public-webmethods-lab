@echo off

:: change this according to your run env

docker run -ti --entrypoint=/bin/bash^
 --network=server-bundle_project_internal_network^
 -v e:\r\pub\gh\my\public-webmethods-lab\windows:/mnt/project-home^
 centos:7

echo Centos Start debug finished!
pause