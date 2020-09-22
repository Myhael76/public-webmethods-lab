@echo off

set H_WMLAB_PRODUCTS_VERSION=1003

docker-compose -f docker-compose_mydbcc.yml up

:: ensure cleaning

docker-compose -f docker-compose_mydbcc.yml down
