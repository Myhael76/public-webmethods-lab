#!/bin/bash

# 01 - Cleanup original folder

# TODO: optimize, for the moment I found this to be more appropriate than selecting contetn in Dockerfile

rm -rf /opt/softwareag/_documentation
rm -rf /opt/softwareag/bin
rm -rf /opt/softwareag/common/src
rm -rf /opt/softwareag/profiles/SPM         # not useful in docker
rm -rf /opt/softwareag/jvm/*.bck            # no backup needed
rm -rf /opt/softwareag/jvm/jvm/src.zip
rm -rf /opt/softwareag/jvm/jvm/demo
rm -rf /opt/softwareag/jvm/jvm/man
rm -rf /opt/softwareag/jvm/jvm/sample

find /opt/softwareag -type f -iname "*.pdf" -delete


# 02 - Copy the extra files 

unalias cp #it is aliased to cp -i
cp -r /mnt/wm-install-mws-mount/wms_extra_files/* /opt/softwareag/
cp /mnt/wm-install-base-libs/mysql-connector-java-8.0.15.jar /opt/softwareag/MWS/lib/
    
# TODO: Continue