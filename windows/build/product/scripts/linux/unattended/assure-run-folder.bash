#!/bin/bash

if [[ ""${RUN_FOLDER} == "" ]]; then
	export RUN_FOLDER="/mnt/runs/run_"`date +%y-%m-%dT%H.%M.%S`
    mkdir -p ${RUN_FOLDER}
fi