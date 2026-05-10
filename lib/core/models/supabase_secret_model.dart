class SupabaseSecretModel {
  final String? url;
  final String? anonKey;

  SupabaseSecretModel({required this.url, required this.anonKey});

  factory SupabaseSecretModel.fromMap(Map<String, dynamic> map) {
    return SupabaseSecretModel(
      url: map['URL'],
      anonKey: map['ANON_KEY'],
    );
  }
}
