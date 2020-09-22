# Example of unattended fix image creation from inventory file

## Prerequisites

- Project unixShellLib (already provided by project cloning)
- Build the image centos-wm-install-helper first (..\01.build.001.wm-install-helper\build.bat)
- Download the Update Manager 11 bootstrap
- Produce the SUM credentials as described in ..\config\secret\readme.md

## Run the project

- Setup your project first by calling 01.generateEnvFile.bat
  - Alternatively set manually .env
    - copy .env_base into .env
    - edit .env and add the line H_WMLAB_SUM11_BOOTSTRAP_BIN=path/to/sum11.bin
- Run the provided bat file "02.produceFixesImage.bat". The result will be found in the ./runs folder.