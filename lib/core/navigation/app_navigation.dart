import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  /// Push a named route using [Navigator.pushNamed]
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool useAppRoute = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: useAppRoute,
    ).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push and replace a named route using [Navigator.pushNamed]
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments, result: result);
  }

  /// Push and remove until a named route using [Navigator.pushNamedAndRemoveUntil]
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
    bool useAppRoute = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: useAppRoute,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  /// Pop the current route using [Navigator.pop]
  void pop<T extends Object?>({bool? useAppRoute, T? result}) {
    Navigator.of(this, rootNavigator: useAppRoute ?? false).pop(result);
  }


  void popUntil(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }
}
