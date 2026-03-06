Flutter Multiplatform Task: Goals & My Plan Integration

You are working on a Flutter (Mobile + Web) project.

⚠️ IMPORTANT:
Before implementing anything:

1. Read PROJECT_CONTEXT.md to understand domain logic, business rules, and constraints.
2. Strictly follow all coding rules defined in:
   /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules
3. Follow DRY principles. Audit existing widgets before creating new ones.
4. Do NOT introduce duplicate UI components or architecture deviations.

--------------------------------------------------
TASK 1: API CLIENT UPDATES
--------------------------------------------------

Add the following endpoints to the existing API client:

1. Fetch All Goals
   GET /api/v1/goals

2. Create Goal
   POST /api/v1/goals
   Body:
   {
     "goal": "Fitness Goal"
   }

3. Fetch Goal by ID
   GET /api/v1/goals/:id

4. Update Goal
   PUT /api/v1/goals/:id
   Body:
   {
     "goal": "Updated Goal Name"
   }

5. Delete Goal
   DELETE /api/v1/goals/:id

Ensure:
- Proper model mapping
- Retrofit/Dio configuration follows existing project pattern
- API responses are wrapped using the existing ApiResponse model
- No hardcoded tokens
- Error handling matches current architecture

--------------------------------------------------
TASK 2: MY PLAN SCREEN INTEGRATION
--------------------------------------------------

File:
lib/presentation/screens/my_plan/my_plan_screen.dart

A. Program Section

Populate the first section card using:

HomeDashboardModel().yourProgram

From:
lib/presentation/providers/home_provider.dart

Do not use dummy data.

--------------------------------------------------

B. Fetch Data Asynchronously

Trigger these APIs:

1. Fetch User Goals
2. Fetch Specialists:
   ref.read(specialistListProvider.notifier).fetchSpecialists();

--------------------------------------------------

C. Populate UI Sections

- "Your Care Team" → Use fetchSpecialists() response
- "Your Goals" → Use Fetch User Goals API response

Remove all dummy/mock data currently used in this screen.

--------------------------------------------------

D. Independent Rendering (CRITICAL)

Do NOT wait for both APIs to complete before rendering.

Each section must load independently.

Use:
- FutureBuilder
OR
- Riverpod AsyncValue
OR
- Existing reactive pattern already used in the project

The UI must:
- Render Care Team immediately when specialists load
- Render Goals immediately when goals load
- Handle loading & error states per section

--------------------------------------------------
EXPECTED OUTCOME
--------------------------------------------------

✔ API client updated with full Goal CRUD support
✔ My Plan screen fully API-driven
✔ No dummy data remaining
✔ Independent async rendering
✔ Architecture compliance maintained
✔ No duplicate widgets
✔ Clean, maintainable code

Follow existing folder structure and architecture strictly.
Do not refactor unrelated files.
Do not break existing flows.