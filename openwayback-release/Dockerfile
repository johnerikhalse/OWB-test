FROM tomcat:7-jre8
MAINTAINER John Erik Halse <johnerikhalse@gmail.com>

RUN rm -rf /usr/local/tomcat/webapps/*

VOLUME ["/tmp/openwayback"]

ENV WAYBACK_URL_SCHEME http
ENV WAYBACK_URL_HOST localhost
ENV WAYBACK_URL_PORT 80
ENV WAYBACK_URL_PREFIX http://localhost:80

COPY server.xml conf/server.xml

RUN wget "http://search.maven.org/remotecontent?filepath=org/netpreserve/openwayback/openwayback-dist/2.2.0/openwayback-dist-2.2.0.tar.gz" -O - | \
    tar zxv; \
    mv openwayback/openwayback-2.2.0.war webapps/ROOT.war
