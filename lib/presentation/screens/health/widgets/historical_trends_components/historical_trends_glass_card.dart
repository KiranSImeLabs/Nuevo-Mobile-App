import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HistoricalTrendsGlassCard extends StatelessWidget {
  final Widget child;
  final bool applyPadding;
  
  const HistoricalTrendsGlassCard({super.key, required this.child, this.applyPadding = true});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: applyPadding ? const EdgeInsets.all(20) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE5DCD8).withValues(alpha: 0.5), width: 1.0),
            boxShadow: isDark ? [] : [
              BoxShadow(color: const Color(0xFFA05E44).withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
