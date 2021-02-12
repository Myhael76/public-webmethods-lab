ARG SRC_IMAGE=wm-generic-host
FROM ${SRC_IMAGE}

#RUN mkdir -p /opt/sag/ccs-admin &&\
#	chown 1724:1724 /opt/sag/ccs-admin

#COPY --chown=1724:1724 ./ccs-admin/ /opt/sag/ccs-admin/

RUN mkdir -p /opt/sag/ccs-admin
COPY ./ccs-admin/ /opt/sag/ccs-admin/