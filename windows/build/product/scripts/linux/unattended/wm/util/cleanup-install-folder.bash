#!/bin/bash

# TODO: optimize, for the moment I found this to be more appropriate than selecting content in Dockerfile

pushd .

cd /opt/softwareag/profiles/SPM/bin

./shutdown.sh

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

# Special, to analyze further
rm -rf /opt/softwareag/MWS/server/template-derby.zip

popd