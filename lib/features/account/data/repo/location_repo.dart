import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../datasource/location_remote_datasource.dart';
import '../models/location_model.dart';

abstract class LocationRepo {
  Future<Either<Failure, void>> addStoreLocation(LocationModel location);
}

class LocationRepoImpl implements LocationRepo {
  LocationRepoImpl(this._locationRemoteDataSource);

  final LocationRemoteDataSource _locationRemoteDataSource;

  @override
  Future<Either<Failure, void>> addStoreLocation(LocationModel location) async {
    try {
      await _locationRemoteDataSource.addStoreLocation(location);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }
}
