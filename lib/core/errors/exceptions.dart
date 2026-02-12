/// Base exception class
class AppException implements Exception {
  final String message;
  final int? code;
  
  AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network exceptions
class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'NetworkException: $message (code: $code)';
}

/// Server exceptions
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'ServerException: $message (code: $code)';
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'AuthException: $message (code: $code)';
}

/// Subscription exceptions
class SubscriptionException extends AppException {
  SubscriptionException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'SubscriptionException: $message (code: $code)';
}

/// Permission exceptions
class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'PermissionException: $message (code: $code)';
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'CacheException: $message (code: $code)';
}

/// Validation exceptions
class ValidationException extends AppException {
  final List<String>? errors;

  ValidationException({
    required super.message,
    super.code,
    this.errors,
  });
  
  @override
  String toString() => 'ValidationException: $message (code: $code, errors: $errors)';
}
