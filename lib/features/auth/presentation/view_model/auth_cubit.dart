import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/features/auth/data/models/auth_account.dart';
import 'package:e_learning/features/auth/data/repositories/auth_repository.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthInitial());

  final AuthRepository _repository;

  AuthAccount? get currentAccount => _repository.currentAccount;

  Future<void> signIn({required String email, required String password}) async {
    if (isClosed || state is LoginLoading) return;
    emit(LoginLoading());
    final response = await _repository.signIn(email: email, password: password);
    if (isClosed) return;
    response.fold(
      (failure) => emit(LoginFailure(errorMessage: failure.message)),
      (account) => emit(
        LoginSuccess(
          account: account,
          message: AppStrings.loggedInSuccessfully,
        ),
      ),
    );
  }

  Future<void> signOut() async {
    if (isClosed || state is SignOutLoading) return;
    emit(SignOutLoading());
    final response = await _repository.signOut();
    if (isClosed) return;
    response.fold(
      (failure) => emit(SignOutFailure(errorMessage: failure.message)),
      (_) => emit(SignOutSuccess(message: AppStrings.loggedOutSuccessfully)),
    );
  }
}
