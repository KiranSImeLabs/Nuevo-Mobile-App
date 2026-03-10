🚀 ANTIGRAVITY EXECUTION MODE — GOOGLE & APPLE SIGN-IN IMPLEMENTATION

Project: Flutter Multiplatform (Mobile + Web)

=========================================================
MANDATORY PRE-IMPLEMENTATION CHECKS
=========================================================

Before making ANY changes, you MUST complete the following:

1. Read **PROJECT_CONTEXT.md** completely to understand:
   - Domain logic
   - Authentication flow
   - Business rules
   - Existing API integrations

2. Strictly follow all coding rules defined in:

/Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules

3. Audit the existing project architecture before implementing anything:
   - Repository pattern usage
   - Riverpod provider structure
   - API client usage
   - Navigation patterns
   - Dialog / error handling patterns

4. Follow **DRY principles**.

5. DO NOT:
   - Introduce duplicate widgets
   - Break the existing architecture
   - Change unrelated files
   - Refactor unrelated logic
   - Create parallel authentication flows

6. Only extend the **existing authentication architecture**.

=========================================================
TASK
=========================================================

Implement **Google Sign-In** and **Apple Sign-In** integration.

⚠️ IMPORTANT:

The Google and Apple sign-in code is **already partially implemented**.

You MUST:

• Review the existing implementations  
• Modify code **ONLY if required**  
• Preserve the current architecture  

=========================================================
FILES TO MODIFY (ONLY IF NECESSARY)
=========================================================

lib/presentation/screens/auth/login_screen.dart  
lib/presentation/screens/auth/signup_screen.dart  

Do NOT modify any other files unless absolutely required.

=========================================================
AUTHENTICATION FLOW REQUIREMENT
=========================================================

The client application should **ONLY retrieve the OAuth token** from the SDK.

The client must NOT perform authentication verification.

The retrieved token must be sent to the backend.

The backend will handle:

• Token validation  
• User creation  
• User login  

=========================================================
GOOGLE SIGN-IN
=========================================================

1. Retrieve **Google access token** using the Google SDK.

2. Send the token to backend.

Endpoint:

auth/register-or-login-google

Request Body:

{
  "token": "{{googleToken}}"
}

=========================================================
APPLE SIGN-IN
=========================================================

1. Retrieve **Apple identity token** using the Apple Sign-In SDK.

2. Send the token to backend.

Endpoint:

auth/register-or-login-apple

Request Body:

{
  "token": "{{appleToken}}",
  "firstName": "",
  "lastName": "",
  "email": ""
}

=========================================================
IMPORTANT APPLE SIGN-IN BEHAVIOR
=========================================================

According to Apple documentation:

Apple provides user details such as:

• firstName  
• lastName  
• email  

ONLY during the **first login**.

Subsequent logins may return **only the token**.

You MUST verify:

1. Whether the Apple SDK automatically persists this data.
2. If not, ensure the client stores required values safely.
3. Ensure API requests contain the required fields when available.

Do NOT introduce insecure storage mechanisms.

=========================================================
API RESPONSE CONTRACT
=========================================================

The response from Google and Apple login APIs is **identical to the normal email/password login API**.

Therefore the client must **reuse the same authentication response handling logic** already implemented for the standard login.

Example Response:

{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "6f2c1c73-adff-4453-a17d-d36e33c89ddd",
      "email": "remyakrishnan605@gmail.com",
      "firstName": "remya",
      "lastName": "krishnan",
      "createdAt": "2026-03-10T04:54:55.289Z"
    },
    "token": "JWT_TOKEN"
  }
}

Client MUST:

• Extract `token`  
• Save authentication token using the same mechanism used in normal login  
• Store user data using the same model  
• Continue the same post-login navigation flow  

Do NOT create a separate auth flow for Google or Apple login.

=========================================================
IMPLEMENTATION RULES
=========================================================

1. Reuse existing widgets where possible.

2. Maintain consistency with:

   • Riverpod providers  
   • API client usage  
   • Error handling  
   • Dialog UI patterns  

3. Ensure both flows work for:

   • Login screen  
   • Signup screen  

4. Do NOT duplicate OAuth button widgets.

5. If a shared OAuth button component exists, reuse it.

=========================================================
FINAL VERIFICATION
=========================================================

Before completing the task, ensure:

✓ Google Sign-In retrieves token successfully  
✓ Apple Sign-In retrieves token successfully  
✓ API request matches backend contract  
✓ API response is handled using the existing login logic  
✓ Token storage works correctly  
✓ No architecture rules were violated  
✓ No unrelated files were modified  
✓ No duplicate widgets were introduced


Create a new .md file in context folder which contain the context summary of this converstion for future uses.