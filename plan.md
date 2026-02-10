# Medical App Implementation Plan

## Project Overview
Flutter multiplatform medical app with video consultations, health tracking, and wellness features. Strict Apple compliance - NO in-app purchases, subscription management is read-only.

## Architecture: Clean Architecture

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── network/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

## Phase 1: Core Setup & Dependencies

### 1.1 Dependencies (pubspec.yaml)
```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Video Calling
  agora_rtc_engine: ^6.3.0
  permission_handler: ^11.0.0
  
  # iOS CallKit
  flutter_callkit_incoming: ^2.0.0
  
  # Network
  dio: ^5.4.0
  # retrofit removed - using manual implementation
  
  # Storage
  flutter_secure_storage: ^9.0.0
  shared_preferences: ^2.2.0
  
  # UI
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  
dev_dependencies:
  # Code Generation
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
  # retrofit_generator removed
  
  # Testing
  mockito: ^5.4.0
  flutter_test:
    sdk: flutter
```

### 1.2 Folder Structure Creation
- Create all Clean Architecture folders
- Setup barrel exports for each module

## Phase 2: Core Layer

### 2.1 Theme System
- Define color palette (extract from Figma)
- Typography system
- Component themes (buttons, cards, inputs)
- Dark mode support

### 2.2 Constants
- API endpoints
- Route names
- Asset paths
- Error messages

### 2.3 Network Layer
- Dio client setup
- Interceptors (auth, logging)
- Error handling
- Manual ApiClient implementation (Dio)

## Phase 3: Domain Layer

### 3.1 Entities
```dart
// User Entity
class User {
  final String id;
  final String name;
  final String email;
  final SubscriptionStatus subscriptionStatus;
}

// Subscription Entity
class Subscription {
  final String planName;
  final SubscriptionStatus status;
  final DateTime? expiryDate;
  final List<String> features;
}

enum SubscriptionStatus { active, inactive, expired }
```

### 3.2 Repository Interfaces
- AuthRepository
- UserRepository
- SubscriptionRepository
- VideoCallRepository
- HealthTrackingRepository

### 3.3 Use Cases
- LoginUseCase
- GetSubscriptionStatusUseCase
- CheckFeatureAccessUseCase
- InitiateVideoCallUseCase
- GetHealthDataUseCase

## Phase 4: Data Layer

### 4.1 Models (with JSON serialization)
- UserModel
- SubscriptionModel
- HealthDataModel
- VideoCallSessionModel

### 4.2 Data Sources
- Remote: API calls
- Local: Secure storage for tokens

### 4.3 Repository Implementations
- Implement all repository interfaces
- Handle data transformation (Model ↔ Entity)

## Phase 5: Presentation Layer - State Management

### 5.1 Critical Provider: SubscriptionProvider
```dart
@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  Future<Subscription> build() async {
    // Fetch subscription status from API
  }
  
  bool isFeatureUnlocked(String featureName) {
    final subscription = state.value;
    if (subscription?.status == SubscriptionStatus.active) {
      return subscription!.features.contains(featureName);
    }
    return false;
  }
}
```

### 5.2 Other Providers
- AuthProvider
- UserProvider
- VideoCallProvider
- HealthDataProvider

## Phase 6: Navigation (GoRouter)

### 6.1 Route Structure
```dart
GoRouter(
  redirect: (context, state) {
    // Check subscription status
    // Redirect to "Contact Support" if accessing locked features
  },
  routes: [
    GoRoute(path: '/login'),
    GoRoute(path: '/home'),
    GoRoute(path: '/profile'),
    GoRoute(
      path: '/video-consultation',
      redirect: (context, state) {
        // Check if subscription is active
      }
    ),
    GoRoute(
      path: '/wellness-reset',
      redirect: (context, state) {
        // Check if subscription is active
      }
    ),
    GoRoute(path: '/contact-support'),
    GoRoute(path: '/subscription-details'), // READ-ONLY
  ]
)
```

## Phase 7: UI Screens (Based on Figma - Payment Screens EXCLUDED)

### 7.1 Authentication
- [ ] Login Screen
- [ ] Signup Screen (if applicable)
- [ ] Forgot Password

### 7.2 Main Dashboard
- [ ] Home Screen
- [ ] Navigation Bar

### 7.3 Video Consultations
- [ ] Consultation List
- [ ] Video Call Screen (Agora integration)
- [ ] Call History

### 7.4 Wellness Reset
- [ ] Wellness Dashboard
- [ ] Exercise Videos
- [ ] Progress Tracking

### 7.5 Health Tracking
- [ ] Health Metrics Dashboard
- [ ] Data Entry Forms
- [ ] Charts/Visualizations

### 7.6 Profile Section
- [ ] Profile Overview
- [ ] **Subscription Details (READ-ONLY)** ✅
  - Display plan name
  - Display status (Active/Inactive)
  - Display expiry date
  - Display included features
  - NO payment buttons
  - NO "Add Card" option
- [ ] Settings
- [ ] Contact Support Screen

### 7.7 Locked Feature Screen
- [ ] Generic "Contact Support" message
- [ ] NO links to website payment
- [ ] Display support email/phone

## Phase 8: Video Calling Integration

### 8.1 Agora Setup
- Initialize Agora Engine
- Channel naming convention (compatible with React.js web)
- UID generation strategy

### 8.2 iOS CallKit Integration
- Configure CallKit for background calls
- Handle incoming call notifications
- Integrate with Agora

### 8.3 Permissions
- Camera permission
- Microphone permission
- Notification permission
- Graceful permission denial handling

## Phase 9: Security & Compliance

### 9.1 HIPAA/GDPR Compliance
- Encrypt health data at rest
- Secure API communication (HTTPS)
- No PII in logs
- Implement data retention policies

### 9.2 Apple Policy Compliance
- ✅ NO store_kit dependency
- ✅ NO billing_client dependency
- ✅ NO payment UI screens
- ✅ Subscription is read-only
- Marketing copy emphasizes physical medical services

## Phase 10: Testing (TDD - 90% Coverage)

### 10.1 Unit Tests
- [ ] All Use Cases
- [ ] All Providers
- [ ] All Repositories
- [ ] Utility functions

### 10.2 Widget Tests
- [ ] All screens
- [ ] All custom widgets
- [ ] Navigation flows

### 10.3 Integration Tests
- [ ] Authentication flow
- [ ] Subscription status check
- [ ] Feature locking/unlocking
- [ ] Video call initialization

## Phase 11: Platform-Specific Configuration

### 11.1 iOS
- Info.plist permissions
- CallKit configuration
- Agora framework setup

### 11.2 Android
- AndroidManifest.xml permissions
- Agora configuration

### 11.3 Web
- Agora web SDK compatibility
- Responsive design

## Deliverables Checklist

- [ ] ✅ NO features/payments module
- [ ] ✅ Subscription status-based feature locking
- [ ] ✅ Read-only subscription details in profile
- [ ] ✅ Video calling with Agora + CallKit
- [ ] ✅ Health tracking features
- [ ] ✅ 90% test coverage
- [ ] ✅ HIPAA/GDPR compliant
- [ ] ✅ Apple policy compliant

## Risk Mitigation: Apple Rejection Defense

**If rejected for IAP requirement:**

**Response Template:**
> "This application is a companion tool for a physical medical service. The subscription covers:
> - Real-world doctor consultations via telehealth
> - Access to clinical care teams
> - Physical medical treatment and monitoring
> 
> The app's digital content (exercise videos, health tracking) is merely supportive of the primary physical medical treatment service. Per Guideline 3.1.3(e) (Physical Services), web-based payment is permitted."

**Supporting Evidence:**
- Marketing materials emphasize doctors and care teams
- App description focuses on medical consultation service
- Digital content positioned as supplementary to physical care

## Next Steps

1. Review Figma design for UI details
2. Begin Phase 1: Core Setup
3. Implement TDD workflow for each feature
4. Regular verification against this plan
