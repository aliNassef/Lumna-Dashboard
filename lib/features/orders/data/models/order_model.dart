import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/order_status.dart';

class OrderModel extends Equatable {
  final String id;
  final DateTime createdAt;
  final OrderStatus status;
  final String customerName;
  final String? customerEmail;
  final String? customerImage;
  final num totalAmount;
  final int itemsCount;
  final int orderNumber;
  final int? rating;

  const OrderModel({
    required this.id,
    required this.createdAt,
    required this.orderNumber,
    required this.status,
    required this.customerName,
    required this.customerEmail,
    required this.customerImage,
    required this.totalAmount,
    required this.itemsCount,
    this.rating,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;
    final orderItems = map['order_items'] as List<dynamic>?;
    final rating = _resolveRating(map['order_reviews']);
    final rawStatus = (map['status'] as String? ?? '').trim().toLowerCase();

    return OrderModel(
      orderNumber: map['order_no'] as int? ?? 0,
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      status: OrderStatus.values.byName(
        rawStatus.isEmpty ? OrderStatus.pending.name : rawStatus,
      ),
      customerName: _resolveCustomerName(profile),
      customerEmail: profile?['email'] as String?,
      customerImage: profile?['avatar_url'] as String?,
      totalAmount: (map['total_amount'] as num?) ?? 0,
      itemsCount: orderItems?.length ?? 0,
      rating: rating,
    );
  }

  /// `order_reviews` embeds as a single object (one-to-one, since `order_id`
  /// is unique) or `null`, but tolerate a list shape too in case the relation
  /// is ever exposed as one-to-many.
  static int? _resolveRating(dynamic reviews) {
    if (reviews is Map<String, dynamic>) {
      return reviews['rating'] as int?;
    }
    if (reviews is List && reviews.isNotEmpty) {
      return (reviews.first as Map<String, dynamic>)['rating'] as int?;
    }
    return null;
  }

  static String _resolveCustomerName(Map<String, dynamic>? profile) {
    final customerName = profile?['full_name'] as String?;
    if (customerName == null || customerName.trim().isEmpty) {
      return LocaleKeys.unknown_customer.tr();
    }
    return customerName;
  }

  OrderModel copyWith({
    String? id,
    DateTime? createdAt,
    OrderStatus? status,
    String? customerName,
    String? customerEmail,
    String? customerImage,
    num? totalAmount,
    int? itemsCount,
    int? rating,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerImage: customerImage ?? this.customerImage,
      totalAmount: totalAmount ?? this.totalAmount,
      itemsCount: itemsCount ?? this.itemsCount,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object?> get props => [
    id,
    createdAt,
    status,
    customerName,
    customerEmail,
    customerImage,
    totalAmount,
    itemsCount,
    rating,
  ];
}

final List<OrderModel> dummyOrders = [
  OrderModel(
    id: '1aaaaaaa',
    orderNumber: 2,
    createdAt: DateTime.now(),
    status: OrderStatus.pending,
    customerName: 'John Doe',
    customerEmail: '2K9m7@example.com',
    customerImage: null,
    totalAmount: 100,
    itemsCount: 2,
    rating: 5,
  ),
  OrderModel(
    orderNumber: 2,
    id: '111111111',
    createdAt: DateTime.now(),
    status: OrderStatus.pending,
    customerName: 'John Doe',
    customerEmail: '2K9m7@example.com',
    customerImage: null,
    totalAmount: 100,
    itemsCount: 2,
    rating: 3,
  ),
  OrderModel(
    orderNumber: 2,
    id: '111111111',
    createdAt: DateTime.now(),
    status: OrderStatus.pending,
    customerName: 'John Doe',
    customerEmail: '2K9m7@example.com',
    customerImage: null,
    totalAmount: 100,
    itemsCount: 2,
  ),
  OrderModel(
    orderNumber: 2,
    id: '11111111111',
    createdAt: DateTime.now(),
    status: OrderStatus.pending,
    customerName: 'John Doe',
    customerEmail: '2K9m7@example.com',
    customerImage: null,
    totalAmount: 100,
    itemsCount: 2,
  ),
  OrderModel(
    orderNumber: 2,
    id: '11111111',
    createdAt: DateTime.now(),
    status: OrderStatus.pending,
    customerName: 'John Doe',
    customerEmail: '2K9m7@example.com',
    customerImage: null,
    totalAmount: 100,
    itemsCount: 2,
  ),
];
