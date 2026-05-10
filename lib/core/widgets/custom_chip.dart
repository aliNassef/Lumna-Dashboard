import '../extensions/order_status.dart';
import 'package:flutter/material.dart';

import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';
import '../utils/shape.dart';
import '../utils/spacer.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.orderStatus,
    required this.isActive,
  });
  final OrderStatus orderStatus;

  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.extraLarge,
      ),
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive
            ? context.colors.primary
            : context.colors.outline.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Text(
        orderStatus.value,
        style: context.typography.medium14.copyWith(
          color: isActive
              ? context.colors.onPrimary
              : context.colors.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
