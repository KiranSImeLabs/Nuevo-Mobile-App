import '../../../domain/entities/home/quick_stats.dart';

class QuickStatsModel extends QuickStats {
  const QuickStatsModel({
    super.nuevoAge,
    super.nextSession,
  });

  factory QuickStatsModel.fromJson(Map<String, dynamic> json) {
    SessionInfo? sessionInfo;
    
    if (json['nextSession'] is Map) {
      final session = json['nextSession'] as Map<String, dynamic>;
      sessionInfo = SessionInfo(
        time: session['time'] as String? ?? '',
        date: session['date'] as String? ?? '',
        label: session['label'] as String? ?? 'Consultation',
        bookingId: session['bookingId'] as String? ?? '',
      );
    }

    return QuickStatsModel(
      nuevoAge: json['nuevoAge']?.toString(),
      nextSession: sessionInfo,
    );
  }
}
