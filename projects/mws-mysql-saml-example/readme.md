# MWS on MySQL Community Edition with SAML Example

## Prerequisites

- mydbcc-${VERSION} container imagess must exist. Use the dcc-builder project to obtain them
- wm-generic-installation container image must exist.
- unixShellLib project is also a dependency
- all host paths in .env must point to their valid correspondent files (products image, fixes, installer, licenses etc)

## Quickstart

### Build the container image centos-wm-install-helper

- go to folder centos-wm-install-helper
- set all host paths in .env (now f:\something)
- run the "build.bat" in the project folder

### Build the container image centos-wm-generic-installation

- go to folder centos-wm-generic-installation
- set all host paths in .env (now f:\something)
- run the "build.bat" in the project folder

#### Build the dbcc container images

- go to folder centos-wm-generic-installation
- set all host paths in .env (now f:\something)
- run the "build.bat" in the project folder
- eventually edit "build.v*.bat" changing the product image path
- eventually run "build.v*.bat"

#### Run this project

- set all the necessary env variables
- startup mysql (01-mysql-01-up.bat)
- optionally startuo adminer (S01-adminer-01-up.bat) if you want to introspect mysql contents
- execute init-db.bat after mysql finished its own startup. wait for the command to finish
  - Note: only one version may be used at a time. If you use 10.3 call init-db.v1003.bat ONLY
- execute init-mws.bat

ATM this command fails for a probable bug. Investigations are on going.
