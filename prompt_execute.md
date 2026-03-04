**
Flutter Multiplatform Task: Payment & Subscription Integration
You are working on a Flutter (Mobile + Web) project. Adhere strictly to the project architecture and the following guidelines.

🛠 Prerequisites & Compliance
Project Context: Read PROJECT_CONTEXT.md for domain logic, business goals, and constraints.

Coding Standards: Follow all rules defined in /Users/goodbits/Desktop/GoodBits/Flutter/nuevo_app/.cursorrules.

DRY Principle: Before creating any UI component, audit the existing codebase to prevent duplicate widgets.

📋 Implementation Requirements
1. API Client Updates

Add the following endpoints to the API client:

Fetch User Subscription: GET /api/v1/subscriptions/payway-details

Fetch Saved Cards: GET /api/v1/payments/customer

Billing history: GET /api/v1/mobile/billing

2. Update Payments Screen Logic

Path: .../lib/presentation/screens/profile/payments_screen.dart

Asynchronous Loading: Trigger both "Billing history", "User Subscription" and "Saved Cards" APIs simultaneously.

Currently we are using some dummmy data to populate the screen. Please remove that and use the API response to populate the screen.

we have method 
void _fetchData() {
    final apiClient = ref.read(apiClientProvider);
    _subscriptionFuture = apiClient.getSubscriptionPaywayDetails();
    _savedCardsFuture = apiClient.getSavedCards();
  } in payments_screen.dart which call thes API. Check there respose model and modify if needed also add billig history that already defined in apiClient.getBillingDetails().


  uture<ApiResponse<BillingResponseData>> getBillingDetails() async {



Independent Population: Do not wait for both to complete. Use FutureBuilder or a similar reactive approach to populate each section (Subscription info vs. Card list) as soon as its respective data arrives.


📑 API Reference
Feature  -> Endpoint -> Method -> Key Params
Subscription Info -> /subscriptions/payway-details -> GET -> Bearer Token
Customer Cards -> /payments/customer -> GET -> Bearer Token
Billing history: GET /api/v1/mobile/billing


- Add a API in API client for User subscription Fetch API.
Request
postman request 'http://localhost:3000/api/v1/subscriptions/payway-details' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg1NzZiNDA3LTcxYWItNDA4ZC05MTRkLTIxODNmMzdlYTUxYyIsImVtYWlsIjoiaWhpbXJhbytlbGE2NHVAeW9wbWFpbC5jb20iLCJpYXQiOjE3NzEzOTQxOTMsImV4cCI6MTc3MTk5ODk5M30.K6vhUswvSlVtsU9YeIdoCvG8kxVY0NNfN2QYiPfJZ9U' \
  --body ''

Response:
{
    "success": true,
    "message": "Subscription details retrieved successfully",
    "data": {
        "paywaySchedule": {
            "frequency": "weekly",
            "nextPaymentDate": "19 Mar 2026",
            "numberOfPaymentsRemaining": 52,
            "nextPrincipalAmount": 99,
            "nextSurchargeAmount": 0,
            "nextPaymentAmount": 99,
            "regularPrincipalAmount": 99,
            "regularSurchargeAmount": 0,
            "regularPaymentAmount": 99,
            "finalPrincipalAmount": 99,
            "finalSurchargeAmount": 0,
            "finalPaymentAmount": 99,
                "links": [
                {
                    "rel": "help",
                    "href": "https://www.payway.com.au/docs/rest.html#customers"
                }
            ]
        },
        "localSubscription": {
            "id": "a461e84a-12a7-4ac9-b908-e24ab9b1581f",
            "status": "ACTIVE",
            "startDate": "2026-02-18T05:12:03.906Z",
            "endDate": "2026-02-25T05:12:03.906Z"
        }
    }
}

- Add API for Fetch save cards

postman request 'http://localhost:3000/api/v1/payments/customer' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg1NzZiNDA3LTcxYWItNDA4ZC05MTRkLTIxODNmMzdlYTUxYyIsImVtYWlsIjoiaWhpbXJhbytlbGE2NHVAeW9wbWFpbC5jb20iLCJpYXQiOjE3NzEzOTQxOTMsImV4cCI6MTc3MTk5ODk5M30.K6vhUswvSlVtsU9YeIdoCvG8kxVY0NNfN2QYiPfJZ9U' \
  --body ''
Response:
{
    "success": true,
    "message": "Customer details retrieved successfully",
    "data": {
        "customerNumber": "216",
        "paymentSetup": {
            "paymentMethod": "creditCard",
            "stopped": false,
            "creditCard": {
                "cardNumber": "456471...004",
                "expiryDateMonth": "02",
                "expiryDateYear": "29",
                "cardScheme": "visa",
                "cardType": "credit",
                "cardholderName": "John Doe",
                "surchargePercentage": 0,
                "panType": "fpan"
            },
            "merchant": {
                "merchantId": "TEST",
                "merchantName": "Test Merchant"
            }
        },
        "creditCard": null,
        "links": [
            {
                "rel": "self",
                "href": "https://api.payway.com.au/rest/v1/customers/216"
            },
            {
                "rel": "help",
                "href": "https://www.payway.com.au/docs/rest.html#customers"
            },
            {
                "rel": "contact",
                "href": "https://api.payway.com.au/rest/v1/customers/216/contact"
            },
            {
                "rel": "custom-fields",
                "href": "https://api.payway.com.au/rest/v1/customers/216/custom-fields"
            },
            {
                "rel": "payment-setup",
                "href": "https://api.payway.com.au/rest/v1/customers/216/payment-setup"
            },
            {
                "rel": "schedule",
                "href": "https://api.payway.com.au/rest/v1/customers/216/schedule"
            },
            {
                "rel": "virtual-account",
                "href": "https://api.payway.com.au/rest/v1/customers/216/virtual-account"
            },
            {
                "rel": "search-customer-transactions",
                "href": "https://api.payway.com.au/rest/v1/transactions/search-customer?customerNumber=216"
            }
        ]
    }
}

Api for billing history:
curl --location --request GET 'http://localhost:3000/api/v1/mobile/billing' \ --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Ijg1NzZiNDA3LTcxYWItNDA4ZC05MTRkLTIxODNmMzdlYTUxYyIsImVtYWlsIjoiaWhpbXJhbytlbGE2NHVAeW9wbWFpbC5jb20iLCJpYXQiOjE3NzI0NTIxMDYsImV4cCI6MTc3MzA1NjkwNn0._wa7cWyocAuhnb1NIKa_fC-9chSWbGBJqlkDwI9REf4' \ --header 'Content-Type: application/json' \ --data '{ "singleUseTokenId": "46b0eb97-8c98-44bc-8e6b-60056adc3b58" }' 

Response:
{
  "success": true,
  "message": "Billing history retrieved successfully",
  "data": {
    "currentSubscription": {
      "programName": "Weight Loss Program",
      "price": 199.99,
      "frequency": "MONTHLY",
      "status": "ACTIVE",
      "renewalDate": "2026-04-01T00:00:00.000Z",
      "startDate": "2026-03-01T00:00:00.000Z"
    },
    "paymentMethods": [
      {
        "brand": "Visa",
        "lastFour": "4242",
        "expiry": "12/25",
        "isPrimary": true
      }
    ],
    "billingHistory": [
      {
        "id": 1,
        "description": "Initial Consultation",
        "date": "2026-03-01T10:00:00.000Z",
        "amount": 199.99,
        "currency": "AUD",
        "status": "Paid",
        "receiptNumber": "RCP_1772182782795"
      },
      {
        "id": 2,
        "description": "Monthly Subscription",
        "date": "2026-02-01T10:00:00.000Z",
        "amount": 99.99,
        "currency": "AUD",
        "status": "Paid",
        "receiptNumber": "RCP_1772182782800"
      }
    ]
  }
}

**