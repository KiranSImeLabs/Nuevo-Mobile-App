import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Payments',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.credit_card, size: 64, color: Colors.grey[300]),
               const SizedBox(height: 16),
               Text(
                 'No payment methods added',
                 style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
               ),
               const SizedBox(height: 24),
               ElevatedButton(
                 onPressed: () {},
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF964A38),
                   foregroundColor: Colors.white,
                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                 ),
                 child: const Text('Add Payment Method'),
               ),
             ],
          ),
        ),
      ),
    );
  }
}
