export MAVEN_METADATA_URL = maven.sequenceiq.com/releases/com/sequenceiq/periscope/maven-metadata.xml

dockerhub:
	./deploy.sh $(VERSION)
