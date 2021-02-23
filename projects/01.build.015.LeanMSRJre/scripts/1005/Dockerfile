ARG SRC_IMAGE=centos:7
FROM ${SRC_IMAGE}

LABEL MAINTAINER Myhael76

ARG UID=1724
ARG GID=1724

ENV SAG_HOME /opt/sag/products
ENV JAVA_HOME ${SAG_HOME}/jvm/jvm/jre/
ENV JRE_HOME ${SAG_HOME}/jvm/jvm/jre/
ENV SAG_DATA_HOME=/data
ENV SAG_IS_LOGS_DIR=/data/is/logs
ENV SAG_IS_HOME=${SAG_HOME}/IntegrationServer
ENV SAG_UID=${UID}
ENV SAG_GID=${GID}

RUN mkdir -p ${SAG_IS_HOME} ${SAG_DATA_HOME} ${SAG_IS_LOGS_DIR} &&\
    groupadd -g ${SAG_GID} sagadmin &&\
    useradd -u ${SAG_UID} -m -g ${SAG_GID} -d ${SAG_HOME} sagadmin &&\
    chown ${SAG_UID}:${SAG_GID} ${SAG_HOME} ${SAG_DATA_HOME} ${SAG_IS_LOGS_DIR} ${SAG_IS_HOME} &&\
    ln -s ${SAG_IS_LOGS_DIR} ${SAG_IS_HOME}/logs &&\
    chown ${SAG_UID}:${SAG_GID} ${SAG_IS_HOME}/logs
    
COPY --chown=${SAG_UID}:${SAG_GID} ./SAG_HOME/ ${SAG_HOME}/ 

USER ${SAG_UID}

EXPOSE 5555

ENTRYPOINT ["${SAG_IS_HOME}/bin/startContainer.sh"]