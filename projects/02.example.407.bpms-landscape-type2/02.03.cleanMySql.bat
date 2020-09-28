@echo off
echo This will destroy the data hosted in the container's volume?
pause
docker-compose -f .\02.docker-compose_mysql.yml down -v