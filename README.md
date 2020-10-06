# public-webmethods-lab

This project groups a series of scripted tools and code examples useful in some typical webMethods development and operation scenarios.

These are personal assets, offered to the public as starting points in case of need and are not related in any way to Software AG official support.

The users may fork this repository and LGPL 3.0 apply, in particular the modified code must be public as well.

The subdirectories contain dedicate readme files according to the pertinent use case.

## Prerequisites

In order to use this project you will need the following

- Windows 10 Laptop on AMD64 CPU architecture (x86-64) (2004 minimum in case of Windows Home)
- Docker Desktop 2.3.x or newer
- Local Software AG developer installation containing
  - Designer for BPM (no "local development" needed)
  - Universal Messaaging Enterprise Manager
- Latest Software AG installer for Linux 64 (tested with SoftwareAGInstaller20191216-LinuxX86.bin)
- Latest Software AG Update Manager Bootstrap version 11 for Linux 64 (tested with SoftwareAGUpdateManagerInstaller20200214-LinuxX86.bin)
- Latest Software AG Update Manager Bootstrap version 10 for Linux 64 (tested with SoftwareAGUpdateManagerInstaller20200214-LinuxX86.bin)
- Product Software AG image - you may use the installer helper to produce one eventually
- Fixes Software AG image - you may use the installer helper to produce one eventually
- In case on of the Software AG images are to be produced, empower credentials able to download the products and fixes
- Valid product license files for, but depending on the actual use:
  - Integration Server for BPM (Microservices Runtime license works too) (Mandatory)
  - Business Rules (Mandatory)
  - Universal Messaging Realm Server (Mandatory)
  - Digital Event Services (DES)
  - MashZone Next Generation
  - Terracotta Big Memory
  - API MicroGateway
- Direct access to internet from the containers. In case a proxy is needed to access internet, configure it on the Docker Desktop properties.
- All paths that will be provided in the .env files must not contain spaces or special chars.
- Powershell v5.1 or later is required for guided generation of .env files where this is available

## Quick start

The following projects must be built upfront as they are a prerequisite for many others

- execute initial project setup
  - run generateEnv.bat in folder 00.commons
  - eventually change the produced .env file in folder 00.commons according to your environment and/or preferences
  - run generateEnvInstallCommons.bat in folder 01.build.000.commons
  - eventually change the produced .env file in folder 01.build.000.commons according to your environment and/or preferences
- project 01.build.001.wm-install-helper - centos-wm-install-helper
  - run build.bat in folder 01.build.001.wm-install-helper
- project 01.build.002.generic-installation - wm-generic-host
  - run build.bat in folder 01.build.002.generic-installation
- project 01.build.003.mydbcc - dbcc-builder
  - this project builds a container image having the database configurator
  - playing around with webMethods requires a database as a prerequisite. The built container will help with the database initialization
  - optionally run generateEnv.bat and change the resulting .env file according to your preferences
  - run build.bat. If the .env file does not exist, build.bat will call generateEnv.bat and will generate a default .env file
  - build command variations are provided as example
  - Note: the build of this container is not done by docker, therefore do not attempt a "docker-compose build". Use the provided commands as in the windows .bat files
- each project is built to be used independently. Follow the readmes of each project.
- try out database preparation projects
  - project 02.example.401.mysqlce-for-wm
  - sqlserver-for-wm-example

## Common use cases

### Refreshing the image for database configurator

If your database configurator falls behind with respect to fixes you will need to update it to the latest version. 

Just run the build command in the dbcc-builder project with the apropriate parameters

### Authoring new install scripts

Each project will host its own scripts. In order to generate new projects you will need to prepare new installation scripts.

The project centos-wm-install-helper has been preconfigured for this.

Change the envronment as appropriate for your use case, run the project with "up", geta shell and inside the shell

```bash
. /mnt/scripts/lib/common.sh
startInstallerInAttendedMode
```

Run through the installer as you need. After selecting all the needed components and required installation options you will have the script in the run folder.
Exit installer immedately after the file creation moment, before the actual installation if you don't wnat to install in this moment. Optionally installation may take place, it will be lost with the first container restart.
