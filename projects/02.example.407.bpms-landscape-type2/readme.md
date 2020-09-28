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
|S01|adminer||TODO|
|S02|mydbcc||TODO|
|03|um||TODO|
|04|mws||TODO|
|05|o4p-ae||TODO|
|06|is-plus||TODO|
|07|deployer||TODO|
|08|msr-sd-1||TODO|

## Prerequisites

Execute the following projects and their prerequisites first

