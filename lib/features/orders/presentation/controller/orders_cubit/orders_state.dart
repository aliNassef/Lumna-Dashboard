import 'package:equatable/equatable.dart';
import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/extensions/order_status.dart';
import '../../../data/models/order_details_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/recent_order_model.dart';

enum OrderStates {
  initial,
  loadingOrders,
  successGetOrders,
  failureGetOrders,

  loadingRecentOrders,
  successRecentOrders,
  failureRecentOrders,

  loadingGetOrderDetails,
  successGetOrderDetails,
  failureGetOrderDetails,

  updatedOrderStatusLoading,
  updatedOrderStatusSuccess,
  updatedOrderStatusFailure,
}

extension OrderStatesX on OrderStates {
  bool get isInitial => this == OrderStates.initial;
  bool get isLoadingOrders => this == OrderStates.loadingOrders;
  bool get isSuccessOrders => this == OrderStates.successGetOrders;
  bool get isFailureOrders => this == OrderStates.failureGetOrders;
  bool get isLoadingRecentOrders => this == OrderStates.loadingRecentOrders;
  bool get isSuccessRecentOrders => this == OrderStates.successRecentOrders;
  bool get isFailureRecentOrders => this == OrderStates.failureRecentOrders;
  bool get isLoadingOrderDetails => this == OrderStates.loadingGetOrderDetails;
  bool get isSuccessOrderDetails => this == OrderStates.successGetOrderDetails;
  bool get isFailureOrderDetails => this == OrderStates.failureGetOrderDetails;
  bool get isUpdatedOrderStatusLoading =>
      this == OrderStates.updatedOrderStatusLoading;
  bool get isUpdatedOrderStatusSuccess =>
      this == OrderStates.updatedOrderStatusSuccess;
  bool get isUpdatedOrderStatusFailure =>
      this == OrderStates.updatedOrderStatusFailure;
}

class OrderState extends Equatable {
  final OrderStates status;
  final Failure? failure;
  final List<OrderModel> orders;
  final List<OrderModel> filteredOrders;
  final List<RecentOrderModel>? recentOrders;
  final OrderDetailsModel? orderDetails;
  final Set<String> updatingOrderIds;
  final OrderStatus selectedStatus;
  final OrderStatus? updateOrderStatus;

  const OrderState({
    this.status = OrderStates.initial,
    this.failure,
    this.orders = const [],
    this.filteredOrders = const [],
    this.orderDetails,
    this.recentOrders = const [],
    this.updatingOrderIds = const <String>{},
    this.selectedStatus = OrderStatus.all,
    this.updateOrderStatus = OrderStatus.all,
  });

  OrderState copyWith({
    final OrderStates? status,
    final Failure? failure,
    final List<OrderModel>? orders,
    final List<OrderModel>? filteredOrders,
    final OrderDetailsModel? orderDetails,
    final List<RecentOrderModel>? recentOrders,
    final Set<String>? updatingOrderIds,
    final OrderStatus? selectedStatus,
    final OrderStatus? updateOrderStatus,
  }) {
    return OrderState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      orderDetails: orderDetails ?? this.orderDetails,
      recentOrders: recentOrders ?? this.recentOrders,
      updatingOrderIds: updatingOrderIds ?? this.updatingOrderIds,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      updateOrderStatus: updateOrderStatus ?? this.updateOrderStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    failure,
    orders,
    filteredOrders,
    recentOrders,
    updatingOrderIds,
    selectedStatus,
    updateOrderStatus,
    orderDetails,
  ];
}
