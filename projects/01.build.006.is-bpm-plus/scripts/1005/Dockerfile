ARG SRC_IMAGE=wm-generic-host
FROM ${SRC_IMAGE}

MAINTAINER Myhael76

# Copy the required binaries from installation to image
#### Folder optimized upfront...

ENV INSTANCE_NAME default

COPY --chown=1724:1724 ./SAG_HOME/ $SAG_INSTALL_HOME/


RUN cd $SAG_INSTALL_HOME/IntegrationServer/docker; ./is_container.sh updateDockerConfigFiles -Dinstance.name=default -Ddocker.isHomeDir=$SAG_INSTALL_HOME/IntegrationServer/instances/default -Ddocker.rootDir=$SAG_INSTALL_HOME
RUN cd $SAG_INSTALL_HOME/IntegrationServer/instances; ./is_instance.sh create-osgi-profile -Dinstance.name=default 

#RUN cd $SAG_INSTALL_HOME/IntegrationServer/docker && \
#    ./is_container.sh updateDockerConfigFiles -Dinstance.name=default -Ddocker.isHomeDir=$SAG_INSTALL_HOME/IntegrationServer/instances/default -Ddocker.rootDir=$SAG_INSTALL_HOME && \
#    cd $SAG_INSTALL_HOME/IntegrationServer/instances && \
#    ./is_instance.sh create-osgi-profile -Dinstance.name=default 

RUN mkdir -p $SAG_INSTALL_HOME/profiles
COPY --chown=1724:1724 ./extra/profiles/ $SAG_INSTALL_HOME/profiles/

WORKDIR $SAG_INSTALL_HOME

ENTRYPOINT ["/opt/sag/products/IntegrationServer/bin/startContainer.sh"]