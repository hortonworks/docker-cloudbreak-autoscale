Periscope on Docker
==========

This repository contains a Docker file to build a Docker image containing Periscope binary and DB schema scripts.
The Periscope source code is available on [GitHub](https://github.com/sequenceiq/periscope).

## Pull the image from Docker Repository
```
docker pull sequenceiq/periscope:0.5.3
```

## Building the image
```
docker build --rm -t sequenceiq/periscope:0.5.3 .
```

## Building custom version
```
sed 's/ENV VERSION.*/ENV VERSION 0.5.3/' Dockerfile > Dockerfile.custom
docker build -f Dockerfile.custom --rm -t  sequenceiq/cloudbreak:custom-0.5.3 .
```

## Running the image
It is intended to run only with [Cloudbreak Deployer](https://github.com/sequenceiq/cloudbreak-deployer).
