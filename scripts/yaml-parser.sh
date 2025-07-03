#!/bin/bash

# yaml-parser.sh - Pure bash YAML parser without external dependencies
# Provides basic YAML parsing functionality for template upgrade system

# Parse YAML key-value pairs
parse_yaml() {
    local file="$1"
    local prefix="${2:-}"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Remove comments and empty lines, then process
    grep -v '^[[:space:]]*#' "$file" | grep -v '^[[:space:]]*$' | while IFS= read -r line; do
        # Skip if line starts with ---
        [[ "$line" =~ ^[[:space:]]*--- ]] && continue

        # Handle simple key: value pairs
        if [[ "$line" =~ ^[[:space:]]*([^:]+):[[:space:]]*(.*)$ ]]; then
            local key="${BASH_REMATCH[1]// /}"  # Remove spaces
            local value="${BASH_REMATCH[2]}"

            # Remove quotes from value
            value="${value#\"}"
            value="${value%\"}"
            value="${value#\'}"
            value="${value%\'}"

            echo "${prefix}${key}=${value}"
        fi
    done
}

# Get specific value from YAML
get_yaml_value() {
    local file="$1"
    local key_path="$2"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Simple implementation for nested keys like "templates.flutter-mise.current_version"
    local current_section=""
    local target_section=""
    local target_key=""

    # Parse key path
    if [[ "$key_path" =~ ^([^.]+)\.([^.]+)\.(.+)$ ]]; then
        target_section="${BASH_REMATCH[2]}"
        target_key="${BASH_REMATCH[3]}"
    elif [[ "$key_path" =~ ^([^.]+)\.(.+)$ ]]; then
        target_section="${BASH_REMATCH[1]}"
        target_key="${BASH_REMATCH[2]}"
    else
        target_key="$key_path"
    fi

    # Read file line by line
    local in_target_section=false
    local indent_level=0

    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue
        [[ "$line" =~ ^[[:space:]]*--- ]] && continue

        # Count indentation
        local current_indent=0
        if [[ "$line" =~ ^([[:space:]]*) ]]; then
            current_indent=${#BASH_REMATCH[1]}
        fi

        # Check if we're entering a new section
        if [[ "$line" =~ ^[[:space:]]*([^:]+):[[:space:]]*$ ]]; then
            local section_name="${BASH_REMATCH[1]// /}"

            if [[ -z "$target_section" ]]; then
                in_target_section=true
            elif [[ "$section_name" == "$target_section" ]]; then
                in_target_section=true
                indent_level=$current_inden
            elif [[ $current_indent -le $indent_level ]]; then
                in_target_section=false
            fi
        fi

        # Check for key-value pair
        if [[ "$line" =~ ^[[:space:]]*([^:]+):[[:space:]]*(.+)$ ]] && [[ "$in_target_section" == true ]]; then
            local key="${BASH_REMATCH[1]// /}"
            local value="${BASH_REMATCH[2]}"

            if [[ "$key" == "$target_key" ]]; then
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

# Update YAML value
update_yaml_value() {
    local file="$1"
    local key_path="$2"
    local new_value="$3"
    local backup_file="${file}.bak"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    # Create backup
    cp "$file" "$backup_file"

    # Simple replacement for single-level keys
    if [[ "$key_path" =~ ^[^.]+$ ]]; then
        sed -i.tmp "s/^[[:space:]]*${key_path}:[[:space:]]*.*/${key_path}: \"${new_value}\"/" "$file"
        rm -f "${file}.tmp"
        return 0
    fi

    # For nested keys, we'll use a more complex approach
    # This is a simplified version - in production, you might want more robust parsing
    local temp_file=$(mktemp)
    local target_key="${key_path##*.}"
    local in_target_section=false
    local updated=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*${target_key}:[[:space:]]* ]] && [[ "$in_target_section" == true ]]; then
            echo "  ${target_key}: \"${new_value}\"" >> "$temp_file"
            updated=true
        else
            echo "$line" >> "$temp_file"
        fi

        # Simple section detection (this could be improved)
        if [[ "$key_path" =~ template\.version ]] && [[ "$line" =~ ^template: ]]; then
            in_target_section=true
        fi
    done < "$file"

    if [[ "$updated" == true ]]; then
        mv "$temp_file" "$file"
    else
        rm -f "$temp_file"
        return 1
    fi
}

# Add entry to YAML array
add_yaml_array_entry() {
    local file="$1"
    local array_path="$2"
    local entry="$3"

    # Find the array and add entry
    # This is a simplified implementation
    local temp_file=$(mktemp)
    local in_array=false

    while IFS= read -r line; do
        echo "$line" >> "$temp_file"

        if [[ "$line" =~ ^${array_path}:[[:space:]]*$ ]]; then
            echo "$entry" >> "$temp_file"
        fi
    done < "$file"

    mv "$temp_file" "$file"
}

# Get array length
get_yaml_array_length() {
    local file="$1"
    local array_path="$2"

    if [[ ! -f "$file" ]]; then
        echo "0"
        return
    fi

    # Count entries that start with "  - "
    local count=0
    local in_array=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^${array_path}:[[:space:]]*$ ]]; then
            in_array=true
            continue
        fi

        if [[ "$in_array" == true ]]; then
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]] ]]; then
                ((count++))
            elif [[ "$line" =~ ^[^[:space:]] ]]; then
                # End of array
                break
            fi
        fi
    done < "$file"

    echo "$count"
}

# Test if value exists
yaml_key_exists() {
    local file="$1"
    local key_path="$2"

    local value
    value=$(get_yaml_value "$file" "$key_path" 2>/dev/null)
    [[ -n "$value" ]]
}

# Create simple YAML structure
create_yaml_structure() {
    local file="$1"
    shif
    local entries=("$@")

    cat > "$file" << 'EOF'
# Auto-generated YAML file
# Do not edit manually
EOF

    for entry in "${entries[@]}"; do
        echo "$entry" >> "$file"
    done
}

# Usage examples:
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "YAML Parser Utility"
    echo "Usage examples:"
    echo "  parse_yaml file.yaml"
    echo "  get_yaml_value file.yaml 'key.subkey'"
    echo "  update_yaml_value file.yaml 'key' 'new_value'"
fi
