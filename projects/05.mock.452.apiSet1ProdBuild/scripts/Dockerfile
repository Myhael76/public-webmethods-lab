ARG SRC_IMG=msr-lean-jre-1005:last-build
FROM ${SRC_IMG}

ARG IS_HOME=/opt/sag/products/IntegrationServer
ARG SAG_UID=1724
ARG SAG_GID=1724

COPY --chown=${SAG_UID}:${SAG_GID} ./packages/ ${IS_HOME}/packages/

ENTRYPOINT ${IS_HOME}/bin/startContainer.sh