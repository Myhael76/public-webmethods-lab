@echo off
set H_WMLAB_PRODUCTS_VERSION=1003
set H_WMLAB_PRODUCTS_IMAGE=f:\k\SAG\Images\Products\1003\LNX64_All_Products.zip
set H_WMLAB_INSTALL_SCRIPT_FILE=./scripts/1003/install.wmscript.txt 
docker-compose up
docker-compose down