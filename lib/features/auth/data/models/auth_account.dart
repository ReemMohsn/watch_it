import 'package:supabase_flutter/supabase_flutter.dart';

class AuthAccount {
  const AuthAccount({
    required this.id,
    required this.email,
    required this.fullName,
  });

  final String id;
  final String email;
  final String fullName;

  factory AuthAccount.fromUser(User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    return AuthAccount(
      id: user.id,
      email: user.email ?? '',
      fullName: (metadata['full_name'] ?? metadata['name'] ?? '').toString(),
    );
  }
}
