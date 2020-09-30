# CentOS 7 based WebMethods Install Helper

This is an intermediate image for experimentation, manual build and for build automation, wherever this is necessary.

## Prerequisites

- Project unixShellLib
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
