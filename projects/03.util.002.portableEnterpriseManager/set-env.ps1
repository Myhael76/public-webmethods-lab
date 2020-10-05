# set this variables according to your environment: home of your local development installation
# the specified folder must be a valid webmethods installation containing Enterprise Manager

$env:WM_INSTALL_HOME="e:/i/SAG/1005/Dev1"

# change these only if strictly needed
$env:UM_LIB="$env:WM_INSTALL_HOME/UniversalMessaging/lib"
$env:LOG4J_LIB="$env:WM_INSTALL_HOME/common/lib/ext/log4j"
$env:JAVA_EXE="$env:WM_INSTALL_HOME/jvm/jvm/jre/bin/java.exe"

# optional paramters (not yet tested)

$env:CLIENT_RNAME=""
$env:HPROXY=""
$env:HAUTH=""
$env:CKEYSTORE=""
$env:CKEYSTOREPASSWD=""
$env:CAKEYSTORE="" 
$env:CAKEYSTOREPASSWD=""