import '../../../domain/entities/home/quick_stats.dart';

class SessionInfoModel extends SessionInfo {
  const SessionInfoModel({
    required super.time,
    required super.date,
    required super.label,
    required super.bookingId,
  });

  factory SessionInfoModel.fromJson(Map<String, dynamic> json) {
    return SessionInfoModel(
      time: json['time']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
    );
  }
}

class QuickStatsModel extends QuickStats {
  const QuickStatsModel({
    super.nuevoAge,
    super.nextSession,
  });

  factory QuickStatsModel.fromJson(Map<String, dynamic> json) {
    return QuickStatsModel(
      nuevoAge: json['nuevoAge']?.toString(),
      nextSession: json['nextSession'] is Map<String, dynamic>
          ? SessionInfoModel.fromJson(json['nextSession'] as Map<String, dynamic>)
          : null,
    );
  }
}
