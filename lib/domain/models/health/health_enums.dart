import 'package:flutter/material.dart';
import 'patient_habit_history.dart';

enum TimeRange { weekly, monthly }
enum MetricType { sleep, water, screenTime, stress, steps }

extension MetricTypeX on MetricType {
  Color get color {
      switch (this) {
        case MetricType.sleep: return const Color(0xFF6B4EFF);
        case MetricType.water: return const Color(0xFF00A3FF);
        case MetricType.screenTime: return const Color(0xFFFFB300);
        case MetricType.stress: return const Color(0xFFFF8A00);
        case MetricType.steps: return const Color(0xFF00C48C);
      }
  }
  String get name {
      switch (this) {
        case MetricType.sleep: return "Sleep";
        case MetricType.water: return "Water";
        case MetricType.screenTime: return "Screen Time";
        case MetricType.stress: return "Stress";
        case MetricType.steps: return "Steps";
      }
  }
  String get unit {
      switch (this) {
        case MetricType.sleep: return "hrs";
        case MetricType.water: return "L";
        case MetricType.screenTime: return "hrs";
        case MetricType.stress: return "lvl";
        case MetricType.steps: return "steps";
      }
  }
  IconData get icon {
      switch (this) {
        case MetricType.sleep: return Icons.bedtime_rounded;
        case MetricType.water: return Icons.water_drop_rounded;
        case MetricType.screenTime: return Icons.smartphone_rounded;
        case MetricType.stress: return Icons.psychology_rounded;
        case MetricType.steps: return Icons.directions_walk_rounded;
      }
  }
  double get goal {
      switch (this) {
        case MetricType.sleep: return 7.5;
        case MetricType.water: return 3.0;
        case MetricType.screenTime: return 3.0;
        case MetricType.stress: return 4.0;
        case MetricType.steps: return 10000;
      }
  }
  double getValue(PatientHabitHistory history) {
      switch (this) {
        case MetricType.sleep: return history.sleepHours;
        case MetricType.water: return history.waterIntake;
        case MetricType.screenTime: return history.screenTime;
        case MetricType.stress:
          if (history.stressLevel == "High") return 8.0;
          if (history.stressLevel == "Medium") return 5.0;
          return 2.0; 
        case MetricType.steps: return history.stepsCount.toDouble();
      }
  }
}
