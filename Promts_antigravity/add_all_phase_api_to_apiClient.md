🚀 ANTIGRAVITY EXECUTION MODE — PHASE APIs INTEGRATION

Project: Flutter Multiplatform (Mobile + Web)

=========================================================
MANDATORY PRE-CHECK
=========================================================

Before implementing any changes:

1. Read PROJECT_CONTEXT.md completely to understand domain logic and architecture.
2. Strictly follow existing coding conventions and project structure.
3. Review the existing ApiClient implementation to ensure:
   - Dio configuration remains unchanged
   - Interceptors and headers are reused
   - Error handling follows the existing pattern
4. Do NOT introduce new networking patterns.
5. Maintain full compatibility with current Riverpod providers and repositories.

=========================================================
OBJECTIVE
=========================================================

Integrate **Phase APIs** into the existing `ApiClient`.

Key constraints:

• Extend the existing ApiClient  
• Follow current Dio configuration and interceptors  
• Follow current response parsing strategy  
• Maintain consistent error handling  
• Do NOT modify existing APIs unless necessary  
• Ensure null-safety and strong typing

=========================================================
BASE API
=========================================================

Base URL already configured in ApiClient.

Endpoint prefix:

/api/v1/phases

=========================================================
APIs TO IMPLEMENT
=========================================================

---------------------------------------------------------
1️⃣ GET PHASE BY ID
---------------------------------------------------------

Endpoint:

GET /api/v1/phases/{phaseId}

Description:
Fetch details of a phase including its tasks.

Example Request:

GET /phases/{phaseId}

Response Structure:

success  
message  
data → Phase object

Phase object contains:

- id
- name
- durationWeeks
- orderIndex
- programType
- totalAppointments
- createdAt
- updatedAt
- phaseTasks[]

Each phaseTask contains:

- id
- phaseId
- taskType
- title
- description
- isMandatory
- questionnaireId
- weekNumberGlobal
- weekNumberInPhase
- isEvenWeekInPhase
- practitioner
- statusOptions[]
- defaultStatus
- points
- orderIndex
- createdAt
- updatedAt


---------------------------------------------------------
2️⃣ GET MY ACTIVE PHASE
---------------------------------------------------------

Endpoint:

GET /phases/my-active-phase

Authorization: Required

Description:
Returns the patient's currently active phase and associated tasks.

Response includes:

data:

phase
tasks[]

phase contains:

- id
- patientId
- phaseId
- startDate
- expectedEndDate
- actualEndDate
- status
- createdAt
- updatedAt
- nested phase info

tasks contain:

- id
- patientId
- patientPhaseId
- phaseTaskId
- status
- completedAt
- weekNumberGlobal
- weekNumberInPhase
- statusValue
- createdAt
- updatedAt
- phaseTask{}


---------------------------------------------------------
3️⃣ GET CURRENT WEEKLY VIEW
---------------------------------------------------------

Endpoint:

GET /phases/my-active-phase/weekly

Authorization: Required

Description:

Returns tasks and progress information for the **current week**.

Response includes:

- currentWeekGlobal
- phaseNumber
- phaseName
- weekInPhase
- isEvenWeek
- tasks[]
- progress
- retainUntil

progress contains:

- completedAppointments
- totalAppointments
- isPhaseComplete


---------------------------------------------------------
4️⃣ GET PHASE PROGRESS
---------------------------------------------------------

Endpoint:

GET /phases/my-active-phase/progress

Authorization: Required

Description:

Returns progress information for the active phase.

Response includes:

- phaseName
- completedAppointments
- totalAppointments
- isPhaseComplete
- percentComplete
- retainUntil


---------------------------------------------------------
5️⃣ GET WEEK VIEW BY NUMBER
---------------------------------------------------------

Endpoint:

GET /phases/my-active-phase/weeks/{weekNumber}

Authorization: Required

Description:

Fetch tasks for a specific week.

Response includes:

- weekNumberGlobal
- phaseNumber
- phaseName
- weekInPhase
- isEvenWeek
- isCurrentWeek
- isReadOnly
- tasks[]


---------------------------------------------------------
6️⃣ GET TASK BY ID
---------------------------------------------------------

Endpoint:

GET /phases/my-active-phase/tasks/{taskId}

Authorization: Required

Description:

Fetch detailed information for a specific task.

Response includes:

- id
- patientId
- patientPhaseId
- phaseTaskId
- status
- completedAt
- weekNumberGlobal
- weekNumberInPhase
- statusValue
- createdAt
- updatedAt
- phaseTask{}


---------------------------------------------------------
7️⃣ MARK TASK COMPLETED
---------------------------------------------------------

Endpoint:

PATCH /phases/my-active-phase/tasks/{taskId}/complete

Authorization: Required

Description:

Marks the given task as completed.

Response returns the updated task object.

Response:
{
    "success": true,
    "message": "Task marked as completed",
    "data": {
        "id": "bbc3a9a2-e2aa-4a05-94e9-99c6704e0ac0",
        "patientId": "f40a7ed1-4ebd-4d37-b75d-b6b29659f2f3",
        "patientPhaseId": "ed0d8d2b-f3a1-4463-903a-3652edae522d",
        "phaseTaskId": "53654fe1-5ad2-4e4f-b486-4d585ab6315e",
        "status": "COMPLETED",
        "completedAt": "2026-03-16T10:58:02.664Z",
        "weekNumberGlobal": 1,
        "weekNumberInPhase": 1,
        "statusValue": "pending",
        "createdAt": "2026-03-13T10:29:58.143Z",
        "updatedAt": "2026-03-16T10:58:02.664Z",
        "phaseTask": {
            "id": "53654fe1-5ad2-4e4f-b486-4d585ab6315e",
            "phaseId": "570e67db-2575-4456-a04d-fd2f05f322eb",
            "taskType": "QUESTIONNAIRE",
            "title": "Pre-session questionnaire — Trainer",
            "description": "Complete the pre-session questionnaire before your Trainer appointment",
            "isMandatory": true,
            "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
            "weekNumberGlobal": 1,
            "weekNumberInPhase": 1,
            "isEvenWeekInPhase": false,
            "practitioner": "TRAINER",
            "statusOptions": [
                "pending",
                "done"
            ],
            "defaultStatus": "pending",
            "points": null,
            "orderIndex": 1,
            "createdAt": "2026-03-12T14:25:38.278Z",
            "updatedAt": "2026-03-12T14:25:38.278Z"
        }
    }
}

Response 2: 
{
    "success": false,
    "message": "Task is already completed"
}

---------------------------------------------------------
8️⃣ UPDATE TASK STATUS
---------------------------------------------------------

Endpoint:

PATCH /phases/my-active-phase/tasks/{taskId}/status

Authorization: Required

Request Body:

{
  "statusValue": "pending"
}

Description:

Updates the status value of the task.

Response returns the updated task summary.

Rsponse:
{
    "success": true,
    "message": "Task marked as completed",
    "data": {
        "id": "bbc3a9a2-e2aa-4a05-94e9-99c6704e0ac0",
        "patientId": "f40a7ed1-4ebd-4d37-b75d-b6b29659f2f3",
        "patientPhaseId": "ed0d8d2b-f3a1-4463-903a-3652edae522d",
        "phaseTaskId": "53654fe1-5ad2-4e4f-b486-4d585ab6315e",
        "status": "COMPLETED",
        "completedAt": "2026-03-16T10:58:02.664Z",
        "weekNumberGlobal": 1,
        "weekNumberInPhase": 1,
        "statusValue": "pending",
        "createdAt": "2026-03-13T10:29:58.143Z",
        "updatedAt": "2026-03-16T10:58:02.664Z",
        "phaseTask": {
            "id": "53654fe1-5ad2-4e4f-b486-4d585ab6315e",
            "phaseId": "570e67db-2575-4456-a04d-fd2f05f322eb",
            "taskType": "QUESTIONNAIRE",
            "title": "Pre-session questionnaire — Trainer",
            "description": "Complete the pre-session questionnaire before your Trainer appointment",
            "isMandatory": true,
            "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
            "weekNumberGlobal": 1,
            "weekNumberInPhase": 1,
            "isEvenWeekInPhase": false,
            "practitioner": "TRAINER",
            "statusOptions": [
                "pending",
                "done"
            ],
            "defaultStatus": "pending",
            "points": null,
            "orderIndex": 1,
            "createdAt": "2026-03-12T14:25:38.278Z",
            "updatedAt": "2026-03-12T14:25:38.278Z"
        }
    }
}

=========================================================
IMPLEMENTATION REQUIREMENTS
=========================================================

The implementation must include:

1️⃣ ApiClient methods for each endpoint.

2️⃣ Strongly typed models for:

- Phase
- PhaseTask
- PatientPhase
- PatientTask
- WeeklyView
- PhaseProgress

3️⃣ Repository layer methods that call ApiClient.

4️⃣ JSON parsing using existing project conventions.

5️⃣ Error handling using the existing response wrapper pattern.

6️⃣ Authorization headers automatically handled by existing Dio interceptors.

=========================================================
DO NOT
=========================================================

❌ Do NOT modify Dio configuration  
❌ Do NOT create a new HTTP client  
❌ Do NOT break existing API implementations  
❌ Do NOT bypass interceptors  
❌ Do NOT duplicate base URL configuration  

=========================================================
EXPECTED OUTPUT
=========================================================

The final implementation must include:

• Updated ApiClient with all Phase API methods  
• Model classes for responses  
• Repository integration  
• Fully typed API responses  
• Null-safe parsing  
• Clean and maintainable code following existing project architecture

=========================================================
SUCCESS CRITERIA
=========================================================

The integration is successful when:

✓ All Phase APIs work through ApiClient  
✓ Existing Dio configuration remains untouched  
✓ Responses map correctly to models  
✓ APIs integrate smoothly with Riverpod state management  
✓ Code compiles without warnings or errors

=========================================================
END OF ANTIGRAVITY PROMPT
=========================================================