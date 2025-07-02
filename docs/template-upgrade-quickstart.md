# Template Upgrade System - Quick Start Guide

> **🎯 Git-Integrated Approach** - Works with any git repository, zero dependencies

## 🚨 Migration Notice

**The template upgrade system has been migrated to a git-integrated approach.** The old backup-based system is deprecated.

- ✅ **New (Recommended)**: `template-upgrade-git.sh` - Git-integrated, zero backup directories
- ⚠️ **Deprecated**: `template-upgrade-native.sh` - Backup-based, legacy approach

**Migration guide**: [`git-upgrade-migration.md`](git-upgrade-migration.md)

## 🚀 Instant Start (Git-Integrated)

### Check Current Status
```bash
# Main interface (recommended)
./tika.sh template-status

# Direct script
./scripts/template-upgrade-git.sh status

# Through mise from project directory
mise run template:status
```

### Check for Available Upgrades
```bash
# Check what upgrades are available
./tika.sh template-check

# Direct script
./scripts/template-upgrade-git.sh check-upgrades

# Through mise
mise run template:check
```

### Apply Latest Upgrades
```bash
# Upgrade to latest versions (creates git commit)
./tika.sh template-upgrade

# With dry-run preview
./tika.sh template-upgrade --dry-run

# Direct script
./scripts/template-upgrade-git.sh upgrade --latest

# Through mise
mise run template:upgrade
```

## 📋 Common Workflows

### Daily Template Management
```bash
# 1. Check if templates need updates
./tika.sh template-status

# 2. Preview available upgrades
./tika.sh template-check

# 3. Apply upgrades if needed (creates git commit automatically)
./tika.sh template-upgrade
```

### Git Integration Workflow (Automatic)
```bash
# The git-integrated system handles git operations automatically:

# 1. Check current state
./tika.sh template-status

# 2. Preview changes (no git operations)
./tika.sh template-upgrade --dry-run

# 3. Apply upgrade (auto-creates branch + commit)
./tika.sh template-upgrade

# 4. If needed, rollback using git
./tika.sh template-rollback
```

### Manual Git Integration
```bash
# If you prefer manual git control:

# Create your own feature branch
git checkout -b feature/template-upgrade-$(date +%Y%m%d)

# Apply upgrades without auto-commit
./scripts/template-upgrade-git.sh upgrade --latest --no-commit

# Review and commit manually
git diff --name-only
git add .
git commit -m "feat: upgrade templates to latest versions"
```

# Push and create PR
git push origin feature/template-upgrade-$(date +%Y%m%d)
```

### Interactive Upgrade Session
```bash
# Start interactive upgrade process
./scripts/template-upgrade-native.sh interactive

# Or for specific template
./scripts/template-upgrade-native.sh upgrade flutter-mise --version 1.3.0
./scripts/template-upgrade-native.sh upgrade rn-expo-mise --version 2.1.0
```

## 🔧 Advanced Usage

### Selective Template Upgrades
```bash
# List available templates
./scripts/template-upgrade-native.sh list

# Upgrade specific template
./scripts/template-upgrade-native.sh upgrade flutter-mise --latest
./scripts/template-upgrade-native.sh upgrade rn-expo-mise --version 2.0.5
```

### Backup and Recovery
```bash
# Create backup before major upgrades
./scripts/template-upgrade-native.sh backup

# Restore from backup if needed
./scripts/template-upgrade-native.sh restore --backup-id 20250701_143022
```

### Development and Testing
```bash
# Test upgrade in playground environment
cd playground/
../scripts/template-upgrade-native.sh upgrade --dry-run

# Validate template after upgrade
../scripts/verify.sh flutter-mise
../scripts/verify.sh rn-expo-mise
```

## 🏆 Why Zero Dependencies?

### ✅ Benefits
- **Instant Ready**: Works immediately on any bash environment
- **Universal Compatibility**: No platform-specific installations
- **Zero Maintenance**: No dependency version conflicts
- **Team Friendly**: Everyone can use without setup
- **CI/CD Ready**: No additional setup steps required

### ❌ What We Avoid
- External tool installations (yq, jq, etc.)
- Platform-specific setup steps
- Version compatibility issues
- Team onboarding friction
- CI/CD environment complexity

## 🛠 Troubleshooting

### Common Issues

**Template not found:**
```bash
# Refresh template registry
./scripts/template-upgrade-native.sh refresh

# Verify template exists
./scripts/template-upgrade-native.sh list
```

**Git conflicts during upgrade:**
```bash
# Reset to clean state
git stash
./scripts/template-upgrade-native.sh upgrade --latest
git stash pop  # Resolve conflicts manually
```

**Verification failures:**
```bash
# Check template integrity
./scripts/template-upgrade-native.sh validate flutter-mise
./scripts/template-upgrade-native.sh validate rn-expo-mise

# Full system check
mise run template:validate
```

### Advanced Troubleshooting

**For complex scenarios requiring advanced tools:**
```bash
# Use full-featured script (requires yq/jq installation)
./scripts/template-upgrade.sh advanced-command

# But prefer native approach for 95% of use cases
./scripts/template-upgrade-native.sh equivalent-command
```

## 📖 Related Documentation

- **[Template Upgrade System Overview](./template-upgrade-system.md)** - Complete technical details
- **[Template Upgrade Comparison](./template-upgrade-comparison.md)** - Native vs Advanced approaches
- **[Zero Dependencies Migration Guide](./zero-dependencies-migration.md)** - Migration from old system
- **[Template Architecture](./template-architecture.md)** - Understanding template structure

## 🎯 Quick Reference

| Task | Command | Description |
|------|---------|-------------|
| Status Check | `mise run template:upgrade:status` | Current template versions |
| Check Upgrades | `mise run template:upgrade:check` | Available upgrades |
| Apply Latest | `mise run template:upgrade:latest` | Upgrade to latest versions |
| List Templates | `./scripts/template-upgrade-native.sh list` | Available templates |
| Backup | `./scripts/template-upgrade-native.sh backup` | Create backup |
| Validate | `mise run template:validate` | Verify template integrity |

---

> **💡 Pro Tip**: Start with `mise run template:upgrade:status` to understand your current state, then use `mise run template:upgrade:latest` for most upgrade scenarios. The native script handles 95% of use cases without any external dependencies.
