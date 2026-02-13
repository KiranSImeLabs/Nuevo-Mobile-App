import '../../../domain/entities/home/quick_stats.dart';

class QuickStatsModel extends QuickStats {
  const QuickStatsModel({
    super.nuevoAge,
    super.nextSession,
  });

  factory QuickStatsModel.fromJson(Map<String, dynamic> json) {
    return QuickStatsModel(
      nuevoAge: json['nuevoAge']?.toString(),
      nextSession: json['nextSession']?.toString(),
    );
  }
}
