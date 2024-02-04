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

# Build the Android app
RUN /app/gradlew assembleDebug

# Blue-Green Deployment Script
COPY cd/deploy.sh /app/deploy.sh
RUN chmod +x /app/deploy.sh

EXPOSE 8080

# Start the Android app with Blue-Green deployment
CMD ["/app/deploy.sh"]
