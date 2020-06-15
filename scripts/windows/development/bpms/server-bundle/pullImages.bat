@echo off

docker pull alpine
docker pull adminer
docker pull mysql/mysql-server:5.7
docker pull store/softwareag/universalmessaging-server:10.5

:: will need PS acccess
docker pull dib.eur.ad.sag:5000/wm-dcc:10.5
