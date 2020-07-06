# CentOS 7 based WebMethods Install Helper

This is an intermediate image for experimentation, manual build and for build automation, wherever this is necessary.

## Prerequisites

Docker must allow for the declared mounts in docker-compose.yml, configure it to allow mounting of:

- all paths in set-env.ps1

## Quick start

Execute in order:

- Create the image by calling the 01-up.bat command
- Test it by calling 08-test-02.bat
- Close the existing container by calling 02-down.bat
- Call 08-test-01.bat to run an ad-hoc container linked to the host docker daemon
