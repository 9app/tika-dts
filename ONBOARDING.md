# New Member Onboarding Checklist

Welcome to the mobile development team! This checklist will guide you through the setup process.

## ✅ Pre-Setup Checklist

### System Requirements
- [ ] **macOS** (for iOS development) or **Linux/Windows** (for Android only)
- [ ] **8GB+ RAM** (16GB recommended)
- [ ] **50GB+ free disk space**
- [ ] **Stable internet connection**

### Prerequisites
- [ ] **Git** installed and configured
- [ ] **Terminal/Command Line** access
- [ ] **Admin/sudo** privileges on your machine

## 🚀 Quick Setup (Recommended)

### Step 1: Clone Repository
```bash
git clone [repository-url]
cd [project-name]
```

### Step 2: Run Automated Setup
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### Step 3: Verify Installation
```bash
mise run verify
```

## 📋 Manual Setup (If Needed)

### 1. Install Mise
- [ ] Install mise: `brew install mise` or `curl https://mise.run | sh`
- [ ] Add to shell: `echo 'eval "$(mise activate zsh)"' >> ~/.zshrc`
- [ ] Restart terminal

### 2. Install Development Tools
- [ ] Run: `mise install`
- [ ] Verify tools: `mise doctor`

### 3. Platform-Specific Setup

#### Android Development
- [ ] Install Android Studio
- [ ] Run: `mise run setup:android`
- [ ] Accept Android licenses
- [ ] Create Android emulator

#### iOS Development (macOS only)
- [ ] Install Xcode from App Store
- [ ] Run: `mise run setup:ios`
- [ ] Accept Xcode license
- [ ] Install iOS Simulator

## 🧪 Test Your Setup

### Environment Verification
- [ ] Run: `mise run doctor`
- [ ] All tools show green checkmarks
- [ ] No error messages

### Test Builds
- [ ] React Native: `mise run dev` → `mise run android`
- [ ] Flutter: `mise run flutter`
- [ ] iOS (macOS): `mise run ios`

### Test Development Workflow
- [ ] Make a small code change
- [ ] Hot reload works
- [ ] Debugger connects

## 💡 Development Tools

### VS Code Setup
- [ ] Install recommended extensions (see `.vscode/extensions.json`)
- [ ] Mise plugin automatically configures tools
- [ ] IntelliSense works for React Native/Flutter

### Available Commands
Learn these essential commands:
```bash
# Development
mise run dev          # Start Metro bundler
mise run android      # Run on Android
mise run ios          # Run on iOS (macOS)
mise run flutter      # Run Flutter app

# Testing
mise run test         # Run all tests
mise run lint         # Check code quality

# Maintenance
mise run clean        # Clean build artifacts
mise run setup        # Re-run setup
```

## 🔧 Troubleshooting

### Common Issues

#### "Command not found" errors
```bash
mise doctor
mise rehash
source ~/.zshrc
```

#### Android SDK issues
```bash
mise run setup:android
# Or manually set ANDROID_HOME in environment
```

#### iOS build failures (macOS)
```bash
mise run setup:ios
cd ios && pod install
```

#### Node modules issues
```bash
mise run clean
npm install
```

### Getting Help
- [ ] Check project documentation in `/docs`
- [ ] Run diagnostic: `mise run doctor`
- [ ] Ask team members in Slack/Discord
- [ ] Create issue in project repository

## 📚 Learning Resources

### Required Reading
- [ ] Project README.md
- [ ] Architecture documentation
- [ ] Code style guide
- [ ] Git workflow guidelines

### Recommended Learning
- [ ] [Mise Documentation](https://mise.jdx.dev)
- [ ] [React Native Docs](https://reactnative.dev)
- [ ] [Flutter Docs](https://flutter.dev)
- [ ] Team coding standards

## ✨ First Tasks

### Getting Familiar
- [ ] Explore codebase structure
- [ ] Run existing tests
- [ ] Set up debugging workflow
- [ ] Join team communication channels

### Template Management
- [ ] Check template status: `mise run template:status`
- [ ] Learn upgrade workflow: `mise run template:check`
- [ ] Understand rollback: `mise run template:rollback --help`
- [ ] Review git-integrated upgrades in docs

### Initial Contributions
- [ ] Fix a simple bug or typo
- [ ] Add unit test for existing feature
- [ ] Update documentation
- [ ] Pair program with team member

## 🎯 Success Criteria

You're ready for development when:
- [ ] ✅ `mise run verify` passes completely
- [ ] ✅ Can build and run apps on target platforms
- [ ] ✅ Development workflow is smooth
- [ ] ✅ Can run tests and debugging
- [ ] ✅ IDE/editor is properly configured
- [ ] ✅ Understand team processes and guidelines

## 📞 Contacts

### Technical Support
- **Mise Issues**: [GitHub Issues](https://github.com/jdx/mise/issues)
- **Team Lead**: [Name] - [Contact]
- **DevOps**: [Name] - [Contact]

### Project Resources
- **Documentation**: [Link]
- **Team Chat**: [Slack/Discord]
- **Issue Tracker**: [Jira/GitHub]
- **CI/CD**: [Jenkins/GitHub Actions]

---

## 💬 Feedback

After completing setup, please:
- [ ] Update this checklist if steps were unclear
- [ ] Report any issues or improvements
- [ ] Share feedback with the team

**Welcome to the team! 🎉**
