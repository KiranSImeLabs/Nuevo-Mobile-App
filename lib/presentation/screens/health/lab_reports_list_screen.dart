import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../providers/health_provider.dart';
import '../../providers/lab_reports_provider.dart';

class LabReportsListScreen extends ConsumerWidget {
  const LabReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labReportsAsync = ref.watch(labReportsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'All Lab Reports',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: labReportsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFA05E44)),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load reports',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(labReportsProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA05E44),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (labReportsData) {
          if (labReportsData == null || labReportsData.reports == null || labReportsData.reports!.isEmpty) {
            return const Center(
              child: Text(
                AppStrings.noLabReportsFound,
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
            );
          }

          // Filter reports to only show those with a PDF URL
          final pdfReports = labReportsData.reports!
              .where((r) => r.reportUrl != null && r.reportUrl!.isNotEmpty)
              .toList();
              
          if (pdfReports.isEmpty) {
            return const Center(
              child: Text(
                'No PDF lab reports found.',
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(labReportsProvider),
            color: const Color(0xFFA05E44),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: pdfReports.length,
              itemBuilder: (context, index) {
                final report = pdfReports[index];
                
                // We no longer need custom testType logic for the icon because 
                // we are going to treat every row purely as a generic PDF document file.

                // Format Date
                String displayDate = AppStrings.unknownDate;
                if (report.testDate != null) {
                  try {
                    final date = DateTime.parse(report.testDate!);
                    displayDate = DateFormat('MMM dd, yyyy').format(date);
                  } catch (e) {
                    displayDate = report.testDate!;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: InkWell(
                    onTap: () async {
                      // We already filtered for non-null reportUrl
                      final urlString = report.reportUrl!;
                      developer.log('Attempting to open PDF: $urlString', name: 'PDF_Viewer_List');
                      
                      try {
                        final url = Uri.parse(urlString);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url, 
                            mode: LaunchMode.inAppBrowserView, 
                          );
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cannot open this type of link')),
                            );
                          }
                        }
                      } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error loading report: $e')),
                            );
                          }
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    splashColor: const Color(0xFFD32F2F).withOpacity(0.05),
                    highlightColor: const Color(0xFFD32F2F).withOpacity(0.02),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF2E9E6), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Color(0xFFD32F2F),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${report.testType ?? AppStrings.labReport} Report.pdf',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A1A),
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      'PDF Document',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF757575),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Icon(Icons.circle, size: 4, color: Colors.grey[300]),
                                    ),
                                    Text(
                                      displayDate,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8F9FA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.visibility_outlined,
                              color: Color(0xFF424242),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
