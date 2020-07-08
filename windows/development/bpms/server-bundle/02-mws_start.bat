@echo off

call .\set-env.bat

docker-compose -f .\02-mws_docker-compose.yml start

pause