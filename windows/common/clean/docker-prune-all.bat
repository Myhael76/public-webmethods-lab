@ echo off

echo This will remove all images, networks, containers and volumes not having active references! Ctrl-C to break, any key to continue.
pause
docker system prune -a -f --volumes
