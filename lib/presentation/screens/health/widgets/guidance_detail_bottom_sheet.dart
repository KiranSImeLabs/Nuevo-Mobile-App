import 'package:flutter/material.dart';
import '../../../../data/models/diet_plan_model.dart';
import '../../../../core/theme/app_theme.dart';

class GuidanceDetailBottomSheet extends StatelessWidget {
  final GuidanceModel guidance;

  const GuidanceDetailBottomSheet({Key? key, required this.guidance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF735B4D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nutrition Details',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Main Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EAE8), // Light pink/brown background
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA05E44), // Rust icon background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: guidance.iconUrl != null
                          ? Image.network(
                              guidance.iconUrl!,
                              color: Colors.white,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.restaurant, color: Colors.white, size: 24),
                            )
                          : const Icon(Icons.restaurant, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    guidance.title ?? 'Guidance',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400, // Medium/Regular weight
                      color: Color(0xFF2B1B18),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    guidance.subtitle ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C7970), // Slightly lighter brown text
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Why this matters Card
            if (guidance.whyThisMatters != null)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Thin rust line on LHS
                      Container(
                        width: 3,
                        decoration: const BoxDecoration(
                          color: Color(0xFFA05E44),
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lightbulb_outline,
                                    color: Color(0xFF735B4D),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    guidance.whyThisMatters?.title ?? 'Why this matters',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF735B4D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Faint inner divider
                              Container(
                                height: 1,
                                color: const Color(0xFFE8DCD9),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                guidance.whyThisMatters?.text ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF4A4A4A),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // How to achieve it header
            if (guidance.howToAchieve != null && guidance.howToAchieve!.isNotEmpty) ...[
              const Text(
                'How to achieve it',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B1B18),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),

              // Step Cards
              ...guidance.howToAchieve!.asMap().entries.map((entry) {
                int idx = entry.key;
                var item = entry.value;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EAE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Number Circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8DCD9), // Darker pink circle
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA05E44), // Rust number color
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Text Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF2B1B18),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.text ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8C7970),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ]
          ],
        ),
      ),
    );
  }
}
