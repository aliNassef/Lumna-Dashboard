import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/order_status.dart';
import '../../data/models/order_model.dart';
import '../controller/orders_cubit/orders_cubit.dart';
import '../controller/orders_cubit/orders_state.dart';
import 'order_card_item.dart';
import 'pendng_order_card_item.dart';

class OrderListItem extends StatelessWidget {
  const OrderListItem({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrdersCubit, OrderState, _OrderListItemViewModel?>(
      selector: (state) {
        final order = state.filteredOrders
            .where((order) => order.id == orderId)
            .firstOrNull;

        if (order == null) return null;

        return _OrderListItemViewModel(
          order: order,
          isUpdating: state.updatingOrderIds.contains(orderId),
        );
      },
      builder: (context, state) {
        if (state == null) {
          return const SizedBox.shrink();
        }

        return state.order.status == OrderStatus.processing
            ? PendingOrderCardItem(
                order: state.order,
                isUpdating: state.isUpdating,
              )
            : OrderCardItem(order: state.order);
      },
    );
  }
}

class _OrderListItemViewModel {
  const _OrderListItemViewModel({
    required this.order,
    required this.isUpdating,
  });

  final OrderModel order;
  final bool isUpdating;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _OrderListItemViewModel &&
        other.order == order &&
        other.isUpdating == isUpdating;
  }

  @override
  int get hashCode => Object.hash(order, isUpdating);
}
