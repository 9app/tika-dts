# 🚀 Tika Quick Start Guide

**Tika** is a mobile development template system focused on **initial setup and project creation**. After setup, use **mise** for ongoing development operations.

## ⚡ One-Time Setup

```bash
# 1. Clone and enter the project
git clone <repo-url> tika
cd tika

# 2. One-time environment setup
./tika.sh setup

# 3. Create your first project
./tika.sh create --template flutter --name my-app
```

## 🎯 Workflow: Tika → Mise

### � Phase 1: Initial Setup (Use Tika)
```bash
# Setup development environment (once)
./tika.sh setup

# Platform-specific setup if needed
./tika.sh setup-android        # Android development
./tika.sh setup-ios            # iOS development (macOS only)

# Create new projects
./tika.sh create --template flutter --name my-flutter-app
./tika.sh create --template expo --name my-expo-app
```

### � Phase 2: Ongoing Development (Use Mise)
```bash
# Navigate to your project directory first
cd my-flutter-app  # or cd my-expo-app

# Verify environment
mise doctor

# Template management (git-integrated)
mise run template:status          # Check current template version
mise run template:check           # Check for updates
mise run template:upgrade         # Upgrade to latest template (git commit)
mise run template:rollback        # Rollback using git
mise run template:history         # View upgrade history

# Development tasks
mise run dev                      # Start development
mise run android                  # Run on Android
mise run ios                      # Run on iOS
mise run build                    # Build for production
```

### Start Development
```bash
# React Native + Expo (from playground/apps/mobile-app/)
mise run dev          # Start Expo development server
## 🎯 Common Workflows

### New Team Member Onboarding
```bash
# 1. One-time environment setup
./tika.sh setup

# 2. Verify everything works
mise doctor

# 3. Create test project
./tika.sh create --template flutter --name test-project
```

### Daily Development (In Project Directory)
```bash
# Check for template updates
mise run template:check

# Start development
mise run dev

# Run on devices
mise run android        # Android
mise run ios           # iOS
```

### Project Maintenance (In Project Directory)
```bash
# Update to latest template
mise run template:upgrade

# Verify after updates
mise doctor

# Build for production
mise run build
```

## 💡 Key Concepts

### 🎯 Tika's Role
- **One-time setup**: Configure development environment
- **Project creation**: Generate new projects from templates
- **Platform setup**: Configure Android/iOS development tools

### 🔧 Mise's Role (After Project Creation)
- **Environment verification**: `mise doctor`
- **Template management**: `mise run template:*`
- **Development tasks**: `mise run dev`, `mise run android`, etc.
- **Build operations**: `mise run build`

## 📋 Command Reference

### Tika Commands (Global)
```bash
./tika.sh help                    # Show help
./tika.sh version                 # Show version
./tika.sh setup                   # Setup environment
./tika.sh create [options]        # Create project
./tika.sh setup-android           # Android setup
./tika.sh setup-ios               # iOS setup (macOS)
```

### Mise Commands (In Project Directory)
```bash
mise doctor                       # Verify environment
mise run template:status          # Template version
mise run template:check           # Check updates
mise run template:upgrade         # Upgrade template
mise run template:history         # Upgrade history
mise run template:rollback        # Rollback upgrade
```

## 📁 Project Structure

```
tika/
├── playground/          # Testing and experimentation
│   ├── apps/            # Test applications
│   │   ├── flutter_app/ # Flutter cross-platform mobile app
│   │   ├── mobile-app/  # React Native + Expo mobile app
│   │   └── web-app/     # Web application
│   └── packages/        # Shared packages for testing
├── templates/           # Development templates
│   ├── flutter-mise/    # Flutter template
│   └── rn-expo-mise/    # React Native + Expo template
├── scripts/             # Setup and build scripts
├── mise.toml           # Development environment config
└── README.md           # Full documentation
```

## 📖 Documentation

- **[Full Setup Guide](README.md)** - Complete documentation
- **[Onboarding Checklist](ONBOARDING.md)** - Step-by-step checklist for new members
- **Available Commands**: Run `mise run` to see all available tasks

## 🆘 Need Help?

1. **Environment Issues**: `mise run doctor`
2. **Clean Reset**: `mise run clean`
3. **Re-run Setup**: `./scripts/setup.sh`
4. **Android Setup**: `mise run setup:android`
5. **iOS Setup**: `mise run setup:ios` (macOS only)

### Common Issues

- **Java JAXB errors**: These are harmless warnings from older Android SDK tools
- **Emulator not starting**: Try `mise run emulator` or start from Android Studio
- **Missing dependencies**: Run `mise run deps` to reinstall all dependencies

## 🛠 What Gets Installed

- **Node.js 20.12.0** - React Native/Expo development ✅
- **Flutter 3.32.5** - Cross-platform development (includes Dart SDK 3.8.1) ✅
- **Java 17.0.2** - Android builds ✅
- **Python 3.11.7** - Build scripts ✅
- **Expo SDK 52** - React Native framework ✅
- **EAS CLI** - Build and deployment ✅
- **Development tools** - Gradle, platform-specific tools, etc.

All versions are managed by mise and defined in `mise.toml`.

### Current Status
✅ **Core tools ready** - Node.js, Java, Python installed via mise
✅ **Flutter ready** - Latest stable version (3.32.5) via mise
✅ **Android ready** - SDK configured, emulators available
✅ **iOS ready** - Xcode and tools configured (macOS)
✅ **All verification checks pass** - Run `mise run verify` to confirm

## 🎯 Creating New Projects

### Quick Project Creation
```bash
# Create new Flutter project (default name: my_flutter_app)
mise run project:create:flutter -- my_flutter_app

# Create new Expo project (default name: my-expo-app)
mise run project:create:expo -- my-expo-app

# Interactive project creation
mise run project:create
```

### Manual Project Creation
```bash
# Using scripts directly with default names
./scripts/create-new-project.sh --template flutter
./scripts/create-new-project.sh --template expo

# Or with custom names
./scripts/create-new-project.sh --template flutter --name my_custom_flutter_app
./scripts/create-new-project.sh --template expo --name my-custom-expo-app

# Then setup the project
cd my_flutter_app  # or my-expo-app
mise install
mise run doctor
```

### Template Management
```bash
# List available templates
mise run template:list

# Validate templates
mise run template:validate

# Sync templates with main configuration
mise run template:sync
```
