import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String id;
  final String goal;

  const Goal({
    required this.id,
    required this.goal,
  });

  @override
  List<Object?> get props => [id, goal];
}
