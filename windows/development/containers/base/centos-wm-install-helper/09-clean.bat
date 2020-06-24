call .\set-env.bat

./03-destroy.bat

echo ensure other projects based on centos-wm-install-helper image are down and cleaned 

pause

docker rmi centos-wm-install-helper

pause