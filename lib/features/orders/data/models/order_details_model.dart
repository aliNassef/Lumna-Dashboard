import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import 'package:lumna_admin/core/utils/app_assets.dart';

import '../../../../core/extensions/order_status.dart';
import '../../../../core/extensions/payment_method.dart';
import 'order_item_model.dart';

class OrderDetailsModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final OrderStatus status;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final String customerName;
  final String? customerEmail;
  final String? customerAvatarUrl;
  final String? addressLabel;
  final String? addressStreet;
  final String? addressCity;
  final String? addressState;
  final String? addressZip;
  final String? addressCountry;
  final String? addressPhone;
  final String? shippingAddress;
  final List<OrderItemModel> items;

  const OrderDetailsModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    required this.customerName,
    this.customerEmail,
    this.customerAvatarUrl,
    this.addressLabel,
    this.addressStreet,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.addressCountry,
    this.addressPhone,
    this.shippingAddress,
    required this.items,
  });

  factory OrderDetailsModel.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;
    final address = _resolveAddressMap(map['addresses']);
    final itemsRaw = (map['order_items'] as List?) ?? [];

    return OrderDetailsModel(
      id: map['id']?.toString() ?? '',
      createdAt: _parseDate(map['created_at']),
      status: _parseStatus(map['status']),
      totalAmount: _parseDouble(map['total_amount']),
      paymentMethod: _parsePaymentMethod(map['payment_method']),
      customerName: _resolveCustomerName(profile),
      customerEmail: _clean(profile?['email']),
      customerAvatarUrl: _clean(profile?['avatar_url']),
      addressLabel: _clean(address?['label']),
      addressStreet: _clean(address?['street']),
      addressCity: _clean(address?['city']),
      addressState: _clean(address?['state']),
      addressZip: _clean(address?['zip']),
      addressCountry: _clean(address?['country']),
      addressPhone: _clean(address?['phone']),
      shippingAddress: _resolveShippingAddress(address),
      items: itemsRaw
          .whereType<Map<String, dynamic>>()
          .map(OrderItemModel.fromMap)
          .toList(),
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.tryParse(value.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static OrderStatus _parseStatus(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return OrderStatus.pending;
    }

    return OrderStatus.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => OrderStatus.pending,
    );
  }

  static PaymentMethod _parsePaymentMethod(dynamic value) {
    if (value is Map<String, dynamic>) {
      return PaymentMethod.fromMap(value);
    }

    final normalized = value?.toString().trim().toLowerCase();
    return switch (normalized) {
      'credit' => PaymentMethod.credit,
      'card' => PaymentMethod.credit,
      _ => PaymentMethod.cash,
    };
  }

  static String _resolveCustomerName(Map<String, dynamic>? profile) {
    return _clean(profile?['full_name']) ?? LocaleKeys.unknown_customer.tr();
  }

  static Map<String, dynamic>? _resolveAddressMap(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return _resolveAddressMap(value.first);
    }

    if (value is Map<String, dynamic>) {
      return value;
    }

    return null;
  }

  static String? _resolveShippingAddress(dynamic value) {
    final address = _resolveAddressMap(value);
    if (address != null) {
      final parts = [
        _clean(address['street']),
        _clean(address['city']),
        _clean(address['state']),
        _clean(address['zip']),
        _clean(address['country']),
      ].whereType<String>().toList();

      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }

    return _clean(value);
  }

  static String? _clean(dynamic value) {
    final str = value?.toString().trim();
    if (str == null || str.isEmpty) return null;
    return str;
  }

  @override
  List<Object> get props => [
    id,
    createdAt,
    status,
    totalAmount,
    paymentMethod,
    customerName,
    items,
  ];
}

final dummyOrderDetails = OrderDetailsModel(
  createdAt: DateTime.now(),
  customerName: 'Admin',
  id: 'aaaaaaaaaa',
  paymentMethod: PaymentMethod.cash,
  status: OrderStatus.pending,
  totalAmount: 1000,
  customerAvatarUrl: AppNetworkImage.dummy,
  customerEmail: '2K9m7@example.com',
  addressLabel: 'Home',
  addressStreet: '1742 Willow Creek Rd',
  addressCity: 'Austin',
  addressState: 'TX',
  addressZip: '78704',
  addressCountry: 'United States',
  addressPhone: '+1 (555) 019-8273',
  shippingAddress: '1742 Willow Creek Rd, Austin, TX, 78704, United States',
  items: [
    const OrderItemModel(
      id: '666666',
      title: 'title',
      unitPrice: 100,
      totalPrice: 1000,
      quantity: 3,
      imageUrl: AppNetworkImage.dummy,
    ),
  ],
);
