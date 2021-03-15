#!/bin/sh

cp -f \
  /mnt/scripts/local/${WMLAB_PRODUCTS_VERSION}/tc-config.xml \
  ${WMLAB_INSTALL_HOME}/Terracotta/server/wrapper/conf/tc-config.xml

pushd .

cd ${WMLAB_INSTALL_HOME}/Terracotta/server/wrapper/bin/
./startup.sh

popd
