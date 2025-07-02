# Flutter mise Template

This template provides a complete mise configuration for Flutter development.

## Features

- ✅ Flutter SDK management
- ✅ Android/iOS development setup
- ✅ Web development support
- ✅ Comprehensive build tasks
- ✅ Testing automation
- ✅ Code formatting and linting
- ✅ Development tools integration

## Quick Start

1. Copy this template to your Flutter project:
   ```bash
   cp templates/flutter-mise/mise.toml your-flutter-project/
   ```

   Or create a new project using the script:
   ```bash
   ./scripts/create-new-project.sh --template flutter
   # Creates project with default name: my_flutter_app

   # Or with custom name:
   ./scripts/create-new-project.sh --template flutter --name your_flutter_project
   ```

2. Navigate to your project and activate mise:
   ```bash
   cd my_flutter_app  # or your_flutter_project
   mise install
   ```

3. Setup Flutter development environment:
   ```bash
   mise run setup:android  # For Android development
   mise run setup:ios      # For iOS development (macOS only)
   mise run setup:web      # For web development
   ```

4. Verify your setup:
   ```bash
   mise run doctor
   ```

## Available Tasks

### Development
- `mise run dev` - Run Flutter app in development mode
- `mise run android` - Run on Android device/emulator
- `mise run ios` - Run on iOS device/simulator (macOS only)
- `mise run web` - Run on web browser

### Testing
- `mise run test` - Run all tests
- `mise run test:unit` - Run unit tests only
- `mise run test:widget` - Run widget tests only
- `mise run test:integration` - Run integration tests only

### Building
- `mise run build:apk` - Build Android APK
- `mise run build:appbundle` - Build Android App Bundle
- `mise run build:ios` - Build iOS app
- `mise run build:web` - Build web app

### Maintenance
- `mise run clean` - Clean build artifacts and reinstall dependencies
- `mise run deps` - Install/update dependencies
- `mise run deps:upgrade` - Upgrade dependencies to latest versions

### Development Tools
- `mise run lint` - Run Flutter analyzer
- `mise run format` - Format code with dart format
- `mise run simulator` - Open iOS Simulator (macOS only)
- `mise run emulator` - Start Android emulator

### Setup & Configuration
- `mise run setup:android` - Configure Android development
- `mise run setup:ios` - Configure iOS development (macOS only)
- `mise run setup:web` - Configure web development
- `mise run precache` - Precache Flutter binaries
- `mise run upgrade` - Upgrade Flutter SDK

## Project Structure

This template assumes a standard Flutter project structure:

```
my_flutter_app/          # Default project name
├── mise.toml           # This template file
├── lib/                # Flutter source code
├── test/               # Unit and widget tests
├── integration_test/   # Integration tests
├── android/            # Android-specific code
├── ios/                # iOS-specific code
├── web/                # Web-specific code
└── pubspec.yaml        # Flutter dependencies
```

## Environment Variables

The template includes these environment variables:

- `ANDROID_HOME` - Android SDK path
- `ANDROID_SDK_ROOT` - Android SDK root (same as ANDROID_HOME)
- `GRADLE_OPTS` - Gradle JVM options for better performance

## Requirements

- macOS (for iOS development)
- Android SDK (for Android development)
- Chrome (for web development)
- mise CLI tool

## Customization

You can customize this template by:

1. Adjusting tool versions in the `[tools]` section
2. Modifying environment variables in the `[env]` section
3. Adding custom tasks in the `[tasks.*]` sections
4. Updating paths to match your specific setup

## VS Code Integration

This template includes a complete VS Code workspace configuration:

### Extensions
The template recommends installing these VS Code extensions:
- Flutter extension pack (Dart & Flutter)
- Error Lens for inline error display
- TODO Tree for task management
- GitHub Copilot for AI assistance
- Prettier for code formatting
- YAML support for configuration files

### Tasks
Pre-configured VS Code tasks for common Flutter operations:
- Setup and environment verification
- Development server management
- Testing (unit, widget, integration)
- Building (APK, App Bundle, iOS, Web)
- Code formatting and analysis
- Dependency management

### Debug Configurations
Ready-to-use debug configurations for:
- Development mode debugging
- Profile mode testing
- Release mode validation
- Platform-specific debugging (Android, iOS, Web)
- Integration test debugging

### Settings
Optimized VS Code settings for Flutter development:
- Dart SDK auto-detection
- Format on save enabled
- Hot reload configuration
- File exclusions for build artifacts
- Code analysis and error reporting
