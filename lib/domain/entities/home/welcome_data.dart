import 'package:equatable/equatable.dart';

class WelcomeData extends Equatable {
  final String firstName;
  final String lastName;
  final String greeting;

  const WelcomeData({
    required this.firstName,
    required this.lastName,
    required this.greeting,
  });

  @override
  List<Object?> get props => [firstName, lastName, greeting];
}
