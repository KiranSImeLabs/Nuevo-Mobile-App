# Nuevo App - Project Context

## 📱 Project Overview
**Name:** Nuevo Mobile App  
**Goal:** Multiplatform medical app for personalized care programs.  
**Compliance:** HIPAA/GDPR, Apple Safe (Read-only subscriptions).

## 🛠 Tech Stack
- **Framework:** Flutter (Mobile/Web/Desktop)
- **State Management:** Riverpod (StateNotifier, FutureProvider)
- **Navigation:** GoRouter
- **Networking:** Dio with Interceptors
- **Local Storage:** FlutterSecureStorage & SharedPreferences
- **Design:** Custom "Deep Maroon" implementation of Figma designs.

## 📅 Current Status
**Phase:** 4 (Presentation Layer Implementation) - **IN PROGRESS**

### ✅ Completed
1.  **Domain Layer:**
    - defined Entities, Repositories, and UseCases for Auth, User, and Subscription.
    - 100% Test Coverage for Domain Logic.

2.  **Data Layer:**
    - Repositories implemented with `ApiClient` and `LocalDataSource`.
    - Token management (Access/Refresh) securely handled.

3.  **Presentation Layer (Setup):**
    - `GoRouter` configured with Auth Guards.
    - Riverpod Providers (`AuthProvider`, `UserProvider`, `SubscriptionProvider`) setup.
    - **UI Implemented:**
        - Splash Screen
        - **Login Screen** (Visuals matched to design)
        - **Signup Screen** (Visuals matched to design)
        - Home Screen (Dashboard Skeleton)

### 🚧 Pending / In Progress
- [ ] **Video Consultation:** Agora SDK Integration.
- [ ] **Profile Edit:** User profile update screen.
- [ ] **Real Integration:** Verify API endpoints connectivity.
- [ ] **Unit Tests:** Widget testing for new screens.

## 📝 Recent Changes (Session 2026-02-06)
- **Login UI Redesign:** Implemented modern visuals (Pill buttons, social auth, password visibility).
- **Signup UI Redesign:** Added Confirm Password, Terms checkbox, matches Login aesthetic.
- **Git Init:** Repository initialized, `dev` branch active.

## 🔗 Repository
**Remote:** `https://github.com/KiranSImeLabs/Nuevo-Mobile-App.git`
**Branch:** `dev`
