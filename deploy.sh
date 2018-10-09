#!/bin/bash

set -eo pipefail
if [[ "$TRACE" ]]; then
    : ${START_TIME:=$(date +%s)}
    export START_TIME
    export PS4='+ [TRACE $BASH_SOURCE:$LINENO][ellapsed: $(( $(date +%s) -  $START_TIME ))] '
    set -x
fi

debug() {
  [[ "$DEBUG" ]] && echo "-----> $*" 1>&2 || :
}


new_version() {

  declare VERSION_TYPE="$(echo ${VERSION} | awk -F"-" '{ print $2 }' | awk -F"." '{ print $1 }')"

  declare VERSION_BRANCH="master"
  if [[ "$VERSION_TYPE" = "rc" ]]; then
    VERSION_BRANCH="$(echo ${VERSION} | awk -F"." '{ print "rc-"$1"."$2 }')"
  elif [[ "$VERSION_TYPE" = "" ]]; then
    VERSION_BRANCH="$(echo ${VERSION} | awk -F"." '{ print "release-"$1"."$2 }')"
  fi

  debug "checking out branch: $VERSION_BRANCH"

  git checkout ${VERSION_BRANCH}

  debug "building docker image for version: $VERSION"
  sed -i "/^ENV VERSION/ s/VERSION .*/VERSION ${VERSION}/" Dockerfile

  git commit -m "Release ${VERSION}" Dockerfile
  git tag ${VERSION}
  git push origin ${VERSION_BRANCH} --tags
  
  # Build docker and push to hortonworks repo
  docker build -t ${DOCKER_IMAGE}:${VERSION} --build-arg=REPO_URL=${REPO_URL} --build-arg=VERSION=${VERSION} .
  docker push ${DOCKER_IMAGE}:${VERSION}
  docker rmi ${DOCKER_IMAGE}:${VERSION}

}

main() {
  : ${VERSION:?"required!"}
  : ${DOCKER_IMAGE:?"required!"}
  : ${DOCKERHUB_USERNAME:?"required!"}
  : ${DOCKERHUB_PASSWORD:?"required!"}
  : ${DEBUG:=1}
  : ${REPO_URL:?"required!"}

  new_version "$@"
}

[[ "$0" ==  "$BASH_SOURCE" ]] && main "$@"
