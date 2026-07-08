import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/di/di.dart';
import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/mediaquery_size.dart';
import '../../../../core/extensions/order_status.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../data/models/order_details_model.dart';
import '../controller/orders_cubit/orders_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/utils/spacer.dart';
import 'change_order_status_menu.dart';
import 'items_summary_section.dart';

class OrderDetailHeader extends StatelessWidget {
  const OrderDetailHeader({
    super.key,
    required this.orderDetailsModel,
  });
  final OrderDetailsModel orderDetailsModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button Link
        InkWell(
          onTap: () {
            context.pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 18, color: context.colors.primary),
              const Gap(Spacing.large),
              Text(
                LocaleKeys.back_to_orders.tr(),
                style: context.typography.semiBold16.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),

        const Gap(Spacing.extraLarge),

        // Order ID and Status Chip
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Order #${orderDetailsModel.orderNo}',
                style: context.typography.bold32.copyWith(height: 1.1),
              ),
            ),
            BlocConsumer<OrdersCubit, OrderState>(
              listener: (context, state) {
                if (state.status.isUpdatedOrderStatusFailure) {
                  context.showToast(
                    text:
                        state.failure?.errMessage ??
                        LocaleKeys.something_went_wrong.tr(),
                    backgroundColor: context.colors.error,
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current.status.isSuccessOrderDetails ||
                  current.status.isUpdatedOrderStatusSuccess ||
                  current.status.isUpdatedOrderStatusFailure ||
                  current.status.isUpdatedOrderStatusLoading,
              builder: (context, state) {
                return switch (state.status) {
                  OrderStates.successGetOrderDetails => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: orderDetailsModel.status.chipBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      orderDetailsModel.status.value,
                      style: context.typography.medium14.copyWith(
                        color: orderDetailsModel.status.chipTextColor,
                      ),
                    ),
                  ),
                  OrderStates.updatedOrderStatusLoading => Skeletonizer(
                    enabled: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: orderDetailsModel.status.chipBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        orderDetailsModel.status.value,
                        style: context.typography.medium14.copyWith(
                          color: orderDetailsModel.status.chipTextColor,
                        ),
                      ),
                    ),
                  ),

                  OrderStates.updatedOrderStatusSuccess => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: state.updateOrderStatus!.chipBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      state.updateOrderStatus!.value,
                      style: context.typography.medium14.copyWith(
                        color: orderDetailsModel.status.chipTextColor,
                      ),
                    ),
                  ),
                  _ => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: orderDetailsModel.status.chipBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      orderDetailsModel.status.value,
                      style: context.typography.medium14.copyWith(
                        color: orderDetailsModel.status.chipTextColor,
                      ),
                    ),
                  ),
                };
              },
            ),
          ],
        ),

        const Gap(12),

        // Date Subtitle
        Text(
          '${LocaleKeys.placed_on_prefix.tr()}${orderDetailsModel.createdAt.orderDetailsDisplayText}',
          style: context.typography.regular16.copyWith(color: Colors.grey[600]),
        ),

        const Gap(24),

        // Action Buttons
        SizedBox(
          width: context.width * .5,
          child: ChangeOrderStatusMenu(
            orderId: orderDetailsModel.id,
            initialStatus: orderDetailsModel.status,
          ),
        ),
        const Gap(24),
        ItemsSummarySection(
          items: orderDetailsModel.items,
        ),
      ],
    );
  }
}
