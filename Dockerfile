FROM hortonworks/hwx_openjdk:10-jdk-slim
MAINTAINER Hortonworks

# REPO URL to download jar
ARG REPO_URL=http://repo.hortonworks.com/content/repositories/releases
ARG VERSION=''

# Install starter script for the Periscope application
COPY bootstrap/start_periscope_app.sh /start_periscope_app.sh

# Install zip
RUN apt-get update --no-install-recommends && apt-get install -y zip procps

ENV VERSION ${VERSION}
# install the periscope app
ADD ${REPO_URL}/com/sequenceiq/periscope/$VERSION/periscope-$VERSION.jar /periscope.jar

# add jmx exporter
ADD jmx_prometheus_javaagent-0.10.jar /jmx_prometheus_javaagent.jar

# extract schema files
RUN ( unzip periscope.jar schema/* -d / ) || \
    ( unzip periscope.jar BOOT-INF/classes/schema/* -d /tmp/ && mv /tmp/BOOT-INF/classes/schema/ /schema/ )

WORKDIR /

ENTRYPOINT ["/start_periscope_app.sh"]
