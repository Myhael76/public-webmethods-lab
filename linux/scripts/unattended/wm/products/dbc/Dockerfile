FROM alpine:latest as packager

RUN apk --no-cache add openjdk11-jdk openjdk11-jmods

ENV JAVA_MINIMAL="/opt/java-minimal"

# build minimal JRE
RUN /usr/lib/jvm/java-11-openjdk/bin/jlink \
    --verbose \
    --add-modules \
        java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    --compress 2 --strip-debug --no-header-files --no-man-pages \
    --release-info="add:IMPLEMENTOR=radistao:IMPLEMENTOR_VERSION=radistao_JRE" \
    --output "$JAVA_MINIMAL"

FROM alpine:latest
ENV SAG_INSTALL_HOME=/opt/sag/products
ENV JAVA_HOME=${SAG_INSTALL_HOME}/jvm/jvm/jre
ENV PATH=$PATH:$JAVA_HOME/bin

COPY --from=packager /opt/java-minimal ${SAG_INSTALL_HOME}/jvm/jvm/jre
COPY ./common/lib ${SAG_INSTALL_HOME}/common/lib
COPY ./common/db/bin/setEnv.sh ${SAG_INSTALL_HOME}/common/db/bin/setEnv.sh
COPY ./common/db/bin/dbConfigurator.sh ${SAG_INSTALL_HOME}/common/db/bin/dbConfigurator.sh
COPY ./common/db/lib ${SAG_INSTALL_HOME}/common/db/lib
COPY ./common/db/DCC ${SAG_INSTALL_HOME}/common/db/DCC
COPY ./common/db/IntegrationServer ${SAG_INSTALL_HOME}/common/db/IntegrationServer
COPY ./common/db/Monitor ${SAG_INSTALL_HOME}/common/db/Monitor
COPY ./common/db/MywebMethodsServer ${SAG_INSTALL_HOME}/common/db/MywebMethodsServer
COPY ./common/db/Optimize ${SAG_INSTALL_HOME}/common/db/Optimize
COPY ./common/db/ProcessEngine ${SAG_INSTALL_HOME}/common/db/ProcessEngine
COPY ./common/db/TradingNetworks ${SAG_INSTALL_HOME}/common/db/TradingNetworks

ENV SAG_HOME=/opt/sag \
    SAG_INSTALL_HOME=/opt/sag/products \
    SAG_RUN_HOME=/opt/sag/mnt/runs \
    SAG_SCRIPTS_HOME=/opt/sag/mnt/scripts \
#WORKDIR /opt/sag/products
# Note: this image is NOT intended to contain the concrete jdbc drivers e.g. mysqlce 