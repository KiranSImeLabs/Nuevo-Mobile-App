# Context Summary: OTP Authentication Flow Changes
**Created Date:** 2026-03-25

## Overview
This document summarizes the architectural and UI changes made to transition the application's login and registration processes to an OTP-based authentication system. This effectively replaced the prior password-based requirement.

## Key Changes by Layer

### 1. Data Layer
- **Models (`auth_response_model.dart`)**: 
  - Added `SendOtpRequest` and `VerifyOtpRequest` payload structures.
  - Removed the `password` field from the `RegisterRequest` class.
- **API Interfaces (`api_client.dart` & `app_constants.dart`)**: 
  - Integrated `POST /auth/generate-otp` (`sendOtp`) and `POST /auth/login-otp` (`verifyOtp`) endpoints.

### 2. Domain Layer
- **Repository (`auth_repository.dart` & `auth_repository_impl.dart`)**: 
  - Added `sendLoginOtp` and `verifyLoginOtp` contract methods.
  - Modified the `signup` method footprint to completely exclude password validation.
- **Use Cases (`send_otp_usecase.dart`, `verify_otp_usecase.dart`)**: 
  - Created new Riverpod-compatible callable classes (utilizing the `call` method) to interact with the repository for generating and validating OTPs.
  - Stripped password requirements from `signup_usecase.dart`.

### 3. Presentation Layer State
- **Providers (`auth_provider.dart`, `core_providers.dart`)**: 
  - Injected `sendOtpUseCase` and `verifyOtpUseCase`.
  - Exposed `sendOtp` and `verifyOtp` logic tied to the `AuthState`.
  - **Crucial Rule:** Updated the `signup` logic to automatically and seamlessly authenticate the user upon a `200 Created` response. OTP verification is actively bypassed for new account creations.

### 4. Presentation Layer UI
- **Login Flow (`login_screen.dart`)**: 
  - Replaced the standard Email/Password form with a two-step local state flow (`_isOtpState`).
  - Users input their email first, trigger `sendOtp`, and dynamically switch the UI to collect and submit their `OTP`.
  - Removed "Forgot Password" links and all social login buttons.
- **Registration Flow (`signup_screen.dart`)**: 
  - Removed all "Password" fields and social authentication options.
  - Once the "Create Account" phase finishes, the app considers them fully authenticated.

## Testing & Maintenance Notes
- Unit tests (`auth_repository_impl_test.dart`, `signup_usecase_test.dart`) have been completely refactored to align with the removed password parameters and test the new OTP response handling.
- When modifying the auth data models in the future, remember to run `dart run build_runner build --delete-conflicting-outputs` to regenerate serializers properly.
