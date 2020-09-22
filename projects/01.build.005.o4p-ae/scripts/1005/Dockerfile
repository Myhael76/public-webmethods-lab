ARG BASE_IMAGE=centos:7

FROM $BASE_IMAGE as sag_base

ENV SAG_HOME=/opt/sag/products

RUN yum -y update &&\
	yum -y clean all &&\
	mkdir -p /opt/sag &&\
	groupadd -g 1724 sagadmin &&\
	useradd -u 1724 -m -g 1724 -d $SAG_HOME -c "SoftwareAG Admin" sagadmin &&\
	mkdir -p $SAG_HOME && chown 1724:1724 $SAG_HOME &&\
	chmod 775 $SAG_HOME &&\
	mkdir -p $SAG_HOME/jvm &&\
	chown 1724:1724 $SAG_HOME/jvm

COPY --chown=1724:1724 ./SAG_HOME/jvm/jvm/ $SAG_HOME/jvm/jvm/

ENV PATH=$SAG_HOME:$SAG_HOME/jvm/jvm:$PATH

USER 1724

FROM sag_base

MAINTAINER Myhael76
# Adapted from Software AG

# Environment variables
ENV INSTANCE_NAME=$__instance_name

# Copy the required binaries from installation to image
#### Folder optimized upfront...
COPY --chown=1724:1724 ./SAG_HOME/ $SAG_HOME/

WORKDIR $SAG_HOME
