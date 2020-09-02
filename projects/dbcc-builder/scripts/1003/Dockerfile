FROM centos:7
ENV SAG_INSTALL_HOME=/opt/sag/products
ENV JAVA_HOME=${SAG_INSTALL_HOME}/jvm/jvm
ENV PATH=$PATH:$JAVA_HOME/bin

COPY ./jvm/jvm ${SAG_INSTALL_HOME}/jvm/jvm
COPY ./common/lib ${SAG_INSTALL_HOME}/common/lib
COPY ./common/db/bin/setEnv.sh ${SAG_INSTALL_HOME}/common/db/bin/setEnv.sh
COPY ./common/db/bin/dcc.sh ${SAG_INSTALL_HOME}/common/db/bin/dcc.sh
COPY ./common/db/bin/dbConfigurator.sh ${SAG_INSTALL_HOME}/common/db/bin/dbConfigurator.sh
COPY ./common/db/lib ${SAG_INSTALL_HOME}/common/db/lib
COPY ./common/db/definition ${SAG_INSTALL_HOME}/common/db/definition
COPY ./common/db/scripts ${SAG_INSTALL_HOME}/common/db/scripts

ENV SAG_HOME=/opt/sag \
    SAG_INSTALL_HOME=/opt/sag/products \
    SAG_RUN_HOME=/opt/sag/mnt/runs \
    SAG_SCRIPTS_HOME=/opt/sag/mnt/scripts \
#WORKDIR /opt/sag/products
# Note: this image is NOT intended to contain the concrete jdbc drivers e.g. mysqlce 