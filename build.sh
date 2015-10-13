#!/bin/bash

OPWD=`pwd`

function usage {
    echo "Usage: build.sh <path to OpenWayback>"
    cd ${OPWD}
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

SOURCE=$1
POM=${SOURCE}/pom.xml

if [ ! -f ${POM} ]; then
    echo "The path '${SOURCE}' does not point to an Open Wayback source tree"
    usage
fi

ARTIFACT=`xpath -q -e "/project/artifactId/text()" ${POM}`
if [ "${ARTIFACT}" != "openwayback" ]; then
    echo "The path '${SOURCE}' does not point to an Open Wayback source tree"
    usage
fi

VERSION=`xpath -q -e "/project/version/text()" ${POM}`

echo Compiling Open Wayback v.${VERSION} at ${SOURCE}

## BUILD OWB
cd $SOURCE
mvn -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -am -pl :openwayback-cdx-server-webapp,:openwayback-webapp install


## BUILD OWB DOCKER IMAGE
cd ${OPWD}/openwayback
cp ${SOURCE}/wayback-webapp/target/openwayback-${VERSION}.war .
mkdir ROOT
cd ROOT
jar xvf ../openwayback-${VERSION}.war
cd ..
rm openwayback-${VERSION}.war

sudo docker build -t johnh/openwayback:${VERSION} .

rm -rf ROOT


## BUILD CDX-SERVER DOCKER IMAGE
cd ${OPWD}/cdx-server
cp ${SOURCE}/wayback-cdx-server-webapp/target/openwayback-cdx-server-${VERSION}.war .
mkdir ROOT
cd ROOT
jar xvf ../openwayback-cdx-server-${VERSION}.war
cd ..
rm openwayback-cdx-server-${VERSION}.war

sudo docker build -t johnh/openwayback-cdx-server:${VERSION} .

rm -rf ROOT


## RUN DOCKER IMAGE
#sudo docker run --rm -it -v /tmp/warc-files:/tmp/openwayback -p 8080:8080 johnh/openwayback:${VERSION}
sudo docker run --rm -it -v /tmp/warc-files:/tmp -p 8080:8080 johnh/openwayback-cdx-server:${VERSION}

cd ${OPWD}
