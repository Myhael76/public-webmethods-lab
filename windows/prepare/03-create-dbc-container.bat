@echo off

SET ENTRY_POINT=/opt/sag/mnt/scripts/entrypoints/dbcCreate.bash

cd ..\build\os\centos-wm-install-helper

call .\01-up.bat

call .\02-down.bat