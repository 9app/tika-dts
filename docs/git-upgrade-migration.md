# Migration to Git-Integrated Template Upgrades

This document guides you through migrating from the backup-based template upgrade system to the new git-integrated approach.

## 🎯 Benefits of Git-Integrated Upgrades

### Before (Backup-Based)
- Created backup directories for rollback
- Required manual cleanup of backup folders
- No version control integration
- Rollback was file copy operation
- Backup directories could accumulate over time

### After (Git-Integrated)
- Uses git branches and commits for upgrades
- Automatic rollback using git reset
- Full version control integration
- Clean working directory
- No backup directories needed

## 🔄 Migration Steps

### 1. For Existing Projects

If you have a project using the old backup-based system:

```bash
# Check current template status
./scripts/template-upgrade-git.sh status

# If you have existing backups, you can clean them up
rm -rf .template-backups/

# The git-integrated script will work with existing .template-metadata
```

### 2. Clean Up Old Backup Directories

```bash
# Remove any existing backup directories
find . -name ".template-backups" -type d -exec rm -rf {} +
find . -name "backups" -type d -exec rm -rf {} +
```

### 3. Update Your Workflow

#### Old Commands (Deprecated)
```bash
# OLD - Don't use these anymore
./scripts/template-upgrade-native.sh status
./scripts/template-upgrade-native.sh upgrade
./scripts/template-upgrade-native.sh rollback
```

#### New Commands (Git-Integrated)
```bash
# NEW - Use these instead
./scripts/template-upgrade-git.sh status
./scripts/template-upgrade-git.sh upgrade
./scripts/template-upgrade-git.sh rollback
```

#### Main Script Interface
```bash
# Main tika.sh interface (recommended)
./tika.sh template-status
./tika.sh template-upgrade
./tika.sh template-rollback
```

#### Mise Tasks (From Project Directory)
```bash
# Using mise tasks
mise run template:status
mise run template:upgrade
mise run template:rollback
```

## 🚀 New Features

### 1. Git Branch-Based Upgrades
```bash
# Upgrade creates a dedicated branch
./tika.sh template-upgrade --latest

# This creates: template-upgrade-flutter-1.3.0-20241201-143022
# Switches to that branch
# Applies changes
# Commits with descriptive message
```

### 2. Dry Run with Git Preview
```bash
# See what changes would be made
./tika.sh template-upgrade --dry-run

# Shows git diff of proposed changes
# No commits or branches created
```

### 3. Git-Based Rollback
```bash
# Simple git reset to previous state
./tika.sh template-rollback

# No file copying needed
# Instant rollback
# Preserves git history
```

### 4. Better Conflict Resolution
```bash
# If conflicts occur during upgrade
git status                    # See conflicted files
git diff                      # Review conflicts
# Edit files to resolve conflicts
git add .
git commit -m "Resolve conflicts"
```

## ⚙️ Configuration Updates

### 1. Mise Tasks Updated
All mise tasks now use the git-integrated script:

```toml
[tasks."template:upgrade"]
description = "Upgrade project to latest template version"
run = "./scripts/template-upgrade-git.sh upgrade --latest"

[tasks."template:rollback"]
description = "Rollback to previous template version"
run = "./scripts/template-upgrade-git.sh rollback"
```

### 2. Main Script Integration
The `tika.sh` script now includes template commands:

```bash
./tika.sh template-status      # Check status
./tika.sh template-check       # Check for upgrades
./tika.sh template-upgrade     # Upgrade template
./tika.sh template-rollback    # Rollback template
./tika.sh template-releases    # List releases
```

## 🔍 Verification

### 1. Test the Migration
```bash
# 1. Check current status
./tika.sh template-status

# 2. Check for upgrades
./tika.sh template-check

# 3. Try a dry run
./tika.sh template-upgrade --dry-run

# 4. Verify git integration
git status
git log --oneline -5
```

### 2. Validate Git Integration
```bash
# Should show clean working directory
git status

# Should show your project in a git repository
git remote -v

# Should work without errors
./tika.sh template-status
```

## 🛠 Troubleshooting

### Issue: "Not a git repository"
```bash
# Initialize git if needed
git init
git add .
git commit -m "Initial commit"
```

### Issue: "Uncommitted changes"
```bash
# Commit your changes first
git add .
git commit -m "Work in progress"

# Then run upgrade
./tika.sh template-upgrade
```

### Issue: "Template metadata not found"
```bash
# Initialize template metadata
./scripts/template-upgrade-git.sh init .
```

## 📚 Documentation Updates

All documentation has been updated to reflect the git-integrated approach:

- [`template-upgrade-quickstart.md`](template-upgrade-quickstart.md) - Updated quickstart guide
- [`template-upgrade-comparison.md`](template-upgrade-comparison.md) - Script comparison
- [`git-integrated-template-upgrade.md`](git-integrated-template-upgrade.md) - Detailed git integration guide
- [`README.md`](../README.md) - Updated main documentation
- [`ONBOARDING.md`](../ONBOARDING.md) - Updated onboarding checklist

## ✅ Post-Migration Checklist

- [ ] Old backup directories removed
- [ ] Git repository initialized and clean
- [ ] Template status command works: `./tika.sh template-status`
- [ ] Upgrade dry-run works: `./tika.sh template-upgrade --dry-run`
- [ ] Mise tasks updated: `mise run template:status`
- [ ] Team members informed of new workflow
- [ ] Documentation reviewed and understood
- [ ] CI/CD updated if using template upgrades

## 🎉 Benefits Realized

After migration, you'll enjoy:
- ✅ **Cleaner git history** - All template changes in dedicated commits
- ✅ **Instant rollbacks** - No file copying, just git reset
- ✅ **Better conflict resolution** - Use standard git merge tools
- ✅ **No backup directories** - Git handles all versioning
- ✅ **Integrated workflow** - Template upgrades part of normal git workflow
- ✅ **Zero dependencies** - No external tools required

---

**The git-integrated template upgrade system provides a more robust, maintainable, and developer-friendly approach to template management.** 🚀
