ARG BASE_IMAGE=ccs-admin-tool-1005

FROM $BASE_IMAGE

MAINTAINER Myhael76

# Copy the required binaries from installation to image
#### Folder optimized upfront...
COPY --chown=1724:1724 ./SAG_HOME/ $SAG_INSTALL_HOME/

WORKDIR $SAG_INSTALL_HOME
