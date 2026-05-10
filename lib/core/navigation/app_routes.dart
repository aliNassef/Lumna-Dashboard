import 'package:flutter/material.dart';
import '../../features/account/presentation/views/map_location_view.dart';
import '../../features/notification/presentation/view/send_notification_view.dart';
import '../../features/orders/presentation/views/order_details_view.dart';
import '../../features/products/data/models/product_args.dart';
import '../../features/products/presentation/views/edit_product_view.dart';
import '../../features/products/presentation/views/products_view.dart';
import 'navigation.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final navArgs = args is NavArgs ? args : const NavArgs(data: null);

    late final Widget page;
    switch (settings.name) {
      case SignupView.routeName:
        page = const SignupView();
        break;
      case LoginView.routeName:
        page = const LoginView();
        break;
      case LayoutView.routeName:
        page = const LayoutView();
        break;
      case ManageCategoryView.routeName:
        page = const ManageCategoryView();
        break;
      case CreateNewProductView.routeName:
        page = const CreateNewProductView();
        break;
      case ProductsView.routeName:
        page = const ProductsView();
        break;
      case SendNotificationView.routeName:
        page = const SendNotificationView();
        break;
      case MapLocationView.routeName:
        page = const MapLocationView();
        break;
      case OrderDetailsView.routeName:
        final data = navArgs.data as Map;

        page = OrderDetailsView(
          orderId: data['orderId'],
          ordersCubit: data['orderCubit'],
        );
        break;
      case EditProductView.routeName:
        final productArgs = navArgs.data as ProductArgs;
        page = EditProductView(productArgs: productArgs);
        break;
      default:
        page = const Scaffold(body: Center(child: Text('Page not found')));
    }

    return PageRouteBuilder(
      settings: settings,
      transitionDuration: navArgs.animation == NavAnimation.none
          ? Duration.zero
          : navArgs.duration,
      reverseTransitionDuration: navArgs.animation == NavAnimation.none
          ? Duration.zero
          : navArgs.duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (navArgs.animation) {
          case NavAnimation.fade:
            return FadeTransition(opacity: animation, child: child);
          case NavAnimation.translate:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          case NavAnimation.none:
            return child;
        }
      },
    );
  }
}
