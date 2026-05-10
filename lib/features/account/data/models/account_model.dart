import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String role;

  const AccountModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.avatarUrl,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      role: map['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }

  AccountModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? role,
  }) {
    return AccountModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, avatarUrl, role];
}

final dummyAccount = const AccountModel(
  id: '444444',
  fullName: 'Ali Nassef',
  email: 'anassef798@gmail.com',
  role: 'admin',
);
