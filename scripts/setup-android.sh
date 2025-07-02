#!/bin/bash

# Android Development Setup Script

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

setup_android_sdk() {
    print_status "Setting up Android SDK..."
    
    OS=$(detect_os)
    
    # Determine SDK path based on OS
    if [[ "$OS" == "macos" ]]; then
        ANDROID_HOME="$HOME/Library/Android/sdk"
    elif [[ "$OS" == "linux" ]]; then
        ANDROID_HOME="$HOME/Android/Sdk"
    else
        # Windows or other
        ANDROID_HOME="$HOME/Android/Sdk"
    fi
    
    # Create SDK directory
    if [[ ! -d "$ANDROID_HOME" ]]; then
        print_status "Creating Android SDK directory: $ANDROID_HOME"
        mkdir -p "$ANDROID_HOME"
    fi
    
    # Update mise.toml with correct path
    if [[ -f "mise.toml" ]]; then
        print_status "Updating ANDROID_HOME in mise.toml for $OS"
        if [[ "$OS" == "macos" ]]; then
            sed -i '' 's|ANDROID_HOME = ".*"|ANDROID_HOME = "~/Library/Android/sdk"|' mise.toml
        else
            sed -i 's|ANDROID_HOME = ".*"|ANDROID_HOME = "~/Android/Sdk"|' mise.toml
        fi
    fi
    
    # Check if Android Studio is installed
    if [[ "$OS" == "macos" ]]; then
        if [[ -d "/Applications/Android Studio.app" ]]; then
            print_success "Android Studio found"
        else
            print_warning "Android Studio not found"
            echo "Please download and install Android Studio from:"
            echo "https://developer.android.com/studio"
            echo
        fi
    fi
    
    print_success "Android SDK directory set up at: $ANDROID_HOME"
}

setup_android_licenses() {
    print_status "Accepting Android licenses..."
    
    if command_exists flutter; then
        flutter doctor --android-licenses
        print_success "Android licenses accepted"
    else
        print_warning "Flutter not available, skipping license acceptance"
        echo "You can accept licenses later with: flutter doctor --android-licenses"
    fi
}

setup_emulator() {
    print_status "Setting up Android Emulator..."
    
    # Check if SDK tools are available
    if [[ -d "$ANDROID_HOME/tools" || -d "$ANDROID_HOME/cmdline-tools" ]]; then
        print_success "Android SDK tools found"
        
        # Create a default AVD if none exist
        if command_exists avdmanager; then
            existing_avds=$(avdmanager list avd | grep "Name:" | wc -l)
            if [[ $existing_avds -eq 0 ]]; then
                print_status "Creating default Android Virtual Device..."
                
                # Download system image (API 30, x86_64)
                sdkmanager "system-images;android-30;google_apis;x86_64" 2>/dev/null || true
                
                # Create AVD
                echo "no" | avdmanager create avd \
                    -n "Pixel_4_API_30" \
                    -k "system-images;android-30;google_apis;x86_64" \
                    -d "pixel_4" 2>/dev/null || print_warning "Could not create default AVD"
                
                print_success "Default Android emulator created: Pixel_4_API_30"
            else
                print_success "Android Virtual Devices already exist"
            fi
        else
            print_warning "avdmanager not found. Please set up emulator through Android Studio"
        fi
    else
        print_warning "Android SDK tools not found"
        echo "Please install Android SDK through Android Studio"
    fi
}

check_build_tools() {
    print_status "Checking Android build tools..."
    
    # Check if build-tools directory exists
    if [[ -d "$ANDROID_HOME/build-tools" ]]; then
        build_tools_versions=$(ls "$ANDROID_HOME/build-tools" 2>/dev/null | wc -l)
        if [[ $build_tools_versions -gt 0 ]]; then
            print_success "Android build tools found ($build_tools_versions versions)"
        else
            print_warning "No Android build tools found"
        fi
    else
        print_warning "Android build tools directory not found"
    fi
    
    # Check platform-tools
    if [[ -d "$ANDROID_HOME/platform-tools" ]]; then
        print_success "Android platform tools found"
        
        if command_exists adb; then
            adb_version=$(adb --version | head -n1)
            print_success "ADB available: $adb_version"
        fi
    else
        print_warning "Android platform tools not found"
    fi
}

setup_environment() {
    print_status "Setting up Android environment variables..."
    
    # These are already in mise.toml, but show current values
    echo "Current Android environment:"
    echo "ANDROID_HOME: ${ANDROID_HOME:-'not set'}"
    echo "ANDROID_SDK_ROOT: ${ANDROID_SDK_ROOT:-'not set'}"
    
    # Check PATH
    if echo "$PATH" | grep -q "platform-tools"; then
        print_success "Android platform-tools in PATH"
    else
        print_warning "Android platform-tools not in PATH"
        echo "Make sure mise.toml includes platform-tools in PATH"
    fi
}

install_android_dependencies() {
    print_status "Installing Android project dependencies..."
    
    # Check if this is an Android project
    if [[ -f "android/build.gradle" ]]; then
        print_status "Android project detected"
        
        cd android
        
        # Make gradlew executable
        if [[ -f "gradlew" ]]; then
            chmod +x gradlew
            print_success "Made gradlew executable"
        fi
        
        # Clean and sync
        print_status "Running Gradle sync..."
        ./gradlew dependencies 2>/dev/null || print_warning "Gradle sync had issues"
        
        cd ..
        print_success "Android dependencies processed"
    else
        print_warning "No Android project found (android/build.gradle missing)"
    fi
}

main() {
    echo
    echo "🤖 Android Development Setup"
    echo "============================"
    echo
    
    OS=$(detect_os)
    
    # Set ANDROID_HOME based on OS
    if [[ "$OS" == "macos" ]]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
    else
        export ANDROID_HOME="$HOME/Android/Sdk"
    fi
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    
    setup_android_sdk
    check_build_tools
    setup_environment
    setup_android_licenses
    setup_emulator
    install_android_dependencies
    
    echo
    print_success "🎉 Android setup complete!"
    echo
    echo "Next steps:"
    echo "1. Install Android Studio if not already installed"
    echo "2. Open Android Studio and install SDK components"
    echo "3. Create/start an Android emulator"
    echo "4. Run 'mise run android' to test your setup"
    echo
}

main "$@"
