@echo off

docker-compose -f docker-compose_mws_setup.yml down -v

docker volume rm 02example405mws-on-mysqlce_mws-install-home 02example405mws-on-mysqlce_mws-sum-home 02example405mws-on-mysqlce_mws-temp

echo Check volumes

docker volume ls

pause