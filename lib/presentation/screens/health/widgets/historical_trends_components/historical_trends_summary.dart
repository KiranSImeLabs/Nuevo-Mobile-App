import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'historical_trends_glass_card.dart';
import '../../../../../domain/models/health/health_enums.dart';
import '../../../../../domain/models/health/metric_stats.dart';
import '../../../../../domain/models/health/patient_habit_history.dart';

class HistoricalTrendsSummary extends StatelessWidget {
  final MetricStats stats;
  final List<PatientHabitHistory> rawData;
  final MetricType selectedMetric;

  const HistoricalTrendsSummary({
    super.key, required this.stats, required this.rawData, required this.selectedMetric,
  });

  Widget _buildDetailedBox(String title, String value, IconData icon, String unit, double rawVal, String ctxLabel, bool isScore, Color subTextColor, Color textColor) {
    Color contextColor = subTextColor;
    if (isScore) {
        if (rawVal >= 85) contextColor = const Color(0xFF00C48C);
        else if (rawVal >= 60) contextColor = const Color(0xFFFF8A00);
        else contextColor = const Color(0xFFFF5252);
    } else {
        contextColor = subTextColor;
    }

    return HistoricalTrendsGlassCard(
      applyPadding: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: subTextColor, size: 20),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                   decoration: BoxDecoration(color: contextColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                   child: Text(ctxLabel, style: TextStyle(color: contextColor, fontSize: 10, fontWeight: FontWeight.w700)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                const SizedBox(width: 4),
                Padding(padding: const EdgeInsets.only(bottom: 4.0), child: Text(unit, style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: subTextColor, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color textColor = isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1E1E1E);
    Color subTextColor = isDark ? const Color(0xFFB0BEC5) : const Color(0xFF757575);
    final isLowerBetter = selectedMetric == MetricType.screenTime || selectedMetric == MetricType.stress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(top: 8, bottom: 20), child: Text("Detailed Analysis", style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w800))),
        Row(
          children: [
            Expanded(child: HistoricalTrendsScaleTapCard(child: _buildDetailedBox("Average", stats.avgVal.toStringAsFixed(1), Icons.blur_linear_rounded, selectedMetric.unit, stats.avgVal, stats.goalGap.abs() < 0.1 ? "On Target" : (stats.goalGap > 0 ? "+${stats.goalGap.toStringAsFixed(1)} Gap" : "${stats.goalGap.toStringAsFixed(1)} Gap"), false, subTextColor, textColor))),
            const SizedBox(width: 12),
            Expanded(child: HistoricalTrendsScaleTapCard(child: _buildDetailedBox("Consistency", "${stats.consistencyScore.toStringAsFixed(0)}%", Icons.check_circle_outline_rounded, "rng", stats.consistencyScore, stats.consistencyLabel, true, subTextColor, textColor))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: HistoricalTrendsScaleTapCard(child: _buildDetailedBox("Goal Score", "${stats.goalScore.toStringAsFixed(0)}%", Icons.flag_rounded, "hits", stats.goalScore, stats.goalScore >= 80 ? "Excellent" : "Needs Work", true, subTextColor, textColor))),
            const SizedBox(width: 12),
            Expanded(child: HistoricalTrendsScaleTapCard(child: _buildDetailedBox("Health Score", stats.healthScore.toStringAsFixed(0), Icons.favorite_rounded, "pts", stats.healthScore, stats.healthScoreLabel, true, subTextColor, textColor))),
          ],
        ),
      ],
    );
  }
}

// Micro-Interaction Tap Scale Wrap
class HistoricalTrendsScaleTapCard extends StatefulWidget {
  final Widget child;
  const HistoricalTrendsScaleTapCard({super.key, required this.child});
  @override State<HistoricalTrendsScaleTapCard> createState() => _HistoricalTrendsScaleTapCardState();
}
class _HistoricalTrendsScaleTapCardState extends State<HistoricalTrendsScaleTapCard> {
  double _scale = 1.0;
  @override Widget build(BuildContext context) {
    return GestureDetector(
       onTapDown: (_) { HapticFeedback.lightImpact(); setState(() => _scale = 0.96); },
       onTapUp: (_) => setState(() => _scale = 1.0),
       onTapCancel: () => setState(() => _scale = 1.0),
       child: AnimatedScale(scale: _scale, duration: const Duration(milliseconds: 100), curve: Curves.easeOutCubic, child: widget.child),
    );
  }
}

// Sparkline Reference
class MiniSparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  MiniSparklinePainter({required this.data, required this.lineColor});
  @override void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length == 1) return;
    final paint = Paint()..color = lineColor..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final shadowPaint = Paint()..color = lineColor.withValues(alpha: 0.3)..strokeWidth = 6.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    double minVal = data.reduce(math.min); double maxVal = data.reduce(math.max);
    if (minVal == maxVal) { minVal -= 1; maxVal += 1; }
    final path = Path(); final stepX = size.width / (data.length - 1); final rangeY = maxVal - minVal;
    for (int i = 0; i < data.length; i++) {
        final x = i * stepX; final normalizedY = (data[i] - minVal) / rangeY; final y = size.height - (normalizedY * size.height);
        if (i == 0) path.moveTo(x, y);
        else {
            final prevX = (i - 1) * stepX; final prevY = size.height - (((data[i - 1] - minVal) / rangeY) * size.height);
            path.cubicTo(prevX + stepX / 2, prevY, x - stepX / 2, y, x, y);
        }
    }
    canvas.drawPath(path, shadowPaint); canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant MiniSparklinePainter old) => true;
}
