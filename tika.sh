#!/bin/bash

# tika.sh - Unified entry point for all tika operations
# Usage: ./tika.sh <command> [options]

set -e

# Colors for outpu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# Print colored outpu
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

print_command() {
    echo -e "${CYAN}📋 $1${NC}"
}

# Show main usage
show_usage() {
    print_header "Tika - Mobile Development Template System"
    echo
    echo "Usage: $0 <command> [options]"
    echo
    echo "🚀 Initial Setup & Project Creation:"
    echo "  setup           Setup development environment (one-time)"
    echo "  create          Create a new mobile project from templates"
    echo
    echo "📖 Information:"
    echo "  version         Show version information"
    echo "  help            Show this help message"
    echo
    echo "Examples:"
    echo "  $0 setup                                    # Initial environment setup"
    echo "  $0 create --template flutter --name my-app # Create Flutter project"
    echo "  $0 create --template expo --name my-app    # Create React Native/Expo project"
    echo
    echo "📋 For ongoing development, use mise commands inside the project directory:"
    echo "  mise run dev                                # Start development server"
    echo "  mise run test                               # Run tests"
    echo
    echo "For detailed help on specific commands:"
    echo "  $0 <command> --help"
    echo
}

# Show version
show_version() {
    echo "Tika - Mobile Development Template System"
    echo "Version: 1.0.0"
    echo ""
    echo "Purpose: Initial setup and project creation"
    echo "Built with ❤️  for Flutter and React Native development"
}

# Setup command
cmd_setup() {
    print_command "Setting up development environment..."
    print_info "This is a one-time setup for your development environment"
    exec "$SCRIPTS_DIR/setup.sh" "$@"
}

# Create project command - main function of tika
cmd_create() {
    print_command "Creating new project from template..."
    print_info "After creation, use 'mise run' commands for ongoing development"
    exec "$SCRIPTS_DIR/create-new-project.sh" "$@"
}

# Command validation
validate_command() {
    local cmd="$1"
    case "$cmd" in
        create|setup|version|help)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Main execution
main() {
    # Check if no arguments provided
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi

    local command="$1"
    shif

    # Handle help and version
    case "$command" in
        help|--help|-h)
            show_usage
            exit 0
            ;;
        version|--version|-v)
            show_version
            exit 0
            ;;
    esac

    # Validate command
    if ! validate_command "$command"; then
        print_error "Unknown command: $command"
        echo
        show_usage
        exit 1
    fi

    # Check if scripts directory exists
    if [ ! -d "$SCRIPTS_DIR" ]; then
        print_error "Scripts directory not found: $SCRIPTS_DIR"
        exit 1
    fi

    # Execute command
    case "$command" in
        create)
            cmd_create "$@"
            ;;
        setup)
            cmd_setup "$@"
            ;;
    esac
}

# Execute main function with all arguments
main "$@"
