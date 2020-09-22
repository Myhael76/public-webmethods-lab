@echo off
echo This will destroy the data hosted in the container's volume?
pause
docker-compose -f .\docker-compose_mysql.yml down -v