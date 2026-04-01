import 'dart:math' as math;
import 'package:flutter/material.dart';

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
      ..color = const Color(0xFFA05E44) // dark brown
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
