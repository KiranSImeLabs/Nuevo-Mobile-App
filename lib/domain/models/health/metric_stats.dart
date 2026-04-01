class MetricStats {
  final double avgVal;
  final double minVal;
  final double maxVal;
  final double cv;
  final double consistencyScore;
  final double goalScore;
  final double healthScore;
  final double slope;
  final String trendDirection;
  final String trendStrength;
  final String confidence;
  final String consistencyLabel;
  final String healthScoreLabel;
  final String smartInsight;
  final String anomalyMessage;
  final String recentTrendMessage;
  final double previousAvg;
  final double goalGap;

  const MetricStats({
    required this.avgVal,
    required this.minVal,
    required this.maxVal,
    required this.cv,
    required this.consistencyScore,
    required this.goalScore,
    required this.healthScore,
    required this.slope,
    required this.trendDirection,
    required this.trendStrength,
    required this.confidence,
    required this.consistencyLabel,
    required this.healthScoreLabel,
    required this.smartInsight,
    required this.anomalyMessage,
    required this.recentTrendMessage,
    required this.previousAvg,
    required this.goalGap,
  });
}
