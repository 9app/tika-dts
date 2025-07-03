# Tika - Mobile Development Template System

**Unified mobile development toolkit for Flutter and React Native** - Zero-config setup, production-ready templates, and intelligent template management.

## 🚀 Quick Start (5 Minutes)

```bash
# 1. Setup (one-time)
git clone <repo-url> tika && cd tika && ./tika.sh setup

# 2. Create projec
./tika.sh create --template flutter --name my-app    # Flutter
./tika.sh create --template expo --name my-app      # React Native

# 3. Start developing
cd my-app && mise run dev
```

**✅ Done!** Your development environment is ready with hot reload, debugging, and platform tools.

---

## 📚 Documentation Hub

### 🎯 **Essential Guides**
| Document | Purpose | Time to Read |
|----------|---------|--------------|
| **[QUICKSTART.md](./QUICKSTART.md)** | 5-minute setup guide | 5 min ⚡ |
| **[Technology Stack](./docs/ARCHITECTURE.md)** | All versions, tools, configurations | 10 min 📋 |
| **[Development Workflows](./docs/WORKFLOWS.md)** | Daily development processes | 15 min 🔧 |
| **[CLI Commands](./docs/CLI.md)** | Complete command reference | 10 min 💻 |

### 🔧 **Implementation Guides**
| Technology | Guide | Focus |
|------------|-------|-------|
| **Flutter** | [Flutter Guide](./templates/flutter-mise/GUIDE.md) | Clean Architecture, BLoC, Material 3 |
| **React Native** | [React Native Guide](./templates/rn-expo-mise/GUIDE.md) | TypeScript, React Query, Expo |

### 🧪 **Advanced Topics**
- **[System Architecture](./docs/ARCHITECTURE.md)** - How the template system works
- **[Playground Guide](./playground/README.md)** - Validation and experimentation
- **[Troubleshooting](./docs/TROUBLESHOOTING.md)** - Common issues and solutions

---

## 🎯 What is Tika?

### **Core Value Propositions**
- 🚀 **5-Minute Setup**: From zero to running mobile app in 5 minutes
- 📱 **Production Templates**: Battle-tested Flutter and React Native templates
- 🔄 **Smart Upgrades**: Git-integrated template updates with automatic rollback
- 🛠️ **Zero Config**: Everything works out of the box, no manual configuration

### **Technology Support**
- **Flutter 3.24+**: Clean Architecture, BLoC/Riverpod, Material 3
- **React Native 0.74+**: TypeScript, React Query, Expo SDK 51+
- **Development Tools**: mise, VS Code, Android Studio, Xcode

> **Complete technology details**: See [System Architecture](./docs/ARCHITECTURE.md)

---

## 🏗️ System Architecture

### **Two-Phase Development Workflow**
```
Phase 1: Bootstrap (Tika CLI) → Phase 2: Development (Mise)
```

| Phase | Tool | Commands | Purpose |
|-------|------|----------|---------|
| **Bootstrap** | `./tika.sh` | `setup`, `create` | System setup, project creation |
| **Development** | `mise run` | `dev`, `android`, `ios` | Daily development, builds, tests |

### **Repository Structure**
```
tika/
├── 📋 README.md (this file)        # Project overview & navigation
├── 🚀 QUICKSTART.md               # 5-minute setup guide
├── 🎯 tika.sh                     # Main CLI interface
├── 📚 docs/                       # Core documentation
│   ├── REFERENCE.md              # Technology stack (SSOT)
│   ├── WORKFLOWS.md              # Development processes (SSOT)
│   └── CLI.md                    # Command reference (SSOT)
├── 🔧 templates/                  # Mobile development templates
│   ├── flutter-mise/             # Flutter + Clean Architecture
│   └── rn-expo-mise/             # React Native + Expo
├── 🧪 playground/                # Testing & validation
└── 📝 scripts/                   # Automation scripts
```

> **Detailed architecture**: See [System Architecture](./docs/ARCHITECTURE.md)

---

## 📋 Quick Command Reference

### **Setup & Creation**
```bash
./tika.sh setup                    # One-time environment setup
./tika.sh create --template flutter --name <app>   # Create Flutter projec
./tika.sh create --template expo --name <app>      # Create React Native projec
```

### **Daily Development** (in project directory)
```bash
mise run dev                       # Start development server
mise run android                   # Launch Android emulator
mise run ios                       # Launch iOS simulator
mise run test                      # Run all tests
```

### **Template Management**
```bash
./tika.sh template-upgrade         # Upgrade to latest template
./tika.sh template-rollback        # Rollback if issues occur
```

> **Complete command reference**: See [CLI Documentation](./docs/CLI.md)

---

## 🔄 Template Managemen

### **Intelligent Upgrade System**
- ✅ **Git Integration**: Automatic commits before upgrades
- ✅ **Rollback Safety**: One-command rollback if issues occur
- ✅ **Version Selection**: Choose specific versions, not just lates
- ✅ **Conflict Resolution**: Smart handling of upgrade conflicts

### **Upgrade Workflow**
```bash
./tika.sh template-check           # Check for updates
./tika.sh template-upgrade --dry-run    # Preview changes
./tika.sh template-upgrade         # Apply upgrade (creates git commit)
./tika.sh template-rollback        # Rollback if needed
```

> **Detailed upgrade workflows**: See [Development Workflows](./docs/WORKFLOWS.md)

---

## 🛠️ Developer Experience

### **Out-of-the-Box Features**
- 🎯 **Single Command Setup**: `./tika.sh setup` configures everything
- 📱 **Hot Reload Ready**: Instant feedback during developmen
- 🧪 **Testing Configured**: Unit, widget, integration, and E2E tests
- 🔍 **Debugging Tools**: VS Code integration, platform debuggers
- 📊 **Code Quality**: Linting, formatting, and analysis pre-configured

### **Production-Ready Templates**
- **Flutter Template**: Material 3, BLoC pattern, Clean Architecture
- **React Native Template**: Expo Router, TypeScript, React Query

> **Implementation details**: See [Flutter Guide](./templates/flutter-mise/GUIDE.md) | [React Native Guide](./templates/rn-expo-mise/GUIDE.md)

---

## 🌟 Why Choose Tika?

### **Compared to Manual Setup**
- ⚡ **10x Faster**: 5 minutes vs 2+ hours manual configuration
- 🔒 **Consistent**: Same environment across all team members
- 🎯 **Best Practices**: Production-proven patterns built-in
- 🔄 **Maintainable**: Easy updates as ecosystem evolves

### **Compared to Other Tools**
- 🚫 **Zero Dependencies**: No external tools required (yq, jq, etc.)
- 🔧 **Tool Management**: Automatic version management with mise
- 📱 **Mobile Focus**: Optimized specifically for mobile developmen
- 🎯 **Template System**: Upgradeable, version-controlled templates

---

## 🚀 Getting Started

### **New to Tika?**
1. **Start Here**: [QUICKSTART.md](./QUICKSTART.md) - Get running in 5 minutes
2. **Learn Stack**: [System Architecture](./docs/ARCHITECTURE.md) - Understand the tools
3. **Daily Workflow**: [Development Workflows](./docs/WORKFLOWS.md) - Master the process

### **Team Setup?**
1. **Environment**: [Setup Guide](./docs/WORKFLOWS.md#setup-workflows) - Consistent team environmen
2. **Standards**: [Flutter Guide](./templates/flutter-mise/GUIDE.md) | [React Native Guide](./templates/rn-expo-mise/GUIDE.md) - Development standards
3. **Processes**: [Team Workflows](./docs/WORKFLOWS.md#team-development-workflows) - Collaboration patterns

### **Need Help?**
- 🐛 **Issues**: [Troubleshooting Guide](./docs/TROUBLESHOOTING.md)
- 💬 **Commands**: [CLI Reference](./docs/CLI.md)
- 🏗️ **Architecture**: [Template Architecture](./docs/template-architecture.md)

---

**🎯 Ready to build amazing mobile apps?** Start with [QUICKSTART.md](./QUICKSTART.md) and go from zero to mobile development in 5 minutes!

## 🚀 Quick Start Guide

### 📋 Two-Phase Development Workflow

**Phase 1: Bootstrap (Tika CLI)** → **Phase 2: Development (Mise)**

| Phase | Tool | Purpose | Example Commands |
|-------|------|---------|------------------|
| **1. Bootstrap** | Tika CLI | System setup & project creation | `./tika.sh setup`, `./tika.sh create` |
| **2. Development** | Mise | Daily development & builds | `mise run dev`, `mise run android` |

### ⚡ Super Quick Start (5 Minutes)

```bash
# 1. Clone and setup environment (one-time)
git clone <repo-url> tika && cd tika
./tika.sh setup                    # Complete development environmen

# 2. Create your first projec
./tika.sh create --template flutter --name my-flutter-app
# OR
./tika.sh create --template expo --name my-expo-app

# 3. Start developing immediately
cd my-flutter-app
mise run dev                       # Start development server
mise run android                   # Launch on Android
mise run ios                       # Launch on iOS (macOS only)
```

### 🎯 Phase 1: Initial Setup & Project Creation (Tika CLI)

**Use Tika CLI for one-time system setup and project creation:**

```bash
# ENVIRONMENT SETUP (One-time)
./tika.sh setup                    # Complete development environment setup
./tika.sh setup-android            # Android SDK and tools (if needed separately)
./tika.sh setup-ios                # iOS development tools (macOS only)

# PROJECT CREATION FROM TEMPLATES
./tika.sh create --template flutter --name my-flutter-app --path ./projects/
./tika.sh create --template expo --name my-expo-app --path ./mobile-apps/

# TEMPLATE MANAGEMENT
./tika.sh template-status          # Check current template version
./tika.sh template-upgrade         # Upgrade to latest template version
./tika.sh template-rollback        # Git-based rollback to previous version
```

### 🔧 Phase 2: Daily Development (Mise in Project Directory)

**Navigate to your project and use mise for development operations:**

```bash
# Navigate to your created projec
cd my-flutter-app

# DEVELOPMENT OPERATIONS
mise doctor                        # Verify environment health
mise run dev                       # Start development server with hot reload
mise run android                   # Run on Android device/emulator
mise run ios                       # Run on iOS simulator (macOS only)
mise run web                       # Run on web browser (Flutter/Expo)

# BUILD & TESTING
mise run build                     # Build for production
mise run test                      # Run all tests (unit, widget, integration)
mise run lint                      # Code linting and analysis
mise run format                    # Code formatting

# TEMPLATE OPERATIONS (Alternative to Tika CLI)
mise run template:status           # Check template version status
mise run template:upgrade          # Upgrade template (same as Tika CLI)
mise run template:rollback         # Rollback template changes using gi
```

## 🎯 When to Use What?

| Task | Tool | Command Example |
|------|------|-----------------|
| **Environment Setup** | Tika CLI | `./tika.sh setup` |
| **Create New Project** | Tika CLI | `./tika.sh create --template flutter` |
| **Template Management** | Tika CLI or Mise | `./tika.sh template-upgrade` or `mise run template:upgrade` |
| **Daily Development** | Mise | `mise run dev`, `mise run android` |
| **Build & Deploy** | Mise | `mise run build`, `mise run test` |

### Why This Two-Phase Approach?

- **Tika CLI**: Handles **system-wide** setup and **cross-project** operations
- **Mise**: Manages **project-specific** development and **per-project** tool versions
- **Clear Separation**: No confusion about which tool to use for what purpose
- **Consistency**: Same workflow across all mobile projects

### Advanced Users: Direct Script Access
Experienced users can access individual scripts directly if needed:

```bash
# Direct script execution (bypassing Tika CLI)
./scripts/create-new-project.sh --template flutter --name my-app
./scripts/setup.sh --verbose
./scripts/template-upgrade-git.sh status     # Git-integrated template upgrades
```

## 📱 Supported Technologies & Platforms

**Tika** supports modern cross-platform mobile development with best-in-class tooling:

### 🎯 **Flutter Development**
- **Framework**: Flutter 3.24+ with Dart 3.5+
- **Architecture**: Clean Architecture with BLoC/Cubit pattern
- **State Management**: BLoC, Riverpod, Provider patterns
- **UI/UX**: Material 3 design system with custom theming
- **Testing**: Unit, widget, and integration testing strategies
- **Platforms**: iOS, Android, Web, macOS, Linux, Windows

### ⚛️ **React Native & Expo Development**
- **Framework**: React Native 0.74+ with Expo SDK 51+
- **Language**: TypeScript with strict type checking
- **State Management**: React Query (server), Zustand (client)
- **Navigation**: React Navigation v6 with type safety
- **Development**: Expo Router, hot reload, debugging tools
- **Platforms**: iOS, Android, Web (Expo)

### 🔧 **Development Tools & Versions**
- **Node.js**: 20.12.0 (LTS) - JavaScript runtime
- **Flutter**: 3.24.0 - Cross-platform UI toolki
- **Java**: 17.0.2 - Android development and Gradle
- **Python**: 3.11.7 - Build scripts and automation
- **mise**: Latest - Tool version managemen

### 📖 **Additional Information**
For detailed setup instructions and troubleshooting, see:
- **[Complete CLI Reference](./docs/cli-reference.md)** - All available commands
- **[Template Architecture Guide](./docs/template-architecture.md)** - Understanding templates
- **[VS Code Configuration](./docs/vscode-configuration.md)** - IDE setup and extensions

## 📁 Repository Structure

**Tika** is organized as a template system and development toolkit:

```
tika/
├── tika.sh                 # 🎯 Main CLI entry poin
├── mise.toml              # 🛠️ Tool and task definitions
├── scripts/               # 🔧 Core automation scripts
│   ├── setup.sh           # Environment setup
│   ├── create-new-project.sh  # Project creation from templates
│   ├── template-upgrade-git.sh  # Git-integrated template upgrades
│   └── ...                # Platform-specific setup scripts
├── templates/             # 📱 Mobile development templates
│   ├── flutter-mise/      # Flutter + Mise development template
│   └── rn-expo-mise/      # React Native/Expo + Mise template
├── playground/            # 🧪 Template testing & experimentation
│   ├── apps/             # Test applications for validation
│   ├── packages/         # Shared test packages
│   └── scripts/          # Template testing & validation scripts
├── docs/                 # 📚 Comprehensive documentation
│   ├── README.md         # Documentation index
│   ├── template-upgrade-quickstart.md
│   ├── vscode-configuration.md
│   └── ...               # Additional guides and references
└── .vscode/              # ⚙️ VS Code workspace configuration
```

### Core Components

#### 🎯 **`tika.sh`** - Main CLI Interface
The primary command-line interface that orchestrates all operations:
- Environment setup and configuration
- Project creation from templates
- Template upgrade and managemen
- Platform-specific tool installation

#### 🛠️ **`mise.toml`** - Tool & Task Managemen
Defines development tools, versions, and automation tasks:
- Cross-platform tool version managemen
- Project-specific environment variables
- Development workflow automation
- Template upgrade tasks

#### 📱 **Templates (`templates/`)**
Production-ready project templates with best practices:
- **`flutter-mise/`** - Flutter development with Clean Architecture, BLoC, Testing
- **`rn-expo-mise/`** - React Native/Expo with TypeScript, React Query, Navigation

#### 🔧 **Scripts (`scripts/`)**
Production-focused automation for system-wide operations:
- Project creation and template instantiation
- Development environment setup
- Template upgrade and synchronization
- Platform-specific tool installation

#### 🧪 **Playground (`playground/`)**
Template testing and validation environment:
- Test applications for template verification
- Shared packages for code reuse testing
- Template validation and testing scripts

## 🛠️ Development Tools & Versions

**Tika** uses [mise](https://mise.jdx.dev) for **deterministic tool version management**. All tools and versions are defined in `mise.toml`:

### 📦 Included Development Tools
- **Node.js 20.12.0** - JavaScript runtime for React Native developmen
- **Flutter 3.33.0** - Google's UI toolkit for cross-platform developmen
- **Java 17.0.2** - Required for Android development and Gradle builds
- **Python 3.11.7** - Used by build scripts and automation tools

### 🎯 Why mise?
- **Reproducible environments** across team members and CI/CD
- **Automatic tool installation** based on project requirements
- **No manual PATH management** - tools are activated automatically
- **Environment variables** managed per-projec
- **Task automation** integrated with tool managemen

## ⚡ Installation & Setup

### Option 1: Automated Setup (Recommended)
```bash
# Clone the repository
git clone <repository-url>
cd tika

# Run automated setup (installs mise + all tools)
./tika.sh setup

# Verify installation
./tika.sh version
mise doctor
```

### Option 2: Manual Setup
If automated setup fails, install manually:

#### 1. Install mise
```bash
# macOS with Homebrew
brew install mise

# Or using curl (cross-platform)
curl https://mise.run | sh
```

#### 2. Activate mise in your shell
```bash
# For Zsh (default on macOS)
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
source ~/.zshrc

# For Bash
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

#### 3. Install project tools
```bash
cd tika
mise install
```

#### 4. Verify installation
```bash
mise doctor
./tika.sh version
```

## 📋 Complete Command Reference

### 🎯 Tika CLI Commands

**Tika CLI** (`./tika.sh`) is your primary interface for system-wide operations:

#### 🚀 Environment & Setup
```bash
./tika.sh setup                    # Complete development environment setup
./tika.sh setup-android            # Android SDK and tools setup
./tika.sh setup-ios                # iOS development tools (macOS only)
./tika.sh version                  # Show Tika version and system info
./tika.sh help                     # Show all available commands
```

#### 📱 Project Creation
```bash
# Create Flutter projec
./tika.sh create --template flutter --name my-flutter-app

# Create React Native/Expo projec
./tika.sh create --template expo --name my-expo-app

# Advanced options
./tika.sh create --template flutter --name my-app --path ./projects/
```

#### 🔄 Template Managemen
```bash
./tika.sh template-status          # Check current template version
./tika.sh template-check           # Check for available template upgrades
./tika.sh template-upgrade         # Upgrade to latest template version
./tika.sh template-rollback        # Git rollback to previous version
./tika.sh template-releases        # List all available template releases

# Advanced template operations
./tika.sh template-upgrade --dry-run    # Preview upgrade changes
./tika.sh template-upgrade --force      # Force upgrade ignoring conflicts
```
./tika.sh verify                   # Verify project configuration
./tika.sh build                    # Build projec
```

#### 📦 Template Managemen
```bash
# Template upgrades (git-integrated, zero dependencies)
./tika.sh template-status          # Check current template status
./tika.sh template-check           # Check for available upgrades
./tika.sh template-upgrade         # Upgrade to latest template version
./tika.sh template-rollback        # Git rollback to previous version
./tika.sh template-releases        # List all available template releases

# Using mise tasks from within projec
mise run template:status           # Check template status
mise run template:upgrade          # Upgrade template
mise run template:rollback         # Rollback using gi
```

#### 📖 Information & Help
```bash
./tika.sh help                     # Show all commands
./tika.sh version                  # Show version info
./tika.sh <command> --help         # Get help for specific command
```

### Command Examples

#### Create a New Flutter Projec
```bash
# Using unified interface (recommended)
./tika.sh create --template flutter --name awesome-flutter-app

# Equivalent direct script call
./scripts/create-new-project.sh --template flutter --name awesome-flutter-app
```

#### Setup Complete Environmen
```bash
# One command setup
./tika.sh setup

# Platform-specific setup
./tika.sh setup-android     # Android tools
./tika.sh setup-ios         # iOS tools (macOS only)
```

#### Check and Upgrade Templates (Git-Integrated)
```bash
# Check current status
./tika.sh template-status

# Check for available upgrades
./tika.sh template-check

# Upgrade with dry-run preview
./tika.sh template-upgrade --dry-run

# Upgrade to latest version (creates git commit)
./tika.sh template-upgrade

# Rollback using git (no backup directories needed)
./tika.sh template-rollback

# View available releases
./tika.sh template-releases
```
