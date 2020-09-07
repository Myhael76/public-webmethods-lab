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
- Latest Software AG Update Manage Bootstrap for Linux 64 (tested with SoftwareAGUpdateManagerInstaller20200214-LinuxX86.bin)
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

## Quick start

The following projects must be built upfront as they are a prerequisite for many others

- centos-wm-install-helper
  - we use this as a helper for installations, both for installation script authoring and for installations made during build automation
  - execute the build command in the project folder
- centos-wm-generic-installation
  - this project prepares a base image to be used accross various dynamic installations
  - run the build command from the folder
- dbcc-builder
  - this project builds a container image having the database configurator
  - playing around with webMEthods requires a database as a prerequisite. The built container will help with the database initialization
  - change the .env file and provide all the necessary host paths (installer, product image, update manager bootstrap, fixes image etc)
  - execute the build command in the project folder
  - build command variations are provided as example
  - Note: the build of this container is not done by docker, therefore do not attempt a "docker-compose build". Use the provided commands as in the windows .bat files
- try out database preparation projects
  - mysqlce-for-wm-example
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
