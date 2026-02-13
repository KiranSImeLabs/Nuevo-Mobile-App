import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import 'quick_access_grid.dart'; // For QuickAccessItem definition? Or move Item to here? 
// Actually QuickAccessItem is in quick_access_grid.dart. 
// Maybe move QuickAccessItem to a separate model file or keep it there?
// Better to keep QuickAccessItem in grid or move to entity?
// For now, let's import it from grid or duplicate/move. 
// Ideally QuickAccessItem should be in a model file.
// Let's check where QuickAccessItem is defined. It's in quick_access_grid.dart.
// I will move QuickAccessItem to this file or a model file?
// Simpler: Move QuickAccessCard to this file, and import QuickAccessItem from grid file? 
// Cyclic dependency if Grid imports Card and Card imports Grid (for Item).
// Solution: Move QuickAccessItem to this file too, or a third file.
// Let's put QuickAccessItem and QuickAccessCard in `quick_access_card.dart`? 
// No, Grid needs Item to pass to Card.
// Let's leave Item in Grid for now (or move to models) and just have Card take title/icon/onTap? 
// Or define QuickAccessItem in `quick_access_card.dart` and have Grid import it. This seems cleaner.

// Redefining Content:

import 'package:flutter/material.dart';

/// Quick access grid item model
class QuickAccessItem {
  final String title;
  final IconData? icon; // Make nullable
  final String? imagePath; // Add image path
  final VoidCallback? onTap;

  const QuickAccessItem({
    required this.title,
    this.icon,
    this.imagePath,
    this.onTap,
  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');
}

/// Individual quick access card
class QuickAccessCard extends StatelessWidget {
  final QuickAccessItem item;

  const QuickAccessCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        height: ResponsiveUtils.spacing(context, base: 66),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EAE8), // Background per spec
          borderRadius: BorderRadius.circular(8), // Radius 8 per spec
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: IconBox + Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon Box
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: item.imagePath != null
                      ? Padding(
                          padding: const EdgeInsets.all(6.0), // Padding for image
                          child: Image.asset(
                            item.imagePath!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Icon(
                          item.icon!,
                          size: 18,
                          color: const Color(0xFF964A38), // Brown
                        ),
                ),
                // Arrow
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Color(0xFF964A38),
                ),
              ],
            ),
            
            // Bottom: Title
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E1E1E),
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
