import 'package:flutter/material.dart';

class InsightRowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Widget? customTrailing;
  final bool showBottomBorder;
  final VoidCallback onTap;

  const InsightRowItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.customTrailing,
    this.showBottomBorder = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: showBottomBorder
              ? Border(
                  bottom: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.1),
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF73584D), size: 24),
            const SizedBox(width: 16),
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
            if (customTrailing != null)
              customTrailing!
            else if (value != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EAE6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: Color(0xFF73584D),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
