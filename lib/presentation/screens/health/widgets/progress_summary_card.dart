import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';

class ProgressSummaryCard extends StatelessWidget {
  final int improvedCount;
  final int stableCount;
  final String displayDate;
  final String? reportUrl;

  const ProgressSummaryCard({
    super.key,
    required this.improvedCount,
    required this.stableCount,
    required this.displayDate,
    this.reportUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            improvedCount > 0 ? AppStrings.greatProgress : 'Results Outlook',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$stableCount parameters remained stable since last test.',
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
              if (reportUrl != null && reportUrl!.isNotEmpty)
                InkWell(
                  onTap: () async {
                    final urlString = reportUrl!;
                    developer.log('Attempting to open PDF: $urlString', name: 'PDF_Viewer');
                    
                    try {
                      final url = Uri.parse(urlString);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url, 
                          mode: LaunchMode.inAppBrowserView, 
                        );
                      } else {
                        developer.log('canLaunchUrl returned false for: $urlString', name: 'PDF_Viewer_Error');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cannot open this type of link')),
                          );
                        }
                      }
                    } catch (e, stack) {
                      developer.log('Error launching PDF', error: e, stackTrace: stack, name: 'PDF_Viewer_Exception');
//                      print('PDF LAUNCH ERROR: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error opening report: $e')),
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
    );
  }
}
