#!/bin/bash

# verify-rn.sh - React Native/Expo environment verification script
# This script verifies the React Native/Expo development environment

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
    echo "🔍 React Native/Expo Environment Verification"
    echo "============================================="
    echo
}

check_node() {
    print_status "Checking Node.js environment..."

    if command_exists node; then
        version=$(node --version 2>/dev/null)
        print_success "✓ Node.js: $version"
    else
        print_error "✗ Node.js is not available"
        return 1
    fi

    if command_exists npm; then
        version=$(npm --version 2>/dev/null)
        print_success "✓ npm: $version"
    else
        print_error "✗ npm is not available"
        return 1
    fi

    # Check if yarn is available (optional)
    if command_exists yarn; then
        version=$(yarn --version 2>/dev/null)
        print_success "✓ Yarn: $version"
    else
        print_warning "⚠ Yarn not available (optional)"
    fi
}

check_expo() {
    print_status "Checking Expo environment..."

    # Check Expo CLI globally
    if command_exists expo; then
        print_success "✓ Expo CLI is available globally"
        expo --version 2>/dev/null || print_warning "Could not get Expo version"
    else
        print_warning "⚠ Expo CLI not available globally"
    fi

    # Check local Expo CLI
    if command_exists npx; then
        print_status "Checking local Expo CLI..."
        npx expo --version 2>/dev/null && print_success "✓ Local Expo CLI works" || print_warning "⚠ Local Expo CLI issues"
    fi

    # Run Expo doctor
    if command_exists npx; then
        print_status "Running Expo doctor..."
        npx expo doctor || print_warning "Expo doctor found issues"
    fi
}

check_react_native() {
    print_status "Checking React Native environment..."

    # Check if npx is available for React Native CLI
    if command_exists npx; then
        print_success "✓ npx is available (can run React Native commands)"
    else
        print_error "✗ npx is not available"
        return 1
    fi

    # Check if this is a React Native project
    if [[ -f "package.json" ]] && grep -q "react-native" package.json; then
        print_success "✓ React Native project detected"
        
        # Run React Native doctor if available
        print_status "Running React Native doctor..."
        npx react-native doctor || print_warning "React Native doctor found issues"
    else
        print_warning "⚠ Not a React Native project or package.json not found"
    fi

    # Check Metro bundler
    if [[ -f "metro.config.js" ]]; then
        print_success "✓ Metro configuration found"
    else
        print_warning "⚠ Metro configuration not found"
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

    # Check for Android Studio (macOS)
    OS=$(detect_os)
    if [[ "$OS" == "macos" ]]; then
        if [[ -d "/Applications/Android Studio.app" ]]; then
            print_success "✓ Android Studio is installed"
        else
            print_warning "⚠ Android Studio not found"
        fi
    fi

    # Check Gradle
    if command_exists gradle; then
        gradle_version=$(gradle --version | grep "Gradle" | head -n1)
        print_success "✓ $gradle_version"
    else
        print_warning "⚠ Gradle not found in PATH (project has wrapper)"
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
        print_warning "⚠ android/ directory not found"
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

    # Check iOS Simulator
    if command_exists xcrun; then
        simulators=$(xcrun simctl list devices available | grep "iPhone" | wc -l)
        if [[ $simulators -gt 0 ]]; then
            print_success "✓ iOS Simulators available: $simulators"
        else
            print_warning "⚠ No iOS Simulators found"
        fi
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
        print_warning "⚠ ios/ directory not found"
    fi
}

check_project_dependencies() {
    print_status "Checking project dependencies..."

    # Check package.json
    if [[ -f "package.json" ]]; then
        print_success "✓ package.json found"
        
        # Check node_modules
        if [[ -d "node_modules" ]]; then
            print_success "✓ Node.js dependencies installed"
        else
            print_warning "⚠ Node.js dependencies not installed (run: npm install)"
        fi
    else
        print_error "✗ package.json not found"
    fi

    # Check key React Native/Expo dependencies
    if [[ -f "package.json" ]]; then
        if grep -q "expo" package.json; then
            print_success "✓ Expo project detected"
        elif grep -q "react-native" package.json; then
            print_success "✓ React Native project detected"
        else
            print_warning "⚠ Neither Expo nor React Native detected in package.json"
        fi
    fi
}

run_health_tests() {
    print_status "Running health tests..."

    # Test Node.js
    if command_exists node; then
        node_test=$(node -e "console.log('Node.js works')" 2>/dev/null)
        if [[ "$node_test" == "Node.js works" ]]; then
            print_success "✓ Node.js execution test passed"
        else
            print_error "✗ Node.js execution test failed"
        fi
    fi

    # Test npm
    if command_exists npm; then
        npm_test=$(npm --version 2>/dev/null)
        if [[ -n "$npm_test" ]]; then
            print_success "✓ npm execution test passed"
        else
            print_error "✗ npm execution test failed"
        fi
    fi

    # Test Expo CLI
    if command_exists npx; then
        expo_test=$(npx expo --version 2>/dev/null)
        if [[ -n "$expo_test" ]]; then
            print_success "✓ Expo CLI execution test passed"
        else
            print_warning "⚠ Expo CLI execution test failed"
        fi
    fi
}

print_summary() {
    echo
    echo "📋 Verification Summary"
    echo "======================"
    echo
    echo "If you see any errors above, please:"
    echo "1. Run the setup script: ./scripts/setup-rn.sh"
    echo "2. Install missing dependencies manually"
    echo "3. Restart your terminal and try again"
    echo
    echo "Available commands after successful setup:"
    echo "• mise run dev          - Start Expo development server"
    echo "• mise run android      - Run on Android"
    echo "• mise run ios          - Run on iOS (macOS only)"
    echo "• mise run test         - Run tests"
    echo "• mise run verify       - Run this verification again"
    echo
}

main() {
    print_header

    local exit_code=0

    check_node || exit_code=1
    check_expo
    check_react_native
    check_android
    check_ios
    check_project_dependencies
    run_health_tests

    print_summary

    if [[ $exit_code -eq 0 ]]; then
        print_success "🎉 React Native/Expo environment verification completed successfully!"
    else
        print_error "❌ Environment verification found issues. Please check the errors above."
    fi

    exit $exit_code
}

main "$@"
