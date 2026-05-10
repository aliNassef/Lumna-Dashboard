import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/extensions/order_status.dart';
import 'package:lumna_admin/core/extensions/date_time_extension.dart';
import 'package:lumna_admin/core/navigation/navigation.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import '../../../../core/extensions/color_extensions.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../data/models/order_model.dart';
import '../controller/orders_cubit/orders_cubit.dart';
import '../views/order_details_view.dart';

class OrderCardItem extends StatelessWidget {
  const OrderCardItem({super.key, required this.order});
  final OrderModel order;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pending Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.chipBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: context.colors.onError,
                        ),
                        const Gap(6),
                        Text(
                          order.status.value,
                          style: context.typography.bold10.copyWith(
                            color: order.status.chipTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Text(
                    '#${order.id.substring(0, 6)}',
                    style: context.typography.bold24,
                  ),
                  Text(
                    order.createdAt.orderDisplayText,
                    style: context.typography.regular14.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${order.totalAmount}',
                    style: context.typography.bold24.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  Text(
                    '${order.itemsCount} ${LocaleKeys.items_label.tr()}',
                    style: context.typography.regular14,
                  ),
                ],
              ),
            ],
          ),

          const Gap(20),

          // Profile Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: order.customerImage == null
                      ? null
                      : NetworkImage(
                          order.customerImage!,
                        ),
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: context.typography.semiBold16,
                    ),
                    Text(
                      order.customerEmail!,
                      style: context.typography.regular12.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Gap(24),

          // Action Buttons
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _goToOrderDetails(context);
                  },
                  child: Text(
                    LocaleKeys.view_order.tr(),
                    style: context.typography.semiBold16.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToOrderDetails(BuildContext context) {
    context.pushNamed(
      OrderDetailsView.routeName,
      arguments: NavArgs(
        animation: NavAnimation.fade,
        data: {
          'orderId': order.id,
          'orderCubit': context.read<OrdersCubit>(),
        },
      ),
    );
  }
}
