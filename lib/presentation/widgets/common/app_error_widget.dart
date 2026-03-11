import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String title;
  final String retryText;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.title = 'Oops! Something went wrong',
    this.retryText = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 20)),
              decoration: const BoxDecoration(
                color: Color(0xFFFDE8E8), // Light red/pink background
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: ResponsiveUtils.iconSize(context, base: 56),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: ResponsiveUtils.spacing(context, base: 32)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(context, base: 16)),
                  ),
                  child: Text(retryText),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
