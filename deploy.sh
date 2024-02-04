#!/bin/bash

# Check if the Dockerfile exists in the current directory
if [ ! -f "Dockerfile" ]; then
  echo "Dockerfile not found in the current directory."
  exit 1
fi

BRANCH=$(git branch --show-current)
IMAGE_NAME="mandlh/android-library"

BLUE_TAG="blue"
GREEN_TAG="green"

if [ "$BRANCH" == "main" ] || [ "$BRANCH" == "env_testing" ]; then
  echo "Building and pushing image for Blue environment..."
  docker build -t $IMAGE_NAME:$BLUE_TAG .
  docker push $IMAGE_NAME:$BLUE_TAG

elif [ "$BRANCH" == "env_prod" ]; then
  echo "Building and pushing image for Green environment (Production)..."
  docker build -t $IMAGE_NAME:$GREEN_TAG .
  docker push $IMAGE_NAME:$GREEN_TAG

else
  echo "Unsupported branch for deployment."
  exit 1
fi
