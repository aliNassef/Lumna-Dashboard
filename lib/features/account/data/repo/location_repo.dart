import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
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
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
