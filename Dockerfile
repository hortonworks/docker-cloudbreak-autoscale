FROM java:openjdk-8
MAINTAINER SequenceIQ

# Install starter script for the Periscope application
COPY bootstrap/start_periscope_app.sh /start_periscope_app.sh

# Install zip
RUN apt-get update
RUN apt-get install zip

ENV VERSION 2.3.0-rc.4
# install the periscope app
ADD https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/periscope/$VERSION/periscope-$VERSION.jar /periscope.jar

# add jmx exporter
ADD https://s3.eu-central-1.amazonaws.com/hortonworks-prometheus/jmx_prometheus_javaagent-0.10.jar /jmx_prometheus_javaagent.jar

# extract schema files
RUN ( unzip periscope.jar schema/* -d / ) || \
    ( unzip periscope.jar BOOT-INF/classes/schema/* -d /tmp/ && mv /tmp/BOOT-INF/classes/schema/ /schema/ )

WORKDIR /

ENTRYPOINT ["/start_periscope_app.sh"]
