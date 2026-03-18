import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// Custom Dashed Border Implementation
class DashedBorder extends BoxBorder {
  const DashedBorder({this.color = const Color(0xFF000000), this.width = 1.0});

  final Color color;
  final double width;

  static DashedBorder all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
  }) {
    return DashedBorder(color: color, width: width);
  }

  @override
  BorderSide get top => BorderSide(color: color, width: width);

  @override
  BorderSide get bottom => BorderSide(color: color, width: width);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    if (borderRadius != null) {
      path.addRRect(borderRadius.toRRect(rect));
    } else {
      path.addRect(rect);
    }

    final Path dashPath = Path();
    const double dashWidth = 5.0;
    const double dashSpace = 3.0;
    double distance = 0.0;

    for (final ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return DashedBorder(color: color, width: width * t);
  }
}
