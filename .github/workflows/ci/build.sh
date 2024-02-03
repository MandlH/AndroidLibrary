#!/bin/bash

# Grant execute permissions to gradlew
chmod +x ./gradlew

# Build APK, Install dependencies
./gradlew :app:assembleDebug