import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

/// Task Model (Data Layer)
@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final String description;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  final String type;
  @JsonKey(name: 'due_date')
  final String? dueDate;
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  
  const TaskModel({
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
  
  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
  
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      durationMinutes: durationMinutes,
      imageUrl: imageUrl,
      isCompleted: isCompleted,
      type: _parseTaskType(type),
      dueDate: dueDate != null ? DateTime.tryParse(dueDate!) : null,
      completedAt: completedAt != null ? DateTime.tryParse(completedAt!) : null,
    );
  }
  
  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      durationMinutes: entity.durationMinutes,
      imageUrl: entity.imageUrl,
      isCompleted: entity.isCompleted,
      type: entity.type.name,
      dueDate: entity.dueDate?.toIso8601String(),
      completedAt: entity.completedAt?.toIso8601String(),
    );
  }
  
  static TaskType _parseTaskType(String type) {
    switch (type.toLowerCase()) {
      case 'questionnaire':
        return TaskType.questionnaire;
      case 'exercise':
        return TaskType.exercise;
      case 'nutrition':
        return TaskType.nutrition;
      case 'appointment':
        return TaskType.appointment;
      default:
        return TaskType.general;
    }
  }
}
