🚀 ANTIGRAVITY EXECUTION MODE — NEW OTP LOGIN SCREEN

Project: Flutter Multiplatform (Mobile + Web)

=========================================================
MANDATORY PRE-CHECK
=========================================================

Before implementing any changes:

1. Read PROJECT_CONTEXT.md completely to understand business rules and domain logic.
2. Strictly follow:
   /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules
3. Audit existing architecture:
   - Repository pattern
   - Riverpod provider usage
   - Navigation patterns
   - Dialog implementations
4. Follow DRY principles.
5. Do NOT introduce duplicate widgets.
6. Do NOT deviate from existing architecture.
7. Do NOT refactor unrelated files.

=========================================================
TASK: Add OTP LOGIN SCREEN
=========================================================

- Create a new screen for OTP Login
- Use the existing architecture and patterns
- Provide a retry button for resend otp
- Provide a back button to go back to the login screen

=========================================================
TASK: LOGIN SCREEN UPDATION
=========================================================
Target file: lib/presentation/screens/auth/login_screen.dart
- Remove password field from current Login Screen
- Change login button to get otp button
- Use the existing architecture and patterns
- remove all the code based on password field

=========================================================
TASK: SIGN UP SCREEN UPDATION
=========================================================
Target file: lib/presentation/screens/auth/signup_screen.dart

- Remove password, confirm password field from current Sign Up Screen
- Change SignUP button to get otp button
- Navigate to OTP Login Screen after clicking get otp button
- Use the existing architecture and patterns
- remove all the code based on password field

---------------------------------------------------------
DATA SOURCE REQUIREMENT
---------------------------------------------------------

The Goal list must be obtained using ONE of the following approaches:

OPTION A:
Pass the goal list as a navigation parameter when navigating to this screen.

OR

OPTION B:
Use Riverpod provider:
final goalsState = ref.watch(goalListProvider);

Import:
lib/presentation/providers/goal_provider.dart

Follow whichever approach aligns with the current project navigation pattern.

---------------------------------------------------------
REPOSITORY USAGE
---------------------------------------------------------

Use the existing repository:

GoalRepository:
lib/domain/repositories/goal_repository.dart

Do NOT create new repository layers.

After successful Create or Delete:
→ Update the goal list state for global access.
→ Ensure UI refresh reflects the updated list.

Do NOT use dummy/mock data anywhere.

=========================================================
1️⃣ DELETE GOAL IMPLEMENTATION
=========================================================

Replace existing local deletion logic with API integration.

Use:
GoalRepository().deleteGoal(String id);

Modify:
void _deleteGoal(int index)

Behavior Requirements:
- Trigger delete via confirmation dialog.
- Call Delete Goal API.
- On success:
   ✔ Remove goal from state/provider
   ✔ Refresh UI
- Handle loading & error states appropriately.
- Do not silently fail.

=========================================================
2️⃣ CREATE GOAL IMPLEMENTATION
=========================================================

Replace current local goal creation logic with API integration.

Use:
GoalRepository().createGoal(String goal);

Modify:
void _addNewGoal()

Behavior Requirements:
- Trigger via existing dialog UI.
- Call Create Goal API.
- On success:
   ✔ Add goal to provider/state
   ✔ Refresh UI globally
- Handle loading & error states properly.

=========================================================
STATE MANAGEMENT RULES
=========================================================

- UI must NOT directly mutate lists.
- All updates must go through provider/repository pattern.
- Maintain reactive rebuild behavior.
- Follow existing Riverpod usage style.
- Do not introduce new state management approaches.

=========================================================
EXPECTED OUTCOME
=========================================================

✔ No dummy data remaining
✔ Delete uses API
✔ Create uses API
✔ Global goal list updates correctly
✔ Architecture fully respected
✔ No duplicate widgets introduced
✔ No unrelated refactoring
✔ Clean, maintainable implementation
✔ No regression in existing flows

If uncertain:
→ Inspect similar implemented CRUD screen
→ Mirror structure exactly
→ Maintain consistency

END OF INSTRUCTION