import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/add_card_bottom_sheet.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.paymentsAndBilling,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanCard(context),
              const SizedBox(height: 32),
              _buildSectionHeader(
                title: AppStrings.paymentMethods,
                actionLabel: AppStrings.addNew,
                onAction: () {
                   showModalBottomSheet( // Correct showModalBottomSheet usage
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddCardBottomSheet(),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildPaymentMethodTile(),
              const SizedBox(height: 32),
              _buildSectionHeader(title: AppStrings.billingHistory),
              const SizedBox(height: 16),
              _buildBillingHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF5D2E24), // Deep brown/maroon
        borderRadius: BorderRadius.circular(15), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white, // White background for the icon container
                  shape: BoxShape.rectangle,
                   borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Icon(
                  Icons.cached, // Using a similar refresh/cycle icon
                  color: const Color(0xFFA0503D), // Icon color
                  size: 28,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Transparent white
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppStrings.active,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.insightProgram,
            style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Text(
            '\$99.00 / ${AppStrings.month}',
             style: AppTextStyles.h3.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${AppStrings.nextRenewal}: Oct 24, 2023', // Hardcoded date for now as per design
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionLabel != null && onAction != null)
          InkWell(
            onTap: onAction,
            child: Row(
              children: [
                const Icon(Icons.add_circle_outline,
                    size: 18, color: Color(0xFFA0503D)),
                const SizedBox(width: 4),
                Text(
                  actionLabel,
                   style: AppTextStyles.button.copyWith(
                    color: const Color(0xFFA0503D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethodTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1F0), // Very light pinkish-bg
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.credit_card, size: 24, color: AppColors.textPrimary), // Credit card icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                   children: [
                      Text(
                         AppStrings.visa,
                         style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                         ),
                      ),
                       const SizedBox(width: 8), // Spacing
                       // Dots for masked number
                       const Text('••••', style: TextStyle(fontSize: 10, letterSpacing: 2)),
                        const SizedBox(width: 8), // Spacing
                       Text(
                         '1234',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                         ),
                       ),
                   ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires 12/25',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE0C4BE), // Light badge color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                AppStrings.primary,
                 style: AppTextStyles.caption.copyWith(
                   color: const Color(0xFF5D2E24),
                   fontWeight: FontWeight.w600,
                 ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistoryList() {
    // Determine how many items to show based on design (e.g. 3 items)
    return Column(
      children: List.generate(3, (index) => _buildBillingHistoryItem()),
    );
  }

  Widget _buildBillingHistoryItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F1F0), // Logic to match "bg-light" from design
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long, size: 24, color: Color(0xFFA0503D)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.monthlySubscription,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w400, // Regular weight as per list item
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Oct 01, 2023',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$99.00',
                   style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                   ),
                ),
                 const SizedBox(height: 4),
                 Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0C4BE), // "Paid" badge color
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      AppStrings.paid,
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF5D2E24),
                         fontWeight: FontWeight.w600,
                      ),
                    ),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
