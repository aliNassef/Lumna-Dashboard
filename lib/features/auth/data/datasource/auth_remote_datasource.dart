import '../../../../core/services/auth/auth_service.dart';
import '../models/signup_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/server_exception.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> signIn(String email, String password);
  Future<void> signUp(SignupRequest request);
  Future<void> signOut();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSourceImpl({required AuthService authService})
    : _authService = authService;
  @override
  Future<void> signIn(String email, String password) async {
    final response = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );
    if (response.user == null) {
      throw const ServerException('Failed to sign in');
    }
  }

  @override
  Future<void> signUp(SignupRequest request) async {
    final response = await _authService.createUserWithEmailAndPassword(
      request.email,
      request.password,
      request.toMap(),
    );
    if (response.user == null) {
      throw const ServerException('Failed to sign up');
    }
  }

  @override
  Future<void> signOut() async => _authService.signOut();

  @override
  User? getCurrentUser() {
    return _authService.currentUser;
  }
}
