# 🤝 Contributing to ForeverUsInLove

Thank you for your interest in contributing to ForeverUsInLove! This document provides guidelines for contributing to the project.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Requirements](#testing-requirements)

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the project
- Show empathy towards other contributors

---

## Getting Started

### Prerequisites

1. Flutter SDK 3.16.0+
2. Dart SDK 3.0+
3. Git
4. IDE (VS Code or Android Studio)

### Setup

```bash
# Clone repository
git clone https://github.com/yourusername/ForeverUsInLove_Frontend.git

# Install dependencies
flutter pub get

# Copy environment file
cp .env.example .env

# Run the app
flutter run
```

---

## Development Workflow

### 1. Create a Branch

```bash
# Fetch latest changes
git fetch origin

# Create feature branch
git checkout -b feature/your-feature-name

# Or bug fix branch
git checkout -b fix/bug-description
```

### Branch Naming Convention

- **Features**: `feature/login-screen`
- **Bug Fixes**: `fix/login-validation`
- **Hotfixes**: `hotfix/critical-bug`
- **Documentation**: `docs/update-readme`
- **Refactoring**: `refactor/auth-service`

### 2. Make Changes

- Follow coding standards
- Write tests for new features
- Update documentation if needed
- Ensure code passes linting

### 3. Test Your Changes

```bash
# Run tests
flutter test

# Run analyzer
flutter analyze

# Format code
flutter format .
```

### 4. Commit Your Changes

Follow commit guidelines (see below)

### 5. Push to Remote

```bash
git push origin feature/your-feature-name
```

### 6. Create Pull Request

- Use the PR template
- Provide clear description
- Link related issues
- Request reviews

---

## Coding Standards

### Dart Style Guide

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.

### File Organization

```
lib/
├── core/           # Core functionality
├── features/       # Feature modules
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/         # Shared code
```

### Naming Conventions

#### Files
```dart
// Snake case for files
user_repository.dart
login_bloc.dart
```

#### Classes
```dart
// Pascal case for classes
class UserRepository { }
class LoginBloc { }
```

#### Variables and Functions
```dart
// Camel case for variables/functions
final userName = 'John';
void fetchUserData() { }
```

#### Constants
```dart
// Screaming snake case for constants
const int MAX_LOGIN_ATTEMPTS = 3;
```

### Code Structure

#### Use Trailing Commas
```dart
// Good
Widget build(BuildContext context) {
  return Container(
    child: Text('Hello'),
  );
}
```

#### Prefer const Constructors
```dart
// Good
const SizedBox(height: 16);

// Avoid
SizedBox(height: 16);
```

#### Use Meaningful Names
```dart
// Good
final authenticatedUser = await repository.login();

// Avoid
final u = await repo.l();
```

---

## Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting)
- **refactor**: Code refactoring
- **test**: Adding tests
- **chore**: Maintenance tasks

### Scope

- **auth**: Authentication module
- **profile**: Profile module
- **chat**: Chat module
- **core**: Core functionality
- **ui**: UI components

### Examples

```bash
# Feature
git commit -m "feat(auth): implement login with email"

# Bug fix
git commit -m "fix(auth): resolve password validation issue"

# Documentation
git commit -m "docs(readme): update installation instructions"

# With body and footer
git commit -m "feat(auth): add Google Sign-In

Implement Google authentication flow with proper error handling

Closes #123"
```

---

## Pull Request Process

### 1. Before Creating PR

- [ ] Code follows style guidelines
- [ ] Tests pass (`flutter test`)
- [ ] Linter passes (`flutter analyze`)
- [ ] Code is formatted (`flutter format .`)
- [ ] Documentation updated
- [ ] No merge conflicts

### 2. PR Title Format

```
[TYPE] Brief description

Examples:
[FEAT] Add login screen
[FIX] Resolve password validation bug
[DOCS] Update README
```

### 3. PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated

## Screenshots (if applicable)
Add screenshots here

## Related Issues
Closes #123
```

### 4. Review Process

- At least 1 approval required
- Address all review comments
- Keep PR focused and small
- Respond promptly to feedback

### 5. Merge

- Squash commits before merging
- Delete branch after merge
- Update local repository

---

## Testing Requirements

### Unit Tests

Test business logic and use cases:

```dart
// test/features/auth/domain/usecases/login_use_case_test.dart
void main() {
  group('LoginUseCase', () {
    test('should return User when login is successful', () async {
      // Arrange
      final repository = MockAuthRepository();
      final useCase = LoginUseCase(repository);
      
      when(repository.login(any, any))
          .thenAnswer((_) async => Right(tUser));
      
      // Act
      final result = await useCase(LoginParams(
        email: 'test@example.com',
        password: 'password123',
      ));
      
      // Assert
      expect(result, Right(tUser));
    });
  });
}
```

### Widget Tests

Test UI components:

```dart
// test/features/auth/presentation/pages/login_page_test.dart
void main() {
  testWidgets('LoginPage should display email and password fields',
      (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(home: LoginPage()),
    );
    
    // Find fields
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
```

### Integration Tests

Test complete flows:

```dart
// integration_test/auth_flow_test.dart
void main() {
  testWidgets('Complete login flow', (WidgetTester tester) async {
    // Start app
    await tester.pumpWidget(MyApp());
    
    // Navigate to login
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    // Enter credentials
    await tester.enterText(find.byKey(Key('email')), 'test@example.com');
    await tester.enterText(find.byKey(Key('password')), 'password123');
    
    // Submit
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    // Verify navigation
    expect(find.text('Home'), findsOneWidget);
  });
}
```

---

## Documentation

### Code Comments

```dart
/// Authenticates user with email and password.
///
/// Returns [User] on success, [Failure] on error.
///
/// Throws [NetworkException] if no internet connection.
Future<Either<Failure, User>> login({
  required String email,
  required String password,
}) async {
  // Implementation
}
```

### README Updates

Update README.md when:
- Adding new features
- Changing setup process
- Updating dependencies
- Modifying architecture

---

## Code Review Checklist

### For Reviewers

- [ ] Code follows style guidelines
- [ ] Logic is clear and well-structured
- [ ] Tests are comprehensive
- [ ] Documentation is updated
- [ ] No security vulnerabilities
- [ ] Performance is acceptable
- [ ] Error handling is proper

### For Authors

- [ ] Self-reviewed code
- [ ] Added tests
- [ ] Updated documentation
- [ ] Resolved merge conflicts
- [ ] Addressed review comments

---

## Getting Help

### Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

### Contact

- **Email**: dev@foreverusinlove.com
- **Slack**: #foreverusinlove-dev
- **Issues**: GitHub Issues

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to ForeverUsInLove! 💕
