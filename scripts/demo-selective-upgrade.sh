#!/bin/bash

# Demo script: Template Selective Version Upgrade
# Demonstrates upgrading to a specific version instead of latest

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Main demo function
demo_selective_upgrade() {
    print_header "Template Selective Version Upgrade Demo"
    echo
    
    print_info "Scenario: Upgrade từ version 1.2.0 lên 1.4.0 (bỏ qua latest 2.0.0)"
    echo
    
    # 1. Show current status
    print_header "Step 1: Kiểm tra template status hiện tại"
    echo
    
    echo "$ ./tika.sh template-status"
    echo "Template: flutter-mise"
    echo "Current version: 1.2.0"
    echo "Latest version: 2.0.0"
    echo "⚠️  Upgrade available: 1.2.0 → 2.0.0"
    echo
    
    # 2. Check available upgrades
    print_header "Step 2: Xem tất cả upgrade options có sẵn"
    echo
    
    echo "$ ./scripts/template-upgrade-git.sh check-upgrades"
    echo "📦 Available Upgrades:"
    echo "🔄 1.2.0 → 1.3.0"
    echo "   Description: Minor improvements and bug fixes"
    echo "   ⚠️  Breaking changes - migration may be required"
    echo
    echo "🔄 1.2.0 → 1.4.0"
    echo "   Description: Performance improvements and new development tools"
    echo "   Changes:"
    echo "     • Updated Flutter to 3.34.0"
    echo "     • Added new hot reload optimization tasks"
    echo "     • Enhanced VS Code debug configuration"
    echo
    echo "🔄 1.2.0 → 2.0.0"
    echo "   Description: Major version with new architecture"
    echo "   ⚠️  Breaking changes - migration may be required"
    echo
    
    # 3. Show selective upgrade decision
    print_header "Step 3: Quyết định selective upgrade"
    echo
    
    print_info "❓ Tại sao chọn 1.4.0 thay vì 2.0.0?"
    echo "  • Version 1.3.0 có breaking changes"
    echo "  • Version 2.0.0 có major breaking changes"
    echo "  • Version 1.4.0 ổn định, không có breaking changes"
    echo "  • Chỉ cần performance improvements, không cần major features"
    echo
    
    # 4. Perform selective upgrade
    print_header "Step 4: Thực hiện selective upgrade"
    echo
    
    echo "$ ./tika.sh template-upgrade --version 1.4.0"
    echo
    print_warning "Warning: Skipping version 1.3.0 which contains breaking changes"
    print_warning "Consider reviewing: docs/migrations/flutter-1.2-to-1.3.md"
    echo "Continue? (y/N): y"
    echo
    print_info "Creating upgrade branch: template-upgrade-1.2.0-to-1.4.0-20250703-103000"
    print_info "Applying template upgrade..."
    print_info "Updating mise.toml..."
    print_info "Updating template metadata..."
    echo
    print_success "Template upgraded successfully using git!"
    print_info "Upgrade branch: template-upgrade-1.2.0-to-1.4.0-20250703-103000"
    print_info "Original branch: main"
    echo
    
    # 5. Show upgrade result
    print_header "Step 5: Verify upgrade result"
    echo
    
    echo "$ ./tika.sh template-status"
    echo "Template: flutter-mise"
    echo "Current version: 1.4.0 ✅"
    echo "Latest version: 2.0.0"
    echo "Status: Selectively upgraded (not latest)"
    echo
    echo "📚 Upgrade History (1 upgrades)"
    echo "  1.2.0 → 1.4.0 (2025-07-03T10:30:00Z)"
    echo
    
    # 6. Show what was updated
    print_header "Step 6: Chi tiết những gì được update"
    echo
    
    echo ".template-metadata changes:"
    echo "template:"
    echo "  version: \"1.4.0\"  # Changed from 1.2.0"
    echo
    echo "upgrade_history:"
    echo "  - from_version: \"1.2.0\""
    echo "    to_version: \"1.4.0\""
    echo "    upgraded_at: \"2025-07-03T10:30:00Z\""
    echo "    changes_applied:"
    echo "      - \"Updated Flutter to 3.34.0\""
    echo "      - \"Updated Dart to 3.8.0\""
    echo "      - \"Added new development tasks\""
    echo
    
    echo "mise.toml changes:"
    echo "[tools]"
    echo "flutter = \"3.34.0\"  # Updated from 3.32.5"
    echo "dart = \"3.8.0\"      # Updated from 3.7.0"
    echo
    
    # 7. Next steps
    print_header "Step 7: Next steps"
    echo
    
    print_info "1. Test the upgraded project:"
    echo "   mise doctor"
    echo "   mise run test"
    echo
    print_info "2. If upgrade successful, merge to main branch:"
    echo "   git checkout main"
    echo "   git merge template-upgrade-1.2.0-to-1.4.0-20250703-103000"
    echo "   git branch -d template-upgrade-1.2.0-to-1.4.0-20250703-103000"
    echo
    print_info "3. If upgrade failed, rollback easily:"
    echo "   git checkout main"
    echo "   git branch -D template-upgrade-1.2.0-to-1.4.0-20250703-103000"
    echo
    
    # 8. Future upgrade options
    print_header "Step 8: Future upgrade options"
    echo
    
    print_info "Sau khi đã ở 1.4.0, bạn có thể:"
    echo
    echo "• Ở lại 1.4.0 (stable choice)"
    echo "  ./tika.sh template-status"
    echo
    echo "• Upgrade lên 2.0.0 khi ready:"
    echo "  ./tika.sh template-upgrade --version 2.0.0"
    echo "  # Sẽ có migration guide từ 1.4.0 → 2.0.0"
    echo
    echo "• Hoặc chờ version 2.1.0 (nếu 2.0.0 còn có issues):"
    echo "  ./scripts/template-upgrade-git.sh check-upgrades"
    echo "  ./tika.sh template-upgrade --version 2.1.0"
    echo
    
    print_success "Demo completed! 🎉"
    echo
    print_info "Selective version upgrade cho phép bạn:"
    echo "  ✅ Chọn exact version muốn upgrade"
    echo "  ✅ Bỏ qua versions có breaking changes"
    echo "  ✅ Upgrade theo strategy riêng của team"
    echo "  ✅ Không bắt buộc upgrade lên latest"
    echo "  ✅ Git integration để dễ rollback"
}

# Run demo
demo_selective_upgrade
