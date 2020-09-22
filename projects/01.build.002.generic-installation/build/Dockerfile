ARG SRC_IMAGE=centos:7
FROM ${SRC_IMAGE}

LABEL maintainer="Myhael76"

RUN yum install -y net-tools && \
    yum install -y unzip && \
    yum install -y less && \
    yum install -y telnet && \
    yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum

ENV SAG_HOME=/opt/sag \
    SAG_INSTALL_HOME=/opt/sag/products \
    SAG_SUM_HOME=/opt/sag/sum \
    SAG_OSGI_ORCHESTRATOR_HOME=/opt/sag/mnt/wm-install-files \
    SAG_RUN_HOME=/opt/sag/mnt/runs \
    SAG_SCRIPTS_HOME=/opt/sag/mnt/scripts \
    SAG_SECRETS_HOME=/opt/sag/mnt/secret \
    SAG_LICENSE_FOLDER=/opt/sag/mnt/wm-install-files/licenses

RUN groupadd -g 1724 sagadmin; useradd -u 1724 -m -g 1724 -d ${SAG_HOME} sagadmin

USER 1724
# need to create these for permissions inheritance (which works in a strange manner now??)
RUN mkdir -p    ${SAG_HOME} \
                ${SAG_INSTALL_HOME} \
                ${SAG_SUM_HOME} \
                ${SAG_OSGI_ORCHESTRATOR_HOME} \
                ${SAG_RUN_HOME} \
                ${SAG_SCRIPTS_HOME} \
                ${SAG_SECRETS_HOME} \
                ${SAG_LICENSE_FOLDER}

ENV JAVA_HOME=${SAG_INSTALL_HOME}/jvm/jvm/ JRE_HOME=${SAG_INSTALL_HOME}/jvm/jvm/

# Expect this to be overwritten
ENTRYPOINT ["tail -f /dev/null"]