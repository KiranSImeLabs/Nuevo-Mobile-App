\🚀 ANTIGRAVITY EXECUTION MODE — Update Your Phase UI

Project: Flutter Multiplatform (Mobile + Web)

=========================================================
MANDATORY PRE-CHECK
=========================================================

Before implementing any changes:

1. Read PROJECT_CONTEXT.md completely to understand:
   - Domain logic
   - Business rules
   - Data flow constraints

2. Strictly follow coding standards defined in:
   /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules

3. Enforce DRY principles:
   - Reuse existing widgets
   - Avoid duplicate UI/components
   - Audit before creating anything new

4. Do NOT:
   - Introduce duplicate UI structures
   - Modify unrelated files
   - Break existing architecture patterns


=========================================================
TASK: Update "Your Phase" Screen UI
=========================================================

Target File:
lib/presentation/screens/home/your_program_screen.dart

Objective:

- Update UI to display the **active phase dynamically**
- Replace any existing dummy/static data

API to use:
PhaseRepositoryImpl().getMyActivePhase()

Requirements:

- Fetch active phase via repository
- Bind response to UI reactively
- Ensure UI reflects real backend data
- Handle loading, success, and error states properly


=========================================================
STATE MANAGEMENT RULES
=========================================================

- Follow existing Riverpod implementation strictly
- UI must remain declarative and reactive
- DO NOT mutate lists or state directly in UI
- All data updates must flow through:
  Provider → Repository → API

- Maintain consistency with:
  - Existing providers
  - Async state handling (`when`, `AsyncValue`, etc.)

- Do NOT introduce:
  - New state management solutions
  - Local state hacks


=========================================================
IMPLEMENTATION GUIDELINES
=========================================================

1. Identify existing provider handling phases (if available)
2. If already exists:
   → Extend it to support active phase
3. If not:
   → Create provider following existing pattern ONLY

4. UI Behavior:
   - Show loading skeleton/placeholders
   - Show active phase data when available
   - Gracefully handle empty/null state
   - Show error UI if API fails

5. Component Reuse:
   - Reuse existing phase cards/widgets
   - Do not rebuild UI components from scratch

6. Maintain:
   - Responsive design
   - Platform consistency (Mobile + Web)


=========================================================
EXPECTED OUTCOME
=========================================================

✔ Active phase displayed from API  
✔ No dummy/static data remaining  
✔ Architecture fully respected  
✔ No duplicate widgets introduced  
✔ Clean and maintainable code  
✔ No regression in existing flows  
✔ Proper loading & error handling  

=========================================================
FAILSAFE INSTRUCTIONS
=========================================================

If uncertain at any step:

→ Inspect similar implemented screens (e.g., phases, appointments)  
→ Mirror structure and patterns exactly  
→ Prioritize consistency over creativity  

=========================================================
END OF EXECUTION
=========================================================