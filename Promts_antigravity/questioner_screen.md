


🚀 ANTIGRAVITY EXECUTION PROMPT: QUESTIONNAIRE MODULE
🧩 CONTEXT & DOMAIN

Project: Flutter Multiplatform (Mobile/Web)
Architecture: Repository Pattern + Riverpod State Management
Task: Implement Questionnaire fetching, multi-step UI logic, and submission flow.

🛠 TASK 1: DATA LAYER (API & MODELS)

Implement the following in the existing Data Layer:

Models: Create Questionnaire, Question, and Option models using freezed and json_serializable. Match the provided JSON structure exactly.

API Client: Add two methods to QuestionnaireRepository:

getQuestionnaire(String id): GET /questionnaires/:id

submitQuestionnaire(String patientTaskId, List<QuestionResponse> responses): POST /questionnaires/submit/:patientTaskId

Riverpod: Create a questionnaireProvider(String id) (FutureProvider) and a QuestionnaireNotifier (StateNotifier or AsyncNotifier) to manage the user's current answers and progress index.

🎨 TASK 2: UI IMPLEMENTATION (REFERENCE: Complete task.png)

Screen Path: lib/presentation/screens/questionnaire/questionnaire_screen.dart

Header:

Custom AppBar with back button and "Complete task" title.

Segmented Progress Bar: Generate N segments where N=totalQuestions. Active segments should use the primary theme color (brownish-red).

Info Card: Display the questionnaire title, category (e.g., Dietitian), and estimated time (5 minutes) with the provided asset image.

Question Logic:

Display text of the current question.

Selection Types:

MULTIPLE_CHOICE: Single selection logic.

MULTI_SELECT: Toggle logic for multiple options.

Styling: Outlined containers for options. Highlight selected state with a border and subtle fill.

Navigation Buttons:

Next Question: Update progress index. If last question, change label to "Submit".

Save for Later: Pop the screen or save local draft (if supported by domain logic).

🏁 TASK 3: COMPLETION FLOW (REFERENCE: Task completed.png)

Submission: On "Submit", trigger the submitQuestionnaire API call.

Success Overlay: Upon 200 OK, display a ModalBottomSheet or Dialog as shown in Task completed.png:

Large Checkmark Icon.

Title: "Reset Task completed" (or dynamic title based on task type).

Subtext: "Thank you. Your care team has received your response."

Next Task Button: Navigates back to your_tasks_screen.dart or the next pending task.

⚠️ MANDATORY CONSTRAINTS

DRY Principle: Reuse existing CustomButton or AppCard widgets from the ui_kit.

Riverpod Flow: Do not use setState. All UI state (current question index, selected IDs) must live in a Riverpod provider.

Navigation: Ensure the entry point is wired from your_tasks_screen.dart via the GoRouter (or existing router).

Safety: Handle loading and error states for the API fetch using the existing AsyncValue pattern.









1. Get Questionnaire by ID

   End point: GET /questionnaires/:id

   Request:
    postman request 'https://nuevo-dev-be.simelabs.in/api/v1/questionnaires/41d822c3-8af3-43a6-894d-493c897b7410' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImY0MGE3ZWQxLTRlYmQtNGQzNy1iNzVkLWI2YjI5NjU5ZjJmMyIsImVtYWlsIjoiam9obi5zbWl0aEBleGFtcGxlLmNvbSIsImlhdCI6MTc3MzgzMzAxNiwiZXhwIjoxNzc0NDM3ODE2fQ.oDr3_rgAAvbx2hISn6hiJhP41u9ldn2HTfbeT5Vbk6w'

  Response:
   {
    "success": true,
    "message": "Questionnaire retrieved successfully",
    "data": {
        "id": "41d822c3-8af3-43a6-894d-493c897b7410",
        "title": "Trainer Pre-Session Questionnaire",
        "description": "Complete this questionnaire before every Trainer appointment",
        "type": "TRAINER_PRE_SESSION",
        "createdAt": "2026-03-12T14:25:38.146Z",
        "updatedAt": "2026-03-12T14:25:38.146Z",
        "questions": [
            {
                "id": "27da4cd5-71ca-4c04-8288-546741b69a3e",
                "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
                "text": "How would you rate your energy level today?",
                "type": "MULTIPLE_CHOICE",
                "orderIndex": 1,
                "isRequired": true,
                "createdAt": "2026-03-12T14:25:38.148Z",
                "updatedAt": "2026-03-12T14:25:38.148Z",
                "options": [
                    {
                        "id": "747ebd45-9e25-4e53-8947-30278596858e",
                        "questionId": "27da4cd5-71ca-4c04-8288-546741b69a3e",
                        "text": "Very high",
                        "orderIndex": 1,
                        "createdAt": "2026-03-12T14:25:38.149Z",
                        "updatedAt": "2026-03-12T14:25:38.149Z"
                    },
                    {
                        "id": "802a2695-845b-484e-8432-918155db8276",
                        "questionId": "27da4cd5-71ca-4c04-8288-546741b69a3e",
                        "text": "High",
                        "orderIndex": 2,
                        "createdAt": "2026-03-12T14:25:38.150Z",
                        "updatedAt": "2026-03-12T14:25:38.150Z"
                    },
                    {
                        "id": "4d8307ec-9c6b-4162-8bbc-55729262b00e",
                        "questionId": "27da4cd5-71ca-4c04-8288-546741b69a3e",
                        "text": "Moderate",
                        "orderIndex": 3,
                        "createdAt": "2026-03-12T14:25:38.151Z",
                        "updatedAt": "2026-03-12T14:25:38.151Z"
                    },
                    {
                        "id": "91650fe7-ced8-4cd0-bf0c-be42fe32970b",
                        "questionId": "27da4cd5-71ca-4c04-8288-546741b69a3e",
                        "text": "Low",
                        "orderIndex": 4,
                        "createdAt": "2026-03-12T14:25:38.153Z",
                        "updatedAt": "2026-03-12T14:25:38.153Z"
                    },
                    {
                        "id": "707ccffd-e618-4552-9f7f-0c2275efb4c7",
                        "questionId": "27da4cd5-71ca-4c04-8288-546741b69a3e",
                        "text": "Very low",
                        "orderIndex": 5,
                        "createdAt": "2026-03-12T14:25:38.154Z",
                        "updatedAt": "2026-03-12T14:25:38.154Z"
                    }
                ]
            },
            {
                "id": "88478ce6-03c7-414e-8feb-de8e960a9614",
                "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
                "text": "Are you experiencing any pain or discomfort?",
                "type": "MULTIPLE_CHOICE",
                "orderIndex": 2,
                "isRequired": true,
                "createdAt": "2026-03-12T14:25:38.155Z",
                "updatedAt": "2026-03-12T14:25:38.155Z",
                "options": [
                    {
                        "id": "c4759513-ec73-495c-98b5-d2af88670448",
                        "questionId": "88478ce6-03c7-414e-8feb-de8e960a9614",
                        "text": "No pain",
                        "orderIndex": 1,
                        "createdAt": "2026-03-12T14:25:38.157Z",
                        "updatedAt": "2026-03-12T14:25:38.157Z"
                    },
                    {
                        "id": "96303a8f-3831-42f6-ab87-36175a6626a2",
                        "questionId": "88478ce6-03c7-414e-8feb-de8e960a9614",
                        "text": "Mild discomfort",
                        "orderIndex": 2,
                        "createdAt": "2026-03-12T14:25:38.158Z",
                        "updatedAt": "2026-03-12T14:25:38.158Z"
                    },
                    {
                        "id": "b71c35b0-b74e-452c-93f2-6397ef30844d",
                        "questionId": "88478ce6-03c7-414e-8feb-de8e960a9614",
                        "text": "Moderate pain",
                        "orderIndex": 3,
                        "createdAt": "2026-03-12T14:25:38.160Z",
                        "updatedAt": "2026-03-12T14:25:38.160Z"
                    },
                    {
                        "id": "ae17ee7d-93b1-427c-96e6-58f65eca5ec2",
                        "questionId": "88478ce6-03c7-414e-8feb-de8e960a9614",
                        "text": "Significant pain",
                        "orderIndex": 4,
                        "createdAt": "2026-03-12T14:25:38.161Z",
                        "updatedAt": "2026-03-12T14:25:38.161Z"
                    }
                ]
            },
            {
                "id": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
                "text": "Select any areas of concern for today's session",
                "type": "MULTI_SELECT",
                "orderIndex": 3,
                "isRequired": false,
                "createdAt": "2026-03-12T14:25:38.163Z",
                "updatedAt": "2026-03-12T14:25:38.163Z",
                "options": [
                    {
                        "id": "4dc03e7c-de44-41f8-bcca-75db1098526f",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "Back",
                        "orderIndex": 1,
                        "createdAt": "2026-03-12T14:25:38.165Z",
                        "updatedAt": "2026-03-12T14:25:38.165Z"
                    },
                    {
                        "id": "ed1b6bfc-9a82-4244-99e8-4dc9a77a8af0",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "Knees",
                        "orderIndex": 2,
                        "createdAt": "2026-03-12T14:25:38.166Z",
                        "updatedAt": "2026-03-12T14:25:38.166Z"
                    },
                    {
                        "id": "e429098e-7f0c-49a1-88db-03705acd8505",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "Shoulders",
                        "orderIndex": 3,
                        "createdAt": "2026-03-12T14:25:38.167Z",
                        "updatedAt": "2026-03-12T14:25:38.167Z"
                    },
                    {
                        "id": "2f228ff2-b866-4bce-8816-40e6916669be",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "Neck",
                        "orderIndex": 4,
                        "createdAt": "2026-03-12T14:25:38.168Z",
                        "updatedAt": "2026-03-12T14:25:38.168Z"
                    },
                    {
                        "id": "ea686c9b-7323-4cc9-a9fb-065ebb7bf0c5",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "Hips",
                        "orderIndex": 5,
                        "createdAt": "2026-03-12T14:25:38.170Z",
                        "updatedAt": "2026-03-12T14:25:38.170Z"
                    },
                    {
                        "id": "8cbe5494-a1f2-403b-98ac-7ec90ff3f39a",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "Ankles",
                        "orderIndex": 6,
                        "createdAt": "2026-03-12T14:25:38.171Z",
                        "updatedAt": "2026-03-12T14:25:38.171Z"
                    },
                    {
                        "id": "d8e10905-819f-48cb-8538-abe35b394d01",
                        "questionId": "51edecb9-62b9-453e-aad9-85dd0a97da81",
                        "text": "None",
                        "orderIndex": 7,
                        "createdAt": "2026-03-12T14:25:38.172Z",
                        "updatedAt": "2026-03-12T14:25:38.172Z"
                    }
                ]
            },
            {
                "id": "f53c81ec-3bbd-4b8f-b45f-7be3d0c26750",
                "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
                "text": "How many days did you exercise since your last session?",
                "type": "MULTIPLE_CHOICE",
                "orderIndex": 4,
                "isRequired": true,
                "createdAt": "2026-03-12T14:25:38.174Z",
                "updatedAt": "2026-03-12T14:25:38.174Z",
                "options": [
                    {
                        "id": "ab0ee2b0-82be-45a5-ba0b-65b192804c92",
                        "questionId": "f53c81ec-3bbd-4b8f-b45f-7be3d0c26750",
                        "text": "0 days",
                        "orderIndex": 1,
                        "createdAt": "2026-03-12T14:25:38.175Z",
                        "updatedAt": "2026-03-12T14:25:38.175Z"
                    },
                    {
                        "id": "5f821622-e393-44dc-8160-3210f1ff39f7",
                        "questionId": "f53c81ec-3bbd-4b8f-b45f-7be3d0c26750",
                        "text": "1-2 days",
                        "orderIndex": 2,
                        "createdAt": "2026-03-12T14:25:38.176Z",
                        "updatedAt": "2026-03-12T14:25:38.176Z"
                    },
                    {
                        "id": "1bb577ff-a701-4eb3-b2e2-eb0669d8d266",
                        "questionId": "f53c81ec-3bbd-4b8f-b45f-7be3d0c26750",
                        "text": "3-4 days",
                        "orderIndex": 3,
                        "createdAt": "2026-03-12T14:25:38.180Z",
                        "updatedAt": "2026-03-12T14:25:38.180Z"
                    },
                    {
                        "id": "29e1853d-4706-4407-9d9d-8b03e26f3f90",
                        "questionId": "f53c81ec-3bbd-4b8f-b45f-7be3d0c26750",
                        "text": "5+ days",
                        "orderIndex": 4,
                        "createdAt": "2026-03-12T14:25:38.181Z",
                        "updatedAt": "2026-03-12T14:25:38.181Z"
                    }
                ]
            },
            {
                "id": "79df86ea-9062-4360-a48c-34ec691b8f20",
                "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
                "text": "How well did you sleep last night?",
                "type": "MULTIPLE_CHOICE",
                "orderIndex": 5,
                "isRequired": true,
                "createdAt": "2026-03-12T14:25:38.184Z",
                "updatedAt": "2026-03-12T14:25:38.184Z",
                "options": [
                    {
                        "id": "653c9b6b-1e51-4064-99b6-ab8374a6340f",
                        "questionId": "79df86ea-9062-4360-a48c-34ec691b8f20",
                        "text": "Very well",
                        "orderIndex": 1,
                        "createdAt": "2026-03-12T14:25:38.187Z",
                        "updatedAt": "2026-03-12T14:25:38.187Z"
                    },
                    {
                        "id": "2517e73d-2125-46e6-8382-e7292325b0f4",
                        "questionId": "79df86ea-9062-4360-a48c-34ec691b8f20",
                        "text": "Well",
                        "orderIndex": 2,
                        "createdAt": "2026-03-12T14:25:38.189Z",
                        "updatedAt": "2026-03-12T14:25:38.189Z"
                    },
                    {
                        "id": "2eb9d41c-b062-4e4c-8f20-8e1ddf7b62ee",
                        "questionId": "79df86ea-9062-4360-a48c-34ec691b8f20",
                        "text": "Average",
                        "orderIndex": 3,
                        "createdAt": "2026-03-12T14:25:38.193Z",
                        "updatedAt": "2026-03-12T14:25:38.193Z"
                    },
                    {
                        "id": "197935c1-5d90-4f30-98bd-f710979d2b37",
                        "questionId": "79df86ea-9062-4360-a48c-34ec691b8f20",
                        "text": "Poorly",
                        "orderIndex": 4,
                        "createdAt": "2026-03-12T14:25:38.194Z",
                        "updatedAt": "2026-03-12T14:25:38.194Z"
                    },
                    {
                        "id": "e8c469f2-0e8e-4ccb-9be4-6cc22ab25d8a",
                        "questionId": "79df86ea-9062-4360-a48c-34ec691b8f20",
                        "text": "Very poorly",
                        "orderIndex": 5,
                        "createdAt": "2026-03-12T14:25:38.198Z",
                        "updatedAt": "2026-03-12T14:25:38.198Z"
                    }
                ]
            },
            {
                "id": "6670939f-2152-422a-996d-512d06db641e",
                "questionnaireId": "41d822c3-8af3-43a6-894d-493c897b7410",
                "text": "Is there anything specific you want to focus on today?",
                "type": "MULTIPLE_CHOICE",
                "orderIndex": 6,
                "isRequired": true,
                "createdAt": "2026-03-12T14:25:38.200Z",
                "updatedAt": "2026-03-12T14:25:38.200Z",
                "options": [
                    {
                        "id": "ed0097e0-d0a7-4495-a77d-dc39953c67d6",
                        "questionId": "6670939f-2152-422a-996d-512d06db641e",
                        "text": "Strength training",
                        "orderIndex": 1,
                        "createdAt": "2026-03-12T14:25:38.201Z",
                        "updatedAt": "2026-03-12T14:25:38.201Z"
                    },
                    {
                        "id": "81be5a4a-fc8a-4381-9936-36bda9bd828a",
                        "questionId": "6670939f-2152-422a-996d-512d06db641e",
                        "text": "Cardio",
                        "orderIndex": 2,
                        "createdAt": "2026-03-12T14:25:38.202Z",
                        "updatedAt": "2026-03-12T14:25:38.202Z"
                    },
                    {
                        "id": "2fc81740-76df-419a-83dc-081989546cc5",
                        "questionId": "6670939f-2152-422a-996d-512d06db641e",
                        "text": "Flexibility",
                        "orderIndex": 3,
                        "createdAt": "2026-03-12T14:25:38.203Z",
                        "updatedAt": "2026-03-12T14:25:38.203Z"
                    },
                    {
                        "id": "790bf3ac-29fa-45c0-8584-f45e54c04d4e",
                        "questionId": "6670939f-2152-422a-996d-512d06db641e",
                        "text": "Recovery",
                        "orderIndex": 4,
                        "createdAt": "2026-03-12T14:25:38.205Z",
                        "updatedAt": "2026-03-12T14:25:38.205Z"
                    },
                    {
                        "id": "fa2ae773-db7d-482f-8210-81934cc9d44e",
                        "questionId": "6670939f-2152-422a-996d-512d06db641e",
                        "text": "General fitness",
                        "orderIndex": 5,
                        "createdAt": "2026-03-12T14:25:38.206Z",
                        "updatedAt": "2026-03-12T14:25:38.206Z"
                    }
                ]
            }
        ]
    }
}

2. Submit Questionnaire Responses

 Endpoint: /questionnaires/submit/:patientTaskId
Request:
  postman request POST 'http://localhost:3000/api/v1/questionnaires/submit/:patientTaskId' \
  --header 'Content-Type: application/json' \
  --body '{
  "responses": [
    {
      "questionId": "question-uuid",
      "selectedOptionIds": ["option-uuid-1"],
      "textAnswer": null
    },
    {
      "questionId": "question-uuid-2",
      "selectedOptionIds": [],
      "textAnswer": "My free-text answer"
    }
  ]
}'