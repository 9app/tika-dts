#!/bin/bash

# template-upgrade-native.sh - Template upgrade system without external dependencies
# Pure bash implementation for cross-platform compatibility
#
# ⚠️  DEPRECATED: This script is deprecated in favor of template-upgrade-git.sh
#
# This backup-based approach has been replaced with a git-integrated solution.
# Please use template-upgrade-git.sh or the main tika.sh interface instead.
#
# Migration guide: docs/git-upgrade-migration.md
# New usage: ./tika.sh template-upgrade OR ./scripts/template-upgrade-git.sh

# Show deprecation warning
echo "⚠️  WARNING: template-upgrade-native.sh is DEPRECATED"
echo "📄 Please use the git-integrated approach instead:"
echo "   ./tika.sh template-status"
echo "   ./tika.sh template-upgrade"
echo "   ./tika.sh template-rollback"
echo ""
echo "📖 Migration guide: docs/git-upgrade-migration.md"
echo "🔄 New script: scripts/template-upgrade-git.sh"
echo ""
echo "⏰ Continuing with legacy backup-based approach..."
echo ""

set -e

# Colors for outpu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$WORKSPACE_ROOT/templates"
REGISTRY_FILE="$TEMPLATES_DIR/.templates-registry.yaml"
BACKUPS_DIR="$WORKSPACE_ROOT/backups"

# Source YAML parser
source "$SCRIPT_DIR/yaml-parser.sh"

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
    echo -e "${PURPLE}🔄 $1${NC}"
}

# Check dependencies (minimal)
check_dependencies() {
    local missing_deps=()

    command -v git >/dev/null 2>&1 || missing_deps+=("git")

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Install git for your platform"
        exit 1
    fi
}

# Show usage information
show_usage() {
    cat << 'EOF'
🔄 Template Upgrade System (Native)

Pure bash implementation - no external dependencies required!

Usage: ./scripts/template-upgrade-native.sh <command> [options]

Commands:
  init <path>               Initialize template metadata for existing projec
  status [path]             Show current template status
  check-upgrades [path]     Check for available template upgrades
  upgrade [options]         Upgrade template to newer version
  rollback <version>        Rollback to previous template version
  history [path]            Show upgrade history
  validate [path]           Validate template metadata and configuration
  registry                  Manage template registry

Upgrade Options:
  --version <version>       Upgrade to specific version
  --latest                  Upgrade to latest version
  --dry-run                Show what would be changed without applying
  --force                  Force upgrade even with conflicts

Registry Commands:
  registry list            List all available templates

Examples:
  # Initialize metadata for existing projec
  ./scripts/template-upgrade-native.sh init ./my-flutter-projec

  # Check upgrade status
  cd my-flutter-projec
  ../../scripts/template-upgrade-native.sh status

  # Upgrade to latest version
  ../../scripts/template-upgrade-native.sh upgrade --lates

EOF
}

# Parse simple YAML value (native implementation)
parse_yaml_value() {
    local file="$1"
    local key="$2"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Look for key: value pattern
    local value
    value=$(grep "^[[:space:]]*${key}:" "$file" | head -n1 | sed "s/^[[:space:]]*${key}:[[:space:]]*//" | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/")

    if [[ -n "$value" ]]; then
        echo "$value"
        return 0
    fi

    return 1
}

# Parse nested YAML value
parse_nested_yaml_value() {
    local file="$1"
    local section="$2"
    local key="$3"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Find section and extract key
    local in_section=false
    local section_indent=0

    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue

        # Calculate indentation
        local line_indent=0
        if [[ "$line" =~ ^([[:space:]]*) ]]; then
            line_indent=${#BASH_REMATCH[1]}
        fi

        # Check if we're entering the target section
        if [[ "$line" =~ ^[[:space:]]*${section}:[[:space:]]*$ ]]; then
            in_section=true
            section_indent=$line_inden
            continue
        fi

        # If we're in the section
        if [[ "$in_section" == true ]]; then
            # Check if we've moved to a different section at the same or higher level
            if [[ $line_indent -le $section_indent ]] && [[ "$line" =~ ^[[:space:]]*[^[:space:]]+:[[:space:]]*$ ]]; then
                in_section=false
                continue
            fi

            # Look for our key
            if [[ "$line" =~ ^[[:space:]]*${key}:[[:space:]]*(.+)$ ]]; then
                local value="${BASH_REMATCH[1]}"
                # Remove quotes
                value="${value#\"}"
                value="${value%\"}"
                value="${value#\'}"
                value="${value%\'}"
                echo "$value"
                return 0
            fi
        fi
    done < "$file"

    return 1
}

# Update YAML value (native)
update_yaml_value_native() {
    local file="$1"
    local key="$2"
    local new_value="$3"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Create backup
    cp "$file" "${file}.bak"

    # Use sed to replace the value
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        sed -i '' "s/^[[:space:]]*${key}:[[:space:]]*.*/${key}: \"${new_value}\"/" "$file"
    else
        # Linux sed
        sed -i "s/^[[:space:]]*${key}:[[:space:]]*.*/${key}: \"${new_value}\"/" "$file"
    fi
}

# Add to YAML array (native)
add_to_yaml_array() {
    local file="$1"
    local array_name="$2"
    local entry="$3"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Find the array and add entry after i
    local temp_file=$(mktemp)
    local found_array=false

    while IFS= read -r line; do
        echo "$line" >> "$temp_file"

        if [[ "$line" =~ ^[[:space:]]*${array_name}:[[:space:]]*$ ]]; then
            found_array=true
        elif [[ "$found_array" == true ]] && [[ "$line" =~ ^[[:space:]]*$ ]]; then
            # Add entry before empty line
            echo "$entry" >> "$temp_file"
            found_array=false
        fi
    done < "$file"

    # If array was at the end of file
    if [[ "$found_array" == true ]]; then
        echo "$entry" >> "$temp_file"
    fi

    mv "$temp_file" "$file"
}

# Count YAML array entries
count_yaml_array_entries() {
    local file="$1"
    local array_name="$2"

    if [[ ! -f "$file" ]]; then
        echo "0"
        return
    fi

    local count=0
    local in_array=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*${array_name}:[[:space:]]*$ ]]; then
            in_array=true
            continue
        fi

        if [[ "$in_array" == true ]]; then
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]] ]]; then
                ((count++))
            elif [[ "$line" =~ ^[^[:space:]].*:[[:space:]]*$ ]]; then
                # New section, end of array
                break
            fi
        fi
    done < "$file"

    echo "$count"
}

# Get current working directory project path
get_project_path() {
    local path="${1:-$(pwd)}"
    echo "$(cd "$path" && pwd)"
}

# Check if directory is a template-based projec
is_template_project() {
    local project_path="$1"
    [[ -f "$project_path/.template-metadata" ]]
}

# Initialize template metadata for existing projec
init_template_metadata() {
    local project_path="$(get_project_path "$1")"

    if [[ ! -d "$project_path" ]]; then
        print_error "Project directory not found: $project_path"
        exit 1
    fi

    if is_template_project "$project_path"; then
        print_warning "Project already has template metadata"
        return 0
    fi

    print_header "Initializing Template Metadata"
    print_info "Project path: $project_path"

    # Detect template type
    local template_name=""
    local template_version="1.0.0"
    local workspace_version="2024.1"

    if [[ -f "$project_path/pubspec.yaml" ]]; then
        template_name="flutter-mise"
        print_info "Detected Flutter project"
    elif [[ -f "$project_path/package.json" ]] && [[ -f "$project_path/app.json" ]]; then
        template_name="rn-expo-mise"
        print_info "Detected React Native/Expo project"
    else
        print_error "Unable to detect project type"
        print_info "Supported types: Flutter, React Native/Expo"
        exit 1
    fi

    # Get template version from registry if available
    if [[ -f "$REGISTRY_FILE" ]]; then
        local current_version
        current_version=$(parse_nested_yaml_value "$REGISTRY_FILE" "templates" "current_version" 2>/dev/null)
        if [[ -n "$current_version" ]]; then
            template_version="$current_version"
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
    cat > "$project_path/.template-metadata" << EOF
# This file tracks template properties and upgrade history
# Used by template upgrade system to manage project versions
# This file should be version controlled and not manually edited

template:
  name: "$template_name"
  version: "$template_version"
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
        cat >> "$project_path/.template-metadata" << EOF
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
        cat >> "$project_path/.template-metadata" << EOF
  - "src/**"                     # React Native source code
  - "app/**"                     # Expo Router app directory
  - "components/**"              # React components
  - "constants/**"               # App constants
  - "hooks/**"                   # React hooks
  - "App.{js,jsx,ts,tsx}"        # Main app componen
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
    print_info "Template: $template_name v$template_version"
}

# Show current template status
show_template_status() {
    local project_path="$(get_project_path "$1")"

    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        print_info "Run: ./scripts/template-upgrade-native.sh init $project_path"
        exit 1
    fi

    print_header "Template Status"
    print_info "Project: $(basename "$project_path")"

    # Parse metadata
    local metadata_file="$project_path/.template-metadata"
    local template_name=$(parse_nested_yaml_value "$metadata_file" "template" "name")
    local current_version=$(parse_nested_yaml_value "$metadata_file" "template" "version")
    local workspace_version=$(parse_nested_yaml_value "$metadata_file" "template" "workspace_version")
    local created_at=$(parse_nested_yaml_value "$metadata_file" "template" "created_at")

    echo
    echo "📋 Current Configuration"
    echo "Template: $template_name"
    echo "Version: $current_version"
    echo "Workspace: $workspace_version"
    echo "Created: $created_at"

    # Check for available upgrades
    if [[ -f "$REGISTRY_FILE" ]]; then
        # Simple approach to get latest version
        local latest_version
        latest_version=$(grep -A 5 "^[[:space:]]*${template_name}:" "$REGISTRY_FILE" | grep "current_version:" | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')

        if [[ -n "$latest_version" && "$latest_version" != "$current_version" ]]; then
            echo
            print_warning "Upgrade available: $current_version → $latest_version"
        else
            echo
            print_success "Template is up to date"
        fi
    fi

    # Show upgrade history
    local history_coun
    history_count=$(count_yaml_array_entries "$metadata_file" "upgrade_history")
    if [[ "$history_count" -gt 0 ]]; then
        echo
        echo "📚 Upgrade History ($history_count upgrades)"
        # Simple history display
        grep -A 3 "upgrade_history:" "$metadata_file" | grep -E "(from_version|to_version|upgraded_at)" | sed 's/^[[:space:]]*/  /'
    fi
}

# Check for available upgrades
check_upgrades() {
    local project_path="$(get_project_path "$1")"

    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        exit 1
    fi

    print_header "Checking for Template Upgrades"

    local metadata_file="$project_path/.template-metadata"
    local template_name=$(parse_nested_yaml_value "$metadata_file" "template" "name")
    local current_version=$(parse_nested_yaml_value "$metadata_file" "template" "version")

    if [[ ! -f "$REGISTRY_FILE" ]]; then
        print_error "Template registry not found"
        exit 1
    fi

    # Get latest version (simple approach)
    local latest_version
    latest_version=$(grep -A 5 "^[[:space:]]*${template_name}:" "$REGISTRY_FILE" | grep "current_version:" | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')

    echo "Current version: $current_version"
    echo "Latest version: $latest_version"
    echo

    if [[ "$current_version" == "$latest_version" ]]; then
        print_success "Template is up to date"
        return 0
    fi

    echo "📦 Available Upgrades:"
    echo
    print_warning "Upgrade available: $current_version → $latest_version"

    # Show version information from registry (simplified)
    echo "   Check registry for detailed changes: $REGISTRY_FILE"

    print_info "To upgrade: ./scripts/template-upgrade-native.sh upgrade --version $latest_version"
    print_info "Latest: ./scripts/template-upgrade-native.sh upgrade --latest"
}

# Perform template upgrade
perform_upgrade() {
    local project_path="$(get_project_path)"
    local target_version=""
    local dry_run=false
    local force=false

    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --version)
                target_version="$2"
                shift 2
                ;;
            --latest)
                target_version="latest"
                shif
                ;;
            --dry-run)
                dry_run=true
                shif
                ;;
            --force)
                force=true
                shif
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        exit 1
    fi

    if [[ -z "$target_version" ]]; then
        print_error "Target version required. Use --version <version> or --latest"
        exit 1
    fi

    print_header "Template Upgrade"

    local metadata_file="$project_path/.template-metadata"
    local template_name=$(parse_nested_yaml_value "$metadata_file" "template" "name")
    local current_version=$(parse_nested_yaml_value "$metadata_file" "template" "version")

    # Resolve latest version
    if [[ "$target_version" == "latest" ]]; then
        target_version=$(grep -A 5 "^[[:space:]]*${template_name}:" "$REGISTRY_FILE" | grep "current_version:" | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')
    fi

    print_info "Template: $template_name"
    print_info "Current version: $current_version"
    print_info "Target version: $target_version"

    if [[ "$current_version" == "$target_version" ]]; then
        print_success "Already at target version"
        return 0
    fi

    # Create backup
    print_info "Creating backup..."
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_dir="$BACKUPS_DIR/project_$(basename "$project_path")_$timestamp"
    mkdir -p "$backup_dir"
    cp -r "$project_path"/* "$backup_dir/" 2>/dev/null || true
    print_success "Backup created: $backup_dir"

    if [[ "$dry_run" == "true" ]]; then
        print_info "DRY RUN - No changes will be applied"
        echo
        print_info "Changes that would be applied:"
        echo "  • Update template version: $current_version → $target_version"
        echo "  • Apply template configuration changes"
        echo "  • Update .template-metadata"
        return 0
    fi

    # Apply upgrade
    print_info "Applying upgrade..."

    # Copy new template files
    local template_dir="$TEMPLATES_DIR/$template_name"
    if [[ -f "$template_dir/mise.toml" ]]; then
        print_info "Merging mise.toml (preserving customizations)..."
        cp "$template_dir/mise.toml" "$project_path/mise.toml.new"
        print_warning "New template saved as mise.toml.new - please review and merge manually"
    fi

    # Update metadata using native functions
    local upgraded_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local commit_hash=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

    # Update current version
    update_yaml_value_native "$metadata_file" "version" "$target_version"

    # Add to upgrade history (simplified approach)
    local upgrade_entry="  - from_version: \"$current_version\""$'\n'"    to_version: \"$target_version\""$'\n'"    upgraded_at: \"$upgraded_at\""$'\n'"    commit: \"$commit_hash\""
    add_to_yaml_array "$metadata_file" "upgrade_history" "$upgrade_entry"

    print_success "Template upgraded successfully"
    print_info "Version: $current_version → $target_version"
    print_info "Please test your project to ensure everything works correctly"
}

# Show upgrade history
show_history() {
    local project_path="$(get_project_path "$1")"

    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        exit 1
    fi

    print_header "Template Upgrade History"

    local metadata_file="$project_path/.template-metadata"
    local history_coun
    history_count=$(count_yaml_array_entries "$metadata_file" "upgrade_history")

    if [[ "$history_count" -eq 0 ]]; then
        print_info "No upgrade history found"
        return 0
    fi

    echo "Project: $(basename "$project_path")"
    echo "Total upgrades: $history_count"
    echo

    # Show upgrade history (simplified)
    echo "🔄 Upgrade History"
    grep -A 10 "upgrade_history:" "$metadata_file" | grep -E "(from_version|to_version|upgraded_at)" | sed 's/^[[:space:]]*/   /'
}

# List all templates in registry
list_templates() {
    if [[ ! -f "$REGISTRY_FILE" ]]; then
        print_error "Template registry not found"
        exit 1
    fi

    print_header "Available Templates"

    # Simple template listing
    grep -E "^[[:space:]]*[^[:space:]]+:[[:space:]]*$" "$REGISTRY_FILE" | grep -v "templates:" | while read -r line; do
        local template_name=$(echo "$line" | sed 's/:[[:space:]]*$//' | sed 's/^[[:space:]]*//')

        # Get description and version (simplified)
        local description=$(grep -A 10 "$line" "$REGISTRY_FILE" | grep "description:" | head -n1 | sed 's/.*description:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')
        local version=$(grep -A 10 "$line" "$REGISTRY_FILE" | grep "current_version:" | head -n1 | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')

        echo "📱 $template_name"
        [[ -n "$description" ]] && echo "   Description: $description"
        [[ -n "$version" ]] && echo "   Current version: $version"
        echo
    done
}

# Main function
main() {
    check_dependencies

    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi

    local command="$1"
    shif

    case "$command" in
        init)
            init_template_metadata "$@"
            ;;
        status)
            show_template_status "$@"
            ;;
        check-upgrades)
            check_upgrades "$@"
            ;;
        upgrade)
            perform_upgrade "$@"
            ;;
        history)
            show_history "$@"
            ;;
        registry)
            if [[ $# -gt 0 && "$1" == "list" ]]; then
                list_templates
            else
                show_usage
            fi
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
