# Google and Apple Sign-In Integration Summary

**Created / Updated:** March 10, 2026

This document serves as a historical context and reference for the integration of Google and Apple Sign-In within the `nuevo_app` Flutter application.

## 🎯 Goal
Connect the existing, partially implemented Google and Apple SDK sign-in flows to the backend using specific authentication endpoints, preserving the current architecture and without introducing duplicate UI components or separate auth flows.

## 🚀 Key Implementation Details

1. **Authentication Flow Strategy**:
   - The Flutter client's responsibility is solely to retrieve the OAuth token (specifically `accessToken` for Google and `identityToken` for Apple) from their respective SDKs.
   - The token is then sent to the backend for validation, user creation (if necessary), and session generation.
   - The backend response follows the exact same structure as the standard email/password login flow.

2. **API Configuration (`app_constants.dart`)**:
   - Added two new endpoints to `ApiConstants`:
     - `googleLogin = '/auth/register-or-login-google'`
     - `appleLogin = '/auth/register-or-login-apple'`

3. **API Client Layer (`api_client.dart`)**:
   - Added corresponding methods to directly POST to the backend:
     - `googleLogin(String token)`: Sends `{'token': token}`.
     - `appleLogin({required String token, String? firstName, String? lastName, String? email})`: Sends `token` and optionally includes user details. This optional inclusion mirrors Apple's behavior of providing user data (like name and email) only on the *first* login.

4. **Data Repository Layer (`auth_repository_impl.dart`)**:
   - Replaced mock representations with real SDK-to-API links.
   - **Google Sign-In**:
     - Utilizing `GoogleSignIn` to authenticate and extract the `accessToken` via `googleAuth.accessToken`.
     - Passes this token natively through `_apiClient.googleLogin(accessToken)`.
   - **Apple Sign-In**:
     - Utilizing `SignInWithApple` to authenticate and extract the `identityToken` alongside user profile details (`givenName`, `familyName`, `email`).
     - Passes these securely through `_apiClient.appleLogin(...)`.
   - **Response Handling**:
     - Both methods seamlessly convert the `ApiResponse` containing user and token data, save the generated JWT session token to local secure storage via `_localDataSource`, and return the domain-level `User` entity, perfectly adhering to the repository pattern employed globally.

## 💡 Important Notes & Considerations
- **Apple First-Login Behavior**: Apple's API specification notes that user-identifiable data (`firstName`, `lastName`, `email`) is typically only provided upon the initial authorization. Subsequent logins usually only generate a raw identity token. The `appleLogin` API call safely structures the payload to omit these optionally when Apple drops them from the credential response.
- **Consistency**: Both SDK sign-ins leverage the centralized `_localDataSource.saveAccessToken(...)` to maintain standard App token state, ensuring subsequent authenticated API requests succeed natively without any isolated OAuth-specific session logic.

## ✅ Files Modified
- `lib/core/constants/app_constants.dart`
- `lib/data/datasources/remote/api_client.dart`
- `lib/data/repositories/auth_repository_impl.dart`

*(The original `Google-Apple-Sigin.md` specification file has been removed/replaced by this summary)*
