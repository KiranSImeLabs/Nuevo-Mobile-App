import 'package:flutter/material.dart';
import '../../../../data/models/diet_plan_model.dart';
import '../../../../core/theme/app_theme.dart';

class GuidanceDetailBottomSheet extends StatelessWidget {
  final GuidanceModel guidance;

  const GuidanceDetailBottomSheet({Key? key, required this.guidance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Row(
            children: [
              if (guidance.iconUrl != null)
                Container(
                  width: 48,
                  height: 48,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA05E44).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      guidance.iconUrl!,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.info_outline, color: Color(0xFFA05E44)),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guidance.title ?? 'Guidance',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    if (guidance.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        guidance.subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Why This Matters
          if (guidance.whyThisMatters != null) ...[
            _buildSection(
              title: guidance.whyThisMatters?.title ?? 'Why this matters',
              content: guidance.whyThisMatters?.text,
              icon: Icons.lightbulb_outline,
            ),
            const SizedBox(height: 24),
          ],
          
          // How to Achieve
          if (guidance.howToAchieve != null && guidance.howToAchieve!.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xFFA05E44), size: 20),
                const SizedBox(width: 8),
                Text(
                  'How to achieve this',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...guidance.howToAchieve!.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA05E44),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.title != null)
                          Text(
                            item.title!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        if (item.text != null)
                          Text(
                            item.text!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF616161),
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
          
          // Close Button
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA05E44),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Got it',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, String? content, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFA05E44), size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
        if (content != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF616161),
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
