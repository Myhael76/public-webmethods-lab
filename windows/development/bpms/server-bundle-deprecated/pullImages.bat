@echo off

docker pull alpine
docker pull adminer
docker pull mysql/mysql-server:5.7
docker pull store/softwareag/universalmessaging-server:10.5

:: will need PS acccess
:: docker pull dib.eur.ad.sag:5000/wm-dcc:10.5

:: alternatively, with myhael76 private repo access
:: docker pull myhael76/my-private-free-repo:mydbcc100501
:: docker tag myhael76/my-private-free-repo:mydbcc100501 mydbcc:10.5