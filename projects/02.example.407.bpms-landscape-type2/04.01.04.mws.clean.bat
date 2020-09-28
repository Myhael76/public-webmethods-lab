@echo off

echo This will clean the mws installation! Continue?

pause

docker-compose -f .\03.01.docker-compose_mws_setup.yml down -v
