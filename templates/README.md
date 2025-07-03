# Mobile Development Templates

This directory contains mise configuration templates for different mobile development frameworks.

## Available Templates

### 📱 Flutter Template (`flutter-mise/`)
Complete mise configuration for Flutter development including:
- Flutter SDK managemen
- Android/iOS/Web developmen
- Testing automation
- Build tasks for all platforms
- Code formatting and linting

**Use for:** Cross-platform apps with Flutter framework

### ⚛️ React Native/Expo Template (`rn-expo-mise/`)
Complete mise configuration for React Native and Expo development including:
- React Native & Expo CLI setup
- EAS Build & Submit integration
- Local and cloud builds
- Over-the-air updates
- Testing and development tools

**Use for:** Cross-platform apps with React Native/Expo framework

## Quick Setup

### Using the Script (Recommended)
```bash
# Create a new Flutter projec
./scripts/create-new-project.sh --template flutter --name my-flutter-app

# Create a new React Native/Expo projec
./scripts/create-new-project.sh --template expo --name my-expo-app
```

### Manual Setup
1. Choose the appropriate template for your projec
2. Copy the template files to your project directory
3. Follow the template-specific README instructions

## Template Structure

Each template includes:
- `mise.toml` - Complete mise configuration
- `README.md` - Detailed setup and usage instructions
- Environment variables and tool configurations
- Comprehensive task definitions

## Customization

Templates are designed to be starting points. You can:
- Modify tool versions
- Add custom tasks
- Adjust environment variables
- Add project-specific configurations

## Requirements

- [mise](https://mise.jdx.dev/) CLI tool
- Platform-specific SDKs (Android SDK, Xcode)
- Node.js (managed by mise)
- Java (managed by mise)

## Suppor

For questions and issues:
1. Check the template-specific README
2. Review the main project documentation
3. Use `mise run doctor` to diagnose issues
