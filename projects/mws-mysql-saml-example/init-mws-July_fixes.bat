@echo off

set H_WMLAB_FIXES_ONLINE=0
set H_WMLAB_FIXES_IMAGE_FILE=f:\k\SAG\Images\Fixes\LNX64_All_10.5_2020-07-02.zip

docker-compose -f docker-compose_mws_setup.yml up

:: ensure cleaning

docker-compose -f docker-compose_mws_setup.yml down
