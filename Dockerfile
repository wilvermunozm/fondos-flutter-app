FROM ubuntu:22.04 AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk-headless \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter
ENV FLUTTER_HOME=/flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME -b stable
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Run basic check to download Dart SDK
RUN flutter doctor

# Copy project files
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build web app
RUN flutter build web --release

# Use Nginx to serve the web app
FROM nginx:stable-alpine

# Copy the build output to the nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
