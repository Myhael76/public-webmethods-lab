@echo off

:: call .\set-env.bat

docker exec mws /opt/sag/products/profiles/MWS_default/bin/shutdown.sh

:: do not issue stop is you want a clean shutdown and the snapshot
:: docker-compose -f .\02-mws_docker-compose.yml stop

:: pause