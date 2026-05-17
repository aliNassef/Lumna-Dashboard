import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/features/orders/presentation/controller/orders_cubit/orders_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../../home/presentation/widgets/empty_orders.dart';
import '../../data/models/order_model.dart';
import '../controller/orders_cubit/orders_cubit.dart';
import 'order_card_item.dart';
import 'order_list_item.dart';

class OrdersBuilder extends StatelessWidget {
  const OrdersBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrderState>(
      buildWhen: (previous, current) =>
          current.status.isSuccessOrders ||
          current.status.isFailureOrders ||
          current.status.isLoadingOrders ||
          current.status.isUpdatedOrderStatusSuccess ||
          current.status.isUpdatedOrderStatusFailure ||
          current.status.isLoadingOrderDetails ||
          current.status.isSuccessOrderDetails ||
          current.status.isFailureOrderDetails,
      builder: (context, state) {
        Logger.info(state.toString());
        return switch (state.status) {
          OrderStates.loadingOrders => SliverList.separated(
            itemBuilder: (_, index) => Skeletonizer(
              enabled: true,
              child: OrderCardItem(
                order: dummyOrders[index],
              ),
            ),
            separatorBuilder: (context, index) => const Gap(Spacing.extraLarge),
            itemCount: dummyOrders.length,
          ),
          OrderStates.successGetOrders ||
          OrderStates.updatedOrderStatusSuccess =>
            state.filteredOrders.isEmpty
                ? const SliverToBoxAdapter(
                    child: EmptyOrders(),
                  )
                : SliverList.separated(
                    itemBuilder: (_, index) => OrderListItem(
                      orderId: state.filteredOrders[index].id,
                    ),
                    separatorBuilder: (context, index) =>
                        const Gap(Spacing.extraLarge),
                    itemCount: state.filteredOrders.length,
                  ),

          OrderStates.failureGetOrders => SliverToBoxAdapter(
            child: CustomFailureWidget(failure: state.failure!),
          ),
          _ =>
            state.filteredOrders.isEmpty
                ? const SliverToBoxAdapter(
                    child: EmptyOrders(),
                  )
                : SliverList.separated(
                    itemBuilder: (_, index) => OrderListItem(
                      orderId: state.filteredOrders[index].id,
                    ),
                    separatorBuilder: (context, index) =>
                        const Gap(Spacing.extraLarge),
                    itemCount: state.filteredOrders.length,
                  ),
        };
      },
    );
  }
}
