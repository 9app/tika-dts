#!/bin/bash

# Documentation Link Checker
# Kiểm tra các liên kết bị hỏng trong hệ thống tài liệu Tika

set -e

# Colors for outpu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOCS_DIR="docs"
TEMPLATES_DIR="templates"
ROOT_DIR="."
BROKEN_LINKS=()
TOTAL_LINKS=0
BROKEN_COUNT=0

echo -e "${BLUE}🔍 Tika Documentation Link Checker${NC}"
echo "======================================="

# Function to check if file exists
check_file_exists() {
    local file_path="$1"
    local source_file="$2"

    # Convert relative path to absolute
    if [[ "$file_path" == ./* ]]; then
        file_path="${file_path#./}"
    fi

    # Handle different path patterns
    case "$file_path" in
        docs/*)
            full_path="$file_path"
            ;;
        ./docs/*)
            full_path="${file_path#./}"
            ;;
        ../docs/*)
            full_path="docs/${file_path#../docs/}"
            ;;
        ../../docs/*)
            full_path="docs/${file_path#../../docs/}"
            ;;
        ../*)
            # Handle relative paths from templates
            full_path="${file_path#../}"
            ;;
        templates/*)
            full_path="$file_path"
            ;;
        ./templates/*)
            full_path="${file_path#./}"
            ;;
        *)
            # Assume it's relative to current directory
            full_path="$file_path"
            ;;
    esac

    if [[ -f "$full_path" ]]; then
        return 0
    else
        BROKEN_LINKS+=("$source_file → $file_path (resolved to: $full_path)")
        ((BROKEN_COUNT++))
        return 1
    fi
}

# Function to extract and check links from markdown files
check_markdown_links() {
    local file="$1"
    echo -e "${YELLOW}📄 Checking: $file${NC}"

    # Extract markdown links: [text](path) and [text](path#anchor)
    while IFS= read -r line; do
        # Find all markdown links in the line
        echo "$line" | grep -oE '\[[^\]]*\]\([^)]+\)' | while read -r link; do
            # Extract the path part (between parentheses)
            path=$(echo "$link" | sed 's/.*(\([^)]*\)).*/\1/')

            # Skip external URLs (http, https, mailto, etc.)
            if [[ "$path" =~ ^https?:// ]] || [[ "$path" =~ ^mailto: ]] || [[ "$path" =~ ^ftp:// ]]; then
                continue
            fi

            # Remove anchor part (#section) for file existence check
            file_path=$(echo "$path" | cut -d'#' -f1)

            # Skip empty paths or just anchors
            if [[ -z "$file_path" ]] || [[ "$file_path" == "#"* ]]; then
                continue
            fi

            ((TOTAL_LINKS++))

            # Check if file exists
            if ! check_file_exists "$file_path" "$file"; then
                echo -e "  ${RED}✗ Broken link: $link${NC}"
            else
                echo -e "  ${GREEN}✓ Valid link: $path${NC}"
            fi
        done
    done < "$file"
}

# Check main documentation files
echo -e "\n${BLUE}📚 Checking main documentation...${NC}"
for doc_file in "$DOCS_DIR"/*.md; do
    if [[ -f "$doc_file" ]]; then
        check_markdown_links "$doc_file"
    fi
done

# Check template documentation
echo -e "\n${BLUE}📱 Checking template documentation...${NC}"
for template_dir in "$TEMPLATES_DIR"/*; do
    if [[ -d "$template_dir" ]]; then
        echo -e "${YELLOW}📁 Template: $(basename "$template_dir")${NC}"

        # Check main template files
        for file in "$template_dir"/*.md "$template_dir"/**/*.md; do
            if [[ -f "$file" ]]; then
                check_markdown_links "$file"
            fi
        done
    fi
done

# Check root documentation files
echo -e "\n${BLUE}📋 Checking root documentation...${NC}"
for root_file in README.md QUICKSTART.md ONBOARDING.md INSTRUCTIONS_INDEX.md; do
    if [[ -f "$root_file" ]]; then
        check_markdown_links "$root_file"
    fi
done

# Check playground documentation
echo -e "\n${BLUE}🎮 Checking playground documentation...${NC}"
for file in playground/**/*.md; do
    if [[ -f "$file" ]]; then
        check_markdown_links "$file"
    fi
done

# Report results
echo -e "\n${BLUE}📊 Link Check Results${NC}"
echo "===================="
echo -e "Total links checked: ${YELLOW}$TOTAL_LINKS${NC}"
echo -e "Broken links found: ${RED}$BROKEN_COUNT${NC}"

if [[ $BROKEN_COUNT -gt 0 ]]; then
    echo -e "\n${RED}🚨 Broken Links Found:${NC}"
    printf '%s\n' "${BROKEN_LINKS[@]}"

    echo -e "\n${YELLOW}💡 Recommendations:${NC}"
    echo "1. Update broken links to point to the correct SSOT files"
    echo "2. Check if referenced files have been moved or renamed"
    echo "3. Verify relative path calculations"
    echo "4. Consider using absolute paths from project root"

    exit 1
else
    echo -e "\n${GREEN}🎉 All links are valid!${NC}"
    echo "Documentation link integrity verified."
    exit 0
fi
