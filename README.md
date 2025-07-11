# BTG Funds Management Frontend

This is the Flutter frontend for the BTG Funds Management application. It provides a responsive interface for managing FPV/FIC funds for BTG clients.

## Architecture

The project follows Clean Architecture principles with Atomic Design for UI components:

- **Core**: Contains constants, utilities, error handling, and reusable widgets
- **Features**: Each feature follows the Clean Architecture pattern with data, domain, and presentation layers
- **Navigation**: Uses GoRouter for Navigator 2.0 implementation
- **Localization**: Supports English and Spanish languages

## Setup and Installation

```bash
# Install dependencies
flutter pub get

# Generate Riverpod providers
flutter pub run build_runner build --delete-conflicting-outputs

# Run the application in debug mode
flutter run -d chrome  # For web
flutter run -d <device-id>  # For mobile devices
```

## Docker Build

To build the Docker image:

```bash
docker build -t btg-funds-frontend .
```

To run the Docker container:

```bash
docker run -p 80:80 btg-funds-frontend
```

## Features

- View list of available funds
- View fund details
- Subscribe to funds
- Cancel subscriptions
- View transaction history
- Settings and preferences

## Responsive Design

The application is designed to be responsive and work on both web and mobile platforms using:

- ScreenUtilInit for responsive sizing
- LayoutBuilder for adaptive layouts
- Different UI components for web and mobile when needed
