. ..\00.commons\lib\powerShell\common.ps1

# TODO: check for credentials file first, doesn't make sense to continue if they are not there
# TODO: check if .env file exist and ask for permission to overwrite
# TODO: add optionality and mapping to dummy for optional files

"## Lines generated by project 02.example.001.fix-img-for-inventory generateEnvFile.ps1" >> .env

generateEnvLineForFolderRef "H_WMLAB_FIXES_IMAGE_DIR" "Please provide the folder for fix image output" >> .env
