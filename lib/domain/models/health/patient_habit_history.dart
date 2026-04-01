class PatientHabitHistory {
  final String date;
  final double sleepHours;
  final double waterIntake;
  final double screenTime;
  final String stressLevel;
  final int stepsCount;
  final String energyLevel;

  PatientHabitHistory({
    required this.date,
    required this.sleepHours,
    required this.waterIntake,
    required this.screenTime,
    required this.stressLevel,
    required this.stepsCount,
    required this.energyLevel,
  });

  factory PatientHabitHistory.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is String) return double.tryParse(value) ?? 0.0;
      if (value is num) return value.toDouble();
      return 0.0;
    }

    return PatientHabitHistory(
      date: json['date'] as String? ?? '',
      sleepHours: parseDouble(json['sleepHours']),
      waterIntake: parseDouble(json['waterIntake']),
      screenTime: parseDouble(json['screenTime']),
      stressLevel: json['stressLevel'] as String? ?? 'Normal',
      stepsCount: (json['stepsCount'] as num?)?.toInt() ?? 0,
      energyLevel: json['energyLevel'] as String? ?? 'Balanced',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'sleepHours': sleepHours,
      'waterIntake': waterIntake,
      'screenTime': screenTime,
      'stressLevel': stressLevel,
      'stepsCount': stepsCount,
      'energyLevel': energyLevel,
    };
  }
}
