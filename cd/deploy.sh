#!/bin/bash

BRANCH=$(git branch --show-current)
IMAGE_NAME="mandlh/android-library"

BLUE_TAG="blue"
GREEN_TAG="green"

if [ "$BRANCH" == "main" ] || [ "$BRANCH" == "env_testing" ]; then
  echo "Deploying to Blue environment..."
  docker build -t $IMAGE_NAME:$BLUE_TAG .
  docker stop $IMAGE_NAME-green || true
  docker run -d --name $IMAGE_NAME-blue $IMAGE_NAME:$BLUE_TAG

  # Download the APK artifacts from CI
  docker cp $(docker create $IMAGE_NAME:$BLUE_TAG):/usr/share/nginx/html/app-debug.apk /tmp/artifacts
  cp /tmp/artifacts/app-debug.apk /usr/share/nginx/html/recommended.apk

  docker rm $IMAGE_NAME-green || true
  docker push $IMAGE_NAME:$BLUE_TAG

elif [ "$BRANCH" == "env_prod" ]; then
  echo "Deploying to Green environment (Production)..."
  docker build -t $IMAGE_NAME:$GREEN_TAG .
  docker stop $IMAGE_NAME-blue || true
  docker run -d --name $IMAGE_NAME-green $IMAGE_NAME:$GREEN_TAG

  # Download the APK artifacts from CI
  docker cp $(docker create $IMAGE_NAME:$GREEN_TAG):/usr/share/nginx/html/app-debug.apk /tmp/artifacts
  cp /tmp/artifacts/app-debug.apk /usr/share/nginx/html/latest.apk

  docker rm $IMAGE_NAME-blue || true
  docker push $IMAGE_NAME:$GREEN_TAG

else
  echo "Unsupported branch for deployment."
  exit 1
fi
