@echo off

:: change this according to your run env

docker run -ti --entrypoint=/bin/bash^
 --network=server-bundle_project_internal_network^
 -v e:\r\pub\gh\my\public-webmethods-lab\windows\development\bpms\server-bundle\extra\mws\bnd\mysql-connector-java-8.0.15.bnd:/opt/softwareag/MWS/lib/mysql-connector-java-8.0.15.bnd^
 -v e:\r\pub\gh\my\public-webmethods-lab\windows\common\lib\ext\mysql-connector-java-8.0.15.jar:/opt/softwareag/MWS/lib/mysql-connector-java-8.0.15.jar^
 -v e:\r\pub\gh\my\public-webmethods-lab\windows:/mnt/project-home^
 -p 8585:8585^
 wm-mws-for-bpm

echo MWS Start debug finished!
pause