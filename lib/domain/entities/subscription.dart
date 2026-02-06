import 'package:equatable/equatable.dart';

/// Subscription Status Enum
enum SubscriptionStatus {
  active,
  inactive,
  expired,
  trial,
}

/// Subscription Entity (Domain Layer)
/// Represents the user's subscription plan and access rights
/// CRITICAL: This is READ-ONLY data - no payment processing
class Subscription extends Equatable {
  final String id;
  final String planName;
  final SubscriptionStatus status;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final List<String> features;
  final String? description;
  
  const Subscription({
    required this.id,
    required this.planName,
    required this.status,
    this.startDate,
    this.expiryDate,
    required this.features,
    this.description,
  });
  
  /// Check if subscription is currently active
  bool get isActive => status == SubscriptionStatus.active;
  
  /// Check if a specific feature is unlocked
  bool hasFeature(String featureName) {
    return isActive && features.contains(featureName);
  }
  
  /// Check if subscription is expired
  bool get isExpired {
    if (status == SubscriptionStatus.expired) return true;
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }
  
  /// Days remaining until expiry (null if no expiry date)
  int? get daysRemaining {
    if (expiryDate == null) return null;
    final difference = expiryDate!.difference(DateTime.now());
    return difference.inDays;
  }
  
  @override
  List<Object?> get props => [
    id,
    planName,
    status,
    startDate,
    expiryDate,
    features,
    description,
  ];
  
  @override
  String toString() {
    return 'Subscription(id: $id, planName: $planName, status: $status, features: $features)';
  }
}
