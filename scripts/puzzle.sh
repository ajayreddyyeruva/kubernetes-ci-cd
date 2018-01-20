#!/bin/bash

#Retrieve the latest git commit hash
TAG=`git rev-parse --short HEAD` 

#Build the docker image
docker build -t mindstreamorg/puzzle:$TAG -f applications/puzzle/Dockerfile applications/puzzle

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push mindstreamorg/puzzle:$TAG

# Create the deployment and service for the puzzle server aka puzzle
sed 's#mindstreamorg/puzzle:latest#mindstreamorg/puzzle:'$TAG'#' applications/puzzle/k8s/deployment.yaml | kubectl apply -f -
