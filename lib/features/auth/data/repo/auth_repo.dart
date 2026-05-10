import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/failure.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/signup_request.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, void>> signIn(String email, String password);
  Future<Either<Failure, void>> signUp(SignupRequest request);
  Future<Either<Failure, void>> signOut();
  User? getCurrentUser();
}

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);
  @override
  User? getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<Either<Failure, void>> signIn(String email, String password) async {
    try {
      await _remoteDataSource.signIn(email, password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signUp(SignupRequest request) async {
    try {
      await _remoteDataSource.signUp(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.message));
    }
  }
}
