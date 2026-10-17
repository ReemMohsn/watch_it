import 'package:dartz/dartz.dart';
import 'package:e_learning/core/services/errors/failure.dart';
import 'package:e_learning/core/services/request_handler.dart';
import 'package:e_learning/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:e_learning/features/auth/data/models/auth_account.dart';

class AuthRepository {
  const AuthRepository(this._remote);

  final AuthRemoteDataSource _remote;

  Future<Either<Failure, AuthAccount>> signIn({
    required String email,
    required String password,
  }) => requestHandler(() => _remote.signIn(email: email, password: password));

  AuthAccount? get currentAccount => _remote.currentAccount;

  Future<Either<Failure, void>> signOut() => requestHandler(_remote.signOut);
}
