.\..\common\mount\extra\lib\ext\ goto download
mkdir .\..\common\mount\extra\lib\ext\
:download
if exist .\..\common\mount\extra\lib\ext\mysql-connector-java-8.0.15.jar  goto end
powershell -Command^
 "Invoke-WebRequest https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.15/mysql-connector-java-8.0.15.jar -OutFile .\..\common\mount\extra\lib\ext\mysql-connector-java-8.0.15.jar"
:end
