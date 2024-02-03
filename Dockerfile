# Use a base image with OpenJDK 11 and Android SDK
FROM openjdk:11-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the necessary files for dependency resolution
COPY build.gradle settings.gradle gradlew /app/
COPY gradle /app/gradle

# Download dependencies to cache them in Docker layer
RUN ./gradlew --version

# Add executable permissions to gradlew
RUN chmod +x ./gradlew

# Copy the entire project
COPY . /app/

# Build the Android app
RUN ./gradlew assembleDebug

# Expose any necessary ports
EXPOSE 8080

# Start the Android app
CMD ["java", "-jar", "app/build/outputs/apk/debug/app-debug.apk"]
