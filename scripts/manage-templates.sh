#!/bin/bash

# manage-templates.sh - Script to manage and update mobile development templates
# Usage: ./scripts/manage-templates.sh <command> [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script paths
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
🔧 Template Manager

Usage: $0 <command> [options]

Commands:
  list                  List all available templates
  validate              Validate all templates
  sync                  Sync templates with main mise.toml
  update-versions       Update tool versions in templates
  backup                Create backup of templates
  restore <backup>      Restore templates from backup
  help                  Show this help message

Examples:
  $0 list               # List all templates
  $0 validate           # Check all templates for issues
  $0 sync               # Sync templates with main configuration
  $0 update-versions    # Update tool versions to latest
  $0 backup             # Create timestamped backup
EOF
}

# List all templates
list_templates() {
    print_info "📋 Available Templates:"
    echo
    
    for template_dir in "$TEMPLATES_DIR"/*; do
        if [[ -d "$template_dir" ]]; then
            template_name=$(basename "$template_dir")
            mise_file="$template_dir/mise.toml"
            readme_file="$template_dir/README.md"
            
            echo "📱 $template_name"
            
            if [[ -f "$mise_file" ]]; then
                print_success "  ✓ mise.toml exists"
            else
                print_error "  ✗ mise.toml missing"
            fi
            
            if [[ -f "$readme_file" ]]; then
                print_success "  ✓ README.md exists"
            else
                print_warning "  ! README.md missing"
            fi
            
            # Check for required sections in mise.toml
            if [[ -f "$mise_file" ]]; then
                if grep -q "\[tools\]" "$mise_file"; then
                    print_success "  ✓ [tools] section found"
                else
                    print_warning "  ! [tools] section missing"
                fi
                
                if grep -q "\[tasks\." "$mise_file"; then
                    task_count=$(grep -c "\[tasks\." "$mise_file")
                    print_success "  ✓ $task_count tasks defined"
                else
                    print_warning "  ! No tasks defined"
                fi
            fi
            echo
        fi
    done
}

# Validate templates
validate_templates() {
    print_info "🔍 Validating Templates..."
    local has_errors=false
    
    for template_dir in "$TEMPLATES_DIR"/*; do
        if [[ -d "$template_dir" ]]; then
            template_name=$(basename "$template_dir")
            mise_file="$template_dir/mise.toml"
            
            print_info "Validating $template_name..."
            
            if [[ -f "$mise_file" ]]; then
                # Check if mise can parse the file by testing in the template directory
                pushd "$template_dir" >/dev/null
                if mise ls >/dev/null 2>&1; then
                    print_success "  ✓ mise.toml syntax valid"
                else
                    print_error "  ✗ mise.toml syntax error"
                    has_errors=true
                fi
                popd >/dev/null
                
                # Check for required sections
                if grep -q "\[tools\]" "$mise_file"; then
                    print_success "  ✓ [tools] section found"
                else
                    print_warning "  ! [tools] section missing"
                fi
                
                if grep -q "\[env\]" "$mise_file"; then
                    print_success "  ✓ [env] section found"
                else
                    print_warning "  ! [env] section missing"
                fi
                
                if grep -q "\[tasks\.dev\]" "$mise_file"; then
                    print_success "  ✓ [tasks.dev] section found"
                else
                    print_warning "  ! [tasks.dev] section missing"
                fi
                
                if grep -q "\[tasks\.test\]" "$mise_file"; then
                    print_success "  ✓ [tasks.test] section found"
                else
                    print_warning "  ! [tasks.test] section missing"
                fi
                
                if grep -q "\[tasks\..*build" "$mise_file"; then
                    print_success "  ✓ [tasks.build*] section found"
                else
                    print_warning "  ! [tasks.build*] section missing"
                fi
            else
                print_error "  ✗ mise.toml not found"
                has_errors=true
            fi
            echo
        fi
    done
    
    if [[ "$has_errors" == "true" ]]; then
        print_error "Validation failed with errors"
        exit 1
    else
        print_success "All templates validated successfully"
    fi
}

# Sync templates with main configuration
sync_templates() {
    print_info "🔄 Syncing templates with main configuration..."
    
    local main_mise="$WORKSPACE_ROOT/mise.toml"
    if [[ ! -f "$main_mise" ]]; then
        print_error "Main mise.toml not found: $main_mise"
        exit 1
    fi
    
    # Extract tool versions from main mise.toml
    local node_version=$(grep '^node = ' "$main_mise" | sed 's/node = "\(.*\)"/\1/')
    local python_version=$(grep '^python = ' "$main_mise" | sed 's/python = "\(.*\)"/\1/')
    local java_version=$(grep '^java = ' "$main_mise" | sed 's/java = "\(.*\)"/\1/')
    local flutter_version=$(grep '^flutter = ' "$main_mise" | sed 's/flutter = "\(.*\)"/\1/')
    
    print_info "Main configuration versions:"
    print_info "  Node: $node_version"
    print_info "  Python: $python_version"
    print_info "  Java: $java_version"
    print_info "  Flutter: $flutter_version"
    echo
    
    # Update each template
    for template_dir in "$TEMPLATES_DIR"/*; do
        if [[ -d "$template_dir" ]]; then
            template_name=$(basename "$template_dir")
            mise_file="$template_dir/mise.toml"
            
            if [[ -f "$mise_file" ]]; then
                print_info "Updating $template_name..."
                
                # Update versions
                if [[ -n "$node_version" ]]; then
                    sed -i.bak "s/^node = .*/node = \"$node_version\"/" "$mise_file"
                    print_success "  ✓ Updated Node.js to $node_version"
                fi
                
                if [[ -n "$python_version" ]]; then
                    sed -i.bak "s/^python = .*/python = \"$python_version\"/" "$mise_file"
                    print_success "  ✓ Updated Python to $python_version"
                fi
                
                if [[ -n "$java_version" ]]; then
                    sed -i.bak "s/^java = .*/java = \"$java_version\"/" "$mise_file"
                    print_success "  ✓ Updated Java to $java_version"
                fi
                
                if [[ -n "$flutter_version" ]] && grep -q "flutter = " "$mise_file"; then
                    sed -i.bak "s/^flutter = .*/flutter = \"$flutter_version\"/" "$mise_file"
                    print_success "  ✓ Updated Flutter to $flutter_version"
                fi
                
                # Remove backup files
                rm -f "$mise_file.bak"
                echo
            fi
        fi
    done
    
    print_success "Template sync completed"
}

# Update tool versions to latest
update_versions() {
    print_info "📅 Updating tool versions to latest..."
    
    # Get latest versions (this is a simplified approach)
    print_info "Checking for latest versions..."
    
    # This would typically query actual version APIs
    # For now, we'll show what the process would look like
    print_warning "Note: This is a manual process. Check these sources for latest versions:"
    echo "  - Node.js: https://nodejs.org/en/download/"
    echo "  - Python: https://www.python.org/downloads/"
    echo "  - Java: https://adoptium.net/temurin/releases/"
    echo "  - Flutter: https://docs.flutter.dev/development/tools/sdk/releases"
    echo
    print_info "After checking, update the main mise.toml and run 'sync' command"
}

# Create backup
backup_templates() {
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_dir="$WORKSPACE_ROOT/backups/templates_$timestamp"
    
    print_info "💾 Creating backup: $backup_dir"
    
    mkdir -p "$(dirname "$backup_dir")"
    cp -r "$TEMPLATES_DIR" "$backup_dir"
    
    print_success "Backup created: $backup_dir"
    print_info "To restore: $0 restore templates_$timestamp"
}

# Restore from backup
restore_templates() {
    local backup_name="$1"
    if [[ -z "$backup_name" ]]; then
        print_error "Backup name required"
        print_info "Available backups:"
        ls -la "$WORKSPACE_ROOT/backups/" 2>/dev/null | grep "templates_" || print_info "  No backups found"
        exit 1
    fi
    
    local backup_dir="$WORKSPACE_ROOT/backups/$backup_name"
    if [[ ! -d "$backup_dir" ]]; then
        print_error "Backup not found: $backup_dir"
        exit 1
    fi
    
    print_warning "This will replace all current templates"
    read -p "Continue? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Restore cancelled"
        exit 0
    fi
    
    print_info "🔄 Restoring templates from: $backup_name"
    rm -rf "$TEMPLATES_DIR"
    cp -r "$backup_dir" "$TEMPLATES_DIR"
    
    print_success "Templates restored from $backup_name"
}

# Main function
main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    command="$1"
    shift
    
    case "$command" in
        list)
            list_templates
            ;;
        validate)
            validate_templates
            ;;
        sync)
            sync_templates
            ;;
        update-versions)
            update_versions
            ;;
        backup)
            backup_templates
            ;;
        restore)
            restore_templates "$@"
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
