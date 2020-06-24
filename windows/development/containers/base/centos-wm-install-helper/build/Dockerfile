ARG SRC_IMAGE=centos:7
FROM ${SRC_IMAGE}

LABEL maintainer="Myhael76"

RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    yum install -y net-tools && \
    yum install -y less && \
    yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum