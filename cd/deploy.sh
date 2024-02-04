#!/bin/bash

BRANCH=$(git branch --show-current)
IMAGE_NAME="mandlh/android-library"

BLUE_TAG="blue"
GREEN_TAG="green"

if [ "$BRANCH" == "main" ] || [ "$BRANCH" == "env_testing" ]; then
  echo "Deploying to Blue environment..."
  docker build -t $IMAGE_NAME:$BLUE_TAG .

  docker stop $IMAGE_NAME-green || true
  docker rm $IMAGE_NAME-green || true

  docker run -d --name $IMAGE_NAME-blue $IMAGE_NAME:$BLUE_TAG

  # Wait for the container to be in the 'running' state
  while [ "$(docker inspect -f '{{.State.Status}}' $IMAGE_NAME-blue)" != "running" ]; do
      sleep 1
  done

  # Download the APK artifacts from the running container
  docker cp $IMAGE_NAME-blue:/usr/share/nginx/html/app-debug.apk /tmp/artifacts
  cp /tmp/artifacts/app-debug.apk /usr/share/nginx/html/recommended.apk

  docker push $IMAGE_NAME:$BLUE_TAG

  # Cleanup
  docker stop $IMAGE_NAME-blue || true
  docker rm $IMAGE_NAME-blue || true

elif [ "$BRANCH" == "env_prod" ]; then
  echo "Deploying to Green environment (Production)..."
  docker build -t $IMAGE_NAME:$GREEN_TAG .

  docker stop $IMAGE_NAME-blue || true
  docker rm $IMAGE_NAME-blue || true

  docker run -d --name $IMAGE_NAME-green $IMAGE_NAME:$GREEN_TAG

  # Wait for the container to be in the 'running' state
  while [ "$(docker inspect -f '{{.State.Status}}' $IMAGE_NAME-green)" != "running" ]; do
      sleep 1
  done

  # Download the APK artifacts from the running container
  docker cp $IMAGE_NAME-green:/usr/share/nginx/html/app-debug.apk /tmp/artifacts
  cp /tmp/artifacts/app-debug.apk /usr/share/nginx/html/latest.apk

  docker push $IMAGE_NAME:$GREEN_TAG

  # Cleanup
  docker stop $IMAGE_NAME-green || true
  docker rm $IMAGE_NAME-green || true

else
  echo "Unsupported branch for deployment."
  exit 1
fi
