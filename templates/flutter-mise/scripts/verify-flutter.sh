#!/bin/bash

# verify-flutter.sh - Flutter environment verification script
# This script verifies the Flutter development environment

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
    echo "🔍 Flutter Environment Verification"
    echo "==================================="
    echo
}

check_flutter() {
    print_status "Checking Flutter installation..."

    if command_exists flutter; then
        print_success "✓ Flutter is available"
        flutter --version
        
        print_status "Running Flutter doctor..."
        flutter doctor
    else
        print_error "✗ Flutter is not installed"
        return 1
    fi
}

check_dart() {
    print_status "Checking Dart installation..."

    if command_exists dart; then
        version=$(dart --version 2>/dev/null)
        print_success "✓ Dart: $version"
    else
        print_warning "⚠ Dart not available (should come with Flutter)"
    fi
}

check_android() {
    print_status "Checking Android development setup..."

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
    fi

    # Check ADB
    if command_exists adb; then
        adb_version=$(adb --version | head -n1)
        print_success "✓ ADB: $adb_version"
    else
        print_error "✗ ADB is not available (check Android SDK platform-tools)"
    fi

    # Check Android project structure
    if [[ -d "android" ]]; then
        print_success "✓ android/ directory found"
        
        # Check gradlew
        if [[ -f "android/gradlew" ]]; then
            print_success "✓ Gradle wrapper found"
        else
            print_warning "⚠ Gradle wrapper not found"
        fi
    else
        print_warning "⚠ android/ directory not found (run flutter create . if needed)"
    fi
}

check_ios() {
    OS=$(detect_os)
    if [[ "$OS" != "macos" ]]; then
        print_warning "⚠ iOS development is only available on macOS"
        return
    fi

    print_status "Checking iOS development setup..."

    # Check Xcode
    if command_exists xcodebuild; then
        xcode_version=$(xcodebuild -version | head -n1)
        print_success "✓ $xcode_version"

        # Check command line tools
        if xcode-select -p &>/dev/null; then
            print_success "✓ Xcode command line tools are installed"
        else
            print_error "✗ Xcode command line tools not installed"
        fi
    else
        print_error "✗ Xcode is not installed"
    fi

    # Check CocoaPods
    if command_exists pod; then
        pod_version=$(pod --version)
        print_success "✓ CocoaPods: $pod_version"
    else
        print_error "✗ CocoaPods is not installed"
    fi

    # Check iOS project structure
    if [[ -d "ios" ]]; then
        print_success "✓ ios/ directory found"
        
        # Check Podfile
        if [[ -f "ios/Podfile" ]]; then
            print_success "✓ Podfile found"
            
            # Check if pods are installed
            if [[ -d "ios/Pods" ]]; then
                print_success "✓ iOS dependencies installed"
            else
                print_warning "⚠ iOS dependencies not installed (run: cd ios && pod install)"
            fi
        else
            print_warning "⚠ Podfile not found"
        fi
    else
        print_warning "⚠ ios/ directory not found (run flutter create . if needed)"
    fi
}

check_project_structure() {
    print_status "Checking Flutter project structure..."

    # Check pubspec.yaml
    if [[ -f "pubspec.yaml" ]]; then
        print_success "✓ pubspec.yaml found"
        
        # Check if dependencies are installed
        if [[ -d ".dart_tool" ]]; then
            print_success "✓ Flutter dependencies installed"
        else
            print_warning "⚠ Flutter dependencies not installed (run: flutter pub get)"
        fi
    else
        print_error "✗ pubspec.yaml not found - not a Flutter project?"
    fi

    # Check lib directory
    if [[ -d "lib" ]]; then
        print_success "✓ lib/ directory found"
        
        # Check main.dart
        if [[ -f "lib/main.dart" ]]; then
            print_success "✓ lib/main.dart found"
        else
            print_warning "⚠ lib/main.dart not found"
        fi
    else
        print_warning "⚠ lib/ directory not found"
    fi
}

check_development_tools() {
    print_status "Checking development tools..."

    # Check Java
    if command_exists java; then
        version=$(java -version 2>&1 | head -n1)
        print_success "✓ Java: $version"
    else
        print_error "✗ Java is not available"
    fi

    # Check Node.js (for Flutter web)
    if command_exists node; then
        version=$(node --version 2>/dev/null)
        print_success "✓ Node.js: $version (for Flutter web)"
    else
        print_warning "⚠ Node.js not available (needed for Flutter web)"
    fi
}

run_flutter_tests() {
    print_status "Running Flutter health tests..."

    # Test Flutter analyze
    if [[ -f "pubspec.yaml" ]]; then
        print_status "Running Flutter analyze..."
        flutter analyze || print_warning "Flutter analyze found issues"
    fi

    # Test Flutter test
    if [[ -d "test" ]]; then
        print_status "Running Flutter tests..."
        flutter test || print_warning "Flutter tests failed"
    else
        print_warning "⚠ No test directory found"
    fi

    # Test Flutter doctor
    print_status "Final Flutter doctor check..."
    flutter doctor || print_warning "Flutter doctor found issues"
}

print_summary() {
    echo
    echo "📋 Verification Summary"
    echo "======================"
    echo
    echo "If you see any errors above, please:"
    echo "1. Run the setup script: ./scripts/setup-flutter.sh"
    echo "2. Install missing dependencies manually"
    echo "3. Run flutter doctor and follow suggestions"
    echo "4. Restart your terminal and try again"
    echo
    echo "Available commands after successful setup:"
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

    local exit_code=0

    check_flutter || exit_code=1
    check_dart
    check_android
    check_ios
    check_project_structure
    check_development_tools
    run_flutter_tests

    print_summary

    if [[ $exit_code -eq 0 ]]; then
        print_success "🎉 Flutter environment verification completed successfully!"
    else
        print_error "❌ Environment verification found issues. Please check the errors above."
    fi

    exit $exit_code
}

main "$@"
