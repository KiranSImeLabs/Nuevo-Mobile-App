import '../../../domain/entities/home/wellness_progress.dart';

class WellnessProgressModelResponse extends WellnessProgress {
  const WellnessProgressModelResponse({
    required super.phaseName,
    required super.subtitle,
    required super.progressPercent,
    required super.currentStep,
  });

  factory WellnessProgressModelResponse.fromJson(Map<String, dynamic> json) {

    return WellnessProgressModelResponse(
      phaseName: json['phaseName'] ?? 'Wellness Phase',
      subtitle: json['subtitle'] ?? 'Keep going!',
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
      currentStep: json['currentStep'] ?? '',
    );
  }
}
