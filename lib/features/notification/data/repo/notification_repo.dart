import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../datasource/notification_remote_datasource.dart';
import '../models/send_notification_request.dart';

abstract interface class NotificationRepo {
  Future<Either<Failure, void>> sendNotification(
    SendNotificationRequest request,
  );
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
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }
}
