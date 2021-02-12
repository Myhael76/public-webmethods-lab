#!/bin/sh

. /mnt/scripts/lib/common/common.sh

logI "Waiting for the realm server to come up"

p=`portIsReachable umserver 9000`

while [ $p -eq 0 ]; do
    logI "Sleep 5..."
    sleep 5
    p=`portIsReachable umserver 9000`
done

logI "UM is up, checking the local net connection factory"

cd /opt/sag/products/UniversalMessaging/tools/runner
./runUMTool.sh ViewConnectionFactory -rname=nsp://umserver:9000 -factoryname=local-net >/dev/null 2>&1

if [ $? -ne 0 ]; then
    logI "CreatingConnectionFactory local-net"
    ./runUMTool.sh CreateConnectionFactory -rname=nsp://umserver:9000 -factoryname=local-net -connectionurl=nsp://umserver:9000
else
    logI "Connection factory local-net exists"
fi


logI "Checking the external connection factory"
./runUMTool.sh ViewConnectionFactory -rname=nsp://umserver:9000 -factoryname=external >/dev/null 2>&1

if [ $? -ne 0 ]; then
    logI "CreatingConnectionFactory external"
    ./runUMTool.sh CreateConnectionFactory -rname=nsp://umserver:9000 -factoryname=external -connectionurl=nsp://host.docker.internal:41490
else
    logI "Connection factory external exists"
fi
