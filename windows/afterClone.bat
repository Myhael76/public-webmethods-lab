@echo off

call .\pullContent.bat
cd .\prepare
pushd .
call .\01-install-helper-roundtrip.bat
popd
pushd .
call .\02-sag-osgi-helper-roundtrip.bat
popd
call .\03-my-dbc-container-roundtrip.bat
pause