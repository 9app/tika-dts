# Flutter Development Guide

**Complete implementation guide for Flutter development with Tika** - Clean Architecture, BLoC patterns, and Material 3.

## 🎯 Quick Reference

| Topic | Details | Reference |
|-------|---------|-----------|
| **Technology Stack** | Flutter 3.24+, Dart 3.5+, Material 3 | [Tech Stack →](../../docs/REFERENCE.md#flutter-technology-stack) |
| **Architecture** | Clean Architecture + BLoC Pattern | [Architecture →](../../docs/REFERENCE.md#flutter-clean-architecture--bloc) |
| **Development Workflow** | Setup, develop, test, build process | [Workflows →](../../docs/WORKFLOWS.md#flutter-development) |
| **CLI Commands** | All available Flutter commands | [CLI Reference →](../../docs/CLI.md) |

---

## 🚀 Getting Started

### Project Creation
```bash
# Create new Flutter projec
./tika.sh create --template flutter --name my-flutter-app
cd my-flutter-app

# Start developmen
mise run dev                # Start development server
mise run android            # Launch Android emulator
mise run ios               # Launch iOS simulator (macOS)
```

> **Complete setup process**: See [Setup Workflows](../../docs/WORKFLOWS.md#setup-workflows)

### Project Structure
```
lib/
├── main.dart              # Application entry poin
├── app/                   # App configuration (theme, router)
├── core/                  # Shared infrastructure (error, network, utils)
├── shared/                # Reusable components (widgets, extensions)
└── features/              # Feature modules (domain, data, presentation)
    └── [feature_name]/
        ├── domain/        # Entities, repositories, use cases
        ├── data/          # Models, repositories, data sources
        └── presentation/  # Pages, widgets, BLoC/Cubi
```

> **Detailed architecture**: See [Flutter Architecture](../../docs/REFERENCE.md#flutter-clean-architecture--bloc)

---

## 🏗️ Development Patterns

### BLoC Pattern Implementation
```dar
// See complete pattern examples in:
```
> [BLoC Pattern Reference](../../docs/REFERENCE.md#flutter-bloc-pattern)

### Riverpod Provider Pattern
```dar
// See complete pattern examples in:
```
> [Riverpod Pattern Reference](../../docs/REFERENCE.md#flutter-riverpod-provider)

### Clean Architecture UseCase
```dar
// See complete pattern examples in:
```
> [Clean Architecture Reference](../../docs/REFERENCE.md#code-pattern-reference)

---

## 🔧 Development Workflows

### Daily Developmen
```bash
# In project directory
mise run dev               # Start development with hot reload
mise run test              # Run unit and widget tests
mise run lint              # Code analysis and linting
mise run format            # Code formatting
```

### Quality Assurance
```bash
# Before committing
mise run lint              # Check code quality
mise run test              # All tests pass
mise run analyze           # Static analysis
mise run format            # Format code
```

### Platform Testing
```bash
# Test on different platforms
mise run android           # Android emulator/device
mise run ios              # iOS simulator (macOS)
mise run web              # Web browser
```

> **Complete workflows**: See [Development Workflows](../../docs/WORKFLOWS.md#flutter-development)

---

## 🧪 Testing Strategy

### Test Types
- **Unit Tests**: Business logic, use cases, repositories
- **Widget Tests**: UI components and interactions
- **Integration Tests**: Feature workflows and user journeys
- **Golden Tests**: UI snapshot testing

### Testing Commands
```bash
mise run test              # All tests
mise run test:unit         # Unit tests only
mise run test:widget       # Widget tests only
mise run test:integration  # Integration tests
```

> **Testing patterns**: See [Flutter Testing Reference](../../docs/REFERENCE.md#flutter-technology-stack)

---

## 📱 Platform-Specific Considerations

### Android Developmen
- Material 3 design system
- Android-specific permissions
- Platform channels for native functionality
- APK/AAB build configuration

### iOS Developmen
- Human Interface Guidelines
- iOS-specific permissions and capabilities
- Platform channels for native functionality
- IPA build and distribution

### Web Developmen
- Progressive Web App (PWA) features
- Web-specific routing considerations
- Performance optimizations for web

> **Platform details**: See [Development Workflows](../../docs/WORKFLOWS.md#platform-specific-tasks)

---

## 🔄 Template Managemen

### Keeping Templates Updated
```bash
# Check for template updates
./tika.sh template-check

# Preview upgrade changes
./scripts/template-upgrade-git.sh check-upgrades

# Apply template upgrade
./scripts/template-upgrade-git.sh upgrade

# Rollback if issues
./tika.sh template-rollback
```

> **Template workflows**: See [Template Management](../../docs/WORKFLOWS.md#template-management-workflows)

---

## 📚 Learning Resources

### Flutter Official Documentation
- [Flutter Documentation](https://flutter.dev/docs) - Complete Flutter guide
- [Dart Language Tour](https://dart.dev/language) - Dart language guide
- [Material Design 3](https://m3.material.io) - Design system guide

### State Managemen
- [BLoC Library](https://bloclibrary.dev) - BLoC pattern documentation
- [Riverpod Documentation](https://riverpod.dev) - Riverpod guide

### Development Tools
- [Flutter Inspector](https://docs.flutter.dev/tools/flutter-inspector) - Widget debugging
- [Dart DevTools](https://docs.flutter.dev/tools/devtools) - Performance and debugging

---

## 🚨 Troubleshooting

### Common Issues
- **Build errors**: Run `mise run clean` then `mise run dev`
- **Dependency conflicts**: Check `pubspec.yaml` versions
- **Platform issues**: Re-run platform setup scripts

### Getting Help
1. **Check environment**: `mise doctor`
2. **Verify template**: `./tika.sh template-status`
3. **Clean rebuild**: `mise run clean && mise run dev`

> **Complete troubleshooting**: See [Troubleshooting Guide](../../docs/TROUBLESHOOTING.md)

---

**This guide provides Flutter-specific implementation details. For general workflows and commands, refer to the [core documentation](../../docs/).**
