import '../../../core/di/injection_container.dart';
import '../../../core/navigation/navigation.dart';
import 'controller/orders_cubit/orders_cubit.dart';
import 'views/order_details_view.dart';

/// Handles a tapped `order` notification by opening the matching order details.
///
/// Registered against [RemoteNotificationService] at the composition root so
/// the core notification service stays decoupled from the orders feature.
void handleOrderNotificationTap(Map<String, dynamic> data) {
  final orderId = data['order_id'];
  if (orderId == null) return;

  navigatorKey.currentState?.pushNamed(
    OrderDetailsView.routeName,
    arguments: NavArgs(
      animation: NavAnimation.fade,
      data: {
        'orderId': orderId,
        'orderCubit': injector<OrdersCubit>(),
      },
    ),
  );
}
