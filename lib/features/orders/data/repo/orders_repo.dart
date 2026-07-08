import 'package:dartz/dartz.dart';
import '../datasource/orders_remote_datasource.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/extensions/order_status.dart';
import '../models/order_details_model.dart';
import '../models/order_model.dart';
import '../models/recent_order_model.dart';

abstract interface class OrdersRepo {
  Future<Either<Failure, List<RecentOrderModel>>> getRecentOrders();
  Stream<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, OrderDetailsModel>> getOrderDetails(String orderId);
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  );
}

class OrdersRepoImpl implements OrdersRepo {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<RecentOrderModel>>> getRecentOrders() async {
    try {
      final orders = await _remoteDataSource.getRecentOrders();
      return Right(orders);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }

  @override
  Stream<Either<Failure, List<OrderModel>>> getOrders() async* {
    try {
      await for (final orders in _remoteDataSource.getOrders()) {
        yield Right(orders);
      }
    } catch (e) {
      yield Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderDetailsModel>> getOrderDetails(
    String orderId,
  ) async {
    try {
      final order = await _remoteDataSource.getOrderDetails(orderId);
      return Right(order);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      await _remoteDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }
}
