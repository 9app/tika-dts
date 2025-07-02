#!/bin/bash

# template-upgrade-git.sh - Git-integrated template upgrade system
# Zero external dependencies - Pure bash + git implementation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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
    echo -e "${PURPLE}🔄 $1${NC}"
}

print_command() {
    echo -e "${CYAN}📋 $1${NC}"
}

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$WORKSPACE_ROOT/templates"
REGISTRY_FILE="$TEMPLATES_DIR/.templates-registry.yaml"

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Install git for your platform"
        exit 1
    fi
}

# Parse simple YAML value (native implementation)
parse_yaml_value() {
    local file="$1"
    local key="$2"
    
    if [[ ! -f "$file" ]]; then
        return 1
    fi
    
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
    
    local in_section=false
    local section_indent=0
    
    while IFS= read -r line; do
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue
        
        local line_indent=0
        if [[ "$line" =~ ^([[:space:]]*) ]]; then
            line_indent=${#BASH_REMATCH[1]}
        fi
        
        if [[ "$line" =~ ^[[:space:]]*${section}:[[:space:]]*$ ]]; then
            in_section=true
            section_indent=$line_indent
            continue
        fi
        
        if [[ "$in_section" == true ]]; then
            if [[ $line_indent -le $section_indent ]] && [[ "$line" =~ ^[[:space:]]*[^[:space:]]+:[[:space:]]*$ ]]; then
                in_section=false
                continue
            fi
            
            if [[ "$line" =~ ^[[:space:]]*${key}:[[:space:]]*(.+)$ ]]; then
                local value="${BASH_REMATCH[1]}"
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
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^[[:space:]]*${key}:[[:space:]]*.*/${key}: \"${new_value}\"/" "$file"
    else
        sed -i "s/^[[:space:]]*${key}:[[:space:]]*.*/${key}: \"${new_value}\"/" "$file"
    fi
}

# Check if in git repository
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Check if git working directory is clean
is_git_clean() {
    [[ -z "$(git status --porcelain)" ]]
}

# Get current working directory project path
get_project_path() {
    local path="${1:-$(pwd)}"
    echo "$(cd "$path" && pwd)"
}

# Check if directory is a template-based project
is_template_project() {
    local project_path="$1"
    [[ -f "$project_path/.template-metadata" ]]
}

# Show usage information
show_usage() {
    print_header "Git-Integrated Template Upgrade System"
    echo
    echo "Zero dependencies - Pure bash + git implementation!"
    echo
    echo "Usage: $0 <command> [options]"
    echo
    echo "Commands:"
    echo "  status [path]             Show current template status"
    echo "  check-upgrades [path]     Check for available template upgrades"
    echo "  upgrade [options]         Upgrade template using git workflow"
    echo "  history [path]            Show upgrade history"
    echo "  rollback <version>        Rollback using git"
    echo "  init <path>               Initialize template metadata"
    echo
    echo "Upgrade Options:"
    echo "  --version <version>       Upgrade to specific version"
    echo "  --latest                  Upgrade to latest version"
    echo "  --dry-run                Show what would be changed"
    echo "  --auto-branch             Auto-create upgrade branch"
    echo "  --branch <name>           Use custom branch name"
    echo "  --no-git                 Disable git integration"
    echo
    echo "Examples:"
    echo "  # Check current status"
    echo "  $0 status"
    echo
    echo "  # Check available upgrades"
    echo "  $0 check-upgrades"
    echo
    echo "  # Upgrade with git integration (recommended)"
    echo "  $0 upgrade --latest --auto-branch"
    echo
    echo "  # Upgrade to specific version with custom branch"
    echo "  $0 upgrade --version 1.3.0 --branch \"upgrade/flutter-1.3.0\""
    echo
    echo "  # Rollback using git"
    echo "  $0 rollback 1.2.0"
    echo
}

# Show current template status
show_status() {
    local project_path="$(get_project_path "$1")"
    
    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        print_info "Run: $0 init . to initialize template metadata"
        exit 1
    fi
    
    print_header "Template Status"
    print_info "Project: $(basename "$project_path")"
    
    if is_git_repo; then
        local git_status="Clean"
        if ! is_git_clean; then
            git_status="Uncommitted changes"
        fi
        print_info "Git status: $git_status"
        print_info "Current branch: $(git branch --show-current)"
    fi
    
    local metadata_file="$project_path/.template-metadata"
    local template_name=$(parse_nested_yaml_value "$metadata_file" "template" "name")
    local current_version=$(parse_nested_yaml_value "$metadata_file" "template" "version")
    local workspace_version=$(parse_nested_yaml_value "$metadata_file" "template" "workspace_version")
    local created_at=$(parse_nested_yaml_value "$metadata_file" "template" "created_at")
    
    echo
    print_command "Current Configuration"
    echo "Template: $template_name"
    echo "Version: $current_version"
    echo "Workspace: $workspace_version"
    echo "Created: $created_at"
    
    # Check if upgrade available
    if [[ -f "$REGISTRY_FILE" ]]; then
        local latest_version=$(grep -A 5 "^[[:space:]]*${template_name}:" "$REGISTRY_FILE" | grep "current_version:" | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')
        
        if [[ -n "$latest_version" ]] && [[ "$current_version" != "$latest_version" ]]; then
            echo
            print_warning "Upgrade available: $current_version → $latest_version"
        else
            echo
            print_success "Template is up to date"
        fi
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
    
    local latest_version=$(grep -A 5 "^[[:space:]]*${template_name}:" "$REGISTRY_FILE" | grep "current_version:" | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')
    
    echo "Current version: $current_version"
    echo "Latest version: $latest_version"
    echo
    
    if [[ "$current_version" == "$latest_version" ]]; then
        print_success "Template is up to date"
        return 0
    fi
    
    print_command "Available Upgrades:"
    print_warning "Upgrade available: $current_version → $latest_version"
    echo "   Check registry for detailed changes: $REGISTRY_FILE"
    echo
    print_info "To upgrade with git integration:"
    print_command "$0 upgrade --latest --auto-branch"
    print_info "To upgrade to specific version:"
    print_command "$0 upgrade --version $latest_version --auto-branch"
}

# Perform template upgrade with git integration
perform_upgrade() {
    local project_path="$(get_project_path)"
    local target_version="$1"
    local dry_run="$2"
    local auto_branch="$3"
    local custom_branch="$4"
    local no_git="$5"
    
    if ! is_template_project "$project_path"; then
        print_error "Not a template-based project"
        exit 1
    fi
    
    print_header "Git-Integrated Template Upgrade"
    
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
    
    # Git integration (if enabled)
    local upgrade_branch=""
    local original_branch=""
    
    if [[ "$no_git" != "true" ]] && is_git_repo; then
        print_info "Git integration enabled"
        
        # Check git status
        if ! is_git_clean; then
            print_warning "Working directory has uncommitted changes"
            print_info "Commit or stash changes before upgrade"
            
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Upgrade cancelled"
                exit 0
            fi
        fi
        
        # Get current branch
        original_branch=$(git branch --show-current)
        
        # Create upgrade branch
        if [[ "$auto_branch" == "true" ]]; then
            local timestamp=$(date +"%Y%m%d-%H%M%S")
            upgrade_branch="template-upgrade-${current_version}-to-${target_version}-${timestamp}"
        elif [[ -n "$custom_branch" ]]; then
            upgrade_branch="$custom_branch"
        fi
        
        if [[ -n "$upgrade_branch" ]]; then
            print_info "Creating upgrade branch: $upgrade_branch"
            git checkout -b "$upgrade_branch"
            
            # Commit current state if needed
            if ! is_git_clean; then
                git add -A
                git commit -m "feat: save state before template upgrade

Template: $template_name
From: $current_version
To: $target_version"
            fi
        fi
    fi
    
    if [[ "$dry_run" == "true" ]]; then
        print_info "DRY RUN - No changes will be applied"
        echo
        print_info "Changes that would be applied:"
        echo "  • Update template version: $current_version → $target_version"
        echo "  • Apply template configuration changes"
        echo "  • Update .template-metadata"
        if [[ -n "$upgrade_branch" ]]; then
            echo "  • Create git branch: $upgrade_branch"
            echo "  • Git commit with template changes"
        fi
        return 0
    fi
    
    # Apply upgrade
    print_info "Applying template upgrade..."
    
    # Copy template files with git-friendly approach
    local template_dir="$TEMPLATES_DIR/$template_name"
    
    if [[ -f "$template_dir/mise.toml" ]]; then
        print_info "Updating mise.toml..."
        
        if [[ "$no_git" != "true" ]] && is_git_repo && [[ -n "$upgrade_branch" ]]; then
            # Git-integrated approach
            cp "$project_path/mise.toml" "$project_path/mise.toml.backup"
            cp "$template_dir/mise.toml" "$project_path/mise.toml"
            
            # Add to git for conflict detection
            git add mise.toml
            
            # Check if there are conflicts to resolve
            if git diff --cached --name-only | grep -q mise.toml; then
                print_info "Template changes applied to mise.toml"
            fi
        else
            # Non-git approach (fallback)
            cp "$template_dir/mise.toml" "$project_path/mise.toml.new"
            print_warning "New template saved as mise.toml.new - please review and merge manually"
        fi
    fi
    
    # Copy other template files as needed
    if [[ -d "$template_dir/.vscode" ]]; then
        print_info "Updating VS Code configuration..."
        cp -r "$template_dir/.vscode/"* "$project_path/.vscode/" 2>/dev/null || true
        
        if [[ "$no_git" != "true" ]] && is_git_repo && [[ -n "$upgrade_branch" ]]; then
            git add .vscode/
        fi
    fi
    
    # Update metadata
    print_info "Updating template metadata..."
    local upgraded_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    update_yaml_value_native "$metadata_file" "version" "$target_version"
    
    # Add upgrade to history
    local upgrade_entry="  - from_version: \"$current_version\""$'\n'"    to_version: \"$target_version\""$'\n'"    upgraded_at: \"$upgraded_at\""
    if is_git_repo; then
        local commit_hash=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
        upgrade_entry="${upgrade_entry}"$'\n'"    commit: \"$commit_hash\""
    fi
    
    # Append to upgrade_history
    echo "$upgrade_entry" >> "$metadata_file"
    
    if [[ "$no_git" != "true" ]] && is_git_repo && [[ -n "$upgrade_branch" ]]; then
        # Git commit the upgrade
        git add .template-metadata
        git commit -m "feat: upgrade template to $target_version

Template: $template_name
Version: $current_version → $target_version
Upgraded: $upgraded_at

Changes applied:
- Updated template configuration
- Updated tool versions  
- Enhanced development tasks

To merge: git checkout $original_branch && git merge $upgrade_branch
To rollback: git checkout $original_branch && git branch -D $upgrade_branch"
        
        print_success "Template upgraded successfully using git!"
        print_info "Upgrade branch: $upgrade_branch"
        print_info "Original branch: $original_branch"
        echo
        print_command "Next steps:"
        echo "1. Test the upgraded project:"
        echo "   mise doctor"
        echo "   mise run test"
        echo
        echo "2. If upgrade successful, merge to main branch:"
        echo "   git checkout $original_branch"
        echo "   git merge $upgrade_branch"
        echo "   git branch -d $upgrade_branch"
        echo
        echo "3. If upgrade failed, rollback easily:"
        echo "   git checkout $original_branch"
        echo "   git branch -D $upgrade_branch"
        
    else
        print_success "Template upgraded successfully"
        print_info "Version: $current_version → $target_version"
        print_info "Please test your project to ensure everything works correctly"
    fi
}

# Git-based rollback
git_rollback() {
    local target_version="$1"
    local project_path="$(get_project_path)"
    
    if ! is_git_repo; then
        print_error "Git repository required for rollback"
        print_info "Use git to rollback manually or restore from backup"
        exit 1
    fi
    
    print_header "Git-based Template Rollback"
    print_info "Target version: $target_version"
    
    # Find upgrade commit
    local upgrade_commits=$(git log --oneline --grep="upgrade template" --grep="feat: upgrade" | head -10)
    
    if [[ -z "$upgrade_commits" ]]; then
        print_error "No template upgrade commits found"
        print_info "Available rollback methods:"
        echo "1. Manual git reset: git reset --hard <commit-hash>"
        echo "2. Revert specific commit: git revert <commit-hash>"
        exit 1
    fi
    
    print_info "Recent template upgrade commits:"
    echo "$upgrade_commits"
    echo
    
    read -p "Enter commit hash to rollback to (or 'cancel'): " commit_hash
    
    if [[ "$commit_hash" == "cancel" ]] || [[ -z "$commit_hash" ]]; then
        print_info "Rollback cancelled"
        exit 0
    fi
    
    # Validate commit exists
    if ! git cat-file -e "$commit_hash" 2>/dev/null; then
        print_error "Invalid commit hash: $commit_hash"
        exit 1
    fi
    
    # Confirm rollback
    print_warning "This will reset your project to commit: $commit_hash"
    print_warning "All changes after this commit will be lost!"
    
    read -p "Continue with rollback? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Rollback cancelled"
        exit 0
    fi
    
    # Perform rollback
    print_info "Rolling back to commit: $commit_hash"
    git reset --hard "$commit_hash"
    
    print_success "Rollback completed"
    print_info "Project restored to previous state"
    
    # Update status
    show_status
}

# Show upgrade history from git and metadata
show_history() {
    local project_path="$(get_project_path "$1")"
    
    print_header "Template Upgrade History"
    
    if is_git_repo; then
        print_info "Git commit history:"
        git log --oneline --grep="upgrade template" --grep="feat: upgrade" | head -10
        echo
    fi
    
    if is_template_project "$project_path"; then
        print_info "Template metadata history:"
        local metadata_file="$project_path/.template-metadata"
        grep -A 10 "upgrade_history:" "$metadata_file" | grep -E "(from_version|to_version|upgraded_at)" | sed 's/^[[:space:]]*/   /'
    else
        print_warning "No template metadata found"
    fi
}

# Initialize template metadata
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
    
    # Get template version from registry
    if [[ -f "$REGISTRY_FILE" ]]; then
        local current_version=$(grep -A 5 "^[[:space:]]*${template_name}:" "$REGISTRY_FILE" | grep "current_version:" | sed 's/.*current_version:[[:space:]]*//' | sed 's/^"\(.*\)"$/\1/')
        if [[ -n "$current_version" ]]; then
            template_version="$current_version"
        fi
    fi
    
    local created_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local base_commit=""
    if is_git_repo; then
        base_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    fi
    
    # Create metadata file
    cat > "$project_path/.template-metadata" << EOF
# Template metadata for git-integrated upgrade system
# This file should be version controlled

template:
  name: "$template_name"
  version: "$template_version"
  workspace_version: "$workspace_version"
  created_at: "$created_at"
  base_commit: "$base_commit"

# Git-tracked upgrade history
upgrade_history: []

# User customizations preserved during upgrades
customizations:
  modified_files: []
  custom_tasks: []
  custom_env: []

# Files excluded from template upgrades
unmanaged_files:
  - "lib/**"                  # User code
  - "assets/**"               # User assets
  - ".env.local"              # Local config
EOF

    print_success "Template metadata created: .template-metadata"
    
    if is_git_repo; then
        print_info "Add to git: git add .template-metadata"
    fi
}

# Main execution
main() {
    check_dependencies
    
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 0
    fi
    
    local command="$1"
    shift
    
    case "$command" in
        status)
            show_status "$@"
            ;;
        check-upgrades)
            check_upgrades "$@"
            ;;
        upgrade)
            local target_version=""
            local dry_run="false"
            local auto_branch="false"
            local custom_branch=""
            local no_git="false"
            
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --version)
                        target_version="$2"
                        shift 2
                        ;;
                    --latest)
                        target_version="latest"
                        shift
                        ;;
                    --dry-run)
                        dry_run="true"
                        shift
                        ;;
                    --auto-branch)
                        auto_branch="true"
                        shift
                        ;;
                    --branch)
                        custom_branch="$2"
                        shift 2
                        ;;
                    --no-git)
                        no_git="true"
                        shift
                        ;;
                    *)
                        print_error "Unknown option: $1"
                        show_usage
                        exit 1
                        ;;
                esac
            done
            
            if [[ -z "$target_version" ]]; then
                print_error "Version required. Use --latest or --version <version>"
                exit 1
            fi
            
            perform_upgrade "$target_version" "$dry_run" "$auto_branch" "$custom_branch" "$no_git"
            ;;
        rollback)
            if [[ $# -eq 0 ]]; then
                print_error "Target version required for rollback"
                exit 1
            fi
            git_rollback "$1"
            ;;
        history)
            show_history "$@"
            ;;
        init)
            init_template_metadata "$@"
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

# Execute main function with all arguments
main "$@"
