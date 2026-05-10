import 'package:equatable/equatable.dart';

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

  const OrderModel({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.customerName,
    required this.customerEmail,
    required this.customerImage,
    required this.totalAmount,
    required this.itemsCount,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;
    final orderItems = map['order_items'] as List<dynamic>?;
    final rawStatus = (map['status'] as String? ?? '').trim().toLowerCase();

    return OrderModel(
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
    );
  }

  static String _resolveCustomerName(Map<String, dynamic>? profile) {
    final customerName = profile?['full_name'] as String?;
    if (customerName == null || customerName.trim().isEmpty) {
      return 'Unknown Customer';
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
  }) {
    return OrderModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerImage: customerImage ?? this.customerImage,
      totalAmount: totalAmount ?? this.totalAmount,
      itemsCount: itemsCount ?? this.itemsCount,
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
  ];
}

final List<OrderModel> dummyOrders = [
  OrderModel(
    id: '1aaaaaaa',
    createdAt: DateTime.now(),
    status: OrderStatus.pending,
    customerName: 'John Doe',
    customerEmail: '2K9m7@example.com',
    customerImage: null,
    totalAmount: 100,
    itemsCount: 2,
  ),
  OrderModel(
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
