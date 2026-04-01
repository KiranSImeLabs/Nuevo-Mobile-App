import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/health/health_enums.dart';
import '../../domain/models/health/metric_stats.dart';
import '../../domain/models/health/patient_habit_history.dart';
import 'package:intl/intl.dart';

final healthAnalyticsServiceProvider = Provider((ref) => HealthAnalyticsService());

class HealthAnalyticsService {
  MetricStats analyze({
    required List<PatientHabitHistory> rawData,
    required MetricType selectedMetric,
    required TimeRange selectedRange,
  }) {
    if (rawData.isEmpty) {
      return const MetricStats(
        avgVal: 0, minVal: 0, maxVal: 0, cv: 0,
        consistencyScore: 0, goalScore: 0, healthScore: 0, slope: 0,
        trendDirection: "Stable", trendStrength: "Weak", confidence: "Low",
        consistencyLabel: "Fluctuating", healthScoreLabel: "Needs Attention",
        smartInsight: "Setup active metrics to view actionable insights.",
        anomalyMessage: "", recentTrendMessage: "Insufficient data to compute trend.",
        previousAvg: 0, goalGap: 0,
      );
    }

    final isLowerBetter = selectedMetric == MetricType.screenTime || selectedMetric == MetricType.stress;
    final goal = _getGoal(selectedMetric);
    int hits = 0;
    
    double minVal = double.maxFinite;
    double maxVal = -double.maxFinite;
    double sumY = 0;
    
    int n = rawData.length;
    double sumX = 0;
    double sumXY = 0;
    double sumX2 = 0;

    for (int i = 0; i < n; i++) {
        final val = _getMetricValue(rawData[i], selectedMetric);
        if (val < minVal) minVal = val;
        if (val > maxVal) maxVal = val;
        
        sumY += val;
        sumX += i;
        sumXY += i * val;
        sumX2 += i * i;

        if (isLowerBetter) {
            if (val <= goal) hits++;
        } else {
            if (val >= goal) hits++;
        }
    }

    final avgVal = sumY / n;
    
    double previousAvg = 0;
    if (n >= 2) {
      int mid = n ~/ 2;
      double sumPrev = 0;
      for (int i = 0; i < mid; i++) sumPrev += _getMetricValue(rawData[i], selectedMetric);
      previousAvg = sumPrev / mid;
    }
    
    double goalGap = avgVal - goal;

    // Variance and Coefficient of Variation
    double varianceSum = 0;
    for (int i = 0; i < n; i++) {
        final val = _getMetricValue(rawData[i], selectedMetric);
        varianceSum += math.pow(val - avgVal, 2);
    }
    double stdDev = math.sqrt(varianceSum / n);
    double cv = avgVal == 0 ? 0 : (stdDev / avgVal) * 100;
    double consistencyScore = math.max(0, 100 - cv); 

    String consistencyLabel = "Fluctuating";
    if (consistencyScore >= 90) consistencyLabel = "Highly Consistent";
    else if (consistencyScore >= 70) consistencyLabel = "Stable";

    // Regression Loop
    double slope = 0;
    if (n > 1) {
        double denominator = (n * sumX2) - (sumX * sumX);
        if (denominator != 0) slope = ((n * sumXY) - (sumX * sumY)) / denominator;
    }

    // Trend Direction & Strength
    String trendStrength = "Weak";
    double sAbs = slope.abs();
    if (sAbs > 1.0) trendStrength = "Strong";
    else if (sAbs > 0.3) trendStrength = "Moderate";

    bool trendingUp = slope > 0.3;
    bool trendingDown = slope < -0.3;
    bool isStable = (!trendingUp && !trendingDown);

    String trendDirection = isStable ? "Stable" : (trendingUp ? "Improving" : "Declining");
    if (isLowerBetter && !isStable) trendDirection = trendingUp ? "Declining" : "Improving";

    String confidence = "Low";
    if (n >= 7) confidence = "High";
    else if (n >= 4) confidence = "Medium";

    // Health Score Math Engine
    double avgScore = 0;
    if (isLowerBetter) {
      if (avgVal <= goal) avgScore = 100;
      else {
         double overage = avgVal - goal;
         double maxAllowed = goal;
         avgScore = math.max(0, 100 - ((overage / maxAllowed) * 100));
      }
    } else {
      if (goal != 0) {
        avgScore = math.min(100, (avgVal / goal) * 100);
      }
    }

    double goalScore = (hits / n) * 100;
    double healthScore = (avgScore * 0.4) + (consistencyScore * 0.3) + (goalScore * 0.3);

    String healthScoreLabel = "Needs Attention";
    if (healthScore > 85) healthScoreLabel = "Excellent";
    else if (healthScore >= 70) healthScoreLabel = "Good";
    else if (healthScore >= 50) healthScoreLabel = "Average";

    // Anomaly Detection (Spikes / Drops mapped via 1.5 * stdDev bounds)
    String anomalyMessage = "";
    if (n >= 4) {
      for (int i = 0; i < n; i++) {
        final val = _getMetricValue(rawData[i], selectedMetric);
        if (val > avgVal + (1.5 * stdDev) && stdDev > 0.5) {
             final dateStr = rawData[i].date;
             final parsedDate = DateTime.tryParse(dateStr);
             final formattedDate = parsedDate != null ? DateFormat('MMM d').format(parsedDate) : dateStr;
             anomalyMessage = "Spike observed on $formattedDate.";
        } else if (val < avgVal - (1.5 * stdDev) && stdDev > 0.5) {
             final dateStr = rawData[i].date;
             final parsedDate = DateTime.tryParse(dateStr);
             final formattedDate = parsedDate != null ? DateFormat('MMM d').format(parsedDate) : dateStr;
             anomalyMessage = "Drop observed on $formattedDate.";
        }
      }
    }

    // Smart Insight Generation
    final isWeek = selectedRange == TimeRange.weekly;
    final timeStr = isWeek ? "this week" : "this month";
    String smartInsight = _generateInsight(selectedMetric, avgVal, hits, n, timeStr);

    final diff = avgVal - previousAvg;
    String metricName = _getMetricName(selectedMetric).toLowerCase();
    String metricUnit = _getMetricUnit(selectedMetric);
    
    String recentMsg = "";
    if (n < 2) {
       recentMsg = "Insufficient data to establish a structural trend. Continue logging to view comparison rates.";
    } else if (isStable || diff.abs() < 0.1) {
       recentMsg = "Your $metricName has remained completely stable compared to last period. Consistency score tracks as ${consistencyLabel.toLowerCase()} ($consistencyScore%). Confidence: $confidence.";
    } else {
       String verb = trendDirection == "Improving" ? "improved" : "declined";
       recentMsg = "Your $metricName $verb by ${diff.abs().toStringAsFixed(1)} $metricUnit compared to last period, showing steady $trendDirection shifts. Confidence: $confidence.";
    }

    return MetricStats(
      avgVal: avgVal,
      minVal: minVal,
      maxVal: maxVal,
      cv: cv,
      consistencyScore: consistencyScore,
      goalScore: goalScore,
      healthScore: healthScore,
      slope: slope,
      trendDirection: trendDirection,
      trendStrength: trendStrength,
      confidence: confidence,
      consistencyLabel: consistencyLabel,
      healthScoreLabel: healthScoreLabel,
      smartInsight: smartInsight,
      anomalyMessage: anomalyMessage,
      recentTrendMessage: recentMsg,
      previousAvg: previousAvg,
      goalGap: goalGap,
    );
  }

  double _getGoal(MetricType type) {
    switch (type) {
      case MetricType.sleep: return 7.5;
      case MetricType.water: return 3.0;
      case MetricType.screenTime: return 3.0;
      case MetricType.stress: return 4.0;
      case MetricType.steps: return 10000;
    }
  }

  double _getMetricValue(PatientHabitHistory history, MetricType type) {
    switch (type) {
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

  String _getMetricName(MetricType type) {
    switch (type) {
      case MetricType.sleep: return "Sleep";
      case MetricType.water: return "Water";
      case MetricType.screenTime: return "Screen Time";
      case MetricType.stress: return "Stress";
      case MetricType.steps: return "Steps";
    }
  }

  String _getMetricUnit(MetricType type) {
    switch (type) {
      case MetricType.sleep: return "hrs";
      case MetricType.water: return "L";
      case MetricType.screenTime: return "hrs";
      case MetricType.stress: return "lvl";
      case MetricType.steps: return "steps";
    }
  }

  String _generateInsight(MetricType type, double avg, int hits, int total, String timeStr) {
      final aStr = avg.toStringAsFixed(1);
      switch(type) {
          case MetricType.sleep:
             if (avg < 5) return "You averaged $aStr hrs $timeStr, critically below optimal. This severely impairs recovery. Try shutting down devices 1 hour early tonight.";
             if (avg < 7) return "You averaged $aStr hrs $timeStr, slightly below baseline. This gradually builds sleep debt. Try going to bed 30 mins earlier.";
             return "You averaged $aStr hrs $timeStr, hitting the optimal window! This fuels deep immune recovery. Maintain your current evening wind-down routine.";
          case MetricType.water:
             if (avg < 2) return "You averaged $aStr L daily, triggering moderate dehydration risks. This slows cellular metabolism. Increase intake by 500ml daily.";
             if (avg < 3) return "You averaged $aStr L daily, forming a decent functional baseline. This is stable but not elite. Keep a water bottle at your desk.";
             return "You averaged $aStr L daily, hitting peak hydration states! This maximizes joint lubrication. Excellent ongoing routine.";
          case MetricType.screenTime:
             if (avg > 5) return "You averaged $aStr hrs daily, defining aggressive screen consumption. This constantly spikes cortisol. Consider limiting digital usage rigorously after 10 PM.";
             if (avg > 3) return "You averaged $aStr hrs daily, maintaining moderate standard usage. This strains eyes gradually. Use the 20-20-20 distance rule every hour.";
             return "You averaged $aStr hrs daily, actively holding elite digital boundaries! This protects cognitive load. You are successfully unplugged.";
          case MetricType.stress:
             if (avg > 7) return "High chronic stress (avg $aStr) detected over multiple days. This floods your system with oxidative load. Utilize short breathing exercises during peak afternoon hours.";
             if (avg >= 4) return "Moderate stress maintained (avg $aStr). This tracks as normal functional psychological tension. Break up standard routine with short outdoor walks.";
             return "Very low stress profiles evaluated (avg $aStr). Exceptional emotional bandwidth. You are in a primed mental state for adaptation.";
          case MetricType.steps:
             if (avg < 5000) return "You were highly inactive, averaging $aStr steps. This compounds circulatory slowing. A short 15-minute walk after lunch can help reverse this trend.";
             if (avg <= 10000) return "You averaged $aStr steps, building a solid cardiovascular reserve. This is fundamentally healthy. Try parking further away to cross the elite 10k threshold naturally.";
             return "You conquered elite loads, hitting $aStr steps dynamically! This scales profound stamina tracking. Make sure you fuel with extra hydration to compensate.";
      }
  }
}
