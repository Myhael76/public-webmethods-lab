@echo off

echo This will clean the mws installation! Continue?

pause

docker-compose -f .\04.01.docker-compose_mws_setup.yml down -v
