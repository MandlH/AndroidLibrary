#!/bin/bash

# Script to deploy the Dockerized app with Blue-Green deployment strategy
BRANCH=$(git branch --show-current)
IMAGE_NAME="androidlibrary" 

BLUE_TAG="blue"
GREEN_TAG="green"

if [ "$BRANCH" == "main" ] || [ "$BRANCH" == "env_testing" ]; then
  echo "Deploying to Blue environment..."
  docker build -t $IMAGE_NAME:$BLUE_TAG .
  docker stop $IMAGE_NAME-green || true
  docker run -d -p 8080:8080 --name $IMAGE_NAME-blue $IMAGE_NAME:$BLUE_TAG
  docker rm $IMAGE_NAME-green || true
elif [ "$BRANCH" == "env_prod" ]; then
  echo "Deploying to Green environment (Production)..."
  docker build -t $IMAGE_NAME:$GREEN_TAG .
  docker stop $IMAGE_NAME-blue || true
  docker run -d -p 8080:8080 --name $IMAGE_NAME-green $IMAGE_NAME:$GREEN_TAG
  docker rm $IMAGE_NAME-blue || true
else
  echo "Unsupported branch for deployment."
  exit 1
fi
