import 'package:flutter/material.dart';

class HealthParameterMeter extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final double optimalStart;
  final double optimalEnd;
  final String status;

  const HealthParameterMeter({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.optimalStart,
    required this.optimalEnd,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // We consider the whole width as corresponding to the range [0, max].
    // If max is 0 (invalid), default to 1 to prevent division by zero.
    final double safeMax = max <= 0 ? 1 : max;
    
    // Also protect against potential min values less than 0 for bounds checking
    // though the UI typically treats 0 as the absolute minimum.
    final double safeMin = min < 0 ? 0 : min;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth.isInfinite ? 300 : constraints.maxWidth;
        if (width <= 0) return const SizedBox();

        const double barHeight = 4.0; // Thinner bars to match design
        const double markerWidth = 8.0; // Slightly smaller base
        const double markerHeight = 16.0; // Slightly shorter pin
        const double gap = 6.0; // Gap between segments
        
        final double barOuterMargin = width * 0.05;
        final double startX = barOuterMargin;
        final double endX = width - barOuterMargin;
        final double drawableWidth = endX - startX;

        // Map a value to an exact left position on the colored bar axis
        // We calculate progress relative to the absolute range [0, max]
        double getXForValue(double v) {
          final double progress = (v / safeMax).clamp(0.0, 1.0);
          return startX + (progress * drawableWidth);
        }

        final double minX = getXForValue(safeMin);
        final double optimalStartX = getXForValue(optimalStart);
        final double optimalEndX = getXForValue(optimalEnd);
        final double maxX = getXForValue(safeMax);

        // Determine which segments are visible based on the new logic
        final bool showLow = optimalStart > safeMin;
        final bool showOptimal = optimalEnd > optimalStart;
        final bool showHigh = safeMax > optimalEnd;

        // Calculate exact horizontal bounds for each bar segment to perfectly fit
        // within the relative start and end points of each segment.
        final double lowLeft = minX;
        final double lowRight = (showOptimal || showHigh) ? optimalStartX - (gap / 2) : optimalStartX;

        final double optimalLeft = showLow ? optimalStartX + (gap / 2) : optimalStartX;
        final double optimalRight = showHigh ? optimalEndX - (gap / 2) : optimalEndX;

        final double highLeft = (showOptimal || showLow) ? optimalEndX + (gap / 2) : optimalEndX;
        final double highRight = maxX;

        final double lowWidth = (lowRight - lowLeft).clamp(0.0, double.infinity);
        final double optimalBarWidth = (optimalRight - optimalLeft).clamp(0.0, double.infinity);
        final double highWidth = (highRight - highLeft).clamp(0.0, double.infinity);

        // Indicator position maps the exact value directly to corresponding pixel
        final double indicatorX = getXForValue(value);
        
        double markerLeftOffset = indicatorX - (markerWidth / 2);
        
        // Prevent bounding box overflow absolutely
        if (markerLeftOffset < 0) {
          markerLeftOffset = 0;
        } else if (markerLeftOffset > width - markerWidth) {
          markerLeftOffset = width - markerWidth;
        }

        const Color markerColor = Color(0xFF1E1E1E);

        return SizedBox(
          height: 24, // Container must be taller to fit marker and bar
          width: width,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Low Range Section (Light Orange)
              if (showLow && lowWidth > 0)
                Positioned(
                  left: lowLeft,
                  width: lowWidth,
                  top: (24 - barHeight) / 2,
                  child: Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDAB9), // Softer peach/orange
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                ),
              
              // Optimal Range Section (Green)
              if (showOptimal && optimalBarWidth > 0)
                Positioned(
                  left: optimalLeft,
                  width: optimalBarWidth,
                  top: (24 - barHeight) / 2,
                  child: Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C48C), // Vibrant mint green matching design
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                ),
              
              // High Range Section (Light Red)
              if (showHigh && highWidth > 0)
                Positioned(
                  left: highLeft,
                  width: highWidth,
                  top: (24 - barHeight) / 2,
                  child: Container(
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFCDD2), // Soft red/pink
                      borderRadius: BorderRadius.circular(barHeight / 2),
                    ),
                  ),
                ),

              // 2. Vertical Indicator Marker (The requested pin shape)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                left: markerLeftOffset,
                top: (24 - markerHeight) / 2, // Centered vertically across the bar
                child: Container(
                  width: markerWidth,
                  height: markerHeight,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // The top vertical line piece of the pin
                      Container(
                        width: 2.5, // Thinner needle base
                        height: markerHeight,
                        decoration: BoxDecoration(
                          color: markerColor,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                      // The circular base piece of the pin
                      // Position it slightly protruding downward for the bottom bump
                      Positioned(
                        bottom: -2,
                        child: Container(
                          width: markerWidth,
                          height: markerWidth,
                          decoration: const BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
