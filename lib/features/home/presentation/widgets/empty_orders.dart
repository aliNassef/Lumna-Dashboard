import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';

class EmptyOrders extends StatelessWidget {
  const EmptyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: context.colors.primaryContainer,
          ),
          const SizedBox(height: 12),
          Text(
            'Empty Orders',
            style: context.typography.bold14,
          ),
          const SizedBox(height: 6),
          Text(
            'No recent orders to display.',
            style: context.typography.medium12.copyWith(
              color: context.colors.primaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
