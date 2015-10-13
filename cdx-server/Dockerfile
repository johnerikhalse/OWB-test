FROM tomcat:7-jre8
MAINTAINER John Erik Halse <johnerikhalse@gmail.com>

RUN rm -rf /usr/local/tomcat/webapps/*

VOLUME ["/tmp"]

ENV WAYBACK_URL_SCHEME http
ENV WAYBACK_URL_HOST localhost
ENV WAYBACK_URL_PORT 8080
ENV WAYBACK_URL_PREFIX http://localhost:8080

COPY ROOT /usr/local/tomcat/webapps/ROOT/
COPY overrides /usr/local/tomcat/webapps/ROOT/
