@echo off
SET ENTRY_POINT=/opt/softwareag/script/create-all.sh
docker-compose -f .\alpine_dbcc_docker-compose.yml down