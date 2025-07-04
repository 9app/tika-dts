#!/bin/bash

# setup-rn.sh - React Native/Expo project setup script
# This script is specific to React Native/Expo projects using mise

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
    echo "🚀 React Native/Expo Project Setup"
    echo "=================================="
    echo
}

setup_node() {
    print_status "Setting up Node.js environment..."

    if command_exists node; then
        print_success "✓ Node.js is available: $(node --version)"
    else
        print_error "✗ Node.js is not installed"
        return 1
    fi

    if command_exists npm; then
        print_success "✓ npm is available: $(npm --version)"
    else
        print_error "✗ npm is not available"
        return 1
    fi

    # Install dependencies
    if [[ -f "package.json" ]]; then
        print_status "Installing Node.js dependencies..."
        npm install
        print_success "✓ Node.js dependencies installed"
    fi
}

setup_expo() {
    print_status "Setting up Expo CLI..."

    # Check if Expo CLI is available globally or locally
    if command_exists expo; then
        print_success "✓ Expo CLI is available globally"
    elif [[ -f "package.json" ]] && grep -q "@expo/cli" package.json; then
        print_success "✓ Expo CLI is available locally"
    else
        print_status "Installing Expo CLI globally..."
        npm install -g @expo/cli
    fi

    # Run Expo doctor if available
    if command_exists npx; then
        print_status "Running Expo doctor..."
        npx expo doctor || print_warning "Expo doctor found issues"
    fi
}

setup_react_native() {
    print_status "Setting up React Native environment..."

    # Check React Native CLI
    if command_exists npx; then
        print_success "✓ npx is available (can run React Native commands)"
    else
        print_error "✗ npx is not available"
        return 1
    fi

    # Check if it's a React Native project
    if [[ -f "package.json" ]] && grep -q "react-native" package.json; then
        print_status "React Native project detected"
        
        # Run React Native doctor if available
        npx react-native doctor || print_warning "React Native doctor found issues"
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

    # Check for Android directory
    if [[ -d "android" ]]; then
        print_success "✓ Android project directory found"
        
        # Generate gradlew permissions
        if [[ -f "android/gradlew" ]]; then
            chmod +x android/gradlew
            print_success "✓ Gradle wrapper permissions set"
        fi
    else
        print_warning "⚠ No Android directory found"
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

    # Launch configuration for React Native
    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Expo: Start",
            "type": "node",
            "request": "launch",
            "program": "${workspaceFolder}/node_modules/.bin/expo",
            "args": ["start"],
            "console": "integratedTerminal"
        },
        {
            "name": "React Native: Debug Android",
            "type": "reactnative",
            "request": "launch",
            "platform": "android"
        },
        {
            "name": "React Native: Debug iOS",
            "type": "reactnative", 
            "request": "launch",
            "platform": "ios"
        }
    ]
}
EOF

    # Settings
    cat > .vscode/settings.json << 'EOF'
{
    "typescript.preferences.importModuleSpecifier": "relative",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": "explicit"
    },
    "files.exclude": {
        "**/node_modules": true,
        "**/.expo": true,
        "**/ios/build": true,
        "**/android/build": true,
        "**/android/.gradle": true
    },
    "emmet.includeLanguages": {
        "javascript": "javascriptreact"
    }
}
EOF

    print_success "✓ VS Code settings created"
}

setup_metro() {
    print_status "Setting up Metro bundler..."

    # Create or update metro.config.js if it doesn't exist
    if [[ ! -f "metro.config.js" ]]; then
        cat > metro.config.js << 'EOF'
const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

module.exports = config;
EOF
        print_success "✓ Metro configuration created"
    else
        print_success "✓ Metro configuration already exists"
    fi
}

run_verification() {
    print_status "Running environment verification..."

    local all_good=true

    # Check Node.js
    if ! command_exists node; then
        all_good=false
    fi

    # Check npm/yarn
    if ! command_exists npm && ! command_exists yarn; then
        all_good=false
    fi

    # Check if dependencies are installed
    if [[ -f "package.json" ]] && [[ ! -d "node_modules" ]]; then
        all_good=false
    fi

    if [[ "$all_good" == true ]]; then
        print_success "🎉 React Native/Expo setup completed successfully!"
    else
        print_warning "⚠ Setup completed with warnings. Please check the issues above."
    fi
}

print_summary() {
    echo
    echo "📋 Setup Summary"
    echo "================"
    echo
    echo "React Native/Expo project setup completed. Available commands:"
    echo "• mise run dev          - Start Expo development server"
    echo "• mise run android      - Run on Android device/emulator"
    echo "• mise run ios          - Run on iOS simulator (macOS only)"
    echo "• mise run test         - Run tests"
    echo "• mise run verify       - Verify environment"
    echo "• mise run build        - Build for production"
    echo
}

main() {
    print_header

    setup_node
    setup_expo
    setup_react_native
    setup_android
    setup_ios
    create_vscode_settings
    setup_metro
    run_verification
    print_summary
}

main "$@"
