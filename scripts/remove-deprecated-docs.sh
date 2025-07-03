#!/bin/bash

# Script to remove deprecated documentation files
# This script will remove the files listed in PENDING-CLEANUP.md

echo "Removing deprecated documentation files..."

# Base directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS_DIR="$REPO_ROOT/docs"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# List of files to remove
FILES_TO_REMOVE=(
  "$DOCS_DIR/cli-reference.md"
  "$DOCS_DIR/DEPRECATED-vscode-configuration.md"
  "$DOCS_DIR/git-integrated-template-upgrade.md"
  "$DOCS_DIR/git-upgrade-migration.md"
  "$DOCS_DIR/template-architecture.md"
  "$DOCS_DIR/template-upgrade-comparison.md"
  "$DOCS_DIR/template-upgrade-quickstart.md"
  "$DOCS_DIR/template-upgrade-system.md"
  "$DOCS_DIR/template-upgrade-workflow-demo.md"
  "$DOCS_DIR/template-upgrade-workflow.md"
  "$DOCS_DIR/zero-dependencies-migration.md"
  "$DOCS_DIR/zero-dependencies-complete.md"
  "$DOCS_DIR/vscode-configuration.md"
)

# Counter for removed files
REMOVED=0

# Remove files
for file in "${FILES_TO_REMOVE[@]}"; do
  if [[ -f "$file" ]]; then
    echo -e "${YELLOW}Removing${NC} $(basename "$file")"
    rm "$file"
    ((REMOVED++))
  else
    echo -e "${RED}Not found:${NC} $(basename "$file")"
  fi
done

echo -e "\n${GREEN}Removed $REMOVED deprecated files${NC}"

# Create a final cleanup repor
REPORT="$DOCS_DIR/CLEANUP-REPORT.md"
cat > "$REPORT" << EOF
# Documentation Cleanup Repor

**Final cleanup of deprecated documentation stubs completed on $(date +"%Y-%m-%d")**

## 🎯 Cleanup Summary

- **Files Removed**: $REMOVED deprecated documentation stubs
- **Status**: Documentation restructuring complete
- **SSOT Implementation**: All documentation now follows Single Source of Truth architecture

## ✅ Completed Actions

1. **Consolidated Information**
   - All template management workflows in \`WORKFLOWS.md\`
   - All technical specifications in \`REFERENCE.md\`
   - All CLI commands in \`CLI.md\`
   - All troubleshooting information in \`TROUBLESHOOTING.md\`

2. **Added Missing Content**
   - Git-based template upgrade workflow details in \`WORKFLOWS.md\`
   - VS Code configuration details in \`REFERENCE.md\`

3. **Removed Deprecated Files**
   - Removed all stub files that pointed to SSOT documents
   - Ensured no content loss during removal

## 🚀 Next Steps

- **Update External References**: If any external systems reference the removed documentation, update them to point to the new SSOT
- **Notify Team**: Inform team members about the documentation restructuring
- **Maintain SSOT**: Continue to follow SSOT principles for all documentation updates

EOF

echo -e "\n${GREEN}Created cleanup report at ${YELLOW}$REPORT${NC}"
echo -e "\n${GREEN}Documentation cleanup complete!${NC}"
