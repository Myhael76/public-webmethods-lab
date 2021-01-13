ARG SRC_IMAGE=centos:7
ARG WMLAB_INSTALL_HOME=/opt/sag/products
ARG WMLAB_SUM_HOME=/opt/sag/sum
ARG WMLAB_WM_USERS_HOME=/opt/sag
ARG WMLAB_SAGADMIN_USER_NAME=sagadmin
ARG WMLAB_SAGADMIN_USER_PASSWORD=$1$uwFdCgRw$WS2pg1CpnxEjQA6nRFZel1
ARG WMLAB_SAG_USER_NAME=sag
ARG WMLAB_SAG_USER_PASSWORD=$1$vs2LiYFT$xj3XdCNHteEpRwsKQby/a0
ARG WMLAB_GPG_KEYS_FILE_1=/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

FROM ${SRC_IMAGE}

ARG WMLAB_INSTALL_HOME=/opt/sag/products
ARG WMLAB_SUM_HOME=/opt/sag/sum
ARG WMLAB_RUN_BASE_MOUNT=/mnt/runs
ARG WMLAB_DATA_BASE_MOUNT=/mnt/data
ARG WMLAB_WM_USERS_HOME=/opt/sag
ARG WMLAB_SAGADMIN_USER_NAME=sagadmin
ARG WMLAB_SAGADMIN_USER_PASSWORD=$1$uwFdCgRw$WS2pg1CpnxEjQA6nRFZel1
ARG WMLAB_SAG_USER_NAME=sag
ARG WMLAB_SAG_USER_PASSWORD=$1$vs2LiYFT$xj3XdCNHteEpRwsKQby/a0
ARG WMLAB_GPG_KEYS_FILE_1=/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

LABEL maintainer="Myhael76"

RUN if [ -f "$WMLAB_GPG_KEYS_FILE_1" ] ; then rpmkeys --import "${WMLAB_GPG_KEYS_FILE_1}" ; fi &&\
    yum -y update &&\
    yum install -y net-tools sudo unzip less telnet dstat &&\
    yum -y update &&\
    yum clean all &&\
    rm -rf /var/cache/yum

# propagate necessary env variables
ENV WMLAB_INSTALL_HOME=${WMLAB_INSTALL_HOME} \
    WMLAB_SUM_HOME=${WMLAB_SUM_HOME} \
    WMLAB_WM_USERS_HOME=${WMLAB_WM_USERS_HOME} \
    JAVA_HOME=${WMLAB_INSTALL_HOME}/jvm/jvm/ \
    JRE_HOME=${WMLAB_INSTALL_HOME}/jvm/jvm/jre/ \
    WMLAB_RUN_BASE_MOUNT=${WMLAB_RUN_BASE_MOUNT}

RUN groupadd -g 1724 sag &&\
    useradd -u 1725 -m -g 1724          -d ${WMLAB_WM_USERS_HOME} ${WMLAB_SAG_USER_NAME}      -p "${WMLAB_SAG_USER_PASSWORD}" &&\
    useradd -u 1724 -M -g wheel -G 1724 -d ${WMLAB_WM_USERS_HOME} ${WMLAB_SAGADMIN_USER_NAME} -p "${WMLAB_SAGADMIN_USER_PASSWORD}" &&\
    mkdir -p ${WMLAB_INSTALL_HOME} ${WMLAB_SUM_HOME} ${WMLAB_RUN_BASE_MOUNT} ${WMLAB_DATA_BASE_MOUNT} &&\
    chown -R sag:sag ${WMLAB_INSTALL_HOME} &&\
    chown -R sag:sag ${WMLAB_SUM_HOME} &&\
    chown -R sag:sag ${WMLAB_WM_USERS_HOME} &&\
    chown -R sag:sag ${WMLAB_RUN_BASE_MOUNT} &&\
    chown -R sag:sag ${WMLAB_DATA_BASE_MOUNT} &&\
    chmod g+rwx /opt/sag/

USER 1725

# Expect this to be overwritten
ENTRYPOINT ["/bin/sh -c tail -f /dev/null"]