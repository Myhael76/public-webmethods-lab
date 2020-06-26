#!/bin/bash

/tmp/installer.bin -console \
 -installDir /opt/softwareag \
 -debugLvl verbose \
 -debugFile /work-folder/installDebug.log \
 -writeScript /work-folder/wmInstallScript.txt \
 -readImage /tmp/product-image.zip