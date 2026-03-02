import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';

class YourProgramScreen extends StatelessWidget {
  const YourProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Your Program',
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, base: 16),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF17110D),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getHorizontalPadding(context),
          vertical: ResponsiveUtils.spacing(context, base: 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainProgramCard(context),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
            Text(
              'Program Phases',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, base: 16),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF17110D),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
            _buildPhaseCard(
              context,
              phase: 'Phase 1',
              title: 'Assess',
              iconData: Icons.assignment_outlined,
              isActive: false,
              isLocked: false,
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            _buildPhaseCard(
              context,
              phase: 'Reset',
              title: 'Focus: Metabolic flexibility',
              iconData: Icons.autorenew,
              isActive: true,
              isLocked: false,
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            _buildPhaseCard(
              context,
              phase: 'Phase 3',
              title: 'Elevate',
              iconData: Icons.lock_outline,
              isActive: false,
              isLocked: true,
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            _buildPhaseCard(
              context,
              phase: 'Phase 4',
              title: 'Sustain',
              iconData: Icons.lock_outline,
              isActive: false,
              isLocked: true,
            ),
            
            SizedBox(height: ResponsiveUtils.spacing(context, base: 32)),
            Text(
              'Your Care Team',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, base: 16),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF17110D),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
            _buildCareTeamCard(
              context,
              name: 'DR. Mike',
              role: 'Dietitian',
              imageUrl: 'https://i.pravatar.cc/150?u=mike',
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            _buildCareTeamCard(
              context,
              name: 'Dr. A. Smith',
              role: 'General Practitioner',
              imageUrl: 'https://i.pravatar.cc/150?u=smith',
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainProgramCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 20)),
      decoration: BoxDecoration(
        color: const Color(0xFF6B3528),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.change_circle_outlined,
              color: const Color(0xFF6B3528),
              size: ResponsiveUtils.iconSize(context, base: 28),
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
          Text(
            'Insight Program',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 18),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, base: 4)),
          Text(
            'Personalised, clinician-guided care',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 14),
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context, {
    required String phase,
    required String title,
    required IconData iconData,
    required bool isActive,
    required bool isLocked,
  }) {
    final bgColor = isActive ? const Color(0xFF964A38) : const Color(0xFFF6ECE9);
    final textColor = isActive ? Colors.white : const Color(0xFF17110D);
    final subtitleColor = isActive ? Colors.white.withOpacity(0.9) : const Color(0xFF735B4D);

    Widget iconWidget;
    if (isLocked) {
      iconWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDFDFDF), width: 1.5),
        ),
        child: Icon(iconData, color: const Color(0xFFBDBDBD), size: ResponsiveUtils.iconSize(context, base: 20)),
      );
    } else {
      iconWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : const Color(0xFF964A38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          iconData,
          color: isActive ? const Color(0xFF964A38) : Colors.white,
          size: ResponsiveUtils.iconSize(context, base: 20),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          iconWidget,
          SizedBox(width: ResponsiveUtils.spacing(context, base: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 14),
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 2)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 16),
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Active',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 12),
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCareTeamCard(
    BuildContext context, {
    required String name,
    required String role,
    required String imageUrl,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECE9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, base: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 16),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF17110D),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 2)),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 14),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF735B4D),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward,
            size: ResponsiveUtils.iconSize(context, base: 18),
            color: const Color(0xFF964A38),
          ),
        ],
      ),
    );
  }
}
