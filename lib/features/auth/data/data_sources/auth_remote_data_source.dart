import 'package:app_links/app_links.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/services/errors/app_exception.dart';
import 'package:e_learning/features/auth/data/models/auth_account.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._client);

  final SupabaseClient? _client;

  bool get handlesAuthCallbacks => !kIsWeb;

  Stream<Uri> get authCallbacks => handlesAuthCallbacks
      ? AppLinks().uriLinkStream
      : const Stream<Uri>.empty();

  bool isAuthCallback(Uri uri) =>
      uri.scheme == 'tafrah-science' && uri.host == 'auth-callback';

  Stream<AuthChangeEvent> get authChanges =>
      _client?.auth.onAuthStateChange.map((state) => state.event) ??
      const Stream<AuthChangeEvent>.empty();

  Future<AuthChangeEvent> handleAuthCallback(Uri uri) async {
    final response = await _requireClient().auth
        .getSessionFromUrl(uri)
        .timeout(const Duration(seconds: 20));
    final recovery =
        response.redirectType == 'recovery' ||
        response.redirectType == AuthChangeEvent.passwordRecovery.name;
    return recovery
        ? AuthChangeEvent.passwordRecovery
        : AuthChangeEvent.signedIn;
  }

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

  Future<void> sendPasswordResetEmail(String email) async {
    await _requireClient().auth
        .resetPasswordForEmail(
          email.trim(),
          redirectTo: kIsWeb
              ? Uri.base.replace(query: '', fragment: '').toString()
              : 'tafrah-science://auth-callback/',
        )
        .timeout(const Duration(seconds: 20));
  }

  Future<void> resetPassword(String password) async {
    final client = _requireClient();
    if (client.auth.currentSession == null) {
      throw const AuthException(
        AppStrings.theVerificationLinkOrCodeHasExpiredRequestANewOne,
        code: 'otp_expired',
      );
    }
    await client.auth
        .updateUser(UserAttributes(password: password))
        .timeout(const Duration(seconds: 20));
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
