import 'package:equatable/equatable.dart';

class WellnessProgress extends Equatable {
  final String phaseName;
  final String subtitle;
  final int progressPercent;
  final String currentStep;

  const WellnessProgress({
    required this.phaseName,
    required this.subtitle,
    required this.progressPercent,
    required this.currentStep,
  });

  @override
  List<Object?> get props => [phaseName, subtitle, progressPercent, currentStep];
}
