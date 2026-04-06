import 'package:equatable/equatable.dart';

class Phase extends Equatable {
  final String id;
  final String name;
  final int durationWeeks;
  final int orderIndex;
  final String programType;
  final int? totalAppointments;
  final String? createdAt;
  final String? updatedAt;

  const Phase({
    required this.id,
    required this.name,
    required this.durationWeeks,
    required this.orderIndex,
    required this.programType,
    this.totalAppointments,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        durationWeeks,
        orderIndex,
        programType,
        totalAppointments,
        createdAt,
        updatedAt,
      ];
}
