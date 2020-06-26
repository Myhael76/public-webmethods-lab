# How to install MWS in a docker container

## Prerequisites

### Prepare a docker container image with Centos 7 and docker

- name/tag this image as my-centos7-docker

### Download necessary Software AG tools

- installer for Windows and Linux
- update manager boostrap for Linux

### Prepare a product image (zip file) with the necessary products

- use Software AG Installer to select MWS and MWS UI
- may leave out Broker UI and Fix module for 7.2

### Procure the necessary Licenses

MWS itself does not require a license file, but the Business Rules engine does

## Stept to obtain the container

### Install for the first time

- Alter the file start-container-for-first-install-config-1.bat to point to your local assets. Create a work folder for your run and change the related parameter.
- Launch start-container-for-first-install-config-1.bat
- Inside the container execute the following to install MWS

```bash
cd /scripts
./install-start-for-script-creation.bash
```

- Follow the instructions making certain to:
  - choose localhost as hostname
  - toggle off "use command central"
  - toggle off "create instance"
  - license file for Business Rules is /tmp/br-license.xml (see the related mount in docker-start-for-installation.bat eventually)
- Optionally, after the installation you may take a snapshot of the installation folder for future analysis. The installation folder is mounted, so you mway observe it from the host as well. On the work folder two new files can be observed:
  - wmInstallScript.txt that may be reused in future unattended installations. One file is already provided in the GitHub repository for the next steps
  - installDebug.log - a detailed log of the installation. We expect the tocken "APP_ERROR" to be present only once

```bash
grep APP_ERROR /work-folder/installDebug.log | wc -l
1
```

- Boostrap Update Manager as follows

```bash
cd /scripts
./bootstrap-sum.bash
```

- Apply latest fixes

```bash
cd /scripts
./start-sum-for-patching.bash
```

Note: there is no current supported programmatic way to apply latext fixes.

Follow the instreuctions from the tool with the following properties:

- go online, provide your empower username and password when asked (details only if needed)
- apply ALL latest fixes directly from Empower for product directory /opt/softwareag
- create script for future reference in /work-folder/wmPatchScript.txt

### Install subsequently

This aspect is not covered here as our purpose is to reuse the container image, not the installation script. If needed, use the scripts created above.

TODO: put scripts in source control. This operation will maybe done in the future when fixes may be applied programmatically as well, for not the value of doing so is minimal.

