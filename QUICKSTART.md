# 🚀 Tika Quick Start Guide

**Get up and running with cross-platform mobile development in under 5 minutes.**

## ⚡ Super Quick Start (TL;DR)

```bash
# 1. Clone and setup (one-time)
git clone <repo-url> tika && cd tika && ./tika.sh setup

# 2. Create your project (choose one)
./tika.sh create --template flutter --name my-app    # Flutter + Material 3
./tika.sh create --template expo --name my-app      # React Native + Expo

# 3. Start developing immediately
cd my-app && mise run dev                           # Development server
mise run android                                    # Android emulator
mise run ios                                        # iOS simulator (macOS)
```

**That's it!** Your mobile development environment is ready with hot reload, debugging, and platform tools.

---

## 📋 Complete Step-by-Step Guide

### 🎯 Understanding the Workflow

**Tika** uses a **two-phase approach** for optimal developer experience:

| Phase | Tool | Purpose | When to Use |
|-------|------|---------|-------------|
| **Phase 1** | **Tika CLI** | System setup & project creation | Initial setup, new projects, template management |
| **Phase 2** | **Mise** | Daily development operations | Building, testing, running, debugging |

---

## 🛠️ Phase 1: One-Time Setup (Tika CLI)

### Step 1: Clone and Setup Environmen

```bash
# Clone the repository
git clone <repo-url> tika
cd tika

# Complete environment setup (installs mise + all tools)
./tika.sh setup
```

**What this does:**
- ✅ Installs mise (tool version manager)
- ✅ Configures shell integration
- ✅ Downloads and installs Flutter, Node.js, Java, Python
- ✅ Sets up Android SDK and development tools
- ✅ Configures VS Code extensions and settings

### Step 2: Platform-Specific Setup (Optional)

```bash
# Android development tools (if setup didn't complete)
./tika.sh setup-android

# iOS development tools (macOS only)
./tika.sh setup-ios
```

### Step 3: Create Your First Projec

```bash
# Flutter project with Material 3 + BLoC
./tika.sh create --template flutter --name awesome-flutter-app

# React Native project with Expo + TypeScrip
./tika.sh create --template expo --name awesome-mobile-app

# Advanced: Custom project path
./tika.sh create --template flutter --name my-app --path ./projects/
```

**Project Templates Include:**
- 📁 **Complete project structure** with best practices
- 🏗️ **Architecture patterns** (Clean Architecture / Feature-based)
- 🎨 **UI components** (Material 3 / React Native components)
- 🧪 **Testing setup** (Unit, Widget/Component, Integration tests)
- ⚙️ **Development tools** (Linting, formatting, debugging)
- 📱 **Platform configuration** (iOS, Android, Web)

---

## 🔧 Phase 2: Daily Development (Mise)

**After creating your project, navigate to it and use mise for all development operations:**

### Step 1: Navigate to Your Projec

```bash
# Navigate to your created projec
cd awesome-flutter-app
# OR
cd awesome-mobile-app
```

### Step 2: Verify Environmen

```bash
# Check that everything is working correctly
mise doctor                        # Verify tool installation and versions
mise list                          # Show all available tasks
```

### Step 3: Start Developing

```bash
# Core development commands
mise run dev                       # Start development server with hot reload
mise run android                   # Launch on Android emulator/device
mise run ios                       # Launch on iOS simulator (macOS only)
mise run web                       # Launch in web browser

# Additional development tools
mise run test                      # Run all tests (unit, widget, integration)
mise run lint                      # Run code analysis and linting
mise run format                    # Format code according to project standards
mise run build                     # Build for production
```

### Step 4: Template Management (Optional)

```bash
# Keep your project up-to-date with latest template improvements
mise run template:status           # Check current template version
mise run template:check            # Check for available updates
mise run template:upgrade          # Upgrade to latest template (creates git commit)
mise run template:rollback         # Git-based rollback if issues occur
```

---

## 🎯 Common Development Workflows

### 👤 **New Team Member Onboarding**

```bash
# 1. Clone and setup environment (one-time)
git clone <repo-url> tika && cd tika
./tika.sh setup

# 2. Verify installation
mise doctor
./tika.sh version

# 3. Create a test project to verify everything works
./tika.sh create --template flutter --name onboarding-tes
cd onboarding-test && mise run dev
```

### 📱 **Starting a New Project**

```bash
# 1. Create project from template
./tika.sh create --template flutter --name production-app --path ./projects/

# 2. Initialize development environmen
cd projects/production-app
mise run dev                       # Verify project works

# 3. Set up version control (if not using git template integration)
git init && git add . && git commit -m "Initial project setup"
```

### 🔄 **Daily Development Routine**

```bash
# In your project directory
mise run dev                       # Start development server

# In separate terminal tabs/windows
mise run android                   # Launch Android for testing
mise run ios                       # Launch iOS for testing (macOS)

# Code quality checks
mise run lint                      # Check for issues
mise run test                      # Run tests
mise run format                    # Format code before commi
```

### 🔧 **Template Maintenance**

```bash
# Check for template updates (weekly/monthly)
mise run template:check

# Upgrade to latest template (creates git commit automatically)
mise run template:upgrade

# If issues occur, rollback safely
mise run template:rollback
```

---

## 🚨 Troubleshooting

### Common Issues and Solutions

#### ❌ `mise not found` or command errors
```bash
# Ensure mise is properly installed and activated
curl https://mise.run | sh
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc  # or ~/.bashrc for bash
source ~/.zshrc  # or source ~/.bashrc
```

#### ❌ Android emulator or iOS simulator not starting
```bash
# Run platform-specific setup
./tika.sh setup-android            # For Android issues
./tika.sh setup-ios                # For iOS issues (macOS only)

# Verify installation
mise doctor
```

#### ❌ Template upgrade conflicts
```bash
# Safe rollback using gi
mise run template:rollback

# Check status and try again
mise run template:status
mise run template:upgrade --dry-run  # Preview changes firs
```

#### ❌ Development server not starting
```bash
# Clean and rebuild
mise run clean                     # Clean build artifacts
mise run dev                       # Restart development server

# Check for port conflicts
lsof -i :3000                      # Check if port 3000 is in use (React Native)
lsof -i :8080                      # Check if port 8080 is in use (Flutter web)
```

### Getting Help

1. **Check documentation**: See `docs/` directory for detailed guides
2. **Verify environment**: Run `mise doctor` to check tool installation
3. **View available commands**: Run `mise list` in your project directory
4. **Template-specific help**: Check the template's README in your projec

---

## 🎯 Next Steps

### 🎓 **Learn the Architecture**
- **Flutter**: [Flutter Development Instructions](./templates/flutter-mise/.github/instructions/)
- **React Native**: [React Native Development Instructions](./templates/rn-expo-mise/.github/instructions/)
- **Template System**: [System Architecture Guide](./docs/ARCHITECTURE.md)

### ⚙️ **Customize Your Setup**
- **VS Code**: [Troubleshooting Guide](./docs/TROUBLESHOOTING.md)
- **Git Integration**: [Development Workflows](./docs/WORKFLOWS.md)
- **CLI Reference**: [CLI Commands](./docs/CLI.md)

### 🧪 **Experiment and Test**
- **Playground**: Use `playground/` directory for testing new features
- **Template Testing**: Validate templates with `playground/scripts/test-runner.sh`
- **Custom Templates**: Learn to create your own project templates

---

**🎉 Congratulations!** You're now ready to build amazing cross-platform mobile applications with Tika. Happy coding!

# Verify after updates
mise doctor

# Build for production
mise run build
```

## 💡 Key Concepts

### 🎯 Tika's Role
- **One-time setup**: Configure development environmen
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
./tika.sh setup                   # Setup environmen
./tika.sh create [options]        # Create projec
./tika.sh setup-android           # Android setup
./tika.sh setup-ios               # iOS setup (macOS)
```

### Mise Commands (In Project Directory)
```bash
mise doctor                       # Verify environmen
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

- **[Project Structure](README.md)** - Complete documentation
- **[Getting Started Checklist](./docs/WORKFLOWS.md)** - Step-by-step checklist for new members
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

# Then setup the projec
cd my_flutter_app  # or my-expo-app
mise install
mise run doctor
```

### Template Managemen
```bash
# List available templates
mise run template:lis

# Validate templates
mise run template:validate

# Sync templates with main configuration
mise run template:sync
```
