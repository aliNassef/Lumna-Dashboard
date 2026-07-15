import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/extensions/order_status.dart';
import '../models/order_details_model.dart';
import '../models/order_model.dart';
import '../models/recent_order_model.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class OrdersRemoteDataSource {
  Future<List<RecentOrderModel>> getRecentOrders();
  Stream<List<OrderModel>> getOrders();
  Future<OrderDetailsModel> getOrderDetails(String orderId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final Database _database;

  OrdersRemoteDataSourceImpl(this._database);

  @override
  Future<List<RecentOrderModel>> getRecentOrders() async {
    final response = await _database.get(
      path: Endpoints.orders,
      columns:
          'id, order_no, created_at, status, profiles(full_name, avatar_url)',
      orderBy: 'created_at',
      ascending: false,
      limit: 5,
    );
    final recentOrders = response
        .map((e) => RecentOrderModel.fromMap(e))
        .toList();
    return recentOrders;
  }

  @override
  Stream<List<OrderModel>> getOrders() {
    return Rx.merge<List<Map<String, dynamic>>>([
      _database.stream(
        path: Endpoints.orders,
        primaryKey: ['id'],
      ),
      _database.stream(
        path: Endpoints.orderItems,
        primaryKey: ['id'],
      ),
      _database.stream(
        path: Endpoints.profiles,
        primaryKey: ['id'],
      ),
      _database.stream(
        path: Endpoints.orderReviews,
        primaryKey: ['id'],
      ),
    ]).debounceTime(const Duration(milliseconds: 300)).asyncMap((_) {
      return _fetchOrders();
    });
  }

  Future<List<OrderModel>> _fetchOrders() async {
    final response = await _database.get(
      path: Endpoints.orders,
      columns:
          'id, order_no, created_at, status, total_amount, profiles(full_name, email, avatar_url), order_items(id), order_reviews(user_id, rating)',
      orderBy: 'created_at',
      ascending: false,
    );

    return response.map(OrderModel.fromMap).toList();
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(String orderId) async {
    final response = await _database.get(
      path: Endpoints.orders,
      columns:
          'id, order_no, user_id, created_at, status, total_amount, payment_method, profiles(full_name, email, avatar_url), addresses!orders_address_id_fkey(*), order_items(id,quantity,unit_price,product_name,products(name, price, images))',
      filterColumn: 'id',
      filterValue: orderId,
    );

    if (response.isEmpty) {
      throw const ServerException('Order not found');
    }

    final orderMap = Map<String, dynamic>.from(response.first);
    final hasAddress = _hasAddressData(orderMap['addresses']);

    if (!hasAddress) {
      final userId = orderMap['user_id']?.toString();
      if (userId != null && userId.isNotEmpty) {
        final addresses = await _database.get(
          path: Endpoints.addresses,
          columns:
              'id, label, street, city, state, zip, country, is_default, created_at, phone',
          filterColumn: 'user_id',
          filterValue: userId,
        );

        if (addresses.isNotEmpty) {
          addresses.sort((a, b) {
            final aDefault = a['is_default'] == true ? 1 : 0;
            final bDefault = b['is_default'] == true ? 1 : 0;
            return bDefault.compareTo(aDefault);
          });
          orderMap['addresses'] = addresses.first;
        }
      }
    }

    return OrderDetailsModel.fromMap(orderMap);
  }

  bool _hasAddressData(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.isNotEmpty;
    }

    if (value is List) {
      return value.isNotEmpty;
    }

    return false;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) {
    return _database.update(
      path: Endpoints.orders,
      id: orderId,
      data: {'status': status.name},
    );
  }
}
