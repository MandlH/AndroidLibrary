# Use a base image with OpenJDK 11 and Android SDK
FROM openjdk:11-jdk-slim

# Install required dependencies
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends unzip curl openjdk-11-jre-headless \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /android-sdk \
    && curl -L https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -o /android-sdk/sdk-tools-linux.zip \
    && unzip -qq /android-sdk/sdk-tools-linux.zip -d /android-sdk \
    && rm /android-sdk/sdk-tools-linux.zip \
    && yes | /android-sdk/tools/bin/sdkmanager --licenses

# Set the working directory
WORKDIR /app

# Copy the necessary files for dependency resolution
COPY build.gradle settings.gradle gradlew /app/
COPY gradle /app/gradle

# Add executable permissions to gradlew
RUN chmod +x /app/gradlew

# Download dependencies to cache them in Docker layer
RUN /app/gradlew --version

# Copy the entire project
COPY . /app/

# Build the Android app
RUN /app/gradlew assembleDebug

EXPOSE 8080

# Blue-Green Deployment Script
COPY deploy.sh /app/deploy.sh
RUN chmod +x /app/deploy.sh

# Start the Android app with Blue-Green deployment
CMD ["/app/deploy.sh"]
