# Quick Start Guide - Medical Care App

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.10.8 installed
- Dart SDK (comes with Flutter)
- IDE (VS Code or Android Studio)
- iOS: Xcode (for iOS development)
- Android: Android Studio

### Installation

1. **Navigate to project directory**
```bash
cd /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Verify installation**
```bash
flutter doctor
flutter analyze
```

Expected output: `No issues found!`

---

## 📱 Running the App

### iOS
```bash
flutter run -d ios
```

### Android
```bash
flutter run -d android
```

### Web
```bash
flutter run -d chrome
```

---

## 🔧 Configuration Required

### 1. Agora Video Calling Setup

**Get your Agora App ID:**
1. Go to [Agora Console](https://console.agora.io/)
2. Create a new project
3. Copy your App ID

**Update configuration:**
```dart
// File: lib/core/constants/app_constants.dart
// Line: ~60

static const String appId = 'YOUR_AGORA_APP_ID'; // Replace this
```

### 2. API Backend Configuration

**Update base URL:**
```dart
// File: lib/core/constants/app_constants.dart
// Line: ~8

static const String baseUrl = 'https://api.yourmedicalapp.com/v1'; // Replace this
```

### 3. Support Contact Information

**Update support details:**
```dart
// File: lib/core/constants/app_constants.dart
// Line: ~156

static const String supportEmail = 'support@yourmedicalapp.com'; // Replace this
static const String supportPhone = '+1-800-MEDICAL'; // Replace this
```

---

## 🧪 Running Tests

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### View coverage report (requires lcov)
```bash
# Install lcov (macOS)
brew install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

---

## 🔨 Code Generation

This project uses code generation for Riverpod providers, Retrofit API clients, and JSON serialization.

### Run code generation (one-time)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch for changes (continuous)
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

**When to run:**
- After creating new Riverpod providers with `@riverpod` annotation
- After creating/modifying Retrofit API interfaces
- After creating/modifying JSON serializable models

---

## 📂 Project Structure Overview

```
lib/
├── core/                    # Core utilities & configuration
│   ├── constants/          # App constants, API endpoints
│   ├── theme/              # Design system (colors, typography)
│   ├── utils/              # Validators, helpers
│   ├── network/            # Dio HTTP client
│   └── errors/             # Exceptions & failures
│
├── domain/                  # Business logic (framework-independent)
│   ├── entities/           # Core business objects
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
│
├── data/                    # Data layer
│   ├── models/             # Data models (JSON serializable)
│   ├── repositories/       # Repository implementations
│   └── datasources/        # API & local storage
│
└── presentation/            # UI layer
    ├── providers/          # Riverpod state management
    ├── screens/            # App screens
    └── widgets/            # Reusable UI components
```

---

## 🎨 Design System

### Colors
```dart
import 'package:nuevo_app/core/theme/app_theme.dart';

// Usage in widgets
Container(
  color: AppColors.primaryColor,    // #4A0E0E
  child: Text(
    'Hello',
    style: AppTextStyles.h1,         // 32px bold
  ),
)
```

### Spacing
```dart
import 'package:nuevo_app/core/theme/app_theme.dart';

Padding(
  padding: EdgeInsets.all(AppSpacing.lg),  // 16px
  child: ...
)
```

---

## 🔐 Security Best Practices

### Storing Sensitive Data
```dart
// Use Flutter Secure Storage for tokens, health data
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'access_token', value: token);
```

### Storing Non-Sensitive Data
```dart
// Use SharedPreferences for preferences, settings
import 'package:shared_preferences/shared_preferences.dart';

final prefs = await SharedPreferences.getInstance();
await prefs.setBool('is_first_launch', false);
```

### HIPAA/GDPR Compliance
- ✅ Never log PII (Personal Identifiable Information)
- ✅ Never log health data
- ✅ Use secure storage for sensitive data
- ✅ All API calls over HTTPS

---

## 🚫 Apple Policy Compliance

### ❌ STRICTLY PROHIBITED
- **DO NOT** add `store_kit` or `billing_client` packages
- **DO NOT** implement payment screens
- **DO NOT** add "Add Card" functionality
- **DO NOT** create in-app purchase flows

### ✅ ALLOWED
- Read-only subscription details display
- "Contact Support" for subscription issues
- Feature locking based on backend subscription status

---

## 🐛 Common Issues & Solutions

### Issue: "No issues found" but app won't run
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Code generation not working
**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: iOS build fails
**Solution:**
```bash
cd ios
pod install
cd ..
flutter run -d ios
```

### Issue: Android build fails
**Solution:**
```bash
flutter clean
flutter pub get
flutter run -d android
```

---

## 📚 Useful Commands

```bash
# Check Flutter installation
flutter doctor

# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Build release APK (Android)
flutter build apk --release

# Build release IPA (iOS)
flutter build ios --release

# Check for outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade

# Analyze code
flutter analyze

# Format code
dart format lib/

# Clean build artifacts
flutter clean
```

---

## 📖 Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Agora Flutter SDK](https://docs.agora.io/en/video-calling/get-started/get-started-sdk?platform=flutter)
- [Dio Documentation](https://pub.dev/packages/dio)

---

## 🆘 Getting Help

### Support Contacts
- **Email:** support@yourmedicalapp.com
- **Phone:** +1-800-MEDICAL

### Development Issues
- Check `plan.md` for implementation roadmap
- Check `PHASE1_COMPLETE.md` for Phase 1 details
- Check `.cursorrules` for project standards

---

## ✅ Phase 1 Checklist

- [x] Dependencies installed
- [x] Project structure created
- [x] Core constants configured
- [x] Theme system implemented
- [x] Error handling framework
- [x] Network layer setup
- [x] Domain entities created
- [x] Code compiles without errors

**Status: Phase 1 Complete ✅**  
**Next: Phase 2 - Data Layer Implementation**
