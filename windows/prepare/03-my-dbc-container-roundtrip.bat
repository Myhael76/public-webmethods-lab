@echo off

SET SAG_W_ENTRY_POINT=/opt/sag/mnt/scripts/entrypoints/dbcCreate.sh

cd ..\build\os\centos-wm-install-helper

call .\01-up.bat

call .\02-down.bat