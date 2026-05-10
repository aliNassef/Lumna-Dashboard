import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthService {
  Future<AuthResponse> createUserWithEmailAndPassword(
    String email,
    String password,
    Map<String, dynamic>? data,
  );

  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<bool> signInWithGoogle();
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String password);
  Future<void> signOut();
  User? get currentUser;
}
