import 'package:equatable/equatable.dart';

class Phase extends Equatable {
  final String id;
  final String name;
  final int durationWeeks;
  final int orderIndex;
  final String programType;

  const Phase({
    required this.id,
    required this.name,
    required this.durationWeeks,
    required this.orderIndex,
    required this.programType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        durationWeeks,
        orderIndex,
        programType,
      ];
}
