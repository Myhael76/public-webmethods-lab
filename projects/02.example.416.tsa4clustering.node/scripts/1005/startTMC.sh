#!/bin/sh

CRT_DATE=`date +%y-%m-%dT%H.%M.%S_%3N`
TMC_RUN_FOLDER=${TMC_RUN_FOLDER:-"/tmp/${CRT_DATE}"}
mkdir -p "${TMC_RUN_FOLDER}"

pushd .
cd "${TMC_RUN_FOLDER}"
nohup /opt/sag/products/Terracotta/tools/management-console/bin/start-tmc.sh &

