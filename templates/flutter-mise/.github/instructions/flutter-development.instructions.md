# Flutter Development Instructions

## Overview
This document provides specific instructions for GitHub Copilot when working on Flutter projects.

## Core Development Principles

### Architecture
- Follow the BLoC pattern or Riverpod for state management
- Use repository pattern for data layer
- Implement clean architecture principles
- Separate business logic from UI components

### Code Organization
```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
├── features/
│   └── feature_name/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/
│   ├── themes/
│   └── extensions/
└── main.dart
```

### Widget Development
- Always use `const` constructors when possible
- Keep widgets small and focused
- Extract complex logic into separate methods
- Use proper key management for dynamic lists
- Implement proper dispose methods for controllers

### State Management
- Use `StatelessWidget` by default
- Convert to `StatefulWidget` only when local state is needed
- For complex state, prefer Riverpod or BLoC
- Avoid `setState` in large widgets

### Performance Best Practices
- Use `ListView.builder` for scrollable lists
- Implement `RepaintBoundary` for expensive widgets
- Use `AutomaticKeepAliveClientMixin` when appropriate
- Optimize image loading with `cached_network_image`

### Testing Guidelines
- Write unit tests for business logic
- Create widget tests for UI components
- Use integration tests for complete user flows
- Mock external dependencies properly

### Error Handling
- Implement proper try-catch blocks
- Use `Either` type for error handling (fpdart package)
- Provide meaningful error messages
- Handle network failures gracefully

### Code Style
- Follow official Dart style guide
- Use meaningful variable names
- Add documentation for public APIs
- Keep line length under 120 characters
- Use trailing commas for better formatting

## Specific Instructions for Copilot

### When generating widgets:
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```

### When generating models:
```dart
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

### When generating API calls:
```dart
class ApiService {
  const ApiService(this._dio);

  final Dio _dio;

  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      return Right(User.fromJson(response.data));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
```

### When generating tests:
```dart
void main() {
  group('User', () {
    test('should create User from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
      };

      // Act
      final user = User.fromJson(json);

      // Assert
      expect(user.id, '1');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
    });
  });
}
```

## Dependencies to Prefer
- `dio` for HTTP requests
- `fpdart` for functional programming
- `riverpod` or `flutter_bloc` for state management
- `go_router` for navigation
- `freezed` for immutable data classes
- `json_annotation` for JSON serialization
- `cached_network_image` for image loading
- `flutter_secure_storage` for secure storage

## Avoid
- Using `var` without explicit types in public APIs
- Creating god widgets with multiple responsibilities
- Direct HTTP calls without error handling
- Hardcoding strings (use localization)
- Ignoring null safety warnings
- Using deprecated widgets or methods
