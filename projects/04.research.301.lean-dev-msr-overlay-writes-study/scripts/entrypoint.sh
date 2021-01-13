#!/bin/sh

mkdir -p /mnt/scripts/snaphot1
cp -r /opt/sag/products /mnt/scripts/snaphot1/

cd /opt/sag/products/IntegrationServer/bin/

./server.sh -log none
