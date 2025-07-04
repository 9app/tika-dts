#!/bin/bash

# test-runner.sh - Run comprehensive template validation tests
# Usage: ./playground/scripts/test-runner.sh [--template <flutter|expo|all>] [--quick]

set -e

# Colors for outpu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLAYGROUND_ROOT="$(dirname "$SCRIPT_DIR")"
WORKSPACE_ROOT="$(dirname "$PLAYGROUND_ROOT")"
TEMPLATES_DIR="$WORKSPACE_ROOT/templates"
PLAYGROUND_APPS_DIR="$PLAYGROUND_ROOT/apps"

# Options
TEMPLATE="all"
QUICK_MODE=false

# Print functions
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# Help function
show_help() {
    cat << EOF
Template Testing Runner

USAGE:
    ./playground/scripts/test-runner.sh [OPTIONS]

OPTIONS:
    --template TEMPLATE  Template to test (flutter|expo|all) [default: all]
    --quick             Run quick validation only (skip full builds)
    --help             Show this help message

EXAMPLES:
    # Test all templates
    ./playground/scripts/test-runner.sh

    # Test only Flutter template
    ./playground/scripts/test-runner.sh --template flutter

    # Quick validation for React Native
    ./playground/scripts/test-runner.sh --template expo --quick

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --template)
            TEMPLATE="$2"
            shift 2
            ;;
        --quick)
            QUICK_MODE=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate template option
if [[ "$TEMPLATE" != "flutter" && "$TEMPLATE" != "expo" && "$TEMPLATE" != "all" ]]; then
    print_error "Invalid template: $TEMPLATE. Must be 'flutter', 'expo', or 'all'"
    exit 1
fi

# Test Flutter template
test_flutter() {
    print_info "Testing Flutter template..."

    if [[ -d "$PLAYGROUND_APPS_DIR/flutter_app" ]]; then
        cd "$PLAYGROUND_APPS_DIR/flutter_app"

        print_info "Installing Flutter dependencies..."
        if ! mise install; then
            print_error "Failed to install Flutter dependencies"
            return 1
        fi

        if [[ "$QUICK_MODE" == "false" ]]; then
            print_info "Running Flutter doctor..."
            if ! mise run doctor; then
                print_warning "Flutter doctor has issues (continuing anyway)"
            fi

            print_info "Running Flutter tests..."
            if ! mise run test; then
                print_error "Flutter tests failed"
                return 1
            fi

            print_info "Running Flutter analysis..."
            if ! mise run lint; then
                print_error "Flutter analysis failed"
                return 1
            fi
        else
            print_info "Running quick Flutter validation..."
            if ! flutter --version; then
                print_error "Flutter CLI not available"
                return 1
            fi
        fi

        print_success "Flutter template validation passed"
    else
        print_warning "Flutter test app not found at $PLAYGROUND_APPS_DIR/flutter_app"
        return 1
    fi
}

# Test React Native/Expo template
test_expo() {
    print_info "Testing React Native/Expo template..."

    if [[ -d "$PLAYGROUND_APPS_DIR/mobile-app" ]]; then
        cd "$PLAYGROUND_APPS_DIR/mobile-app"

        print_info "Installing React Native dependencies..."
        if ! npm ci; then
            print_error "Failed to install React Native dependencies"
            return 1
        fi

        if [[ "$QUICK_MODE" == "false" ]]; then
            print_info "Running TypeScript check..."
            if ! npm run type-check; then
                print_error "TypeScript check failed"
                return 1
            fi

            print_info "Running React Native tests..."
            if ! npm test; then
                print_error "React Native tests failed"
                return 1
            fi

            print_info "Running linting..."
            if ! npm run lint; then
                print_error "Linting failed"
                return 1
            fi
        else
            print_info "Running quick React Native validation..."
            if ! npx expo --version; then
                print_error "Expo CLI not available"
                return 1
            fi
        fi

        print_success "React Native/Expo template validation passed"
    else
        print_warning "React Native test app not found at $PLAYGROUND_APPS_DIR/mobile-app"
        return 1
    fi
}

# Test template integrity
test_template_integrity() {
    print_info "Testing template integrity..."

    # Check Flutter template
    if [[ ! -f "$TEMPLATES_DIR/flutter-mise/mise.toml" ]]; then
        print_error "Flutter template mise.toml not found"
        return 1
    fi

    # Check React Native template
    if [[ ! -f "$TEMPLATES_DIR/rn-expo-mise/package.json" ]]; then
        print_error "React Native template package.json not found"
        return 1
    fi

    # Check VS Code configurations
    if [[ ! -d "$TEMPLATES_DIR/flutter-mise/.vscode" ]]; then
        print_error "Flutter VS Code config not found"
        return 1
    fi

    if [[ ! -d "$TEMPLATES_DIR/rn-expo-mise/.vscode" ]]; then
        print_error "React Native VS Code config not found"
        return 1
    fi

    print_success "Template integrity check passed"
}

# Main execution
main() {
    print_info "Starting template validation tests..."
    print_info "Template: $TEMPLATE, Quick mode: $QUICK_MODE"

    # Test template integrity firs
    if ! test_template_integrity; then
        print_error "Template integrity test failed"
        exit 1
    fi

    # Test based on template selection
    case "$TEMPLATE" in
        "flutter")
            if ! test_flutter; then
                exit 1
            fi
            ;;
        "expo")
            if ! test_expo; then
                exit 1
            fi
            ;;
        "all")
            if ! test_flutter; then
                exit 1
            fi
            if ! test_expo; then
                exit 1
            fi
            ;;
    esac

    print_success "All template validation tests passed! 🎉"
}

# Run main function
main "$@"
