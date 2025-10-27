# 🧪 Testing Guide - ForeverUsInLove Backend Integration

Complete guide for setting up, running, and understanding the test suite for all 21 API endpoints.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Running Tests](#running-tests)
4. [Test Coverage](#test-coverage)
5. [Test Structure](#test-structure)
6. [Troubleshooting](#troubleshooting)

---

## 🔧 Prerequisites

Before running tests, ensure you have:

- ✅ **Flutter SDK** installed (version 3.19.0 or higher)
- ✅ **Dart SDK** (comes with Flutter)
- ✅ **Git** installed
- ✅ **Code editor** (VS Code, Android Studio, or IntelliJ)
- ✅ **Internet connection** (for downloading dependencies)

### Check Your Flutter Installation

```bash
flutter --version
flutter doctor
```

Expected output should show Flutter 3.19.0 or higher.

---

## 🚀 Environment Setup

### Step 1: Navigate to Project Directory

```bash
cd /path/to/ForeverUsInLove
```

### Step 2: Install Dependencies

```bash
# Install all project dependencies
flutter pub get
```

This will install:
- Production dependencies (dio, retrofit, flutter_bloc, etc.)
- Test dependencies (mockito, bloc_test, http_mock_adapter, mocktail)

### Step 3: Generate Required Code

The project uses code generation for:
- JSON serialization (json_serializable)
- Retrofit API client
- Mockito mocks

```bash
# Generate all required .g.dart files
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected output:
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 2.1s
[INFO] Creating build script snapshot...
[INFO] Creating build script snapshot completed, took 8.3s
[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 1.5s
[INFO] Checking for unexpected pre-existing outputs...
[INFO] Succeeded after 12.4s with 11 outputs
```

### Step 4: Generate Test Mocks

```bash
# Generate mocks for testing
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `auth_repository_impl_test.mocks.dart`
- Other mock files for testing

---

## 🧪 Running Tests

### Run All Tests

```bash
# Run all tests in the project
flutter test
```

### Run Specific Test Files

```bash
# Run only repository tests
flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart

# Run only API endpoint tests
flutter test test/features/auth/data/datasources/auth_remote_datasource_test.dart
```

### Run Tests with Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage in terminal (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Tests in Watch Mode

```bash
# Auto-run tests on file changes (requires fswatch or similar)
flutter test --watch
```

### Run Tests with Detailed Output

```bash
# Show detailed test output
flutter test --verbose

# Show individual test results
flutter test --reporter expanded
```

---

## 📊 Test Coverage

### Summary

| Category | Tests | Endpoints Covered |
|----------|-------|-------------------|
| **Login & Logout** | 7 tests | 6 endpoints |
| **Registration** | 4 tests | 3 endpoints |
| **Email Verification** | 5 tests | 4 endpoints |
| **Phone Verification** | 3 tests | 3 endpoints |
| **Password Management** | 4 tests | 3 endpoints |
| **Social Authentication** | 3 tests | 2 endpoints |
| **Error Handling** | 6 tests | All endpoints |
| **Total** | **32+ tests** | **21 endpoints** |

### Detailed Coverage

#### 1. Login & Logout Tests (7 tests)

```
✅ POST /auth/login - Success case
✅ POST /auth/login - Invalid credentials (401)
✅ POST /auth/logout - Success case
✅ POST /auth/logout/all-devices - Success case
✅ POST /auth/logout/device/{deviceId} - Success case
✅ GET /auth/sessions - List sessions
✅ DELETE /auth/sessions/{sessionId} - Delete session
```

#### 2. Registration Tests (4 tests)

```
✅ POST /auth/register/simple-register - Success case
✅ POST /auth/register/with-email-verification - Success case
✅ POST /auth/register/with-phone-verification - Success case
✅ POST /auth/register - Email already exists (422)
```

#### 3. Email Verification Tests (5 tests)

```
✅ POST /auth/verification/email/send - Send verification
✅ POST /auth/verification/email/verify - Verify code success
✅ POST /auth/verification/email/verify - Invalid code (400)
✅ POST /auth/verification/email/resend - Resend code
✅ GET /auth/verification/email/status - Check status
```

#### 4. Phone Verification Tests (3 tests)

```
✅ POST /auth/verification/phone/send - Send SMS
✅ POST /auth/verification/phone/verify - Verify code
✅ POST /auth/verification/phone/resend - Resend SMS
```

#### 5. Password Management Tests (4 tests)

```
✅ POST /auth/password/forgot - Send reset email
✅ POST /auth/password/forgot - Email not found (404)
✅ POST /auth/password/reset - Reset with token
✅ POST /auth/password/change - Change password
```

#### 6. Social Authentication Tests (3 tests)

```
✅ POST /auth/social/google - Login success
✅ POST /auth/social/google - Invalid token (401)
✅ POST /auth/social/apple - Login success
```

#### 7. Network Error Tests (2 tests)

```
✅ Connection timeout handling
✅ Server error (500) handling
```

---

## 🗂️ Test Structure

### Directory Layout

```
test/
├── helpers/
│   └── test_helper.dart              # Shared test data and utilities
├── features/
│   └── auth/
│       ├── data/
│       │   ├── repositories/
│       │   │   └── auth_repository_impl_test.dart      # Repository unit tests
│       │   └── datasources/
│       │       └── auth_remote_datasource_test.dart    # API integration tests
│       ├── domain/
│       │   └── (future domain tests)
│       └── presentation/
│           └── (future widget tests)
└── core/
    ├── network/
    │   └── (future network tests)
    └── storage/
        └── (future storage tests)
```

### Test File Descriptions

#### 1. `test_helper.dart`

Provides shared test data:
- Mock user data (email, phone, password, etc.)
- Mock requests (LoginRequest, RegisterRequest, etc.)
- Mock responses (AuthResponse, UserModel, etc.)
- Mock JSON payloads
- Utility methods for creating test data

**Usage:**
```dart
import '../../../../../helpers/test_helper.dart';

test('example', () {
  final request = TestHelper.mockLoginRequest;
  final response = TestHelper.mockAuthResponse;
  expect(request.email, TestHelper.testEmail);
});
```

#### 2. `auth_repository_impl_test.dart`

Unit tests for `AuthRepositoryImpl`:
- Tests business logic layer
- Uses mocked dependencies (data source, storage)
- Tests all 11 repository methods
- Tests error handling and data flow

**Key Tests:**
- Login flow with token storage
- Registration with user creation
- Email/phone verification flows
- Password management flows
- Logout and session management
- Social authentication flows

#### 3. `auth_remote_datasource_test.dart`

Integration tests for API endpoints:
- Tests network layer
- Uses HTTP mock adapter to simulate API responses
- Tests all 21 API endpoints
- Tests success and error scenarios
- Tests network error handling

**Key Tests:**
- API request/response mapping
- HTTP status code handling
- Error response parsing
- Network timeout handling

---

## 🎯 Running Tests on Your Device

### Option 1: Run Tests Locally (Recommended)

```bash
# 1. Clone the repository (if not already done)
git clone https://github.com/Luisnefelibato/Forever_Front.git
cd Forever_Front

# 2. Checkout the test branch
git checkout genspark_ai_developer

# 3. Install dependencies
flutter pub get

# 4. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Run all tests
flutter test

# 6. Run with coverage
flutter test --coverage
```

### Option 2: Run Tests in CI/CD

Add to `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      - run: flutter pub get
      - run: flutter pub run build_runner build --delete-conflicting-outputs
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
```

### Option 3: Run Tests in VS Code

1. Install the **Flutter** extension
2. Open Command Palette (`Cmd+Shift+P` or `Ctrl+Shift+P`)
3. Select **Flutter: Run Tests**
4. Or click the **Run** button above each test

### Option 4: Run Tests in Android Studio

1. Open the test file
2. Click the **Run** icon (▶️) next to test group or individual test
3. View results in the **Run** panel at the bottom

---

## 🔧 Troubleshooting

### Issue 1: "Missing .g.dart files"

**Error:**
```
Error: Could not resolve the package 'auth_api_client.g.dart'
```

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 2: "Mock files not found"

**Error:**
```
Error: Could not resolve 'auth_repository_impl_test.mocks.dart'
```

**Solution:**
```bash
# Generate mocks
flutter pub run build_runner build --delete-conflicting-outputs

# If still failing, clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 3: "Test failures due to network"

**Error:**
```
Test failed: DioException [connection timeout]
```

**Solution:**
Tests use mocked HTTP responses, so this shouldn't happen. If it does:
```bash
# Check that http_mock_adapter is installed
flutter pub get

# Ensure you're not accidentally hitting real API
# Check test file imports and mock setup
```

### Issue 4: "Build runner conflicts"

**Error:**
```
[SEVERE] Conflicting outputs were detected
```

**Solution:**
```bash
# Delete existing generated files and regenerate
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 5: "Flutter test command not found"

**Error:**
```
bash: flutter: command not found
```

**Solution:**
```bash
# Check Flutter installation
flutter doctor

# If not installed, install Flutter:
# https://docs.flutter.dev/get-started/install
```

### Issue 6: "Tests pass but app crashes"

**Cause:** Tests use mocks, but app uses real API.

**Solution:**
```bash
# Ensure backend is running and accessible
curl http://3.232.35.26:8000/api/v1/health

# Check .env file has correct base URL
cat .env

# Verify dio_client.dart has correct baseUrl
cat lib/core/network/dio_client.dart | grep baseUrl
```

---

## 📝 Test Checklist

Before considering tests complete:

- [ ] All dependencies installed (`flutter pub get`)
- [ ] Code generation completed (`build_runner`)
- [ ] All tests pass (`flutter test`)
- [ ] Coverage report generated (`flutter test --coverage`)
- [ ] No warnings or errors in test output
- [ ] Mock files generated successfully
- [ ] All 21 endpoints have corresponding tests
- [ ] Error cases tested for each endpoint
- [ ] Network error handling tested

---

## 🎉 Expected Test Output

When all tests pass, you should see:

```
00:05 +32: All tests passed!
```

With detailed output:

```
00:01 +1: AuthRepositoryImpl - Login should return User when login is successful
00:01 +2: AuthRepositoryImpl - Login should return ServerFailure when login fails
00:02 +3: AuthRepositoryImpl - Register should return User when registration is successful
...
00:05 +32: All tests passed!
```

---

## 📚 Additional Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [HTTP Mock Adapter](https://pub.dev/packages/http_mock_adapter)
- [Bloc Test Package](https://pub.dev/packages/bloc_test)

---

## 🤝 Contributing

When adding new tests:

1. Follow existing test structure
2. Use `TestHelper` for mock data
3. Test both success and error cases
4. Update this guide with new test coverage
5. Ensure all tests pass before committing

---

## ✅ Quick Reference

### Essential Commands

```bash
# Setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Run Tests
flutter test                                    # All tests
flutter test test/features/auth/               # Auth tests only
flutter test --coverage                         # With coverage

# Clean & Rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

**Test Suite Status:** ✅ 32+ tests covering all 21 API endpoints

**Last Updated:** 2024-01-15

**Maintained by:** GenSpark AI Developer
