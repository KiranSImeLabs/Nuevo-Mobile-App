import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

/// Login Response Data
/// Wrapped inside ApiResponse<LoginResponseData>
@JsonSerializable()
class LoginResponseData {
  @JsonKey(name: 'token')
  final String token;
  final UserModel user;
  
  const LoginResponseData({
    required this.token,
    required this.user,
  });
  
  factory LoginResponseData.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginResponseDataToJson(this);
}

/// Login Request Model
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;
  
  const LoginRequest({
    required this.email,
    required this.password,
  });
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// Register Request Model
@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;
  final String email;
  final String password;
  
  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
  
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// Forgot Password Request
@JsonSerializable()
class ForgotPasswordRequest {
  final String email;
  
  const ForgotPasswordRequest({required this.email});
  
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

/// Verify Reset Code Request
@JsonSerializable()
class VerifyResetCodeRequest {
  final String email;
  final String code;
  
  const VerifyResetCodeRequest({
    required this.email,
    required this.code,
  });
  
  factory VerifyResetCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetCodeRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$VerifyResetCodeRequestToJson(this);
}

/// Reset Password Request
@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String code;
  @JsonKey(name: 'newPassword')
  final String newPassword;
  
  const ResetPasswordRequest({
    required this.email,
    required this.code,
    required this.newPassword,
  });
  
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
