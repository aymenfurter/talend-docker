FROM openjdk:8-alpine
MAINTAINER Aymen Furter <aymen.furter+docker@gmail.com>

ENV USER trun
ENV APPUID 8181
ENV JAVA_XMX 256m
ENV EXEC exec

RUN addgroup -S -g $APPUID $USER; \
    adduser -S -u $APPUID -g $USER $USER

RUN apk add --update bash zip unzip jq curl && rm -rf /var/cache/apk/*

COPY tos.zip /tmp/tos.zip

RUN cd tmp \ 
    && unzip -q /tmp/tos.zip \
    && rm /tmp/tos.zip \
    && mkdir -p /opt/ \
    && mv /tmp/Runtime_ESBSE/container /opt/trun \
    && rm -r /tmp/Runtime_ESBSE \
    && rm -r /tmp/Studio \
    && mkdir -p /opt/trun/data /opt/trun/data/log \
    && chown -R $USER.$USER /opt/trun \
    && chmod 777 /opt/trun/data \
    && chmod 777 /opt/trun/data/log
 #  && echo org.ops4j.pax.url.mvn.defaultRepositories = file:///opt/maven/repository@id=local.app@snapshots  >> /opt/trun/etc/org.ops4j.pax.url.mvn.cfg

EXPOSE 1099 8101 44444 8040 9001

USER $USER

ENTRYPOINT ["/opt/trun/bin/trun"] 

