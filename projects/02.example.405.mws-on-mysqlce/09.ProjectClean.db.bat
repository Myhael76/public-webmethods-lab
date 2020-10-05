@echo off
echo This will destroy the data hosted in the container's volume?
pause
docker-compose -f .\04.ProjectStructure.db.run.docker-compose.yml down -v