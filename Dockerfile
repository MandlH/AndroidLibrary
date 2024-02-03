# Use a base image with OpenJDK 11 and Android SDK
FROM openjdk:11-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the necessary files for dependency resolution
COPY build.gradle settings.gradle gradlew /app/
COPY gradle /app/gradle

# Add executable permissions to gradlew
RUN chmod +x ./gradlew

# Download dependencies to cache them in Docker layer
# It's a good practice to run dependencies separately to leverage Docker's caching mechanism
RUN ./gradlew --version

# Copy the entire project
COPY . /app/

# Build the Android app
RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"
RUN ./gradlew assembleDebug

# Start the Android app (update this according to your actual app structure)
CMD ["adb", "install", "-r", "app/build/outputs/apk/debug/app-debug.apk"]
