---
description: Comprehensive workspace cleanup and optimization prompt for mobile development template system
---

# Workspace Clean-up and Optimization

Clean up and optimize the entire workspace by removing duplicate content, empty files, fixing broken paths, correcting non-functional scripts, and updating instructions/prompts throughout the workspace.

## 📋 Clean-up Progress Checklist

### 🔍 Phase 1: Analysis & Inspection
- [ ] **1.1** Scan all empty files in workspace (exclude node_modules, .git)
- [ ] **1.2** Find duplicate files by content (duplicate content detection)
- [ ] **1.3** Check invalid paths in all markdown files
- [ ] **1.4** Identify non-functional scripts or syntax errors
- [ ] **1.5** List all instruction files and prompt files needing review
- [ ] **1.6** Check references between files (broken links)

### 🗑️ Phase 2: Remove & Clean
- [ ] **2.1** Delete all empty files (0 bytes or whitespace only)
- [ ] **2.2** Remove unnecessary or old backup files
- [ ] **2.3** Remove duplicate content in instruction files
- [ ] **2.4** Delete unused template files or example files
- [ ] **2.5** Clean trailing whitespace in all text files
- [ ] **2.6** Remove unnecessary comments or old code

### 🔧 Phase 3: Fix & Update
- [ ] **3.1** Fix all incorrect paths in documentation
- [ ] **3.2** Update scripts with correct syntax and error handling
- [ ] **3.3** Fix broken links between markdown files
- [ ] **3.4** Update version numbers and old dependencies
- [ ] **3.5** Fix formatting inconsistencies in markdown files
- [ ] **3.6** Update file paths in scripts to match current structure

### 📝 Phase 4: Optimize Instructions & Prompts
- [ ] **4.1** Review and consolidate duplicate instruction files
- [ ] **4.2** Update AI terminal safety guidelines in all templates
- [ ] **4.3** Standardize format for all instruction files
- [ ] **4.4** Optimize prompt file content for clarity and effectiveness
- [ ] **4.5** Ensure consistency between Flutter and React Native instructions
- [ ] **4.6** Update project-specific guidelines to match current architecture

### 🏗️ Phase 5: Structure & Organization
- [ ] **5.1** Reorganize file structure for logical navigation
- [ ] **5.2** Create or update index files for each directory
- [ ] **5.3** Ensure consistent naming convention across all files
- [ ] **5.4** Create or update README files for each major directory
- [ ] **5.5** Organize templates by version and framework
- [ ] **5.6** Standardize directory structure between templates

### ✅ Phase 6: Verify & Validate
- [ ] **6.1** Test all scripts to ensure they work
- [ ] **6.2** Validate all links and references
- [ ] **6.3** Verify no empty or duplicate files remain
- [ ] **6.4** Review all documentation for accuracy
- [ ] **6.5** Test template creation scripts
- [ ] **6.6** Verify AI instructions work correctly in templates

## 🎯 Specific Clean-up Targets

### File Types to Clean:
```
📁 Target Directories:
├── .github/
│   ├── instructions/
│   ├── prompts/
│   └── workflows/
├── docs/
├── scripts/
├── templates/
│   ├── flutter-mise/
│   └── rn-expo-mise/
├── playground/
└── backups/
```

### Scripts to Check:
- [ ] `scripts/create-new-project.sh`
- [ ] `scripts/template-upgrade.sh`
- [ ] `scripts/setup.sh`
- [ ] `scripts/verify.sh`
- [ ] `scripts/build.sh`
- [ ] `playground/scripts/*.sh`

### Instruction Files to Optimize:
- [ ] `.github/instructions/ai-in-terminal.instructions.md`
- [ ] `templates/flutter-mise/.github/instructions/*.md`
- [ ] `templates/rn-expo-mise/.github/instructions/*.md`
- [ ] Template-specific copilot instructions

### Documentation Files to Review:
- [ ] Main README.md
- [ ] `docs/*.md`
- [ ] Template README files
- [ ] All index and navigation files

## 🔍 Detection Commands

### Find Empty Files:
```bash
find . -type f -name "*.md" -size 0
find . -type f -name "*.sh" -size 0
find . -type f \( -name "*.md" -o -name "*.sh" -o -name "*.json" \) -exec sh -c 'test $(wc -l < "$1") -eq 0' _ {} \; -print
```

### Find Duplicate Files:
```bash
find . -type f -name "*.md" -exec md5sum {} \; | sort | uniq -d -w 32
```

### Check Broken Links:
```bash
grep -r '\[.*\](' . --include="*.md" | grep -v "http" | grep -v "https"
```

### Find Trailing Whitespace:
```bash
grep -r " $" . --include="*.md" --include="*.sh"
```

## 📊 Progress Tracking

### Status Symbols:
- ✅ **Completed** - Task completed
- 🔄 **In Progress** - Currently working on
- ⏳ **Pending** - Waiting to execute
- ❌ **Failed** - Failed, needs review
- 🔍 **Review Needed** - Requires additional review

### Completion Metrics:
- **Phase 1:** ___/6 tasks completed
- **Phase 2:** ___/6 tasks completed  
- **Phase 3:** ___/6 tasks completed
- **Phase 4:** ___/6 tasks completed
- **Phase 5:** ___/6 tasks completed
- **Phase 6:** ___/6 tasks completed

**Overall Progress:** ___/36 tasks completed (___%)

## 🚨 Safety Guidelines

### Backup Strategy:
- [ ] Create backups before deleting files
- [ ] Use git to track all changes
- [ ] Test scripts in sandbox environment first

### Verification Steps:
- [ ] Check git status after each phase
- [ ] Test major functionality after cleanup
- [ ] Verify templates still create projects successfully

### Recovery Plan:
- [ ] Document all changes made
- [ ] Keep backup of original files
- [ ] Use git revert if rollback needed

## 📝 Implementation Notes

**Important Guidelines:** 
- Always backup before deleting
- Test scripts after fixing
- Verify links after updating paths
- Check templates work after cleanup

**Priority Order:**
1. Safety first - backup and verify
2. Remove empty/broken files
3. Fix critical scripts
4. Optimize instructions
5. Organize structure
6. Final validation

## 🎯 Expected Outcomes

After completing this cleanup:
- Zero empty or duplicate files
- All scripts functional with proper error handling
- Consistent documentation with valid links
- Optimized instruction files following best practices
- Clean, organized file structure
- Reliable template creation process

---

*Execute this prompt incrementally. Complete each phase before moving to the next. Update the checklist progress as you work through each task.*
