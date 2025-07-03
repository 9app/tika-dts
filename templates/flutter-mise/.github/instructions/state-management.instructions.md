# Flutter State Management Instructions

## Riverpod State Managemen

### Provider Types
- Use `Provider` for read-only values
- Use `StateProvider` for simple state
- Use `StateNotifierProvider` for complex state
- Use `FutureProvider` for async operations
- Use `StreamProvider` for streams

### Example Implementations

#### Simple State Provider
```dar
final counterProvider = StateProvider<int>((ref) => 0);

class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $counter'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

#### StateNotifier for Complex State
```dar
@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(List<User> users) = _Loaded;
  const factory UserState.error(String message) = _Error;
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(this._repository) : super(const UserState.initial());

  final UserRepository _repository;

  Future<void> loadUsers() async {
    state = const UserState.loading();

    try {
      final users = await _repository.getUsers();
      state = UserState.loaded(users);
    } catch (e) {
      state = UserState.error(e.toString());
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});
```

#### Async Provider
```dar
final userFutureProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.read(userRepositoryProvider);
  return repository.getUsers();
});

class UserListWidget extends ConsumerWidget {
  const UserListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userFutureProvider);

    return usersAsync.when(
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => UserTile(user: users[index]),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## BLoC Pattern

### Event and State Classes
```dar
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested(String email, String password) = _LoginRequested;
  const factory AuthEvent.logoutRequested() = _LogoutRequested;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}
```

### BLoC Implementation
```dar
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState.initial()) {
    on<_LoginRequested>(_onLoginRequested);
    on<_LogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onLoginRequested(
    _LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      final user = await _authRepository.login(event.email, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    _LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthState.unauthenticated());
  }
}
```

### BLoC Consumer Widge
```dar
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (user) => context.go('/home'),
          error: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          ),
          orElse: () {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => const CircularProgressIndicator(),
          orElse: () => const LoginForm(),
        );
      },
    );
  }
}
```

## Best Practices

### Provider Dependency Injection
```dar
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(dioProvider));
});
```

### Error Handling
```dar
final dataProvider = FutureProvider<Data>((ref) async {
  try {
    final repository = ref.read(dataRepositoryProvider);
    return await repository.getData();
  } on NetworkException catch (e) {
    throw DataException('Network error: ${e.message}');
  } on ServerException catch (e) {
    throw DataException('Server error: ${e.message}');
  }
});
```

### Testing State Managemen
```dar
void main() {
  group('UserNotifier', () {
    late UserRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockUserRepository();
      container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    test('should load users successfully', () async {
      // Arrange
      when(() => mockRepository.getUsers())
          .thenAnswer((_) async => [const User(id: '1', name: 'Test')]);

      // Ac
      await container.read(userProvider.notifier).loadUsers();

      // Asser
      final state = container.read(userProvider);
      expect(state, isA<_Loaded>());
    });
  });
}
```
