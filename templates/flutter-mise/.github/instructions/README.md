# Flutter Development Instructions Index

This directory contains comprehensive instructions for GitHub Copilot when working on Flutter projects. Each file provides specific guidance for different aspects of Flutter development.

## 📋 Instructions Overview

### 🎯 [Flutter Development](./flutter-development.instructions.md)
**Core Flutter development patterns and best practices**

- **Architecture**: Clean architecture, BLoC pattern, dependency injection
- **Widget Development**: StatefulWidget, StatelessWidget, custom widgets
- **State Management**: BLoC, Riverpod, Provider patterns
- **Navigation**: Navigator 2.0, routing strategies
- **Dependencies**: Preferred packages and tools
- **Platform Considerations**: iOS/Android/Web/Desktop patterns
- **Performance**: Widget optimization, memory management
- **Testing**: Unit, widget, and integration testing

**Key Sections:**
- Widget composition patterns
- State management implementations
- Navigation and routing
- Platform-specific code
- Performance optimization
- Testing strategies

---

### 🗂️ [State Management](./state-management.instructions.md)
**Advanced state management patterns for Flutter**

- **BLoC Pattern**: Business Logic Component implementation
- **Riverpod**: Modern provider pattern
- **Provider**: Classic state management
- **State Notifier**: Immutable state management
- **Freezed Integration**: Immutable data classes
- **Testing**: State management testing patterns

**Key Sections:**
- BLoC implementation patterns
- Riverpod provider setup
- State notifier patterns
- Freezed data classes
- Testing state management
- Performance considerations

---

### 🎨 [UI/UX](./ui-ux.instructions.md)
**User interface and user experience patterns**

- **Material Design**: Material 3 implementation
- **Cupertino Design**: iOS-style widgets
- **Custom Themes**: Theme data and styling
- **Responsive Design**: Adaptive layouts
- **Animations**: Implicit and explicit animations
- **Accessibility**: A11y best practices

**Key Sections:**
- Theme configuration
- Custom widget creation
- Animation implementations
- Responsive design patterns
- Accessibility guidelines
- Platform-specific UI

---

### 🛡️ [AI Terminal Safety](./ai-in-terminal.instructions.md)
**Guidelines for safe AI-assisted terminal operations**

- **Command Safety**: Avoid complex regex and chained operations
- **File Operations**: Use VS Code tools instead of terminal commands
- **Error Prevention**: Prevent terminal hangs and command issues
- **Best Practices**: Incremental testing and safe command patterns
- **VS Code Integration**: Prefer integrated tools over shell commands

**Key Guidelines:**
- Never use complex shell escaping patterns
- Avoid cat with heredoc for large content
- Use VS Code file editing tools
- Break complex tasks into simple steps
- Test commands incrementally

---

## 🎯 Usage Guidelines

### For GitHub Copilot:
1. **Primary Reference**: Start with `flutter-development.instructions.md` for general patterns
2. **State Management**: Use `state-management.instructions.md` for BLoC/Riverpod patterns
3. **UI Implementation**: Follow `ui-ux.instructions.md` for design patterns
4. **Cross-Platform**: Consider platform-specific implementations

### For Developers:
1. **Project Setup**: Follow main development instructions
2. **Architecture**: Implement clean architecture patterns
3. **State Management**: Choose appropriate pattern for complexity
4. **UI/UX**: Follow Material Design and iOS Human Interface Guidelines

## 🏗️ Architecture Overview

```
Flutter App Architecture
├── lib/
│   ├── core/               # Core functionality
│   │   ├── error/         # Error handling
│   │   ├── network/       # Network layer
│   │   ├── theme/         # App theming
│   │   └── utils/         # Utility functions
│   ├── features/          # Feature-based modules
│   │   └── feature_name/
│   │       ├── data/      # Data layer
│   │       │   ├── datasources/  # Local/Remote data sources
│   │       │   ├── models/       # Data models
│   │       │   └── repositories/ # Repository implementations
│   │       ├── domain/    # Domain layer
│   │       │   ├── entities/     # Business entities
│   │       │   ├── repositories/ # Repository contracts
│   │       │   └── usecases/     # Business logic
│   │       └── presentation/ # Presentation layer
│   │           ├── bloc/         # BLoC/Cubit
│   │           ├── pages/        # Screen widgets
│   │           └── widgets/      # UI components
│   ├── shared/            # Shared components
│   │   ├── widgets/       # Reusable widgets
│   │   └── utils/         # Shared utilities
│   └── main.dart         # App entry point
```

## 🔧 Technology Stack

### Core Technologies:
- **Flutter**: UI framework
- **Dart**: Programming language
- **BLoC/Cubit**: State management
- **Riverpod**: Dependency injection and state
- **Freezed**: Immutable data classes
- **Go Router**: Navigation
- **Dio**: HTTP client

### Development Tools:
- **VS Code/Android Studio**: Primary IDEs
- **Flutter Inspector**: Widget debugging
- **Dart DevTools**: Performance profiling
- **Flipper**: Additional debugging
- **Very Good CLI**: Project scaffolding

### Design & Testing:
- **Material 3**: Design system
- **Flutter Test**: Testing framework
- **Golden Toolkit**: Golden file testing
- **Mockito**: Mocking framework

## 📚 Quick Reference

### Common Patterns:
- **Widgets**: Composition over inheritance
- **State**: BLoC for complex, Provider for simple
- **Navigation**: Declarative routing with Go Router
- **Data**: Repository pattern with clean architecture
- **Testing**: Test-driven development approach

### Code Quality:
- **Linting**: Very good analysis
- **Formatting**: Dart formatter
- **Testing**: 100% test coverage goal
- **Documentation**: Comprehensive dartdoc comments

### Performance:
- **Widget optimization**: const constructors, keys
- **State management**: Minimal rebuilds
- **Images**: Asset optimization, caching
- **Lists**: ListView.builder for large datasets

---

*This index is maintained to ensure consistent development patterns across Flutter projects. Update instructions as new patterns and best practices emerge.*
