import 'package:e_learning/features/auth/data/models/auth_account.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthCallbackLoading extends AuthState {}

class AuthSessionChanged extends AuthState {}

class AuthSessionFailure extends AuthState {
  AuthSessionFailure({required this.errorMessage});

  final String errorMessage;
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  LoginSuccess({required this.account, required this.message});

  final AuthAccount account;
  final String message;
}

class LoginFailure extends AuthState {
  LoginFailure({required this.errorMessage});

  final String errorMessage;
}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {
  SignOutSuccess({required this.message});

  final String message;
}

class SignOutFailure extends AuthState {
  SignOutFailure({required this.errorMessage});

  final String errorMessage;
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  ForgotPasswordSuccess({required this.message});

  final String message;
}

class ForgotPasswordFailure extends AuthState {
  ForgotPasswordFailure({required this.errorMessage});

  final String errorMessage;
}

class PasswordRecoveryRequired extends AuthState {}

class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  ResetPasswordSuccess({required this.message});

  final String message;
}

class ResetPasswordFailure extends AuthState {
  ResetPasswordFailure({required this.errorMessage});

  final String errorMessage;
}
