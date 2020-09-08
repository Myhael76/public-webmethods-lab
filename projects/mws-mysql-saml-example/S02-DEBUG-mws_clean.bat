@echo off

docker-compose -f docker-compose_mws_setup.yml down -v

docker volume rm mws-mysql-saml-example_mws-install-home mws-mysql-saml-example_mws-sum-home mws-mysql-saml-example_mws-temp

echo Check volumes

docker volume ls

pause