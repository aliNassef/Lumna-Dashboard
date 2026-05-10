import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';

class CreateProductHeader extends StatelessWidget {
  const CreateProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Breadcrumbs
        RichText(
          text: TextSpan(
            style: context.typography.regular14.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            children: [
              TextSpan(text: '${LocaleKeys.products.tr()} '),
              TextSpan(
                text: '› ',
                style: TextStyle(
                  color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
              TextSpan(
                text: LocaleKeys.add_product.tr(),
                style: context.typography.bold14.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
        const Gap(Spacing.large),

        // Main Title
        Text(
          LocaleKeys.create_product.tr(),
          style: context.typography.bold24.copyWith(
            color: context.colors.onSurface,
          ),
        ),
        const Gap(Spacing.medium),

        // Subtitle / Description
        Text(
          LocaleKeys.create_product_desc.tr(),
          style: context.typography.regular16.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
