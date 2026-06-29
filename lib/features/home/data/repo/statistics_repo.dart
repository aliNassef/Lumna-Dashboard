import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
import '../datasource/statistics_remote_datasource.dart';
import '../models/dashboard_data_model.dart'; 

abstract interface class StatisticsRepo {
  Future<Either<Failure, DashboardStatsModel>> getDashboardSummary();
}

class StatisticsRepoImpl implements StatisticsRepo {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DashboardStatsModel>> getDashboardSummary() async {
    try {
      final summary = await _remoteDataSource.getDashboardSummary();
      return Right(summary);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
