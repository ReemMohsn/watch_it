import 'package:dartz/dartz.dart';
import 'package:e_learning/core/services/errors/failure.dart';
import 'package:e_learning/core/services/request_handler.dart';
import 'package:e_learning/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:e_learning/features/auth/data/models/auth_account.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  const AuthRepository(this._remote);

  final AuthRemoteDataSource _remote;

  Stream<Either<Failure, AuthChangeEvent>> get authChanges =>
      requestStreamHandler(_remote.authChanges);

  Stream<Either<Failure, Uri>> get authCallbacks =>
      requestStreamHandler(_remote.authCallbacks);

  bool get handlesAuthCallbacks => _remote.handlesAuthCallbacks;

  bool isAuthCallback(Uri uri) => _remote.isAuthCallback(uri);

  Future<Either<Failure, AuthChangeEvent>> handleAuthCallback(Uri uri) =>
      requestHandler(() => _remote.handleAuthCallback(uri));

  Future<Either<Failure, AuthAccount>> signIn({
    required String email,
    required String password,
  }) => requestHandler(() => _remote.signIn(email: email, password: password));

  AuthAccount? get currentAccount => _remote.currentAccount;

  Future<Either<Failure, void>> signOut() => requestHandler(_remote.signOut);

  Future<Either<Failure, void>> sendPasswordResetEmail(String email) =>
      requestHandler(() => _remote.sendPasswordResetEmail(email));

  Future<Either<Failure, void>> resetPassword(String password) =>
      requestHandler(() => _remote.resetPassword(password));
}
