#!/bin/bash

#Retrieve the latest git commit hash
TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t mindstreamorg/kr8sswordz:$TAG -f applications/kr8sswordz-pages/Dockerfile applications/kr8sswordz-pages

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push mindstreamorg/kr8sswordz:$TAG

#Stop the registry proxy
docker stop socat-registry

# Create the deployment and service for the front end aka kr8sswordz
sed 's#mindstreamorg/kr8sswordz:latest#mindstreamorg/kr8sswordz:'$TAG'#' applications/kr8sswordz-pages/k8s/deployment.yaml | kubectl apply -f -
