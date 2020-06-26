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

FROM dib.eur.ad.sag:5000/wm-dcc:10.5 as intermediate

FROM alpine:latest
ENV SAG_HOME=/opt/softwareag
ENV JAVA_MINIMAL="/opt/java-minimal"
ENV JAVA_HOME=$SAG_HOME/jvm/jvm/jre
ENV PATH=$PATH:$JAVA_HOME/bin

COPY --from=packager $JAVA_MINIMAL $SAG_HOME/jvm/jvm/jre
COPY --from=intermediate $SAG_HOME/common/lib $SAG_HOME/common/lib
COPY --from=intermediate $SAG_HOME/common/db/bin/setEnv.sh $SAG_HOME/common/db/bin/setEnv.sh
COPY --from=intermediate $SAG_HOME/common/db/bin/dbConfigurator.sh $SAG_HOME/common/db/bin/dbConfigurator.sh
COPY --from=intermediate $SAG_HOME/common/db/lib $SAG_HOME/common/db/lib
COPY --from=intermediate $SAG_HOME/common/db/DCC $SAG_HOME/common/db/DCC
COPY --from=intermediate $SAG_HOME/common/db/IntegrationServer $SAG_HOME/common/db/IntegrationServer
COPY --from=intermediate $SAG_HOME/common/db/Monitor $SAG_HOME/common/db/Monitor
COPY --from=intermediate $SAG_HOME/common/db/MywebMethodsServer $SAG_HOME/common/db/MywebMethodsServer
COPY --from=intermediate $SAG_HOME/common/db/Optimize $SAG_HOME/common/db/Optimize
COPY --from=intermediate $SAG_HOME/common/db/ProcessEngine $SAG_HOME/common/db/ProcessEngine
COPY --from=intermediate $SAG_HOME/common/db/TradingNetworks $SAG_HOME/common/db/TradingNetworks

WORKDIR /opt/softwareag