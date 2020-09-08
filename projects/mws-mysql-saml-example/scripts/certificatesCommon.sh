#!/bin/sh

init(){
    . /mnt/scripts/lib/common.sh

    WMLAB_LOCAL_KEYSTORE_FILE=${WMLAB_LOCAL_KEYSTORE_FILE:-"${WMLAB_INSTALL_HOME}/common/conf/local_keystore.p12"}
    WMLAB_LOCAL_KEYSTORE_PASSWORD=${WMLAB_LOCAL_KEYSTORE_PASSWORD:-"changeIt"}
    WMLAB_LOCAL_TRUSTSTORE_FILE=${WMLAB_LOCAL_TRUSTSTORE_FILE:-"${WMLAB_INSTALL_HOME}/common/conf/local_truststore.jks"}
    WMLAB_LOCAL_TRUSTSTORE_PASSWORD=${WMLAB_LOCAL_TRUSTSTORE_PASSWORD:-"changeIt"}
}

init

addPemCertToProjectJksTruststore(){
    # Params: 
    # 1: pem file containing a certificate
    # 2: key alias
    # by convention, the jks trust store is ${SAG_PROJECT_TRUSTSTORE}
    # e.g. CA cert is /opt/sag/certificates/store/ca/certificateAuthority.cert.pem
    if [ -f ${1} ]; then
        ${WMLAB_INSTALL_HOME}/jvm/jvm/jre/bin/keytool \
            -importcert -file ${1} -alias ${2} \
            -noprompt -keystore ${WMLAB_LOCAL_TRUSTSTORE_FILE} \
            -storepass ${WMLAB_LOCAL_TRUSTSTORE_PASSWORD}
        RESULT_addPemCertToProjectJksTruststore=$?
        logI "DEBUG: Adding certificate ${1} with alias ${2} to project truststore (code ${RESULT_addPemCertToProjectJksTruststore})"
    else
        logE "Certificate file ${1} not found"
    fi
}

cafCipherUtilEncryptPassword(){
    CP="${WMLAB_INSTALL_HOME}/common/lib/wm-caf-common.jar"
    CP="${CP}:${WMLAB_INSTALL_HOME}/common/lib/wm-caf-common.jar"
    CP="${CP}:${WMLAB_INSTALL_HOME}/common/lib/ext/slf4j-api.jar"
    CP="${CP}:${WMLAB_INSTALL_HOME}/common/lib/wm-scg-security.jar"
    CP="${CP}:${WMLAB_INSTALL_HOME}/common/lib/wm-scg-core.jar"
    CP="${CP}:${WMLAB_INSTALL_HOME}/common/lib/ext/enttoolkit.jar"

    CMD="${WMLAB_INSTALL_HOME}/jvm/jvm/jre/bin/java -cp "'"'"${CP}"'"'" com.webmethods.caf.common.CipherUtil ${1}"
    
    MY_ENCRYPTED_PASSWORD=`${CMD}`
    RESULT_cafCipherUtilEncryptPassword=$?

    if [ ${RESULT_cafCipherUtilEncryptPassword} -eq 0 ] ; then
        logI "Password encrypted successfully"
        export MY_ENCRYPTED_PASSWORD
    fi
}

updateCustomWrapperForHttps(){
    logI "Updating custom_wrapper.conf to enable HTTPS"

    cafCipherUtilEncryptPassword ${WMLAB_LOCAL_KEYSTORE_PASSWORD}
    sed -i "s/\(set\.JAVA_KEYSTORE_PASSWORD=\).*\$/\1${MY_ENCRYPTED_PASSWORD}/" ${WMLAB_INSTALL_HOME}/profiles/MWS_default/configuration/custom_wrapper.conf

    cafCipherUtilEncryptPassword ${WMLAB_LOCAL_TRUSTSTORE_PASSWORD}
    sed -i "s/\(set\.JAVA_TRUSTSTORE_PASSWORD=\).*\$/\1${MY_ENCRYPTED_PASSWORD}/" ${WMLAB_INSTALL_HOME}/profiles/MWS_default/configuration/custom_wrapper.conf

    unset MY_ENCRYPTED_PASSWORD
    # Truststore
    sed -i "s;\(set\.JAVA_TRUSTSTORE=\).*\$;\1${WMLAB_LOCAL_TRUSTSTORE_FILE};" ${WMLAB_INSTALL_HOME}/profiles/MWS_default/configuration/custom_wrapper.conf
    # Keystore
    sed -i "s;\(set\.JAVA_KEYSTORE=\).*\$;\1${WMLAB_LOCAL_KEYSTORE_FILE};" ${WMLAB_INSTALL_HOME}/profiles/MWS_default/configuration/custom_wrapper.conf
}