# 🏗️ Architecture Documentation

## Overview

ForeverUsInLove follows **Clean Architecture** principles combined with **BLoC (Business Logic Component)** pattern for state management. This ensures:

- ✅ **Separation of concerns**
- ✅ **Testability**
- ✅ **Maintainability**
- ✅ **Scalability**
- ✅ **Independence from frameworks**

---

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  (UI, Widgets, Pages, BLoC, ViewModels)                     │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ Events/States
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                             │
│  (Entities, Use Cases, Repository Interfaces)               │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        │ Entities/Failures
                        ↓
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│  (Models, Repositories, Data Sources, DTOs)                 │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ↓
        ┌───────────────┴───────────────┐
        │                               │
┌───────▼──────┐              ┌─────────▼────────┐
│ Remote Data  │              │  Local Data      │
│   Source     │              │    Source        │
│ (API/Cloud)  │              │ (Cache/DB)       │
└──────────────┘              └──────────────────┘
```

---

## 1. Presentation Layer

### Responsibilities
- Display UI to users
- Handle user interactions
- Manage UI state with BLoC
- Navigate between screens
- Format data for display

### Components

#### BLoC (Business Logic Component)
```dart
// Example: LoginBloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  
  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }
  
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    
    result.fold(
      (failure) => emit(LoginFailure(message: failure.message)),
      (user) => emit(LoginSuccess(user: user)),
    );
  }
}
```

#### Pages
- Stateless/Stateful widgets
- BlocProvider setup
- BlocListener/BlocBuilder for state management
- Navigation logic

#### Widgets
- Reusable UI components
- Custom buttons, inputs, cards
- Layout components

---

## 2. Domain Layer

### Responsibilities
- Define business entities
- Implement business logic (Use Cases)
- Define repository contracts (interfaces)
- Pure Dart code (no Flutter dependencies)

### Components

#### Entities
```dart
// Example: User Entity
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, email, name, photoUrl, createdAt];
}
```

#### Use Cases
```dart
// Example: LoginUseCase
class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  
  const LoginParams({required this.email, required this.password});
  
  @override
  List<Object> get props => [email, password];
}
```

#### Repository Interfaces
```dart
// Example: AuthRepository Interface
abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, User>> register(RegisterParams params);
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, User>> getCurrentUser();
}
```

---

## 3. Data Layer

### Responsibilities
- Implement repository interfaces
- Manage data sources (remote/local)
- Handle data transformation (Model ↔ Entity)
- Cache management
- Error handling

### Components

#### Models
```dart
// Example: UserModel (extends Entity)
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.photoUrl,
    required super.createdAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photo_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

#### Repository Implementation
```dart
// Example: AuthRepositoryImpl
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
```

#### Data Sources

**Remote Data Source**
```dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(RegisterParams params);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  
  AuthRemoteDataSourceImpl({required this.dio});
  
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Server error',
        code: e.response?.statusCode,
      );
    }
  }
}
```

**Local Data Source**
```dart
abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });
  
  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString('cached_user');
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
  
  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      'cached_user',
      json.encode(user.toJson()),
    );
  }
}
```

---

## Dependency Flow

```
Presentation → Domain → Data

Dependencies point inward:
- Presentation depends on Domain
- Data depends on Domain
- Domain depends on nothing (pure business logic)
```

---

## State Management with BLoC

### BLoC Pattern Components

1. **Events**: User actions or triggers
2. **States**: UI states based on data
3. **BLoC**: Business logic processor

### Example Flow

```
User Action (e.g., Login Button Click)
         ↓
    LoginEvent (LoginSubmitted)
         ↓
    LoginBloc (processes event)
         ↓
    LoginUseCase (business logic)
         ↓
    AuthRepository (data access)
         ↓
    Remote/Local DataSource
         ↓
    Result (Success/Failure)
         ↓
    LoginState (LoginSuccess/LoginFailure)
         ↓
    UI Update (BlocBuilder rebuilds)
```

---

## Dependency Injection

Using **GetIt** and **Injectable** for dependency management.

### Setup

```dart
// injection.dart
@InjectableInit()
Future<void> configureDependencies() async {
  // Core dependencies
  getIt.registerLazySingleton<Dio>(() => ApiClient.createDio());
  getIt.registerLazySingleton<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  
  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  
  // BLoCs
  getIt.registerFactory(() => LoginBloc(loginUseCase: getIt()));
}
```

### Usage in Widgets

```dart
BlocProvider(
  create: (context) => getIt<LoginBloc>(),
  child: LoginPage(),
)
```

---

## Error Handling

### Failure Types

```dart
abstract class Failure {
  final String message;
  final int? code;
}

- ServerFailure: API/Backend errors
- NetworkFailure: Connection issues
- CacheFailure: Local storage errors
- AuthenticationFailure: Auth-specific errors
- ValidationFailure: Input validation errors
```

### Exception to Failure Mapping

```dart
try {
  final result = await remoteDataSource.login(email, password);
  return Right(result);
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message));
} on NetworkException catch (e) {
  return Left(NetworkFailure(message: e.message));
}
```

---

## Testing Strategy

### Unit Tests
- Test use cases independently
- Mock repositories
- Test business logic

### Widget Tests
- Test UI components
- Test BLoC state management
- Mock BLoCs

### Integration Tests
- Test complete flows
- Test API integration
- Test navigation

---

## Best Practices

1. **Single Responsibility**: Each class has one job
2. **Dependency Inversion**: Depend on abstractions, not implementations
3. **Immutable State**: Use Equatable for value equality
4. **Error Handling**: Use Either<Failure, Success> pattern
5. **Separation**: Keep layers independent
6. **Testing**: Write tests for all layers
7. **Documentation**: Document complex business logic

---

## File Naming Conventions

```
- Entities: user.dart
- Models: user_model.dart
- Repositories: auth_repository.dart (interface)
- Repository Impl: auth_repository_impl.dart
- Data Sources: auth_remote_data_source.dart
- Use Cases: login_use_case.dart
- BLoCs: login_bloc.dart, login_event.dart, login_state.dart
- Pages: login_page.dart
- Widgets: custom_button.dart
```

---

## Summary

This architecture provides:
- **Scalability**: Easy to add new features
- **Maintainability**: Clear separation of concerns
- **Testability**: Each layer can be tested independently
- **Flexibility**: Easy to change implementations
- **Clean Code**: Following SOLID principles

---

For more details, refer to:
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern Documentation](https://bloclibrary.dev/)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
