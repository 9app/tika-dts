# React Native/Expo mise Template

This template provides a complete mise configuration for React Native and Expo development.

## Features

- ✅ React Native & Expo CLI setup
- ✅ EAS Build & Submit integration
- ✅ Android/iOS development suppor
- ✅ Web development with Expo
- ✅ Comprehensive testing tasks
- ✅ Code formatting and linting
- ✅ Local and cloud builds
- ✅ Development server managemen

## Quick Star

1. Copy this template to your React Native/Expo project:
   ```bash
   cp templates/rn-expo-mise/mise.toml your-rn-project/
   ```

   Or create a new project using the script:
   ```bash
   ./scripts/create-new-project.sh --template expo
   # Creates project with default name: my-expo-app

   # Or with custom name:
   ./scripts/create-new-project.sh --template expo --name your-rn-projec
   ```

2. Navigate to your project and activate mise:
   ```bash
   cd my-expo-app  # or your-rn-projec
   mise install
   ```

3. Install dependencies:
   ```bash
   mise run deps
   ```

4. Setup development environment:
   ```bash
   mise run setup:android  # For Android developmen
   mise run setup:ios      # For iOS development (macOS only)
   mise run setup:eas      # For EAS Build & Submi
   ```

5. Verify your setup:
   ```bash
   mise run doctor
   ```

## Available Tasks

### Developmen
- `mise run dev` - Start Metro bundler
- `mise run android` - Run on Android device/emulator
- `mise run ios` - Run on iOS device/simulator (macOS only)
- `mise run web` - Run on web browser
- `mise run tunnel` - Start development server with tunnel
- `mise run localhost` - Start development server on localhos

### Testing
- `mise run test` - Run all tests
- `mise run test:watch` - Run tests in watch mode
- `mise run test:coverage` - Run tests with coverage repor
- `mise run test:android` - Run Android instrumentation tests
- `mise run test:ios` - Run iOS tests (macOS only)

### EAS Build (Cloud)
- `mise run build:eas:android` - Build Android with EAS
- `mise run build:eas:ios` - Build iOS with EAS (macOS only)
- `mise run build:eas:all` - Build for all platforms with EAS
- `mise run build:eas:preview` - Build preview version
- `mise run build:eas:production` - Build production version

### Local Build
- `mise run build:android` - Build Android APK locally
- `mise run build:ios` - Build iOS app locally (macOS only)

### EAS Submi
- `mise run submit:eas:android` - Submit to Google Play Store
- `mise run submit:eas:ios` - Submit to Apple App Store

### Maintenance
- `mise run clean` - Clean all build artifacts and dependencies
- `mise run clean:cache` - Clean all caches (npm, Expo, Metro)
- `mise run clean:android` - Clean Android build artifacts
- `mise run clean:ios` - Clean iOS build artifacts

### Development Tools
- `mise run lint` - Run ESLin
- `mise run lint:fix` - Run ESLint with auto-fix
- `mise run format` - Format code with Prettier
- `mise run simulator` - Open iOS Simulator (macOS only)
- `mise run emulator` - Start Android emulator

### Dependencies
- `mise run deps` - Install/update dependencies
- `mise run deps:upgrade` - Upgrade dependencies to latest versions

### Expo Specific
- `mise run expo:eject` - Eject from Expo managed workflow
- `mise run expo:prebuild` - Generate native code with prebuild
- `mise run expo:install` - Install and configure native dependencies
- `mise run expo:upgrade` - Upgrade Expo SDK

### EAS Update
- `mise run update:publish` - Publish over-the-air update
- `mise run update:configure` - Configure EAS Update

## Project Structure

This template works with both standard React Native and Expo projects:

### Expo Managed Projec
```
my-expo-app/            # Default project name
├── mise.toml           # This template file
├── App.js              # Main app componen
├── app.json            # Expo configuration
├── eas.json            # EAS configuration
├── package.json        # Dependencies
├── babel.config.js     # Babel configuration
└── assets/             # App assets
```

### Expo Bare/React Native Projec
```
my-expo-app/            # Default project name
├── mise.toml           # This template file
├── src/                # Source code
├── android/            # Android-specific code
├── ios/                # iOS-specific code
├── package.json        # Dependencies
├── metro.config.js     # Metro bundler configuration
├── babel.config.js     # Babel configuration
└── eas.json            # EAS configuration (if using EAS)
```

## Environment Variables

The template includes these environment variables:

- `ANDROID_HOME` - Android SDK path
- `ANDROID_SDK_ROOT` - Android SDK roo
- `NODE_ENV` - Node environment (development)
- `REACT_NATIVE_PACKAGER_HOSTNAME` - Metro bundler hostname
- `IOS_SIMULATOR_UDID` - iOS simulator device ID
- `GRADLE_OPTS` - Gradle JVM options

## EAS Configuration

To use EAS Build and Submit, you'll need:

1. An Expo accoun
2. EAS CLI installed (handled by template)
3. `eas.json` configuration file
4. Proper app signing credentials

Run `mise run setup:eas` to get started with EAS.

## Requirements

- Node.js (managed by mise)
- Java (managed by mise)
- Android SDK (for Android development)
- Xcode (for iOS development on macOS)
- mise CLI tool

## Development Workflows

### Expo Managed Workflow
- Use Expo CLI for most operations
- Build with EAS for production
- Use Expo Go app for quick testing

### Expo Bare Workflow / React Native CLI
- Full access to native code
- Use local builds or EAS for production
- Requires Android Studio/Xcode for native developmen

## Customization

You can customize this template by:

1. Adjusting tool versions in the `[tools]` section
2. Modifying environment variables in the `[env]` section
3. Adding custom tasks in the `[tasks.*]` sections
4. Updating EAS configuration for your specific projec
5. Adding project-specific scripts and tools

## VS Code Integration

This template includes a complete VS Code workspace configuration:

### Extensions
The template recommends installing these VS Code extensions:
- TypeScript and JavaScript language suppor
- React Native and Expo tools
- ESLint for code quality
- Prettier for code formatting
- Error Lens for inline error display
- TODO Tree for task managemen
- GitHub Copilot for AI assistance
- Styled Components suppor

### Tasks
Pre-configured VS Code tasks for common React Native/Expo operations:
- Development server management (Metro, tunnel, localhost)
- Platform-specific builds (Android, iOS, Web)
- EAS Build & Submit workflows
- Testing and coverage
- Code formatting and linting
- Dependency managemen
- Cache cleaning utilities

### Debug Configurations
Ready-to-use debug configurations for:
- Expo development server
- Platform-specific debugging (Android, iOS, Web)
- Tunnel debugging for remote testing
- Jest test debugging
- Production build testing

### Settings
Optimized VS Code settings for React Native/Expo development:
- TypeScript and JavaScript auto-imports
- ESLint integration and auto-fix
- Prettier formatting configuration
- File exclusions for build artifacts
- React Native packager configuration
- Emmet support for JSX
