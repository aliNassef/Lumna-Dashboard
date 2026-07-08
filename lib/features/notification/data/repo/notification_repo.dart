import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
import '../datasource/notification_remote_datasource.dart';
import '../models/notification_model.dart';
import '../models/send_notification_request.dart';

abstract interface class NotificationRepo {
  Future<Either<Failure, void>> sendNotification(
    SendNotificationRequest request,
  );
  Future<Either<Failure, List<NotificationModel>>> fetchNotificationHistory();
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Future<Either<Failure, int>> getUnReadedCount();
}

class NotificationRepoImpl implements NotificationRepo {
  NotificationRepoImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> sendNotification(
    SendNotificationRequest request,
  ) async {
    try {
      await _remoteDataSource.sendNotification(request);
      return const Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationModel>>>
  fetchNotificationHistory() async {
    try {
      final notifications = await _remoteDataSource.fetchNotificationHistory();
      return Right(notifications);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
  
  @override
  Future<Either<Failure, int>> getUnReadedCount()async {
    try {
      final count = await _remoteDataSource.getUnReadedCount();
      return Right(count);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
