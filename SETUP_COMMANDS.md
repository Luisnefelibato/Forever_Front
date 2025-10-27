# 🚀 Setup Commands - ForeverUsInLove Project

Quick reference guide with all commands needed to set up and run the project on your device.

---

## 📋 Prerequisites Check

```bash
# Check Flutter installation
flutter --version
# Expected: Flutter 3.19.0 or higher

# Check Dart installation (comes with Flutter)
dart --version
# Expected: Dart 3.0.0 or higher

# Check if Flutter is properly configured
flutter doctor
# Should show all checkmarks (✓) or provide instructions for missing items

# Check Git installation
git --version
```

---

## 🔽 Initial Setup (First Time Only)

### 1. Clone Repository

```bash
# Clone the repository
git clone https://github.com/Luisnefelibato/Forever_Front.git

# Navigate to project directory
cd Forever_Front
```

### 2. Switch to Development Branch

```bash
# Switch to the branch with backend integration and tests
git checkout genspark_ai_developer

# Pull latest changes
git pull origin genspark_ai_developer
```

### 3. Install Dependencies

```bash
# Install all Flutter dependencies
flutter pub get
```

**Expected Output:**
```
Running "flutter pub get" in Forever_Front...
Resolving dependencies... (X.Xs)
+ dartz 0.10.1
+ dio 5.4.3+1
+ mockito 5.4.4
+ retrofit 4.1.0
  ... (more packages)
Got dependencies!
```

### 4. Generate Code

```bash
# Generate all required .g.dart files
flutter pub run build_runner build --delete-conflicting-outputs
```

**Expected Output:**
```
[INFO] Generating build script...
[INFO] Building new asset graph...
[INFO] Succeeded after 12.4s with 11 outputs:
  - lib/core/network/auth_api_client.g.dart
  - lib/features/auth/data/models/requests/login_request.g.dart
  - lib/features/auth/data/models/requests/register_request.g.dart
  - lib/features/auth/data/models/responses/user_model.g.dart
  - lib/features/auth/data/models/responses/auth_response.g.dart
  ... (7 more files)
```

---

## 🧪 Running Tests

### Run All Tests

```bash
# Run complete test suite
flutter test
```

**Expected Output:**
```
00:05 +32: All tests passed!
```

### Run Specific Test Files

```bash
# Test repository layer
flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart

# Test API endpoints
flutter test test/features/auth/data/datasources/auth_remote_datasource_test.dart

# Test helpers
flutter test test/helpers/test_helper.dart
```

### Run Tests with Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage (macOS/Linux)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# View coverage (Windows)
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

### Run Tests with Detailed Output

```bash
# Verbose mode
flutter test --verbose

# Expanded reporter (shows each test)
flutter test --reporter expanded
```

---

## 📱 Running the App

### On Physical Device

#### iOS (macOS only)

```bash
# List available devices
flutter devices

# Run on connected iPhone/iPad
flutter run

# Or specify device
flutter run -d "iPhone 13"

# Release mode
flutter run --release
```

#### Android

```bash
# List available devices
flutter devices

# Run on connected Android device
flutter run

# Or specify device
flutter run -d "emulator-5554"

# Release mode
flutter run --release
```

### On Emulator/Simulator

#### iOS Simulator (macOS only)

```bash
# Open iOS Simulator
open -a Simulator

# Or use Xcode
# Xcode → Open Developer Tool → Simulator

# Then run app
flutter run
```

#### Android Emulator

```bash
# List available emulators
emulator -list-avds

# Start emulator
emulator -avd Pixel_5_API_33

# Or use Android Studio
# Tools → Device Manager → Play button

# Then run app
flutter run
```

### On Chrome (Web)

```bash
# Run in Chrome
flutter run -d chrome

# Or build for web
flutter build web
cd build/web
python3 -m http.server 8000
# Open http://localhost:8000 in browser
```

---

## 🔧 Development Commands

### Code Generation

```bash
# Generate once
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
flutter pub run build_runner clean
```

### Dependency Management

```bash
# Add new package
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Update all packages
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Code Analysis

```bash
# Analyze code for issues
flutter analyze

# Fix common issues automatically
dart fix --apply

# Format code
dart format .
```

### Clean Build

```bash
# Clean build files
flutter clean

# Reinstall dependencies
flutter pub get

# Regenerate code
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🏗️ Building for Production

### Android APK

```bash
# Build debug APK
flutter build apk

# Build release APK
flutter build apk --release

# Build split APKs per ABI (smaller file size)
flutter build apk --split-per-abi

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Google Play)

```bash
# Build app bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA (macOS only)

```bash
# Build iOS app
flutter build ios --release

# Or build IPA for App Store
flutter build ipa --release

# Output: build/ios/ipa/ForeverUsInLove.ipa
```

### Web

```bash
# Build web app
flutter build web --release

# Output: build/web/
```

---

## 🐛 Debugging Commands

### Run in Debug Mode

```bash
# Run with debug console
flutter run --debug

# Run with verbose logging
flutter run -v

# Run with device logs
flutter run --device-vmservice-port 8888
```

### View Logs

```bash
# View Flutter logs
flutter logs

# View Android logs (adb required)
adb logcat | grep flutter

# View iOS logs (macOS only)
xcrun simctl spawn booted log stream --predicate 'process == "Runner"'
```

### Performance Profiling

```bash
# Run with performance overlay
flutter run --profile

# Generate performance trace
flutter run --trace-startup

# Measure app size
flutter build apk --analyze-size
```

---

## 🔍 Troubleshooting Commands

### Issue: Dependencies not resolving

```bash
flutter clean
rm -rf .dart_tool/
rm pubspec.lock
flutter pub get
```

### Issue: Build errors

```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: iOS build fails (macOS)

```bash
cd ios
pod install
cd ..
flutter clean
flutter build ios
```

### Issue: Android build fails

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter build apk
```

### Issue: Emulator not detected

```bash
# Kill adb server (Android)
adb kill-server
adb start-server

# List devices
flutter devices
```

### Issue: Hot reload not working

```bash
# Stop current run
# Press 'q' in terminal or Ctrl+C

# Clean and restart
flutter clean
flutter pub get
flutter run
```

---

## 📦 Complete Setup Script (Copy & Paste)

### macOS/Linux

```bash
#!/bin/bash

# Navigate to project
cd /path/to/Forever_Front

# Pull latest changes
git checkout genspark_ai_developer
git pull origin genspark_ai_developer

# Clean previous build
flutter clean

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run app
flutter run
```

### Windows (PowerShell)

```powershell
# Navigate to project
cd C:\path\to\Forever_Front

# Pull latest changes
git checkout genspark_ai_developer
git pull origin genspark_ai_developer

# Clean previous build
flutter clean

# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run app
flutter run
```

---

## 🎯 Quick Test Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart

# Run tests matching pattern
flutter test --name "login"

# Run tests with coverage
flutter test --coverage

# Watch mode (re-run on changes - requires fswatch)
flutter test --watch
```

---

## 🌐 Backend Connection Check

```bash
# Check if backend is accessible
curl -v http://3.232.35.26:8000/api/v1/health

# Expected response: 200 OK

# If not accessible:
# 1. Check internet connection
# 2. Verify backend server is running
# 3. Check firewall settings
```

---

## 📱 Device-Specific Commands

### iOS (macOS Required)

```bash
# Check Xcode installation
xcode-select --version

# Install Xcode Command Line Tools (if needed)
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept

# Install CocoaPods (if needed)
sudo gem install cocoapods

# Setup iOS development
flutter doctor --verbose

# Install pods
cd ios && pod install && cd ..

# Run on iOS
flutter run -d ios
```

### Android

```bash
# Check Android SDK
flutter doctor --android-licenses

# Accept all licenses
flutter doctor --android-licenses
# Press 'y' for each license

# Setup Android development
flutter doctor --verbose

# Run on Android
flutter run -d android
```

---

## 🔐 Environment Variables

Create `.env` file in project root (if not exists):

```bash
# Create .env file
cat > .env << EOF
API_BASE_URL=http://3.232.35.26:8000/api/v1
API_TIMEOUT=30000
ENABLE_LOGGING=true
EOF
```

---

## 📊 Useful Shortcuts During Development

While `flutter run` is active:

- `r` - Hot reload (fast update)
- `R` - Hot restart (full restart)
- `h` - Show help
- `c` - Clear console
- `q` - Quit
- `d` - Detach (keep app running)
- `v` - Open DevTools in browser
- `w` - Dump widget hierarchy
- `t` - Dump rendering tree
- `p` - Toggle debug paint (show layout borders)

---

## ✅ Verification Checklist

After running all setup commands, verify:

- [ ] `flutter doctor` shows all green checkmarks
- [ ] `flutter pub get` completes successfully
- [ ] `flutter pub run build_runner build` generates 11 files
- [ ] `flutter test` shows "All tests passed!"
- [ ] `flutter run` launches app on device/emulator
- [ ] App can make API calls to `http://3.232.35.26:8000`
- [ ] No errors in console during app usage

---

## 🆘 Getting Help

### Check Flutter Documentation
```bash
flutter help
flutter help run
flutter help test
flutter help build
```

### Check Package Documentation
```bash
flutter pub deps
flutter pub show package_name
```

### Open Project in IDE
```bash
# VS Code
code .

# Android Studio (macOS)
open -a "Android Studio" .

# IntelliJ IDEA
idea .
```

---

**Last Updated:** 2024-01-15  
**Project:** ForeverUsInLove - Backend Integration  
**Branch:** genspark_ai_developer  
**Backend:** http://3.232.35.26:8000/api/v1
