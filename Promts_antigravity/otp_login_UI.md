# 🚀 ANTIGRAVITY EXECUTION MODE — OTP Login & Registration Flow

Project: Flutter Multiplatform (Mobile + Web)

---

## MANDATORY PRE-CHECK

Before implementing anything:

1. Read PROJECT_CONTEXT.md to understand domain logic, business rules, and constraints.
2. Strictly follow all coding rules defined in:
   /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules
3. Follow DRY principles. Avoid duplicate widgets and logic.
4. Do NOT deviate from existing architecture.
5. Do NOT refactor unrelated files.

Audit existing architecture:

* Repository pattern
* Riverpod provider usage
* Navigation patterns
* Dialog/snackbar implementations

---

## TASK 1: API CLIENT UPDATES

### 1. Send Auth OTP

Endpoint: `/auth/generate-otp`
Method: POST

Request Body:

```
{
  "bookingId": "",
  "purposeType": "auth",
  "userMail": "user@example.com"
}
```

Response:

```
{
  "success": true,
  "message": "If the user exists, an OTP has been sent to their email",
  "data": {}
}
```

---

### 2. Auth OTP Verification

Endpoint: `/auth/login-otp`
Method: POST

Request Body:

```
{
  "email": "user@example.com",
  "otp": "123456",
  "purposeType": "login"
}
```

Response:

```
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {...},
    "token": "JWT_TOKEN"
  }
}
```

---

### 3. Registration API

* Already implemented in APIClient
* Remove password field from request model

---

### ⚠️ IMPORTANT API NOTES

* Send OTP API uses `userMail`

* Verify OTP API uses `email`

* Use correct field mapping in models

* Use `purposeType = "auth"` for OTP generation

* Use `purposeType = "login"` for OTP verification

---

## TASK 2: LOGIN UI UPDATE

Target Path:
`lib/presentation/screens/auth/login_screen.dart`

### UI Flow

1. Initial State:

   * Show only Email field
   * Button text: "Continue"

2. On Continue Click:

   * Validate email
   * Call Send OTP API
   * Move to OTP state

3. OTP State:

   * Show OTP input field
   * Button text: "Verify OTP"
   * Show "Change Email" option

4. On Verify OTP Click:

   * Validate OTP
   * Call OTP Verification API

5. Change Email:

   * Clear OTP
   * Navigate back to email input state

---

### UI Changes

* Remove Social login buttons
* Remove Forgot Password option

---

### State Handling

* Show loading indicator during API calls
* Disable button while API is in progress
* Handle errors using existing dialog/snackbar system

---

### Success Handling

* Save token using existing secure storage mechanism
* Navigate to Home/Dashboard screen

---

## TASK 3: REGISTER UI UPDATE

Target Path:
`lib/presentation/screens/auth/signup_screen.dart`

### UI Changes

* Remove password fields
* Keep remaining flow unchanged
* Remove Social login buttons
* Remove Forgot Password option

---

### Flow

1. User enters details (no password)
2. Click "Create Account"

   * Call Registration API
3. On success:

   * Trigger OTP flow
4. Verify OTP using Auth OTP Verification API
5. Navigate to Home/Dashboard

---

### State Handling

* Show loading indicator during API calls
* Disable button while API is in progress
* Handle errors using existing dialog/snackbar system

---

## IMPLEMENTATION REQUIREMENTS

Ensure the following:

* Proper model mapping
* Retrofit/Dio configuration follows existing project pattern
* API responses use existing ApiResponse model
* Maintain architecture consistency

---

## FLOW SUMMARY

### Login Flow

1. Enter Email
2. Click Continue → Send OTP
3. Enter OTP
4. Click Verify → Verify OTP
5. Navigate to Home

### Register Flow

1. Enter Details
2. Click Create Account → Register API
3. Trigger OTP
4. Verify OTP
5. Navigate to Home

---

## IF UNCERTAIN

1. Inspect similar implemented screens
2. Mirror structure exactly
3. Maintain architectural consistency

---

## END OF INSTRUCTION