#!/bin/sh

######### Project constants
# this script position: /root/certificates
export RED='\033[0;31m'
export NC='\033[0m' 				  	# No Color
export Green="\033[0;32m"        		# Green
export Cyan="\033[0;36m"         		# Cyan

if [ -z "${LOG_TOKEN}" ]; then
    LOG_TOKEN="PUBLIC_CERT_LAB Common"
fi
LOG_TOKEN_C_I="${Green}INFO - ${LOG_TOKEN}${NC}"
LOG_TOKEN_C_E="${RED}ERROR - ${Green}${LOG_TOKEN}${NC}"

function logI(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_I} - ${1}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -INFO- ${1}" >> ${LAB_RUN_FOLDER}/script.trace.log
}

function logE(){
    echo -e `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN_C_E} - ${RED}${1}${NC}"
    echo `date +%y-%m-%dT%H.%M.%S_%3N`" ${LOG_TOKEN} -ERROR- ${1}" >> ${LAB_RUN_FOLDER}/script.trace.log
}



assureRunFolder(){
    if [ -z "${LAB_RUN_FOLDER}" ]; then
        export LAB_RUN_FOLDER="/root/certificates/runs/run_"`date +%y-%m-%dT%H.%M.%S`
        mkdir -p ${LAB_RUN_FOLDER}
        logI "LAB_RUN_FOLDER set to "${LAB_RUN_FOLDER}
    fi
}

assurePassphrase(){
    if [ -z "${LAB_PASSPHRASE}" ]; then
        export LAB_PASSPHRASE='default_passphrase'
        logI "LAB_PASSPHRASE set to default value: ${LAB_PASSPHRASE}"
    fi
}

generateCaKey()
{
    openssl genrsa \
        -aes256 \
        -passout pass:"${LAB_PASSPHRASE}" \
        -out ${LAB_OUT_FOLDER}/encryptedCertificateAuthority.key.pem \
        ${LAB_KEY_BITS}
}

generateCaCert(){
    openssl req \
        -new \
        -key ${LAB_OUT_FOLDER}/encryptedCertificateAuthority.key.pem \
        -passin pass:"${LAB_PASSPHRASE}" \
        -x509 \
        -days 90 \
        -subj "${LAB_CA_Subj}" \
        -out ${LAB_OUT_FOLDER}/certificateAuthority.cert.pem 
}

generateServerKey(){
    openssl genrsa \
        -aes256 \
        -passout pass:"${LAB_PASSPHRASE}" \
        -out ${LAB_OUT_FOLDER}/server_${1}/private.key.pem \
        ${LAB_KEY_BITS}
}

generateServerCSR(){

    echo "FQDN = ${1}${LAB_SERVER_COMMON_DOMAIN_SUFFIX}" > ${LAB_OUT_FOLDER}/server_${1}/csr.config
    echo "LAB_CA_Organization = ${LAB_CA_Organization}" >> ${LAB_OUT_FOLDER}/server_${1}/csr.config
    echo "LAB_CA_Country = ${LAB_CA_Country}" >> ${LAB_OUT_FOLDER}/server_${1}/csr.config
    echo "LAB_CA_Region = ${LAB_CA_Region}" >> ${LAB_OUT_FOLDER}/server_${1}/csr.config
    echo "LAB_CA_City = ${LAB_CA_City}" >> ${LAB_OUT_FOLDER}/server_${1}/csr.config
    echo "" >> ${LAB_OUT_FOLDER}/server_${1}/csr.config
    
    cat /root/certificates/config/csr/base.config >> ${LAB_OUT_FOLDER}/server_${1}/csr.config
    cat /root/certificates/config/server_${1}/altNames.config >> ${LAB_OUT_FOLDER}/server_${1}/csr.config

    openssl req \
        -new \
        -sha256 \
        -key ${LAB_OUT_FOLDER}/server_${1}/private.key.pem \
        -passin pass:"${LAB_PASSPHRASE}" \
        -out ${LAB_OUT_FOLDER}/server_${1}/public.csr.pem \
        -config ${LAB_OUT_FOLDER}/server_${1}/csr.config
}

generateServerCertificate(){

    cat \
        /root/certificates/config/ca/sign_base.config \
        /root/certificates/config/server_${1}/altNames.config \
        > ${LAB_OUT_FOLDER}/server_${1}/ca_sign.config

    openssl x509 \
        -req \
        -days 60 \
        -in ${LAB_OUT_FOLDER}/server_${1}/public.csr.pem \
        -CA ${LAB_OUT_FOLDER}/certificateAuthority.cert.pem \
        -CAkey ${LAB_OUT_FOLDER}/encryptedCertificateAuthority.key.pem \
        -passin pass:"${LAB_PASSPHRASE}" \
        -CAcreateserial \
        -out ${LAB_OUT_FOLDER}/server_${1}/public.crt.pem \
        -extfile ${LAB_OUT_FOLDER}/server_${1}/ca_sign.config \
        -extensions LAB
}

chainServerCertificate(){
    # ${LAB_OUT_FOLDER}/encrypted.server_${1}/key.pem
    cat \
        ${LAB_OUT_FOLDER}/server_${1}/public.crt.pem  \
        ${LAB_OUT_FOLDER}/certificateAuthority.cert.pem \
        > ${LAB_OUT_FOLDER}/server_${1}/public.crt.bundle.pem
}

generateP12PrivateKeyStore(){
    # Note: 
    # for longer chains the -certfile must contain the full bundle up to the current certificate
    # excluding the one passed with -inkey
    openssl pkcs12 \
        -export \
        -in ${LAB_OUT_FOLDER}/server_${1}/public.crt.pem \
        -inkey ${LAB_OUT_FOLDER}/server_${1}/private.key.pem \
        -passin pass:"${LAB_PASSPHRASE}" \
        -out ${LAB_OUT_FOLDER}/server_${1}/private.key.store.p12  \
        -passout pass:"${LAB_PASSPHRASE}" \
        -CAfile ${LAB_OUT_FOLDER}/certificateAuthority.cert.pem
}

generateP12PrivateKeyStoreWithChain(){
    # Note: 
    # for longer chains the -certfile must contain the full bundle up to the current certificate
    # excluding the one passed with -inkey
    openssl pkcs12 \
        -export \
        -in ${LAB_OUT_FOLDER}/server_${1}/public.crt.pem \
        -inkey ${LAB_OUT_FOLDER}/server_${1}/private.key.pem \
        -passin pass:"${LAB_PASSPHRASE}" \
        -out ${LAB_OUT_FOLDER}/server_${1}/full.chain.key.store.p12  \
        -passout pass:"${LAB_PASSPHRASE}" \
        -name serverCertificate \
        -CAfile ${LAB_OUT_FOLDER}/certificateAuthority.cert.pem \
        -caname "Laboratory Authority" \
        -chain
}

generateAll(){
    logI "Generating Certificate Authority Key Pair"
    generateCaKey >${LAB_RUN_FOLDER}/01-genCaKey.out 2>${LAB_RUN_FOLDER}/01-genCaKey.err

    logI "Generating Certificate Authority Self Signed Certificate"
    generateCaCert >${LAB_RUN_FOLDER}/02-genCaCert.out 2>${LAB_RUN_FOLDER}/02-genCaCert.err

    set -- ${LAB_SERVERS}
    
    while [ -n "$1" ]; do
        s=$1
        logI "Treating server ${s}"
        mkdir -p ${LAB_OUT_FOLDER}/server_${1}
        generateServerKey ${s} >${LAB_RUN_FOLDER}/output/server_${1}/03-genKey.${s}.out 2>${LAB_RUN_FOLDER}/output/server_${1}/03-genKey.${s}.err
        
        logI "Generating CSR for server ${s}"
        generateServerCSR ${s} >${LAB_RUN_FOLDER}/output/server_${1}/04-genCSR.${s}.out 2>${LAB_RUN_FOLDER}/output/server_${1}/04-genCSR.${s}.err

        logI "Generating certificate for server ${s}"
        generateServerCertificate ${s} >${LAB_RUN_FOLDER}/output/server_${1}/05-genCert.${s}.out 2>${LAB_RUN_FOLDER}/output/server_${1}/05-genCert.${s}.err

        logI "Generating chained certificates for server ${s}"
        chainServerCertificate ${s}

        logI "Generating p12 no chain PKCS12 key store for server ${s}"
        generateP12PrivateKeyStore ${s} >${LAB_RUN_FOLDER}/output/server_${1}/07-genP12.${s}.out 2>${LAB_RUN_FOLDER}/output/server_${1}/07-genP12.${s}.err

        logI "Generating p12 full chain PKCS12 key store for server ${s}"
        generateP12PrivateKeyStoreWithChain ${s} >${LAB_RUN_FOLDER}/output/server_${1}/08-genFullP12.${s}.out 2>${LAB_RUN_FOLDER}/output/server_${1}/08-genFullP12.${s}.err

        shift
    done

    logI "Finished"
}

####### Init
assureRunFolder
export LAB_OUT_FOLDER=${LAB_RUN_FOLDER}/output
mkdir -p ${LAB_OUT_FOLDER}
assurePassphrase
# this run variables
. /root/certificates/config/variables.sh
