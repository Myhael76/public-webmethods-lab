@echo off
echo This will destroy the data hosted in the container's volume?
pause
docker-compose -f .\04.01.docker-compose.db.yml down -v