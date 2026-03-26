import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../providers/health_provider.dart';
import '../../../../domain/models/health/patient_habit_history.dart';

enum TimeRange { weekly, monthly, yearly }
enum MetricType { sleep, water, screenTime, stress, steps }

class HistoricalTrendsScreen extends ConsumerStatefulWidget {
  const HistoricalTrendsScreen({super.key});

  @override
  ConsumerState<HistoricalTrendsScreen> createState() => _HistoricalTrendsScreenState();
}

class _HistoricalTrendsScreenState extends ConsumerState<HistoricalTrendsScreen> {
  TimeRange _selectedRange = TimeRange.weekly;
  MetricType _selectedMetric = MetricType.sleep;

  String _getMetricName(MetricType type) {
    switch (type) {
      case MetricType.sleep:
        return "Sleep (Hrs)";
      case MetricType.water:
        return "Water (L)";
      case MetricType.screenTime:
        return "Screen Time (Hrs)";
      case MetricType.stress:
        return "Stress Level";
      case MetricType.steps:
        return "Steps";
    }
  }

  IconData _getMetricIcon(MetricType type) {
    switch (type) {
      case MetricType.sleep:
        return Icons.bedtime_outlined;
      case MetricType.water:
        return Icons.water_drop_outlined;
      case MetricType.screenTime:
        return Icons.smartphone_outlined;
      case MetricType.stress:
        return Icons.person_outline;
      case MetricType.steps:
        return Icons.speed_outlined;
    }
  }

  double _getMetricValue(PatientHabitHistory history, MetricType type) {
    switch (type) {
      case MetricType.sleep:
        return history.sleepHours;
      case MetricType.water:
        return history.waterIntake;
      case MetricType.screenTime:
        return history.screenTime;
      case MetricType.stress:
        if (history.stressLevel == "High") return 3.0;
        if (history.stressLevel == "Medium") return 2.0;
        return 1.0;
      case MetricType.steps:
        return history.stepsCount.toDouble();
    }
  }

  List<PatientHabitHistory> _filterData(List<PatientHabitHistory> allData) {
    final now = DateTime.now();
    DateTime cutoff;
    
    switch (_selectedRange) {
      case TimeRange.weekly:
        cutoff = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.monthly:
        cutoff = now.subtract(const Duration(days: 30));
        break;
      case TimeRange.yearly:
        cutoff = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    final filtered = allData.where((d) {
      try {
        final date = DateTime.parse(d.date);
        return date.isAfter(cutoff) || date.isAtSameMomentAs(cutoff);
      } catch (e) {
        return false;
      }
    }).toList();

    // Sort chronologically
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  Widget _buildRangeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2EAE5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRangeButton("Weekly", TimeRange.weekly),
          _buildRangeButton("Monthly", TimeRange.monthly),
          _buildRangeButton("Yearly", TimeRange.yearly),
        ],
      ),
    );
  }

  Widget _buildRangeButton(String label, TimeRange range) {
    final isSelected = _selectedRange == range;
    return GestureDetector(
      onTap: () => setState(() => _selectedRange = range),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFFA05E44) : const Color(0xFF7A6B65),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: MetricType.values.map((type) {
          final isSelected = _selectedMetric == type;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Row(
                children: [
                  Icon(
                    _getMetricIcon(type),
                    size: 16,
                    color: isSelected ? Colors.white : const Color(0xFF73584D),
                  ),
                  const SizedBox(width: 6),
                  Text(_getMetricName(type)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedMetric = type);
              },
              backgroundColor: const Color(0xFFFDFBFB),
              selectedColor: const Color(0xFFA05E44),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF42332D),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected ? Colors.transparent : const Color(0xFFEBE6E4),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart(List<PatientHabitHistory> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No data available for this range.",
          style: TextStyle(color: Color(0xFF7A6B65), fontSize: 14),
        ),
      );
    }

    List<FlSpot> spots = [];
    double minY = double.maxFinite;
    double maxY = -double.maxFinite;

    for (int i = 0; i < data.length; i++) {
      final val = _getMetricValue(data[i], _selectedMetric);
      spots.add(FlSpot(i.toDouble(), val));
      if (val < minY) minY = val;
      if (val > maxY) maxY = val;
    }

    if (maxY == minY) {
      if (maxY == 0) {
        maxY = 10; 
      } else {
        minY = 0;
        maxY = maxY * 1.5;
      }
    } else {
      double padding = (maxY - minY) * 0.2;
      minY = math.max(0, minY - padding);
      maxY = maxY + padding;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: const Color(0xFFEBE6E4),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: math.max(1, (data.length / 5).floor().toDouble()),
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= data.length) return const SizedBox.shrink();
                final date = DateTime.tryParse(data[value.toInt()].date);
                if (date == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat(_selectedRange == TimeRange.yearly ? 'MMM' : 'MM/dd').format(date),
                    style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    value.toStringAsFixed(1).replaceAll('.0', ''),
                    style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: data.length > 1 ? (data.length - 1).toDouble() : 1.0,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots.isEmpty && data.length == 1 ? [FlSpot(0, _getMetricValue(data[0], _selectedMetric)), FlSpot(1, _getMetricValue(data[0], _selectedMetric))] : spots,
            isCurved: true,
            color: const Color(0xFFA05E44),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: data.length < 30,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: const Color(0xFFA05E44),
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFA05E44).withValues(alpha: 0.3),
                  const Color(0xFFA05E44).withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF42332D),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: data[spot.x.toInt()].date,
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(patientHabitHistoryListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Historical Trends",
          style: TextStyle(color: Color(0xFF42332D), fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF42332D), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRangeToggle(),
          const SizedBox(height: 24),
          _buildMetricSelector(),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: historyAsync.when(
              data: (data) {
                final filtered = _filterData(data);
                return _buildChart(filtered);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFA05E44)),
              ),
              error: (err, stack) => Center(
                child: Text('Error loading data: $err', style: const TextStyle(color: Colors.red)),
              ),
            ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
