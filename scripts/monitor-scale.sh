#!/bin/bash

#Retrieve the latest git commit hash
TAG=`git rev-parse --short HEAD` 

#Build the docker image
docker build -t mindstreamorg/monitor-scale:$TAG -f applications/monitor-scale/Dockerfile applications/monitor-scale

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push mindstreamorg/monitor-scale:$TAG

# Create the deployment and service for the monitor-scale node server
sed 's#mindstreamorg/monitor-scale:latest#mindstreamorg/monitor-scale:'$TAG'#' applications/monitor-scale/k8s/deployment.yaml | kubectl apply -f -
