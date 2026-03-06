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

1. Fetch All phases
   GET /api/v1/phases

Req:
postman request 'https://nuevo-medical-be.simelabs.in/api/v1/phases' \
  --header 'Accept: application/json'

Res:
{
    "success": true,
    "message": "Phases retrieved successfully",
    "data": [
        {
            "id": "851f3677-9497-44e2-a068-5b2bb06c2375",
            "name": "Assess",
            "durationWeeks": 4,
            "orderIndex": 1,
            "programType": "FOUNDATION",
            "createdAt": "2026-03-03T09:01:50.055Z",
            "updatedAt": "2026-03-03T09:01:50.055Z"
        },
        {
            "id": "6b90012c-6571-46d5-98e3-3009bf887aa5",
            "name": "Reset",
            "durationWeeks": 6,
            "orderIndex": 2,
            "programType": "FOUNDATION",
            "createdAt": "2026-03-03T11:18:44.984Z",
            "updatedAt": "2026-03-03T11:18:44.984Z"
        },
        {
            "id": "e800d1be-44d4-469d-9f2c-9ae88429c103",
            "name": "Elevate",
            "durationWeeks": 10,
            "orderIndex": 3,
            "programType": "FOUNDATION",
            "createdAt": "2026-03-03T11:18:45.063Z",
            "updatedAt": "2026-03-03T11:18:45.063Z"
        },
        {
            "id": "4dfe1099-fd79-4e80-b63b-39af29976d6a",
            "name": "Sustain",
            "durationWeeks": 36,
            "orderIndex": 4,
            "programType": "FOUNDATION",
            "createdAt": "2026-03-03T11:18:45.073Z",
            "updatedAt": "2026-03-03T11:18:45.073Z"
        }
    ]
}

Ensure:
- Proper model mapping
- Retrofit/Dio configuration follows existing project pattern
- API responses are wrapped using the existing ApiResponse model
- No hardcoded tokens
- Error handling matches current architecture

--------------------------------------------------
TASK 2: YOUR PLAN SCREEN INTEGRATION AND MY PLAN SCREEN INTEGRATION
--------------------------------------------------

File:
lib/presentation/screens/home/your_program_screen.dart - YOUR PLAN SCREEN
lib/presentation/screens/my_plan/my_plan_screen.dart - MY PLAN SCREEN

A. Program Section

Populate the phase section using the fetch all phases API.

Do not use dummy data.

--------------------------------------------------

B. Fetch Data Asynchronously

Trigger fetch all phases API while loading Asynchronously.

--------------------------------------------------

C. Populate UI Sections

Use dummy data while loading the phases.

--------------------------------------------------

D. Independent Rendering (CRITICAL)

Do NOT wait for APIs to complete before rendering.

Each section must load independently.

Use:
- FutureBuilder
OR
- Riverpod AsyncValue
OR
- Existing reactive pattern already used in the project

The UI must:
- Render Phases immediately when phases load





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