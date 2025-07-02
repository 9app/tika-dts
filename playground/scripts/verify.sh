#!/bin/bash

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

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
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
    echo "🔍 Development Environment Verification"
    echo "======================================"
    echo
}

check_mise() {
    print_status "Checking mise installation..."

    if command_exists mise; then
        print_success "✓ Mise is installed"
        mise --version

        # Check if mise is activated
        if [[ -n "$MISE_SHELL" ]]; then
            print_success "✓ Mise is activated in current shell"
        else
            print_warning "⚠ Mise is not activated in current shell"
            echo "  Run: eval \"\$(mise activate $SHELL)\""
        fi
    else
        print_error "✗ Mise is not installed"
        return 1
    fi
}

check_tools() {
    print_status "Checking development tools..."

    # Activate mise
    eval "$(mise activate bash 2>/dev/null || mise activate zsh 2>/dev/null || true)"

    local all_good=true

    # Check individual tools
    if command_exists node; then
        version=$(node --version 2>/dev/null)
        print_success "✓ node: $version"
    else
        print_error "✗ node is not available"
        all_good=false
    fi

    if command_exists npm; then
        version=$(npm --version 2>/dev/null)
        print_success "✓ npm: $version"
    else
        print_error "✗ npm is not available"
        all_good=false
    fi

    if command_exists java; then
        version=$(java -version 2>&1 | head -n1)
        print_success "✓ java: $version"
    else
        print_error "✗ java is not available"
        all_good=false
    fi

    if command_exists python; then
        version=$(python --version 2>/dev/null)
        print_success "✓ python: $version"
    else
        print_error "✗ python is not available"
        all_good=false
    fi

    if command_exists flutter; then
        version=$(flutter --version 2>/dev/null | head -n1)
        print_success "✓ flutter: $version"
    else
        print_warning "⚠ flutter not available (install via official installer)"
    fi

    if command_exists dart; then
        version=$(dart --version 2>/dev/null)
        print_success "✓ dart: $version"
    else
        print_warning "⚠ dart not available (comes with Flutter)"
    fi

    if [ "$all_good" = true ]; then
        return 0
    else
        return 1
    fi
}

check_android() {
    print_status "Checking Android development setup..."

    # Check Android SDK - expand ~ in path
    if [[ -n "$ANDROID_HOME" ]]; then
        # Expand tilde to home directory
        expanded_path="${ANDROID_HOME/#\~/$HOME}"
        if [[ -d "$expanded_path" ]]; then
            print_success "✓ ANDROID_HOME is set: $ANDROID_HOME"
        else
            print_error "✗ ANDROID_HOME directory doesn't exist: $expanded_path"
        fi
    else
        print_error "✗ ANDROID_HOME is not set"
    fi

    # Check platform-tools
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
}

check_flutter() {
    print_status "Checking Flutter setup..."

    if command_exists flutter; then
        print_status "Running Flutter Doctor..."
        flutter doctor

        # Check Flutter configuration
        print_status "Flutter configuration:"
        flutter config
    else
        print_error "✗ Flutter is not available"
        return 1
    fi
}

check_react_native() {
    print_status "Checking React Native setup..."

    # Check if React Native CLI is available
    if command_exists npx; then
        print_success "✓ npx is available (can run React Native commands)"

        # Check React Native doctor if available
        if [[ -f "package.json" ]]; then
            if grep -q "react-native" package.json; then
                print_status "Running React Native Doctor..."
                npx react-native doctor || print_warning "React Native doctor had issues"
            fi
        fi
    else
        print_error "✗ npx is not available"
    fi

    # Check Metro bundler dependencies
    if [[ -f "metro.config.js" ]]; then
        print_success "✓ Metro configuration found"
    else
        print_warning "⚠ Metro configuration not found"
    fi
}

check_environment() {
    print_status "Checking environment variables..."

    # Check important environment variables
    if [[ -n "$ANDROID_HOME" ]]; then
        print_success "✓ ANDROID_HOME: $ANDROID_HOME"
    else
        print_warning "⚠ ANDROID_HOME is not set (Android SDK location)"
    fi

    if [[ -n "$JAVA_HOME" ]]; then
        print_success "✓ JAVA_HOME: $JAVA_HOME"
    else
        print_info "ℹ JAVA_HOME not set (mise will manage Java automatically)"
    fi

    if [[ -n "$FLUTTER_ROOT" ]]; then
        print_success "✓ FLUTTER_ROOT: $FLUTTER_ROOT"
    else
        print_info "ℹ FLUTTER_ROOT not set (Flutter manages its own installation)"
    fi

    if [[ -n "$NODE_ENV" ]]; then
        print_success "✓ NODE_ENV: $NODE_ENV"
    else
        print_info "ℹ NODE_ENV not set (defaults to development)"
    fi
}

check_project_files() {
    print_status "Checking project files..."

    # Check essential files
    if [[ -f "mise.toml" ]]; then
        print_success "✓ mise.toml: Mise configuration"
    else
        print_error "✗ mise.toml missing"
    fi

    if [[ -f "package.json" ]]; then
        print_success "✓ package.json: Node.js dependencies"
    else
        print_info "ℹ package.json not found (for React Native projects)"
    fi

    if [[ -f "pubspec.yaml" ]]; then
        print_success "✓ pubspec.yaml: Flutter dependencies"
    else
        print_info "ℹ pubspec.yaml not found (for Flutter projects)"
    fi

    if [[ -d "android" ]]; then
        print_success "✓ android/: Android project directory"
    else
        print_info "ℹ android/ directory not found (for mobile projects)"
    fi

    if [[ -d "ios" ]]; then
        print_success "✓ ios/: iOS project directory"
    else
        print_info "ℹ ios/ directory not found (for mobile projects)"
    fi
}

check_dependencies() {
    print_status "Checking project dependencies..."

    # Node modules
    if [[ -f "package.json" ]]; then
        if [[ -d "node_modules" ]]; then
            print_success "✓ Node.js dependencies installed"
        else
            print_warning "⚠ Node.js dependencies not installed (run: npm install)"
        fi
    fi

    # Flutter packages
    if [[ -f "pubspec.yaml" ]]; then
        if [[ -d ".dart_tool" ]]; then
            print_success "✓ Flutter dependencies installed"
        else
            print_warning "⚠ Flutter dependencies not installed (run: flutter pub get)"
        fi
    fi

    # iOS Pods
    OS=$(detect_os)
    if [[ "$OS" == "macos" && -f "ios/Podfile" ]]; then
        if [[ -d "ios/Pods" ]]; then
            print_success "✓ iOS dependencies installed"
        else
            print_warning "⚠ iOS dependencies not installed (run: cd ios && pod install)"
        fi
    fi
}

run_tests() {
    print_status "Running quick health tests..."

    # Test Node.js
    if command_exists node; then
        node_test=$(node -e "console.log('Node.js works')" 2>/dev/null)
        if [[ "$node_test" == "Node.js works" ]]; then
            print_success "✓ Node.js execution test passed"
        else
            print_error "✗ Node.js execution test failed"
        fi
    fi

    # Test Flutter
    if command_exists flutter; then
        flutter_test=$(flutter --version 2>/dev/null | head -n1)
        if [[ -n "$flutter_test" ]]; then
            print_success "✓ Flutter execution test passed"
        else
            print_error "✗ Flutter execution test failed"
        fi
    fi

    # Test Java
    if command_exists java; then
        java_test=$(java -version 2>&1 | head -n1)
        if [[ -n "$java_test" ]]; then
            print_success "✓ Java execution test passed"
        else
            print_error "✗ Java execution test failed"
        fi
    fi
}

print_summary() {
    echo
    echo "📋 Verification Summary"
    echo "======================"
    echo
    echo "If you see any errors above, please:"
    echo "1. Run the setup script: ../../scripts/setup.sh"
    echo "2. Follow the manual setup instructions in README.md"
    echo "3. Restart your terminal and try again"
    echo
    echo "Available commands after successful setup:"
    echo "• mise run dev          - Start development server"
    echo "• mise run android      - Run on Android"
    echo "• mise run ios          - Run on iOS (macOS only)"
    echo "• mise run test         - Run tests"
    echo "• mise run doctor       - Run this verification again"
    echo
}

main() {
    print_header

    local exit_code=0

    check_mise || exit_code=1
    check_tools || exit_code=1
    check_environment
    check_project_files
    check_dependencies
    check_android
    check_ios
    check_flutter
    check_react_native
    run_tests

    print_summary

    if [[ $exit_code -eq 0 ]]; then
        print_success "🎉 Environment verification completed successfully!"
    else
        print_error "❌ Environment verification found issues. Please check the errors above."
    fi

    exit $exit_code
}

main "$@"
