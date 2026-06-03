import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../translation/locale_keys.g.dart';

enum OrderStatus {
  all,
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
  ;

  static OrderStatus fromValue(String s) {
    switch (s) {
      case 'Pending':
        return OrderStatus.pending;
      case 'Processing':
        return OrderStatus.processing;
      case 'Shipped':
        return OrderStatus.shipped;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Cancelled':
        return OrderStatus.cancelled;
      case 'Refunded':
        return OrderStatus.refunded;
      default:
        return OrderStatus.all;
    }
  }
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return LocaleKeys.pending.tr();
      case OrderStatus.processing:
        return LocaleKeys.processing.tr();
      case OrderStatus.shipped:
        return LocaleKeys.shipped.tr();
      case OrderStatus.delivered:
        return LocaleKeys.delivered.tr();
      case OrderStatus.cancelled:
        return LocaleKeys.status_cancelled.tr();
      case OrderStatus.refunded:
        return LocaleKeys.status_refunded.tr();
      case OrderStatus.all:
        return LocaleKeys.all_orders.tr();
    }
  }

  Color get chipBackgroundColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFFF3E0);
      case OrderStatus.processing:
        return const Color(0xFFEDE7F6);
      case OrderStatus.shipped:
        return const Color(0xFFE1F5FE);
      case OrderStatus.delivered:
        return const Color(0xFFE0F2F1);
      case OrderStatus.cancelled:
        return const Color(0xFFFFEBEE);
      case OrderStatus.refunded:
        return const Color(0xFFF3E5F5);
      case OrderStatus.all:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get chipTextColor {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFEF6C00);
      case OrderStatus.processing:
        return const Color(0xFF5E35B1);
      case OrderStatus.shipped:
        return const Color(0xFF0277BD);
      case OrderStatus.delivered:
        return const Color(0xFF00796B);
      case OrderStatus.cancelled:
        return const Color(0xFFC62828);
      case OrderStatus.refunded:
        return const Color(0xFF6A1B9A);
      case OrderStatus.all:
        return const Color(0xFF616161);
    }
  }
}
