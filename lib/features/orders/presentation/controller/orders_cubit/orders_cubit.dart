import 'package:bloc/bloc.dart';
import 'package:lumna_admin/core/extensions/order_status.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repo/orders_repo.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrderState> {
  OrdersCubit({required this.ordersRepo}) : super(const OrderState());
  final OrdersRepo ordersRepo;

  void getRecentOrders() async {
    emit(
      state.copyWith(
        status: OrderStates.loadingRecentOrders,
      ),
    );
    final recentOrdersOrFailure = await ordersRepo.getRecentOrders();
    recentOrdersOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderStates.failureRecentOrders,
          failure: failure,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          status: OrderStates.successRecentOrders,
          recentOrders: orders,
        ),
      ),
    );
  }

  void getOrders() async {
    emit(
      state.copyWith(
        status: OrderStates.loadingOrders,
      ),
    );
    final ordersOrFailure = await ordersRepo.getOrders();
    ordersOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderStates.failureGetOrders,
          failure: failure,
        ),
      ),
      (orders) => emit(
        state.copyWith(
          status: OrderStates.successGetOrders,
          orders: orders,
          filteredOrders: orders,
        ),
      ),
    );
  }

  void filterOrders(OrderStatus status) async {
    emit(
      state.copyWith(
        selectedStatus: status,
        filteredOrders: _getFilteredOrders(state.orders, status),
      ),
    );
  }

  List<OrderModel> _getFilteredOrders(
    List<OrderModel> orders,
    OrderStatus status,
  ) {
    if (status == OrderStatus.all) return orders;
    return orders.where((order) => order.status == status).toList();
  }

  void updateOrderStatus(String id, OrderStatus status) async {
    emit(
      state.copyWith(
        updatingOrderIds: {...state.updatingOrderIds, id},
        status: OrderStates.updatedOrderStatusLoading,
      ),
    );

    final updateOrfailure = await ordersRepo.updateOrderStatus(id, status);

    updateOrfailure.fold(
      (failure) => emit(
        state.copyWith(
          updatingOrderIds: {...state.updatingOrderIds}..remove(id),
          failure: failure,
          status: OrderStates.updatedOrderStatusFailure,
        ),
      ),
      (_) {
        final updatedOrders = state.orders
            .map(
              (order) =>
                  order.id == id ? order.copyWith(status: status) : order,
            )
            .toList();

        emit(
          state.copyWith(
            orders: updatedOrders,
            filteredOrders: _getFilteredOrders(
              updatedOrders,
              state.selectedStatus,
            ),
            updatingOrderIds: {...state.updatingOrderIds}..remove(id),
            status: OrderStates.updatedOrderStatusSuccess,
            updateOrderStatus: status,
          ),
        );
      },
    );
  }

  void getOrderDetails(String orderId) async {
    emit(
      state.copyWith(
        status: OrderStates.loadingGetOrderDetails,
        updateOrderStatus: null,
        orders: state.orders,
        filteredOrders: state.filteredOrders,
      ),
    );
    final orderDetailsOrFailure = await ordersRepo.getOrderDetails(orderId);
    orderDetailsOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderStates.failureGetOrderDetails,

          failure: failure,
        ),
      ),
      (orderDetails) => emit(
        state.copyWith(
          status: OrderStates.successGetOrderDetails,
          orderDetails: orderDetails,
          orders: state.orders,
          filteredOrders: state.filteredOrders,
        ),
      ),
    );
  }
}
