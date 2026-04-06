import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../../domain/models/health/health_enums.dart';
import '../../../../../domain/models/health/patient_habit_history.dart';
import '../../../../../domain/models/health/metric_stats.dart';

class HistoricalTrendsChart extends StatelessWidget {
  final List<PatientHabitHistory> data;
  final MetricStats stats;
  final MetricType selectedMetric;

  const HistoricalTrendsChart({
    super.key, required this.data, required this.stats, required this.selectedMetric,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color subTextColor = isDark ? const Color(0xFFB0BEC5) : const Color(0xFF757575);
    
    if (data.isEmpty) return Center(child: Text("No data available.", style: TextStyle(color: subTextColor, fontSize: 14, fontWeight: FontWeight.w500)));

    final color = selectedMetric.color;
    final goal = selectedMetric.goal;
    final isLowerBetter = selectedMetric == MetricType.screenTime || selectedMetric == MetricType.stress;
    
    List<FlSpot> spots = [];
    int maxIndex = 0;
    int minIndex = 0;

    for (int i = 0; i < data.length; i++) {
        final val = selectedMetric.getValue(data[i]);
        spots.add(FlSpot(i.toDouble(), val));
        if (val == stats.maxVal) maxIndex = i;
        if (val == stats.minVal) minIndex = i;
    }

    double minY = math.max(0, stats.minVal - ((stats.maxVal - stats.minVal) * 0.2));
    double maxY = stats.maxVal + ((stats.maxVal - stats.minVal) * 0.2);
    if (goal > maxY) maxY = goal + 1;
    if (goal < minY) minY = goal - 1;
    if (maxY == minY) { maxY += 2; minY -= 2; }
    
    double yInterval = (maxY - minY) / 5;
    if (yInterval == 0) yInterval = 1;
    
    double leftReservedSize = 36;
    if (maxY >= 1000) leftReservedSize = 46;
    if (maxY >= 10000) leftReservedSize = 52;

    Color gradientStart = stats.healthScore > 80 ? const Color(0xFF00C48C).withValues(alpha: 0.25) : color.withValues(alpha: 0.25);
    Color gradientEnd = color.withValues(alpha: 0.01);

    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    int n = data.length;
    for (int i = 0; i < n; i++) {
        final val = selectedMetric.getValue(data[i]);
        sumX += i; sumY += val; sumXY += i * val; sumX2 += i * i;
    }
    double slope = 0;
    double intercept = 0;
    if (n > 1) {
       double denominator = (n * sumX2) - (sumX * sumX);
       if (denominator != 0) {
           slope = ((n * sumXY) - (sumX * sumY)) / denominator;
           intercept = (sumY - slope * sumX) / n;
       }
    }
    List<FlSpot> trendSpots = n > 1 ? [FlSpot(0, intercept), FlSpot((n-1).toDouble(), slope * (n-1) + intercept)] : [];

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true, drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF0F0F0), strokeWidth: 1, dashArray: [8, 4]),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, reservedSize: 32,
              interval: math.max(1, (data.length / 4).ceil().toDouble()),
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= data.length) return const SizedBox.shrink();
                final date = DateTime.tryParse(data[value.toInt()].date);
                if (date == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(DateFormat('MMM d').format(date), style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, reservedSize: leftReservedSize, interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value <= minY || value >= maxY) return const SizedBox.shrink(); 
                String label;
                if (value >= 1000) {
                  label = '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
                } else {
                  label = value.toInt().toString();
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(label, style: TextStyle(color: subTextColor, fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: goal, color: isDark ? const Color(0xFF636366) : const Color(0xFFD1D1D6), strokeWidth: 1.5, dashArray: [6, 4],
              label: HorizontalLineLabel(show: true, alignment: Alignment.topRight, padding: const EdgeInsets.only(right: 4, bottom: 4), style: TextStyle(color: isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93), fontSize: 10, fontWeight: FontWeight.w700), labelResolver: (line) => 'GOAL ($goal)'),
            ),
          ],
        ),
        minX: 0, maxX: data.length > 1 ? (data.length - 1).toDouble() : 1.0,
        minY: minY, maxY: maxY,
        lineBarsData: [
          if (trendSpots.isNotEmpty) LineChartBarData(
            spots: trendSpots, isCurved: false, color: isDark ? Colors.white.withValues(alpha: 0.3) : subTextColor.withValues(alpha: 0.4), barWidth: 2, isStrokeCapRound: true, dashArray: [5, 5],
            dotData: const FlDotData(show: false), belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: spots.isEmpty && data.length == 1 ? [FlSpot(0, selectedMetric.getValue(data[0])), FlSpot(1, selectedMetric.getValue(data[0]))] : spots,
            isCurved: true, curveSmoothness: 0.35, color: color, barWidth: 4, isStrokeCapRound: true,
            shadow: Shadow(color: color.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 8)),
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) => (spot.x.toInt() == maxIndex || spot.x.toInt() == minIndex || data.length < 14),
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: (spot.x.toInt() == maxIndex || spot.x.toInt() == minIndex) ? 6 : 4,
                color: (spot.x.toInt() == maxIndex && !isLowerBetter) || (spot.x.toInt() == minIndex && isLowerBetter) ? const Color(0xFF00C48C) : isDark ? const Color(0xFF1E1E1E) : Colors.white,
                strokeWidth: 3, strokeColor: color,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(colors: [gradientStart, gradientEnd], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) => TouchedSpotIndicatorData(FlLine(color: color.withValues(alpha: 0.3), strokeWidth: 2), FlDotData(getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 5, color: color, strokeWidth: 2, strokeColor: Colors.white)))).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) { HapticFeedback.lightImpact(); return isDark ? const Color(0xFF2C2C2E) : const Color(0xFF1E1E1E).withValues(alpha: 0.95); },
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final i = spot.x.toInt();
                final dateStr = data[i].date;
                final formattedDate = DateFormat('MMM d').format(DateTime.parse(dateStr));
                
                String compStr = "";
                String emoji = "✔️";
                if (i > 0) {
                     final prevVal = selectedMetric.getValue(data[i-1]);
                     final diff = spot.y - prevVal;
                     if (diff == 0) { compStr = "→ stable vs prev day"; emoji = "😐"; }
                     else {
                       String sign = diff > 0 ? "↑ +" : "↓ ";
                       compStr = "$sign${diff.abs().toStringAsFixed(1)} vs prev day";
                       if (isLowerBetter) { emoji = diff > 0 ? "⚠️" : "🚀"; }
                       else { emoji = diff > 0 ? "🚀" : "⚠️"; }
                     }
                }

                return LineTooltipItem(
                  '', const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(text: '$formattedDate\n', style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 11, fontWeight: FontWeight.w600)),
                    TextSpan(text: '${spot.y.toStringAsFixed(1)} ${selectedMetric.unit}\n', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, height: 1.4)),
                    if (i > 0) TextSpan(text: '$emoji $compStr', style: TextStyle(color: emoji == "⚠️" ? const Color(0xFFFF5252) : const Color(0xFF00C48C), fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
