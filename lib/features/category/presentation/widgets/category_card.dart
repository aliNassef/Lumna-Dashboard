import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../data/model/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          Spacing.extraLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(Shape.large),
              decoration: BoxDecoration(
                color: context.colors.outline.withValues(
                  alpha: 0.4,
                ),
                shape: BoxShape.circle,
              ),
              child: CustomNetworkImage(
                img: category.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                radius: 20,
              ),
            ),
            const Gap(20),

            // Title
            Text(
              category.name,
              style: context.typography.bold24.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const Gap(Spacing.medium),

            // Description
            Text(
              'Seating, tables, beds, and storage solutions for modern living spaces.',
              style: context.typography.regular14.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const Gap(Spacing.extraLarge),

            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: context.colors.primary,
                ),
                const Gap(Spacing.medium),
                Text(
                  '${category.productCount} Products',
                  style: context.typography.bold14.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
