#!/bin/bash

# Check if the Dockerfile exists in the current directory
if [ ! -f "Dockerfile" ]; then
  echo "Dockerfile not found in the current directory."
  exit 1
fi

BRANCH=$(git rev-parse --abbrev-ref HEAD)
IMAGE_NAME="mandlh/android-library"
BLUE_TAG="blue"
GREEN_TAG="green"

# Create a temporary directory for the build context
# Avoid modifying the original files during build process
TEMP_DIR=$(mktemp -d)

# Copy Dockerfile and necessary files to the temporary directory
cp Dockerfile $TEMP_DIR/
cp -r app $TEMP_DIR/

echo "You are in the $BRANCH branch"

if [[ "$BRANCH" == "env_testing" ]]; then
  echo "Building and pushing image for Blue environment..."
  docker build -t $IMAGE_NAME:$BLUE_TAG $TEMP_DIR
  docker push $IMAGE_NAME:$BLUE_TAG

elif [ "$BRANCH" == "env_prod" ]; then
  echo "Building and pushing image for Green environment (Production)..."
  docker build -t $IMAGE_NAME:$GREEN_TAG $TEMP_DIR
  docker push $IMAGE_NAME:$GREEN_TAG

else
  echo "Unsupported branch for deployment."
  exit 1
fi


# Remove the temporary directory
rm -rf $TEMP_DIR
