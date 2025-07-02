# 🚨 DEPRECATION NOTICE: Backup-Based Template Upgrades

## ⚠️ Important Migration Required

The backup-based template upgrade system has been **deprecated** and replaced with a git-integrated approach.

### What's Deprecated

- ❌ `scripts/template-upgrade-native.sh` (backup-based)
- ❌ Backup directories (`.template-backups/`, `backups/`)
- ❌ File copy-based rollback system
- ❌ Manual backup directory cleanup

### What's New

- ✅ `scripts/template-upgrade-git.sh` (git-integrated)
- ✅ Git branch and commit-based upgrades
- ✅ Git-based rollback (`git reset`)
- ✅ No backup directories needed
- ✅ Integrated with `tika.sh` main interface

## 🔄 Migration Timeline

- **Now**: New git-integrated system available
- **Immediate**: Old system shows deprecation warnings
- **Next release**: Old system will be removed

## 📖 How to Migrate

### 1. **Use the Migration Guide**
Follow [`docs/git-upgrade-migration.md`](git-upgrade-migration.md) for complete migration steps.

### 2. **Update Your Commands**

**Before (Deprecated)**:
```bash
./scripts/template-upgrade-native.sh status
./scripts/template-upgrade-native.sh upgrade
./scripts/template-upgrade-native.sh rollback
```

**After (Current)**:
```bash
./tika.sh template-status
./tika.sh template-upgrade
./tika.sh template-rollback
```

**Or use direct script**:
```bash
./scripts/template-upgrade-git.sh status
./scripts/template-upgrade-git.sh upgrade
./scripts/template-upgrade-git.sh rollback
```

### 3. **Clean Up Old Backups**
```bash
# Remove backup directories (no longer needed)
rm -rf .template-backups/
rm -rf backups/
```

### 4. **Update Mise Tasks**
All mise tasks have been updated to use the git-integrated approach:
```bash
mise run template:status     # Uses git-integrated script
mise run template:upgrade    # Uses git-integrated script
mise run template:rollback   # Uses git-integrated script
```

## 🎯 Benefits of Migration

| Aspect | Old (Deprecated) | New (Git-Integrated) |
|--------|------------------|---------------------|
| **Rollback** | File copy from backup | `git reset` |
| **Storage** | Backup directories | Git history |
| **Cleanup** | Manual backup removal | Automatic git cleanup |
| **Integration** | Separate from git | Part of git workflow |
| **Conflict Resolution** | Manual file editing | Standard git merge tools |
| **History** | Custom tracking | Git commit history |

## 🚨 Action Required

### For Project Maintainers
- [ ] Update CI/CD scripts to use new commands
- [ ] Update documentation with new command references
- [ ] Inform team members about the migration
- [ ] Remove references to backup directories

### For Developers
- [ ] Read migration guide: [`git-upgrade-migration.md`](git-upgrade-migration.md)
- [ ] Update local workflows to use new commands
- [ ] Clean up any existing backup directories
- [ ] Test new git-integrated upgrade process

### For Documentation
- [ ] Update any scripts or documentation referencing old commands
- [ ] Remove references to backup-based rollback
- [ ] Update training materials and onboarding guides

## 📞 Support

If you encounter issues during migration:

1. **Read the migration guide**: [`docs/git-upgrade-migration.md`](git-upgrade-migration.md)
2. **Check git setup**: Ensure your project is in a git repository
3. **Test basic commands**: `./tika.sh template-status`
4. **Review git integration guide**: [`docs/git-integrated-template-upgrade.md`](git-integrated-template-upgrade.md)

## 🎉 Future Benefits

After migration, you'll enjoy:
- **Cleaner workspace** - No backup directories cluttering your project
- **Better version control** - Template changes integrated with your git history
- **Faster rollbacks** - Instant git operations instead of file copying
- **Standard workflows** - Uses familiar git commands and concepts
- **Better conflict resolution** - Use your preferred git merge tools

---

**Start your migration today!** The git-integrated approach provides a more robust and maintainable template upgrade experience. 🚀
