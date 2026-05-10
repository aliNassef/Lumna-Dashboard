import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../nav_bar_item_data.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({super.key, required this.isActive, required this.data});
  final bool isActive;
  final NavBarItemData data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.medium),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xffF0FDFA).withValues(alpha: 0.9)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Column(
        children: [
          Icon(
            data.icon,
            color: isActive ? context.colors.primary : const Color(0xffA8A29E),
          ),
          Text(
            data.label,
            style: context.typography.semiBold10.copyWith(
              color: isActive
                  ? context.colors.primary
                  : const Color(0xffA8A29E),
            ),
          ),
        ],
      ),
    );
  }
}
