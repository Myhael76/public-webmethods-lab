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

- Set up the project
  - run 01.Setup.01.generateEnvFile.bat
  - optionally edit the generated .env file and set up the desired non default options
- Start up the database
  - run 01.Setup.02.startMySql.bat
- Initialize database
  - run 01.Setup.03.db.init.bat
  - wait for the job to finish (window will be closed)
  - (optional) run 02.Support.01.adminer.up.bat if you want to introspect the database contents
- Initialize MWS
  - run 01.Setup.04.mws.init.bat
  - wait for the setup to finish

## Steps for the initial configuration

Note: configurations stored in the database wil be maintained accross restarts. Project "clean" will destroy them.

- Start up the database
  - run 03.ProjectUp.01.db.start.bat
- Start Universal Messaging Realm Server
  - run 03.ProjectUp.02.um.start.bat
- Start MWS
  - run 03.ProjectUp.03.mws.start.bat. Wait for the MWS web server to come up
- Manually set the MWS cluster to point to nsp://umserver:9000
- Bounce MWS
  - run 05.ProjectDown.04.mws.stop.bat. Wait for the docker container to exit
  - run 03.ProjectUp.03.mws.start.bat. Wait for the MWS web server to come up (optimize logs are mounted from the run folder)
  - (optional) open an Enterprise Manager to nsp://localhost:40790 and you should see the relative com.webmethods channels that were created
    - for the moment there are some class not found exceptions, ignore them
- Startup Optimize analytic Engine
  - run 03.ProjectUp.04.o4p-ae.start.bat. Wait for the server to come up
  - (optional) open an Enterprise Manager to nsp://localhost:40790 and you should see the relative channels created
- Set up Optimize server o4p-ae-server (default port 12503) in the servers portlet and test it. The AE should be healthy at this point
- Startup ISPlus
  - run 03.ProjectUp.05.isplus.start.bat Wait for the serve to come up
  - In MWS servers portlet set "is-plus" as the ESB / IS server name. Save and check the server status and everything should be green


## Steps to stop the project 

Run all the 05.ProjectDown.*.bat commands in the provided order

## Steps to run the project 

Run all the 03.ProjectUp.*.bat commands in the provided order