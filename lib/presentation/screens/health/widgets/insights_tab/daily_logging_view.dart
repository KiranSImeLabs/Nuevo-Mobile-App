import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/health_provider.dart';
import '../../../../../../domain/models/health/patient_habit_history.dart';
import 'daily_logging/dialogs/daily_log_dialogs.dart';
import 'daily_logging/painters/dotted_line_painter.dart';
import 'daily_logging/components/daily_date_selector.dart';
import 'daily_logging/components/energy_level_card.dart';
import 'daily_logging/components/step_goal_card.dart';
import 'daily_logging/components/metric_input_card.dart';

class DailyLoggingView extends ConsumerStatefulWidget {
  const DailyLoggingView({super.key});

  @override
  ConsumerState<DailyLoggingView> createState() => _DailyLoggingViewState();
}

class _DailyLoggingViewState extends ConsumerState<DailyLoggingView> {
  final Map<String, Map<String, String>> _dailyData = {};
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeDataFor(_selectedDate);
  }

  void _initializeDataFor(DateTime date) async {
    final dateKey = _formatDateKey(date);
    if (!_dailyData.containsKey(dateKey)) {
      setState(() {
        _dailyData[dateKey] = {
          "sleep": "0:00",
          "water": "0",
          "screenTime": "0:00",
          "stressLevel": "Normal",
          "steps": "0",
          "stepGoal": "8000",
          "energyLevel": "Balanced",
        };
      });

      try {
        final history = await ref.read(patientHabitHistoryProvider(dateKey).future);
        if (history != null && mounted) {
           setState(() {
             _dailyData[dateKey] = {
                "sleep": _formatHoursToHrMm(history.sleepHours),
                "water": history.waterIntake.toString(),
                "screenTime": _formatHoursToHrMm(history.screenTime),
                "stressLevel": history.stressLevel,
                "steps": history.stepsCount.toString(),
                "stepGoal": "8000",
                "energyLevel": history.energyLevel,
             };
           });
        }
      } catch (e) {
        // Keep default if fetching fails or data doesn't exist yet
      }
    }
  }

  String _formatHoursToHrMm(double hours) {
    int h = hours.floor();
    int m = ((hours - h) * 60).round();
    return "$h:${m.toString().padLeft(2, '0')}";
  }

  double _parseHrMmToHours(String time) {
    if (time.isEmpty || !time.contains(':')) return 0.0;
    final parts = time.split(':');
    final h = double.tryParse(parts[0]) ?? 0.0;
    final m = parts.length > 1 ? (double.tryParse(parts[1]) ?? 0.0) : 0.0;
    return h + (m / 60.0);
  }

  String _formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatHrMmDisplay(String time) {
    if (time.isEmpty) return "0h 00m";
    final parts = time.split(':');
    final hh = parts.isNotEmpty ? parts[0] : '0';
    final mm = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
    return "${hh}h ${mm}m";
  }

  void _updateValue(String key, String value) {
    setState(() {
      _dailyData[_formatDateKey(_selectedDate)]![key] = value;
    });
  }

  Map<String, String> get _currentData => _dailyData[_formatDateKey(_selectedDate)]!;

  Widget _buildValuePill(String value, {bool showArrow = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EAE6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF42332D),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showArrow) ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF73584D)),
          ],
        ],
      ),
    );
  }

  Widget _buildSleepBottomContent(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(height: 8, decoration: BoxDecoration(color: const Color(0xFFEBE6E4), borderRadius: BorderRadius.circular(4))),
            FractionallySizedBox(widthFactor: progress.clamp(0.0, 1.0), child: Container(height: 8, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF985A3F), Color(0xFFD49A80)]), borderRadius: BorderRadius.circular(4)))),
          ],
        ),
        const SizedBox(height: 8),
        const Text("You slept -- mins less than yesterday", style: TextStyle(fontSize: 12, color: Color(0xFFA0A0A0))),
      ],
    );
  }

  Widget _buildWaterBottomContent(double progress) {
    final safeProgress = progress.clamp(0.0, 1.0);
    final fillFlex = (safeProgress * 1000).toInt();
    final emptyFlex = ((1.0 - safeProgress) * 1000).toInt();

    return Row(
      children: [
        if (fillFlex > 0) Expanded(flex: fillFlex, child: Container(height: 8, decoration: BoxDecoration(color: const Color(0xFF6B8BE8), borderRadius: BorderRadius.circular(4)))),
        if (fillFlex > 0 && emptyFlex > 0) const SizedBox(width: 8),
        if (emptyFlex > 0) Expanded(flex: emptyFlex, child: SizedBox(height: 8, child: CustomPaint(painter: DottedLinePainter()))),
      ],
    );
  }

  Widget _buildScreenTimeBottomContent(double progress) {
    return Stack(
      children: [
        Container(height: 8, decoration: BoxDecoration(color: const Color(0xFFEBE6E4), borderRadius: BorderRadius.circular(4))),
        FractionallySizedBox(widthFactor: progress.clamp(0.0, 1.0), child: Container(height: 8, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFC37A5D), Color(0xFFE2B7A5)]), borderRadius: BorderRadius.circular(4)))),
      ],
    );
  }

  Widget _buildStressBottomContent(String stressLevel) {
    double progress = 0.33;
    List<Color> colors = const [Color(0xFF81C784), Color(0xFF4CAF50)];
    String subtitle = "Your stress levels are balanced";

    if (stressLevel == "Medium") {
      progress = 0.66;
      colors = const [Color(0xFFFFB74D), Color(0xFFFF9800)];
      subtitle = "You are experiencing moderate stress";
    } else if (stressLevel == "High") {
      progress = 1.0;
      colors = const [Color(0xFFE57373), Color(0xFFF44336)];
      subtitle = "Your stress levels are quite high";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(height: 8, width: constraints.maxWidth, decoration: BoxDecoration(color: const Color(0xFFEBE6E4), borderRadius: BorderRadius.circular(4))),
                AnimatedContainer(duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic, height: 8, width: constraints.maxWidth * progress, decoration: BoxDecoration(gradient: LinearGradient(colors: colors, begin: Alignment.centerLeft, end: Alignment.centerRight), borderRadius: BorderRadius.circular(4))),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFFA0A0A0))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _currentData;

    return Column(
      children: [
        DailyDateSelector(
          selectedDate: _selectedDate,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
              _initializeDataFor(_selectedDate);
            });
          },
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2EAE5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.monitor_heart_outlined, color: Color(0xFF73584D), size: 24),
                  const SizedBox(width: 12),
                  Text(
                    "Daily Log - ${DateFormat('MMM d, yyyy').format(_selectedDate)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF42332D)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              EnergyLevelCard(
                currentEnergy: data['energyLevel'] ?? 'Balanced',
                onEnergyChanged: (val) => _updateValue('energyLevel', val),
              ),
              MetricInputCard(
                icon: Icons.bedtime_outlined,
                title: "Average Sleep",
                trailing: _buildValuePill(_formatHrMmDisplay(data['sleep']!), showArrow: false),
                bottomContent: _buildSleepBottomContent(_parseHrMmToHours(data['sleep']!) / 8.0),
                onTap: () => DailyLogDialogs.showHrMmDialog(context: context, title: "Average Sleep", currentValue: data['sleep']!, onSave: (val) => _updateValue("sleep", val)),
              ),
              MetricInputCard(
                icon: Icons.water_drop_outlined,
                title: "Water Intake",
                trailing: _buildValuePill("${data['water']} L", showArrow: true),
                bottomContent: _buildWaterBottomContent((double.tryParse(data['water']!) ?? 0.0) / 4.0),
                onTap: () => DailyLogDialogs.showNumberDialog(context: context, title: "Water Intake", currentValue: data['water']!, suffix: "L", isDecimal: true, onSave: (val) => _updateValue("water", val)),
              ),
              MetricInputCard(
                icon: Icons.smartphone_outlined,
                title: "Daily Screen Time",
                trailing: _buildValuePill(_formatHrMmDisplay(data['screenTime']!), showArrow: true),
                bottomContent: _buildScreenTimeBottomContent(_parseHrMmToHours(data['screenTime']!) / 2.0),
                onTap: () => DailyLogDialogs.showHrMmDialog(context: context, title: "Daily Screen Time", currentValue: data['screenTime']!, onSave: (val) => _updateValue("screenTime", val)),
              ),
              MetricInputCard(
                icon: Icons.person_outline,
                title: "Stress Level",
                trailing: _buildValuePill(data['stressLevel']!, showArrow: true),
                bottomContent: _buildStressBottomContent(data['stressLevel']!),
                onTap: () => DailyLogDialogs.showStressLevelDialog(context: context, title: "Stress Level", currentValue: data['stressLevel']!, onSave: (val) => _updateValue("stressLevel", val)),
              ),
              StepGoalCard(
                currentStepsText: data['steps']!,
                goalStepsText: data['stepGoal']!,
                onTap: () => DailyLogDialogs.showNumberDialog(context: context, title: "Daily Step Goal", currentValue: data['steps']!, suffix: "steps", onSave: (val) => _updateValue("steps", val)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final d = _currentData;
              final history = PatientHabitHistory(
                date: _formatDateKey(_selectedDate),
                sleepHours: _parseHrMmToHours(d['sleep']!),
                waterIntake: double.tryParse(d['water']!) ?? 0.0,
                screenTime: _parseHrMmToHours(d['screenTime']!),
                stressLevel: d['stressLevel']!,
                stepsCount: int.tryParse(d['steps']!) ?? 0,
                energyLevel: d['energyLevel'] ?? 'Balanced',
              );

              try {
                final result = await ref.read(healthRepositoryProvider).savePatientHabitHistory(history);
                if (!mounted) return;
                result.fold(
                  (failure) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: ${failure.message}'))); },
                  (success) {
                    ref.invalidate(patientHabitHistoryProvider(_formatDateKey(_selectedDate)));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily metrics saved successfully!'), backgroundColor: Color(0xFFA05E44), behavior: SnackBarBehavior.floating));
                  },
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error saving daily metrics.')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA05E44), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), elevation: 0),
            child: const Text("Save Daily Metrics", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
