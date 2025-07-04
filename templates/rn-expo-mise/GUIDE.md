# React Native & Expo Development Guide

**Complete implementation guide for React Native development with Tika** - TypeScript, React Query, Expo, and modern React Native patterns.

## 🎯 Quick Reference

| Topic | Details | Reference |
|-------|---------|-----------|
| **Technology Stack** | React Native 0.74+, Expo SDK 51+, TypeScript | [Tech Stack →](../../docs/REFERENCE.md#react-native-technology-stack) |
| **Architecture** | Feature-Based + React Query Pattern | [Architecture →](../../docs/REFERENCE.md#react-native-feature-based--react-query) |
| **Development Workflow** | Setup, develop, test, build process | [Workflows →](../../docs/WORKFLOWS.md#react-native-development) |
| **CLI Commands** | All available React Native commands | [CLI Reference →](../../docs/CLI.md) |

---

## 🚀 Getting Started

### Project Creation
```bash
# Create new React Native projec
./tika.sh create --template expo --name my-expo-app
cd my-expo-app

# Start developmen
mise run dev                # Start Expo development server
mise run android            # Launch Android emulator
mise run ios               # Launch iOS simulator (macOS)
```

> **Complete setup process**: See [Setup Workflows](../../docs/WORKFLOWS.md#setup-workflows)

### Project Structure
```
src/
├── components/            # Reusable UI components
├── features/              # Feature-based modules
│   └── [feature_name]/
│       ├── components/    # Feature components
│       ├── hooks/         # Custom hooks
│       ├── queries/       # React Query hooks
│       ├── services/      # API services
│       └── types/         # TypeScript types
├── navigation/            # Navigation configuration
├── services/              # Shared API services
├── stores/                # Zustand stores (client state)
├── queries/               # Global React Query hooks
├── utils/                 # Utility functions
└── types/                 # Global TypeScript types
```

> **Detailed architecture**: See [React Native Architecture](../../docs/REFERENCE.md#react-native-feature-based--react-query)

---

## 🏗️ Development Patterns

### React Query Hook Pattern
```typescrip
// See complete pattern examples in:
```
> [React Query Pattern Reference](../../docs/REFERENCE.md#react-native-react-query-hook)

### Zustand Store Pattern
```typescrip
// See complete pattern examples in:
```
> [Zustand Pattern Reference](../../docs/REFERENCE.md#react-native-zustand-store)

### Navigation Typing
```typescrip
// See complete pattern examples in:
```
> [Navigation Pattern Reference](../../docs/REFERENCE.md#code-pattern-reference)

---

## 🔧 Development Workflows

### Daily Developmen
```bash
# In project directory
mise run dev               # Start Expo development server
mise run test              # Run Jest tests
mise run lint              # Biome linting
mise run format            # Code formatting
```

### Quality Assurance
```bash
# Before committing
mise run lint              # Check code quality
mise run test              # All tests pass
mise run format            # Format code
```

### Platform Testing
```bash
# Test on different platforms
mise run android           # Android emulator/device
mise run ios              # iOS simulator (macOS)
mise run web              # Web browser (Expo)
```

> **Complete workflows**: See [Development Workflows](../../docs/WORKFLOWS.md#react-native-development)

---

## 🧪 Testing Strategy

### Test Types
- **Unit Tests**: Business logic, utilities, custom hooks
- **Component Tests**: React component behavior and interactions
- **Integration Tests**: Feature workflows and API integration
- **E2E Tests**: Complete user journeys with Detox

### Testing Commands
```bash
mise run test              # All tests
mise run test:unit         # Unit tests only
mise run test:component    # Component tests only
mise run test:e2e          # End-to-end tests
```

> **Testing patterns**: See [React Native Testing Reference](../../docs/REFERENCE.md#react-native-technology-stack)

---

## 📱 Platform-Specific Considerations

### Android Developmen
- React Native architecture
- Android-specific permissions and configuration
- Native module integration
- APK build and distribution

### iOS Developmen
- iOS-specific permissions and capabilities
- Native module integration
- IPA build and App Store distribution

### Web Development (Expo)
- Expo Web compatibility
- Web-specific navigation patterns
- Progressive Web App features

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

### React Native Official Documentation
- [React Native Documentation](https://reactnative.dev) - Complete React Native guide
- [Expo Documentation](https://docs.expo.dev) - Expo platform guide
- [TypeScript Documentation](https://www.typescriptlang.org/docs) - TypeScript guide

### State Managemen
- [TanStack Query](https://tanstack.com/query) - React Query documentation
- [Zustand Documentation](https://zustand-demo.pmnd.rs) - Zustand guide
- [React Navigation](https://reactnavigation.org) - Navigation guide

### Development Tools
- [React Native Debugger](https://github.com/jhen0409/react-native-debugger) - Debugging tools
- [Flipper](https://fbflipper.com) - Mobile app debugging platform
- [Expo Dev Tools](https://docs.expo.dev/debugging/tools) - Expo debugging

---

## 🚨 Troubleshooting

### Common Issues
- **Metro bundler errors**: Run `mise run clean` then `mise run dev`
- **Dependency conflicts**: Check `package.json` versions
- **Platform issues**: Re-run platform setup scripts

### Getting Help
1. **Check environment**: `mise doctor`
2. **Verify template**: `./tika.sh template-status`
3. **Clean rebuild**: `mise run clean && mise run dev`

> **Complete troubleshooting**: See [Troubleshooting Guide](../../docs/TROUBLESHOOTING.md)

---

**This guide provides React Native-specific implementation details. For general workflows and commands, refer to the [core documentation](../../docs/).**
