import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';
import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/services/auth/auth_service.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../models/signup_request.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> signIn(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signUp(SignupRequest request);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String password);
  Future<bool> isCurrentUserAdmin();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;
  final Database _database;

  AuthRemoteDataSourceImpl({
    required AuthService authService,
    required Database database,
  }) : _authService = authService,
       _database = database;
  @override
  Future<void> signIn(String email, String password) async {
    try {
      final response = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (response.user == null) {
        throw ServerException(LocaleKeys.error_invalid_credentials.tr());
      }
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final isSignedIn = await _authService.signInWithGoogle();
      if (!isSignedIn) {
        throw ServerException(LocaleKeys.error_generic.tr());
      }
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> signUp(SignupRequest request) async {
    try {
      final response = await _authService.createUserWithEmailAndPassword(
        request.email,
        request.password,
        request.toMap(),
      );
      if (response.user == null) {
        throw ServerException(LocaleKeys.error_generic.tr());
      }
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    try {
      await _authService.updatePassword(password);
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<bool> isCurrentUserAdmin() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return false;

      final rows = await _database.get(
        path: Endpoints.profiles,
        filterColumn: 'id',
        filterValue: user.id,
        limit: 1,
      );
      if (rows.isEmpty) return false;

      return rows.first['role'] == 'admin';
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  User? getCurrentUser() {
    return _authService.currentUser;
  }
}
