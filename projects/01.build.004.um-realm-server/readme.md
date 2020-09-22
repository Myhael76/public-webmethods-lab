# Universal Messaging Reals Server Docker Image Builder

## Purpose

This projects constructs a centos based docker image containing the realm server binaries without any actual server.
This is provided for local PC usage, laboratories and as a starting point for building your own images.

## Prerequisites

- Project wm-install-helper must be already built
  - if not, run _public-webmethods-lab_\projects\centos-wm-install-helper in its folder
- Software AG installer
- Software AG installer product image
- Software AG update manager (v11, but setup will ask for v10 as well)
- Fixes image 
- Empower credentials for Update Manager
- Universal Messaging license file

## Usage

- run 01.generateEnvFile.bat to setup your local environment. The script will ask you to pick the files for the above prerequisites
- run 02.build.bat
- run 03.test.bat eventually to startup a container from the generated image and play with it

## TODO

- generalize for other versions. ATM this was tested with 1005 only