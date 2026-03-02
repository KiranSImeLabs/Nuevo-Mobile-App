import 'package:json_annotation/json_annotation.dart';
import 'daily_exercise_model.dart'; // Import to use DailyExerciseModel for the schedules list

part 'weekly_schedule_model.g.dart';

@JsonSerializable()
class WeeklyScheduleModel {
  final int? currentDayNumber;
  final List<DailyExerciseModel>? schedules;

  WeeklyScheduleModel({
    this.currentDayNumber,
    this.schedules,
  });

  factory WeeklyScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyScheduleModelToJson(this);
}
