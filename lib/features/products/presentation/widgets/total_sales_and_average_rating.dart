import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/strings_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/product_model.dart';
import '../controller/product_cubit/product_cubit.dart';

class TotalSalesAndAvgRating extends StatelessWidget {
  const TotalSalesAndAvgRating({
    super.key,
    required this.product,
  });

  /// Light blue-grey label color.
  static const _labelColor = Color(0xFFB0C1D9);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) =>
          current.status.isLoadingTotalSales ||
          current.status.isTotalSalesSuccess ||
          current.status.isTotalSalesFailure,
      builder: (context, state) {
        return Card(
          color: context.colors.onPrimary,
          elevation: 0,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const Gap(Spacing.extraLarge),
              _buildLabel(context, LocaleKeys.label_rating_upper.tr()),
              ListTile(
                title: _buildTitle(context, LocaleKeys.total_units_sold.tr()),
                trailing: switch (state.status) {
                  ProductStatus.totalSalesSuccess => _buildValue(
                    context,
                    (state.totalSales ?? 0).toString().localizeDigits,
                  ),
                  ProductStatus.totalSalesFailure => _buildValue(
                    context,
                    '--',
                    color: context.colors.error,
                  ),
                  // Covers `loadingTotalSales` plus any state emitted before
                  // the request starts, so the tile never shows a stale zero.
                  _ => Skeletonizer(
                    enabled: true,
                    child: _buildValue(context, '000'),
                  ),
                },
              ),
              const Divider(),
              ListTile(
                title: _buildTitle(context, LocaleKeys.customer_rating.tr()),
                trailing: _buildValue(
                  context,
                  (product.avgRating ?? 0).toStringAsFixed(1).localizeDigits,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.typography.bold18.copyWith(color: _labelColor),
    );
  }

  Widget _buildValue(BuildContext context, String value, {Color? color}) {
    return Text(
      value,
      style: context.typography.bold18.copyWith(
        color: color ?? context.colors.primary,
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
          color: _labelColor,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
