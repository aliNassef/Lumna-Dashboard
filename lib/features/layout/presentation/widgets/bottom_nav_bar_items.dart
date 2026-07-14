import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/mediaquery_size.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../nav_bar_item_data.dart';
import 'bottom_nav_bar_item.dart';

class BottomNavBarItems extends StatelessWidget {
  const BottomNavBarItems({
    super.key,
    required this.currentIndex,
    this.onChanged,
  });
  final int currentIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 85,
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.extraLarge,
        vertical: Spacing.extraLarge,
      ),
      padding: const EdgeInsets.all(Spacing.large),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.outline),
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Row(
        spacing: Spacing.medium,
        children: List.generate(
          4,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(index),
              child: BottomNavItem(
                data: navBarItems[index],
                isActive: index == currentIndex,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
