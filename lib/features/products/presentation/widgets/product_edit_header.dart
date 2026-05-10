import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';

class ProductEditHeader extends StatelessWidget {
  const ProductEditHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Breadcrumbs
        Row(
          children: [
            Text(
              'Products',
              style: context.typography.regular14.copyWith(
                color: Colors.blueGrey[300],
              ),
            ),
            const Gap(Spacing.small),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: Colors.blueGrey[200],
            ),
            const Gap(Spacing.small),
            Text(
              'Edit Product',
              style: context.typography.bold14.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ),
        const Gap(Spacing.medium),

        // 2. Main Title
        Text(
          'Ethereal Fern Vessel',
          style: context.typography.bold32.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        const Gap(Spacing.small),

        // 3. Product ID
        Text(
          'Product ID: #LUM-88291',
          style: context.typography.regular16.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
