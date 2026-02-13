import 'package:flutter/material.dart';
import '../../../domain/entities/wellness_program.dart';
import '../../utils/responsive_utils.dart';

/// Program card widget displaying wellness program information
class ProgramCard extends StatelessWidget {
  final WellnessProgram program;
  final VoidCallback? onViewPlan;

  const ProgramCard({
    Key? key,
    required this.program,
    this.onViewPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Fixed dimensions per spec: 335x177
        // Use full width if constraints < 335, otherwise 335.
        final width = constraints.maxWidth < 335.0 ? constraints.maxWidth : 335.0;
        
        return Container(
          width: width,
          height: ResponsiveUtils.spacing(context, base: 177),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80'), // Physiotherapy/Fitness placeholder
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black54, // Dark overlay
                BlendMode.darken,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12), // Padding 12px per spec
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // "Insight Program"
              Text(
                'Insight Program', // Manual override for now as per design text, disregarding program.name if needed or assuming program.name IS this
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 22), // Larger title
                  fontWeight: FontWeight.w600, // Medium/SemiBold
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),

              // Description
              Expanded(
                child: Text(
                  'Advanced assessment and specialist-led profiling',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 14),
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // View My Plan Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8), // Button radius
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onViewPlan,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View My Plan',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.fontSize(context, base: 14),
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: ResponsiveUtils.iconSize(context, base: 16),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
