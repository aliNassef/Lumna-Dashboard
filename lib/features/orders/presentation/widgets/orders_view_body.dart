import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import 'order_filters.dart';
import 'orders_builder.dart';

class OrdersViewBody extends StatelessWidget {
  const OrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                LocaleKeys.orders_management.tr(),
                style: context.typography.bold24.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const Gap(Spacing.small),
              Text(
                LocaleKeys.orders_description.tr(),
                style: context.typography.regular16.copyWith(
                  color: context.colors.onTertiary,
                ),
              ),
            ],
          ).withHorizontalPadding(Spacing.extraLarge),
        ),
        const SliverGap(Spacing.extraLarge),
        const SliverToBoxAdapter(
          child: OrderFilters(),
        ),
        const SliverGap(Spacing.extraLarge),
        const OrdersBuilder(),
        const SliverGap(Spacing.extraExtraLarge),
      ],
    );
  }
}
