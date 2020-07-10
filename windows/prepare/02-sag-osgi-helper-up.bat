@echo off

cd ..\build\os\centos-sag-osgi-helper

echo Starting up a default centos-sag-osgi-helper
echo Bring is down manually by calling ${PROJECT_HOME}\windows\build\os\centos-sag-osgi-helper\02.down.bat
echo ATTENTION: if you need to set up a proxy for centos-sag-osgi-helper, follow instructions on the Dockerfile
echo CTRL-C to interrupt

pause 

call .\01-up.bat
