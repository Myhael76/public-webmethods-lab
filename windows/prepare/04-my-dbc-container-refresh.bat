@echo off

docker rmi mydbcc-1005

call 03-my-dbc-container-roundtrip.bat
