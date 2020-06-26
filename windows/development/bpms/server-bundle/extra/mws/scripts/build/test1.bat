docker run --rm -ti --entrypoint="/bin/bash"^
 --network="server-bundle_project_internal_network"^
 -v e:\docker-mounts\data\WMSConfig\myConf1\conf\:/opt/softwareag/common/conf/^
 -v e:\r\pub\gh\my\public-webmethods-lab\scripts\windows\development\bpms\server-bundle\extra\lib\mysql-connector-java-8.0.15.jar:/opt/softwareag/common/lib/ext/mysql-connector-java-8.0.15.jar^
 mws-centos-7
