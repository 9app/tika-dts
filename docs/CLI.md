# CLI Command Reference

**Complete command reference for Tika CLI and mise tasks** - Single source of truth for all available commands.

## 🎯 Tika CLI Commands

### Environment & Setup
```bash
./tika.sh setup                    # Complete development environment setup
./tika.sh setup-android            # Android SDK and tools setup
./tika.sh setup-ios                # iOS development tools (macOS only)
./tika.sh version                  # Show Tika version and system info
./tika.sh help                     # Show all available commands
```

### Project Creation
```bash
# Basic project creation
./tika.sh create --template flutter --name <project-name>
./tika.sh create --template expo --name <project-name>

# Advanced options
./tika.sh create --template flutter --name <project-name> --path <custom-path>
./tika.sh create --help            # Show creation options
```

### Template Managemen
```bash
./tika.sh template-status          # Check current template version
./tika.sh template-check           # Check for available upgrades
./tika.sh template-upgrade         # Upgrade to latest template version
./tika.sh template-upgrade --dry-run    # Preview upgrade changes
./tika.sh template-upgrade --force      # Force upgrade ignoring conflicts
./tika.sh template-rollback        # Git rollback to previous version
./tika.sh template-releases        # List all available template releases
```

---

## 🔧 Mise Task Commands

### Development Tasks (In Project Directory)
```bash
# Core developmen
mise run dev                       # Start development server
mise run android                   # Run on Android device/emulator
mise run ios                       # Run on iOS simulator (macOS only)
mise run web                       # Run on web browser

# Build & Testing
mise run build                     # Build for production
mise run test                      # Run all tests
mise run test:unit                 # Run unit tests only
mise run test:integration          # Run integration tests
mise run test:e2e                  # Run end-to-end tests

# Code Quality
mise run lint                      # Code linting and analysis
mise run format                    # Code formatting
mise run analyze                   # Static code analysis
mise run clean                     # Clean build artifacts

# Environmen
mise doctor                        # Verify environment health
mise install                       # Install/update tools
mise list                          # Show all available tasks
```

### Template Tasks (In Project Directory)
```bash
# Template management from within projec
mise run template:status           # Check template version status
mise run template:check            # Check for available updates
mise run template:upgrade          # Upgrade template
mise run template:rollback         # Rollback template changes
mise run template:history          # View template upgrade history
```

### Platform-Specific Tasks
```bash
# Android
mise run emulator                  # Start Android emulator
mise run android:build            # Build Android APK
mise run android:release          # Build Android release

# iOS (macOS only)
mise run simulator                 # Start iOS simulator
mise run ios:build                # Build iOS app
mise run ios:release              # Build iOS release

# Web
mise run web:build                 # Build web version
mise run web:serve                # Serve web build locally
```

---

## 📋 Command Usage Patterns

### Initial Setup Pattern
```bash
# First-time setup
git clone <repo-url> tika && cd tika
./tika.sh setup
./tika.sh create --template flutter --name my-app
cd my-app && mise run dev
```

### Daily Development Pattern
```bash
# In project directory
mise run dev                       # Start developmen
# In separate terminals:
mise run android                   # Test on Android
mise run ios                       # Test on iOS
mise run test                      # Run tests
```

### Quality Assurance Pattern
```bash
# Before committing
mise run lint                      # Check code quality
mise run test                      # Run all tests
mise run format                    # Format code
# git add . && git commit -m "..."
```

### Template Maintenance Pattern
```bash
# Monthly template updates
./tika.sh template-check           # Check for updates
./tika.sh template-upgrade --dry-run    # Preview changes
./tika.sh template-upgrade         # Apply upgrade
mise run test                      # Validate after upgrade
```

### Troubleshooting Pattern
```bash
# When things break
mise doctor                        # Check environmen
./tika.sh template-status          # Check template state
mise run clean                     # Clean build
mise run dev                       # Restart developmen
```

---

## 🔍 Command Details

### Tika CLI Options
```bash
# Setup command options
./tika.sh setup [--verbose] [--android] [--ios]

# Create command options
./tika.sh create --template <flutter|expo> --name <name> [--path <path>]

# Template upgrade options
./tika.sh template-upgrade [--dry-run] [--force] [--version <version>]
```

### Environment Variables
```bash
# Customize Tika behavior
export TIKA_ANDROID_HOME="/custom/android/sdk"
export TIKA_JAVA_HOME="/custom/java/path"
export TIKA_DEFAULT_PROJECT_PATH="./projects"
```

### mise Configuration
```bash
# Tool managemen
mise install                       # Install all tools from mise.toml
mise install node@20.12.0         # Install specific tool version
mise use node@20.12.0             # Use specific version for projec
mise ls                           # List installed tools
mise current                      # Show current tool versions
```

---

## 🚨 Command Safety & Best Practices

### Safe Command Patterns
```bash
# Always verify before major operations
./tika.sh template-upgrade --dry-run    # Preview before upgrade
mise doctor                             # Check health before developmen
mise run test                           # Test before commits
```

### Avoid These Patterns
```bash
# Don't chain complex operations
./tika.sh setup && ./tika.sh create --template flutter --name app && cd app && mise run dev

# Instead use step-by-step
./tika.sh setup
./tika.sh create --template flutter --name app
cd app
mise run dev
```

### Error Recovery Commands
```bash
# When commands fail
./tika.sh template-rollback        # Undo template changes
mise install                       # Reinstall tools
./tika.sh setup                    # Re-run environment setup
```

---

## 📖 Command Help

### Getting Help
```bash
# General help
./tika.sh help                     # All Tika commands
./tika.sh <command> --help         # Specific command help
mise --help                        # Mise help
mise run --help                    # Task help

# Documentation
cat README.md                      # Project overview
ls docs/                          # Available documentation
```

### Quick Reference
```bash
# Most common commands
./tika.sh setup                    # One-time setup
./tika.sh create --template flutter --name app    # Create projec
cd app && mise run dev             # Start developmen
mise run test                      # Run tests
./tika.sh template-upgrade         # Update template
```

---

**This CLI reference is the single source of truth for all commands. All other documentation files should reference these commands rather than duplicating them.**
