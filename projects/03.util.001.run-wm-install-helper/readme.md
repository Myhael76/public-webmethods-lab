# CentOS 7 based WebMethods Install Helper

This is an intermediate image for experimentation, manual build and for build automation, wherever this is necessary.

## Prerequisites

- Project 00.commons
- Project 01.build.000.commons
- A secret credentials file if patching is used online
- Docker must allow for the declared mounts in docker-compose.yml, configure it to allow mounting accordingly
- Edit the .env file and resolve all concrete host references to your files, these include
  - installation assets
  - patching assets
  - liecense files
- The .env contains general purpose assets. If not available or pertinent comment them out in .env and docker-compose.yml accordingly. Alternatively just mount duppy *existing* files
- Alternative "up" shortcuts are provided to show how to overwrite partially the .env variables

## Quick start

Execute in order:

- Create the image by calling the 01-up.bat command
- Test it by calling 08-test-2-bash-in-existing-container.bat
- Close the existing container by calling 02-down.bat
- Call 08-test-1-bash-in-new-container.bat to run an ad-hoc container linked to the host docker daemon

## Use cases

This project may be used to play around with installer, update manager in order to author installation and update scripts

Example on how to start the installer to author an installation script

```bash
. /mnt/scripts/lib/setup/setupCommons.sh
startInstallerInAttendedMode
```

At the end of the wizzard you will find the install script in the run folder.

Hint: at the wizzard step "The products listed below are ready to be saved to script .... and installed." check if the script file is created, notmally it is. Exitting at this point would skip the actual installation while still preserving the installation script.

Example on how to take snapshots

```bash
. /mnt/scripts/lib/setup/setupCommons.sh
export WMLAB_TAKE_SNAPHOTS=1
takeInstallationSnapshot snaphotName
```

Example of patch command

```bash
. /mnt/scripts/lib/setup/setupCommons.sh
bootstrapSum
patchInstallation
```