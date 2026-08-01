import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/signup_request.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, Unit>> signIn(String email, String password);
  Future<Either<Failure, Unit>> signInWithGoogle();
  Future<Either<Failure, Unit>> signUp(SignupRequest request);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, bool>> isCurrentUserAdmin();
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
  Future<Either<Failure, Unit>> signIn(String email, String password) async {
    try {
      await _remoteDataSource.signIn(email, password);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithGoogle() async {
    try {
      await _remoteDataSource.signInWithGoogle();
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, bool>> isCurrentUserAdmin() async {
    try {
      final isAdmin = await _remoteDataSource.isCurrentUserAdmin();
      return Right(isAdmin);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp(SignupRequest request) async {
    try {
      await _remoteDataSource.signUp(request);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
