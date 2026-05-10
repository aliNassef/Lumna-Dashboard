import 'package:flutter/material.dart';

import 'logger.dart';

class AppNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    Logger.info('Navigated to: ${route.settings.name}', tag: 'Navigation');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    Logger.info(
      'Returned to: ${previousRoute?.settings.name}',
      tag: 'Navigation',
    );
  }
}
