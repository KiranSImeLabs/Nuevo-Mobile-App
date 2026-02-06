import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/subscription.dart';

part 'subscription_model.g.dart';

/// Subscription Model (Data Layer)
/// Handles JSON serialization/deserialization for API communication
@JsonSerializable()
class SubscriptionModel {
  final String id;
  @JsonKey(name: 'plan_name')
  final String planName;
  final String status;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'expiry_date')
  final String? expiryDate;
  final List<String> features;
  final String? description;
  
  const SubscriptionModel({
    required this.id,
    required this.planName,
    required this.status,
    this.startDate,
    this.expiryDate,
    required this.features,
    this.description,
  });
  
  /// Factory constructor for creating a SubscriptionModel from JSON
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
  
  /// Convert SubscriptionModel to JSON
  Map<String, dynamic> toJson() => _$SubscriptionModelToJson(this);
  
  /// Convert SubscriptionModel to Domain Entity
  Subscription toEntity() {
    return Subscription(
      id: id,
      planName: planName,
      status: _parseStatus(status),
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      expiryDate: expiryDate != null ? DateTime.tryParse(expiryDate!) : null,
      features: features,
      description: description,
    );
  }
  
  /// Factory constructor for creating a SubscriptionModel from Domain Entity
  factory SubscriptionModel.fromEntity(Subscription subscription) {
    return SubscriptionModel(
      id: subscription.id,
      planName: subscription.planName,
      status: _statusToString(subscription.status),
      startDate: subscription.startDate?.toIso8601String(),
      expiryDate: subscription.expiryDate?.toIso8601String(),
      features: subscription.features,
      description: subscription.description,
    );
  }
  
  /// Parse string status to SubscriptionStatus enum
  static SubscriptionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'inactive':
        return SubscriptionStatus.inactive;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'trial':
        return SubscriptionStatus.trial;
      default:
        return SubscriptionStatus.inactive;
    }
  }
  
  /// Convert SubscriptionStatus enum to string
  static String _statusToString(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return 'active';
      case SubscriptionStatus.inactive:
        return 'inactive';
      case SubscriptionStatus.expired:
        return 'expired';
      case SubscriptionStatus.trial:
        return 'trial';
    }
  }
}
