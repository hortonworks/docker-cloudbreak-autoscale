FROM java:openjdk-8
MAINTAINER SequenceIQ

# Install starter script for the Periscope application
COPY bootstrap/start_periscope_app.sh /start_periscope_app.sh

# Install zip
RUN apt-get update
RUN apt-get install zip

ENV VERSION 1.10.0-dev.prometh
# install the periscope app
ADD https://cloudbreak.s3.amazonaws.com/periscope.jar /periscope.jar

# extract schema files
RUN unzip periscope.jar schema/* -d /

WORKDIR /

ENTRYPOINT ["/start_periscope_app.sh"]
