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

### Template Management
```bash
./scripts/template-upgrade-git.sh status          # Check current template version
./scripts/template-upgrade-git.sh check-upgrades  # Check for available upgrades
./scripts/template-upgrade-git.sh upgrade         # Upgrade to latest template version
./scripts/template-upgrade-git.sh check-upgrades  # Preview upgrade changes
./scripts/template-upgrade-git.sh upgrade --force # Force upgrade ignoring conflicts
./scripts/template-upgrade-git.sh rollback        # Git rollback to previous version
./scripts/template-upgrade-git.sh history         # List all available template releases
```

---

## 🔧 Mise Task Commands

### Development Tasks (In Project Directory)
```bash
# Core development
mise dev                           # Start development server
mise android                       # Run on Android device/emulator
mise ios                           # Run on iOS simulator (macOS only)
mise web                           # Run on web browser

# Build & Testing
mise build                         # Build for production
mise test                          # Run all tests
mise test:unit                     # Run unit tests only
mise test:integration              # Run integration tests
mise test:e2e                      # Run end-to-end tests

# Code Quality
mise lint                          # Code linting and analysis
mise format                        # Code formatting
mise analyze                       # Static code analysis
mise clean                         # Clean build artifacts

# Environment
mise doctor                        # Verify environment health
mise install                       # Install/update tools
mise list                          # Show all available tasks
```

> **Note**: `mise <task>` is shorthand for `mise run <task>`

### Template Tasks (In Project Directory)
```bash
# Template management from within project
mise template:status               # Check template version status
mise template:check                # Check for available updates
mise template:upgrade              # Upgrade template
mise template:rollback             # Rollback template changes
mise template:history              # View template upgrade history
```

### Platform-Specific Tasks
```bash
# Android
mise emulator                      # Start Android emulator
mise android:build                # Build Android APK
mise android:release              # Build Android release

# iOS (macOS only)
mise simulator                     # Start iOS simulator
mise ios:build                    # Build iOS app
mise ios:release                   # Build iOS release

# Web
mise web:build                     # Build web version
mise web:serve                     # Serve web build locally
```

---

## 📋 Command Usage Patterns

### Initial Setup Pattern
```bash
# First-time setup
git clone <repo-url> tika && cd tika
./tika.sh setup
./tika.sh create --template flutter --name my-app
cd my-app && mise dev
```

### Daily Development Pattern
```bash
# In project directory
mise dev                           # Start development
# In separate terminals:
mise android                       # Test on Android
mise ios                           # Test on iOS
mise test                          # Run tests
```

### Quality Assurance Pattern
```bash
# Before committing
mise lint                          # Check code quality
mise test                          # Run all tests
mise format                        # Format code
# git add . && git commit -m "..."
```

### Template Maintenance Pattern
```bash
# Monthly template updates
./scripts/template-upgrade-git.sh check-upgrades  # Check for updates
./scripts/template-upgrade-git.sh check-upgrades  # Preview changes
./scripts/template-upgrade-git.sh upgrade         # Apply upgrade
mise test                                          # Validate after upgrade
```

### Troubleshooting Pattern
```bash
# When things break
mise doctor                        # Check environment
./tika.sh template-status          # Check template state
mise clean                         # Clean build
mise dev                           # Restart development
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
./scripts/template-upgrade-git.sh [status|check-upgrades|upgrade|rollback|history] [--force] [--version <version>]
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
./scripts/template-upgrade-git.sh check-upgrades  # Preview before upgrade
mise doctor                                        # Check health before development
mise run test                                      # Test before commits
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
./scripts/template-upgrade-git.sh upgrade         # Update template
```

---

**This CLI reference is the single source of truth for all commands. All other documentation files should reference these commands rather than duplicating them.**
