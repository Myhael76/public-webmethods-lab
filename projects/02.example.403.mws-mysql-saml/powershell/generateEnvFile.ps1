. ..\00.commons\lib\powerShell\common.ps1

# TODO: check for credentials file first, doesn't make sense to continue if they are not there
# TODO: check if .env file exist and ask for permission to overwrite
# TODO: add optionality and mapping to dummy for optional files

"## Lines generated by project 01.build.004 generateEnvFile.ps1" >> .env

generateEnvLineForFileRef "H_WMLAB_BR_LICENSE_FILE" "Please Provide License File for installing Business Rules " >> .env