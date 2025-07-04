# Flutter mise Template

This template provides a complete mise configuration for Flutter development.

## Features

- ✅ Flutter SDK managemen
- ✅ Android/iOS development setup
- ✅ Web development suppor
- ✅ Comprehensive build tasks
- ✅ Testing automation
- ✅ Code formatting and linting
- ✅ Development tools integration

## Quick Star

1. Copy this template to your Flutter project:
   ```bash
   cp templates/flutter-mise/mise.toml your-flutter-project/
   ```

   Or create a new project using the script:
   ```bash
   ./scripts/create-new-project.sh --template flutter
   # Creates project with default name: my_flutter_app

   # Or with custom name:
   ./scripts/create-new-project.sh --template flutter --name your_flutter_projec
   ```

2. Navigate to your project and activate mise:
   ```bash
   cd my_flutter_app  # or your_flutter_projec
   mise install
   ```

3. Setup Flutter development environment:
   ```bash
   mise setup:android      # For Android development
   mise setup:ios          # For iOS development (macOS only)
   mise setup:web          # For web development
   ```

4. Verify your setup:
   ```bash
   mise doctor
   ```

## Available Tasks

### Development
- `mise dev` - Run Flutter app in development mode
- `mise android` - Run on Android device/emulator
- `mise ios` - Run on iOS device/simulator (macOS only)
- `mise web` - Run on web browser

### Testing
- `mise test` - Run all tests
- `mise test:unit` - Run unit tests only
- `mise test:widget` - Run widget tests only
- `mise test:integration` - Run integration tests only

### Building
- `mise build:apk` - Build Android APK
- `mise build:appbundle` - Build Android App Bundle
- `mise build:ios` - Build iOS app
- `mise build:web` - Build web app

### Maintenance
- `mise clean` - Clean build artifacts and reinstall dependencies
- `mise deps` - Install/update dependencies
- `mise deps:upgrade` - Upgrade dependencies to latest versions

### Development Tools
- `mise lint` - Run Flutter analyzer
- `mise format` - Format code with dart format
- `mise simulator` - Open iOS Simulator (macOS only)
- `mise emulator` - Start Android emulator

### Setup & Configuration
- `mise setup:android` - Configure Android development
- `mise setup:ios` - Configure iOS development (macOS only)
- `mise setup:web` - Configure web development
- `mise precache` - Precache Flutter binaries
- `mise upgrade` - Upgrade Flutter SDK

> **Note**: `mise <task>` is shorthand for `mise run <task>`

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
- TODO Tree for task managemen
- GitHub Copilot for AI assistance
- Prettier for code formatting
- YAML support for configuration files

### Tasks
Pre-configured VS Code tasks for common Flutter operations:
- Setup and environment verification
- Development server managemen
- Testing (unit, widget, integration)
- Building (APK, App Bundle, iOS, Web)
- Code formatting and analysis
- Dependency managemen

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
