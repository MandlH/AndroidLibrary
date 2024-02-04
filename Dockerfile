# Use the official Nginx image as the base image
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm -f /etc/nginx/conf.d/*

# Create a directory to store the APK files
RUN mkdir -p /usr/share/nginx/html/

# Copy the APK file into the image
COPY app/build/outputs/apk/debug/app-debug.apk /usr/share/nginx/html/

# Expose port 80 for serving the APK files
EXPOSE 80
