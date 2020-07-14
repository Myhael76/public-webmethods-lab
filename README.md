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
- In case on of the Software AG images are to be produced, empwoer credentials able to download the products and fixes
- Valid product license files for, but depending on the actual use:
  - Integration Server for BPM (Microservices Runtime license works too) (Mandatory)
  - Business Rules (Mandatory)
  - Universal Messaging Realm Server (Mandatory)
  - Digital Event Services (DES)
  - MashZone Next Generation
  - Terracotta Big Memory
  - API MicroGateway
- Direct access to internet. In case you need a proxy follow the instructions in the dedicated chapter (TODO)

## Quick start

- Create a new "runs" folder (e.g. c:\yourPath\runs). Logs, run traces and snapshots will be put here during the runs. This folder will need periodical cleaning.
- Copy _public-webmethods-lab_\windows\common\config\set-env_example.ps1 to _public-webmethods-lab_\windows\common\config\set-env.ps1 and change all the necessary values according to your environment.
- Ensure that Docker Desktop allows the mounting of the run folder, installer, sum bootstrap, product and fix images, license files (Docker Desktop -> Settings -> Resources -> File Sharing)
- Ensure Docker Desktop has at least 6 GB of available RAM (Docker Desktop -> Settings -> Resources -> Memory)
- Prepare the installation helper image
  - Run _public-webmethods-lab_\windows\prepare\01-install-helper-up.bat
  - Wait for the image to be built
  - Verify you can have a shell on the opened container with
    - _public-webmethods-lab_\windows\build\os\centos-wm-install-helper\08-test-2-bash-in-existing-container.bat
  - Shutdown the container with
    - _public-webmethods-lab_\windows\build\os\centos-wm-install-helper\02-down.bat
- Prepare the Software AG OSGI Helper image
  - _public-webmethods-lab_\windows\prepare\02-sag-osgi-helper-up.bat
  - wait for the image to be built
  - Verify you can have a shell on the opened container with 
    - _public-webmethods-lab_\windows\build\os\centos-sag-osgi-helper\08-test-2-bash-in-existing-container.bat
  - Shutdown the container with
    - _public-webmethods-lab_\windows\build\os\centos-sag-osgi-helper\02-down.bat
- Prepare the database configuration docker image
  - Run _public-webmethods-lab_\windows\prepare\03-create-dbc-container.bat
- Startup the default project
  - Startup the database _public-webmethods-lab_\windows\development\projects\bpms1\01-mysql-01-up.bat
  - Optionally, admininster the database with _public-webmethods-lab_\windows\development\projects\bpms1\S01-adminer-01-up.bat
  - Initialize the database with _public-webmethods-lab_\windows\development\projects\bpms1\S02-alpine_dbcc_create-all.bat
  - Startup the bpms node with _public-webmethods-lab_\windows\development\projects\bpms1\02-bpmsNodeType1-01-up.bat
