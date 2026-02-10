# Manual Network Layer & Client Documentation

## Overview
This document details the manual implementation of the network layer in the Nuevo App, replacing the previous code-generation approach (Retrofit). This change provides greater control over API requests, error handling, and dependency management.

## Architecture
The network layer consists of three main components:
1. **DioClient**: A low-level wrapper around the `dio` package that handles configuration, interceptors, and error mapping.
2. **ApiClient**: A high-level service that defines specific API endpoints and response parsing.
3. **ApiResponse<T>**: A generic wrapper class for standardized backend responses.

---

## 1. DioClient
**Location:** `lib/core/network/dio_client.dart`

The `DioClient` is responsible for the base HTTP configuration. It automatically injects the authentication token (if available) and handles logging.

### Key Features
- **Base URL Configuration**: Sets timeouts and headers.
- **Auth Interceptor**: Injects `Authorization: Bearer <token>` into requests.
- **Error Handling**: Converts `DioException` into domain-specific exceptions (`NetworkException`, `AuthException`, `ServerException`).

### Code Snippet: Configuration
```dart
DioClient({
  Dio? dio,
  required Future<String?> Function() getAccessToken,
}) {
  _dio = dio ?? Dio();
  
  _dio.options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: ApiConstants.connectTimeout,
    receiveTimeout: ApiConstants.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  
  // Auth Interceptor
  _dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      // ... logging and error handling
    ),
  );
}
```

### Code Snippet: GET Request Wrapper
```dart
Future<Response> get(
  String path, {
  Map<String, dynamic>? queryParameters,
  Options? options,
}) async {
  try {
    return await _dio.get(path, queryParameters: queryParameters, options: options);
  } on DioException catch (e) {
    throw handleDioError(e);
  }
}
```

---

## 2. ApiClient
**Location:** `lib/data/datasources/remote/api_client.dart`

This class corresponds to what was previously the Retrofit interface. It manually constructs requests using `DioClient` and parses the JSON response into strongly-typed models using `ApiResponse<T>`.

### Key Pattern
Each method follows this pattern:
1. Call `_dioClient.get/post/put/delete`.
2. Pass the endpoint path from `ApiConstants`.
3. Pass `data` (body) or `queryParameters`.
4. Return `ApiResponse.fromJson` with a standardized deserialization closure.

### Code Snippet: Login
```dart
Future<ApiResponse<LoginResponseData>> login(LoginRequest request) async {
  final response = await _dioClient.post(
    ApiConstants.login,
    data: request.toJson(),
  );
  return ApiResponse.fromJson(
    response.data, 
    (json) => LoginResponseData.fromJson(json as Map<String, dynamic>),
  );
}
```

### Code Snippet: Get User Profile
```dart
Future<ApiResponse<UserModel>> getUserProfile() async {
  final response = await _dioClient.get(ApiConstants.userProfile);
  return ApiResponse.fromJson(
    response.data,
    (json) => UserModel.fromJson(json as Map<String, dynamic>),
  );
}
```

---

## 3. Usage in Repositories
**Location:** `lib/data/repositories/*_repository_impl.dart`

Repositories inject `ApiClient` and call its methods. They handle the `ApiResponse` and map it to `Either<Failure, Entity>`.

### Code Snippet: AuthRepository Implementation
```dart
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  
  // ... constructor

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiClient.login(request);
      
      if (response.success && response.data != null) {
        // Success: Map DTO to Entity
        return Right(response.data!.user.toEntity());
      } else {
        // API Error
        return Left(ServerFailure(message: response.message ?? 'Login failed'));
      }
    } on Exception catch (e) {
      // Exception Handling (e.g. Network offline)
      if (e is NetworkException) {
        return Left(NetworkFailure(message: e.message));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

## Adding New Endpoints
To add a new API endpoint:
1. Add the URL string to `lib/core/constants/app_constants.dart`.
2. Add the method to `lib/data/datasources/remote/api_client.dart`.
3. Ensure the return type is wrapped in `ApiResponse<T>`.
4. Use `_dioClient` to make the request.

```dart
// Example: New Endpoint
Future<ApiResponse<MyNewModel>> getNewData() async {
  final response = await _dioClient.get(ApiConstants.newEndpoint);
  return ApiResponse.fromJson(
    response.data,
    (json) => MyNewModel.fromJson(json as Map<String, dynamic>),
  );
}
```
