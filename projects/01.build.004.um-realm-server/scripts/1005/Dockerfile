ARG BASE_IMAGE=centos:7

FROM $BASE_IMAGE as sag_base

ENV SAG_HOME=/opt/sag/products

RUN yum -y update &&\
	yum -y clean all &&\
	mkdir -p /opt/sag &&\
	groupadd -g 1724 sagadmin &&\
	useradd -u 1724 -m -g 1724 -d $SAG_HOME -c "SoftwareAG Admin" sagadmin &&\
	mkdir -p $SAG_HOME && chown 1724:1724 $SAG_HOME &&\
	mkdir -p /mnt/runs && chown 1724:1724 /mnt/runs &&\
	chmod 775 $SAG_HOME &&\
	mkdir -p $SAG_HOME/jvm &&\
	chown 1724:1724 $SAG_HOME/jvm

COPY --chown=1724:1724 ./SAG_HOME/jvm/jvm/ $SAG_HOME/jvm/jvm/

ENV PATH=$SAG_HOME:$SAG_HOME/jvm/jvm:$PATH

USER 1724

FROM sag_base

# __instance_name: If user want to copy the specific instance content to image, they can specifiy here. Default instance name is 'umserver'
ARG __instance_name=umserver

MAINTAINER Myhael76
# Adapted from Software AG

# Environment variables
ENV INSTANCE_NAME=$__instance_name

# Environment variables

# Create the required folders (data, logs, licence and tools) as these are not going to be copied from the installation, but will be needed at runtime
RUN mkdir -p $SAG_HOME/UniversalMessaging/server/$INSTANCE_NAME &&\
	chown 1724:1724 $SAG_HOME/UniversalMessaging/server/$INSTANCE_NAME

# Copy the required binaries from installation to image
#### Folder optimized upfront...
COPY --chown=1724:1724 ./SAG_HOME/ $SAG_HOME/

ENV PATH=$TOOLS_DIR/runner/:$PATH

WORKDIR $SAG_HOME
