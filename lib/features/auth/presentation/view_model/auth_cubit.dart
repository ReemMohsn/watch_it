import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:e_learning/core/constants/app_strings.dart';
import 'package:e_learning/core/services/errors/failure.dart';
import 'package:e_learning/features/auth/data/models/auth_account.dart';
import 'package:e_learning/features/auth/data/repositories/auth_repository.dart';
import 'package:e_learning/features/auth/presentation/view_model/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(AuthInitial()) {
    _authSubscription = _repository.authChanges.listen(
      (response) => response.fold(_onAuthFailure, _onAuthChanged),
    );
    _callbackSubscription = _repository.authCallbacks.listen(
      (response) => response.fold(_onAuthFailure, _queueAuthCallback),
    );
  }

  final AuthRepository _repository;
  late final StreamSubscription<Either<Failure, AuthChangeEvent>>
  _authSubscription;
  late final StreamSubscription<Either<Failure, Uri>> _callbackSubscription;
  final Set<Uri> _handledCallbacks = {};
  Future<void> _callbackQueue = Future<void>.value();

  AuthAccount? get currentAccount => _repository.currentAccount;

  bool get isBusy =>
      state is AuthCallbackLoading ||
      state is LoginLoading ||
      state is SignOutLoading ||
      state is ForgotPasswordLoading ||
      state is ResetPasswordLoading;

  void _onAuthChanged(AuthChangeEvent event) {
    if (isClosed) return;
    if (event == AuthChangeEvent.passwordRecovery) {
      // Native callbacks are completed by _processAuthCallback below.
      if (_repository.handlesAuthCallbacks) return;
      emit(PasswordRecoveryRequired());
    } else if (!isBusy &&
        (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.signedOut ||
            event == AuthChangeEvent.initialSession)) {
      emit(AuthSessionChanged());
    }
  }

  void _onAuthFailure(Failure failure) {
    if (isClosed || isBusy) return;
    emit(AuthSessionFailure(errorMessage: failure.message));
  }

  void _queueAuthCallback(Uri uri) {
    if (isClosed || !_repository.isAuthCallback(uri)) return;
    if (!_handledCallbacks.add(uri)) return;
    // A link can be delivered more than once while the app is opening.
    _callbackQueue = _callbackQueue.then((_) => _processAuthCallback(uri));
  }

  Future<void> _processAuthCallback(Uri uri) async {
    if (isClosed) return;
    emit(AuthCallbackLoading());
    final response = await _repository.handleAuthCallback(uri);
    if (isClosed) return;
    response.fold(
      (failure) => emit(
        AuthSessionFailure(
          errorMessage:
              failure.message ==
                  AppStrings.unableToCompleteAuthenticationPleaseTryAgain
              ? AppStrings.unableToRecoverPassword
              : failure.message,
        ),
      ),
      (event) {
        if (event == AuthChangeEvent.passwordRecovery) {
          emit(PasswordRecoveryRequired());
        } else {
          emit(AuthSessionChanged());
        }
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    if (isClosed || isBusy) return;
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
    if (isClosed || isBusy) return;
    emit(SignOutLoading());
    final response = await _repository.signOut();
    if (isClosed) return;
    response.fold(
      (failure) => emit(SignOutFailure(errorMessage: failure.message)),
      (_) => emit(SignOutSuccess(message: AppStrings.loggedOutSuccessfully)),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (isClosed || isBusy) return;
    emit(ForgotPasswordLoading());
    final response = await _repository.sendPasswordResetEmail(email);
    if (isClosed) return;
    response.fold(
      (failure) => emit(ForgotPasswordFailure(errorMessage: failure.message)),
      (_) => emit(
        ForgotPasswordSuccess(message: AppStrings.passwordResetEmailSent),
      ),
    );
  }

  Future<void> resetPassword(String password) async {
    if (isClosed || isBusy) return;
    emit(ResetPasswordLoading());
    final response = await _repository.resetPassword(password);
    if (isClosed) return;
    response.fold(
      (failure) => emit(ResetPasswordFailure(errorMessage: failure.message)),
      (_) => emit(
        ResetPasswordSuccess(message: AppStrings.passwordResetSuccessfully),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _callbackSubscription.cancel();
    await _authSubscription.cancel();
    return super.close();
  }
}
