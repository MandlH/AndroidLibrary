# Use the official Nginx image as the base image
FROM nginx:alpine

# Remove the default Nginx configuration
RUN rm -f /etc/nginx/conf.d/*

# Copy the APK file to the default Nginx html directory
COPY app/build/outputs/apk/debug/app-debug.apk /usr/share/nginx/html/

# Expose port 80 for serving the APK file
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
