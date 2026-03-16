import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/lab_report_model.dart';
import '../../providers/health_provider.dart';
import '../../widgets/common/app_error_widget.dart';
import 'widgets/metric_result_card.dart';
import 'widgets/progress_summary_card.dart';

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
          if (detailData != null) {
            String initialReportStr = const JsonEncoder.withIndent('  ').convert(report.toJson());
            String fullDetailsStr = const JsonEncoder.withIndent('  ').convert(detailData.toJson());
            developer.log('=== INITIAL LAB REPORT ===\n$initialReportStr\n==========================', name: 'LabReport');
            developer.log('=== FULL RESULT DETAILS ===\n$fullDetailsStr\n===========================', name: 'LabReportDetails');
          }

          if (detailData == null) {
            return const Center(child: Text("No data available."));
          }
          
          bool hasComparison = detailData.comparison?.parameterComparisons != null && 
                               detailData.comparison!.parameterComparisons!.isNotEmpty;
          
          bool hasParameters = detailData.parameters != null && 
                               detailData.parameters!.isNotEmpty;

          if (!hasComparison && !hasParameters) {
            return const Center(child: Text("No result data available."));
          }

          final comparisonData = detailData.comparison;
          final parameters = comparisonData?.parameterComparisons ?? [];
          final basicParameters = detailData.parameters ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Great Progress Card (Can be conditionally rendered based on improved parameters)
                ProgressSummaryCard(
                  improvedCount: comparisonData?.overallProgress?.improved ?? 0,
                  stableCount: comparisonData?.overallProgress?.stable ?? 0,
                  displayDate: displayDate,
                  reportUrl: detailData.reportUrl,
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

                // Metrics List Mapped from Comparison API Data
                if (hasComparison) ...parameters.map((param) {
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

                // Fallback: Metrics List Mapped from Basic Parameters Data
                if (!hasComparison && hasParameters) ...basicParameters.map((paramData) {
                  if (paramData is! Map) return const SizedBox.shrink();
                  
                  final name = paramData['name'] ?? paramData['parameterName'] ?? 'Unknown Metric';
                  final valRaw = paramData['value'];
                  final val = valRaw is num ? valRaw.toDouble() : double.tryParse(valRaw?.toString() ?? '0') ?? 0.0;
                  final unit = paramData['unit'] ?? '';
                  final statusString = (paramData['status'] ?? paramData['resultStatus'] ?? 'STABLE').toString().toUpperCase();

                  MetricStatus metricStatus;
                  switch (statusString) {
                    case 'OPTIMAL':
                      metricStatus = MetricStatus.optimal;
                      break;
                    case 'SUBOPTIMAL':
                    case 'ABNORMAL':
                    case 'HIGH':
                    case 'LOW':
                      metricStatus = MetricStatus.suboptimal;
                      break;
                    default:
                      metricStatus = MetricStatus.stable;
                  }

                  var originalParamMax = 1.0;
                  ReferenceRange? originalReferenceRange;
                  
                  if (paramData['referenceRange'] != null) {
                    try {
                      originalReferenceRange = ReferenceRange.fromJson(paramData['referenceRange'] as Map<String, dynamic>);
                      originalParamMax = originalReferenceRange.max?.toDouble() ?? 1.0;
                    } catch (e) {
                      // Ignore
                    }
                  }

                  double scoreFraction = (val / originalParamMax).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: MetricResultCard(
                      title: name.toString(),
                      status: metricStatus,
                      value: valRaw?.toString() ?? '--',
                      unit: unit.toString(),
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
