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
  echo "Deploying to Blue environment..."
  docker build -t $IMAGE_NAME:$BLUE_TAG .
  docker stop $IMAGE_NAME-green || true
  docker run -d -p 8080:80 --name $IMAGE_NAME-blue $IMAGE_NAME:$BLUE_TAG

  # Download the APK artifacts from CI
  docker cp $(docker create $IMAGE_NAME:$BLUE_TAG):/github/workspace/app-artifact /tmp/artifacts
  cp /tmp/artifacts/app-debug.apk /usr/share/nginx/html/recommended.apk

  docker rm $IMAGE_NAME-green || true
  docker push $IMAGE_NAME:$BLUE_TAG

elif [ "$BRANCH" == "env_prod" ]; then
  echo "Deploying to Green environment (Production)..."
  docker build -t $IMAGE_NAME:$GREEN_TAG .
  docker stop $IMAGE_NAME-blue || true
  docker run -d -p 8080:80 --name $IMAGE_NAME-green $IMAGE_NAME:$GREEN_TAG

  # Download the APK artifacts from CI
  docker cp $(docker create $IMAGE_NAME:$GREEN_TAG):/github/workspace/app-artifact /tmp/artifacts
  cp /tmp/artifacts/app-debug.apk /usr/share/nginx/html/latest.apk

  docker rm $IMAGE_NAME-blue || true
  docker push $IMAGE_NAME:$GREEN_TAG

else
  echo "Unsupported branch for deployment."
  exit 1
fi
