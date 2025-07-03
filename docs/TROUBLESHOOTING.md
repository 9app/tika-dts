# Troubleshooting Guide

**Complete troubleshooting reference for Tika mobile development** - Common issues, solutions, and diagnostic procedures.

## 🚨 Quick Diagnostic

### First Steps for Any Issue
```bash
# 1. Check environment health
mise doctor

# 2. Check template status
./tika.sh template-status

# 3. Verify tool versions
mise curren

# 4. Check for recent changes
git log --oneline -5
```

---

## 🛠️ Environment Issues

### mise not found
**Symptoms**: `command not found: mise` or `mise: command not found`

**Solutions**:
```bash
# Install mise
curl https://mise.run | sh

# Activate in shell
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc  # For zsh
echo 'eval "$(mise activate bash)"' >> ~/.bashrc  # For bash

# Reload shell
source ~/.zshrc  # or source ~/.bashrc
```

### Tool Installation Failures
**Symptoms**: `mise install` fails or tools not available

**Solutions**:
```bash
# Clear mise cache
rm -rf ~/.local/share/mise

# Reinstall mise
curl https://mise.run | sh

# Re-run setup
./tika.sh setup

# Manual tool installation
mise install node@20.12.0
mise install flutter@3.24.0
mise install java@17.0.2
```

### Permission Errors
**Symptoms**: Permission denied errors during setup

**Solutions**:
```bash
# Fix mise permissions
chmod +x ~/.local/bin/mise

# Fix Tika script permissions
chmod +x ./tika.sh
chmod +x ./scripts/*.sh

# Check directory permissions
ls -la ./
```

---

## 📱 Platform-Specific Issues

### Android Issues

#### Android SDK not found
**Symptoms**: `ANDROID_HOME` not set or SDK not found

**Solutions**:
```bash
# Re-run Android setup
./tika.sh setup-android

# Verify environment variables
echo $ANDROID_HOME
echo $PATH

# Manual setup if needed
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
```

#### Emulator not starting
**Symptoms**: Android emulator fails to launch

**Solutions**:
```bash
# Check available emulators
$ANDROID_HOME/emulator/emulator -list-avds

# Start emulator manually
$ANDROID_HOME/emulator/emulator -avd Pixel_API_34

# Create new emulator if needed
$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd -n Pixel_API_34 -k "system-images;android-34;google_apis;x86_64"
```

#### Gradle build failures
**Symptoms**: Android build fails with Gradle errors

**Solutions**:
```bash
# Clean Gradle cache
cd android && ./gradlew clean

# Check Java version
java -version  # Should be 17.x

# Reset Gradle wrapper
cd android && rm -rf .gradle && ./gradlew wrapper
```

### iOS Issues (macOS only)

#### Xcode not found
**Symptoms**: Xcode command line tools not found

**Solutions**:
```bash
# Install Xcode command line tools
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accep

# Re-run iOS setup
./tika.sh setup-ios
```

#### iOS Simulator issues
**Symptoms**: iOS simulator not launching

**Solutions**:
```bash
# Open simulator manually
open -a Simulator

# List available simulators
xcrun simctl list devices

# Reset simulator if needed
xcrun simctl erase all
```

#### CocoaPods issues
**Symptoms**: Pod install failures

**Solutions**:
```bash
# Update CocoaPods
sudo gem install cocoapods

# Clean pod cache
cd ios && rm -rf Pods Podfile.lock
pod install

# Reset CocoaPods completely
pod deintegrate && pod install
```

---

## 🔧 Project Issues

### Development Server Issues

#### Port already in use
**Symptoms**: Development server won't start, port conflicts

**Solutions**:
```bash
# Check what's using ports
lsof -i :3000  # React Native Metro
lsof -i :8080  # Flutter web
lsof -i :19000 # Expo

# Kill process using por
kill -9 <PID>

# Use different por
mise run dev --port 3001
```

#### Hot reload not working
**Symptoms**: Changes not reflected during developmen

**Solutions**:
```bash
# Restart development server
mise run clean && mise run dev

# Clear cache
# Flutter
flutter clean && flutter pub ge

# React Native
npx react-native start --reset-cache
```

### Build Issues

#### Dependency conflicts
**Symptoms**: Build fails due to dependency versions

**Flutter Solutions**:
```bash
# Clean and reinstall dependencies
flutter clean
flutter pub ge

# Check for conflicts
flutter pub deps
```

**React Native Solutions**:
```bash
# Clean and reinstall dependencies
rm -rf node_modules package-lock.json
npm install

# Check for conflicts
npm ls
```

#### Out of memory errors
**Symptoms**: Build fails with out of memory errors

**Solutions**:
```bash
# Increase Node.js memory limi
export NODE_OPTIONS="--max-old-space-size=8192"

# For Flutter, increase Gradle memory
echo "org.gradle.jvmargs=-Xmx4g" >> android/gradle.properties
```

---

## 🔄 Template Issues

### Template Upgrade Failures

#### Upgrade conflicts
**Symptoms**: Template upgrade fails with merge conflicts

**Solutions**:
```bash
# Check current status
./tika.sh template-status

# Rollback to previous state
./tika.sh template-rollback

# Try upgrade with conflict resolution
./tika.sh template-upgrade --force

# Manual conflict resolution
git status
git diff
# Edit conflicting files manually
git add . && git commit -m "Resolve template conflicts"
```

#### Template version mismatch
**Symptoms**: Template version doesn't match expected

**Solutions**:
```bash
# Check available versions
./tika.sh template-releases

# Upgrade to specific version
./tika.sh template-upgrade --version 1.2.0

# Force refresh template cache
rm -rf ~/.cache/tika/templates
./tika.sh template-check
```

---

## 🧪 Testing Issues

### Test Failures

#### Tests not finding files
**Symptoms**: Import errors or module not found in tests

**Flutter Solutions**:
```bash
# Check test dependencies
flutter pub deps

# Run specific tes
flutter test test/specific_test.dar

# Update test imports
# Verify paths in test files match lib/ structure
```

**React Native Solutions**:
```bash
# Check Jest configuration
cat jest.config.js

# Clear Jest cache
npx jest --clearCache

# Run specific tes
npm test -- --testPathPattern=specific.test.ts
```

#### E2E test failures
**Symptoms**: Integration or E2E tests fail

**Solutions**:
```bash
# Ensure app is built for testing
mise run build

# Check emulator/simulator is running
# Flutter
flutter devices

# React Native
npx react-native run-android --list-devices
```

---

## 🔍 Diagnostic Procedures

### Health Check Procedure
```bash
# 1. Environmen
mise doctor
./tika.sh version

# 2. Project status
cd <project-directory>
mise curren
mise lis

# 3. Template status
./tika.sh template-status

# 4. Platform tools
# Android
$ANDROID_HOME/platform-tools/adb devices

# iOS (macOS)
xcrun simctl list devices | grep Booted
```

### Log Collection
```bash
# Mise logs
mise run dev 2>&1 | tee development.log

# Flutter logs
flutter doctor -v > flutter-doctor.log
flutter logs > flutter-runtime.log

# React Native logs
npx react-native log-android > android.log
npx react-native log-ios > ios.log  # macOS only

# System logs
# macOS
log show --predicate 'process == "mise"' --last 1h

# Linux
journalctl -u mise --since "1 hour ago"
```

---

## 🆘 Getting Help

### Before Asking for Help
1. **Run diagnostics**: Complete health check procedure above
2. **Check logs**: Collect relevant log files
3. **Try basic fixes**: Clean, restart, re-setup
4. **Document steps**: What you did, what failed, error messages

### Information to Include
- **Environment**: OS, shell, mise version, tool versions
- **Project type**: Flutter or React Native
- **Template version**: Output of `./tika.sh template-status`
- **Error messages**: Complete error outpu
- **Steps to reproduce**: Exact commands that cause the issue

### Self-Help Resources
- **Official Docs**: [Flutter](https://flutter.dev/docs), [React Native](https://reactnative.dev), [Expo](https://docs.expo.dev)
- **Tool Docs**: [mise](https://mise.jdx.dev), [VS Code](https://code.visualstudio.com/docs)
- **Community**: Stack Overflow, GitHub Issues, Discord communities

---

**If you've tried all relevant solutions and still have issues, collect the diagnostic information above and reach out for help with complete details.**
