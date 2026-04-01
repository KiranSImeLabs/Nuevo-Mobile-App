import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuidanceCard extends StatelessWidget {
  final IconData icon;
  final String? iconUrl;
  final String title;
  final String subtitle;
  final Color iconColor;

  const GuidanceCard({
    super.key,
    required this.icon,
    this.iconUrl,
    required this.title,
    required this.subtitle,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isSvg = iconUrl?.toLowerCase().endsWith('.svg') ?? false;

    return Container(
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
              color: iconUrl != null ? Colors.transparent : iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconUrl != null
                  ? (isSvg
                      ? SvgPicture.network(
                          iconUrl!,
                          placeholderBuilder: (BuildContext context) =>
                              Icon(icon, color: iconColor, size: 24),
                        )
                      : Image.network(
                          iconUrl!,
                          errorBuilder: (ctx, err, stack) =>
                              Icon(icon, color: iconColor, size: 24),
                        ))
                  : Image.asset(
                      'assets/images/daily_nutrition.png',
                      errorBuilder: (ctx, err, stack) =>
                          Icon(icon, color: Colors.white, size: 24),
                    ),
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
                  subtitle,
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
    );
  }
}
