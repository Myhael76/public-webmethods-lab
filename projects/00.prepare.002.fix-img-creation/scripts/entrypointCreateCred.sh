#!/bin/sh

# import framework functions
. /mnt/scripts/lib/common/common.sh


logI "Boostrapping SUM"
bootstrapSum

logI "Launching SUM. Please follow procedure to create credentials"

logI "Open a new shell and execute the following commands:"
logI "cd /opt/sag/sum/bin"
logI "./UpdateManagerCMD.sh"

logI "Suspending execution ..."
tail -f /dev/null