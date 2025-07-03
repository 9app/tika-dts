#!/bin/bash

# Colors for outpu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored outpu
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

print_header() {
    echo
    echo "🚀 Mobile Project Setup Script"
    echo "================================"
    echo "This script will set up your development environment for:"
    echo "• React Native development"
    echo "• Flutter development"
    echo "• Android development"
    echo "• iOS development (macOS only)"
    echo
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."

    # Check Gi
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi

    # Check platform
    OS=$(detect_os)
    print_status "Detected OS: $OS"

    if [[ "$OS" == "windows" ]]; then
        print_warning "Windows detected. iOS development will not be available."
    elif [[ "$OS" == "unknown" ]]; then
        print_error "Unsupported operating system."
        exit 1
    fi
}

# Install mise
install_mise() {
    print_status "Installing mise..."

    if command_exists mise; then
        print_success "Mise is already installed"
        mise --version
        return
    fi

    # Try homebrew first (macOS/Linux)
    if command_exists brew; then
        print_status "Installing mise via Homebrew..."
        brew install mise
    else
        # Use curl installer
        print_status "Installing mise via curl..."
        curl -fsSL https://mise.run | sh

        # Add to PATH
        export PATH="$HOME/.local/bin:$PATH"
    fi

    if command_exists mise; then
        print_success "Mise installed successfully"
        mise --version
    else
        print_error "Failed to install mise"
        exit 1
    fi
}

# Setup shell integration
setup_shell() {
    print_status "Setting up shell integration..."

    # Detect shell
    SHELL_NAME=$(basename "$SHELL")
    print_status "Detected shell: $SHELL_NAME"

    case "$SHELL_NAME" in
        zsh)
            SHELL_RC="$HOME/.zshrc"
            ACTIVATION_CMD='eval "$(mise activate zsh)"'
            ;;
        bash)
            SHELL_RC="$HOME/.bashrc"
            ACTIVATION_CMD='eval "$(mise activate bash)"'
            ;;
        fish)
            SHELL_RC="$HOME/.config/fish/config.fish"
            ACTIVATION_CMD='mise activate fish | source'
            ;;
        *)
            print_warning "Unsupported shell: $SHELL_NAME"
            return
            ;;
    esac

    # Check if already configured
    if grep -q "mise activate" "$SHELL_RC" 2>/dev/null; then
        print_success "Shell integration already configured"
        return
    fi

    # Add activation to shell rc
    echo "" >> "$SHELL_RC"
    echo "# Mise activation" >> "$SHELL_RC"
    echo "$ACTIVATION_CMD" >> "$SHELL_RC"

    print_success "Shell integration added to $SHELL_RC"
    print_warning "Please restart your terminal or run: source $SHELL_RC"
}

# Install project tools
install_tools() {
    print_status "Installing project development tools..."

    # Activate mise for current session
    eval "$(mise activate bash 2>/dev/null || mise activate zsh 2>/dev/null || true)"

    # Install tools from mise.toml
    if [[ -f "mise.toml" ]]; then
        print_status "Installing tools from mise.toml..."
        mise install
        print_success "Development tools installed"
    else
        print_error "mise.toml not found in current directory"
        exit 1
    fi
}

# Setup Android developmen
setup_android() {
    print_status "Setting up Android development..."

    # Check for Android Studio
    if [[ "$OS" == "macos" ]]; then
        if [[ -d "/Applications/Android Studio.app" ]]; then
            print_success "Android Studio found"
        else
            print_warning "Android Studio not found. Please install it from https://developer.android.com/studio"
        fi
    fi

    # Create Android SDK directory if it doesn't exis
    ANDROID_HOME="$HOME/Library/Android/sdk"
    if [[ "$OS" == "linux" ]]; then
        ANDROID_HOME="$HOME/Android/Sdk"
    fi

    if [[ ! -d "$ANDROID_HOME" ]]; then
        print_status "Creating Android SDK directory: $ANDROID_HOME"
        mkdir -p "$ANDROID_HOME"
    fi

    print_success "Android development setup complete"
}

# Setup iOS development (macOS only)
setup_ios() {
    if [[ "$OS" != "macos" ]]; then
        print_warning "iOS development is only available on macOS"
        return
    fi

    print_status "Setting up iOS development..."

    # Check for Xcode
    if command_exists xcodebuild; then
        print_success "Xcode found"
        xcodebuild -version

        # Accept license
        print_status "Accepting Xcode license (may require sudo)..."
        sudo xcodebuild -license accept 2>/dev/null || true

        # Install command line tools
        if ! xcode-select -p &>/dev/null; then
            print_status "Installing Xcode command line tools..."
            xcode-select --install
        fi
    else
        print_warning "Xcode not found. Please install it from the App Store"
    fi

    # Install CocoaPods if not presen
    if ! command_exists pod; then
        print_status "Installing CocoaPods..."
        gem install cocoapods
    fi

    print_success "iOS development setup complete"
}

# Install project dependencies
install_dependencies() {
    print_status "Installing project dependencies..."

    # Node.js dependencies
    if [[ -f "package.json" ]]; then
        print_status "Installing Node.js dependencies..."
        npm install
    fi

    # Flutter dependencies
    if [[ -f "pubspec.yaml" ]]; then
        print_status "Installing Flutter dependencies..."
        flutter pub ge
    fi

    # iOS dependencies
    if [[ -f "ios/Podfile" && "$OS" == "macos" ]]; then
        print_status "Installing iOS dependencies..."
        cd ios
        pod install
        cd ..
    fi

    print_success "Dependencies installed"
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."

    # Check mise
    if command_exists mise; then
        print_success "✓ Mise is working"
    else
        print_error "✗ Mise is not working"
    fi

    # Check development tools
    eval "$(mise activate bash 2>/dev/null || mise activate zsh 2>/dev/null || true)"

    tools=("node" "npm" "flutter" "dart" "java")
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            print_success "✓ $tool is available"
        else
            print_warning "✗ $tool is not available"
        fi
    done

    # Run mise doctor
    print_status "Running mise environment check..."
    mise doctor || true
}

# Main setup function
main() {
    print_header

    # Check if running from project roo
    if [[ ! -f "mise.toml" ]]; then
        print_error "This script must be run from the project root directory (where mise.toml exists)"
        exit 1
    fi

    print_status "Starting setup process..."

    check_prerequisites
    install_mise
    setup_shell
    install_tools
    setup_android
    setup_ios
    install_dependencies
    verify_installation

    echo
    print_success "🎉 Setup complete!"
    echo
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
    echo "2. Run 'mise run verify' to check your environment"
    echo "3. Run 'mise run dev' to start development"
    echo "4. Check README.md for available commands"
    echo
}

# Handle interruption
trap 'print_error "Setup interrupted"; exit 1' INT

# Run main function
main "$@"
