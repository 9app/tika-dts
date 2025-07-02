# 🔄 Template Upgrade Workflow - Complete Guide

## 📋 Overview

Template upgrade system có 2 phía chính:
1. **Template Maintainer** - Người tạo và publish template updates
2. **Developer** - Người sử dụng template và upgrade projects

## 🎯 Workflow Overview

```
Template Maintainer                    Developer
       │                                  │
   ┌───▼────┐                        ┌────▼────┐
   │Create  │                        │ Check   │
   │New     │                        │ Status  │
   │Version │                        │         │
   └───┬────┘                        └────┬────┘
       │                                  │
   ┌───▼────┐                        ┌────▼────┐
   │Update  │                        │ Check   │
   │Registry│                        │Upgrades │
   │        │                        │Available│
   └───┬────┘                        └────┬────┘
       │                                  │
   ┌───▼────┐                        ┌────▼────┐
   │Publish │                        │Perform  │
   │Changes │                        │Upgrade  │
   │        │                        └────┬────┘
   └────────┘                             │
                                     ┌────▼────┐
                                     │ Verify  │
                                     │Changes  │
                                     │Applied  │
                                     └─────────┘
```

## 👨‍💻 Template Maintainer Side

### 1. Tạo New Template Version

Template maintainer thực hiện các steps sau:

#### Step 1: Update Template Content
```bash
cd templates/flutter-mise

# Cập nhật template files
# Ví dụ: Update mise.toml với Flutter SDK mới
vim mise.toml

# Update VS Code settings
vim .vscode/settings.json

# Add new scripts hoặc tasks
vim mise.toml
```

#### Step 2: Update Registry với New Version
```bash
# Edit .templates-registry.yaml
vim templates/.templates-registry.yaml

# Add new version entry:
# - version: "1.3.0"
#   created: "2025-07-01T00:00:00Z"
#   description: "Flutter 3.32.0, new VS Code tasks"
#   breaking_changes: false
#   flutter_sdk: "3.32.0"
```

#### Step 3: Update current_version
```yaml
flutter-mise:
  current_version: "1.3.0"  # <- Update này
```

#### Step 4: Commit Changes
```bash
git add .
git commit -m "chore: release Flutter template v1.3.0

- Updated Flutter SDK to 3.32.0
- Added new development tasks
- Improved VS Code configuration"

git tag flutter-template-v1.3.0
git push origin main --tags
```

### 2. Testing Template Update

```bash
# Test with sample project
cd playground/apps/flutter_app

# Check if upgrade is detected
../../scripts/template-upgrade-native.sh check-upgrades

# Expected output:
# 🔄 Checking for Template Upgrades
# Current version: 1.2.0
# Latest version: 1.3.0
# ⬆️ Upgrade available: 1.2.0 → 1.3.0
```

## 👩‍💻 Developer Side

### 1. Check Current Status

```bash
cd my-flutter-project

# Check current template info
../../scripts/template-upgrade-native.sh status

# Output:
# 🔄 Template Status
# ℹ️  Project: my-flutter-project
# 📋 Current Configuration
# Template: flutter-mise
# Version: 1.2.0
# Workspace: 2024.1
# Created: 2025-07-01T03:48:17Z
```

### 2. Check for Available Upgrades

```bash
# Check what upgrades are available
../../scripts/template-upgrade-native.sh check-upgrades

# Output:
# 🔄 Checking for Template Upgrades
# Current version: 1.2.0
# Latest version: 1.3.0
# ⬆️ Upgrade available: 1.2.0 → 1.3.0
#
# Changes in 1.3.0:
# - Flutter 3.32.0, new VS Code tasks
# - Breaking changes: No
```

### 3. Perform Upgrade

```bash
# Perform actual upgrade
../../scripts/template-upgrade-native.sh upgrade --latest

# This will:
# 1. Create backup
# 2. Download/apply template changes
# 3. Update project files
# 4. Update .template-metadata
# 5. Show summary of changes
```

## 🔧 What Actually Gets Updated?

Khi upgrade, những files sau được update:

### Template-Managed Files
- `mise.toml` - Tool versions, tasks
- `.vscode/settings.json` - VS Code configuration
- `.vscode/tasks.json` - VS Code tasks
- `.vscode/launch.json` - Debug configuration
- `android/app/build.gradle` - Android build configuration
- `ios/Runner.xcodeproj/project.pbxproj` - iOS project configuration

### User Files (NOT Updated)
- `lib/**` - Your app code
- `assets/**` - Your assets
- `test/**` - Your tests
- Custom configurations you added

## 📂 Backup System

### Backup Directory Structure
```
backups/
├── project_myapp_20250701_120000/
│   ├── mise.toml
│   ├── .vscode/
│   ├── android/
│   └── .template-metadata
└── project_myapp_20250701_130000/
    ├── mise.toml
    └── ...
```

### Backup Usage
- **Automatic**: Created before every upgrade
- **Retention**: Kept for rollback purposes
- **Cleanup**: Can be cleaned up manually or via script
- **Rollback**: Use to restore previous state

## 🚀 Demo Example

Hãy tạo một demo complete workflow:

### Template Maintainer Creates v1.3.0

1. **Update Flutter template**
2. **Add new mise task**
3. **Update registry**
4. **Commit & publish**

### Developer Upgrades Project

1. **Check current status** (v1.2.0)
2. **Detect available upgrade** (v1.3.0)
3. **Perform upgrade**
4. **Verify changes applied**
5. **Test new functionality**

## 📊 File Change Tracking

Upgrade system tracks:

```yaml
# In .template-metadata
customizations:
  modified_files:
    - "mise.toml"           # User modified tool versions
    - "android/app/build.gradle"  # Custom Android config

  custom_tasks:
    - "my:custom:task"      # User added tasks

  custom_env:
    - "CUSTOM_VAR=value"    # User environment vars

upgrade_history:
  - from_version: "1.2.0"
    to_version: "1.3.0"
    upgraded_at: "2025-07-01T12:00:00Z"
    changes_applied:
      - "Updated mise.toml Flutter SDK"
      - "Added new VS Code tasks"
      - "Updated Android Gradle configuration"
    conflicts_resolved:
      - "Merged custom tool versions in mise.toml"
```

## ⚠️ Conflict Resolution

Khi có conflicts (user đã modify template files):

### Interactive Mode
```bash
../../scripts/template-upgrade-native.sh upgrade --latest --interactive

# Prompts:
# ⚠️ Conflict detected in mise.toml
# Template version: [Flutter 3.32.0]
# Your version:     [Flutter 3.30.0 + custom tasks]
#
# Choose resolution:
# 1) Keep template version (lose custom changes)
# 2) Keep your version (miss template updates)
# 3) Manual merge (recommended)
# 4) Skip this file
#
# Choice [3]:
```

### Manual Merge
```bash
# System creates backup and shows diff
diff mise.toml.backup mise.toml.new

# You manually edit final version
vim mise.toml

# Confirm changes
../../scripts/template-upgrade-native.sh upgrade --continue
```

## 🎯 Next Steps

Để demo complete workflow, tôi sẽ:

1. **Create example template update** (v1.3.0)
2. **Demo maintainer workflow**
3. **Demo developer upgrade process**
4. **Show actual file changes**
5. **Demo rollback process**

Would you like me to proceed with the demo?
