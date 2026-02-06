import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

/// Login Response Model
@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  final UserModel user;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  
  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.expiresIn,
  });
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

/// Login Request Model
@JsonSerializable()
class LoginRequestModel {
  final String email;
  final String password;
  
  const LoginRequestModel({
    required this.email,
    required this.password,
  });
  
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}

/// Signup Request Model
@JsonSerializable()
class SignupRequestModel {
  final String email;
  final String password;
  final String name;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  
  const SignupRequestModel({
    required this.email,
    required this.password,
    required this.name,
    this.phoneNumber,
  });
  
  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$SignupRequestModelToJson(this);
}

/// Token Refresh Response Model
@JsonSerializable()
class TokenRefreshResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'expires_in')
  final int? expiresIn;
  
  const TokenRefreshResponseModel({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });
  
  factory TokenRefreshResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TokenRefreshResponseModelToJson(this);
}
