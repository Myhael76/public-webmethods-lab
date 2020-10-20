@echo off

echo This will clean the node installation! Continue?

pause

docker-compose -f .\docker-compose_bpms-node-type1.yml down -v
