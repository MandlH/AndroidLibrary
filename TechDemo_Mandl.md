# CI/CD GitHub - Mandl Harald

In this brief TechDemo, I demonstrate how to build, test, generate APKs, and package an Android app and library using GitHub Actions. The resulting APK and AAR files are then incorporated into a Docker image and pushed to a public docker repo.

- Github Repo: https://github.com/MandlH/AndroidLibrary
- Docker Repo: https://hub.docker.com/repository/docker/mandlh/android-library/general

**For reasons I do not understand, building and pushing to Docker fails (The error message suggests that the image push was successful, but there might be some confusion or delay in recognizing the pushed image locally.) However, the push was successful, and the image is present on the Docker repository and can be pulled**

**If you want to check out the workflox with docker implementation please checkout the docker-test branch**


- What is GitHub Actions?   
Platform to automate developer workflows

- How GitHub Actions automate these workflows?   
When something happens in or to your repository   
automatic actions are executed in response


### 1. Project
Create a project or use an existing project

### 2. Build.gradle
Include the library to the project
```Kotlin
implementation project(':utils')
```

### 3. Repository
Create a branch and push the project

### 4. Actions
Move to the Actions Tab on GitHub   
Here you can choose between some workflow templates   
In this Demo we create a Android project with Gradle so we could chose the 'Android CI' Template or do it all by scratch

### 5. Syntax of Workflow File   

Name of the workflow
```Yaml
name: Android CI
```

This section defines when the workflow should be triggered.   
It triggers on pushes to the specified branches (main and docker-test).   
It also triggers on pull requests targeting the specified branches.
```Yaml
on:
  push:
    branches:
      - main
      - docker-test
  pull_request:
    branches:
      - main
      - docker-test
```

This section defines the jobs that will be executed as part of the workflow.   
Build-and-deploy is the name of the job. It specifies that the job will run on the latest version of the Ubuntu environment.   
Steps section lists the individual steps that the job will perform.
The use of the Checkout repository perform a predefined indivual action.   
Set up JDK 11 sets up Java Development Kit (JDK) version 11 using the actions/setup-java action. It also specifies caching for the Gradle dependencies.
```Yaml
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up JDK 11
      uses: actions/setup-java@v3
      with:
        java-version: '11'
        distribution: 'temurin'
        cache: gradle
```
This step grants execute permissions to the Gradle wrapper script (gradlew).
```Yaml
    - name: Grant execute permissions to gradlew
      run: chmod +x ./gradlew
```

This step runs the Gradle build process using the ./gradlew build command.
```Yaml
    - name: Build with Gradle
      run: ./gradlew build
```

This step runs unit tests for a module named "utils" using the ./gradlew :utils:testDebugUnitTest command.
```Yaml
    - name: Run Utils Tests
      run: ./gradlew :utils:testDebugUnitTest
```

This step assembles the debug version of the Android application using the ./gradlew :app:assembleDebug command.
```Yaml
    - name: Build APK
      run: ./gradlew :app:assembleDebug
```

This step updates the Docker package in the Ubuntu environment. (Ubuntu already has docker installed for windows or mac it could be that you have to install docker before)
```Yaml
    - name: Update Docker
      run: sudo apt-get update && sudo apt-get install -y docker-ce
```

This step sets up Docker Buildx using the docker/setup-buildx-action action.
```Yaml
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1
```

This step builds a Docker image, specifying the platform as both linux/amd64 and linux/arm64.
It uses Docker credentials (username and password) stored as secrets to log in and push the image to a Docker registry.
The image is tagged as mandlh/android-library:latest.
Don't forget to add the DOCKER_USERNAME and DOCKER_PASSWORD to your repo secrets
```Yaml
    - name: Build and push Docker image
      env:
        DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
      run: |
        docker buildx create --use
        docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
        docker buildx build --platform linux/amd64,linux/arm64 -t mandlh/android-library:latest -f Dockerfile . --output type=registry
        docker push mandlh/android-library:latest
```
