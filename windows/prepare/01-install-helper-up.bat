@echo off

cd ..\build\os\centos-wm-install-helper

echo Starting up a default centos-wm-install-helper
echo Bring is down manually by calling ${PROJECT_HOME}\windows\build\os\centos-wm-install-helper\02.down.bat
echo ATTENTION: if you need to set up a proxy for centos-wm-install-helper, follow instructions on the Dockerfile
echo CTRL-C to interrupt

pause 

call .\01-up.bat
