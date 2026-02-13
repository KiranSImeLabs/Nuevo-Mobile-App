import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import 'quick_access_card.dart'; // Import the new separate file

/// Quick access grid widget with adaptive column count
class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem> items;

  const QuickAccessGrid({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getGridColumns(context);
    final spacing = ResponsiveUtils.spacing(context, base: 12);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            // Calculate card width based on number of columns
            final cardWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;
            
            return SizedBox(
              width: cardWidth,
              child: QuickAccessCard(item: item),
            );
          }).toList(),
        );
      },
    );
  }
}
