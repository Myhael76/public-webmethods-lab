# Example of unattended fix image creation from inventory file

## Prerequisites

- Project unixShellLib
- Build the image centos-wm-install-helper first (.\centos-wm-install-helper\build.bat)
- Download the Update Manager 11 bootstrap
- Change .env file pasting the correct path to the downloaded file into the row declaring the variable "H_WMLAB_SUM11_BOOTSTRAP_BIN"
- Produce the SUM credentials as described in ..\config\secret\readme.md

## Run the project

Run the provided bat file "produceFixesImage.bat". The result will be found in the ./runs folder.