import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/product_model.dart';

class TotalSalesAndAvgRating extends StatelessWidget {
  const TotalSalesAndAvgRating({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final totalSales = product.reviewCount?.toInt() ?? 0;
    final averageRating = product.avgRating?.toString() ?? '0';

    return Card(
      color: context.colors.onPrimary,
      elevation: 0,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const Gap(Spacing.extraLarge),
          _buildLabel(context, LocaleKeys.label_rating_upper.tr()),
          ListTile(
            title: Text(
              LocaleKeys.total_units_sold.tr(),
              style: context.typography.bold18.copyWith(
                color: const Color(0xFFB0C1D9),
              ),
            ),
            trailing: Text(
              totalSales.toString(),
              style: context.typography.bold18.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              LocaleKeys.customer_rating.tr(),
              style: context.typography.bold18.copyWith(
                color: const Color(0xFFB0C1D9),
              ),
            ),
            trailing: Text(
              averageRating,
              style: context.typography.bold18.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.extraLarge,
        bottom: Spacing.small,
      ),
      child: Text(
        label,
        style: context.typography.bold12.copyWith(
          color: const Color(0xFFB0C1D9), // Light blue-grey label color
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
