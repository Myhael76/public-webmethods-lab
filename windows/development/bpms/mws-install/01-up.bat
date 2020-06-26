@echo off

call .\..\..\containers\base\centos-wm-install-helper\set-env.bat
call .\set-env.bat

docker-compose up
