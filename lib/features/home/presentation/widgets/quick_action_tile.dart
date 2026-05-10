import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';

class QuickActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Shape.large),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.onPrimary,
          borderRadius: BorderRadius.circular(Shape.large),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.colors.primary,
            ),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: context.typography.medium16.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: context.colors.primaryContainer,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
