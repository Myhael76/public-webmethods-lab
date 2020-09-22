@echo off

:: Expect binaries with no server. Try to create the server as needed and check the volumes

docker run -ti --rm --name um-rs-test1 um-realm-server-1005 /bin/bash

pause