#!/bin/bash

# setup.sh - Simple Flutter template setup script
# This script ensures mise is installed and runs mise install

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
    echo "🚀 Flutter Template Setup"
    echo "========================="
    echo
}

install_mise() {
    print_status "Checking mise installation..."

    if command_exists mise; then
        print_success "✓ mise is already installed"
        mise --version
        return 0
    fi

    print_status "Installing mise..."
    
    OS=$(detect_os)
    if [[ "$OS" == "macos" ]]; then
        if command_exists brew; then
            brew install mise
        else
            curl https://mise.run | sh
        fi
    elif [[ "$OS" == "linux" ]]; then
        curl https://mise.run | sh
    else
        print_error "Unsupported OS for automatic mise installation"
        print_status "Please install mise manually: https://mise.jdx.dev/getting-started.html"
        return 1
    fi

    # Activate mise for current session
    export PATH="$HOME/.local/bin:$PATH"
    
    if command_exists mise; then
        print_success "✓ mise installed successfully"
    else
        print_error "✗ mise installation failed"
        return 1
    fi
}

setup_tools() {
    print_status "Installing development tools via mise..."

    # Install tools defined in mise.toml
    mise install

    print_success "✓ Tools installed successfully"
}

print_summary() {
    echo
    echo "📋 Setup Summary"
    echo "================"
    echo
    echo "Flutter template setup completed! Next steps:"
    echo "1. Restart your terminal or run: eval \"\$(mise activate \$SHELL)\""
    echo "2. Run: mise run doctor     # Check environment"
    echo "3. Run: mise run dev        # Start development"
    echo
    echo "Available commands:"
    echo "• mise run dev          - Start Flutter app"
    echo "• mise run android      - Run on Android"
    echo "• mise run ios          - Run on iOS (macOS only)"
    echo "• mise run test         - Run tests"
    echo "• mise run doctor       - Check environment"
    echo "• mise run build        - Build release"
    echo
}

main() {
    print_header
    
    install_mise
    setup_tools
    print_summary
}

main "$@"
