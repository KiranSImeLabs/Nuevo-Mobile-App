import 'package:equatable/equatable.dart';


/// Base class for all application failures
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(String message, [int? code]) : super(message: message, code: code);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

/// Subscription-related failures
class SubscriptionFailure extends Failure {
  const SubscriptionFailure({
    required super.message,
    super.code,
  });
}

/// Permission-related failures (Camera, Microphone, etc.)
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// Video call failures
class VideoCallFailure extends Failure {
  const VideoCallFailure({
    required super.message,
    super.code,
  });
}

/// Cache/Storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Generic/Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });
}
