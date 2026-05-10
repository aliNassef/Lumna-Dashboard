import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../datasource/account_remote_datasource.dart';
import '../models/account_model.dart';

abstract interface class AccountRepo {
  Future<Either<Failure, AccountModel>> getCurrentProfile();
  Future<Either<Failure, void>> updateProfile(AccountModel profile);
}

class AccountRepoImpl implements AccountRepo {
  final AccountRemoteDataSource _remoteDataSource;

  AccountRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AccountModel>> getCurrentProfile() async {
    try {
      final profile = await _remoteDataSource.getCurrentProfile();
      return Right(profile);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(AccountModel profile) async {
    try {
      await _remoteDataSource.updateProfile(profile);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }
}
