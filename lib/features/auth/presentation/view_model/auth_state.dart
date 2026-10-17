import 'package:e_learning/features/auth/data/models/auth_account.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

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
