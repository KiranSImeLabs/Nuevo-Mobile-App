# 🚀 ANTIGRAVITY EXECUTION MODE --- Appointments API Integration

**Project:** Flutter Multiplatform (Mobile + Web)

------------------------------------------------------------------------

# MANDATORY PRE-CHECK

Before implementing any changes:

1.  Read **PROJECT_CONTEXT.md** completely to understand business rules
    and domain logic.
2.  Strictly follow:

/Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules

3.  Audit existing architecture:

-   Repository pattern
-   Riverpod provider usage
-   Navigation patterns
-   Dialog implementations

4.  Follow **DRY principles**
5.  **Do NOT introduce duplicate widgets**
6.  **Do NOT deviate from existing architecture**
7.  **Do NOT refactor unrelated files**

------------------------------------------------------------------------

# TASK 1 --- API CLIENT UPDATES

Add the following endpoints to the **existing API client**.

------------------------------------------------------------------------

# 1. Create Appointment

### Endpoint

POST /api/v1/bookings/appointment

### Request (Postman)

POST http://localhost:3000/api/v1/bookings/appointment

Headers: Authorization: Bearer `<TOKEN>`{=html} Content-Type:
application/json

### Body

``` json
{
  "locationId": "1ef7a5aa-2e47-4b89-af77-d306466bae9d",
  "date": "2026-10-17",
  "time": "12:00",
  "programId": "ceb9ff63-bd42-447b-aed6-bb0471b5342d",
  "patientId": "3e26f22e-9fa1-42c5-b66c-c55a495da17e"
}
```

### Response

``` json
{
  "success": true,
  "message": "Appointment created successfully",
  "data": {
    "bookingId": "509a0587-dcad-4e8e-a2b3-70031d1681e2",
    "status": "SCHEDULED",
    "consultationDateTime": "2026-10-17T06:30:00.000Z",
    "location": {
      "id": "1ef7a5aa-2e47-4b89-af77-d306466bae9d",
      "name": "Trivandrum",
      "address": "Kochi",
      "city": "Kochi"
    },
    "program": {
      "id": "ceb9ff63-bd42-447b-aed6-bb0471b5342d",
      "name": "Insight Program",
      "type": "INSIGHT"
    },
    "patientId": "3e26f22e-9fa1-42c5-b66c-c55a495da17e"
  }
}
```

------------------------------------------------------------------------

# 2. Update Appointment

### Endpoint

PATCH /api/v1/bookings/appointment/{bookingId}

### Request

PATCH
http://localhost:3000/api/v1/bookings/appointment/093cbeb9-f2c6-4d7e-a166-32c470298d4f

Headers: Authorization: Bearer `<TOKEN>`{=html} Content-Type:
application/json

### Body

``` json
{
  "location": "Trivandrum"
}
```

### Response

``` json
{
  "success": true,
  "message": "Appointment updated successfully",
  "data": {
    "bookingId": "509a0587-dcad-4e8e-a2b3-70031d1681e2",
    "status": "SCHEDULED",
    "consultationDateTime": "2026-10-20T06:30:00.000Z",
    "locationId": "1ef7a5aa-2e47-4b89-af77-d306466bae9d",
    "programId": "ceb9ff63-bd42-447b-aed6-bb0471b5342d"
  }
}
```

------------------------------------------------------------------------

# 3. Cancel Appointment

### Endpoint

DELETE /api/v1/bookings

### Request

DELETE http://localhost:3000/api/v1/bookings

Headers: Authorization: Bearer `<TOKEN>`{=html}

### Response

``` json
{
  "success": true,
  "message": "Booking cancelled",
  "data": {
    "bookingId": "e0689e3b-6707-4b03-8a46-fca4b1166033"
  }
}
```

------------------------------------------------------------------------

# Implementation Requirements

Ensure the following:

-   Proper **model mapping**
-   **Retrofit/Dio configuration** follows existing project pattern
-   API responses are wrapped using the **existing ApiResponse model**
-   **No hardcoded tokens**
-   Error handling matches **current architecture**

------------------------------------------------------------------------

# If Uncertain

1.  Inspect **similar implemented CRUD screen**
2.  Mirror **structure exactly**
3.  Maintain **architecture consistency**

------------------------------------------------------------------------

# END OF INSTRUCTION
