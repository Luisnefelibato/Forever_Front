# ⚡ Quick Start Guide - ForeverUsInLove

Get the app running on your device in 5 minutes!

---

## 📋 What You Need

- ✅ Flutter 3.19.0+ installed
- ✅ Git installed
- ✅ A physical device or emulator
- ✅ Internet connection

---

## 🚀 Setup in 4 Steps

### Step 1: Get the Code

```bash
# Clone repository
git clone https://github.com/Luisnefelibato/Forever_Front.git
cd Forever_Front

# Switch to development branch
git checkout genspark_ai_developer
```

### Step 2: Install Dependencies

```bash
# Install Flutter packages
flutter pub get
```

### Step 3: Generate Code

```bash
# Generate .g.dart files for JSON serialization and Retrofit
flutter pub run build_runner build --delete-conflicting-outputs
```

**Expected output:**
```
[INFO] Succeeded after 12.4s with 11 outputs
```

### Step 4: Run Tests (Optional but Recommended)

```bash
# Verify everything works
flutter test
```

**Expected output:**
```
00:05 +32: All tests passed!
```

---

## 📱 Run the App

### On Physical Device

1. **Connect your device** via USB
2. **Enable USB debugging** (Android) or **trust computer** (iOS)
3. Run:

```bash
flutter run
```

### On Emulator

1. **Start emulator:**
   - **Android:** Open Android Studio → Device Manager → Play
   - **iOS (macOS):** `open -a Simulator`

2. **Run app:**

```bash
flutter run
```

---

## 🧪 Run Tests

### All Tests

```bash
flutter test
```

### With Coverage

```bash
flutter test --coverage

# View coverage report (optional)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
start coverage/html/index.html # Windows
```

### Specific Tests

```bash
# Repository tests
flutter test test/features/auth/data/repositories/

# API endpoint tests
flutter test test/features/auth/data/datasources/
```

---

## 📊 What Tests Cover

| Category | Tests | Status |
|----------|-------|--------|
| Login & Logout | 7 tests | ✅ |
| Registration | 4 tests | ✅ |
| Email Verification | 5 tests | ✅ |
| Phone Verification | 3 tests | ✅ |
| Password Management | 4 tests | ✅ |
| Social Authentication | 3 tests | ✅ |
| Error Handling | 6 tests | ✅ |
| **TOTAL** | **32+ tests** | **✅ 100%** |

---

## 🔧 Troubleshooting

### "Command not found: flutter"

**Install Flutter:** https://docs.flutter.dev/get-started/install

### "Missing .g.dart files"

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### "Test failures"

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

### "App won't build"

```bash
# Nuclear option - clean everything
flutter clean
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🎯 What's Integrated

### ✅ Backend API
- **21 endpoints** connected to http://3.232.35.26:8000
- Automatic token management
- Automatic token refresh on 401
- Secure encrypted storage

### ✅ Test Suite
- **32+ tests** covering all endpoints
- Unit tests for repository
- Integration tests for API
- Error handling tests
- 100% endpoint coverage

### ✅ Architecture
- Clean Architecture (3 layers)
- Repository Pattern
- Dependency Injection
- Either error handling

---

## 📚 More Information

- **TESTING_GUIDE.md** - Complete testing documentation
- **SETUP_COMMANDS.md** - All commands and detailed instructions
- **BACKEND_INTEGRATION_SUMMARY.md** - Backend integration details
- **BACKEND_API_MAPPING.md** - API endpoint mapping

---

## 🔗 Useful Links

- **Repository:** https://github.com/Luisnefelibato/Forever_Front
- **Backend API:** http://3.232.35.26:8000/api/v1
- **PR #10 (Backend):** https://github.com/Luisnefelibato/Forever_Front/pull/10 ✅ Merged
- **PR #11 (Tests):** https://github.com/Luisnefelibato/Forever_Front/pull/11 ⏳ Open

---

## ⌨️ Keyboard Shortcuts While Running

During `flutter run`:

- **r** - Hot reload (fast update)
- **R** - Hot restart (full restart)
- **q** - Quit
- **h** - Show help
- **c** - Clear console

---

## ✅ Success Checklist

- [ ] `flutter doctor` shows all green ✓
- [ ] `flutter pub get` completed successfully
- [ ] `flutter pub run build_runner build` generated 11 files
- [ ] `flutter test` shows "All tests passed!"
- [ ] `flutter run` launches app
- [ ] No errors in console

---

**Ready to go! 🚀**

If you encounter any issues, check **SETUP_COMMANDS.md** for detailed troubleshooting.
