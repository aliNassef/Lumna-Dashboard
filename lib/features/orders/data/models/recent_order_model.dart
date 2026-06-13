import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/extensions/order_status.dart';

class RecentOrderModel extends Equatable {
  final String id;
  final String customerName;
  final String? customerImage;
  final DateTime date;
  final OrderStatus status;

  const RecentOrderModel({
    required this.id,
    required this.customerName,
    this.customerImage,
    required this.date,
    required this.status,
  });

  factory RecentOrderModel.fromMap(Map<String, dynamic> map) {
    final profile = map['profiles'] as Map<String, dynamic>?;
    final customerName = profile?['full_name'] as String?;
    final customerImage = profile?['avatar_url'] as String?;

    return RecentOrderModel(
      id: map['id'],
      customerName: customerName == null || customerName.trim().isEmpty
          ? LocaleKeys.unknown_customer.tr()
          : customerName,
      customerImage: customerImage,
      date: DateTime.parse(map['created_at']),
      status: OrderStatus.values.byName(map['status']),
    );
  }

  @override
  List<Object?> get props => [id];
}

final List<RecentOrderModel> dummyRecentOrders = [
  RecentOrderModel(
    id: 'ORD-001',
    customerName: 'Ahmed Mansour',
    customerImage: 'https://randomuser.me/api/portraits/men/1.jpg',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    status: OrderStatus.pending,
  ),
  RecentOrderModel(
    id: 'ORD-002',
    customerName: 'Sara Mahmoud',
    customerImage: 'https://randomuser.me/api/portraits/women/2.jpg',
    date: DateTime.now().subtract(const Duration(hours: 5)),
    status: OrderStatus.processing,
  ),
  RecentOrderModel(
    id: 'ORD-003',
    customerName: 'Mostafa Youssef',
    customerImage: null,
    date: DateTime.now().subtract(const Duration(days: 1)),
    status: OrderStatus.processing,
  ),
  RecentOrderModel(
    id: 'ORD-004',
    customerName: 'Nour El-Din',
    customerImage: 'https://randomuser.me/api/portraits/men/4.jpg',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    status: OrderStatus.shipped,
  ),
  RecentOrderModel(
    id: 'ORD-005',
    customerName: 'Laila Hany',
    customerImage: 'https://randomuser.me/api/portraits/women/5.jpg',
    date: DateTime.now().subtract(const Duration(days: 2)),
    status: OrderStatus.delivered,
  ),
  RecentOrderModel(
    id: 'ORD-006',
    customerName: 'Omar Samir',
    customerImage: null,
    date: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
    status: OrderStatus.cancelled,
  ),
  RecentOrderModel(
    id: 'ORD-007',
    customerName: 'Mariam Ahmed',
    customerImage: 'https://randomuser.me/api/portraits/women/7.jpg',
    date: DateTime.now().subtract(const Duration(days: 3)),
    status: OrderStatus.refunded,
  ),
  RecentOrderModel(
    id: 'ORD-008',
    customerName: 'Khaled Tamer',
    customerImage: 'https://randomuser.me/api/portraits/men/8.jpg',
    date: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
    status: OrderStatus.pending,
  ),
];
