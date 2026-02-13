import 'package:flutter/material.dart';

/// Responsive utility class for adaptive layouts and sizing
class ResponsiveUtils {
  // Screen size breakpoints
  static const double smallScreenMax = 600;
  static const double mediumScreenMax = 900;

  /// Get screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < smallScreenMax) return ScreenSize.small;
    if (width < mediumScreenMax) return ScreenSize.medium;
    return ScreenSize.large;
  }

  /// Check if screen is small (mobile)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < smallScreenMax;
  }

  /// Check if screen is medium (tablet portrait)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= smallScreenMax && width < mediumScreenMax;
  }

  /// Check if screen is large (tablet landscape, desktop)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= mediumScreenMax;
  }

  /// Get responsive spacing based on screen size
  static double spacing(BuildContext context, {required double base}) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return base;
      case ScreenSize.medium:
        return base * 1.2;
      case ScreenSize.large:
        return base * 1.5;
    }
  }

  /// Get responsive font size based on screen size
  static double fontSize(BuildContext context, {required double base}) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return base;
      case ScreenSize.medium:
        return base * 1.1;
      case ScreenSize.large:
        return base * 1.2;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets padding(BuildContext context, {required EdgeInsets base}) {
    final screenSize = getScreenSize(context);
    final multiplier = screenSize == ScreenSize.small
        ? 1.0
        : screenSize == ScreenSize.medium
            ? 1.2
            : 1.5;
    return EdgeInsets.only(
      left: base.left * multiplier,
      top: base.top * multiplier,
      right: base.right * multiplier,
      bottom: base.bottom * multiplier,
    );
  }

  /// Get number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 2;
      case ScreenSize.medium:
        return 3;
      case ScreenSize.large:
        return 4;
    }
  }

  /// Get responsive card width percentage
  static double getCardWidthPercentage(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 0.9; // 90% of screen width
      case ScreenSize.medium:
        return 0.85; // 85% of screen width
      case ScreenSize.large:
        return 0.7; // 70% of screen width
    }
  }

  /// Get horizontal padding for main content
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < smallScreenMax) return 20;
    if (width < mediumScreenMax) return 32;
    return 48;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, {required double base}) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return base;
      case ScreenSize.medium:
        return base * 1.15;
      case ScreenSize.large:
        return base * 1.3;
    }
  }
}

/// Screen size categories
enum ScreenSize {
  small, // < 600dp (mobile)
  medium, // 600-900dp (tablet portrait)
  large, // > 900dp (tablet landscape, desktop)
}
