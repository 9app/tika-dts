# Template Snapshot & Selective Version Upgrade System

## 🎯 Tổng quan

Hệ thống template upgrade của Tika được thiết kế để hỗ trợ **selective version upgrade** - cho phép bạn upgrade lên bất kỳ version nào bạn muốn, không bắt buộc phải upgrade lên latest version.

## 📦 Template Snapshot Storage

### 1. Registry-Based Versioning

Mỗi template version được lưu trữ như một "snapshot" trong registry file:

```yaml
# templates/.templates-registry.yaml
templates:
  flutter-mise:
    versions:
      - version: "1.0.0"          # Snapshot 1.0.0
        flutter_sdk: "3.30.0"
        dart_sdk: "3.6.0"
        changes: [...]

      - version: "1.2.0"          # Snapshot 1.2.0
        flutter_sdk: "3.32.5"
        dart_sdk: "3.7.0"
        changes: [...]

      - version: "1.4.0"          # Snapshot 1.4.0
        flutter_sdk: "3.34.0"
        dart_sdk: "3.8.0"
        changes: [...]

      - version: "2.0.0"          # Latest snapshot
        flutter_sdk: "3.35.0"
        dart_sdk: "3.8.5"
        changes: [...]
```

### 2. Template Files Storage

Mỗi version có thể có các file template tương ứng:

```
templates/
├── flutter-mise/              # Current/Latest version
│   ├── mise.toml
│   └── README.md
├── flutter-mise-1.0.0/       # Version 1.0.0 snapshot (optional)
├── flutter-mise-1.2.0/       # Version 1.2.0 snapshot (optional)
└── flutter-mise-1.4.0/       # Version 1.4.0 snapshot (optional)
```

## 🎯 Selective Version Upgrade

### Scenario của bạn: 1.2.0 → 1.4.0

Giả sử:
- Latest template: **2.0.0**
- Repo hiện tại: **1.2.0**
- Bạn muốn upgrade lên: **1.4.0** (không phải latest)

### Cách thực hiện:

```bash
# 1. Kiểm tra version hiện tại
./tika.sh template-status

# Output:
# Template: flutter-mise
# Current version: 1.2.0
# Latest version: 2.0.0
# ⚠️ Upgrade available: 1.2.0 → 2.0.0

# 2. Xem tất cả versions có sẵn
./scripts/template-upgrade-git.sh check-upgrades

# Output:
# 📦 Available Upgrades:
# 🔄 1.2.0 → 1.3.0
# 🔄 1.2.0 → 1.4.0
# 🔄 1.2.0 → 2.0.0

# 3. Upgrade lên version 1.4.0 cụ thể
./tika.sh template-upgrade --version 1.4.0

# Hoặc với git integration
./scripts/template-upgrade-git.sh upgrade --version 1.4.0 --auto-branch
```

## 🔄 Upgrade Process cho Selective Version

### 1. Version Resolution

Khi bạn chỉ định `--version 1.4.0`, hệ thống sẽ:

```bash
# Tìm version 1.4.0 trong registry
target_version="1.4.0"
template_snapshot=$(grep -A 10 "version: \"1.4.0\"" templates/.templates-registry.yaml)

# Lấy thông tin version 1.4.0
flutter_sdk="3.34.0"
dart_sdk="3.8.0"
changes=[...]
```

### 2. Template Application

```bash
# Apply changes từ version 1.4.0 snapshot
print_info "Upgrading from 1.2.0 to 1.4.0..."

# Update mise.toml với versions từ 1.4.0
update_tool_version "flutter" "3.34.0"
update_tool_version "dart" "3.8.0"

# Apply template files nếu có
if [[ -d "templates/flutter-mise-1.4.0/" ]]; then
    cp templates/flutter-mise-1.4.0/mise.toml ./mise.toml.new
fi
```

### 3. Metadata Update

```yaml
# .template-metadata gets updated
template:
  version: "1.4.0"  # Changed from 1.2.0

upgrade_history:
  - from_version: "1.2.0"
    to_version: "1.4.0"      # Not latest, selective upgrade
    upgraded_at: "2025-07-03T10:30:00Z"
    changes_applied:
      - "Updated Flutter to 3.34.0"
      - "Updated Dart to 3.8.0"
      - "Added new development tasks"
```

## 📋 Supported Commands

### Check Available Versions

```bash
# Xem tất cả versions
./scripts/template-upgrade-git.sh check-upgrades

# Chi tiết version cụ thể
grep -A 20 "version: \"1.4.0\"" templates/.templates-registry.yaml
```

### Upgrade to Specific Version

```bash
# Basic upgrade
./tika.sh template-upgrade --version 1.4.0

# With git integration
./scripts/template-upgrade-git.sh upgrade --version 1.4.0 --auto-branch

# Dry run để xem changes
./scripts/template-upgrade-git.sh upgrade --version 1.4.0 --dry-run
```

### Validate Version Compatibility

```bash
# Check if version 1.4.0 is compatible
./scripts/template-upgrade-git.sh validate --version 1.4.0

# Check breaking changes
grep -A 5 "version: \"1.4.0\"" templates/.templates-registry.yaml | grep "breaking_changes"
```

## ⚠️ Version Skipping Considerations

### Breaking Changes Detection

```yaml
# Registry shows breaking changes
- version: "1.3.0"
  breaking_changes: true
  migration_guide: "docs/migrations/flutter-1.2-to-1.3.md"

- version: "1.4.0"
  breaking_changes: false  # Safe to skip to
```

### Skip Version Warnings

```bash
# Hệ thống sẽ cảnh báo nếu skip breaking changes
./tika.sh template-upgrade --version 1.4.0

# Output:
# ⚠️ Warning: Skipping version 1.3.0 which contains breaking changes
# ⚠️ Consider reviewing: docs/migrations/flutter-1.2-to-1.3.md
# Continue? (y/N)
```

## 🔍 Verification & Rollback

### Verify Upgrade

```bash
# Kiểm tra upgrade thành công
./tika.sh template-status

# Output:
# Template: flutter-mise
# Current version: 1.4.0 ✅
# Latest version: 2.0.0
# Status: Selectively upgraded (not latest)
```

### Rollback if Needed

```bash
# Git-based rollback
git checkout main
git branch -D template-upgrade-1.2.0-to-1.4.0-20250703

# Or specific version rollback
./scripts/template-upgrade-git.sh rollback --version 1.2.0
```

## 🎯 Why This Design Works

### 1. **Flexibility**
- Không bắt buộc upgrade lên latest
- Hỗ trợ selective version targeting
- Cho phép skip versions không cần thiết

### 2. **Safety**
- Warning khi skip breaking changes
- Git integration để easy rollback
- Dry-run để preview changes

### 3. **Traceability**
- Registry tracks tất cả versions
- Metadata shows upgrade path chosen
- History preserves selective decisions

### 4. **Compatibility**
- Version compatibility matrix
- Tool version requirements per snapshot
- Migration guides for complex changes

## 📚 Example Scenarios

### Scenario 1: Conservative Upgrade
```bash
# Current: 1.2.0, Latest: 2.0.0
# Want: Only minor updates (1.4.0)

./tika.sh template-upgrade --version 1.4.0
# ✅ Safe selective upgrade, no breaking changes
```

### Scenario 2: Skip Breaking Version
```bash
# Current: 1.1.0, Latest: 2.0.0
# Want: 1.4.0 (skip 1.3.0 with breaking changes)

./tika.sh template-upgrade --version 1.4.0
# ⚠️ Warning about skipped breaking changes in 1.3.0
# ✅ Upgrade to 1.4.0 after confirmation
```

### Scenario 3: Staged Upgrade Strategy
```bash
# Upgrade từng bước thay vì nhảy thẳng lên latest
./tika.sh template-upgrade --version 1.3.0  # Step 1
# Test, verify
./tika.sh template-upgrade --version 1.4.0  # Step 2
# Test, verify
./tika.sh template-upgrade --version 2.0.0  # Final step
```

## 🚀 Summary

**Trả lời câu hỏi của bạn:**

1. **Template Snapshots**: Được lưu trong `.templates-registry.yaml` với đầy đủ thông tin về mỗi version (tool versions, changes, breaking changes)

2. **Selective Upgrade**: Hỗ trợ hoàn toàn! Bạn có thể upgrade từ 1.2.0 lên 1.4.0 mà không cần lên 2.0.0

3. **Apply Update**: Sử dụng snapshot data từ registry để apply exact version bạn muốn, không phải latest

4. **Safety**: Cảnh báo về breaking changes bị skip, git integration để rollback

**Command để thực hiện:**
```bash
./tika.sh template-upgrade --version 1.4.0
```

Hệ thống được thiết kế để maximize flexibility và safety cho template management! 🎯
