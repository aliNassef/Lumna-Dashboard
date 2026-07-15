import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widgets/custom_failure_widget.dart';
import '../../data/models/order_details_model.dart';
import '../controller/orders_cubit/orders_cubit.dart';
import '../controller/orders_cubit/orders_state.dart';
import '../widgets/order_details_view_body.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    super.key,
    required this.orderId,
    required this.ordersCubit,
  });
  static const routeName = 'order-details';
  final String orderId;
  final OrdersCubit ordersCubit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ordersCubit..getOrderDetails(orderId),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<OrdersCubit, OrderState>(
            buildWhen: (previous, current) =>
                current.status.isSuccessOrderDetails ||
                current.status.isFailureOrderDetails ||
                current.status.isLoadingOrderDetails,
            builder: (context, state) {
              return switch (state.status) {
                OrderStates.loadingGetOrderDetails => Skeletonizer(
                  enabled: true,
                  child: OrderDetailsViewBody(
                    orderDetailsModel: dummyOrderDetails,
                  ),
                ),

                OrderStates.successGetOrderDetails => OrderDetailsViewBody(
                  orderDetailsModel: state.orderDetails!,
                ),

                OrderStates.failureGetOrderDetails => CustomFailureWidget(
                  failure: state.failure!,
                ),
                _ => const SizedBox.shrink(),
              };
            },
          ),
        ),
      ),
    );
  }
}
