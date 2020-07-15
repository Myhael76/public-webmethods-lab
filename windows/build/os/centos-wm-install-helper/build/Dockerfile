ARG SRC_IMAGE=centos:7
FROM ${SRC_IMAGE}

LABEL maintainer="Myhael76"

# if you need proxy change this file by adding a command like
# echo proxy=http://your-server:12345 >> /etc/yum.conf
# as the first command (i.e. before caling yum)
# see https://www.linuxtechi.com/proxy-settings-yum-command-on-rhel-centos-servers/

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    yum install -y unzip && \
    yum install -y net-tools && \
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
