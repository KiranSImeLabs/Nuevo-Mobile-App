🚀 ANTIGRAVITY EXECUTION MODE — YOUR TASKS SCREEN IMPLEMENTATION

Project: Flutter Multiplatform (Mobile + Web)

=========================================================
MANDATORY PRE-CHECK
=========================================================

Before implementing any changes:

1. Read PROJECT_CONTEXT.md completely to understand:
   - Domain logic
   - Business rules
   - API structure
   - Authentication flow

2. Follow strictly:
   - Existing architecture (Repository + Riverpod)
   - Coding standards from .cursorrules
   - Existing UI patterns

3. DO NOT:
   - Introduce new architecture
   - Modify unrelated files
   - Break Riverpod flow
   - Duplicate widgets

4. Maintain DRY principles.

=========================================================
FEATURE OVERVIEW
=========================================================

Implement **YOUR TASKS SCREEN** based on:

- UI Design: `Your Task.png`
- API Source: `getCurrentWeeklyView()`
- Navigation Source:
  your_program_screen.dart → Active Phase Click

=========================================================
DATA SOURCE MAPPING
=========================================================

Use API:
`ApiClient.getCurrentWeeklyView()`

Map response to updated:

### WeeklyViewModel
- currentWeekGlobal
- phaseNumber
- phaseName
- weekInPhase
- isEvenWeek
- tasks
- progress
- retainUntil
- isCurrentWeek (NEW)
- isReadOnly (NEW)

### PatientTaskModel (UPDATED)
Add fields:
- taskName
- taskType
- practitioner
- statusOptions
- defaultStatus
- visualIndicator
- legacyStatus  ✅ IMPORTANT

=========================================================
UI SECTION BREAKDOWN
=========================================================

---------------------------------------------------------
1. HEADER SECTION (FROM PREVIOUS SCREEN)
---------------------------------------------------------

- Title: "Insight Program"
- Subtitle: "Personalised, clinician-guided care"

⚠️ This data is passed from previous screen.
DO NOT refetch.

---------------------------------------------------------
2. CURRENT PHASE / WEEK CARD
---------------------------------------------------------

Populate from WeeklyViewModel:

- Title → phaseName
- Subtitle → "Week: {currentWeekGlobal}/{weekInPhase}"
- Badge → Active

---------------------------------------------------------
3. ACTION REQUIRED SECTION
---------------------------------------------------------

Filter:
`task.legacyStatus == "PENDING"`

Display list items:

Each Task Card:
- Title → taskName
- Subtitle → practitioner
- Right Arrow CTA

UI Behavior:
- Click → Navigate / Open task interaction
- Show indicator based on `visualIndicator`

---------------------------------------------------------
4. COMPLETED TASKS SECTION
---------------------------------------------------------

Filter:
`task.legacyStatus == "COMPLETED"`

Display:

Each Task Card:
- Title → taskName
- Subtitle → practitioner

UI Behavior based on `taskType`:

A. QUESTIONNAIRE
   - Show selected state (Done)

B. APPOINTMENT
   - Buttons:
     - Pending
     - Done
     - Skip

C. ADHERENCE TYPE (if exists)
   - Options:
     - Low
     - Partially
     - Fully

---------------------------------------------------------
5. STATUS UI MAPPING
---------------------------------------------------------

Use:

- statusValue → current selection
- statusOptions → render buttons dynamically
- defaultStatus → initial state

---------------------------------------------------------
6. VISUAL INDICATOR HANDLING
---------------------------------------------------------

- "badge" → show simple tag
- "toggle" → show selectable buttons

=========================================================
STATE MANAGEMENT (RIVERPOD)
=========================================================

- Create provider:
  `weeklyViewProvider`

- Flow:
  API → Repository → Provider → UI

- Use:
  `AsyncValue.when()`

Handle:
- loading → shimmer / placeholders
- error → existing error widget
- data → render UI

=========================================================
MODEL UPDATE RULES
=========================================================

Update existing models ONLY.

DO NOT:
- Create duplicate models
- Break serialization

Ensure:
- fromJson updated correctly
- null safety handled

=========================================================
NAVIGATION RULES
=========================================================

- Entry Point:
  Click on Active Phase (Your Program Screen)

- Task Click:
  Navigate based on taskType:
  - QUESTIONNAIRE → Questionnaire screen
  - APPOINTMENT → Status update interaction

=========================================================
CODE REUSE RULES
=========================================================

- Reuse:
  - Existing Card widgets
  - Button components
  - Typography styles
  - Color system

- DO NOT create new components unless necessary.

=========================================================
EDGE CASES
=========================================================

- Empty tasks list → Show empty state
- All tasks completed → Hide Action Required section
- Read-only week → Disable interactions
- Null fields → Handle gracefully

=========================================================
VALIDATION CHECKLIST
=========================================================

Before completing:

✔ UI matches design exactly  
✔ Correct filtering using legacyStatus  
✔ No architecture violations  
✔ Riverpod flow intact  
✔ API integration follows existing pattern  
✔ No duplicate logic/components  
✔ Navigation works correctly  

=========================================================
IF UNCERTAIN
=========================================================

1. Inspect similar implemented screens
2. Follow same structure
3. Maintain consistency over creativity

=========================================================
END OF EXECUTION
=========================================================