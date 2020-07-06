#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT_MSR_START=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPT_MSR_START_TPATH=$(dirname "$SCRIPT_MSR_START")

. ./assure-run-folder.bash

echo `date +%y-%m-%dT%H.%M.%S_%3N`" - bootstrap spm ..."
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - bootstrap spm ..." >> ${RUN_FOLDER}/script-trace.txt

/mnt/wm-install-files/sum-bootstrap.bin --accept-license -d /opt/sagsum \
 >${RUN_FOLDER}/bootstrap-sum.out 2>${RUN_FOLDER}/bootstrap-sum.err

echo `date +%y-%m-%dT%H.%M.%S_%3N`" - spm boostrap complete" >> ${RUN_FOLDER}/script-trace.txt
echo `date +%y-%m-%dT%H.%M.%S_%3N`" - spm boostrap complete" 