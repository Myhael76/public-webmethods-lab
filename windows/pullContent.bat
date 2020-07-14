@echo off

:: ensure directory exists
if exist .\..\common\mount\extra\lib\ext\ goto download1
mkdir .\..\common\mount\extra\lib\ext\

:download1
if exist .\..\common\mount\extra\lib\ext\mysql-connector-java-5.1.49.jar  goto end
powershell -Command^
 "Invoke-WebRequest https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar -OutFile .\..\common\mount\extra\lib\ext\mysql-connector-java-5.1.49.jar"

:end
