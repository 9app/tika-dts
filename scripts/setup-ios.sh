#!/bin/bash

# iOS Development Setup Script (macOS only)

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

check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS development is only available on macOS"
        exit 1
    fi
    print_success "Running on macOS"
}

setup_xcode() {
    print_status "Setting up Xcode..."
    
    # Check if Xcode is installed
    if [[ -d "/Applications/Xcode.app" ]]; then
        print_success "Xcode found"
        
        if command_exists xcodebuild; then
            xcode_version=$(xcodebuild -version | head -n1)
            print_success "$xcode_version"
        fi
    else
        print_error "Xcode is not installed"
        echo "Please install Xcode from the App Store:"
        echo "https://apps.apple.com/us/app/xcode/id497799835"
        echo
        return 1
    fi
    
    # Install command line tools
    if ! xcode-select -p &>/dev/null; then
        print_status "Installing Xcode command line tools..."
        xcode-select --install
        echo "Please complete the installation in the popup window"
        echo "Press Enter when installation is complete..."
        read -r
    else
        print_success "Xcode command line tools are installed"
    fi
    
    # Accept license
    print_status "Accepting Xcode license..."
    if sudo xcodebuild -license accept 2>/dev/null; then
        print_success "Xcode license accepted"
    else
        print_warning "Could not accept Xcode license automatically"
        echo "Please run: sudo xcodebuild -license accept"
    fi
}

setup_cocoapods() {
    print_status "Setting up CocoaPods..."
    
    if command_exists pod; then
        pod_version=$(pod --version)
        print_success "CocoaPods already installed: $pod_version"
    else
        print_status "Installing CocoaPods..."
        
        # Install via gem (Ruby should be available via mise)
        if command_exists gem; then
            gem install cocoapods
            print_success "CocoaPods installed"
        else
            print_error "Ruby/gem not available. Make sure mise Ruby is installed"
            return 1
        fi
    fi
    
    # Setup CocoaPods repo if needed
    if [[ ! -d "$HOME/.cocoapods/repos/cocoapods" ]]; then
        print_status "Setting up CocoaPods master repo (this may take a while)..."
        pod setup
    fi
}

setup_simulators() {
    print_status "Setting up iOS Simulators..."
    
    if command_exists xcrun; then
        # List available simulators
        print_status "Available iOS Simulators:"
        xcrun simctl list devices available | grep "iPhone"
        
        # Check if any simulators are available
        simulator_count=$(xcrun simctl list devices available | grep "iPhone" | wc -l)
        if [[ $simulator_count -gt 0 ]]; then
            print_success "$simulator_count iOS Simulators available"
        else
            print_warning "No iOS Simulators found"
            echo "Please install iOS Simulators through Xcode:"
            echo "Xcode → Window → Devices and Simulators → Simulators → +"
        fi
    else
        print_error "xcrun not available"
    fi
}

setup_certificates() {
    print_status "Checking code signing certificates..."
    
    # List available certificates
    if command_exists security; then
        dev_certs=$(security find-identity -v -p codesigning | grep "iPhone Developer" | wc -l)
        dist_certs=$(security find-identity -v -p codesigning | grep "iPhone Distribution" | wc -l)
        
        if [[ $dev_certs -gt 0 ]]; then
            print_success "$dev_certs development certificate(s) found"
        else
            print_warning "No development certificates found"
            echo "You'll need to set up code signing in Xcode"
        fi
        
        if [[ $dist_certs -gt 0 ]]; then
            print_success "$dist_certs distribution certificate(s) found"
        else
            print_warning "No distribution certificates found"
        fi
    fi
}

install_ios_dependencies() {
    print_status "Installing iOS project dependencies..."
    
    # Check if this is an iOS project
    if [[ -f "ios/Podfile" ]]; then
        print_status "iOS project detected"
        
        cd ios
        
        # Install pods
        print_status "Installing CocoaPods dependencies..."
        pod install
        
        if [[ $? -eq 0 ]]; then
            print_success "CocoaPods dependencies installed"
        else
            print_error "Failed to install CocoaPods dependencies"
        fi
        
        cd ..
    else
        print_warning "No iOS project found (ios/Podfile missing)"
    fi
    
    # Check for React Native iOS project
    if [[ -f "ios/Podfile" && -f "package.json" ]]; then
        if grep -q "react-native" package.json; then
            print_status "React Native iOS project detected"
            
            # Additional React Native iOS setup
            cd ios
            
            # Clean build folder
            if [[ -d "build" ]]; then
                print_status "Cleaning iOS build folder..."
                rm -rf build
            fi
            
            cd ..
            print_success "React Native iOS setup complete"
        fi
    fi
}

check_ios_environment() {
    print_status "Checking iOS development environment..."
    
    # Check important paths
    echo "Xcode path: $(xcode-select -p 2>/dev/null || echo 'not found')"
    echo "iOS SDK path: $(xcrun --show-sdk-path --sdk iphoneos 2>/dev/null || echo 'not found')"
    
    # Check iOS SDK version
    if command_exists xcrun; then
        ios_sdk_version=$(xcrun --show-sdk-version --sdk iphoneos 2>/dev/null)
        if [[ -n "$ios_sdk_version" ]]; then
            print_success "iOS SDK version: $ios_sdk_version"
        fi
    fi
}

open_simulators() {
    print_status "Opening iOS Simulator..."
    
    if command_exists open; then
        open -a Simulator
        print_success "iOS Simulator opened"
    else
        print_warning "Could not open iOS Simulator automatically"
        echo "Please open Simulator manually from Launchpad or Xcode"
    fi
}

main() {
    echo
    echo "📱 iOS Development Setup"
    echo "========================"
    echo
    
    check_macos
    setup_xcode
    setup_cocoapods
    setup_simulators
    setup_certificates
    check_ios_environment
    install_ios_dependencies
    
    echo
    print_success "🎉 iOS setup complete!"
    echo
    echo "Next steps:"
    echo "1. Open Xcode and sign in with your Apple ID"
    echo "2. Set up your development team in Xcode"
    echo "3. Install additional iOS Simulators if needed"
    echo "4. Run 'mise run ios' to test your setup"
    echo
    echo "Optional:"
    echo "• Open iOS Simulator: mise run simulator"
    echo "• Check environment: mise run doctor"
    echo
}

main "$@"
