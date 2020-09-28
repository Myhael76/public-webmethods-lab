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
|0|base config|license files|DONE|
|1|db|wmdb-mysql|TODO|
|2|adminer||TODO|
|3|mydbcc||TODO|
|4|um||TODO|
|5|mws||TODO|
|6|o4p-ae||TODO|
|7|is-plus||TODO|
|8|deployer||TODO|
|9|msr-sd-1||TODO|

## Prerequisites

Execute the following projects and their prerequisites first

