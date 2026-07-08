import 'auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../exceptions/error_mapper.dart';
import '../../exceptions/server_exception.dart';

class SupabaseAuthImpl implements AuthService {
  final SupabaseClient _supabase;

  SupabaseAuthImpl({required SupabaseClient supabase}) : _supabase = supabase;
  @override
  Future<AuthResponse> createUserWithEmailAndPassword(
    String email,
    String password,
    Map<String, dynamic>? data,
  ) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      return await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.ecommerce://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await _supabase.auth.signOut();
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      return await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.ecommerce://reset-callback',
      );
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Future<void> updatePassword(String password) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: password),
      );
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }
}
