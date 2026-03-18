import 'package:flutter/material.dart';

class LabReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final Color iconColor;
  final VoidCallback? onTap;

  const LabReportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EAE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFFA05E44),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
