import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/wellness_program.dart';

part 'wellness_program_model.g.dart';

/// Wellness Program Model (Data Layer)
@JsonSerializable()
class WellnessProgramModel {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'progress_percentage')
  final double progressPercentage;
  @JsonKey(name: 'habits_count')
  final int habitsCount;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  
  const WellnessProgramModel({
    required this.id,
    required this.name,
    required this.description,
    required this.progressPercentage,
    required this.habitsCount,
    this.iconUrl,
  });
  
  factory WellnessProgramModel.fromJson(Map<String, dynamic> json) {
    return WellnessProgramModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Program',
      description: json['description'] as String? ?? '',
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
      habitsCount: (json['habits_count'] as num?)?.toInt() ?? 0,
      iconUrl: json['icon_url'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() => _$WellnessProgramModelToJson(this);
  
  WellnessProgram toEntity() {
    return WellnessProgram(
      id: id,
      name: name,
      description: description,
      progressPercentage: progressPercentage,
      habitsCount: habitsCount,
      iconUrl: iconUrl,
    );
  }
  
  factory WellnessProgramModel.fromEntity(WellnessProgram entity) {
    return WellnessProgramModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      progressPercentage: entity.progressPercentage,
      habitsCount: entity.habitsCount,
      iconUrl: entity.iconUrl,
    );
  }
}

/// Habit Model (Data Layer)
@JsonSerializable()
class HabitModel {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  
  const HabitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isCompleted,
    this.completedAt,
  });
  
  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$HabitModelToJson(this);
  
  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      description: description,
      isCompleted: isCompleted,
      completedAt: completedAt != null ? DateTime.tryParse(completedAt!) : null,
    );
  }
  
  factory HabitModel.fromEntity(Habit entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt?.toIso8601String(),
    );
  }
}
