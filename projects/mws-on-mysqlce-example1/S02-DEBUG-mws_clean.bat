@echo off

docker-compose -f docker-compose_mws_setup.yml down -v

docker volume rm  mws-1005-mysql-p411_mws-install-home mws-1005-mysql-p411_mws-sum-home mws-1005-mysql-p411_mws-temp

echo Check volumes

docker volume ls

pause