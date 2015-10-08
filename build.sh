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

OWB=$1
POM=${OWB}/pom.xml

if [ ! -f ${POM} ]; then
    echo "The path '${OWB}' does not point to an Open Wayback source tree"
    usage
fi

ARTIFACT=`xpath -q -e "/project/artifactId/text()" ${POM}`
if [ "${ARTIFACT}" != "openwayback" ]; then
    echo "The path '${OWB}' does not point to an Open Wayback source tree"
    usage
fi

VERSION=`xpath -q -e "/project/version/text()" ${POM}`

echo Compiling Open Wayback v.${VERSION} at ${OWB}

## BUILD OWB
cd $OWB
mvn -Dmaven.test.skip=true -Dmaven.javadoc.skip=true install
cd ${OPWD}


## BUILD DOCKER IMAGE
cp ${OWB}/wayback-webapp/target/openwayback-${VERSION}.war .
mkdir ROOT
cd ROOT
jar xvf ../openwayback-${VERSION}.war
cd ..
rm openwayback-${VERSION}.war

sudo docker build -t johnh/openwayback:${VERSION} .

rm -rf ROOT


## RUN DOCKER IMAGE
sudo docker run --rm -it -v /tmp/warc-files:/tmp/openwayback -p 8080:8080 johnh/openwayback:${VERSION}

cd ${OPWD}
