import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/health_provider.dart';
import '../../../../domain/models/health/patient_habit_history.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD9D9D9)
      ..style = PaintingStyle.fill;

    const spacing = 8.0;
    const dotRadius = 1.5;
    double startX = dotRadius;
    while (startX < size.width - dotRadius) {
      canvas.drawCircle(Offset(startX, size.height / 2), dotRadius, paint);
      startX += spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StepGoalArcPainter extends CustomPainter {
  final double progress;
  StepGoalArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final paintBg = Paint()
      ..color = const Color(0xFFEBE6E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final paintFg = Paint()
      ..color =
          const Color(0xFFA05E44) // dark brown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final startAngle = 135 * math.pi / 180;
    final sweepAngle = 270 * math.pi / 180;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paintBg,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      paintFg,
    );
  }

  @override
  bool shouldRepaint(covariant StepGoalArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class HealthInsightsTab extends ConsumerStatefulWidget {
  const HealthInsightsTab({super.key});

  @override
  ConsumerState<HealthInsightsTab> createState() => _HealthInsightsTabState();
}

class _HealthInsightsTabState extends ConsumerState<HealthInsightsTab> {
  final Map<String, Map<String, String>> _dailyData = {};
  late DateTime _selectedDate;
  final ScrollController _dateScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initializeDataFor(_selectedDate);
    
    // Scroll date selector to the end (today) after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dateScrollController.hasClients) {
        _dateScrollController.jumpTo(_dateScrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
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

  Map<String, String> get _currentData =>
      _dailyData[_formatDateKey(_selectedDate)]!;

  void _showHrMmDialog(String title, String dataKey, String currentValue) {
    final parts = currentValue.split(':');
    int initialHours = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    int initialMinutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    int selectedHours = initialHours;
    int selectedMinutes = initialMinutes;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42332D),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _updateValue(
                          dataKey,
                          '${selectedHours.toString()}:${selectedMinutes.toString().padLeft(2, '0')}',
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                          color: Color(0xFFA05E44),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              SizedBox(
                height: 200,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: Duration(
                    hours: initialHours,
                    minutes: initialMinutes,
                  ),
                  onTimerDurationChanged: (Duration newDuration) {
                    selectedHours = newDuration.inHours;
                    selectedMinutes = newDuration.inMinutes % 60;
                  },
                ),
              ),
            ],
          ),
          ),
        );
      },
    );
  }

  void _showNumberDialog(
    String title,
    String dataKey,
    String currentValue,
    String suffix, {
    bool isDecimal = false,
  }) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Update $title',
            style: const TextStyle(color: Color(0xFF42332D)),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
            decoration: InputDecoration(
              suffixText: suffix,
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA05E44)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _updateValue(dataKey, controller.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA05E44),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateSelector() {
    final today = DateTime.now();
    final List<DateTime> pastDays = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    return Container(
      height: 76,
      margin: const EdgeInsets.only(bottom: 24),
      child: ListView.builder(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: pastDays.length,
        itemBuilder: (context, index) {
          final date = pastDays[index];
          final isSelected =
              _formatDateKey(date) == _formatDateKey(_selectedDate);

          final dayName = DateFormat('EE').format(date);
          final dayNum = DateFormat('d').format(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _initializeDataFor(_selectedDate);
              });
            },
            child: Container(
              width: 55,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFA05E44)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA05E44)
                      : const Color(0xFFDCD2CE),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : const Color(0xFFA0A0A0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 18,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF42332D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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

  void _showStressLevelDialog(String title, String dataKey, String currentValue) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42332D),
                      ),
                    ),
                    const SizedBox(width: 60), // Space for balance
                  ],
                ),
              ),
              const Divider(height: 1),
              _buildStressListOption("Normal", currentValue, dataKey),
              _buildStressListOption("Medium", currentValue, dataKey),
              _buildStressListOption("High", currentValue, dataKey),
              const SizedBox(height: 16),
            ],
          ),
          ),
        );
      },
    );
  }

  Widget _buildStressListOption(String level, String currentValue, String dataKey) {
    final isSelected = level == currentValue;
    return InkWell(
      onTap: () {
        _updateValue(dataKey, level);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        width: double.infinity,
        color: isSelected ? const Color(0xFFFCF8F6) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              level,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFFA05E44) : const Color(0xFF42332D),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFFA05E44)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required Widget trailing,
    Widget? bottomContent,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF73584D), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A4A4A),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
            if (bottomContent != null) ...[
              const SizedBox(height: 16),
              bottomContent,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSleepBottomContent(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFEBE6E4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF985A3F), Color(0xFFD49A80)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "You slept -- mins less than yesterday",
          style: TextStyle(fontSize: 12, color: Color(0xFFA0A0A0)),
        ),
      ],
    );
  }

  Widget _buildWaterBottomContent(double progress) {
    final safeProgress = progress.clamp(0.0, 1.0);
    final fillFlex = (safeProgress * 1000).toInt();
    final emptyFlex = ((1.0 - safeProgress) * 1000).toInt();

    return Row(
      children: [
        if (fillFlex > 0)
          Expanded(
            flex: fillFlex,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF6B8BE8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        if (fillFlex > 0 && emptyFlex > 0)
          const SizedBox(width: 8),
        if (emptyFlex > 0)
          Expanded(
            flex: emptyFlex,
            child: SizedBox(
              height: 8,
              child: CustomPaint(painter: DottedLinePainter()),
            ),
          ),
      ],
    );
  }

  Widget _buildScreenTimeBottomContent(double progress) {
    return Stack(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFEBE6E4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC37A5D), Color(0xFFE2B7A5)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
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
                Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE6E4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  height: 8,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFFA0A0A0)),
        ),
      ],
    );
  }

  Widget _buildStepGoalCard(Map<String, String> data) {
    final currentStepsText = data['steps'] ?? '0';
    final currentSteps = int.tryParse(currentStepsText) ?? 0;
    final goalStepsText = data['stepGoal'] ?? '8000';
    final goalSteps = int.tryParse(goalStepsText) ?? 1;
    final progress = (currentSteps / goalSteps).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => _showNumberDialog(
        "Daily Step Goal",
        "steps",
        currentStepsText,
        "steps",
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.speed_outlined,
                        color: Color(0xFF73584D),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Daily Step Goal",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A4A4A),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        NumberFormat('#,##0').format(currentSteps),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF42332D),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "steps",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You reached ${(progress * 100).toInt()}% of your step goal",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFA0A0A0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: StepGoalArcPainter(progress)),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          NumberFormat('#,##0').format(currentSteps),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF42332D),
                          ),
                        ),
                        Text(
                          "${NumberFormat('#,##0').format(goalSteps)} steps",
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyLevelCard(Map<String, String> data) {
    final List<String> energyLevels = ["Exhausted", "Low", "Balanced", "Good", "Radiant"];
    final energy = data['energyLevel'] ?? 'Balanced';
    int currentIndex = energyLevels.indexOf(energy);
    if (currentIndex == -1) currentIndex = 2; // Default to 'Balanced'

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF42332D).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF2EAE5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFCF8F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt_outlined, color: Color(0xFFA05E44), size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Energy Level",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42332D),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "How do you feel today?",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA0A0A0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2EAE5), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("EXHAUSTED",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: currentIndex <= 1
                                ? const Color(0xFFA05E44)
                                : const Color(0xFFAFA49F))),
                    Text("BALANCED",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: currentIndex == 2
                                ? const Color(0xFFA05E44)
                                : const Color(0xFFAFA49F))),
                    Text("RADIANT",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: currentIndex >= 3
                                ? const Color(0xFFA05E44)
                                : const Color(0xFFAFA49F))),
                  ],
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: const Color(0xFFF2EAE5),
                    inactiveTrackColor: const Color(0xFFF2EAE5),
                    thumbColor: const Color(0xFFA05E44),
                    overlayColor: const Color(0xFFA05E44).withValues(alpha: 0.1),
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 4),
                  ),
                  child: Slider(
                    value: currentIndex.toDouble(),
                    min: 0,
                    max: 4,
                    divisions: 4,
                    onChanged: (val) {
                      _updateValue('energyLevel', energyLevels[val.toInt()]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      bool isSelected = index == currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 12 : 6,
                        height: isSelected ? 12 : 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFFA05E44)
                              : const Color(0xFFDCCDC6),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFA05E44).withValues(alpha: 0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                  )
                                ]
                              : [],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _currentData;

    return Column(
      children: [
        _buildDateSelector(),
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
                  const Icon(
                    Icons.monitor_heart_outlined,
                    color: Color(0xFF73584D),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Daily Log - ${DateFormat('MMM d, yyyy').format(_selectedDate)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF42332D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildEnergyLevelCard(data),
              _buildMetricCard(
                icon: Icons.bedtime_outlined,
                title: "Average Sleep",
                trailing: _buildValuePill(
                  _formatHrMmDisplay(data['sleep']!),
                  showArrow: false,
                ),
                bottomContent: _buildSleepBottomContent(_parseHrMmToHours(data['sleep']!) / 8.0),
                onTap: () =>
                    _showHrMmDialog("Average Sleep", "sleep", data['sleep']!),
              ),
              _buildMetricCard(
                icon: Icons.water_drop_outlined,
                title: "Water Intake",
                trailing: _buildValuePill(
                  "${data['water']} L",
                  showArrow: true,
                ),
                bottomContent: _buildWaterBottomContent((double.tryParse(data['water']!) ?? 0.0) / 4.0),
                onTap: () => _showNumberDialog(
                  "Water Intake",
                  "water",
                  data['water']!,
                  "L",
                  isDecimal: true,
                ),
              ),
              _buildMetricCard(
                icon: Icons.smartphone_outlined,
                title: "Daily Screen Time",
                trailing: _buildValuePill(
                  _formatHrMmDisplay(data['screenTime']!),
                  showArrow: true,
                ),
                bottomContent: _buildScreenTimeBottomContent(_parseHrMmToHours(data['screenTime']!) / 2.0),
                onTap: () => _showHrMmDialog(
                  "Daily Screen Time",
                  "screenTime",
                  data['screenTime']!,
                ),
              ),
              _buildMetricCard(
                icon: Icons.person_outline,
                title: "Stress Level",
                trailing: _buildValuePill(data['stressLevel']!, showArrow: true),
                bottomContent: _buildStressBottomContent(data['stressLevel']!),
                onTap: () => _showStressLevelDialog("Stress Level", "stressLevel", data['stressLevel']!),
              ),
              _buildStepGoalCard(data),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final data = _currentData;
              final history = PatientHabitHistory(
                date: _formatDateKey(_selectedDate),
                sleepHours: _parseHrMmToHours(data['sleep']!),
                waterIntake: double.tryParse(data['water']!) ?? 0.0,
                screenTime: _parseHrMmToHours(data['screenTime']!),
                stressLevel: data['stressLevel']!,
                stepsCount: int.tryParse(data['steps']!) ?? 0,
                energyLevel: data['energyLevel'] ?? 'Balanced',
              );

              try {
                final result = await ref.read(healthRepositoryProvider).savePatientHabitHistory(history);
                if (!mounted) return;
                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save: ${failure.message}')),
                    );
                  },
                  (success) {
                    ref.invalidate(patientHabitHistoryProvider(_formatDateKey(_selectedDate)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Daily metrics saved successfully!'),
                        backgroundColor: Color(0xFFA05E44),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error saving daily metrics.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA05E44),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Save Daily Metrics",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
