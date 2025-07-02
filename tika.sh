#!/bin/bash

# tika.sh - Unified entry point for all tika operations
# Usage: ./tika.sh <command> [options]

set -e

# Colors for output
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

# Print colored output
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
    echo "🔧 Platform-Specific Setup:"
    echo "  setup-android   Setup Android development tools"
    echo "  setup-ios       Setup iOS development tools (macOS only)"
    echo
    echo "📦 Template Management:"
    echo "  template-status      Check current template version"
    echo "  template-check       Check for available template upgrades"
    echo "  template-upgrade     Upgrade to latest template version"
    echo "  template-rollback    Rollback to previous template version"
    echo "  template-releases    List all available template releases"
    echo
    echo "📖 Information:"
    echo "  version         Show version information"
    echo "  help            Show this help message"
    echo
    echo "Examples:"
    echo "  $0 setup                                    # Initial environment setup"
    echo "  $0 create --template flutter --name my-app # Create Flutter project"
    echo "  $0 create --template expo --name my-app    # Create React Native/Expo project"
    echo "  $0 template-check                          # Check for template updates"
    echo "  $0 template-upgrade --dry-run              # Preview template upgrade"
    echo "  $0 template-upgrade                        # Apply template upgrade"
    echo
    echo "📋 Alternative: Use mise for ongoing operations within project:"
    echo "  mise doctor                                 # Verify environment"
    echo "  mise run template:status                    # Check template version"
    echo "  mise run template:upgrade                   # Upgrade template"
    echo "  mise run template:releases                  # View available releases"
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
    echo ""
    echo "Usage workflow:"
    echo "  1. tika.sh setup          # One-time environment setup"
    echo "  2. tika.sh create         # Create new projects"
    echo "  3. mise run <commands>    # Ongoing development operations"
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

# Setup Android command
cmd_setup_android() {
    print_command "Setting up Android development..."
    exec "$SCRIPTS_DIR/setup-android.sh" "$@"
}

# Setup iOS command
cmd_setup_ios() {
    print_command "Setting up iOS development..."
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS development setup is only available on macOS"
        exit 1
    fi
    exec "$SCRIPTS_DIR/setup-ios.sh" "$@"
}

# Template status command
cmd_template_status() {
    print_command "Checking template status..."
    exec "$SCRIPTS_DIR/template-upgrade-git.sh" status "$@"
}

# Template check command
cmd_template_check() {
    print_command "Checking for template upgrades..."
    exec "$SCRIPTS_DIR/template-upgrade-git.sh" check-upgrades "$@"
}

# Template upgrade command
cmd_template_upgrade() {
    print_command "Upgrading template..."
    exec "$SCRIPTS_DIR/template-upgrade-git.sh" upgrade "$@"
}

# Template rollback command
cmd_template_rollback() {
    print_command "Rolling back template..."
    exec "$SCRIPTS_DIR/template-upgrade-git.sh" rollback "$@"
}

# Template releases command
cmd_template_releases() {
    print_command "Listing template releases..."
    exec "$SCRIPTS_DIR/template-upgrade-git.sh" list-releases "$@"
}

# Command validation
validate_command() {
    local cmd="$1"
    case "$cmd" in
        create|setup|setup-android|setup-ios|template-status|template-check|template-upgrade|template-rollback|template-releases|version|help)
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
    shift

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
        setup-android)
            cmd_setup_android "$@"
            ;;
        setup-ios)
            cmd_setup_ios "$@"
            ;;
        template-status)
            cmd_template_status "$@"
            ;;
        template-check)
            cmd_template_check "$@"
            ;;
        template-upgrade)
            cmd_template_upgrade "$@"
            ;;
        template-rollback)
            cmd_template_rollback "$@"
            ;;
        template-releases)
            cmd_template_releases "$@"
            ;;
    esac
}

# Execute main function with all arguments
main "$@"
