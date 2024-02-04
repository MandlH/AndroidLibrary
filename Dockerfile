# Use a base image with OpenJDK 11 and Android SDK
FROM openjdk:11-jdk-slim

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

# Blue-Green Deployment Script
COPY cd/deploy.sh /app/deploy.sh
RUN chmod +x /app/deploy.sh

# Install Android SDK
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends unzip curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /android-sdk \
    && curl -L https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -o /android-sdk/sdk-tools-linux.zip \
    && unzip -qq /android-sdk/sdk-tools-linux.zip -d /android-sdk \
    && rm /android-sdk/sdk-tools-linux.zip \
    && yes | /android-sdk/tools/bin/sdkmanager --licenses

# Set Android SDK environment variables
ENV ANDROID_HOME /android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# Build the Android app
RUN chmod +x /app/gradlew
RUN /app/gradlew assembleDebug

EXPOSE 8080

# Start the Android app with Blue-Green deployment
CMD ["/app/deploy.sh"]
