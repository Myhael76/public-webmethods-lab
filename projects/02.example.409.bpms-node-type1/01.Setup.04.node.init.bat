@echo off

docker-compose -f .\docker-compose_bpms-node-type1-setup.yml up

pause 
:: ensure cleaning

docker-compose -f .\docker-compose_bpms-node-type1-setup.yml down
