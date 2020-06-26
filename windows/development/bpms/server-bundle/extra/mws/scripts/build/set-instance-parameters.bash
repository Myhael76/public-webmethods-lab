#!/bin/bash

######################################  Locals
RED='\033[0;31m'
NC='\033[0m' 				  	# No Color
Green="\033[0;32m"        		# Green
Cyan="\033[0;36m"         		# Cyan

######################################  Parameters with defaults for local BPMS development

echo -e "${Cyan}Setting environment for MWS instance creation"

if [[ ""${MWS_DB_TYPE} == "" ]]; then
    export MWS_DB_TYPE="mysqlce"
fi
echo -e "${Green}MWS_DB_TYPE=${NC}"${MWS_DB_TYPE}


if [[ ""${MWS_DB_URL} == "" ]]; then
    export MWS_DB_URL="jdbc:mysql://mysql:3306/webmethods?useSSL=false"
fi
echo -e "${Green}MWS_DB_URL=${NC}"${MWS_DB_URL}

if [[ ""${MWS_DB_USERNAME} == "" ]]; then
    export MWS_DB_USERNAME="webmethods"
fi
echo -e "${Green}MWS_DB_USERNAME=${NC}"${MWS_DB_USERNAME}

if [[ ""${MWS_DB_PASSWORD} == "" ]]; then
    export MWS_DB_PASSWORD="webmethods"
fi
#echo -e "${Green}MWS_DB_PASSWORD=${NC}"${MWS_DB_PASSWORD}

if [[ ""${MWS_NODE_NAME} == "" ]]; then
    export MWS_NODE_NAME="localhost"
fi
echo -e "${Green}MWS_NODE_NAME=${NC}"${MWS_NODE_NAME}