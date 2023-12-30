FROM openjdk:11-jre-slim

WORKDIR /app

COPY utils/build/outputs/aar/utils-debug.aar /app/libs/utils-debug.aar
COPY app/build/outputs/apk/debug/app-debug.apk /app/app-debug.apk

CMD ["java", "-jar", "app-debug.apk"]
