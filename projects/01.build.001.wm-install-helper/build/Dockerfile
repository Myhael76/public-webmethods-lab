ARG SRC_IMAGE=centos:7
FROM ${SRC_IMAGE}

LABEL maintainer="Myhael76"

RUN rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum -y update && \
    rpmkeys --import https://download.docker.com/linux/centos/gpg && \
    yum install ca-certificates &&\
    yum-config-manager \
	  --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    yum install -y unzip && \
    yum install -y net-tools && \
    yum install -y less && \
    yum install -y telnet && \
    yum install -y dstat && \
    yum -y update && \
    yum clean all && \
    rm -rf /var/cache/yum