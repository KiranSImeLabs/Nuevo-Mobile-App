import 'package:equatable/equatable.dart';

/// Task Type Enum
enum TaskType {
  questionnaire,
  exercise,
  nutrition,
  appointment,
  general,
}

/// Task Entity (Domain Layer)
/// Represents a task or action item for the user
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String? imageUrl;
  final bool isCompleted;
  final TaskType type;
  final DateTime? dueDate;
  final DateTime? completedAt;
  
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    this.imageUrl,
    required this.isCompleted,
    required this.type,
    this.dueDate,
    this.completedAt,
  });
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    durationMinutes,
    imageUrl,
    isCompleted,
    type,
    dueDate,
    completedAt,
  ];
}
