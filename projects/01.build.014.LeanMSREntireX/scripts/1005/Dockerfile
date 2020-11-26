FROM centos:7

MAINTAINER Myhael76

ENV SAG_HOME /opt/sag/products
ENV JAVA_HOME ${SAG_HOME}/jvm/jvm/
ENV JRE_HOME ${SAG_HOME}/jvm/jvm/jre/

RUN mkdir -p ${SAG_HOME}

RUN groupadd -g 1724 sagadmin; useradd -u 1724 -m -g 1724 -d ${SAG_HOME} sagadmin
USER 1724

COPY --chown=1724:1724 ./SAG_HOME/ ${SAG_HOME}/

EXPOSE 5555

ENTRYPOINT ["/opt/sag/products/IntegrationServer/bin/startContainer.sh"]