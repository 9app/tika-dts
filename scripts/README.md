# Scripts Directory

This directory contains all operational scripts for the Tika mobile development template system.

## 📜 Script Index

### 🚀 Initial Setup & Project Creation
- **[setup.sh](./setup.sh)** - Main development environment setup
- **[create-new-project.sh](./create-new-project.sh)** - Create new projects from templates
- **[setup-android.sh](./setup-android.sh)** - Android development tools setup
- **[setup-ios.sh](./setup-ios.sh)** - iOS development tools setup (macOS only)

### 🔧 Template Management
- **[template-upgrade-git.sh](./template-upgrade-git.sh)** - ✅ **Current**: Git-integrated template upgrade system
- **[template-upgrade.sh](./template-upgrade.sh)** - Template upgrade dispatcher script
- **[template-upgrade-native.sh](./template-upgrade-native.sh)** - ⚠️ **Deprecated**: Backup-based upgrade system

### 🛠️ Development Operations
- **[build.sh](./build.sh)** - Build projects and manage build processes
- **[verify.sh](./verify.sh)** - Verify environment and project health
- **[manage-templates.sh](./manage-templates.sh)** - Template management utilities

### 🔧 Utilities
- **[yaml-parser.sh](./yaml-parser.sh)** - YAML parsing utilities for template metadata

## 🎯 Usage Patterns

### Through tika.sh (Recommended)
```bash
# Initial setup and project creation
./tika.sh setup                    # Calls scripts/setup.sh
./tika.sh create                   # Calls scripts/create-new-project.sh
./tika.sh setup-android            # Calls scripts/setup-android.sh
./tika.sh setup-ios               # Calls scripts/setup-ios.sh

# Template management
./tika.sh template-status          # Calls scripts/template-upgrade-git.sh status
./tika.sh template-upgrade         # Calls scripts/template-upgrade-git.sh upgrade
./tika.sh template-rollback        # Calls scripts/template-upgrade-git.sh rollback
```

### Direct Script Execution
```bash
# Advanced users can call scripts directly
./scripts/setup.sh --verbose
./scripts/template-upgrade-git.sh --help
./scripts/create-new-project.sh --template flutter --name my-app
```

### Through mise tasks
```bash
# For ongoing development operations within projects
mise run doctor                   # Environment verification
mise run template:status          # Check template version
mise run template:upgrade         # Upgrade template
```

## 📋 Script Categories

### **Setup Scripts** (One-time execution)
- `setup.sh` - Environment setup
- `setup-android.sh` - Android SDK setup  
- `setup-ios.sh` - Xcode and iOS tools setup

### **Project Creation** (Per-project execution)
- `create-new-project.sh` - Create new projects from templates

### **Template Management** (Project lifecycle)
- `template-upgrade-git.sh` - Primary template upgrade system
- `template-upgrade.sh` - Upgrade system dispatcher
- `manage-templates.sh` - Template utilities

### **Development Operations** (Ongoing use)
- `build.sh` - Build and package projects
- `verify.sh` - Health checks and verification

### **Utility Scripts** (Supporting functionality)
- `yaml-parser.sh` - YAML processing for metadata

## 🔒 Script Security & Best Practices

### Execution Requirements
- All scripts require execute permissions (`chmod +x`)
- Scripts are designed to be run from project root directory
- Most scripts include built-in help (`--help` flag)

### Error Handling
- All scripts use `set -e` for immediate error exit
- Comprehensive error messages with actionable guidance
- Graceful rollback mechanisms where applicable

### Platform Compatibility
- Scripts are designed for macOS, Linux, and Windows (via WSL)
- Platform-specific operations are properly detected and handled
- iOS setup scripts are macOS-only with appropriate guards

## 🚨 Important Notes

### Deprecated Scripts
- **template-upgrade-native.sh** is deprecated but retained for migration support
- Shows warning message when executed
- Redirects users to git-integrated approach

### Script Dependencies
- Scripts may depend on mise-managed tools
- Required tools are installed automatically by setup scripts
- Check `mise.toml` for tool version requirements

### Logging & Debugging
- Scripts provide verbose output with colored messages
- Use `--verbose` or `--debug` flags where available
- Log files are created for complex operations

---

**Note**: For high-level operations, prefer using `./tika.sh` commands over direct script execution. Direct script access is provided for advanced users and automation scenarios.
