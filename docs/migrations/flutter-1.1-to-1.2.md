# Flutter Template Migration Guide: v1.1 → v1.2

## Overview

This guide helps you migrate from Flutter template version 1.1.0 to 1.2.0. This is a **major version upgrade** with breaking changes that require manual intervention.

## Breaking Changes

### 1. Task Name Changes

Several mise tasks have been renamed for consistency:

| Old Task Name | New Task Name | Description |
|---------------|---------------|-------------|
| `mise run build:apk-debug` | `mise run build:debug` | Build debug APK |
| `mise run build:apk-release` | `mise run build:release` | Build release APK |
| `mise run flutter:test` | `mise run test` | Run all tests |
| `mise run flutter:clean` | `mise run clean` | Clean project |

### 2. Flutter SDK Update

- **From**: Flutter 3.31.0
- **To**: Flutter 3.32.5-stable

This update includes:
- New Material Design 3 components
- Updated Android Gradle Plugin requirements
- Enhanced web performance
- Breaking changes in some APIs

### 3. Environment Variable Changes

New required environment variables:

```bash
# New in v1.2.0
FLUTTER_ROOT=$HOME/.mise/installs/flutter/3.32.5-stable
ANDROID_SDK_ROOT=$ANDROID_HOME  # Replaces ANDROID_SDK_HOME

# Updated paths
PATH=$FLUTTER_ROOT/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH
```

### 4. Android Configuration Updates

- Minimum Android SDK version: **34** (was 33)
- Compile SDK version: **34** (was 33)
- Kotlin version: **1.9.10** (was 1.8.20)
- Android Gradle Plugin: **8.1.0** (was 7.4.0)

### 5. iOS Configuration Updates

- Minimum iOS version: **12.0** (was 11.0)
- Xcode minimum version: **15.0** (was 14.0)

## Migration Steps

### Step 1: Backup Your Projec

```bash
# Create backup before migration
mise run template:upgrade:backup
```

### Step 2: Update Task Scripts

If you have custom scripts that call the old task names, update them:

```bash
# Old
mise run build:apk-debug
mise run flutter:tes

# New
mise run build:debug
mise run tes
```

### Step 3: Update Android Configuration

#### android/app/build.gradle

```gradle
android {
    compileSdkVersion 34  // Changed from 33

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34  // Changed from 33
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }
}
```

#### android/build.gradle

```gradle
buildscript {
    ext.kotlin_version = '1.9.10'  // Updated from 1.8.20
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'  // Updated from 7.4.0
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

### Step 4: Update iOS Configuration

#### ios/Podfile

```ruby
platform :ios, '12.0'  # Updated from 11.0
```

### Step 5: Update Dependencies

```bash
# Update Flutter dependencies
mise run deps:upgrade

# Update platform-specific dependencies
cd ios && pod update && cd ..
cd android && ./gradlew clean && cd ..
```

### Step 6: Test Migration

```bash
# Verify setup
mise run doctor

# Run tests
mise run tes

# Test builds
mise run build:debug
mise run build:release
```

## Code Changes Required

### 1. Material Design 3 Updates

If you're using Material Design components, some APIs have changed:

```dar
// Before v1.2.0
Theme(
  data: ThemeData(
    primarySwatch: Colors.blue,
  ),
  child: MyApp(),
)

// After v1.2.0 (Material Design 3)
Theme(
  data: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
  child: MyApp(),
)
```

### 2. Deprecated API Replacements

```dar
// Replace deprecated TextTheme properties
// Before
textTheme: TextTheme(
  headline1: TextStyle(...),  // Deprecated
  headline2: TextStyle(...),  // Deprecated
)

// After
textTheme: TextTheme(
  displayLarge: TextStyle(...),   // Replaces headline1
  displayMedium: TextStyle(...),  // Replaces headline2
)
```

## Troubleshooting

### Common Issues

#### 1. Build Failures After Upgrade

```bash
# Clean everything and reinstall
mise run clean
flutter clean
flutter pub ge
cd ios && pod install && cd ..
cd android && ./gradlew clean && cd ..
```

#### 2. Android Build Issues

```bash
# Update Android SDK
mise run setup:android

# Check SDK licenses
flutter doctor --android-licenses
```

#### 3. iOS Build Issues

```bash
# Update iOS setup
mise run setup:ios

# Clean iOS build
cd ios
rm -rf build/
pod deintegrate
pod install
cd ..
```

#### 4. VS Code Issues

```bash
# Restart Dart Analysis Server
# In VS Code: Cmd+Shift+P -> "Dart: Restart Analysis Server"

# Clear VS Code cache
rm -rf .vscode/launch.json
```

## Rollback Plan

If you encounter issues, you can rollback to the previous version:

```bash
# Rollback to previous template version
mise run template:upgrade:rollback --version 1.1.0

# Or restore from backup
mise run template:upgrade:restore --backup <backup-name>
```

## Validation Checklis

After migration, verify:

- [ ] `mise run doctor` passes without errors
- [ ] `mise run test` runs successfully
- [ ] `mise run build:debug` works
- [ ] `mise run build:release` works
- [ ] Android app runs on device/emulator
- [ ] iOS app runs on device/simulator (if on macOS)
- [ ] Web app builds and runs (if using web)
- [ ] All custom tasks still work
- [ ] VS Code integration works properly

## Getting Help

If you encounter issues during migration:

1. Check the [troubleshooting section](#troubleshooting) above
2. Run `mise run doctor` for diagnostic information
3. Check the [Flutter upgrade guide](https://docs.flutter.dev/release/upgrade)
4. Create an issue in the project repository with:
   - Error messages
   - Output from `mise run doctor`
   - Your platform (macOS/Linux/Windows)
   - Template versions (before/after)

## Post-Migration Notes

After successful migration:

1. Update your documentation to reference new task names
2. Train team members on the changes
3. Update CI/CD pipelines if they use the old task names
4. Consider updating your project's README with the new commands

## Changelog Summary

### Added
- New `mise run build:profile` task for profile builds
- Enhanced Android emulator managemen
- Improved web development workflow
- Better integration test automation

### Changed
- Task naming convention for consistency
- Flutter SDK to 3.32.5-stable
- Android SDK requirements (min SDK 34)
- iOS minimum version (12.0)
- Material Design 3 as defaul

### Removed
- Legacy task names (with deprecation warnings)
- Support for Flutter SDK < 3.30.0
- Support for Android SDK < 34
