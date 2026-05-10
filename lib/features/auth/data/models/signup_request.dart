import 'package:equatable/equatable.dart';

class SignupRequest extends Equatable {
  final String email;
  final String password;
  final String fullName;

  const SignupRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'role': 'admin',
    };
  }

  @override
  List<Object?> get props => [email, password, fullName];
}
