import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class HealthInsightsTab extends StatefulWidget {
  const HealthInsightsTab({super.key});

  @override
  State<HealthInsightsTab> createState() => _HealthInsightsTabState();
}

class _HealthInsightsTabState extends State<HealthInsightsTab> {
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

  void _initializeDataFor(DateTime date) {
    final dateKey = _formatDateKey(date);
    if (!_dailyData.containsKey(dateKey)) {
      _dailyData[dateKey] = {
        "sleep": "0:00",
        "water": "0",
        "screenTime": "0:00",
        "stressLevel": "-",
        "steps": "0",
        "stepGoal": "8000",
      };
    }
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
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
                        'Save',
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
              child: const Text('Save'),
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
                      : const Color(0xFFEBE6E4),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
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

  Widget _buildSleepBottomContent() {
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
              widthFactor: 0.75,
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
          "You slept 30 mins less than yesterday",
          style: TextStyle(fontSize: 12, color: Color(0xFFA0A0A0)),
        ),
      ],
    );
  }

  Widget _buildWaterBottomContent() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF6B8BE8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 8,
            child: CustomPaint(painter: DottedLinePainter()),
          ),
        ),
      ],
    );
  }

  Widget _buildScreenTimeBottomContent() {
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
          widthFactor: 0.6,
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

  @override
  Widget build(BuildContext context) {
    final data = _currentData;

    return Column(
      children: [
        _buildDateSelector(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFCF8F6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.monitor_heart_outlined,
                    color: Color(0xFF73584D),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Daily Metrics",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF42332D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildMetricCard(
                icon: Icons.bedtime_outlined,
                title: "Average Sleep",
                trailing: _buildValuePill(
                  _formatHrMmDisplay(data['sleep']!),
                  showArrow: false,
                ),
                bottomContent: _buildSleepBottomContent(),
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
                bottomContent: _buildWaterBottomContent(),
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
                bottomContent: _buildScreenTimeBottomContent(),
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
            onPressed: () {
              // Add save logic here. You can access the current day's data via _currentData
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Daily metrics saved successfully!'),
                  backgroundColor: Color(0xFFA05E44),
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
        const SizedBox(height: 40),
      ],
    );
  }
}
