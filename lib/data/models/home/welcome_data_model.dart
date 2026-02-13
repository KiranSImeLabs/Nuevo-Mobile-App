import 'package:equatable/equatable.dart';
import '../../../domain/entities/home/welcome_data.dart';

class WelcomeDataModel extends WelcomeData {
  const WelcomeDataModel({
    required super.firstName,
    required super.lastName,
    required super.greeting,
  });

  factory WelcomeDataModel.fromJson(Map<String, dynamic> json) {
    return WelcomeDataModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      greeting: json['greeting'] ?? 'Welcome',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'greeting': greeting,
    };
  }
}
