import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/lab_report_model.dart';
import '../../providers/health_provider.dart';
import '../../widgets/common/app_error_widget.dart';
import 'widgets/metric_result_card.dart';

class ResultDetailsScreen extends ConsumerWidget {
  final LabReportModel report;

  const ResultDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    
    // Fetch real API data
    final comparisonState = ref.watch(labReportDetailsProvider(report.id!));

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
      body: comparisonState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(labReportDetailsProvider(report.id!)),
        ),
        data: (detailData) {
          if (detailData == null || detailData.comparison?.parameterComparisons == null) {
            return const Center(child: Text("No comparison data available."));
          }
          
          final comparisonData = detailData.comparison!;
          final parameters = comparisonData.parameterComparisons!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Great Progress Card (Can be conditionally rendered based on improved parameters)
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
                      Text(
                        (comparisonData.overallProgress?.improved ?? 0) > 0 
                            ? AppStrings.greatProgress 
                            : 'Results Outlook',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${comparisonData.overallProgress?.stable ?? 0} parameters remained stable since last test.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            displayDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8C8C8C),
                            ),
                          ),
                          if (detailData.reportUrl != null && detailData.reportUrl!.isNotEmpty)
                            InkWell(
                              onTap: () async {
                                final url = Uri.parse(detailData.reportUrl!);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url, 
                                    mode: LaunchMode.inAppBrowserView, // Opens as embedded web page with back button
                                  );
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Could not open the report')),
                                    );
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFE5D5D0)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.picture_as_pdf, size: 14, color: Color(0xFFA05E44)),
                                    SizedBox(width: 6),
                                    Text(
                                      'View Report',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFA05E44),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
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

                // Metrics List Mapped from API Data
                ...parameters.map((param) {
                  final statusString = param.current?.status?.toUpperCase() ?? 'STABLE';
                  
                  MetricStatus metricStatus;
                  switch (statusString) {
                    case 'OPTIMAL':
                      metricStatus = MetricStatus.optimal;
                      break;
                    case 'SUBOPTIMAL':
                      metricStatus = MetricStatus.suboptimal;
                      break;
                    default:
                      metricStatus = MetricStatus.stable;
                  }

                  final val = param.current?.value?.toDouble() ?? 0;

                  // Find matching parameter from comparisonData.parameters since it holds the raw array
                  // We map from comparisonData mapped JSON since report.parameters doesn't exist on LabReportModel
                  var originalParamMax = 1.0;
                  ReferenceRange? originalReferenceRange;
                  
                  if (detailData.parameters != null) {
                    try {
                      final p = detailData.parameters!.firstWhere(
                        (p) => p['name'] == param.parameterName,
                        orElse: () => null,
                      );
                      
                      if (p != null && p['referenceRange'] != null) {
                        originalReferenceRange = ReferenceRange.fromJson(p['referenceRange'] as Map<String, dynamic>);
                        originalParamMax = originalReferenceRange.max?.toDouble() ?? 1.0;
                      }
                    } catch (e) {
                      // Fallback if parsing fails
                    }
                  }

                  double scoreFraction = (val / originalParamMax).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: MetricResultCard(
                      title: param.parameterName ?? 'Unknown Metric',
                      status: metricStatus,
                      value: param.current?.value?.toString() ?? '--',
                      unit: param.current?.unit ?? '',
                      scoreFraction: scoreFraction, 
                      numericValue: val,
                      referenceRange: originalReferenceRange,
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  double calculateScoreFraction({
    required double value,
    required double min,
    required double max,
  }) {
    if (max <= min) return 0.0;

    return ((value - min) / (max - min)).clamp(0.0, 1.0);
  }
}
