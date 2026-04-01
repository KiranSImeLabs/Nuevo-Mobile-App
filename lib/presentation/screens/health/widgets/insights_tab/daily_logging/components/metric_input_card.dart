import 'package:flutter/material.dart';

class MetricInputCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final Widget? bottomContent;
  final VoidCallback? onTap;

  const MetricInputCard({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.bottomContent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF73584D), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A4A4A),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
            if (bottomContent != null) ...[
              const SizedBox(height: 16),
              bottomContent!,
            ],
          ],
        ),
      ),
    );
  }
}
