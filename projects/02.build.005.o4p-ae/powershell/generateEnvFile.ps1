. ..\powerShellLib\scripts\common.ps1

# TODO: check for credentials file first, doesn't make sense to continue if they are not there
# TODO: check if .env file exist and ask for permission to overwrite
# TODO: add optionality and mapping to dummy for optional files

## Lines generated by generateEnvFile.ps1 >> .env
generateEnvLineForFileRef "H_WMLAB_INSTALLER_BIN" "Please Provide Installer Binary File" >> .env
generateEnvLineForFileRef "H_WMLAB_PRODUCTS_IMAGE" "Please Provide Products Image File" >> .env
generateEnvLineForFileRef "H_WMLAB_SUM10_BOOTSTRAP_BIN" "Please Provide Update Manager v10 binary file (if not needed provide any file)" >> .env
generateEnvLineForFileRef "H_WMLAB_SUM11_BOOTSTRAP_BIN" "Please Provide Update Manager v11 binary file (if not needed provide any file)" >> .env
generateEnvLineForFileRef "H_WMLAB_FIXES_IMAGE_FILE" "Please Provide Fixes Image File" >> .env