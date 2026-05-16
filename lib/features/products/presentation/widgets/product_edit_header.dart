import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
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
              LocaleKeys.products_breadcrumb.tr(),
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
              LocaleKeys.edit_product_breadcrumb.tr(),
              style: context.typography.bold14.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ),
        const Gap(Spacing.medium),

        // 2. Main Title
        Text(
          LocaleKeys.product_demo_name.tr(),
          style: context.typography.bold32.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        const Gap(Spacing.small),

        // 3. Product ID
        Text(
          LocaleKeys.product_id_format.tr(),
          style: context.typography.regular16.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
