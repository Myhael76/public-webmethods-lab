FROM centos:7

MAINTAINER Myhael76

ENV SAG_HOME /opt/softwareag
RUN groupadd -g 1724 sagadmin; useradd -u 1724 -m -g 1724 -d ${SAG_HOME} sagadmin

USER 1724
RUN mkdir -p ${SAG_HOME}/jvm ${SAG_HOME}/common ${SAG_HOME}/MWS ${SAG_HOME}/install/bms ${SAG_HOME}/MWS/server/default/ ${SAG_HOME}/profiles/

ENV JAVA_HOME ${SAG_HOME}/jvm/jvm/
ENV JRE_HOME ${SAG_HOME}/jvm/jvm/

# TODO: further optimize image

COPY --chown=1724:1724 ./jvm/jvm/jre/ ${SAG_HOME}/jvm/jvm/jre/
COPY --chown=1724:1724 ./jvm/jvm/lib/ ${SAG_HOME}/jvm/jvm/lib/
COPY --chown=1724:1724 ./jvm/jvm/bin/ ${SAG_HOME}/jvm/jvm/bin/

COPY --chown=1724:1724 ./install/ ${SAG_HOME}/install/

COPY --chown=1724:1724 ./common/ ${SAG_HOME}/common/
# ${SAG_HOME}/common/conf/event not reusable, mount at start time, it will overwrite existing files

COPY --chown=1724:1724 ./MWS/ ${SAG_HOME}/MWS/

#COPY --chown=1724:1724 ./ ${SAG_HOME}/

COPY --chown=1724:1724 ./entrypoint.bash ${SAG_HOME}/entrypoint.bash
COPY --chown=1724:1724 ./set-instance-parameters.bash ${SAG_HOME}/set-instance-parameters.bash

EXPOSE 8585

# ENTRYPOINT /opt/softwareag/entrypoint.bash to be used by specializations
ENTRYPOINT ["tail -f /dev/null"]