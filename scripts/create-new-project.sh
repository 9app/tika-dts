#!/bin/bash

# create-new-project.sh - Script to create new mobile projects using mise templates
# Usage: ./scripts/create-new-project.sh --template <flutter|expo> --name <project-name> [--path <target-path>]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
TEMPLATE=""
PROJECT_NAME=""
TARGET_PATH=""
DEFAULT_FLUTTER_NAME="my_flutter_app"
DEFAULT_EXPO_NAME="my-expo-app"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$WORKSPACE_ROOT/templates"

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

# Show usage information
show_usage() {
    cat << EOF
🚀 Mobile Project Creator

Usage: $0 --template <flutter|expo> [--name <project-name>] [options]

Options:
  --template TEMPLATE    Template to use (flutter|expo)
  --name NAME           Project name (default: my_flutter_app or my-expo-app)
  --path PATH           Target path (default: current directory)
  --help               Show this help message

Templates:
  flutter              Flutter development template
  expo                 React Native/Expo development template

Examples:
  # Create Flutter project with default name (my_flutter_app)
  $0 --template flutter

  # Create Expo project with default name (my-expo-app)
  $0 --template expo

  # Create Flutter project with custom name
  $0 --template flutter --name my_custom_flutter_app

  # Create Expo project in specific path
  $0 --template expo --name my-expo-app --path ./projects/

  # Create project and auto-setup
  $0 --template flutter && cd my_flutter_app && mise install
EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --template)
                TEMPLATE="$2"
                shift 2
                ;;
            --name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            --path)
                TARGET_PATH="$2"
                shift 2
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Validate arguments
validate_args() {
    if [[ -z "$TEMPLATE" ]]; then
        print_error "Template is required. Use --template <flutter|expo>"
        show_usage
        exit 1
    fi

    # Set default project name based on template if not provided
    if [[ -z "$PROJECT_NAME" ]]; then
        case "$TEMPLATE" in
            flutter)
                PROJECT_NAME="$DEFAULT_FLUTTER_NAME"
                print_info "Using default Flutter project name: $PROJECT_NAME"
                ;;
            expo)
                PROJECT_NAME="$DEFAULT_EXPO_NAME"
                print_info "Using default Expo project name: $PROJECT_NAME"
                ;;
        esac
    fi

    # Validate template
    case "$TEMPLATE" in
        flutter|expo)
            ;;
        *)
            print_error "Invalid template: $TEMPLATE. Valid options: flutter, expo"
            exit 1
            ;;
    esac

    # Validate project name based on template
    case "$TEMPLATE" in
        flutter)
            # Flutter requires lowercase with underscores
            if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
                print_error "Invalid Flutter project name: $PROJECT_NAME"
                print_info "Flutter project names must be lowercase with underscores (e.g., my_flutter_app)"
                print_info "Must start with letter and contain only letters, numbers, and underscores."
                exit 1
            fi
            ;;
        expo)
            # Expo/React Native allows hyphens and is more flexible
            if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
                print_error "Invalid Expo project name: $PROJECT_NAME"
                print_info "Expo project names must start with letter and contain only letters, numbers, hyphens, and underscores."
                exit 1
            fi
            ;;
    esac

    # Set default target path if not provided
    if [[ -z "$TARGET_PATH" ]]; then
        TARGET_PATH="."
    fi

    # Ensure target path exists
    if [[ ! -d "$TARGET_PATH" ]]; then
        print_error "Target path does not exist: $TARGET_PATH"
        exit 1
    fi
}

# Check if required tools are available
check_prerequisites() {
    print_info "Checking prerequisites..."

    # Check mise
    if ! command -v mise &> /dev/null; then
        print_error "mise is required but not installed. Please install mise first."
        print_info "Visit: https://mise.jdx.dev/getting-started.html"
        exit 1
    fi

    # Check template exists
    local template_path=""
    case "$TEMPLATE" in
        flutter)
            template_path="$TEMPLATES_DIR/flutter-mise"
            ;;
        expo)
            template_path="$TEMPLATES_DIR/rn-expo-mise"
            ;;
    esac

    if [[ ! -d "$template_path" ]]; then
        print_error "Template not found: $template_path"
        exit 1
    fi

    print_success "Prerequisites check passed"
}

# Create Flutter project
create_flutter_project() {
    print_info "Creating Flutter project: $PROJECT_NAME"
    
    # Check if directory already exists
    if [[ -d "$TARGET_PATH/$PROJECT_NAME" ]]; then
        print_error "Directory already exists: $TARGET_PATH/$PROJECT_NAME"
        exit 1
    fi

    # Create Flutter project
    cd "$TARGET_PATH"
    flutter create "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    # Copy mise template
    print_info "Copying Flutter mise template..."
    cp "$TEMPLATES_DIR/flutter-mise/mise.toml" .
    
    # Copy VS Code configuration
    if [[ -d "$TEMPLATES_DIR/flutter-mise/.vscode" ]]; then
        print_info "Copying Flutter VS Code configuration..."
        cp -r "$TEMPLATES_DIR/flutter-mise/.vscode" .
    fi

    # Copy GitHub Copilot instructions
    if [[ -d "$TEMPLATES_DIR/flutter-mise/.github" ]]; then
        print_info "Copying Flutter GitHub Copilot instructions..."
        cp -r "$TEMPLATES_DIR/flutter-mise/.github" .
    fi

    # Copy main Copilot instructions
    if [[ -f "$TEMPLATES_DIR/flutter-mise/.github/copilot-instructions.md" ]]; then
        print_info "Copying Flutter Copilot instructions..."
        cp "$TEMPLATES_DIR/flutter-mise/.github/copilot-instructions.md" .
    fi

    # Create template metadata
    create_template_metadata "flutter-mise"

    print_success "Flutter project created successfully!"
    print_info "Next steps:"
    echo "  cd $PROJECT_NAME"
    echo "  mise install"
    echo "  mise run setup:android  # For Android development"
    echo "  mise run setup:ios      # For iOS development (macOS only)"
    echo "  mise run doctor         # Verify setup"
}

# Create Expo project
create_expo_project() {
    print_info "Creating Expo project: $PROJECT_NAME"
    
    # Check if directory already exists
    if [[ -d "$TARGET_PATH/$PROJECT_NAME" ]]; then
        print_error "Directory already exists: $TARGET_PATH/$PROJECT_NAME"
        exit 1
    fi

    # Create Expo project
    cd "$TARGET_PATH"
    npx create-expo-app "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    # Copy mise template
    print_info "Copying React Native/Expo mise template..."
    cp "$TEMPLATES_DIR/rn-expo-mise/mise.toml" .
    
    # Copy Biome configuration
    if [[ -f "$TEMPLATES_DIR/rn-expo-mise/biome.json" ]]; then
        print_info "Copying Biome configuration..."
        cp "$TEMPLATES_DIR/rn-expo-mise/biome.json" .
    fi
    
    # Copy VS Code configuration
    if [[ -d "$TEMPLATES_DIR/rn-expo-mise/.vscode" ]]; then
        print_info "Copying React Native/Expo VS Code configuration..."
        cp -r "$TEMPLATES_DIR/rn-expo-mise/.vscode" .
    fi

    # Copy GitHub Copilot instructions
    if [[ -d "$TEMPLATES_DIR/rn-expo-mise/.github" ]]; then
        print_info "Copying React Native/Expo GitHub Copilot instructions..."
        cp -r "$TEMPLATES_DIR/rn-expo-mise/.github" .
    fi

    # Copy main Copilot instructions
    if [[ -f "$TEMPLATES_DIR/rn-expo-mise/.github/copilot-instructions.md" ]]; then
        print_info "Copying React Native/Expo Copilot instructions..."
        cp "$TEMPLATES_DIR/rn-expo-mise/.github/copilot-instructions.md" .
    fi

    # Create template metadata
    create_template_metadata "rn-expo-mise"

    print_success "Expo project created successfully!"
    print_info "Next steps:"
    echo "  cd $PROJECT_NAME"
    echo "  mise install"
    echo "  mise run deps           # Install dependencies"
    echo "  mise run setup:android  # For Android development"
    echo "  mise run setup:ios      # For iOS development (macOS only)"
    echo "  mise run setup:eas      # For EAS Build & Submit"
    echo "  mise run doctor         # Verify setup"
}

# Create template metadata file
create_template_metadata() {
    local template_name="$1"
    local current_version="1.0.0"
    local workspace_version="2024.1"
    
    # Get template version from registry if available (using native parsing)
    if [[ -f "$TEMPLATES_DIR/.templates-registry.yaml" ]]; then
        # Parse YAML using native bash - look for current_version under template
        local version_line=$(grep -A 10 "^  $template_name:" "$TEMPLATES_DIR/.templates-registry.yaml" | grep "current_version:" | head -1)
        if [[ -n "$version_line" ]]; then
            current_version=$(echo "$version_line" | sed 's/.*current_version:[[:space:]]*["'"'"']*\([^"'"'"']*\)["'"'"']*/\1/')
        fi
    fi
    
    # Get current timestamp
    local created_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Get git commit if available
    local base_commit=""
    if git rev-parse --git-dir >/dev/null 2>&1; then
        base_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    fi
    
    print_info "Creating template metadata..."
    
    # Create metadata file
    cat > ".template-metadata" << EOF
# This file tracks template properties and upgrade history
# Used by template upgrade system to manage project versions
# This file should be version controlled and not manually edited

template:
  name: "$template_name"
  version: "$current_version"
  workspace_version: "$workspace_version"
  created_at: "$created_at"
  base_commit: "$base_commit"

# Tracks upgrade history
upgrade_history: []

# User customizations that should be preserved during upgrades
customizations:
  # Files that have been modified by user
  modified_files: []
  
  # Custom tasks added by user  
  custom_tasks: []
  
  # Custom environment variables
  custom_env: []

# Files that should be ignored during upgrade (user-specific)
unmanaged_files:
  - "assets/**"                  # User assets
  - ".env.local"                 # Local environment config
EOF

    # Add template-specific configuration
    if [[ "$template_name" == "flutter-mise" ]]; then
        cat >> ".template-metadata" << EOF
  - "lib/**"                     # Flutter application code
  - "test/**"                    # Flutter test code
  - "integration_test/**"        # Integration tests
  - "ios/Runner.xcodeproj/project.pbxproj"  # iOS project file
  - "android/app/src/main/**"    # Android application code
  - "web/**"                     # Web-specific code

# Compatibility information
compatibility:
  min_workspace_version: "$workspace_version"
  max_workspace_version: "2025.1"
  flutter_sdk_range: ">=3.30.0 <4.0.0"
  dart_version_range: ">=3.6.0 <4.0.0"
EOF
    elif [[ "$template_name" == "rn-expo-mise" ]]; then
        cat >> ".template-metadata" << EOF
  - "src/**"                     # React Native source code
  - "app/**"                     # Expo Router app directory
  - "components/**"              # React components
  - "constants/**"               # App constants
  - "hooks/**"                   # React hooks
  - "App.{js,jsx,ts,tsx}"        # Main app component
  - "metro.config.js"            # Metro bundler config
  - "babel.config.js"            # Babel configuration

# Compatibility information
compatibility:
  min_workspace_version: "$workspace_version"
  max_workspace_version: "2025.1"
  node_version_range: ">=18.0.0 <22.0.0"
  react_native_range: ">=0.74.0 <1.0.0"
  expo_sdk_range: ">=51.0.0 <52.0.0"
EOF
    fi
    
    print_success "Template metadata created: .template-metadata"
}
# Main function
main() {
    print_info "🚀 Mobile Project Creator"
    
    parse_args "$@"
    validate_args
    check_prerequisites

    case "$TEMPLATE" in
        flutter)
            create_flutter_project
            ;;
        expo)
            create_expo_project
            ;;
    esac

    print_success "🎉 Project created successfully!"
    print_info "📖 Check the project README for detailed instructions"
    print_info "🔧 Run 'mise run doctor' to verify your development environment"
}

# Run main function
main "$@"
