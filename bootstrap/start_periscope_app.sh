#!/bin/bash

[[ "$TRACE" ]] && set -x
: ${SECURE_RANDOM:=true}
: ${EXPOSE_JMX_METRICS:=false}
: ${EXPOSE_JMX_METRICS_PORT:=20105}
: ${EXPOSE_JMX_METRICS_CONFIG:=config.yaml}

echo "Starting the Periscope application..."

if [ -n "$CERT_URL" ]; then
  curl -O $CERT_URL && keytool -import -noprompt -trustcacerts -file sequenceiq.com.crt -alias "sequenceiq" -keystore /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/security/cacerts -storepass changeit
fi

if [ "$SECURE_RANDOM" == "false" ]; then
  CB_JAVA_OPTS="$CB_JAVA_OPTS -Djava.security.egd=file:/dev/./urandom"
fi

if [ "$EXPOSE_JMX_METRICS" == "true" ]; then
  CB_JAVA_OPTS="$CB_JAVA_OPTS -javaagent:/jmx_prometheus_javaagent=127.0.0.1:$EXPOSE_JMX_METRICS_PORT:$EXPOSE_JMX_METRICS_CONFIG"
fi

java $CB_JAVA_OPTS -jar /periscope.jar
