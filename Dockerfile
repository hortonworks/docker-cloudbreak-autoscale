FROM java:openjdk-8
MAINTAINER SequenceIQ

# Install starter script for the Periscope application
COPY bootstrap/start_periscope_app.sh /start_periscope_app.sh

# Install zip
RUN apt-get update
RUN apt-get install zip

ENV VERSION 1.13.0-dev.60
# install the periscope app
ADD https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/periscope/$VERSION/periscope-$VERSION.jar /periscope.jar

# extract schema files
RUN unzip periscope.jar schema/* -d /

WORKDIR /

ENTRYPOINT ["/start_periscope_app.sh"]
