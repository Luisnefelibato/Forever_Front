# ============================================
# Multi-stage Dockerfile for Flutter Application
# ============================================

# Stage 1: Build environment
FROM ubuntu:22.04 AS build-env

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set up Android SDK environment variables
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Download and install Android SDK
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm commandlinetools-linux-9477386_latest.zip

# Accept Android SDK licenses
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --licenses

# Install Android SDK packages
RUN ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0"

# Install Flutter
ENV FLUTTER_VERSION=3.16.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=$PATH:${FLUTTER_HOME}/bin

RUN git clone --branch ${FLUTTER_VERSION} --depth 1 https://github.com/flutter/flutter.git ${FLUTTER_HOME}

# Run flutter doctor to download dependencies
RUN flutter doctor -v

# Enable Flutter web and mobile
RUN flutter config --enable-web
RUN flutter config --android-sdk ${ANDROID_SDK_ROOT}

# Pre-download Flutter dependencies
RUN flutter precache

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get Flutter dependencies
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Build the Flutter application for different platforms
# Uncomment the platform you want to build for:

# For Android APK (debug)
# RUN flutter build apk --debug

# For Android App Bundle (release)
# RUN flutter build appbundle --release

# For Android APK (release)
# RUN flutter build apk --release --split-per-abi

# For iOS (requires macOS)
# RUN flutter build ios --release

# For Web
# RUN flutter build web --release

# ============================================
# Stage 2: Development environment with hot reload
# ============================================
FROM build-env AS development

WORKDIR /app

# Expose ports for Flutter web and debugging
EXPOSE 8080
EXPOSE 5000

# Default command for development (web)
CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]

# ============================================
# Stage 3: Runtime environment (for web deployment)
# ============================================
FROM nginx:alpine AS production

# Copy built web assets to nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
