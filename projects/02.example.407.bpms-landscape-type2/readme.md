# BPMS Landscape type 1

## Objectives

This project provides an example of a consistent distributed BPMS landscape containing

- one MWS with Task Engine
- one Integration Server containint the Task Client, Process Runtime, Monitor etc. We call this "IS+"
- no other IS, but possibility to add if needed. These subsequent additions may contain PRT, Monitor, but not the referred task client (MWS can point to one only)
- one to many MSRs for service development
- one supporting MYSQLCE database (same schema for all functionalities)
- one supporting Universal Messaging (Central Users requires MWS clustering, which requires UM; also for messaging)
- one Deployer on MSR, also containing ABE
- one Optimize for Process ( Analystic Engine Only )
- one Adminer container for DB inspection
- one mydbcc container for DB initialization

Refer to the archi file for design details.

## Status

|Order|Runtime|Hostname|Status|
|-|-|-|-|
|01|base config, license files||DONE|
|02|db|wmdb-mysql|DONE|
|S01|adminer||DONE|
|S02|mydbcc||DONE|
|03|um|umserver|DONE|
|04|mws|mwsserver|DONE|
|05|o4p-ae|o4p-ae-server|WIP|
|06|is-plus||TODO|
|07|deployer||TODO|
|08|msr-sd-1||TODO|

## Prerequisites

Execute the following projects and their prerequisites first

- 01.build.001.wm-install-helper
- 01.build.002.generic-installation
- 01.build.003.mydbcc
- 01.build.004.um-realm-server
- 01.build.005.o4p-ae
- 01.build.007.ccs-tool-for-optimize

## Steps to set up the project

- Initialize database
  - run 02.01.startMySql.bat
  - (optional) run S01-adminer-01-up.bat is you want to introspect the database
  - run S02.init.01.db.bat
- Initialize MWS
  - run 04.01.01.mws.init.bat

## Steps to run the project 

- run 02.01.startMySql.bat
- run 03.01.startUM.bat
- run 04.02.01.mws.start.bat
  - manually set the cluster to point to nsp://umserver:9000
- run 05.01.o4p-ae.start.bat