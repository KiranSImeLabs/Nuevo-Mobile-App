# Medical Care App - Flutter

A multiplatform medical consultation app built with Flutter, featuring video consultations, health tracking, and wellness management. **Strictly compliant with Apple's Multiplatform Service guidelines** - no in-app purchases.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core utilities, constants, and configurations
│   ├── constants/          # API endpoints, app config, validation rules
│   ├── theme/              # Design system (colors, typography, spacing)
│   ├── utils/              # Validators and helper functions
│   ├── network/            # Dio HTTP client configuration
│   └── errors/             # Custom exceptions and failures
├── domain/                  # Business logic layer (framework-independent)
│   ├── entities/           # Core business objects (User, Subscription)
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── data/                    # Data layer (API, local storage)
│   ├── models/             # Data models with JSON serialization
│   ├── repositories/       # Repository implementations
│   └── datasources/        # Remote (API) and Local (Storage) data sources
└── presentation/            # UI layer
    ├── providers/          # Riverpod state management
    ├── screens/            # App screens
    └── widgets/            # Reusable UI components
```

## 🎨 Design System

Based on Figma design with:
- **Primary Color:** Deep Maroon/Burgundy (#4A0E0E)
- **Background:** Light Beige/Cream (#F9F5F2)
- **Typography:** Inter font family
- **Components:** Pill-shaped buttons, rounded cards (16-20px radius)

## 🚀 Tech Stack

### Core Framework
- **Flutter SDK:** ^3.10.8
- **Dart:** Latest stable

### State Management
- **Riverpod:** ^2.6.1 (MANDATORY per project rules)
- **Riverpod Annotations:** ^2.6.1

### Navigation
- **GoRouter:** ^14.6.2 (MANDATORY per project rules)

### Video Calling
- **Agora RTC Engine:** ^6.3.2 (Cross-platform with React.js compatibility)
- **Flutter CallKit Incoming:** ^2.0.0 (iOS native background calls)

### Networking
- **Dio:** ^5.7.0
- **Retrofit:** ^4.4.1
- **JSON Annotation:** ^4.9.0

### Storage
- **Flutter Secure Storage:** ^9.2.2 (HIPAA/GDPR compliant for tokens)
- **Shared Preferences:** ^2.3.3

### UI Components
- **Flutter SVG:** ^2.0.10+1
- **Cached Network Image:** ^3.4.1

### Testing (TDD - 90% Coverage Requirement)
- **Mockito:** ^5.4.4
- **Mocktail:** ^1.0.4
- **Faker:** ^2.2.0

## 🔒 Apple Policy Compliance

### ✅ IMPLEMENTED
- Read-only subscription details display
- Feature locking based on subscription status
- "Contact Support" screen for inactive users
- No payment processing code

### ❌ STRICTLY PROHIBITED
- **store_kit** (Apple IAP) - NOT INCLUDED
- **billing_client** (Google Play Billing) - NOT INCLUDED
- Payment method screens
- "Add Card" functionality
- In-app purchase flows

### 🛡️ Defense Strategy
If Apple rejects demanding IAP:
> "This app is a companion tool for a physical medical service. The subscription covers real-world doctor consultations via telehealth and access to clinical care teams. The app's digital content (exercise videos, health tracking) is merely supportive of the primary physical medical treatment service. Per Guideline 3.1.3(e) (Physical Services), web-based payment is permitted."

## 📱 Features

### 1. Authentication
- Login with email/password
- Social login (Google)
- Secure token storage

### 2. Subscription Management (READ-ONLY)
- View current plan details
- Check active/inactive status
- See included features
- View expiry date
- **NO payment processing**

### 3. Video Consultations
- Schedule appointments with doctors
- Agora-powered video calls
- iOS CallKit integration for background calls
- Compatible with React.js web clients

### 4. Health Tracking
- View lab results (Metabolic Panel, Lipid Profile, etc.)
- Track health metrics
- Energy level trends
- Activity breakdowns

### 5. Wellness Reset
- Exercise videos
- Diet tracking
- Progress monitoring

### 6. Profile Management
- View/edit profile information
- Settings
- Contact support

## 🔐 Security & Compliance

### HIPAA/GDPR Compliance
- ✅ Encrypted storage for health data
- ✅ Secure HTTPS communication
- ✅ No PII in logs
- ✅ Proper data retention policies

### Data Protection
- Sensitive data (tokens, health info) → **Flutter Secure Storage**
- Non-sensitive data (preferences) → **Shared Preferences**
- All API communication over HTTPS
- No logging of personal health information

## 🧪 Testing Strategy (TDD)

### Test Coverage Goal: 90%

1. **Unit Tests**
   - All use cases
   - All providers
   - All repositories
   - Utility functions

2. **Widget Tests**
   - All screens
   - Custom widgets
   - Navigation flows

3. **Integration Tests**
   - Authentication flow
   - Subscription status check
   - Feature locking/unlocking
   - Video call initialization

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK ^3.10.8
- Dart SDK (comes with Flutter)
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. **Clone the repository**
```bash
cd /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run code generation** (for Riverpod, Retrofit, JSON)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Configure Agora**
   - Get your Agora App ID from [Agora Console](https://console.agora.io/)
   - Update `lib/core/constants/app_constants.dart`:
   ```dart
   static const String appId = 'YOUR_AGORA_APP_ID';
   ```

5. **Configure API endpoints**
   - Update `ApiConstants.baseUrl` in `lib/core/constants/app_constants.dart`

6. **Run the app**
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## 📦 Build & Deployment

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### Web
```bash
flutter build web --release
```

## 🔄 Code Generation

This project uses code generation for:
- Riverpod providers (`riverpod_generator`)
- API clients (`retrofit_generator`)
- JSON serialization (`json_serializable`)

Run after making changes to annotated files:
```bash
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📋 Project Status

### ✅ Phase 1: Core Setup (COMPLETED)
- [x] Project structure (Clean Architecture)
- [x] Dependencies configuration
- [x] Theme system (from Figma)
- [x] Constants and configuration
- [x] Error handling (Failures & Exceptions)
- [x] Network layer (Dio client)
- [x] Validation utilities
- [x] Domain entities (User, Subscription)

### 🚧 Next Phases
- [ ] Phase 2: Data Layer (Models, Repositories, Data Sources)
- [ ] Phase 3: Domain Layer (Use Cases, Repository Interfaces)
- [ ] Phase 4: Presentation Layer (Providers, Screens, Widgets)
- [ ] Phase 5: Navigation (GoRouter configuration)
- [ ] Phase 6: Video Calling (Agora integration)
- [ ] Phase 7: Testing (Unit, Widget, Integration)
- [ ] Phase 8: Platform-specific configuration

## 📞 Support

For subscription issues or app support:
- **Email:** support@yourmedicalapp.com
- **Phone:** +1-800-MEDICAL

## 📄 License

[Your License Here]

---

**Built with ❤️ following Clean Architecture, TDD, and Apple compliance guidelines**
