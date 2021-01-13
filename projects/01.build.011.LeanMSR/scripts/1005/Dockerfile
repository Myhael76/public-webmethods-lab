FROM centos:7

LABEL MAINTAINER Myhael76

ENV SAG_HOME /opt/sag/products
ENV JAVA_HOME ${SAG_HOME}/jvm/jvm/
ENV JRE_HOME ${SAG_HOME}/jvm/jvm/jre/
ENV SAG_DATA_HOME=/data

RUN mkdir -p ${SAG_HOME} ${SAG_DATA_HOME} &&\
    groupadd -g 1724 sagadmin &&\
    useradd -u 1724 -m -g 1724 -d ${SAG_HOME} sagadmin
    
COPY --chown=1724:1724 ./SAG_HOME/ ${SAG_HOME}/

USER 1724

EXPOSE 5555

ENTRYPOINT ["/opt/sag/products/IntegrationServer/bin/startContainer.sh"]