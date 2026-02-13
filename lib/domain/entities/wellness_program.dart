import 'package:equatable/equatable.dart';

/// Wellness Program Entity (Domain Layer)
/// Represents a user's wellness program with progress tracking
class WellnessProgram extends Equatable {
  final String id;
  final String name;
  final String description;
  final double progressPercentage; // 0.0 to 1.0
  final int habitsCount;
  final String? iconUrl;
  
  const WellnessProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.progressPercentage,
    required this.habitsCount,
    this.iconUrl,
  });
  
  @override
  List<Object?> get props => [id, name, description, progressPercentage, habitsCount, iconUrl];
}

/// Habit Entity
/// Represents a building habit within a wellness program
class Habit extends Equatable {
  final String id;
  final String name;
  final String description;
  final bool isCompleted;
  final DateTime? completedAt;
  
  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.isCompleted,
    this.completedAt,
  });
  
  @override
  List<Object?> get props => [id, name, description, isCompleted, completedAt];
}
