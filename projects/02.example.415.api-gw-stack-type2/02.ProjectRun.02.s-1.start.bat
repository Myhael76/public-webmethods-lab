@echo off

SET H_WMLAB_APIGW_HOSTNAME=s-1

docker-compose -f 04.ProjectStructure.run.%H_WMLAB_APIGW_HOSTNAME%.docker-compose.yml up -d
