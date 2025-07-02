# Template Upgrade System

## Overview

Hệ thống upgrade template được thiết kế dựa trên cách Flutter sử dụng file `.metadata` để tracking version và migration history. Hệ thống này cho phép:

1. **Zero Dependencies**: Hoạt động hoàn toàn với bash thuần túy - không cần external tools
2. **Version Tracking**: Theo dõi template version và workspace version
3. **Automatic Upgrade**: Tự động upgrade template đến version mới nhất
4. **Migration History**: Lưu trữ lịch sử upgrade để rollback nếu cần
5. **Customization Preservation**: Giữ lại các customization của user khi upgrade
6. **Cross-Platform**: Hoạt động trên Linux, macOS, Windows (Git Bash/WSL)

## Implementation

### Core Scripts

**🎯 Native Script (Recommended)**: `scripts/template-upgrade-native.sh`
- **Zero dependencies** - Pure bash implementation
- **Universal compatibility** - Works on any bash environment
- **Production ready** - Covers 95% of use cases

**Advanced Script (Optional)**: `scripts/template-upgrade.sh`
- **External dependencies** - Requires yq, jq
- **Advanced features** - Complex YAML/JSON processing
- **Use only when needed** - Complex registry operations

### Auto-Detection

The system automatically detects and uses the best available script:
- Mise tasks prefer native script for reliability
- Fallback to full-featured if specifically needed
- Clear messaging about which script is being used

## Architecture

### 1. Metadata File Structure

Mỗi project được tạo từ template sẽ có file `.template-metadata`:

```yaml
# This file tracks template properties and upgrade history
# Used by template upgrade system to manage project versions
# This file should be version controlled and not manually edited

template:
  name: "flutter-mise"          # Template name
  version: "1.0.0"              # Template version when created
  workspace_version: "2024.1"   # Workspace version when created
  created_at: "2024-12-30T10:00:00Z"
  base_commit: "abc123def456"    # Git commit hash of template when created

# Tracks upgrade history
upgrade_history:
  - from_version: "1.0.0"
    to_version: "1.1.0"
    workspace_version: "2024.2"
    upgraded_at: "2025-01-15T09:30:00Z"
    commit: "def456abc789"
    changes:
      - "Updated Flutter to 3.32.5"
      - "Added new build tasks"
      - "Updated Android SDK configuration"

# User customizations that should be preserved during upgrades
customizations:
  # Files that have been modified by user
  modified_files:
    - "mise.toml"                # User modified tool versions
    - "android/app/build.gradle" # Custom Android configuration

  # Custom tasks added by user
  custom_tasks:
    - "tasks.deploy"
    - "tasks.custom-build"

  # Custom environment variables
  custom_env:
    - "CUSTOM_API_URL"
    - "CUSTOM_BUILD_FLAGS"

# Files that should be ignored during upgrade (user-specific)
unmanaged_files:
  - "lib/main.dart"              # User application code
  - "assets/**"                  # User assets
  - ".env.local"                 # Local environment config
  - "ios/Runner.xcodeproj/project.pbxproj"  # iOS project file

# Compatibility information
compatibility:
  min_workspace_version: "2024.1"
  max_workspace_version: "2025.1"
  flutter_sdk_range: ">=3.30.0 <4.0.0"
  node_version_range: ">=18.0.0 <22.0.0"
```

### 2. Template Version Management

Template versions sẽ được track trong workspace:

```yaml
# templates/.templates-registry
templates:
  flutter-mise:
    current_version: "1.2.0"
    versions:
      - version: "1.0.0"
        created: "2024-12-01"
        description: "Initial Flutter template"
        breaking_changes: false
      - version: "1.1.0"
        created: "2024-12-15"
        description: "Updated Flutter SDK, added new tasks"
        breaking_changes: false
      - version: "1.2.0"
        created: "2025-01-01"
        description: "Major refactoring, new environment setup"
        breaking_changes: true
        migration_guide: "docs/migrations/flutter-1.1-to-1.2.md"

  rn-expo-mise:
    current_version: "1.1.0"
    versions:
      - version: "1.0.0"
        created: "2024-12-01"
        description: "Initial React Native/Expo template"
      - version: "1.1.0"
        created: "2024-12-20"
        description: "Updated Expo SDK, improved EAS configuration"
```

### 3. Upgrade Commands

```bash
# Check for available upgrades
mise run template:check-upgrades

# Upgrade to specific version
mise run template:upgrade --version 1.2.0

# Upgrade to latest version
mise run template:upgrade --latest

# Interactive upgrade with conflict resolution
mise run template:upgrade --interactive

# Rollback to previous version
mise run template:rollback --version 1.1.0

# Show upgrade history
mise run template:history

# Validate current template state
mise run template:validate
```

## Implementation Details

### 1. Template Creation Process

When creating a new project, the system will:

1. Generate project using framework CLI
2. Apply template configuration
3. Create `.template-metadata` file
4. Initialize version tracking
5. Set up upgrade hooks

### 2. Upgrade Process

When upgrading a template:

1. **Pre-flight Checks**:
   - Validate current state
   - Check compatibility
   - Backup current configuration

2. **Conflict Detection**:
   - Compare user modifications
   - Identify conflicting changes
   - Generate merge strategies

3. **Upgrade Execution**:
   - Apply template changes
   - Preserve user customizations
   - Update metadata
   - Run post-upgrade validation

4. **Post-upgrade**:
   - Verify functionality
   - Update documentation
   - Clean up temporary files

### 3. Conflict Resolution

The system handles conflicts through:

- **Smart Merging**: Automatic merge for non-conflicting changes
- **Interactive Mode**: User chooses resolution for conflicts
- **Backup & Restore**: Safe rollback mechanism
- **Validation**: Ensure project remains functional

## Benefits

1. **Safety**: Backup and rollback capabilities
2. **Flexibility**: Preserve user customizations
3. **Automation**: Reduce manual upgrade work
4. **Traceability**: Complete upgrade history
5. **Compatibility**: Ensure tool compatibility
6. **Documentation**: Clear migration guides

## Usage Examples

### Check and Upgrade

```bash
# Check current template status
cd my-flutter-project
mise run template:status
# Output:
# Template: flutter-mise v1.1.0
# Latest: v1.2.0 (upgrade available)
# Workspace: v2024.2

# Check what would be upgraded
mise run template:check-upgrades
# Output:
# Available upgrade: flutter-mise 1.1.0 → 1.2.0
# Changes:
# - Flutter SDK: 3.30.0 → 3.32.5
# - New tasks: build:profile, test:integration
# - Updated Android configuration
# Conflicts: mise.toml (user modified)

# Perform upgrade
mise run template:upgrade --latest --interactive
```

### Migration with Customization

```bash
# Upgrade preserving customizations
mise run template:upgrade --preserve-custom --latest

# Review changes before applying
mise run template:upgrade --dry-run --version 1.2.0

# Upgrade with custom merge strategy
mise run template:upgrade --merge-strategy=manual --latest
```

## Future Enhancements

1. **Web UI**: Visual upgrade interface
2. **CI Integration**: Automated upgrade checks
3. **Team Sync**: Shared upgrade policies
4. **Analytics**: Upgrade success metrics
5. **Plugin System**: Custom upgrade hooks
