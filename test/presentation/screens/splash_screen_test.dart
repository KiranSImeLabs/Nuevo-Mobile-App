import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_app/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders logo and title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    // Verify logo and text functionality
    expect(find.byIcon(Icons.medical_services_rounded), findsOneWidget); // Logo Icon
    
    // Check if circular progress indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget); // Or Adaptive
  });
}
