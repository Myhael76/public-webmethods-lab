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
ENV JAVA_HOME=${SAG_INSTALL_HOME}/jvm/jvm
ENV PATH=$PATH:$JAVA_HOME/bin

COPY --from=packager /opt/java-minimal ${SAG_INSTALL_HOME}/jvm/jvm
COPY ./SAG_HOME/ ${SAG_INSTALL_HOME}/

ENV SAG_HOME=/opt/sag \
    SAG_INSTALL_HOME=/opt/sag/products 
