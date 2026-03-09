import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';
import 'subscription_model.dart';

part 'user_model.g.dart';

/// User Model (Data Layer)
/// Handles JSON serialization/deserialization for API communication
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'profileImage')
  final String? profileImageUrl;
  final SubscriptionModel? subscription;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  
  const UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.subscription,
    this.createdAt,
    this.lastLoginAt,
  });
  
  /// Factory constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  /// Convert UserModel to Domain Entity
  User toEntity() {
    // Combine firstName and lastName into name
    final String name = [firstName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .join(' ')
        .trim();
    
    return User(
      id: id,
      email: email,
      name: '${firstName ?? ''} ${lastName ?? ''}'.trim(),
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      subscription: subscription?.toEntity(),
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      lastLoginAt: lastLoginAt != null ? DateTime.tryParse(lastLoginAt!) : null,
    );
  }
  
  /// Factory constructor for creating a UserModel from Domain Entity
  factory UserModel.fromEntity(User user) {
    final nameParts = user.name.split(' ');
    final firstName = nameParts.length > 0 ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: user.phoneNumber,
      profileImageUrl: user.profileImageUrl,
      subscription: user.subscription != null
          ? SubscriptionModel.fromEntity(user.subscription!)
          : null,
      createdAt: user.createdAt?.toIso8601String(),
      lastLoginAt: user.lastLoginAt?.toIso8601String(),
    );
  }
}
