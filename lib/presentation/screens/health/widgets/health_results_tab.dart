import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/health_provider.dart';
import '../../../providers/lab_reports_provider.dart';
import '../../../widgets/common/dashed_border.dart';
import '../lab_reports/components/lab_report_card.dart';

class HealthResultsTab extends ConsumerWidget {
  const HealthResultsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labReportsAsync = ref.watch(labReportsProvider);
    final labReportsData = labReportsAsync.valueOrNull;
    final int reportCount = labReportsData?.reports?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labReportsAsync.when(
          data: (labReportsData) {
            if (labReportsData == null || labReportsData.reports == null || labReportsData.reports!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: Text(AppStrings.noLabReportsFound)),
              );
            }

            return Column(
              children: labReportsData.reports!.map((report) {
                // Determine icon based on some logic or default
                IconData icon = Icons.science_outlined;
                if (report.testType != null) {
                  final type = report.testType!.toLowerCase();
                  if (type.contains('lipid')) {
                    icon = Icons.grid_on_outlined;
                  } else if (type.contains('vitamin')) {
                    icon = Icons.coronavirus_outlined;
                  }
                }

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
                  child: LabReportCard(
                    icon: icon,
                    title: report.testType ?? AppStrings.labReport,
                    date: displayDate,
                    iconColor: const Color(0xFFA05E44),
                    onTap: () {
                      context.push('/health/result-details', extra: report);
                    },
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Color(0xFFA05E44)),
            ),
          ),
          error: (error, stack) {
            debugPrint('$error');
            //Error loading lab reports: 
            return const Center(child: Text(AppStrings.unableToLoadLabReports));
          },
        ),
        // View All Lab Reports Button
        InkWell(
          onTap: () {
            context.push('/health/lab-reports-list');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF8F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5D5D0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: Color(0xFFA05E44), size: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'View All Lab Reports',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You have $reportCount ${reportCount == 1 ? 'report' : 'reports'} available',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFBDBDBD), size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Update Lab Reports Entry Point
        InkWell(
          onTap: () {
            context.push('/health/update-lab-reports');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF8F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5D5D0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.note_add_outlined, color: Color(0xFFA05E44), size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Lab Reports',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manually enter biomarker data',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFBDBDBD), size: 16),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),
        
        // Upload Lab Report Entry Point
        InkWell(
          onTap: () {
            context.push('/health/upload-lab-report');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF8F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5D5D0), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.file_upload_outlined, color: Color(0xFFA05E44), size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Lab Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Upload your report (PDF or Image)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFBDBDBD), size: 16),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppSpacing.xl),
        
        // Book New Test Section
        InkWell(
          onTap: () {
            _showBookNewTestDialog(context, ref);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: DashedBorder.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA05E44),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  AppStrings.bookNewTest,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  AppStrings.bookNewTestDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBookNewTestDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController notesController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.bookNewTest,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E1E1E),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (!isLoading) {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(Icons.close, color: Color(0xFF757575)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                        const Text(
                          'Please provide some details or notes for your new lab test request.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: notesController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: "E.g., Complete blood count, lipid profile...",
                            hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                            filled: true,
                            fillColor: const Color(0xFFF9F9F9),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFA05E44)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final notes = notesController.text.trim();
                                    if (notes.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please enter some notes')),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      await ref.read(createLabRequestProvider(notes).future);

                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                        _showSuccessDialog(context);
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to book test: $e')),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA05E44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Submit Request',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }

      void _showSuccessDialog(BuildContext context) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4CAF50),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Request Submitted',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your lab test request has been sent successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA05E44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
