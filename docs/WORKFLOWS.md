# Development Workflows Reference

**Single Source of Truth for all development processes and workflows** in the Tika mobile development template system.

## 🎯 Core Development Workflow

### Two-Phase Development Approach
```
Phase 1: Bootstrap (Tika CLI) → Phase 2: Development (Mise)
```

| Phase | Tool | Purpose | Commands |
|-------|------|---------|----------|
| **Bootstrap** | Tika CLI | System setup, project creation | `./tika.sh setup`, `./tika.sh create` |
| **Development** | Mise | Daily development, builds, tests | `mise run dev`, `mise run android` |

---

## 🚀 Setup Workflows

### Initial Environment Setup
```bash
# 1. Clone and setup (one-time)
git clone <repo-url> tika && cd tika
./tika.sh setup

# 2. Platform-specific setup (if needed)
./tika.sh setup-android    # Android developmen
./tika.sh setup-ios        # iOS development (macOS only)

# 3. Verify installation
mise doctor
./tika.sh version
```

### Project Creation Workflow
```bash
# Flutter projec
./tika.sh create --template flutter --name my-flutter-app

# React Native projec
./tika.sh create --template expo --name my-expo-app

# Advanced options
./tika.sh create --template flutter --name my-app --path ./projects/
```

---

## 🔧 Daily Development Workflows

### Flutter Developmen
```bash
# In project directory
mise run dev                # Start development server
mise run android            # Launch Android emulator
mise run ios               # Launch iOS simulator (macOS)
mise run web               # Launch web browser
mise run test              # Run all tests
mise run build             # Build for production
```

### React Native Developmen
```bash
# In project directory
mise run dev                # Start Expo development server
mise run android            # Launch Android emulator
mise run ios               # Launch iOS simulator (macOS)
mise run web               # Launch web browser
mise run test              # Run all tests
mise run build             # Build for production
```

---

## 🔄 Template Management Workflows

### Template Status & Upgrade
```bash
# Check current template status
./tika.sh template-status
mise run template:status

# Check for available upgrades
./tika.sh template-check
mise run template:check

# Upgrade to latest version
./tika.sh template-upgrade
mise run template:upgrade

# Rollback if issues occur
./tika.sh template-rollback
mise run template:rollback
```

### Template Upgrade Process
1. **Pre-upgrade check**: `template-status` to see current version
2. **Dry run**: `template-upgrade --dry-run` to preview changes
3. **Backup**: Git automatically creates commit before upgrade
4. **Upgrade**: Apply new template version
5. **Validation**: Test project still works
6. **Rollback option**: `template-rollback` if issues found

### Git-Based Template Upgrade Workflow

The template upgrade system uses Git for version control, conflict resolution, and rollback capabilities.

#### Phase 1: Pre-Upgrade Preparation
```bash
# 1. Ensure clean git state
git status --porcelain

# 2. Create upgrade branch
git checkout -b "template-upgrade-$(date +%Y%m%d-%H%M%S)"

# 3. Commit current state (if needed)
git add -A && git commit -m "feat: save state before template upgrade"
```

#### Phase 2: Template Update with Git Integration
```bash
# 4. Apply template changes
./tika.sh template-upgrade
# Or use mise task
mise run template:upgrade

# 5. Resolve any conflicts using git tools
git status  # Shows conflicted files
git mergetool  # Opens merge tool (VS Code, vimdiff, etc.)

# 6. Commit resolved changes
git add .
git commit -m "feat: upgrade template to new version

- List major changes
- List any manual fixes applied"
```

#### Phase 3: Validation and Finalization
```bash
# 7. Test that everything works
mise run verify
mise run tes

# 8. If successful, merge back to main branch
git checkout main
git merge template-upgrade-XXXXXXXX

# 9. If issues found, use built-in rollback
git checkout main
# OR use template rollback command
./tika.sh template-rollback
```

### Migration from Backup-Based to Git-Based Upgrades

If you have a project using the old backup-based system:

```bash
# Check current template status
./scripts/template-upgrade-git.sh status

# Clean up old backups if needed
rm -rf .template-backups/

# The git-integrated system will now handle your template upgrades
```

---

## 🧪 Testing & Validation Workflows

### Template Validation
```bash
# Test templates with reference implementations
cd playground/apps/flutter_app     # Flutter reference
cd playground/apps/mobile-app      # React Native reference

# Run comprehensive validation
cd playground && ./scripts/test-runner.sh

# Create test projects
./scripts/create-new-project.sh --template flutter --name test-projec
```

### Quality Assurance Workflow
```bash
# Code quality checks
mise run lint               # Code analysis and linting
mise run format             # Code formatting
mise run test               # Unit and widget/component tests

# Integration testing
mise run test:integration   # Integration tests
mise run test:e2e          # End-to-end tests

# Performance checks
mise run analyze           # Performance analysis
mise run doctor            # Environment health check
```

---

## 👥 Team Development Workflows

### New Team Member Onboarding
```bash
# 1. Environment setup
./tika.sh setup

# 2. Verify installation
mise doctor
./tika.sh version

# 3. Create test project to verify
./tika.sh create --template flutter --name onboarding-tes
cd onboarding-test && mise run dev
```

### Code Review Workflow
1. **Development**: Follow platform-specific patterns from [ARCHITECTURE.md](./ARCHITECTURE.md)
2. **Quality**: Run `mise run lint` and `mise run test` before commi
3. **Review**: Use architecture patterns as quality guidelines
4. **Testing**: Validate changes work in test environmen

### Release Workflow
```bash
# Pre-release validation
mise run test               # All tests pass
mise run lint               # No linting errors
mise run build             # Production build works

# Template updates (if needed)
./tika.sh template-upgrade  # Update to latest template
mise run test               # Validate after template update

# Release preparation
mise run build:release      # Production build
mise run test:e2e          # Final E2E validation
```

---

## 🔍 Troubleshooting Workflows

### Common Issue Resolution
```bash
# Environment issues
mise doctor                 # Check tool installation
mise install               # Reinstall tools
./tika.sh setup            # Re-run setup

# Template issues
./tika.sh template-rollback # Rollback problematic upgrade
mise run template:status    # Check template state

# Development issues
mise run clean             # Clean build artifacts
mise run dev               # Restart development server

# Platform-specific issues
./tika.sh setup-android    # Re-setup Android
./tika.sh setup-ios        # Re-setup iOS (macOS)
```

### Debug Workflow
1. **Identify Issue**: Check error messages and logs
2. **Environment Check**: Run `mise doctor` to verify tools
3. **Template Check**: Run `template-status` to verify version
4. **Incremental Fix**: Apply fixes one at a time
5. **Validation**: Test fix with `mise run dev`
6. **Documentation**: Update troubleshooting guide if new issue

---

## 📋 Best Practices

### Development Workflow Best Practices
- **Incremental Development**: Make small, testable changes
- **Quality Gates**: Run tests and linting before commits
- **Template Updates**: Keep templates current but test thoroughly
- **Documentation**: Update docs when changing workflows

### Team Workflow Best Practices
- **Consistent Environment**: All team members use same tool versions
- **Code Standards**: Follow architecture patterns from templates
- **Review Process**: Use documented patterns as review criteria
- **Knowledge Sharing**: Document new patterns and solutions

### Maintenance Workflow Best Practices
- **Regular Updates**: Keep tools and templates curren
- **Validation**: Test changes in playground environment firs
- **Backup Strategy**: Use git for all template changes
- **Monitoring**: Regular health checks with `mise doctor`

---

**This workflow reference is the single source of truth for all development processes. All other documentation files should reference these workflows rather than duplicating content.**
