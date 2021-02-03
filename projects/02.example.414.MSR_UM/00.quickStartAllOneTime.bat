@echo off


:: Section 1 ask for env specifics

echo Generating concrete environment for project 414 and all dependencies

cd ..\00.commons
call generateEnv.bat

cd ..\01.build.000.commons
call generateEnvInstallCommons.bat

echo "Environment for building UM Realm Server Image"
cd ..\01.build.004.um-realm-server
call 01.generateEnvFile.bat

echo "Environment for building UMTool image"
cd ..\01.build.009.runUMTool
call generateEnv.bat

echo "Environment for buildin Lean MSR image for development"
cd ..\01.build.011.LeanMSR
call generateEnv.bat

cd ..\02.example.414.MSR_UM
call 01.generateEnvFile.bat

:: Section 2: build images
echo "Building Install Helper image"
cd ..\01.build.001.wm-install-helper
call build.bat

echo "Building UM Realm Server Image"
cd ..\01.build.004.um-realm-server
call 02.build.bat

echo "Building UMTool image"
cd ..\01.build.009.runUMTool
call build.bat

echo "Buildin Lean MSR image for development"
cd ..\01.build.011.LeanMSR
call build.bat

cd ..\02.example.414.MSR_UM
docker-compose up
