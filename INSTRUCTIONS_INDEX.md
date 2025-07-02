# Development Instructions Master Index

This repository contains comprehensive development instructions for both Flutter and React Native/Expo projects. Each template has its own set of specialized instructions tailored to the platform's best practices.

## 📱 Template Instructions

### 🔵 [Flutter Template Instructions](./templates/flutter-mise/.github/instructions/)
**Cross-platform Flutter development with Dart**

**Files:**
- [`README.md`](./templates/flutter-mise/.github/instructions/README.md) - Complete instructions index
- [`flutter-development.instructions.md`](./templates/flutter-mise/.github/instructions/flutter-development.instructions.md) - Core development patterns
- [`state-management.instructions.md`](./templates/flutter-mise/.github/instructions/state-management.instructions.md) - BLoC, Riverpod, Provider patterns
- [`ui-ux.instructions.md`](./templates/flutter-mise/.github/instructions/ui-ux.instructions.md) - Material Design, animations, theming

**Key Technologies:**
- Flutter SDK with Dart
- BLoC/Cubit for state management
- Riverpod for dependency injection
- Material 3 design system
- Clean architecture patterns

---

### 🟢 [React Native & Expo Template Instructions](./templates/rn-expo-mise/.github/instructions/)
**Cross-platform React Native development with TypeScript**

**Files:**
- [`README.md`](./templates/rn-expo-mise/.github/instructions/README.md) - Complete instructions index
- [`react-native-development.instructions.md`](./templates/rn-expo-mise/.github/instructions/react-native-development.instructions.md) - Core development patterns
- [`state-management.instructions.md`](./templates/rn-expo-mise/.github/instructions/state-management.instructions.md) - React Query, Zustand patterns
- [`navigation.instructions.md`](./templates/rn-expo-mise/.github/instructions/navigation.instructions.md) - React Navigation v6 patterns

**Key Technologies:**
- React Native with Expo
- TypeScript for type safety
- React Query for server state
- Zustand for client state
- React Navigation v6
- Biome for code quality

---

## 🎯 Usage Guidelines

### For GitHub Copilot AI Assistant:

#### When working on Flutter projects:
1. **Primary**: Start with Flutter development instructions
2. **State**: Use BLoC/Riverpod patterns from state management instructions
3. **UI**: Follow Material Design patterns from UI/UX instructions
4. **Architecture**: Implement clean architecture with feature-based structure

#### When working on React Native projects:
1. **Primary**: Start with React Native development instructions
2. **State**: Use React Query for server state, Zustand for client state
3. **Navigation**: Follow React Navigation v6 patterns
4. **Architecture**: Implement feature-based structure with TypeScript

### For Development Teams:

#### Project Setup:
1. Choose appropriate template (Flutter or React Native)
2. Review complete instructions index in template's README
3. Follow architecture guidelines for consistent structure
4. Implement recommended tooling and dependencies

#### Development Workflow:
1. Reference instructions during feature development
2. Use patterns and examples as implementation guides
3. Follow testing strategies outlined in instructions
4. Maintain code quality standards defined in instructions

## 🏗️ Architecture Comparison

### Flutter Architecture:
```
Clean Architecture + BLoC Pattern
├── Presentation Layer (Widgets, BLoC)
├── Domain Layer (Entities, Use Cases)
└── Data Layer (Repositories, Data Sources)
```

### React Native Architecture:
```
Feature-Based + React Query
├── Components Layer (React Components)
├── Business Logic (Custom Hooks, React Query)
└── Services Layer (API Services, Utilities)
```

## 🔧 Development Tools Integration

### VS Code Configuration:
- Specialized settings for each template
- Extension recommendations for platform-specific development
- Code spell checker with technical dictionaries
- Biome/Dart formatter configuration

### Code Quality:
- **Flutter**: Very Good Analysis, Dart formatter
- **React Native**: Biome, TypeScript strict mode
- Both: Comprehensive testing strategies

## 📚 Shared Principles

### Code Quality:
- Strong typing (Dart/TypeScript)
- Comprehensive testing
- Performance optimization
- Accessibility considerations

### Architecture:
- Feature-based organization
- Separation of concerns
- Dependency injection
- Clean code principles

### Development Experience:
- Hot reload/fast refresh
- Debugging tools integration
- Development server optimization
- Build automation

---

## 🚀 Getting Started

1. **Choose Template**: Select Flutter or React Native based on project requirements
2. **Read Instructions**: Start with the template's README.md for complete overview
3. **Setup Project**: Use provided scripts and configuration
4. **Follow Patterns**: Implement features using instruction guidelines
5. **Test & Validate**: Use test applications for experimentation

### Testing & Validation
Use the `playground/` directory for experimentation and validation:
```bash
# Test templates with reference implementations
cd playground/apps/flutter_app     # Flutter reference app
cd playground/apps/mobile-app      # React Native reference app

# Run comprehensive template validation
cd playground && ./scripts/test-runner.sh

# Create new test projects
cd playground && ../scripts/create-new-project.sh --template flutter --name experiment --path apps/
```

---

## 🤖 AI Assistant Guidelines

For AI assistants working on this project, please follow these guidelines:

### Terminal Commands
- Use simple, incremental commands instead of complex chained operations
- Prefer VS Code tools (`grep_search`, `file_search`, `read_file`) over shell commands
- Avoid complex regex patterns that can cause terminal hangs
- See [AI Terminal Instructions](.github/instructions/ai-in-terminal.instructions.md) for detailed best practices

### Code Editing
- Always read files before editing to understand context
- Include 3-5 lines of context in replacements
- Use appropriate editing tools for each task
- Test changes incrementally

### Project Structure Awareness
- `playground/` for testing and experimentation (not `test/`)
- `scripts/` for production automation
- `templates/` for development templates
- Follow established naming conventions

---
*This master index ensures consistent development patterns across both Flutter and React Native projects. Individual template instructions provide platform-specific implementation details.*
