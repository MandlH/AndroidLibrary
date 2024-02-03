#!/bin/bash

# Script to deploy the Dockerized app to Blue or Green environment based on Git branch
BRANCH=$(git branch --show-current)
IMAGE_NAME="androidlibrary"  # Adjust the repository name as needed

if [ "$BRANCH" == "main" ] || [ "$BRANCH" == "env_testing" ]; then
  echo "Deploying to Blue environment..."
  docker build -t $IMAGE_NAME:blue .
elif [ "$BRANCH" == "env_prod" ]; then
  echo "Deploying to Green environment (Production)..."
  docker build -t $IMAGE_NAME:green .
else
  echo "Unsupported branch for deployment."
  exit 1
fi
