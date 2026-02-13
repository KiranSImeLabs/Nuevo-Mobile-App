import 'package:flutter/material.dart';

/// App Color Palette (Extracted from Figma Design)
class AppColors {
  // Primary Colors - Deep Maroon/Burgundy
  static const Color primaryColor = Color(0xFF4A0E0E);
  static const Color primaryDark = Color(0xFF3A0808);
  static const Color primaryLight = Color(0xFF6A1E1E); //964a38
  //static const Color primaryButtonColor = Color(0xFF964a38);//
  static const Color primaryButtonColor = Color(0xFF964A38);

  // Background Colors - Light Beige/Cream
  static const Color backgroundColor = Color(0xFFF9F5F2);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFFFFBF8);
  
  // Health Status Indicators
  static const Color optimalGreen = Color(0xFF4CAF50);
  static const Color suboptimalOrange = Color(0xFFFF9800);
  static const Color criticalRed = Color(0xFFE53935);
  
  // Neutral Grays
  static const Color textPrimary = Colors.black; //Color(0xFF212121);
  //static const Color textSecondary = Color(0xFF757575);//
  static const Color textSecondary = Color(0xFF735B4D);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Functional Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color shimmer = Color(0xFFE0E0E0);
}

/// App Text Styles (Based on Figma Typography)
class AppTextStyles {
  // Font Family (Inter or System Default)
  static const String fontFamily = 'Inter';
  
  // Headers
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    height: 1.4,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    height: 1.4,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
    height: 1.5,
  );
  
  // Special Text Styles
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
    height: 1.3,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
}

/// App Theme Configuration
class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryLight,
      surface: AppColors.backgroundColor,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundColor,
    
    // App Bar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cardBackground,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h3,
    ),
    
    // Card
    cardTheme: const CardThemeData(
      color: AppColors.cardBackground,
      elevation: 2,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    
    // Elevated Button (Primary Button - Pill Shaped)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Pill shape
        ),
        textStyle: AppTextStyles.button,
        elevation: 2,
      ),
    ),
    
    // Outlined Button (Secondary Button)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        side: const BorderSide(color: AppColors.primaryColor, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),
    
    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTextStyles.button,
      ),
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      labelStyle: AppTextStyles.label,
    ),
    
    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      headlineMedium: AppTextStyles.h4,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.label,
      labelSmall: AppTextStyles.caption,
    ),
  );
  
  // Dark Theme (Optional - for future enhancement)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // TODO: Implement dark theme based on Figma if provided
  );
}

/// Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
  
  // Screen Edge Padding
  static const double screenPadding = 16.0;
  
  // Card Padding
  static const double cardPadding = 16.0;
  
  // Section Spacing
  static const double sectionSpacing = 24.0;
}

/// Border Radius Constants
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double pill = 30.0; // For pill-shaped buttons
  static const double circle = 999.0; // For circular elements
}

/// Animation Durations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
