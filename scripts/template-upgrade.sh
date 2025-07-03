#!/bin/bash

# template-upgrade.sh - Template upgrade system for mobile development projects
# Usage: ./scripts/template-upgrade.sh <command> [options]

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

# Check dependencies
check_dependencies() {
    local missing_deps=()

    command -v yq >/dev/null 2>&1 || missing_deps+=("yq")
    command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "This script requires external dependencies: ${missing_deps[*]}"
        echo ""
        print_info "🎯 RECOMMENDED SOLUTION:"
        echo "  Use the native script instead (zero dependencies):"
        echo "  ./scripts/template-upgrade-native.sh <command>"
        echo ""
        print_warning "If you absolutely need the full-featured script:"
        echo "  Research platform-specific installation for missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "yq") echo "  - yq: https://github.com/mikefarah/yq#install" ;;
                "jq") echo "  - jq: https://github.com/jqlang/jq#installation" ;;
                "git") echo "  - git: https://git-scm.com/downloads" ;;
            esac
        done
        echo ""
        echo "⚠️  Note: External dependencies can cause compatibility issues"
        exit 1
    fi
}

# Show usage information
show_usage() {
    cat << 'EOF'
🔄 Template Upgrade System

Usage: ./scripts/template-upgrade.sh <command> [options]

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
  --interactive            Interactive upgrade with conflict resolution
  --dry-run                Show what would be changed without applying
  --preserve-custom        Preserve all user customizations
  --backup                 Create backup before upgrade (default: true)
  --force                  Force upgrade even with conflicts

Registry Commands:
  registry list            List all available templates
  registry update          Update template registry
  registry add-version     Add new version to template

Examples:
  # Initialize metadata for existing projec
  ./scripts/template-upgrade.sh init ./my-flutter-projec

  # Check upgrade status
  cd my-flutter-projec
  ../../scripts/template-upgrade.sh status

  # Check available upgrades
  ../../scripts/template-upgrade.sh check-upgrades

  # Upgrade to latest version interactively
  ../../scripts/template-upgrade.sh upgrade --latest --interactive

  # Upgrade to specific version with dry run
  ../../scripts/template-upgrade.sh upgrade --version 1.2.0 --dry-run

  # Show upgrade history
  ../../scripts/template-upgrade.sh history

EOF
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

# Get template metadata
get_template_metadata() {
    local project_path="$1"
    local metadata_file="$project_path/.template-metadata"

    if [[ ! -f "$metadata_file" ]]; then
        print_error "Template metadata not found: $metadata_file"
        return 1
    fi

    cat "$metadata_file"
}

# Get template info from registry
get_template_from_registry() {
    local template_name="$1"

    if [[ ! -f "$REGISTRY_FILE" ]]; then
        print_error "Template registry not found: $REGISTRY_FILE"
        return 1
    fi

    yq eval ".templates.$template_name" "$REGISTRY_FILE"
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

    # Get current timestamp
    local created_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Get git commit if available
    local base_commit=""
    if git rev-parse --git-dir >/dev/null 2>&1; then
        base_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    fi

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
  - "lib/main.dart"              # User application code
  - "assets/**"                  # User assets
  - ".env.local"                 # Local environment config
  - "ios/Runner.xcodeproj/project.pbxproj"  # iOS project file
  - "android/app/src/main/**"    # Android application code

# Compatibility information
compatibility:
  min_workspace_version: "$workspace_version"
  max_workspace_version: "2025.1"
EOF

    # Add template-specific unmanaged files
    if [[ "$template_name" == "flutter-mise" ]]; then
        cat >> "$project_path/.template-metadata" << EOF
  flutter_sdk_range: ">=3.30.0 <4.0.0"
  dart_version_range: ">=3.6.0 <4.0.0"
EOF
    elif [[ "$template_name" == "rn-expo-mise" ]]; then
        cat >> "$project_path/.template-metadata" << EOF
  node_version_range: ">=18.0.0 <22.0.0"
  react_native_range: ">=0.74.0 <1.0.0"
EOF
    fi

    print_success "Template metadata initialized"
    print_info "Metadata file: $project_path/.template-metadata"
    print_info "Template: $template_name v$template_version"
}

# Show current template status
show_template_status() {
    local project_path="$(get_project_path "$1")"

    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        print_info "Run: ./scripts/template-upgrade.sh init $project_path"
        exit 1
    fi

    print_header "Template Status"
    print_info "Project: $(basename "$project_path")"

    # Parse metadata
    local metadata_file="$project_path/.template-metadata"
    local template_name=$(yq eval '.template.name' "$metadata_file")
    local current_version=$(yq eval '.template.version' "$metadata_file")
    local workspace_version=$(yq eval '.template.workspace_version' "$metadata_file")
    local created_at=$(yq eval '.template.created_at' "$metadata_file")

    echo
    echo "📋 Current Configuration"
    echo "Template: $template_name"
    echo "Version: $current_version"
    echo "Workspace: $workspace_version"
    echo "Created: $created_at"

    # Check for available upgrades
    if [[ -f "$REGISTRY_FILE" ]]; then
        local latest_version=$(yq eval ".templates.$template_name.current_version" "$REGISTRY_FILE")

        if [[ "$latest_version" != "null" && "$latest_version" != "$current_version" ]]; then
            echo
            print_warning "Upgrade available: $current_version → $latest_version"
        else
            echo
            print_success "Template is up to date"
        fi
    fi

    # Show upgrade history
    local history_count=$(yq eval '.upgrade_history | length' "$metadata_file")
    if [[ "$history_count" -gt 0 ]]; then
        echo
        echo "📚 Upgrade History ($history_count upgrades)"
        yq eval '.upgrade_history[] | "  " + .from_version + " → " + .to_version + " (" + .upgraded_at + ")"' "$metadata_file"
    fi

    # Show customizations
    local custom_files=$(yq eval '.customizations.modified_files | length' "$metadata_file")
    local custom_tasks=$(yq eval '.customizations.custom_tasks | length' "$metadata_file")
    local custom_env=$(yq eval '.customizations.custom_env | length' "$metadata_file")

    if [[ "$custom_files" -gt 0 || "$custom_tasks" -gt 0 || "$custom_env" -gt 0 ]]; then
        echo
        echo "🎨 Customizations"
        [[ "$custom_files" -gt 0 ]] && echo "  Modified files: $custom_files"
        [[ "$custom_tasks" -gt 0 ]] && echo "  Custom tasks: $custom_tasks"
        [[ "$custom_env" -gt 0 ]] && echo "  Custom env vars: $custom_env"
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
    local template_name=$(yq eval '.template.name' "$metadata_file")
    local current_version=$(yq eval '.template.version' "$metadata_file")

    if [[ ! -f "$REGISTRY_FILE" ]]; then
        print_error "Template registry not found"
        exit 1
    fi

    # Get available versions
    local available_versions=$(yq eval ".templates.$template_name.versions[].version" "$REGISTRY_FILE")
    local latest_version=$(yq eval ".templates.$template_name.current_version" "$REGISTRY_FILE")

    echo "Current version: $current_version"
    echo "Latest version: $latest_version"
    echo

    if [[ "$current_version" == "$latest_version" ]]; then
        print_success "Template is up to date"
        return 0
    fi

    echo "📦 Available Upgrades:"
    echo

    # Find versions newer than curren
    local found_newer=false
    while IFS= read -r version; do
        if [[ "$found_newer" == "true" ]] || [[ "$version" == "$current_version" ]]; then
            if [[ "$version" != "$current_version" ]]; then
                local desc=$(yq eval ".templates.$template_name.versions[] | select(.version == \"$version\") | .description" "$REGISTRY_FILE")
                local breaking=$(yq eval ".templates.$template_name.versions[] | select(.version == \"$version\") | .breaking_changes // false" "$REGISTRY_FILE")
                local changes=$(yq eval ".templates.$template_name.versions[] | select(.version == \"$version\") | .changes[]? // \"\"" "$REGISTRY_FILE")

                echo "🔄 $current_version → $version"
                echo "   Description: $desc"
                if [[ "$breaking" == "true" ]]; then
                    print_warning "   ⚠️  Breaking changes - migration may be required"
                fi
                if [[ -n "$changes" && "$changes" != "" ]]; then
                    echo "   Changes:"
                    while IFS= read -r change; do
                        [[ -n "$change" ]] && echo "     • $change"
                    done <<< "$changes"
                fi
                echo
            fi
            found_newer=true
        fi
    done <<< "$available_versions"

    print_info "To upgrade: ./scripts/template-upgrade.sh upgrade --version $latest_version"
    print_info "Interactive: ./scripts/template-upgrade.sh upgrade --latest --interactive"
}

# Perform template upgrade
perform_upgrade() {
    local project_path="$(get_project_path)"
    local target_version=""
    local interactive=false
    local dry_run=false
    local preserve_custom=true
    local create_backup=true
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
            --interactive)
                interactive=true
                shif
                ;;
            --dry-run)
                dry_run=true
                shif
                ;;
            --preserve-custom)
                preserve_custom=true
                shif
                ;;
            --no-backup)
                create_backup=false
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
    local template_name=$(yq eval '.template.name' "$metadata_file")
    local current_version=$(yq eval '.template.version' "$metadata_file")

    # Resolve latest version
    if [[ "$target_version" == "latest" ]]; then
        target_version=$(yq eval ".templates.$template_name.current_version" "$REGISTRY_FILE")
    fi

    print_info "Template: $template_name"
    print_info "Current version: $current_version"
    print_info "Target version: $target_version"

    if [[ "$current_version" == "$target_version" ]]; then
        print_success "Already at target version"
        return 0
    fi

    # Validate target version exists
    local version_exists=$(yq eval ".templates.$template_name.versions[] | select(.version == \"$target_version\") | .version" "$REGISTRY_FILE")
    if [[ "$version_exists" != "$target_version" ]]; then
        print_error "Version $target_version not found in registry"
        exit 1
    fi

    # Check for breaking changes
    local breaking_changes=$(yq eval ".templates.$template_name.versions[] | select(.version == \"$target_version\") | .breaking_changes // false" "$REGISTRY_FILE")
    if [[ "$breaking_changes" == "true" && "$force" != "true" ]]; then
        print_warning "This upgrade contains breaking changes"
        local migration_guide=$(yq eval ".templates.$template_name.versions[] | select(.version == \"$target_version\") | .migration_guide // \"\"" "$REGISTRY_FILE")
        if [[ -n "$migration_guide" ]]; then
            print_info "Migration guide: $migration_guide"
        fi

        if [[ "$interactive" != "true" ]]; then
            print_error "Use --force to proceed with breaking changes or --interactive for guided upgrade"
            exit 1
        fi
    fi

    # Create backup if requested
    if [[ "$create_backup" == "true" ]]; then
        print_info "Creating backup..."
        local timestamp=$(date +"%Y%m%d_%H%M%S")
        local backup_dir="$BACKUPS_DIR/project_$(basename "$project_path")_$timestamp"
        mkdir -p "$backup_dir"
        cp -r "$project_path"/* "$backup_dir/" 2>/dev/null || true
        print_success "Backup created: $backup_dir"
    fi

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
        if [[ "$preserve_custom" == "true" ]]; then
            print_info "Merging mise.toml (preserving customizations)..."
            # In a real implementation, this would do intelligent merging
            cp "$template_dir/mise.toml" "$project_path/mise.toml.new"
            print_warning "New template saved as mise.toml.new - please review and merge manually"
        else
            cp "$template_dir/mise.toml" "$project_path/mise.toml"
            print_success "Updated mise.toml"
        fi
    fi

    # Update metadata
    local upgraded_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local commit_hash=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

    # Add to upgrade history
    yq eval -i ".upgrade_history += [{\"from_version\": \"$current_version\", \"to_version\": \"$target_version\", \"workspace_version\": \"2024.2\", \"upgraded_at\": \"$upgraded_at\", \"commit\": \"$commit_hash\"}]" "$metadata_file"

    # Update current version
    yq eval -i ".template.version = \"$target_version\"" "$metadata_file"

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
    local history_count=$(yq eval '.upgrade_history | length' "$metadata_file")

    if [[ "$history_count" -eq 0 ]]; then
        print_info "No upgrade history found"
        return 0
    fi

    echo "Project: $(basename "$project_path")"
    echo "Total upgrades: $history_count"
    echo

    # Show each upgrade
    for ((i=0; i<history_count; i++)); do
        local from_version=$(yq eval ".upgrade_history[$i].from_version" "$metadata_file")
        local to_version=$(yq eval ".upgrade_history[$i].to_version" "$metadata_file")
        local upgraded_at=$(yq eval ".upgrade_history[$i].upgraded_at" "$metadata_file")
        local commit=$(yq eval ".upgrade_history[$i].commit" "$metadata_file")

        echo "🔄 Upgrade $((i+1))"
        echo "   Version: $from_version → $to_version"
        echo "   Date: $upgraded_at"
        echo "   Commit: $commit"
        echo
    done
}

# List all templates in registry
list_templates() {
    if [[ ! -f "$REGISTRY_FILE" ]]; then
        print_error "Template registry not found"
        exit 1
    fi

    print_header "Available Templates"

    local template_names=$(yq eval '.templates | keys | .[]' "$REGISTRY_FILE")

    while IFS= read -r template_name; do
        local description=$(yq eval ".templates.$template_name.description" "$REGISTRY_FILE")
        local current_version=$(yq eval ".templates.$template_name.current_version" "$REGISTRY_FILE")
        local platforms=$(yq eval ".templates.$template_name.supported_platforms | join(\", \")" "$REGISTRY_FILE")

        echo "📱 $template_name"
        echo "   Description: $description"
        echo "   Current version: $current_version"
        echo "   Platforms: $platforms"
        echo
    done <<< "$template_names"
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
