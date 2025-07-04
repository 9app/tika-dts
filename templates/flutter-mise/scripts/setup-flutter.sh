#!/bin/bash

# setup-flutter.sh - Flutter project setup script
# This script is specific to Flutter projects using mise

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "other"
    fi
}

print_header() {
    echo
    echo "🚀 Flutter Project Setup"
    echo "========================"
    echo
}

setup_flutter() {
    print_status "Setting up Flutter development environment..."

    # Check if Flutter is available
    if command_exists flutter; then
        print_success "✓ Flutter is available"
        flutter --version
    else
        print_error "✗ Flutter is not installed"
        print_status "Please install Flutter from: https://flutter.dev/docs/get-started/install"
        return 1
    fi

    # Flutter doctor
    print_status "Running Flutter doctor..."
    flutter doctor

    # Get dependencies
    if [[ -f "pubspec.yaml" ]]; then
        print_status "Installing Flutter dependencies..."
        flutter pub get
        print_success "✓ Flutter dependencies installed"
    fi

    # Generate platform-specific files if needed
    if [[ ! -d "android" ]] || [[ ! -d "ios" ]]; then
        print_status "Creating platform-specific files..."
        flutter create . --org com.example --project-name "$(basename "$PWD")"
    fi
}

setup_android() {
    print_status "Setting up Android development..."

    OS=$(detect_os)
    
    # Check Android SDK
    if [[ -n "$ANDROID_HOME" ]]; then
        expanded_path="${ANDROID_HOME/#\~/$HOME}"
        if [[ -d "$expanded_path" ]]; then
            print_success "✓ ANDROID_HOME is set: $ANDROID_HOME"
        else
            print_error "✗ ANDROID_HOME directory doesn't exist: $expanded_path"
        fi
    else
        print_error "✗ ANDROID_HOME is not set"
        if [[ "$OS" == "macos" ]]; then
            print_status "Recommended: export ANDROID_HOME=~/Library/Android/sdk"
        else
            print_status "Recommended: export ANDROID_HOME=~/Android/Sdk"
        fi
    fi

    # Check ADB
    if command_exists adb; then
        print_success "✓ ADB is available"
    else
        print_error "✗ ADB is not available"
    fi

    # Accept Android licenses
    if command_exists flutter; then
        print_status "Accepting Android licenses..."
        flutter doctor --android-licenses || print_warning "Could not accept Android licenses"
    fi
}

setup_ios() {
    OS=$(detect_os)
    if [[ "$OS" != "macos" ]]; then
        print_warning "⚠ iOS development is only available on macOS"
        return
    fi

    print_status "Setting up iOS development..."

    # Check Xcode
    if command_exists xcodebuild; then
        print_success "✓ Xcode is available"
        xcodebuild -version
    else
        print_error "✗ Xcode is not installed"
        return 1
    fi

    # Check CocoaPods
    if command_exists pod; then
        print_success "✓ CocoaPods is available"
    else
        print_warning "⚠ CocoaPods is not installed"
        print_status "Installing CocoaPods..."
        gem install cocoapods || print_error "Failed to install CocoaPods"
    fi

    # Install iOS dependencies
    if [[ -f "ios/Podfile" ]]; then
        print_status "Installing iOS dependencies..."
        cd ios
        pod install || print_warning "Pod install failed"
        cd ..
        print_success "✓ iOS dependencies installed"
    fi
}

create_vscode_settings() {
    print_status "Creating VS Code settings..."

    mkdir -p .vscode

    # Launch configuration
    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter: Debug",
            "type": "dart",
            "request": "launch",
            "program": "lib/main.dart"
        },
        {
            "name": "Flutter: Profile",
            "type": "dart",
            "request": "launch",
            "program": "lib/main.dart",
            "flutterMode": "profile"
        },
        {
            "name": "Flutter: Release",
            "type": "dart",
            "request": "launch",
            "program": "lib/main.dart",
            "flutterMode": "release"
        }
    ]
}
EOF

    # Settings
    cat > .vscode/settings.json << 'EOF'
{
    "dart.flutterSdkPath": null,
    "dart.lineLength": 120,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll": "explicit"
    },
    "files.exclude": {
        "**/.dart_tool": true,
        "**/.packages": true,
        "**/build": true
    }
}
EOF

    print_success "✓ VS Code settings created"
}

run_verification() {
    print_status "Running environment verification..."

    local all_good=true

    # Check Flutter
    if ! flutter doctor; then
        all_good=false
    fi

    # Check if project can be analyzed
    if [[ -f "pubspec.yaml" ]]; then
        flutter analyze || print_warning "Flutter analyze found issues"
    fi

    if [[ "$all_good" == true ]]; then
        print_success "🎉 Flutter setup completed successfully!"
    else
        print_warning "⚠ Setup completed with warnings. Check Flutter doctor output above."
    fi
}

print_summary() {
    echo
    echo "📋 Setup Summary"
    echo "================"
    echo
    echo "Flutter project setup completed. Available commands:"
    echo "• mise run dev          - Start Flutter app in development mode"
    echo "• mise run android      - Run on Android device/emulator"
    echo "• mise run ios          - Run on iOS simulator (macOS only)"
    echo "• mise run test         - Run Flutter tests"
    echo "• mise run doctor       - Check Flutter environment"
    echo "• mise run build        - Build release version"
    echo
}

main() {
    print_header

    setup_flutter
    setup_android
    setup_ios
    create_vscode_settings
    run_verification
    print_summary
}

main "$@"
