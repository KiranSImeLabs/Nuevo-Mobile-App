🚀 ANTIGRAVITY EXECUTION MODE — Your Task Screen UI
========================================================
MANDATORY PRE-CHECK
========================================================
Before implementing any changes:
Read PROJECT_CONTEXT.md completely to understand domain logic and architecture.
Strictly follow existing coding conventions and project structure.
Review the existing ApiClient implementation to ensure:
Dio configuration remains unchanged
Interceptors and headers are reused
Error handling follows existing patterns
Do NOT introduce new networking patterns.
Maintain full compatibility with existing Riverpod providers and repositories.
========================================================
TASK 1: YOUR PROGRAM SCREEN UPDATE
========================================================
Pass the corresponding phaseId when clicking options in the "Program Phases" section.
Also pass a boolean flag isActive to indicate whether the selected phase is active.
========================================================
TASK 2: YOUR TASK SCREEN UPDATE
========================================================

Design:
 1. HEADER SECTION  (Program Card,Phase Card)-> No change
 2. WEEK NAVIGATION (NEW) 
 3. ACTION REQUIRED SECTION - 
    🔹 Section Header
        Title: Action Required
        Right: Warning Icon (!) 

    🔹 Task Types
        No functional changes required (existing implementation already supports this)
 4. COMPLETED TASKS SECTION - 
    🔹 Section Header
        Title: Completed Tasks
        Right: Green check icon

    🔹 Task Types
        No functional changes required (already dynamically handled)

========================================================
DATA INTEGRATION — STRICT EXECUTION
========================================================
🔹 INITIAL LOAD
getPhaseByIdUseCaseProvider
→ repository.getPhaseById(params.phaseId)
🔹 WEEK DATA
ACTIVE PHASE
fetchCurrentWeek()
INACTIVE PHASE
weekNumber = getPhaseById().phaseTasks.first.weekNumberGlobal
fetchWeekByNumber(weekNumber)
🔹 UI VALUE MAPPING
REPLACE:
weeklyView.currentWeekGlobal
WITH:
getPhaseById().durationWeeks
🔹 FINAL DISPLAY
Week: ${weeklyView.weekInPhase}/${getPhaseById().durationWeeks}
========================================================
WEEK NAVIGATION LOGIC (LOCKED)
========================================================
🔹 PREVIOUS
weekNumber = weeklyView.weekNumberGlobal - 1
Condition: >= 1
🔹 NEXT
weekNumber = weeklyView.weekNumberGlobal + 1
Condition: <= durationWeeks
🔹 INPUT HANDLING
VALIDATION:
1 <= inputValue <= durationWeeks
LOGIC
CASE 1
inputValue < weeklyView.weekInPhase
weekNumber =
weeklyView.weekNumberGlobal
- (weeklyView.weekInPhase - inputValue)
CASE 2
inputValue > weeklyView.weekInPhase
weekNumber =
weeklyView.weekNumberGlobal
+ (inputValue - weeklyView.weekInPhase)
CASE 3
inputValue == weeklyView.weekInPhase
→ NO ACTION
FINAL CALL
fetchWeekByNumber(weekNumber)
========================================================
NON-NEGOTIABLE CONSTRAINTS
========================================================
❌ Do NOT modify business logic
❌ Do NOT refactor providers
❌ Do NOT introduce new widgets unnecessarily
❌ Do NOT break existing navigation
❌ Do NOT replace dynamic rendering with static UI
========================================================
EXPECTED OUTCOME
========================================================
✔ UI matches new design (icon-based cards)
✔ Active phase displayed using API data
✔ No dummy/static data remains
✔ Architecture fully respected
✔ No duplicate widgets introduced
✔ Clean and maintainable code
✔ No regression in existing flows
✔ Proper loading and error handling
========================================================
FAILSAFE INSTRUCTIONS
========================================================
If uncertain at any step:
→ Refer to similar implemented screens (e.g., phases, appointments)
→ Mirror existing structure and patterns exactly
→ Prioritize consistency over creativity
========================================================
END OF EXECUTION
========================================================