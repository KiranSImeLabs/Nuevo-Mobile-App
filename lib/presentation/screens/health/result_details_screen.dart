import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/lab_report_model.dart';
import 'widgets/metric_result_card.dart';

class ResultDetailsScreen extends StatelessWidget {
  final LabReportModel report;

  const ResultDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    // Format Date
    String displayDate = 'Unknown Date';
    if (report.testDate != null) {
      try {
        final date = DateTime.parse(report.testDate!);
        displayDate = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        displayDate = report.testDate!;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9), // Matching standard app background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          AppStrings.resultDetails,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Great Progress Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EAE8), // Matches design
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA05E44),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.insights_outlined, // Placeholder for the node graph icon
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.greatProgress,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.healthScoreImprovementDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Key Improvements Title
            const Text(
               AppStrings.keyImprovements,
               style: TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.w500,
                 color: Color(0xFF1E1E1E),
               ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Metrics List (Mocked data perfectly matching the UI design)
            const MetricResultCard(
              title: AppStrings.totalCholesterol,
              status: MetricStatus.optimal,
              value: '180',
              unit: AppStrings.ngMl,
              scoreFraction: 0.85, // Position in the center green optimal band
            ),
            const SizedBox(height: AppSpacing.md),
            const MetricResultCard(
              title: AppStrings.vitaminD,
              status: MetricStatus.suboptimal,
              value: '45',
              unit: AppStrings.ngMl,
              scoreFraction: 0.8, // Position in the right red suboptimal band
            ),
            const SizedBox(height: AppSpacing.md),
            const MetricResultCard(
              title: AppStrings.ironFerritin,
              status: MetricStatus.stable,
              value: '92',
              unit: AppStrings.ngMl,
              scoreFraction: 0.35, // Position in the left yellow-ish band border
            ),
          ],
        ),
      ),
    );
  }
}
