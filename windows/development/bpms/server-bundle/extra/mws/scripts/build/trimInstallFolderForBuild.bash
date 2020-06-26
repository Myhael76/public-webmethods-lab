#!/bin/bash


export SAG_HOME=/opt/softwareag

# remove obviously not used big files or subfolders from the folders in Dockerfile

rm -rf ${SAG_HOME}/jvm/jvm/src.zip
rm -rf ${SAG_HOME}/jvm/jvm*.bck

# some of these may be removed, but further analysis is needed
rm -rf ${SAG_HOME}/MWS/bin/migrate # we do not need to migrate anything

# we will not use derby
rm -rf ${SAG_HOME}/MWS/server/template-derby.zip

# note ${SAG_HOME}/MWS/server/template.zip is needed because we will create the instance in the container

