import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../../../core/widgets/section_title_and_view_all_button.dart';
import '../../../orders/presentation/controller/orders_cubit/orders_state.dart';
import 'empty_orders.dart';
import 'quick_actions.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../orders/data/models/recent_order_model.dart';
import '../../../orders/presentation/controller/orders_cubit/orders_cubit.dart';
import 'recent_orders_table.dart';
import 'statistics_card_builder.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: context.colors.onPrimary,
          title: CustomAppbar(
            title: LocaleKeys.app_name.tr(),
            showBackButton: false,
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(Spacing.extraLarge),
              Text(
                LocaleKeys.dashboard_overview.tr(),
                style: context.typography.medium14.copyWith(
                  color: context.colors.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const Gap(Spacing.medium),
              Text(
                LocaleKeys.dashboard.tr(),
                style: context.typography.bold24.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const Gap(32),
            ],
          ).withHorizontalPadding(Spacing.extraLarge),
        ),
        const StatisticsCardBuilder(),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child: const QuickActionsSection().withHorizontalPadding(
            Spacing.extraLarge,
          ),
        ),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child: SectionTitleAndViewAllButton(
            sectionTitle: LocaleKeys.dashboard_recent_orders.tr(),
          ).withHorizontalPadding(Spacing.extraLarge),
        ),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child:
              BlocBuilder<OrdersCubit, OrderState>(
                builder: (context, state) {
                  return switch (state.status) {
                    OrderStates.loadingRecentOrders => Skeletonizer(
                      enabled: true,
                      containersColor: context.colors.surface,
                      child: RecentOrdersTable(
                        orders: dummyRecentOrders,
                      ),
                    ),
                    OrderStates.successRecentOrders =>
                      state.recentOrders!.isEmpty
                          ? const EmptyOrders()
                          : RecentOrdersTable(orders: state.recentOrders!),
                    OrderStates.failureRecentOrders => CustomFailureWidget(
                      failure: state.failure!,
                    ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ).withHorizontalPadding(
                Spacing.extraLarge,
              ),
        ),
        const SliverGap(Spacing.extraExtraLarge),
      ],
    );
  }
}
