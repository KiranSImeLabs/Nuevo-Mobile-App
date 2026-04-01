import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../domain/models/health/metric_stats.dart';

class HistoricalTrendsInsight extends StatefulWidget {
  final MetricStats stats;

  const HistoricalTrendsInsight({super.key, required this.stats});

  @override
  State<HistoricalTrendsInsight> createState() => _HistoricalTrendsInsightState();
}

class _HistoricalTrendsInsightState extends State<HistoricalTrendsInsight> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Complex chained animation: Card slides up & fades in first (600ms), then AI text types out (1000ms)
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOutQuad))
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic))
    );
    
    _setupAnimation(widget.stats.smartInsight);
    _controller.forward();
  }

  void _setupAnimation(String text) {
    _textAnimation = IntTween(begin: 0, end: text.length).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeOut))
    );
  }

  @override
  void didUpdateWidget(covariant HistoricalTrendsInsight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats.smartInsight != widget.stats.smartInsight) {
      _setupAnimation(widget.stats.smartInsight);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    final textStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
      height: 1.5,
      fontWeight: FontWeight.w500,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 15, offset: Offset(0, 8))],
                border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.08), width: 1.5),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The AI Typewriter magic!
                      Stack(
                        children: [
                          // Ghost text holds exact layout bounds instantly, avoiding jumps
                          Opacity(
                            opacity: 0.0,
                            child: Text(widget.stats.smartInsight, style: textStyle),
                          ),
                          // Actively typing text over the layout
                          Positioned.fill(
                             child: Text(
                               widget.stats.smartInsight.substring(0, _textAnimation.value),
                               style: textStyle.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.85)),
                             )
                          )
                        ]
                      )
                    ],
                  ),
                ],
              )
            ),
          ),
        );
      }
    );
  }
}
