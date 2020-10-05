@echo off

echo This will clean the mws installation! Continue?

pause

docker-compose -f 04.03.docker-compose.mws.yml down -v
