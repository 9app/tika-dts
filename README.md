# Tika - Development Template System

**Tika CLI** is a unified command-line interface for cross-platform mobile development with Flutter and React Native. It streamlines environment setup, project creation, and template management.

## 🎯 What is Tika?

**Tika** (`./tika.sh`) is your **one-stop mobile development toolkit** that provides:

- 🚀 **Quick Environment Setup** - Automated development environment configuration
- 📱 **Template-Based Project Creation** - Create Flutter and React Native projects from battle-tested templates  
- 🔄 **Git-Integrated Template Upgrades** - Keep your projects up-to-date with latest best practices
- 🛠️ **Cross-Platform Tool Management** - Unified interface for Android, iOS, and web development

### Two-Phase Development Workflow

**Phase 1: Bootstrap (Use Tika CLI)** → **Phase 2: Development (Use Mise)**

## 🚀 Quick Start

### Phase 1: Initial Setup & Project Creation (Tika CLI)

Use **Tika CLI** for one-time setup and project creation:

#### Phase 1: Initial Setup (Use Tika CLI)
```bash
# Install and activate mise first (if not already done)
curl https://mise.run | sh
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc  # or ~/.bashrc for bash

# ONE-TIME ENVIRONMENT SETUP
./tika.sh setup                    # Complete development environment setup
./tika.sh setup-android            # Android development tools
./tika.sh setup-ios                # iOS development tools (macOS only)

# PROJECT CREATION FROM TEMPLATES  
./tika.sh create --template flutter --name my-flutter-app
./tika.sh create --template expo --name my-expo-app

# TEMPLATE MANAGEMENT
./tika.sh template-status          # Check current template version
./tika.sh template-upgrade         # Upgrade to latest template version
./tika.sh template-rollback        # Rollback to previous version (git-based)
```

#### Phase 2: Ongoing Development (Use Mise in Project Directory)
```bash
# Navigate to your created project
cd my-flutter-app

# DEVELOPMENT OPERATIONS
mise doctor                        # Verify environment health
mise run dev                       # Start development server
mise run android                   # Run on Android device/emulator
mise run ios                       # Run on iOS simulator (macOS only)
mise run web                       # Run on web browser

# BUILD & DEPLOYMENT
mise run build                     # Build for production
mise run test                      # Run tests
mise run lint                      # Code linting
mise run format                    # Code formatting

# TEMPLATE OPERATIONS (Alternative to Tika CLI)
mise run template:status           # Check template version
mise run template:upgrade          # Upgrade template
mise run template:rollback         # Rollback template changes
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

## 📱 Supported Platforms & Frameworks

Tika supports modern cross-platform mobile development:

- **🎯 Flutter** - Google's UI toolkit for cross-platform apps
- **⚛️ React Native with Expo** - Facebook's framework with Expo development platform
- **🤖 Android Native** - Android-specific features and optimizations
- **🍎 iOS Native** - iOS-specific features (macOS development only)

## 📁 Repository Structure

**Tika** is organized as a template system and development toolkit:

```
tika/
├── tika.sh                 # 🎯 Main CLI entry point
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
- Template upgrade and management
- Platform-specific tool installation

#### 🛠️ **`mise.toml`** - Tool & Task Management
Defines development tools, versions, and automation tasks:
- Cross-platform tool version management
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
- **Node.js 20.12.0** - JavaScript runtime for React Native development
- **Flutter 3.33.0** - Google's UI toolkit for cross-platform development  
- **Java 17.0.2** - Required for Android development and Gradle builds
- **Python 3.11.7** - Used by build scripts and automation tools

### 🎯 Why mise?
- **Reproducible environments** across team members and CI/CD
- **Automatic tool installation** based on project requirements
- **No manual PATH management** - tools are activated automatically
- **Environment variables** managed per-project
- **Task automation** integrated with tool management

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
# Create Flutter project
./tika.sh create --template flutter --name my-flutter-app

# Create React Native/Expo project
./tika.sh create --template expo --name my-expo-app

# Advanced options
./tika.sh create --template flutter --name my-app --path ./projects/
```

#### 🔄 Template Management
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
./tika.sh build                    # Build project
```

#### 📦 Template Management
```bash
# Template upgrades (git-integrated, zero dependencies)
./tika.sh template-status          # Check current template status
./tika.sh template-check           # Check for available upgrades
./tika.sh template-upgrade         # Upgrade to latest template version
./tika.sh template-rollback        # Git rollback to previous version
./tika.sh template-releases        # List all available template releases

# Using mise tasks from within project
mise run template:status           # Check template status
mise run template:upgrade          # Upgrade template
mise run template:rollback         # Rollback using git
```

#### 📖 Information & Help
```bash
./tika.sh help                     # Show all commands
./tika.sh version                  # Show version info
./tika.sh <command> --help         # Get help for specific command
```

### Command Examples

#### Create a New Flutter Project
```bash
# Using unified interface (recommended)
./tika.sh create --template flutter --name awesome-flutter-app

# Equivalent direct script call
./scripts/create-new-project.sh --template flutter --name awesome-flutter-app
```

#### Setup Complete Environment
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
