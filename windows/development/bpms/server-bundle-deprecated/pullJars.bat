if exist .\..\..\..\common\lib\ext\mysql-connector-java-8.0.15.jar goto end

powershell -Command^
 "Invoke-WebRequest https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.15/mysql-connector-java-8.0.15.jar -OutFile .\..\..\..\common\lib\ext\mysql-connector-java-8.0.15.jar"

:end
