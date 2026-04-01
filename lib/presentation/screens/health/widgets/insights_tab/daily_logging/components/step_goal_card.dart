import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../painters/step_goal_arc_painter.dart';

class StepGoalCard extends StatelessWidget {
  final String currentStepsText;
  final String goalStepsText;
  final VoidCallback onTap;

  const StepGoalCard({
    super.key,
    required this.currentStepsText,
    required this.goalStepsText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentSteps = int.tryParse(currentStepsText) ?? 0;
    final goalSteps = int.tryParse(goalStepsText) ?? 1;
    final progress = (currentSteps / goalSteps).clamp(0.0, 1.0);

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
}
