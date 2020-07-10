@echo off
SET ENTRY_POINT=/opt/softwareag/script/create-all.sh
docker-compose -f .\S02-alpine_dbcc_docker-compose.yml down