#!/bin/bash

# Convert deprecated documentation files to stubs
# This script follows SSOT documentation architecture

set -e

# Colors for outpu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Converting deprecated documentation files to stubs...${NC}"

# Function to create stub conten
create_stub() {
    local file="$1"
    local title="$2"
    local ssot_reference="$3"
    local description="$4"

    cat > "$file" << 'EOF'
# ⚠️ DEPRECATED - TITLE_PLACEHOLDER

**This file has been moved to maintain Single Source of Truth (SSOT) documentation.**

## 🎯 New Location

**DESCRIPTION_PLACEHOLDER:**

➡️ **SSOT_REFERENCE_PLACEHOLDER** - Complete reference and documentation

## 🔄 What Changed

- **Before**: Information scattered across multiple files
- **After**: Single authoritative source for all information
- **Benefit**: No duplicate or conflicting documentation

## 📚 Complete Documentation System

For the complete documentation system, see:
- **[Documentation Index](./INDEX.md)** - Master navigation and maintenance guide
- **[CLI Commands](./CLI.md)** - All CLI commands and usage patterns
- **[Workflows](./WORKFLOWS.md)** - Development processes and procedures
- **[Reference](./REFERENCE.md)** - Technologies, versions, and architecture
- **[Troubleshooting](./TROUBLESHOOTING.md)** - Problem solutions and diagnostics

---

**⚠️ This stub will be removed in the next cleanup cycle. Please update any bookmarks or references to point to the new location.**
EOF

    # Replace placeholders
    sed -i '' "s/TITLE_PLACEHOLDER/$title/g" "$file"
    sed -i '' "s|SSOT_REFERENCE_PLACEHOLDER|$ssot_reference|g" "$file"
    sed -i '' "s/DESCRIPTION_PLACEHOLDER/$description/g" "$file"

    echo -e "${GREEN}✓ Created stub: $file${NC}"
}

# Template upgrade files → WORKFLOWS.md
create_stub "docs/template-upgrade-quickstart.md"
    "Template Upgrade Quickstart"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#template-management-workflows)"
    "All template upgrade processes are now consolidated in"

create_stub "docs/template-upgrade-system.md"
    "Template Upgrade System"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#template-management-workflows)"
    "All template upgrade system documentation is now in"

create_stub "docs/template-upgrade-comparison.md"
    "Template Upgrade Comparison"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#template-management-workflows)"
    "All template upgrade comparisons and strategies are now in"

create_stub "docs/template-upgrade-workflow-demo.md"
    "Template Upgrade Workflow Demo"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#template-management-workflows)"
    "All template upgrade workflow demonstrations are now in"

# Zero dependencies files → WORKFLOWS.md
create_stub "docs/zero-dependencies-migration.md"
    "Zero Dependencies Migration"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#setup-workflows)"
    "All migration processes and zero-dependency setup are now in"

create_stub "docs/zero-dependencies-complete.md"
    "Zero Dependencies Complete"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#setup-workflows)"
    "All zero-dependency implementation details are now in"

# Git integration files → WORKFLOWS.md
create_stub "docs/git-integrated-template-upgrade.md"
    "Git Integrated Template Upgrade"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#template-management-workflows)"
    "All git-integrated template upgrade workflows are now in"

create_stub "docs/git-upgrade-migration.md"
    "Git Upgrade Migration"
    "[docs/WORKFLOWS.md](./WORKFLOWS.md#template-management-workflows)"
    "All git upgrade migration processes are now in"

# VSCode configuration → REFERENCE.md
if [ -f "docs/vscode-configuration.md" ]; then
    create_stub "docs/vscode-configuration.md"
        "VSCode Configuration"
        "[docs/REFERENCE.md](./REFERENCE.md#development-tools--environment)"
        "All VSCode and development tool configurations are now in"
fi

echo -e "${GREEN}🎉 Successfully converted all deprecated files to stubs${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Review generated stubs for accuracy"
echo "2. Update any remaining links to point to SSOT files"
echo "3. Run link checker: ./scripts/check-docs-links.sh"
echo "4. Commit changes and schedule stub removal"
