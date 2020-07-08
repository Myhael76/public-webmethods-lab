@echo off

call .\set-env.bat

docker exec mws /opt/softwareag/profiles/MWS_default/bin/shutdown.sh

docker-compose -f .\02-mws_docker-compose.yml down -v

pause