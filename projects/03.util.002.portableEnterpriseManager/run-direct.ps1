# get the config variables
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
Invoke-Expression -Command ". $PSScriptRoot\set-env.ps1"

$CP="$env:UM_LIB\classes"
$CP += ";$env:UM_LIB/nEnterpriseManager.jar"
$CP += ";$env:UM_LIB/jfreechart.jar"
$CP += ";$env:UM_LIB/icons.jar"
$CP += ";$env:UM_LIB/jfreechartcommon.jar"
$CP += ";$env:UM_LIB/jide-oss-3.3.4.jar"
$CP += ";$env:UM_LIB/nAdminAPI.jar"
$CP += ";$env:UM_LIB/nClient.jar"
$CP += ";$env:UM_LIB/protobuf-java.jar"
$CP += ";$env:UM_LIB/nJMS.jar"
$CP += ";$env:UM_LIB/xml-apis.jar"
$CP += ";$env:UM_LIB/xerces.jar"
$CP += ";$env:UM_LIB/swing-layout-1.0.jar"
$CP += ";$env:LOG4J_LIB/log4j-core.jar"
$CP += ";$env:LOG4J_LIB/log4j-api.jar"

$CMD = "$env:JAVA_EXE"

$CMD += " -Dsnoop=true" 
$CMD += " -DRNAME=$env:CLIENT_RNAME" 
$CMD += " -DLOGLEVEL=4" 
$CMD += " -DHPROXY=$env:HPROXY" 
$CMD += " -DHAUTH=$env:HAUTH" 
$CMD += " ""-DCKEYSTORE=" + $env:CKEYSTORE + """" 
$CMD += " -DCKEYSTOREPASSWD=$env:CKEYSTOREPASSWD" 
$CMD += " ""-DCAKEYSTORE=" + $env:CAKEYSTORE +"""" 
$CMD += " -DCAKEYSTOREPASSWD=$env:CAKEYSTOREPASSWD"
$CMD += " -DRNAME=nsp://localhost:9000"
$CMD += " ""-Dnirvana.globalStoreCapacity=0"""
$CMD += " -DUM_BRAND=wM"
$CMD += " ""-Dfile.encoding=Cp1252"""
$CMD += " ""-Dsun.stdout.encoding=Cp1252"""
$CMD += " ""-Dsun.stderr.encoding=Cp1252"""
$CMD += " ""-Dwrapper.use_sun_encoding=true"""
$CMD += " -Xms256m"
$CMD += " -Xmx512m"
$CMD += " ""-Djava.library.path=" + $env:UM_LIB + """"
$CMD += " -classpath """ + $CP + """"
$CMD += " com.pcbsys.nirvana.nAdminTool.gui.nEnterpriseManager"

Write-Output $CMD

Invoke-Expression -Command $CMD