# Use a base image with OpenJDK 11 and Android SDK
FROM openjdk:11-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the necessary files for dependency resolution
COPY build.gradle settings.gradle gradlew /app/
COPY gradle /app/gradle

# Add executable permissions to gradlew
RUN chmod +x ./gradlew && ./gradlew assembleDebug

# Download dependencies to cache them in Docker layer
RUN ./gradlew --version

# Copy the entire project
COPY . /app/

# Build the Android app
RUN ./gradlew assembleDebug

# Start the Android app (adjust the path and command based on your app structure)
CMD ["adb", "install", "-r", "app/build/outputs/apk/debug/app-debug.apk"]
