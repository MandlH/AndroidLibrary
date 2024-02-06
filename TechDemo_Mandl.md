# CI/CD GitHub - Mandl Harald

In this brief TechDemo, I demonstrate how to build, test, generate APKs, and package an Android app and library using GitHub Actions. The resulting APK and AAR files are then incorporated into a Docker image and pushed to a public docker repo.

- Github Repo: https://github.com/MandlH/AndroidLibrary
- Docker Repo: https://hub.docker.com/repository/docker/mandlh/android-library/general

## Android CI

The following GitHub Actions workflow is designed for continuous integration on the Android platform.

```yaml
on:
  push:
    branches:
      - main
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        os: [ubuntu-latest]

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: gradle

      - name: Grant execute permissions to gradlew
        run: chmod +x ./gradlew

      - name: Build with Gradle
        run: ./gradlew build

      - name: Run Utils Tests
        run: ./gradlew :utils:testDebugUnitTest

      - name: Archive Artifacts
        uses: actions/upload-artifact@v2
        with:
          name: app-artifact
          path: app/build/outputs/apk/debug/
```

This workflow is triggered on pushes to the main branch and on pull requests. It runs on the latest version of Ubuntu and utilizes JDK 11 for the build process. The steps include checking out the repository, setting up the JDK, granting execute permissions to gradlew, building with Gradle, running unit tests for Utils, and finally archiving the resulting APK artifact.

## Android CD

The following GitHub Actions workflow is designed for continuous deployment (CD) on the Android platform.

```yaml
on:
  push:
    branches:
      - env_testing
      - env_prod
  pull_request:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
          cache: gradle

      - name: Grant execute permissions to gradlew
        run: chmod +x ./gradlew

      - name: Build with Gradle
        run: ./gradlew build

      - name: Run Utils Tests
        run: ./gradlew :utils:testDebugUnitTest 

      - name: Login to Docker Hub
        run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Grant execute permissions to deploy.sh
        run: chmod +x deploy.sh

      - name: Deploy to Blue-Green
        run: ./deploy.sh
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
```
This workflow is triggered on pushes to the env_testing and env_prod branches and on pull requests. It runs on the latest version of Ubuntu and utilizes JDK 11 for the build process. The steps include checking out the repository, setting up the JDK, granting execute permissions to gradlew, building with Gradle, running unit tests for Utils, logging in to Docker Hub, granting execute permissions to deploy.sh, and finally deploying to a Blue-Green environment using the provided script. The Docker Hub credentials are securely passed as secrets.

## Deployment Script

```BASH
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
```

This Bash script checks for the existence of a Dockerfile, determines the current branch, and performs specific Docker image builds and pushes based on the branch (either env_testing or env_prod). The script uses temporary directories to avoid modifying the original files during the build process. Finally, it cleans up the temporary directory after the build and push operations.

## Dockerfile

```Docker
# Use the official Nginx image as the base image
FROM nginx:alpine

# Create a directory to store the APK files
RUN mkdir -p /usr/share/nginx/html/

# Copy the APK file into the image
COPY app/build/outputs/apk/debug/app-debug.apk /usr/share/nginx/html/

# Expose port 80 for serving the APK files
EXPOSE 80
```

This Dockerfile sets up an Nginx container based on the Alpine Linux image. It creates a directory to store APK files, copies the app-debug.apk file into that directory, and exposes port 80 for serving the APK files. This Dockerfile is suitable for hosting and serving an Android application package (APK) using Nginx.