# Example of unattended fix image creation from inventory file

## Prerequisites

- Projects 00.commons and 01.build.000.commons present and configured
- Build the image centos-wm-install-helper first (..\01.build.001.wm-install-helper\build.bat)
- Download the Update Manager 11 bootstrap
- Produce the SUM credentials as described in ..\config\secret\readme.md

## Run the project

- Setup your project first by calling 01.generateEnvFile.bat
- Run the necessary bat file "02.*.createInventoryFile*.bat" according to your context. This script will create an inventory file with all the products present in the current git repository
- Run the associated 03.*.produceFixesImage.*.bat. This will produce an image file in the output folder picked at the project setup time and mentioned in the _env file.

## Known Issues

Preparing fix images for versions older than 10.5 requires Update Manager v10
The project will eventually be extended if the need will be identified