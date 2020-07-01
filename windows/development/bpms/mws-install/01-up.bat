@echo off

:: Base project environment
call .\..\..\containers\base\centos-wm-install-helper\set-env.bat

:: Current project environment
call .\set-env.bat

docker-compose up
