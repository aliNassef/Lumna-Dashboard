import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/order_status.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_chip.dart';
import '../controller/orders_cubit/orders_cubit.dart';
import '../controller/orders_cubit/orders_state.dart';

class OrderFilters extends StatelessWidget {
  const OrderFilters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrderState>(
      buildWhen: (previous, current) =>
          current.status.isSuccessOrders ||
          current.status.isUpdatedOrderStatusSuccess,
      builder: (context, state) {
        final selectedStatus =
            state.status.isSuccessOrders ||
                state.status.isUpdatedOrderStatusSuccess
            ? state.selectedStatus
            : OrderStatus.all;
        Logger.info(selectedStatus.toString());
        return SizedBox(
          height: 30.h,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.extraLarge,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => GestureDetector(
              onTap: () {
                context.read<OrdersCubit>().filterOrders(
                  OrderStatus.values[index],
                );
              },
              child: CustomChip(
                orderStatus: OrderStatus.values[index],
                isActive: OrderStatus.values[index] == selectedStatus,
              ),
            ),
            separatorBuilder: (_, _) => const Gap(Spacing.small),
            itemCount: OrderStatus.values.length,
          ),
        );
      },
    );
  }
}
