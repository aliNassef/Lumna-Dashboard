import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
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
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(AccountModel profile) async {
    try {
      await _remoteDataSource.updateProfile(profile);
      return const Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
