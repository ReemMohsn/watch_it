import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/services/errors/app_exception.dart';
import 'package:e_learning/features/auth/data/models/auth_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final SupabaseClient? _client;

  Future<AuthAccount> signIn({
    required String email,
    required String password,
  }) async {
    final client = _requireClient();
    final response = await client.auth
        .signInWithPassword(email: email.trim(), password: password)
        .timeout(const Duration(seconds: 20));
    final user = response.user;
    if (user == null || response.session == null) {
      throw const AuthException(
        AppStrings.noSessionReturned,
        code: 'session_not_found',
      );
    }
    return AuthAccount.fromUser(user);
  }

  AuthAccount? get currentAccount {
    final user = _client?.auth.currentUser;
    if (user == null) return null;
    return AuthAccount.fromUser(user);
  }

  Future<void> signOut() async {
    await _requireClient().auth.signOut(scope: SignOutScope.local);
  }

  SupabaseClient _requireClient() {
    final client = _client;
    if (client == null) {
      throw const AppException(
        message: AppStrings.supabaseNotConfigured,
        code: 'supabase_not_configured',
      );
    }
    return client;
  }
}
