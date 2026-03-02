// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyScheduleModel _$WeeklyScheduleModelFromJson(Map<String, dynamic> json) =>
    WeeklyScheduleModel(
      currentDayNumber: (json['currentDayNumber'] as num?)?.toInt(),
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => DailyExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyScheduleModelToJson(
        WeeklyScheduleModel instance) =>
    <String, dynamic>{
      'currentDayNumber': instance.currentDayNumber,
      'schedules': instance.schedules,
    };
