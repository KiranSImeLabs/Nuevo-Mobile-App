import '../../domain/entities/goal.dart';

class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.goal,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? '',
      goal: json['goal'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
    };
  }

  Goal toEntity() {
    return Goal(
      id: id,
      goal: goal,
    );
  }
}
